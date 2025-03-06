import logging
from flask import Flask, jsonify, request
import requests
from flask_caching import Cache

app = Flask(__name__)

# Configure cache
cache = Cache(app, config={"CACHE_TYPE": "simple"})

logging.basicConfig(level=logging.WARNING)


@app.route("/stocks")
@cache.cached(timeout=3600)  # Cache this view for 1 hour
def get_stock_data():
    # Retrieve API keys from request headers
    api_key = request.headers.get("APCA-API-KEY-ID")
    api_secret = request.headers.get("APCA-API-SECRET-KEY")

    if not api_key or not api_secret:
        return jsonify({"error": "API key or secret not provided"}), 400

    api_url = "https://paper-api.alpaca.markets/v2/assets"
    headers = {"APCA-API-KEY-ID": api_key, "APCA-API-SECRET-KEY": api_secret}

    response = requests.get(api_url, headers=headers)
    if response.status_code == 200:
        assets = response.json()
        # Filter for assets that are active and tradable, and collect their symbols
        symbols = [
            asset["symbol"]
            for asset in assets
            if asset.get("status", "") == "active" and asset.get("tradable", False)
        ]
        return jsonify(symbols)
    else:
        return jsonify({"error": "Failed to fetch data"}), response.status_code


if __name__ == "__main__":
    from waitress import serve

    app.logger.setLevel(logging.WARNING)
    serve(app, host="0.0.0.0", port=5001)
