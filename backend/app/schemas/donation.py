from pydantic import BaseModel

class DonationCreate(BaseModel):
    product_name: str
    quantity: int
    location: str
    price: float

class DonationResponse(BaseModel):
    id: int
    product_name: str
    quantity: int
    location: str
    price: float
