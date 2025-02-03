import io
import re
import requests
import base64
from PIL import Image, ImageEnhance
from fastapi import APIRouter, File, UploadFile
import os
from dotenv import load_dotenv

router = APIRouter()
load_dotenv()

# Replace with your Google Cloud Vision API key
GOOGLE_CLOUD_VISION_API_KEY = os.getenv("API_KEY")

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

        print("Full API Response:", result)  # Debugging log

        if "responses" in result and result["responses"][0].get("fullTextAnnotation"):
            extracted_text = result["responses"][0]["fullTextAnnotation"]["text"]
            return extracted_text

        return "No text detected"
    except Exception as e:
        return f"Error during OCR: {str(e)}"

def extract_expiry_date(text):
    """
    Extract expiry date from text, avoiding 'PKD' and prioritizing specific expiry indicators.
    """
    # Improved regex patterns to prioritize expiry-related keywords and avoid 'PKD'
    date_patterns = [
        # Prioritize explicit expiry keywords with strong context
        r"(?i)(?:USE BY|EXP(?:IRES)?|BEST BEFORE|EXPIRES)[\s:]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})",
        
        # Avoid dates immediately following 'PKD' or within 'PKD' context using negative lookbehind/lookahead
        r"(?<!PKD)(?<!\w)(\d{1,2}[/-]\d{1,2}[/-]\d{4})(?!\w)(?!.*PKD)",
        
        # ISO date format with additional context checks to avoid 'PKD'
        r"(?<!PKD)(?<!\w)(\d{4}-\d{2}-\d{2})(?!\w)(?!.*PKD)"
    ]

    for pattern in date_patterns:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(1)  # Extract only the date portion

    return "No expiry date found"

@router.post("/detect-expiry/")
async def detect_expiry(file: UploadFile = File(...)):
    """API Endpoint to detect expiry date from an image."""
    image_bytes = await file.read()

    # Convert image to grayscale & enhance contrast
    image = Image.open(io.BytesIO(image_bytes))
    image = image.convert("L")  # Convert to grayscale
    enhancer = ImageEnhance.Contrast(image)
    image = enhancer.enhance(2)  # Increase contrast

    # Convert back to bytes
    image_io = io.BytesIO()
    image.save(image_io, format="PNG")
    processed_image_bytes = image_io.getvalue()

    extracted_text = google_ocr(processed_image_bytes)

    print("Extracted Text from Image:", extracted_text)  # Debugging log

    expiry_date = extract_expiry_date(extracted_text)

    return {"expiry_date": expiry_date, "full_text": extracted_text}  # Return full text for debugging
