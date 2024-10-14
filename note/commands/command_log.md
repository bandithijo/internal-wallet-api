# Command log

## Create new project
```
rails new internal-wallet-api -T --api -d postgreql
```

## Install RSpec for Rails
```
rails g rspec:install
```

## Create model for User, Team, Stock, Wallet, Transaction
```
rails g model User name:string email:string password_digest:string
rails g model Team name:string
rails g model Stock name:string symbol:string
rails g model Wallet walletable:references{polymorphic} 'balance:decimal{10,2}'
rails g model Transaction source_wallet:references target_wallet:references 'amount:decimal{10,2}' type:string
```

## Create model STI for Transaction
```
rails g model CreditTransaction --no-migration
rails g model DebitTransaction --no-migration
```

## Create model UserToken
```
rails g model UserToken user:references token:string:index token_expired_at:datetime
```

## Create controller for Sessions
```
rails g controller Sessions create destroy --routing-specs
```

## Create controller for Wallets, Transactions
```
rails g controller Wallets show deposit withdraw transfer --routing-specs
rails g controller Transactions index --routing-specs
```

## Create migration AddUserIdToTransactions
```
rails g migration AddUserIdToTransactions user:references
```
