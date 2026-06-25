import os

from flask import Flask, jsonify
import redis

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "Docker Network App")
REDIS_HOST = os.getenv("REDIS_HOST", "day8-redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))

redis_client = redis.Redis(
    host=REDIS_HOST,
    port=REDIS_PORT,
    decode_responses=True
)


@app.get("/")
def index():
    return f"""
    <h1>{APP_NAME}</h1>
    <p>Приложение работает в Docker и подключается к Redis.</p>
    <p>Redis host: {REDIS_HOST}</p>
    <p>Redis port: {REDIS_PORT}</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok",
        "service": APP_NAME
    })


@app.get("/counter")
def counter():
    value = redis_client.incr("counter")

    return jsonify({
        "counter": value
    })


@app.get("/redis-check")
def redis_check():
    try:
        redis_client.ping()
        return jsonify({
            "redis": "connected",
            "host": REDIS_HOST,
            "port": REDIS_PORT
        })
    except Exception as error:
        return jsonify({
            "redis": "error",
            "message": str(error)
        }), 500
