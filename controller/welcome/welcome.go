package welcome

import (
  "fmt"
  "github.com/gibheer/zero-blog/lib"
)

func Welcome(c *lib.Context) error {
  fmt.Fprint(c.Response, "Hello World!")
  return nil
}
