package lib

import (
  "errors"
  "database/sql"
  pq "github.com/lib/pq"
)

type Database struct {
  Conn *sql.DB
}

func (d *Database) Query(query string) (*sql.Rows, error) {
  res, err := d.Conn.Query(query)
  if err != nil {
    err := err.(*pq.Error)
    return nil, errors.New(err.Code.Name())
  }
  return res, nil
}

func NewDatabase(connection string) (*Database, error) {
  if connection == "" {
    return nil, errors.New("No connection string given! Check the config.yml file!")
  }
  DB, err := sql.Open("postgres", connection)
  if err != nil {
    return nil, err
  }
  return &Database{DB}, nil
}
