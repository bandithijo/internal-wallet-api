# Command log

## Create new project
```
rails new internal-wallet-api -T --api -d postgreql
```

## Install RSpec for Rails
```
rails g rspec:install
```

## Create model migration for User, Team, Stock, Wallet, Transaction
```
rails g model User name:string email:string password_digest:string
rails g model Team name:string
rails g model Stock name:string symbol:string
rails g model Wallet walletable:references{polymorphic} 'balance:decimal{10,2}'
rails g model Transaction source_wallet:references target_wallet:references 'amount:decimal{10,2}' type:string
```
