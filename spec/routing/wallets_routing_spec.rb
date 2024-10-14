require 'rails_helper'

RSpec.describe 'WalletsController', type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: "/wallet").to route_to("wallets#show", format: :json)
    end
    it 'routes to #deposit' do
      expect(post: "/wallet/deposit").to route_to("wallets#deposit", format: :json)
    end
    it 'routes to #withdraw' do
      expect(post: "/wallet/withdraw").to route_to("wallets#withdraw", format: :json)
    end
    it 'routes to #transfer' do
      expect(post: "/wallet/transfer").to route_to("wallets#transfer", format: :json)
    end
  end
end
