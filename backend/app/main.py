import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI
from app.routes import user, donation
from app.services.database import get_db

app = FastAPI(title="Sharewell API", version="1.0")

# Include routes
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(donation.router, prefix="/donations", tags=["Donations"])

@app.get("/")
def root():
    return {"message": "Welcome to Sharewell API"}
