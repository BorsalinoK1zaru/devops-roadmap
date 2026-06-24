from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return """
    <h1>Hello from Python Docker container</h1>
    <p>Это мое первое Python web-приложение внутри Docker.</p>
    """


@app.get("/health")
def health():
    return jsonify({
        "status": "ok",
        "service": "day-06-python-app"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
