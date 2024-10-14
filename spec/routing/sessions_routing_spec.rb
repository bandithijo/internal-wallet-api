require 'rails_helper'

RSpec.describe SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: "sign-in").to route_to("sessions#create", format: :json)
    end
    it 'routes to #destroy' do
      expect(delete: "sign-out").to route_to("sessions#destroy", format: :json)
    end
  end
end
