from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid

app = FastAPI()

class User(BaseModel):
    username: str
    password: str

# In-memory store
users = {}

def hash_pwd(pwd: str) -> str:
    return pwd + "_hashed"  # stub

@app.post("/register")
def register(user: User):
    if user.username in users:
        raise HTTPException(status_code=400, detail="User exists")
    users[user.username] = hash_pwd(user.password)
    return {"user_id": str(uuid.uuid4()), "username": user.username}

@app.post("/login")
def login(user: User):
    hashed = users.get(user.username)
    if not hashed or hashed != hash_pwd(user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"token": str(uuid.uuid4())}

@app.get("/health")
def health():
    return {"status": "ok"}
