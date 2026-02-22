require 'bundler/setup'
require 'net/http'
require 'json'
require 'dotenv/load'
require "active_support"
require "active_support/number_helper"

def send_telegram_message(bot_token:, chat_id: ENV['TELEGRAM_DEFAULT_CHAT_ID'], message:)
  url = URI("https://api.telegram.org/bot#{bot_token}/sendMessage")
  params = { chat_id: chat_id, text: message }
  Net::HTTP.post_form(url, params)
end

def get_crypto_price(crypto_ids, currencies = ['usd'])
  url = URI("https://api.coingecko.com/api/v3/simple/price?ids=#{crypto_ids.join(',')}&vs_currencies=#{currencies.join(',')}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)
  returned_message = ""

  crypto_ids.map do |crypto_id|
    price = currencies.map { |currency| "#{ActiveSupport::NumberHelper.number_to_currency(data[crypto_id][currency], unit: get_unit(currency), separator: ",", delimiter: " ")}" }.join(' // ')

    returned_message = returned_message + "#{get_emoji(crypto_id)} #{crypto_id.capitalize} price: #{price}\n"
  end
  returned_message
end

def get_unit(currency)
    case currency.downcase
    when 'usd'
        '$'
    when 'eur'
        '€'
    else
        ''
    end
end

def get_emoji(crypto_id)
    case crypto_id.downcase
    when 'bitcoin'
        '₿'
    when 'ethereum'
        'Ξ'
    when 'solana'
        '☀️'
    when 'binancecoin'
        '🔶'
    else
        ''
    end
end

send_telegram_message(
  bot_token: ENV['TELEGRAM_BOT_TOKEN'],
  message: "📊 Daily Crypto Snapshot\n\n#{get_crypto_price(['bitcoin', 'ethereum', 'solana', 'binancecoin'], ['usd',   'eur'])}"
)
