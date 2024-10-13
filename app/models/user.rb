class User < ApplicationRecord
  has_secure_password

  # Associations
  has_one :wallet, as: :walletable, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
