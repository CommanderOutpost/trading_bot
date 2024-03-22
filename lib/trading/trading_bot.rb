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

def initialize_alpaca_client(type = None, key_id, key_secret)
  if type == "paper"
    api_endpoint = "https://paper-api.alpaca.markets"
  elsif type == "live"
    api_endpoint = "https://api.alpaca.markets"
  else
    api_endpoint = "https://paper-api.alpaca.markets"
  end

  Alpaca::Trade::Api.configure do |config|
    config.endpoint = api_endpoint
    config.key_id = key_id
    config.key_secret = key_secret
  end

  client = Alpaca::Trade::Api::Client.new
  return client
end
