import sys
import os
import uvicorn

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI
from app.routes import user
from app.services.database import get_db
from expirydetection import router as expiry_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Sharewell API", version="1.0")

# Include routes
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(expiry_router)

@app.get("/")
def root():
    return {"message": "Welcome to Sharewell API"}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000)) 
    uvicorn.run(app, host="127.0.0.1", port=8000)