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
    @quantity = 1
    @running = false
    @history = []
  end

  def run
    @running = true
    loop do
      check_for_signals
      sleep(2)
    end
  end

  def stop
    @running = false
  end

  def get_attributes
    return {
             symbol: @symbol,
             long_window: @long_window,
             short_window: @short_window,
             position: @position,
             quantity: @quantity,
             running: @running,
           }
  end

  def get_portfolio
    portfolio_info = {
      cash: @client.account.cash,
      equity: @client.account.equity,
      portfolio_value: @client.account.portfolio_value,
    }
    return portfolio_info
  end

  def get_quantity
    return @quantity
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
      # Assume we have a method that gets the last N+1 close prices for the symbol
      close_prices = get_last_n_close_prices(@symbol, @long_window + 1)

      # Calculate SMAs
      short_sma = sma(close_prices, @short_window)
      long_sma = sma(close_prices, @long_window)

      last_price = close_prices.last
      last_short_sma = short_sma.last
      last_long_sma = long_sma.last

      # Check if short SMA crossed above long SMA for a Golden Cross/buy signal
      if last_short_sma > last_long_sma && @position != "long"
        close_short_position if @position == "short"  # If we have a short position, we need to close it first
        open_long_position(last_price)
        # Check if short SMA crossed below long SMA for a Death Cross/sell signal
      elsif last_short_sma < last_long_sma && @position != "short"
        close_long_position if @position == "long"  # If we have a long position, we need to close it first
        open_short_position(last_price)
      end
    rescue => e
      puts "Error in check_for_signals: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end

  def get_last_n_close_prices(symbol, days)
    # print files in lib/data directory
    puts Dir.entries("lib/data")

    python_script_path = "lib/data/real_time_data.py"
    python_command = "python3 #{python_script_path} #{symbol} #{days}"
    close_prices_output = `#{python_command}`

    if close_prices_output && !close_prices_output.empty?
      close_prices_output.split(",").map(&:to_f)
    else
      raise "Failed to fetch close prices."
    end
  rescue => e
    puts "Error in get_last_n_close_prices: #{e.message}"
    nil
  end

  def sma(data, window_size)
    data.each_cons(window_size).map { |window| window.sum / window_size }
  end

  def open_long_position(price)
    order = @client.new_order(
      symbol: @symbol,
      notional: price.round(2),
      side: "buy",
      type: "market",
      time_in_force: "day",
    )
    @position = "long"
    puts "Opened long position on #{@symbol} at #{order.filled_avg_price}"
    @history << { type: "long", price: order.filled_avg_price, time: Time.now }
  end

  def open_short_position(price)
    order = @client.new_order(
      symbol: @symbol,
      notional: price.round(2),
      side: "sell",
      type: "market",
      time_in_force: "day",
    )
    @position = "short"
    puts "Opened short position on #{@symbol} at #{order.filled_avg_price}"
    @history << { type: "short", price: order.filled_avg_price, time: Time.now }
  end

  def close_long_position
    order = @client.close_position(
      symbol: @symbol,
    )
    @position = nil
    puts "Closed long position on #{@symbol} at #{order.filled_avg_price}"
  end

  def close_short_position
    order = @client.close_position(
      symbol: @symbol,
    )
    @position = nil
    puts "Closed short postion on #{@symbol} at #{order.filled_avg_price}"
  end
end

# # # Usage example
# bot = RealTimeTradingBot.new("PKQS4UYIMUTPBVDY7BPC", "vDV0LSbYLPc6vSc9jWIXeAib9QYD7wgpNPgrVj4f", "https://paper-api.alpaca.markets", "AAPL")
# portfolio = bot.get_portfolio
# bot.run
