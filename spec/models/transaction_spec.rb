require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'Associations' do
    it { should belong_to(:source_wallet).class_name('Wallet').optional(true) }
    it { should belong_to(:target_wallet).class_name('Wallet').optional(true) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }

    describe 'Custom Validations' do
      context 'when both source_wallet & target_wallet are nil' do
        it 'is invalid without a source or target wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: nil, target_wallet: nil)

          expect(transaction).not_to be_valid
          expect(transaction.errors[:base]).to include("Transaction must have a source or target wallet")
        end
      end

      context 'when source_wallet or target_wallet is present' do
        let(:user) { create(:user) }
        let(:wallet) { create(:wallet, walletable: user) }

        it 'is invalid without a source_wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: nil, target_wallet: wallet)

          expect(transaction).not_to be_valid
        end

        it 'is invalid without a target_wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: wallet, target_wallet: nil)

          expect(transaction).not_to be_valid
        end
      end
    end
  end
end
