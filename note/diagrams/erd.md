# Diagram ERD

```mermaidjs
erDiagram

    USER {
        int id PK
        string name
        string email
        string password_digest
    }

    TEAM {
        int id PK
        string name
    }

    STOCK {
        int id PK
        string name
        string symbol
    }

    WALLET {
        int id PK
        decimal balance
        int walletable_id FK
        string walletable_type
    }

    TRANSACTION {
        int id PK
        string type
        decimal amount
        int source_wallet_id FK
        int target_wallet_id FK
    }

    USER ||--o| WALLET : "has one"
    TEAM ||--o| WALLET : "has one"
    STOCK ||--o| WALLET : "has one"

    TRANSACTION }o--|| WALLET : "belongs to (source)"
    TRANSACTION }o--|| WALLET : "belongs to (target)"

    %% WALLET }o--|| USER : "walletable (polymorphic)"
    %% WALLET }o--|| TEAM : "walletable (polymorphic)"
    %% WALLET }o--|| STOCK : "walletable (polymorphic)"
    %% WALLET ||--o{ TRANSACTION : "source_transactions"
    %% WALLET ||--o{ TRANSACTION : "target_transactions"
```
