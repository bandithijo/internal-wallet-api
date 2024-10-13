require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe 'Associations' do
    it { should belong_to(:walletable) }

    it { should have_many(:source_transactions).with_foreign_key('source_wallet_id') }
    it { should have_many(:target_transactions).with_foreign_key('target_wallet_id') }
  end

  describe 'Validations' do
    it { should validate_presence_of(:balance) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
