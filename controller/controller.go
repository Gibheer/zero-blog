package controller

import (
  "github.com/gibheer/zero-blog/lib"
  "github.com/gibheer/zero-blog/controller/welcome"
)

func DefineRoutes(router *lib.Router) {
  router.Get("/", welcome.Welcome)
}
