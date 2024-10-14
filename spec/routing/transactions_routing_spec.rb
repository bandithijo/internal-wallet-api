require 'rails_helper'

RSpec.describe 'TransactionsController', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: "/transactions").to route_to("transactions#index", format: :json)
    end
  end
end
