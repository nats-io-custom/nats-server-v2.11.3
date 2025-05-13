.PHONY: all

all:
	go mod tidy || exit 1
	CGO_ENABLED=0 go build . || exit 1
	chmod +x ./nats-server || exit 1