# File: config/initializers/signal_handler.rb
Signal.trap("INT") do
  puts "\nCaught SIGINT; stopping all running bots"

  # Call method to stop all running trades and the bot
  ApplicationController.stop_all_trading_activities

  puts "All trading activities stopped. Exiting now."
  exit
end
