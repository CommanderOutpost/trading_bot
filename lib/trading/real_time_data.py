import sys
import yfinance as yf


def get_close_prices(symbol, limit):
    try:
        # Download historical data
        data = yf.download(symbol, period=f"{limit}d")

        # Extract close prices
        close_prices = data["Close"]

        # Convert close prices to comma-separated string
        close_prices_str = ",".join(map(str, close_prices))

        return close_prices_str
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        return None


if __name__ == "__main__":
    # Check if symbol and limit are provided as command-line arguments
    if len(sys.argv) < 3:
        print("Please provide symbol and limit as command-line arguments.")
        sys.exit(1)

    # Extract symbol and limit from command-line arguments
    symbol = sys.argv[1]
    limit = int(sys.argv[2])

    # Get close prices
    close_prices = get_close_prices(symbol, limit)
    
    if close_prices is not None:
        # Store close prices in a file instead of printing
        with open("lib/trading/close_prices.txt", "w") as file:
            file.write(close_prices)
