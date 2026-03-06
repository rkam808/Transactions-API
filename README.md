# 💰 Ledger API (Ruby on Rails)

## 🚀 Key Features
* **Secure Authentication:** Custom API Key strategy using `bcrypt` and header-based validation.
* **Pagination:** Powered by the `Pagy` gem for extremely low memory consumption.
* **Data Integrity:** MySQL 8 backend with strict validations and database-level constraints.
* **Developer Experience:** Fully Dockerized setup with automated `db:prepare` on startup.

## 🚦 Getting Started

### 1. Boot the Environment
Ensure Docker is installed and running, then execute:
```bash
docker-compose up --build
```

### 2. Run Go Tests
```bash
docker-compose run tester go test
```

## API Testing
Can be run via:
```bash
docker-compose run app rspec
```
