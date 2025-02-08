import os
from fastapi import APIRouter, HTTPException
from dotenv import load_dotenv
from os import environ as env
from google.generativeai import configure, GenerativeModel
from pydantic import BaseModel

class ChatRequest(BaseModel):
    message: str
# Load environment variables
load_dotenv()

# Initialize FastAPI Router
router = APIRouter()

# Get API key from environment
GEMINI_API_KEY = "AIzaSyATo_VGl0FUVWZAi3yYCKsRleyJIfy0M78"
if not GEMINI_API_KEY:
    raise ValueError("Missing Google Gemini API Key in .env file.")

# Initialize Gemini Client
configure(api_key=GEMINI_API_KEY)
model = GenerativeModel("gemini-1.5-flash")

# Define the app context to guide the chatbot
APP_CONTEXT = """
Sharewell is a donation-based app where users can act as donors, receivers, or volunteers. 
- Donors create accounts, list donation posts with item details (food, clothes, etc.), and choose to donate for free or set a minimum price.
- Receivers create accounts, search for nearby donations, and contact donors to claim items.
- Volunteers pick up donations from donors and deliver them to receivers. Receivers can track the volunteer's route in real-time.
- Donors earn reward points and receive a quarterly donation certificate.
- The app features an expiry date scanner that alerts users about near-expiry food items.
Users can ask about how to donate, find donations, track deliveries, earn rewards, and more.
"""

@router.post("/chat/")
async def chat_with_gemini(request: ChatRequest):
    """
    Handles chatbot interactions based on the Sharewell app context.
    """
    prompt= f"App Context: {APP_CONTEXT}\nUser Query: {request.message}"
    try:
        response = model.generate_content(prompt)
        chatbot_response = "".join(chunk.text for chunk in response)
        return {"response": chatbot_response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Chatbot error: {str(e)}")
