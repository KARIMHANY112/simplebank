postgres:
	docker run --name postgres -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres:12-alpine
	powershell -Command "while (-not (docker exec postgres pg_isready -U postgres 2>$$null | Select-String 'accepting')) { Start-Sleep -Seconds 1 }"
	@echo Postgres ready.
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


.PHONY: postgres createdb dropdb migrateup migratedown sqlc test