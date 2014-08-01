package main

import (
  "fmt"
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller"
)

func main() {
  router := lib.NewRouter()
  router.Use(func(c *lib.Context) error {
    fmt.Fprint(c.Response, "Hello says the middleware!")
    return nil
  })
  controller.DefineRoutes(router)
  router.Start()
}
