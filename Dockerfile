# ---- build stage ----
FROM golang:1.24 AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app ./cmd/server/main.go

# ---- runtime stage ----
FROM debian:bookworm-slim
WORKDIR /app

COPY --from=builder /app/app ./app
# OPTIONAL: don't bake .env into image (better to pass via compose)
# COPY .env ./.env

EXPOSE 8080
CMD ["./app"]
