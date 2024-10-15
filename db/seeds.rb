# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create user and user's wallet
user = User.create(
  name: "John Doe",
  email: "johndoe@gmail.com",
  password: "secure"
)
Wallet.create(walletable: user, balance: 1000.0)

# Create team and team's wallet
team = Team.create(
  name: "Gresini"
)
Wallet.create(walletable: team, balance: 500.0)

# Create stock and stock's wallet
stock = Stock.create(
  name: "Tesla, Inc.",
  symbol: "TSLA"
)
Wallet.create(walletable: stock, balance: 100.0)
