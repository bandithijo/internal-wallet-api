class LatestStockPrice
  include HTTParty
  base_uri "https://latest-stock-price.p.rapidapi.com"

  def initialize
    @default_header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-RapidAPI-Host": "latest-stock-price.p.rapidapi.com",
      "X-RapidAPI-Key": Rails.application.credentials.latest_stock_price.x_rapidapi_key
    }
  end

  def price_all(options = {})
    begin
      options = {
        headers: @default_header
      }

      response = self.class.get("/any", options)
    rescue StandardError => e
      response = e
    rescue Timeout::Error
      response = nil
    end

    response
  end
end
