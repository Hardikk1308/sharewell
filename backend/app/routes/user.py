from fastapi import APIRouter, Depends
from app.services.firebase import verify_firebase_token

router = APIRouter()

@router.get("/profile")
def get_user_profile(firebase_user=Depends(verify_firebase_token)):
    """Get user details from Firebase Authentication."""
    return {
        "uid": firebase_user["uid"],
        "email": firebase_user.get("email"),
        "name": firebase_user.get("name", "Anonymous")
    }
