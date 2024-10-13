class Stock < ApplicationRecord
  # Associations
  has_one :wallet, as: :walletable, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :symbol, presence: true, uniqueness: true
end
