
# /*
#   Index
# */
# Author: PerterPon@gmail.com
# Create: Sun Jan 25 2015 20:52:16 GMT+0800 (CST)
#

"use strict"

http   = require 'http'

co     = require 'co'

Router = require './router'

assert = require 'assert'

compose = require 'koa-compose'

class Index

  middleware : []

  # constructor : ->

  listen : ( args... ) ->
    { middleware } = @

    # init http server
    app = http.createServer @callback()

    # listen
    app.listen.apply app, args

  callback : ->
    { respond, middleware } = @
    
    # compose
    gen = compose middleware

    # wrap by co
    fn  = co.wrap gen

    ( req, res ) ->
      fn.call { req, res }

  use : ( wm ) ->
    assert wm and 'GeneratorFunction' is wm.constructor.name, 'app.use() requires a generator function'

    fn = ( next ) ->
      { req, res } = @
      yield wm req, res, next

    @middleware.push fn
    @

  respond : ( next )->
    yield next


module.exports = Index
