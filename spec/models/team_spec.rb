require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'Associations' do
    it { should have_one(:wallet).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end
end
