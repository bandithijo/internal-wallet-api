require 'rails_helper'

RSpec.describe LatestStockPrice, type: :lib do
  let(:http_status_code) { nil }
  let(:response) { nil }

  before do
    stub_request(:get, /latest-stock-price.p.rapidapi.com/)
      .with(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      })
      .to_return(
        status: http_status_code,
        headers: { 'Content-Type': 'application/json' },
        body: response
      )
  end

  describe 'LatestStockPrice Library' do

    context 'Check the Class' do
      it { expect(LatestStockPrice.class.name).to eq('Class') }
      it { expect(LatestStockPrice.new.class.name).to eq('LatestStockPrice') }
    end

    context 'GET #price_all' do
      let(:latest_stock_price) {
        LatestStockPrice.new.price_all
      }
      let(:response_parsed) {
        latest_stock_price.parsed_response
      }

      context 'Success' do
        let(:http_status_code) { 200 }
        let(:response) { File.read("#{fixture_paths.last}/latest_stock_price/responses/success.json") }

        it { expect(latest_stock_price.code).to eq(200) }

        it { expect(response_parsed.class).to eq(Array) }
        it { expect(response_parsed.size).to eq(900) }
      end
    end
  end
end
