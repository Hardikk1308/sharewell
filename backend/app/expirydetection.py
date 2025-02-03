from fastapi import APIRouter, File, UploadFile
import io
from PIL import Image
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

router = APIRouter()

# Load ML model
processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-handwritten")
model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-base-handwritten")

def predict_expiry(image: Image):
    pixel_values = processor(image, return_tensors="pt").pixel_values
    generated_ids = model.generate(pixel_values)
    generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
    return generated_text

@router.post("/ml-detect-expiry/")
async def ml_detect_expiry(file: UploadFile = File(...)):
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes))

    # ML model prediction
    expiry_text = predict_expiry(image)

    return {"expiry_date": expiry_text}
