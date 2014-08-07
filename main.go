package main

import (
  "log"
  "os"
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller"
)

func main() {
  environment, err := boot_system()
  if err != nil {
    log.Fatal("Boot crashed with message: ", err)
    os.Exit(1)
  }

  router := lib.NewRouter(environment)
  controller.DefineRoutes(router)
  router.Start()
}
