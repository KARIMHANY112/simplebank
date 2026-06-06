postgres:
	docker run --name postgres --network bank-network -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=simple_bank -d postgres:12-alpine
createdb:
	docker exec -it postgres createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose up

sqlc:
	sqlc generate	



migratedown:
	migrate -path db/migration -database "postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable" -verbose down


test:
	go test -v -cover ./...


server:
	go run main.go




.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server