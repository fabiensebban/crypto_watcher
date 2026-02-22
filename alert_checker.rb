require 'bundler/setup'
require_relative './utils/telegram'
require_relative './utils/coingecko'
require 'dotenv/load'


BITCOIN_ALERT_THRESHOLD = 57_000

bot_token = ENV['TELEGRAM_BOT_TOKEN']
chat_id = ENV['TELEGRAM_DEFAULT_CHAT_ID']

price = Utils::Coingecko.get_bitcoin_price
puts "Current Bitcoin price: $#{price}"

if price < BITCOIN_ALERT_THRESHOLD
  message = "🚨 Alert: Bitcoin price is below $57,000! Current price: $#{price}"
  Utils::Telegram.send_message(bot_token, chat_id, message)
  puts "Alert sent to Telegram."
else
  puts "No alert sent."
end
