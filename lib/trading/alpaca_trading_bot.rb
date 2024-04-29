# lib/trading/real_time_trading_bot.rb
require "alpaca/trade/api"

class RealTimeAlpacaTradingBot
  attr_reader :symbol, :long_window, :short_window, :position, :quantity, :running
  attr_accessor :on_stop

  def initialize(api_key, api_secret, endpoint, symbol, on_stop = nil)
    @client = initialize_alpaca_client(endpoint, api_key, api_secret)
    @symbol = symbol
    @long_window = 30
    @short_window = 10
    @position = nil
    @quantity = 1
    @running = false
    @history = []
    @on_stop = on_stop
  end

  def run
    @running = true
    loop do
      signal = check_for_signals
      puts "Received signal: #{signal.inspect}"

      if signal.nil?
        puts "Error in check_for_signals. Exiting..."
        break
      end

      sleep(60)
    end
    puts "Exited."
    @on_stop.call if @on_stop
  end

  def stop
    @running = false
  end

  def get_attributes
    {
      symbol: symbol,
      long_window: long_window,
      short_window: short_window,
      position: position,
      quantity: quantity,
      running: running,
    }
  end

  def get_portfolio
    {
      cash: @client.account.cash,
      equity: @client.account.equity,
      portfolio_value: @client.account.portfolio_value,
    }
  end

  private

  def initialize_alpaca_client(endpoint, key_id, key_secret)
    Alpaca::Trade::Api.configure do |config|
      config.endpoint = endpoint
      config.key_id = key_id
      config.key_secret = key_secret
    end
    Alpaca::Trade::Api::Client.new
  end

  def check_for_signals
    close_prices = fetch_close_prices
    return unless close_prices
    check_for_error_in_python_output(close_prices)

    short_sma, long_sma = calculate_smas(close_prices)
    last_price = close_prices.last

    process_trading_signals(last_price, short_sma.last, long_sma.last)
  rescue => e
    log_error("check_for_signals", e)
    return nil
  end

  def fetch_close_prices
    base_path = "lib/trading"
    python_script_path = "#{base_path}/real_time_data.py"
    python_command = "/usr/bin/python3 #{python_script_path} #{symbol} #{long_window + 1}"
    output = `#{python_command}`
    close_prices = File.read("#{base_path}/close_prices.txt")
    return unless close_prices

    close_prices&.split(",")&.map(&:to_f) || raise("Failed to fetch close prices.")
  rescue => e
    log_error("fetch_close_prices", e)
    nil
  end

  def calculate_smas(data)
    [sma(data, short_window), sma(data, long_window)]
  end

  def process_trading_signals(last_price, last_short_sma, last_long_sma)
    if last_short_sma > last_long_sma && position != "long"
      close_position if position == "short"
      open_position("long", last_price)
    elsif last_short_sma < last_long_sma && position != "short"
      close_position if position == "long"
      open_position("short", last_price)
    else
      puts "No trading signal received."
      return "none"
    end
  end

  def sma(data, window_size)
    data.each_cons(window_size).map { |window| window.sum / window_size }
  end

  def open_position(type, price)
    order = @client.new_order(symbol: symbol, notional: price.round(2), side: type == "long" ? "buy" : "sell", type: "market", time_in_force: "day")
    @position = type
    log_position(type, order.filled_avg_price)
  end

  def close_position
    order = @client.close_position(symbol: symbol)
    @position = nil
    log_position("closed", order.filled_avg_price)
  end

  def check_for_error_in_python_output(output)
    raise output if output.split(" ").first == "Error"
  end

  def log_error(method_name, error)
    puts "Error in #{method_name}: #{error.message}"
    puts error.backtrace.join("\n")
  end

  def log_position(type, price)
    action = type == "closed" ? "Closed" : "Opened #{type}"
    puts "#{action} position on #{symbol} at #{price}"
    @history << { type: type, price: price, time: Time.now }
  end
end

# # # Usage example
# bot = RealTimeTradingBot.new("PKQS4UYIMUTPBVDY7BPC", "vDV0LSbYLPc6vSc9jWIXeAib9QYD7wgpNPgrVj4f", "https://paper-api.alpaca.markets", "AAPL")
# portfolio = bot.get_portfolio
# bot.run
