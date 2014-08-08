package main

import (
  "github.com/gibheer/zero-blog/lib"
)

func boot_system() (*lib.Environment, error) {
  env := &lib.Environment{}
  settings, err := lib.LoadConfiguration()
  if err != nil {
    return env, err
  }
  env.Config = settings

  env.DB, err = lib.NewDatabase(settings.Connection)
  if err != nil {
    return env, err
  }
  env.Template, err = lib.LoadTemplates(`templates`)
  if err != nil {
    return env, err
  }

  return env, nil
}
