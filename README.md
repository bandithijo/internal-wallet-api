# 📚README: Internal Wallet API (ATASK)

[![wakatime](https://wakatime.com/badge/user/1e45775c-2d2f-46db-9f24-f0724d2323ff/project/7586f77b-8bb3-4a64-980f-0a40ccb9efce.svg)](https://wakatime.com/badge/user/1e45775c-2d2f-46db-9f24-f0724d2323ff/project/7586f77b-8bb3-4a64-980f-0a40ccb9efce)

This repository contains the coding test for evaluating essential skills and approaches to solving typical project challenges. It’s intended to give insight into practical coding practices and solution quality, though it’s still far from perfect.

> Disclaimer: The `config/master.key` file is intentionally removed from `.gitignore` for coding test purposes only.

## 💎Ruby version
```
Ruby 3.3.5
```

## 🔗 Database Engine
```
PostgreSQL v13.x (minimal)
```

## 🛠️ Configuration
```
$ bundle install
```

## 💼Database initialization and data seeds
```
$ bin/rails db:setup
```

```
Created database 'internal_wallet_api_development'
Created database 'internal_wallet_api_test'
```

It automatically seeds the data into the database.

## 🏗️ Run the test suite
```
$ bin/rails rspec
```

```
Finished in 1.58 seconds (files took 1.69 seconds to load)
48 examples, 0 failures
```

## 🚀 Run the server
```
$ bin/rails s
```

```
=> Booting Puma
=> Rails 7.2.1 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 6.4.3 (ruby 3.3.5-p100) ("The Eagle of Durango")
*  Min threads: 3
*  Max threads: 3
*  Environment: development
*          PID: 1697027
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

## 📈 ER Diagram

![erd](note/diagrams/erd.png)

## 📝 Postman Documentation

https://documenter.getpostman.com/view/8596816/2sAXxV4ozw

## 📍 Endpoints

### 🔐 Authentication

#### Sign-in

**Request**
```
curl --location 'http://localhost:3000/sign-in' \
--header 'Content-Type: application/json' \
--data-raw '{
    "session": {
        "email": "johndoe@gmail.com",
        "password": "secure"
    }
}'
```

**Response (success)**
```json
{
  "response": {
    "status": 201,
    "message": "Created",
    "url": "http://localhost:3000/sign-in"
  },
  "data": {
    "message": "Login successful",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHBpcmVkX2F0IjoxNzI5MTQxMjQ4fQ._Reui0lLloWIxKRF4WCIXuRhkWjJazztGSr3pn6EK_8",
    "token_expired_at": {
      "format_datetime": "2024-10-17T05:00:48.276Z",
      "format_integer": 1729141248
    }
  }
}
```

**Response (failed)**
```json
{
  "response": {
    "status": 401,
    "message": "Unauthorized",
    "url": "http://localhost:3000/sign-in"
  },
  "data": {
    "error": "Invalid email or password"
  }
}
```

#### Sign-out

**Request**
```
curl --location --request DELETE 'http://localhost:3000/sign-out' \
--header 'Content-Type: application/json'
```

**Response (success)**
```json
204 No Content
```

**Response (failed)**
```json
{
  "response": {
    "status": 401,
    "message": "Unauthorized",
    "url": "http://localhost:3000/sign-out"
  },
  "data": {
    "errors": "Unauthorized"
  }
}
```

### 💰 User Wallet

#### User Balance

**Request**
```
curl --location 'http://localhost:3000/wallet' \
--header 'Content-Type: application/json'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet"
  },
  "data": {
    "id": 1,
    "balance": 300
  }
}
```

#### Teams Balance

**Request**
```
curl --location 'http://localhost:3000/wallet/teams-balance' \
--header 'Content-Type: application/json'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet/teams-balance"
  },
  "data": [
    {
      "id": 2,
      "updated_at": "2024-10-16T05:11:52.230Z",
      "name": "Gresini",
      "balance": 150
    }
  ]
}
```

#### Stocks Balance

**Request**
```
curl --location 'http://localhost:3000/wallet/stocks-balance' \
--header 'Content-Type: application/json'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet/stocks-balance"
  },
  "data": [
    {
      "id": 3,
      "updated_at": "2024-10-14T18:45:00.044Z",
      "name": "Tesla, Inc.",
      "symbol": "TSLA",
      "balance": 1000
    }
  ]
}
```

#### Deposit

**Request**
```
curl --location 'http://localhost:3000/wallet/deposit' \
--header 'Content-Type: application/json' \
--data '{
    "wallet": {
        "amount": 150.0
    }
}'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet/deposit"
  },
  "data": {
    "message": "Deposit successful",
    "amount": 150,
    "balance": 450
  }
}
```

#### Withdraw

**Request**
```
curl --location 'http://localhost:3000/wallet/withdraw' \
--header 'Content-Type: application/json' \
--data '{
    "wallet": {
        "amount": 100.0
    }
}'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet/withdraw"
  },
  "data": {
    "message": "Withdrawal successful",
    "amount": 100,
    "balance": 350
  }
}
```

#### Transfer

**Request**
```
curl --location 'http://localhost:3000/wallet/transfer' \
--header 'Content-Type: application/json' \
--data '{
    "transfer": {
        "target_type": "Team", // User, Team, Stock
        "target_id": 1,
        "amount": 50.0
    }
}'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/wallet/transfer"
  },
  "data": {
    "message": "Transfer successful",
    "amount": 50,
    "balance": 300
  }
}
```

**Response (failed)**
```json
{
  "response": {
    "status": null,
    "message": null,
    "url": "http://localhost:3000/wallet/transfer"
  },
  "data": {
    "error": "Insufficient balance"
  }
}
```

### 🤝 User Transaction

#### Index

**Request**
```
curl --location 'http://localhost:3000/transactions?type=&_order=' \
--header 'Content-Type: application/json'
```

**Response (success)**
```json
{
  "response": {
    "status": 200,
    "message": "OK",
    "url": "http://localhost:3000/transactions?type=&_order="
  },
  "data": [
    {
      "id": 25,
      "created_at": "2024-10-16T05:11:52.259Z",
      "type": "CreditTransaction",
      "source_wallet": null,
      "target_wallet": "Gresini",
      "amount": 50
    },
    {
      "id": 24,
      "created_at": "2024-10-16T05:11:52.219Z",
      "type": "DebitTransaction",
      "source_wallet": "John Doe",
      "target_wallet": null,
      "amount": 50
    },
    {
      "id": 23,
      "created_at": "2024-10-16T05:11:22.966Z",
      "type": "CreditTransaction",
      "source_wallet": null,
      "target_wallet": "John Doe",
      "amount": 350
    },
    ...
  ]
}
```

## 🎯 Goal

### Requirements

- Based on relationships every entity e.g. User, Team, Stock or any other should have their own defined "wallet" to which we could transfer money or withdraw.
- Every request for credit/debit (deposit or withdraw) should be based on records in database for given model.
- Every instance of a single transaction should have proper validations against required fields and their source and targetwallet, e.g. from who we are taking money and transferring to whom? (Credits == source wallet == nil, Debits == targetwallet == nil).
- Each record should be created in database transactions to comply with ACID standards.
- Balance for given entity (User, Team, Stock) should be calculated by summing records.

### Tasks

1. Architect generic wallet solution (money manipulation) between entities (User, Stock, Team or any other)
2. Create model relationships and validations for achieving proper calculations of every wallet, transactions
3. Use STI (or any other design pattern) for proper money manipulation
4. Apply your own sign in (new session solution, no sign up is needed) without any external gem
5. Create a LatestStockPrice library (in lib folder in "gem style") for "price", "prices" and "price_all" endpoints - https://rapidapi.com/suneetk92/api/latest-stock-price
