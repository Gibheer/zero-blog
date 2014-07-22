package lib

import (
  "log"
  "net/http"
  "github.com/julienschmidt/httprouter"
)

// Bundle all parameters into the context to make it easier to push important
// data into functions.
type Context struct {
  Request *http.Request
  Response http.ResponseWriter
  params httprouter.Params
}

// the func type for internal routes
type ContextFunc func(*Context) error

type Router struct {
  router *httprouter.Router
}

func NewRouter() *Router {
  return &Router{httprouter.New()}
}

func (r *Router) Get(path string, target ContextFunc) {
  r.addRoute("GET", path, target)
}

func (r *Router) Post(path string, target ContextFunc) {
  r.addRoute("POST", path, target)
}

func (r *Router) Put(path string, target ContextFunc) {
  r.addRoute("PUT", path, target)
}

func (r *Router) Delete(path string, target ContextFunc) {
  r.addRoute("DELETE", path, target)
}

func (r *Router) addRoute(method, path string, target ContextFunc) {
  r.router.Handle(method, path, func(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
    log.Println("Handling Request for ", path)
    if err := target(&Context{r, w, p}); err != nil {
      log.Fatal(err)
    }
  })
}

func (r *Router) Start() {
  log.Print("Starting to listen for incoming requests ...")
  log.Fatal(http.ListenAndServe(":9292", r.router))
}
