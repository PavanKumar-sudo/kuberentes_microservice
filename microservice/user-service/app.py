from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get("username")
    return jsonify({"message": f"User {username} registered successfully!"})

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    return jsonify({"message": f"User {username} logged in!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
