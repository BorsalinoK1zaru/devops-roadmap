import os

from flask import Flask, jsonify

app = Flask(__name__)


APP_NAME = os.getenv("APP_NAME", "Python Docker App")
APP_VERSION = os.getenv("APP_VERSION", "dev")
APP_ENV = os.getenv("APP_ENV", "local")
MAINTAINER = os.getenv("MAINTAINER", "unknown")

@app.get("/")
def index():
    return f"""
    <h1>Имя приложения: {APP_NAME}</h1>
    <p>Версия: {APP_VERSION}</p>
    <p>Окружение: {APP_ENV}</p>
    <p>Автор: {MAINTAINER}</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok"
    })


@app.get("/version")
def version():
    return jsonify({
        "app": APP_NAME,
        "version": APP_VERSION,
        "environment": APP_ENV
    })

@app.get("/info")
def info():
    return jsonify({
        "app": APP_NAME,
        "version": APP_VERSION,
        "environment": APP_ENV,
        "author": MAINTAINER
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
