package lib

import (
  "log"
  "net/http"
  "github.com/julienschmidt/httprouter"
)

// the following is inspired by the gin framework

// this router defines each action to take for an URI including the middlewares
type Router struct {
  // the environment of the application with settings and database connection
  env *Environment
  // path that this engine takes care of relative to the parent
  path string
  // the list of functions to run on a request
  funcList []ContextFunc
  // the router to use as the main entity
  router *httprouter.Router
  // the parent router, if any
  parent *Router
}

// create a new router with the specific environment
func NewRouter(env *Environment) *Router {
  return &Router{env, "", make([]ContextFunc, 0), httprouter.New(), nil}
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
  // a direct link to the environment
  Env *Environment
}

// the func type for internal routes
type ContextFunc func(*Context) error

func (r *Router) fullpath(path string) string {
  if r.parent != nil {
    return r.parent.fullpath(r.path + path)
  }
  return r.path + path
}

func (r *Router) fullFuncList() []ContextFunc {
  if r.parent != nil {
    return append(r.parent.fullFuncList(), r.funcList...)
  }
  return r.funcList
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

func (router *Router) addRoute(method, path string, target ContextFunc) {
  router.router.Handle(
    method,
    router.fullpath(path),
    router.createHandleFunction(target),
  )
}

func (r *Router) createHandleFunction(target ContextFunc) httprouter.Handle {
  return func(
    response http.ResponseWriter,
    request  *http.Request,
    params   httprouter.Params) {

    ctx := &Context{
      request, response, params, append(r.fullFuncList(), target), 0, r.env,
    }
    for i := 0; i < len(ctx.funcList); i++ {
      ctx.funcList[i](ctx)
    }
  }
}

func (r *Router) Use(middleware ContextFunc) {
  r.funcList = append(r.funcList, middleware)
}

func (r *Router) NewGroup(path string) *Router {
  return &Router{r.env, path, make([]ContextFunc, 0), r.router, r}
}

func (r *Router) Start() {
  log.Print("Starting to listen for incoming requests ...")
  log.Fatal(http.ListenAndServe(":9292", r.router))
}
