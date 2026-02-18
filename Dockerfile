# -------- Build Stage --------
FROM golang:1.24 AS builder

WORKDIR /app

# Copy go mod files first (better caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy entire project
COPY . .
COPY .env .

# Build binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app ./cmd/server/main.go

# -------- Runtime Stage --------
FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/url-shortner/go-with-redis .
COPY --from=builder /app/url-shortner/go-with-redis .env .

EXPOSE 8080

CMD ["./app"]
