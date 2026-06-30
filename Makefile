DB_SOURCE ?= postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres --network bank-network -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=simple_bank -d postgres:12-alpine
createdb:
	docker exec -it postgres createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:k7Q6hht4YxxfXM6tXTeq@simple-bank.c1ee86000203.eu-west-1.rds.amazonaws.com:5432/simple_bank" -verbose up

sqlc:
	sqlc generate	



migratedown:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose down


test:
	go test -v -cover ./...


server:
	go run main.go




.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server