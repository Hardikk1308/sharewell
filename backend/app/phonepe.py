from fastapi import APIRouter
from pydantic import BaseModel
from phonepe.sdk.pg.payments.v1.payment_client import PhonePePaymentClient
from phonepe.sdk.pg.env import Env
import hashlib
import base64
import requests
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# PhonePe API credentials (set these in your .env file)
MERCHANT_ID = os.getenv("MERCHANT_ID")
SALT_KEY = os.getenv("SALT_KEY")
SALT_INDEX = os.getenv("SALT_INDEX")
env = Env.UAT
BASE_URL = "https://api-preprod.phonepe.com/apis/pg-sandbox/v1/pay"  # Use production URL for live

phonepe_client = PhonePePaymentClient(merchant_id=MERCHANT_ID, salt_key=SALT_KEY, salt_index=SALT_INDEX, env=env)

# FastAPI app initialization
app = APIRouter()

# Models for request and response validation
class PaymentRequest(BaseModel):
    amount: int  # Amount in rupees (e.g., 100 for ₹100)
    transaction_id: str  # Unique transaction ID
    callback_url: str  # Callback URL for payment status

class StatusRequest(BaseModel):
    transaction_id: str  # Unique transaction ID


# Helper function to generate checksum
def generate_checksum(payload: str, endpoint: str) -> str:
    concatenated_string = payload + endpoint + SALT_KEY
    checksum = hashlib.sha256(concatenated_string.encode()).hexdigest()
    return checksum


# Endpoint to initiate a payment
@app.post("/initiate-payment")
async def initiate_payment(request: PaymentRequest):
    try:
        # Prepare payload
        payload = {
            "merchantId": MERCHANT_ID,
            "merchantTransactionId": request.transaction_id,
            "merchantUserId": "user123",  
            "amount": request.amount * 100, 
            "redirectUrl": request.callback_url,
            "redirectMode": "POST",
            "callbackUrl": request.callback_url,
            "paymentInstrument": {
                "type": "PAY_PAGE",
            },
        }

        # Encode payload to Base64
        payload_string = base64.b64encode(str(payload).encode()).decode()

        # Generate checksum
        checksum = generate_checksum(payload_string, "/pg/v1/pay")

        # Make POST request to PhonePe API
        headers = {
            "Content-Type": "application/json",
            "X-VERIFY": f"{checksum}###{SALT_INDEX}",
        }
        response = requests.post(
            f"{BASE_URL}/pg/v1/pay", data=payload_string, headers=headers
        )

        if response.status_code == 200:
            return {"success": True, "data": response.json()}
        else:
            raise HTTPException(
                status_code=response.status_code,
                detail=f"PhonePe API Error: {response.text}",
            )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# Endpoint to check payment status
@app.post("/check-status")
async def check_status(request: StatusRequest):
    try:
        # Prepare payload for status check
        payload = {
            "merchantId": MERCHANT_ID,
            "merchantTransactionId": request.transaction_id,
        }

        # Encode payload to Base64
        payload_string = base64.b64encode(str(payload).encode()).decode()

        # Generate checksum
        checksum = generate_checksum(payload_string, "/pg/v1/status")

        # Make POST request to PhonePe API for status check
        headers = {
            "Content-Type": "application/json",
            "X-VERIFY": f"{checksum}###{SALT_INDEX}",
        }
        response = requests.post(
            f"{BASE_URL}/pg/v1/status", data=payload_string, headers=headers
        )

        if response.status_code == 200:
            return {"success": True, "data": response.json()}
        else:
            raise HTTPException(
                status_code=response.status_code,
                detail=f"PhonePe API Error: {response.text}",
            )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))