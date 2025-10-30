FROM node:20-alpine AS frontend-builder

WORKDIR /app
COPY web/vue/package.json web/vue/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY web/vue ./
RUN yarn build

FROM golang:1.23-alpine AS backend-builder

RUN apk add --no-cache git make

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
COPY --from=frontend-builder /app/dist ./web/vue/dist

RUN go install github.com/rakyll/statik@latest && \
    go generate ./... && \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o gocron ./cmd/gocron

FROM alpine:latest

RUN apk add --no-cache ca-certificates tzdata && \
    addgroup -S app && \
    adduser -S -g app app

WORKDIR /app

COPY --from=backend-builder /app/gocron .

RUN chown -R app:app ./

EXPOSE 5920

USER app

ENTRYPOINT ["/app/gocron", "web"]
