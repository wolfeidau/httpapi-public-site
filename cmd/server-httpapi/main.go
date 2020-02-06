package main

import (
  "github.com/aws/aws-lambda-go/lambda"
  "github.com/labstack/echo/v4"
  "github.com/wolfeidau/httpapi-public-site/internal/echoadapter"
)


func main() {

  e := echo.New()
  e.Static("/", "public")
  
  echolambda := echoadapter.New(e)

  lambda.Start(echoadapter.Handler(echolambda))
}