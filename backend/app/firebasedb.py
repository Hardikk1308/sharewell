from fastapi import APIRouter, HTTPException
from models.donation import DonationCreate
from datetime import datetime
import uuid
from firebase import db

router = APIRouter()

@router.post("/create-donation/")
async def create_donation(donation: DonationCreate):
    try:
        donation_id = str(uuid.uuid4())

        donation_data = {
            "donor_id": donation.donor_id,
            "category": donation.category,
            "description": donation.description,
            "quantity": donation.quantity,
            "expiry_date": donation.expiry_date,
            "location": {
                "latitude": donation.latitude,
                "longitude": donation.longitude
            },
            "status": "available",
            "created_at": datetime.utcnow()
        }

        db.collection("donations").document(donation_id).set(donation_data)

        return {"message": "Donation created successfully", "donation_id": donation_id}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Server Error: {str(e)}")
