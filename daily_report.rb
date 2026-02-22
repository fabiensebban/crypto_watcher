require 'bundler/setup'
require 'net/http'
require 'json'
require 'dotenv/load'
require "active_support"
require "active_support/number_helper"
require_relative './utils/telegram'
require_relative './utils/coingecko'

def get_formatted_crypto_price(crypto_ids, currencies = ['usd'])
  data = Utils::Coingecko.get_price(crypto_ids, currencies)
  returned_message = ""

  crypto_ids.map do |crypto_id|
    price = currencies.map do |currency|
              "#{ActiveSupport::NumberHelper.number_to_currency(data[crypto_id][currency], unit: get_unit(currency), separator: ",", delimiter: " ")}"
            end.join(' // ')

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

Utils::Telegram.send_message(
  bot_token: ENV['TELEGRAM_BOT_TOKEN'],
  message: "📊 Daily Crypto Snapshot\n\n#{get_formatted_crypto_price(['bitcoin', 'ethereum', 'solana', 'binancecoin'], ['usd', 'eur'])}"
)
