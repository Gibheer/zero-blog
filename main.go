package main

import (
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller"
)

func main() {
  router := lib.NewRouter()
  controller.DefineRoutes(router)
  router.Start()
}
