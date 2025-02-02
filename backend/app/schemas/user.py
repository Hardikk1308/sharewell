from pydantic import BaseModel
from typing import Optional

class UserCreate(BaseModel):
    username: str
    email: str
    password: str
    role: Optional[str]  # "donor", "volunteer", "receiver"

class UserResponse(BaseModel):
    id: int
    username: str
    email: str
    role: str
    is_active: bool
