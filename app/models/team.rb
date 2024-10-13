class Team < ApplicationRecord
  # Associations
  has_one :wallet, as: :walletable, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
end
