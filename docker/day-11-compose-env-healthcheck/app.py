import os

from flask import Flask, jsonify
import redis

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "Compose Env App")
APP_ENV = os.getenv("APP_ENV", "local")
APP_VERSION = os.getenv("APP_VERSION", "dev")

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
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
    <p>Version: {APP_VERSION}</p>
    <p>Environment: {APP_ENV}</p>
    <p>Redis: {REDIS_HOST}:{REDIS_PORT}</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok",
        "service": APP_NAME,
        "version": APP_VERSION
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


@app.get("/counter")
def counter():
    value = redis_client.incr("day11_counter")
    return jsonify({
        "counter": value
    })


@app.get("/config")
def config():
    return jsonify({
        "app": APP_NAME,
        "version": APP_VERSION,
        "environment": APP_ENV,
        "redis_host": REDIS_HOST,
        "redis_port": REDIS_PORT
    })
