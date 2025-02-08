import io
import re
import requests
import base64
import os
import torch
from datetime import datetime
from PIL import Image, ImageEnhance
from fastapi import APIRouter, File, UploadFile, HTTPException
from torchvision import transforms
from dotenv import load_dotenv
from model_architecture import Model  
router = APIRouter()

# Load environment variables
load_dotenv()

GOOGLE_CLOUD_VISION_API_KEY = "AIzaSyAlilJKsjPq1Ge8SECX9aF0GIvabosLvv4"
if not GOOGLE_CLOUD_VISION_API_KEY:
    raise ValueError("Missing Google Cloud Vision API Key in environment variables.")

# Paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_DIR = os.path.join(BASE_DIR, "models")
MODEL_PATH = os.path.join(MODEL_DIR, "fresh_stale_model.pth")

# Ensure model directory exists
if not os.path.exists(MODEL_DIR):
    os.makedirs(MODEL_DIR)

if not os.path.exists(MODEL_PATH):
    raise HTTPException(status_code=500, detail="Model file not found. Please upload fresh_stale_model.pth.")

# ================== MODEL: Fresh vs Rotten Classifier ==================
# Load trained model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = Model()
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.to(device)
model.eval()

# Image preprocessing for classification
classification_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

labels_freshness = ["Fresh", "Rotten"]

# ================== FUNCTION: Classify Freshness ==================
def classify_freshness(image_bytes):
    """Classifies whether the food is fresh or rotten"""
    try:
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        image = classification_transform(image).unsqueeze(0).to(device)

        with torch.no_grad():
            output = model(image)

            # If output is a tuple, extract the first element (logits)
            if isinstance(output, tuple):
                output = output[0]

            probabilities = torch.nn.functional.softmax(output, dim=1)
            confidence, predicted = torch.max(probabilities, 1)

            return labels_freshness[predicted.item()], confidence.item()
    except Exception as e:
        return f"Error in classification: {str(e)}", 0.0

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
            return result["responses"][0]["fullTextAnnotation"]["text"]

        return None  # Return None if no text is detected
    except requests.RequestException as e:
        return f"Error in Google OCR API: {str(e)}"
    except Exception as e:
        return f"Unexpected error during OCR: {str(e)}"

# ================== FUNCTION: Extract & Format Expiry Date ==================
def extract_expiry_date(text):
    """Extract expiry date while avoiding 'PKD' (Packaged Date) entries."""
    if not text or not isinstance(text, str):
        return None  # Return None if input is invalid

    date_patterns = [
        r"(?i)(?:USE BY|EXP(?:IRES)?|BEST BEFORE|EXPIRES)[\s:]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})",
        r"(?<!PKD)(?<!\w)(\d{1,2}[/-]\d{1,2}[/-]\d{4})(?!\w)(?!.*PKD)",
        r"(?<!PKD)(?<!\w)(\d{4}-\d{2}-\d{2})(?!\w)(?!.*PKD)"
    ]

    for pattern in date_patterns:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return format_expiry_date(match.group(1))  # Standardize format

    return None

def format_expiry_date(date_str):
    """Standardize expiry date format to YYYY-MM-DD"""
    for fmt in ("%d/%m/%Y", "%d-%m-%Y", "%m/%d/%Y", "%m-%d-%Y", "%Y-%m-%d"):
        try:
            return datetime.strptime(date_str, fmt).strftime("%Y-%m-%d")
        except ValueError:
            continue
    return date_str  # Return as-is if parsing fails

# ================== API Endpoint: Detect Freshness & Expiry ==================
@router.post("/analyze-food/")
async def analyze_food(file: UploadFile = File(...)):
    """API Endpoint to detect expiry date and classify fresh vs rotten"""
    try:
        image_bytes = await file.read()

        # ===== Step 1: Detect Expiry Date using Google OCR =====
        image_for_ocr = Image.open(io.BytesIO(image_bytes)).convert("RGB")  # Keep RGB format
        enhancer = ImageEnhance.Contrast(image_for_ocr)
        image_for_ocr = enhancer.enhance(2)  # Increase contrast

        # Convert enhanced image to bytes for OCR
        image_io = io.BytesIO()
        image_for_ocr.save(image_io, format="PNG")
        processed_image_bytes = image_io.getvalue()

        extracted_text = google_ocr(processed_image_bytes)

        expiry_date = extract_expiry_date(extracted_text) if extracted_text and not extracted_text.startswith("Error") else None

        if expiry_date:
            return {
                "type": "Packaged Product",
                "expiry_date": expiry_date,
                "full_text": extracted_text or "No text detected",
                "message": "Expiry date detected."
            }

        # ===== Step 2: If expiry date is not found, classify freshness =====
        freshness_result, confidence_score = classify_freshness(image_bytes)

        return {
            "type": "Fresh Produce",
            "freshness": freshness_result,
            "confidence_score": confidence_score,
            "message": f"The product appears to be {freshness_result}."
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Server Error: {str(e)}")
