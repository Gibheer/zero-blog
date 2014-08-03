package main

import (
  "fmt"
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller"
)

func main() {
  router := lib.NewRouter()
  authentication := router.NewGroup("/admin")
  controller.DefineRoutes(router)
  router.Start()
}
