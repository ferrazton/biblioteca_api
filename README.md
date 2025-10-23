# README

# Biblioteca API

A RESTful backend built with **Ruby on Rails** for managing authors and materials (books, articles, and videos).

---

## Features

- **User authentication** with Devise + JWT  
- **CRUD endpoints** for:
  - Users (sign up / sign in)
  - Authors (persons and institutions)
  - Materials (books, articles, videos)
- **Filtering and pagination** on materials
- **Authorization** — users can only update or delete their own materials
- **Automatic data enrichment** via the OpenLibrary API (for books)
- **Test coverage >80%** with RSpec + SimpleCov

---

## Tech Stack

| Category | Tools |
|-----------|--------|
| Language | Ruby 3.4.0 |
| Framework | Ruby on Rails 7.2 |
| Database | PostgreSQL |
| Auth | Devise + devise-jwt |
| Testing | RSpec, FactoryBot, SimpleCov |
| External API | OpenLibrary |
| Documentation | Postman |

---

## Setup

### Requirements
- Ruby 3.4+
- PostgreSQL 14+
- Bundler (`gem install bundler`)

### Installation

```bash
git clone https://github.com/ferrazton/biblioteca_api.git
cd biblioteca_api
bundle install
```

## Database Setup
Create the PostgreSQL role (if not already existing):
```sql
CREATE ROLE biblioteca WITH LOGIN PASSWORD 'biblioteca';
ALTER ROLE biblioteca CREATEDB;
```
Then:
```bash
bin/rails db:create db:migrate
```

## Running the API
Start the development server:
```bash
bin/rails s
```
Default URL:
```
http://localhost:3000
```

## Authentication
### Sign Up
POST /users
```json
{
  "user": {
    "email": "example@email.com",
    "password": "123456",
    "password_confirmation": "123456"
  }
}
```
### Sign In
POST /users/sign_in
```json
{
  "user": {
    "email": "example@email.com",
    "password": "123456"
  }
}
```
Response headers include:
```
Authorization: Bearer <your_token>
```
Use this token for authenticated requests:
```pgsql
Authorization: Bearer <token>
Content-Type: application/json
Accept: application/json
```

## API Overview
### Authors
| Method | Endpoint      | Auth | Description                               |
|--------|---------------|------|-------------------------------------------|
| GET    | /authors      | No   | List all authors                          |
| GET    | /authors/:id   | No   | Retrieve author details                   |
| POST   | /authors      | Yes  | Create new author (person or institution) |

### Materials
| Method | Endpoint        | Auth | Description                                                       |
|--------|-----------------|------|-------------------------------------------------------------------|
| GET    | /materials      | No   | List materials with pagination and filters                        |
| GET    | /materials/:id   | No   | Retrieve a specific material                                      |
| POST   | /materials      | Yes  | Create a new material (auto-fills data for books via OpenLibrary) |
| PATCH  | /materials/:id      | Yes  | Update a material (only by the owner)                             |

### Filtering examples
```
GET /materials?title=estrangeiro
GET /materials?author=camus
GET /materials?status=published
```

## Postman Collection
You can test all endpoints directly via **Postman**.
### Import the collection
1. From the repository root, download and import the file:

[biblioteca_api.postman_collection.json](./biblioteca_api.postman_collection.json)

2. In postman, click **Import** -> **File**, then select it.

### Environment variables

| Variable   | Example     |
|--------|-----------------|
| base_url    | http://localhost:3000      |
| token    | (filled automatically after sign in)      |

### Example request flow
1. POST /users -> create a new user
2. POST /users/sign_in -> obtain JWT (auto-saved to token)
3. POST /authors -> create author
4. POST /materials -> create book, article, or video
5. GET /materials?author=Camus -> filter results
6. PATCH /materials/:id

## Testing
Prepare the test database
```bash
$env:RAILS_ENV = "test"
bundle exec rails db:prepare
```
Run all tests:
```bash
bundle exec rspec
```
View coverage report locally:
```bash
coverage/index.html
```
**Current coverage**: ~82%

## Author

**Antonio Ferraz**  
📧 [aaf3@cin.ufpe.br](mailto:aaf3@cin.ufpe.br)  
💻 [github.com/ferrazton](https://github.com/ferrazton)