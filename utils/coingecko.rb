require 'net/http'
require 'json'

module Utils
  module Coingecko
    # Get price for any crypto and currency (default: bitcoin, usd)
    def self.get_price(crypto_ids, currencies = ['usd'])
      url = URI("https://api.coingecko.com/api/v3/simple/price?ids=#{crypto_ids.join(',')}&vs_currencies=#{currencies.join(',')}")
      response = Net::HTTP.get(url)
      JSON.parse(response)
    end
  end
end
