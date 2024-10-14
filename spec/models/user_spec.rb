require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Has Secure Password' do
    it { should have_secure_password(:password) }
  end

  describe 'Associations' do
    it { should have_one(:wallet).dependent(:destroy) }
    it { should have_many(:user_tokens).dependent(:destroy) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
