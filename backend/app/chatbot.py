import os
from fastapi import APIRouter, HTTPException
from dotenv import load_dotenv
from os import environ as env
import google.generativeai as genai

# Load environment variables
load_dotenv()

# Initialize FastAPI Router
router = APIRouter()

# Get API key from environment
GEMINI_API_KEY = "AIzaSyAJyqp5ka6N3OvCrOTHsm724Vn-dKQeA0E"
if not GEMINI_API_KEY:
    raise ValueError("Missing Google Gemini API Key in .env file.")

# Initialize Gemini Client
client = genai.Client(api_key=GEMINI_API_KEY)

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
async def chat_with_gemini(user_message: str):
    """
    Handles chatbot interactions based on the Sharewell app context.
    """
    try:
        # Generate response using Gemini API
        response = client.models.generate_content_stream(
            model="gemini-2.0-flash",
            contents=[f"App Context: {APP_CONTEXT}\nUser Query: {user_message}"]
        )

        # Combine the streamed response into a single string
        chatbot_response = "".join(chunk.text for chunk in response)
        return {"response": chatbot_response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Chatbot error: {str(e)}")
