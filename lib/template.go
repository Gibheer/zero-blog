package lib

import (
  "errors"
  "log"
  "io/ioutil"
  "os"
  "path/filepath"
  "text/template"
)

type fileList struct {
  len_base int
  t *template.Template
}

// load all templates found as childs of the path
func LoadTemplates(path string) (*template.Template, error) {
  // TODO add better check for template directory
  if path == "" { return nil, errors.New("template path empty") }
  f := &fileList{len(path), &template.Template{}}

  err := filepath.Walk(path, f.scanFile)
  if err != nil {
    return nil, err
  }
  return f.t, nil
}

func (f *fileList) scanFile(path string, info os.FileInfo, err error) error {
  if err != nil { log.Println(`Error with file:`, path, `-`, err) }

  if info.IsDir() {
    log.Print(`Scanning '`, path, `' for templates`)
  }
  if !info.IsDir() && path[len(path) - 5:] == `.tmpl` {
    name := path[f.len_base + 1 : len(path) - 5]
    log.Println(`Adding:`, name)
    f.t.New(name).Parse(read_file_content(path))
  }
  return nil
}

func read_file_content(path string) string {
  content, err := ioutil.ReadFile(path)
  if err != nil {
    return ""
  }
  return string(content)
}
