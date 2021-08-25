SHELL := /bin/bash
.PHONY: all clean

pantegana-dir := $(shell pwd)

DOMAIN = localhost
IP = 127.0.0.1

all: gencert build-client-nix build-client-win build-server

# feel free to change the cert's details in -subj.
gencert:
	mkdir -p cert; \
		openssl genrsa -out ./cert/ca.key 2048; \
		openssl req -new -x509 -days 3650 -key ./cert/ca.key -subj "/C=US/ST=Hawaii/L=The Sewers/O=Pantegana, Inc./CN=Pantegana Root CA" -out ./cert/ca.crt; \
		openssl req -newkey rsa:2048 -nodes -keyout ./cert/server.key -subj "/C=US/ST=Hawaii/L=The Sewers/O=Pantegana, Inc./CN=$(DOMAIN)" -out ./cert/server.csr; \
		openssl x509 -req -extfile <(printf "subjectAltName=DNS:$(DOMAIN),IP:$(IP)") -days 3650 -in ./cert/server.csr -CA ./cert/ca.crt -CAkey ./cert/ca.key -CAcreateserial -out ./cert/server.crt; 
	

# run gencerts before building client and server singularlty.

build-client-nix32: # does not get run by `all:`
	mkdir -p out;
		cd ./client/; \
		go generate; \
		sed -i "/^package main/c\package client" cert.go; \
		cd ../main/client/; \
		GOARCH=386 go build -o client.bin; \
		mv client.bin $(pantegana-dir)/out/client.bin;

build-client-win32: # does not get run by `all:`
	mkdir -p out;
		cd ./client/; \
		go generate; \
		sed -i "/^package main/c\package client" cert.go; \
		cd ../main/client/; \
		GOOS=windows GOARCH=386 go build -o client.exe; \
		mv client.exe $(pantegana-dir)/out/client.exe;

build-client-nix:
	mkdir -p out;
		cd ./client/; \
		go generate; \
		sed -i "/^package main/c\package client" cert.go; \
		cd ../main/client/; \
		go build -o client.bin; \
		mv client.bin $(pantegana-dir)/out/client.bin;

build-client-win:
	mkdir -p out;
		cd ./client/; \
		go generate; \
		sed -i "/^package main/c\package client" cert.go; \
		cd ../main/client/; \
		GOOS=windows GOARCH=amd64 go build -o client.exe; \
		mv client.exe $(pantegana-dir)/out/client.exe;

build-server:
	mkdir -p out; \
		cd ./server/; \
		go generate; \
		sed -i "/^package main/c\package server" cert.go; \
		cd ../main/server; \
		go build -o server.bin; \
		mv server.bin $(pantegana-dir)/out/server.bin;

clean:
	rm -fr ./out; \
		rm -fr ./cert; \
		rm -f ./server/cert.go; \
		rm -f ./client/cert.go;

run-client:
	mkdir -p out;
		cd ./client/; \
		go generate; \
		sed -i "/^package main/c\package client" cert.go; \
		cd ../main/client/; \
		go build -o client.bin; \
		mv client.bin $(pantegana-dir)/out/client.bin; \
		$(pantegana-dir)/out/client.bin;

run-server:
	mkdir -p out; \
		cd ./server/; \
		go generate; \
		sed -i "/^package main/c\package server" cert.go; \
		cd ../main/server; \
		go build -o server.bin; \
		mv server.bin $(pantegana-dir)/out/server.bin; \
		$(pantegana-dir)/out/server.bin;
