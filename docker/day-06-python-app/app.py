import os

from flask import Flask, jsonify

app = Flask(__name__)


APP_NAME = os.getenv("APP_NAME", "Python Docker App")
APP_VERSION = os.getenv("APP_VERSION", "dev")
APP_ENV = os.getenv("APP_ENV", "local")


@app.get("/")
def index():
    return f"""
    <h1>Hello from {APP_NAME}</h1>
    <p>Version: {APP_VERSION}</p>
    <p>Environment: {APP_ENV}</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok",
        "service": APP_NAME
    })


@app.get("/version")
def version():
    return jsonify({
        "app": APP_NAME,
        "version": APP_VERSION,
        "environment": APP_ENV
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
