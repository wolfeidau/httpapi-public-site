package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/wolfeidau/httpapi-public-site/internal/echoadapter"
	"github.com/wolfeidau/httpapi-public-site/internal/server"
)

func main() {

	e := server.Routes()

	echolambda := echoadapter.New(e)

	lambda.Start(echoadapter.Handler(echolambda))
}
