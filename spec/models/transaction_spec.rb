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

        it 'is valid with a source_wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: nil, target_wallet: wallet)

          expect(transaction).to be_valid
        end

        it 'is valid with a target_wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: wallet, target_wallet: nil)

          expect(transaction).to be_valid
        end

        it 'is invalid without target_wallet and source_wallet' do
          transaction = build(:transaction, amount: 1000, source_wallet: nil, target_wallet: nil)

          expect(transaction).not_to be_valid
        end
      end
    end
  end

  describe 'Class Methods' do
    let(:user) { create(:user) }
    let(:source_wallet) { create(:wallet, walletable: user, balance: 1000) }
    let(:target_wallet) { create(:wallet, walletable: user, balance: 0) }

    context '.perform_transaction' do
      it 'successfull performs a transaction and updates wallet balances' do
        expect { Transaction.perform_transaction(source_wallet: source_wallet, target_wallet: target_wallet, amount: 500, user: user) }
          .to change { source_wallet.reload.balance }.from(1000).to(500)
          .and change { target_wallet.reload.balance }.from(0).to(500)

        expect(Transaction.count).to eq(1)

        transaction = Transaction.last
        expect(transaction.source_wallet).to eq(source_wallet)
        expect(transaction.target_wallet).to eq(target_wallet)

        expect(transaction.amount).to eq(500)
      end

      it 'raise an error when there are sufficient funds' do
        expect { Transaction.perform_transaction(source_wallet: source_wallet, target_wallet: target_wallet, amount: 1500, user: user) }
          .to raise_error(RuntimeError, "Insufficient funds")

        expect(source_wallet.reload.balance).to eq(1000)
        expect(target_wallet.reload.balance).to eq(0)

        expect(Transaction.count).to eq(0)
      end

      it 'creates a transaction with only a source wallet (withdrawals or debiting a wallet)' do
        expect { Transaction.perform_transaction(source_wallet: source_wallet, amount: 200, user: user) }
          .to change { source_wallet.reload.balance }.from(1000).to(800)

        expect(Transaction.count).to eq(1)

        transaction = Transaction.last
        expect(transaction.source_wallet).to eq(source_wallet)
        expect(transaction.target_wallet).to be_nil
        expect(transaction.amount).to eq(200)
      end

      it 'creates a transaction with only a target wallet (deposits or crediting a wallet)' do
        expect { Transaction.perform_transaction(target_wallet: target_wallet, amount: 300, user: user) }
          .to change { target_wallet.reload.balance }.from(0).to(300)

        expect(Transaction.count).to eq(1)

        transaction = Transaction.last
        expect(transaction.source_wallet).to be_nil
        expect(transaction.target_wallet).to eq(target_wallet)
        expect(transaction.amount).to eq(300)
      end
    end
  end
end
