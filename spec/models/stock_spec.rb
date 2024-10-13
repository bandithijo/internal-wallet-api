require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'Associations' do
    it { should have_one(:wallet).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:symbol) }
    it { should validate_uniqueness_of(:symbol) }
  end
end
