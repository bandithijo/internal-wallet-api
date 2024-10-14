require 'rails_helper'

RSpec.describe UserToken, type: :model do
  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
  end
end
