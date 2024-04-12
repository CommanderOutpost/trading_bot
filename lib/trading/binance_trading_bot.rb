require "binance"

class RealTimeBinanceTradingBot
  attr_reader :symbol, :long_window, :short_window, :position, :quantity, :running

  def initialize(api_key, api_secret, symbol)
    @client = Binance::Client::REST.new(api_key: api_key, secret_key: api_secret)
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
      sleep(60)
    end
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

  # Example to fetch account portfolio information
  def get_portfolio
    # Implement based on your needs and Binance API capabilities
    # This is just a placeholder to illustrate
    {
      balance: @client.account_info["balances"].find { |balance| balance["asset"] == "BTC" },
    }
  end

  private

  def check_for_signals
    close_prices = fetch_close_prices
    return unless close_prices
    # Implement your strategy here
    short_sma, long_sma = calculate_smas(close_prices)
    last_price = close_prices.last

    process_trading_signals(last_price, short_sma.last, long_sma.last)
  rescue => e
    log_error("check_for_signals", e)
  end

  def fetch_close_prices
    python_script_path = "lib/data/real_time_data.py"
    python_command = "python3 #{python_script_path} #{symbol} #{long_window + 1}"
    output = `#{python_command}`
    output&.split(",")&.map(&:to_f) || raise("Failed to fetch close prices.")
  rescue => e
    log_error("fetch_close_prices", e)
    nil
  end

  # Example method to place an order on Binance
  def place_order(side, price = nil)
    return unless side

    _side = ""

    _side = "SELL" if side == "SHORT"
    _side = "BUY" if side == "LONG"

    options = {
      symbol: @symbol,
      side: side,
      type: "LIMIT",
      quantity: @quantity,
    }
    options[:price] = price if price

    @client.create_order!(options)
    puts "#{side} #{@symbol}"
  end

  # Placeholder method to log positions and errors, similar to Alpaca bot
  def log_position(type, price)
    puts "Position #{type} at price #{price}"
    @history << { type: type, price: price, time: Time.now }
  end

  def log_error(method_name, error)
    puts "Error in #{method_name}: #{error.message}"
    puts error.backtrace.join("\n")
  end

  def sma(data, window_size)
    data.each_cons(window_size).map { |window| window.sum / window_size }
  end

  def calculate_smas(data)
    [sma(data, short_window), sma(data, long_window)]
  end

  def process_trading_signals(last_price, last_short_sma, last_long_sma)
    if last_short_sma > last_long_sma && @position != "long"
      close_position if position == "short"
      place_order("LONG")
    elsif last_short_sma < last_long_sma && @position != "short"
      close_position if position == "long"
      place_order("SHORT")
    else
      place_order("")
    end
  end

  # def open_position(type, price)
  #   order = @client.new_order(symbol: symbol, notional: price.round(2), side: type == "long" ? "BUY" : "SELL", type: "LIMIR", time_in_force: "day")
  #   @position = type
  #   log_position(type, order.filled_avg_price)
  # end
end

bot = RealTimeBinanceTradingBot.new("JTmP8lcNgNq7hHHpaxesoZfoAJEclXi2OMX5AwjgWoV6wkSo58c0UKZYoAaoZXzm", "j1YwssB5y9HPfAo0VEeEDWPpcRz2BqNSi5htjqjtKj6jKQxyiYLkKfbfA5eHn33N", "BTCUSD")
bot.get_attributes
bot.run
