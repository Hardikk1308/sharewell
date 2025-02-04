import torch
import io
import re
import requests
import base64
import os
import torch.nn as nn
from PIL import Image, ImageEnhance
from fastapi import FastAPI, File, UploadFile
from torchvision import transforms
from dotenv import load_dotenv

load_dotenv()

# Load environment variables
GOOGLE_CLOUD_VISION_API_KEY = os.getenv("API_KEY")

app = FastAPI()

BASE_DIR = os.path.dirname(os.path.abspath(__file__))  
MODEL_DIR = os.path.join(BASE_DIR, "models") 
MODEL_PATH = os.path.join(MODEL_DIR, "fresh_stale_model.pth") 

# ================== MODEL: Fresh vs Rotten Classifier ==================
class FreshRottenClassifier(nn.Module):
    def __init__(self):
        super(FreshRottenClassifier, self).__init__()
        self.model = torch.hub.load('pytorch/vision:v0.10.0', 'resnet18', pretrained=False)
        self.model.fc = nn.Linear(self.model.fc.in_features, 2)  # 2 classes: Fresh, Rotten

    def forward(self, x):
        return self.model(x)

# Load trained model
model = FreshRottenClassifier()
model.load_state_dict(torch.load("fresh_stale_model.pth", map_location=torch.device('cpu')))
model.eval()

# Image preprocessing
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

labels = ["Fresh", "Rotten"]

# ================== FUNCTION: Classify Fresh vs Rotten ==================
def classify_freshness(image_bytes):
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    image = transform(image).unsqueeze(0)

    with torch.no_grad():
        outputs = model(image)
        _, predicted = torch.max(outputs, 1)
        return labels[predicted.item()]

# ================== FUNCTION: Google OCR for Expiry Detection ==================
def google_ocr(image_bytes):
    """Send image to Google Cloud Vision OCR API and extract text."""
    try:
        base64_image = base64.b64encode(image_bytes).decode()

        url = f"https://vision.googleapis.com/v1/images:annotate?key={GOOGLE_CLOUD_VISION_API_KEY}"
        headers = {"Content-Type": "application/json"}

        payload = {
            "requests": [{
                "image": {"content": base64_image},
                "features": [{"type": "DOCUMENT_TEXT_DETECTION"}]
            }]
        }

        response = requests.post(url, json=payload, headers=headers)
        response.raise_for_status()

        result = response.json()

        if "responses" in result and result["responses"][0].get("fullTextAnnotation"):
            extracted_text = result["responses"][0]["fullTextAnnotation"]["text"]
            return extracted_text

        return "No text detected"
    except Exception as e:
        return f"Error during OCR: {str(e)}"

# ================== FUNCTION: Extract Expiry Date ==================
def extract_expiry_date(text):
    """
    Extract expiry date from text, avoiding 'PKD' and prioritizing expiry indicators.
    """
    date_patterns = [
        r"(?i)(?:USE BY|EXP(?:IRES)?|BEST BEFORE|EXPIRES)[\s:]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})",
        r"(?<!PKD)(?<!\w)(\d{1,2}[/-]\d{1,2}[/-]\d{4})(?!\w)(?!.*PKD)",
        r"(?<!PKD)(?<!\w)(\d{4}-\d{2}-\d{2})(?!\w)(?!.*PKD)"
    ]

    for pattern in date_patterns:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(1)

    return "No expiry date found"

# ================== FUNCTION: Estimate Fresh Produce Expiry ==================
def estimate_expiry(freshness):
    """Estimate expiry time for fresh produce."""
    if freshness == "Fresh":
        return "Estimated 5-7 days until expiry"
    elif freshness == "Rotten":
        return "Already expired"
    return "Unknown"

# ================== API Endpoint: Detect Freshness & Expiry ==================
@app.post("/analyze-food/")
async def analyze_food(file: UploadFile = File(...)):
    """API Endpoint to detect expiry date and classify fresh vs rotten"""
    image_bytes = await file.read()

    # ===== 1. Detect Expiry Date using Google OCR =====
    image = Image.open(io.BytesIO(image_bytes))
    image = image.convert("L")  # Convert to grayscale
    enhancer = ImageEnhance.Contrast(image)
    image = enhancer.enhance(2)  # Increase contrast

    # Convert image to bytes
    image_io = io.BytesIO()
    image.save(image_io, format="PNG")
    processed_image_bytes = image_io.getvalue()

    extracted_text = google_ocr(processed_image_bytes)
    expiry_date = extract_expiry_date(extracted_text)

    # If expiry date is found, assume it's a packaged product
    if expiry_date != "No expiry date found":
        return {
            "type": "Packaged Product",
            "expiry_date": expiry_date,
            "full_text": extracted_text
        }

    # ===== 2. Detect Fresh vs Rotten for fresh produce =====
    freshness_result = classify_freshness(image_bytes)
    estimated_expiry = estimate_expiry(freshness_result)

    return {
        "type": "Fresh Produce",
        "freshness": freshness_result,
        "estimated_expiry": estimated_expiry
    }
