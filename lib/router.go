package lib

import (
  "log"
  "net/http"
  "github.com/julienschmidt/httprouter"
)

// the following is inspired by the gin framework

// this router defines each action to take for an URI including the middlewares
type Router struct {
  // path that this engine takes care of relative to the parent
  path string
  // the list of functions to run on a request
  funcList []ContextFunc
  // the router to use as the main entity
  router *httprouter.Router
}

// Bundle all parameters into the context to make it easier to push important
// data into functions.
type Context struct {
  // the current request
  Request *http.Request
  // the response
  Response http.ResponseWriter
  // parameters provided by the router
  Params httprouter.Params

  // the list of functions to run
  funcList []ContextFunc
  // the current position in the function list
  current int
}

// the func type for internal routes
type ContextFunc func(*Context) error

func NewRouter() *Router {
  return &Router{"", make([]ContextFunc, 0), httprouter.New()}
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

func (r *Router) Use(middleware ContextFunc) {
  r.funcList = addToFuncList(r.funcList, middleware)
}

func (router *Router) addRoute(method, path string, target ContextFunc) {
  router.router.Handle(
      method,
      router.path + path,
      func(response http.ResponseWriter,
           request  *http.Request,
           params   httprouter.Params) {
    ctx := &Context{
      request,
      response,
      params,
      addToFuncList(router.funcList, target),
      0,
    }
    for i := 0; i < len(ctx.funcList); i++ {
      ctx.funcList[i](ctx)
    }
  })
}

func (r *Router) Start() {
  log.Print("Starting to listen for incoming requests ...")
  log.Fatal(http.ListenAndServe(":9292", r.router))
}

func addToFuncList(list []ContextFunc, element ContextFunc) []ContextFunc {
  new_list := make([]ContextFunc, len(list) + 1)
  copy(new_list, list)
  new_list[len(list)] = element
  return new_list
}
