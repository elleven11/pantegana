# Pantegana - a RAT/Botnet coded in Go
FOR EDUCATIONAL AND RESEARCH USE ONLY

## Features:
 - HTTPS covert channel for communications
 - Undetected by AVs by nature
 - Direct command execution (not using bash or sh)
 - Multiple sessions handling
 - File Upload/Download
 - System fingerprinting

## TODO:
 - Full Windows and OSx integration (currently it's partial)
 - Gracefully closing sessions server-side on client-side crash
 - bash/cmd/psh shell dropping
 - TOR routing?

## Usage:
To build the program you will need `openssl` and `go-bindata`.  
Use: `go get -u github.com/go-bindata/go-bindata/...`  
When running `make` you will need to specify any external IP or domain to include in the SSL certificate.  
Example: `make IP=1.1.1.1 DOMAIN=example.com`.  
If you do not want to specify an IP or a domain, use `127.0.0.1` and `localhost` respectively.  
Example: `make IP=127.0.0.1 DOMAIN=localhost`
