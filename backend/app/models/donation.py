from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.services.database import Base

class Donation(Base):
    __tablename__ = "donations"

    id = Column(Integer, primary_key=True, index=True)
    donor_id = Column(Integer, ForeignKey("users.id"))
    product_name = Column(String, index=True)
    quantity = Column(Integer)
    location = Column(String)
    price = Column(Float, default=0.0)  # Can be 0 (free)
    
    donor = relationship("User")
