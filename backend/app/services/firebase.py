import firebase_admin
from firebase_admin import credentials, auth
from fastapi import HTTPException, Header

if not firebase_admin._apps:
    cred = credentials.Certificate("D:\Abhishek\Projects\Thapar\sharewell\frontend\firebase.json")
    firebase_admin.initialize_app(cred)

def verify_firebase_token(authorization: str = Header(...)):
    """
    Extract and verify Firebase ID token from the Authorization header.
    """
    try:
        token = authorization.split("Bearer ")[1]  
        decoded_token = auth.verify_id_token(token)  
        return decoded_token  
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid or expired authentication token")
