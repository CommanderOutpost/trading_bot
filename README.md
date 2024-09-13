# Trading Bot

This is a Ruby on Rails application designed to help users automate their trading activities. The bot interacts with the Alpaca trading platform to buy and sell stocks based on user-defined settings.
Try it [here](https://quidbot.onrender.com/).

## Features

- **User Authentication:** Securely register, log in, and manage your account.
- **Trading Automation:** Start and stop the trading bot with ease. The bot handles all trading activities automatically.
- **Settings Management:** Set up your API keys, broker details, and other preferences directly from the app.
- **Trade Monitoring:** View the status of your trades in real-time, and stop them whenever you need to.

## How It Works

1. **User Registration and Login:**
   - Users can register with a username and password.
   - Once registered, you can log in and manage your account, including changing your password.

2. **Setting Up Your Trading Environment:**
   - After logging in, you need to set your API key, secret, and endpoint in the settings. This information is crucial for the bot to connect with the Alpaca trading platform.
   - Ensure your broker is supported (currently, only Alpaca is supported).

3. **Starting the Trading Bot:**
   - Choose the stock you want to trade and start the bot.
   - Once started, the bot automatically buys and sells based on your configurations.

4. **Stopping the Trading Bot:**
   - You can stop the bot at any time from the app.
   - When stopped, the bot will cease all trading activities, and any running trades will be updated to reflect their status as "stopped."

## Important Notes

- **Ensure Settings Are Correct:** Before starting the bot, make sure your settings are properly configured. Incorrect settings might lead to errors in the trading process.
- **Supported Broker:** Currently, the bot only supports Alpaca as a broker.

## Technical Overview

While this README is designed to be non-technical, here are a few things you might want to know:
- The bot is implemented using Ruby on Rails.
- It uses a combination of controllers to manage authentication, user settings, and trading activities.
- The bot operates in a separate thread to ensure the main application remains responsive.

## Conclusion

This trading bot project simplifies the process of automated trading, making it accessible even if you're not technically inclined. With a few simple steps, you can set up your trading environment, start trading, and manage your activities with ease.
