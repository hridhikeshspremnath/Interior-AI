from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests
import base64

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

HF_TOKEN = "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"

API_URL = "https://router.huggingface.co/hf-inference/models/stabilityai/stable-diffusion-2"

headers = {
    "Authorization": f"Bearer {HF_TOKEN}"
}

@app.post("/generate")
def generate_image(data: dict):

    image_url = data.get("imageUrl")
    prompt = data.get("prompt")

    # Download the uploaded room image
    image_response = requests.get(image_url)

    payload = {
        "inputs": prompt,
        "image": base64.b64encode(image_response.content).decode("utf-8")
    }

    response = requests.post(API_URL, headers=headers, json=payload)

    if response.status_code != 200:
        return {"error": response.text}

    img_base64 = base64.b64encode(response.content).decode("utf-8")

    return {
        "image": f"data:image/png;base64,{img_base64}"
    }