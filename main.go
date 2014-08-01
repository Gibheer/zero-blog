package main

import (
  "fmt"
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller"
)

func main() {
  router := lib.NewRouter()
  authentication := router.NewGroup("/admin")
  authentication.Use(func(c *lib.Context) error {
    c.Response.Header().Add("Content-Type", "text/html")
    fmt.Fprint(c.Response, "Hello says the middleware!<br />")
    return nil
  })
  authentication.Get("/", func(c *lib.Context) error {
    fmt.Fprint(c.Response, "Admin panel, yay!")
    return nil
  })
  controller.DefineRoutes(router)
  router.Start()
}
