from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()
lambda_handler = Mangum(app)


@app.get("/")
def read_root():
    return {"message": "Hello, FastAPI! número 5"}
