# lib/trading/real_time_trading_bot.rb
require "alpaca/trade/api"

# Alpaca::Trade::Api.configure do |config|
#   config.endpoint = "https://paper-api.alpaca.markets"
#   config.key_id = "PKQS4UYIMUTPBVDY7BPC"
#   config.key_secret = "vDV0LSbYLPc6vSc9jWIXeAib9QYD7wgpNPgrVj4f"
# end

# puts client.new_order(symbol: "AAPL", side: "buy", type: "market", time_in_force: "gtc", qty: 1)
# puts client.account
# puts client.orders
# puts client.new_order(symbol: "AAPL", side: "buy", type: "market", time_in_force: "gtc", qty: 1)

# def initialize_alpaca_client(type = None, key_id, key_secret)
#   if type == "paper"
#     api_endpoint = "https://paper-api.alpaca.markets"
#   elsif type == "live"
#     api_endpoint = "https://api.alpaca.markets"
#   else
#     api_endpoint = "https://paper-api.alpaca.markets"
#   end

#   Alpaca::Trade::Api.configure do |config|
#     config.endpoint = api_endpoint
#     config.key_id = key_id
#     config.key_secret = key_secret
#   end

#   client = Alpaca::Trade::Api::Client.new
#   return client
# end

class RealTimeTradingBot
  def initialize(api_key, api_secret, endpoint, symbol)
    @client = initialize_alpaca_client(endpoint, api_key, api_secret)
    @symbol = symbol
    @long_window = 30
    @short_window = 10
    @position = nil
  end

  def run
    loop do
      check_for_signals
      sleep(60) # Wait for 1 minute before checking again
    end
  end

  private

  def initialize_alpaca_client(endpoint, key_id, key_secret)
    Alpaca::Trade::Api.configure do |config|
      config.endpoint = endpoint
      config.key_id = key_id
      config.key_secret = key_secret
    end

    client = Alpaca::Trade::Api::Client.new
    return client
  end

  def check_for_signals
    begin
      # Execute the Python script to get close prices
      python_script_path = "lib/data/real_time_data.py"  # Replace with the path to your Python script
      python_command = "python #{python_script_path} #{@symbol} #{@long_window + 1}"
      close_prices_output = `#{python_command}`

      puts "Close prices: #{close_prices_output}"

      # Parse the output to get close prices
      close_prices = close_prices_output.split(",").map(&:to_f)

      # Calculate SMAs
      short_sma = sma(close_prices, @short_window)
      long_sma = sma(close_prices, @long_window)

      last_short_sma = short_sma.last
      last_long_sma = long_sma.last

      # Check SMAs and open positions accordingly
      if last_short_sma > last_long_sma && @position != "long"
        open_long_position
      elsif last_short_sma < last_long_sma && @position != "short"
        open_short_position
      end
    rescue => e
      puts "Error in check_for_signals: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end

  def sma(data, window_size)
    data.each_cons(window_size).map { |window| window.sum / window_size }
  end

  def open_long_position
    order = @client.new_order(
      symbol: @symbol,
      qty: 1,
      side: "buy",
      type: "market",
      time_in_force: "gtc",
    )
    @position = "long"
    puts "Opened long position on #{@symbol} at #{order.filled_avg_price}"
  end

  def open_short_position
    order = @client.new_order(
      symbol: @symbol,
      qty: 1,
      side: "sell",
      type: "market",
      time_in_force: "gtc",
    )
    @position = "short"
    puts "Opened short position on #{@symbol} at #{order.filled_avg_price}"
  end
end

# Usage example
bot = RealTimeTradingBot.new("PKQS4UYIMUTPBVDY7BPC", "vDV0LSbYLPc6vSc9jWIXeAib9QYD7wgpNPgrVj4f", "https://paper-api.alpaca.markets", "NVDA")
bot.run
