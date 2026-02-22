require 'net/http'

module Utils
  module Telegram
    def self.send_message(bot_token:, chat_id: ENV['TELEGRAM_DEFAULT_CHAT_ID'], message:)
      url = URI("https://api.telegram.org/bot#{bot_token}/sendMessage")
      params = { chat_id: chat_id, text: message }
      Net::HTTP.post_form(url, params)
    end
  end
end
