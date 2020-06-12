package server

import "github.com/labstack/echo/v4"

// Routes and echo are configured
func Routes() *echo.Echo {
	e := echo.New()
	e.Static("/", "public")

	return e
}
