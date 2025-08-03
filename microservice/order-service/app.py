from flask import Flask, request, jsonify

app = Flask(__name__)

orders = []

@app.route("/orders", methods=["POST"])
def create_order():
    data = request.get_json()
    orders.append(data)
    return jsonify({"message": "Order placed successfully!"})

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003)
