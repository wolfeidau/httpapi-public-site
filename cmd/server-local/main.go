package main

import (
	"log"

	"github.com/wolfeidau/httpapi-public-site/internal/server"
)

func main() {

	e := server.Routes()

	log.Fatal(e.Start(":9000"))
}
