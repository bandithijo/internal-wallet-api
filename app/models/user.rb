class User < ApplicationRecord
  has_secure_password

  # Associations
  has_one :wallet, as: :walletable, dependent: :destroy
  has_many :user_tokens, dependent: :destroy
  has_many :transactions, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
