package lib

import (
  "io/ioutil"
  "text/template"
  "gopkg.in/yaml.v1"
)

type Settings struct {
  Connection string
}

type Environment struct {
  // settings from the config file
  Config *Settings
  // the database connection pool
  DB *Database
  // the base template system
  Template *template.Template
}

func LoadConfiguration() (*Settings, error) {
  configfile, err := ioutil.ReadFile("config.yml")
  if err != nil {
    return nil, err
  }
  settings := Settings{}
  err = yaml.Unmarshal(configfile, &settings)
  if err != nil {
    return nil, err
  }
  return &settings, nil
}
