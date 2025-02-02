from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app import models
from schemas.donation import DonationCreate, DonationResponse
from app.services.database import get_db

router = APIRouter()

@router.post("/")
def create_donation(donation: DonationCreate, db: Session = Depends(get_db)):
    new_donation = models.Donation(**donation.dict())
    db.add(new_donation)
    db.commit()
    db.refresh(new_donation)
    return new_donation
