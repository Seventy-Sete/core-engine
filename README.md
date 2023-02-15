# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Generate database encryption key

```bash
docker compose run web bin/rails db:encryption:init
```

Build image
```bash
docker compose build
```

up container
```bash
docker compose up
```

Run migration
```bash
docker compose run web bin/rails db:migrate
```

Run test
```bash
docker compose run web bin/rails test
```
