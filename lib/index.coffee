
# /*
#   Index
# */
# Author: PerterPon@gmail.com
# Create: Sun Jan 25 2015 20:52:16 GMT+0800 (CST)
#

"use strict"

http    = require 'http'

co      = require 'co'

assert  = require 'assert'

compose = require 'koa-compose'

events  = require 'events' 

thunkify = require 'thunkify'

class Index extends events.EventEmitter

  middleware : []

  constructor : ->
    super()

    # init http server
    @http = http.createServer @callback()

  # /**
  #  * [listen description]
  #  * @param  {[type]} args... [description]
  #  * @return {[type]}         [description]
  ##
  listen : ( args... ) ->
    @http.listen.apply @http, args

  # /**
  #  * [callback description]
  #  * @return {Function} [description]
  ##
  callback : ->
    { respond, middleware } = @
      
    # compose all of the middlewares
    gen = compose middleware

    # wrap by co
    fn  = co.wrap gen

    # return this middleware to http server
    ( req, res ) =>
      fn.call { req, res }
        .catch @onerror req, res

  # /**
  #  * [onerror emit error event]
  #  * @param  {[type]} error [description]
  #  * @return {[type]}       [description]
  ##
  onerror : ( req, res ) ->
    ( error ) =>

      # if the error param was not an Error param.
      assert error instanceof Error, "non-error thrown: #{error}"

      # delegate
      @emit 'error', error

      try
        console.error '=========catched error============'
        console.log error.message, error.stack
        console.error '=================================='

      # if this connect was not able to write, ignore it.
      unless res.writable
        console.warn 'response was not able to write, so ignore it!'

      else
        # default to 500
        status = 500

        { message, code } = error or {}

        # ENOENT support
        if 'ENOENT' is code
          status   = 404

        # set the response status
        res.status = status

        # if none error message, set default
        message   ?= 'some thing wrong'

        headers    =
          "Content-Length" : Buffer.byteLength message
          # force text/plain
          "Content-Type"   : "text/plain"

        # write response header
        res.writeHeader status, headers

        # trans to string.
        res.end "#{message}"

  # /**
  #  * [use way to use middleware]
  #  * @param  {[Function or Generator]} wm [description]
  #  * @return {[type]}    [description]
  ##
  use : ( wm ) ->

    assert wm and 'fucntion' isnt typeof wm, 'app.use() requires a function!'

    if 'Function' is wm.constructor.name
      wm = thunkify wm

    # wrap fn to adapt the param way.
    fn = ( next ) ->
      { req, res } = @

      # if this wm is an generator
      if 'GeneratorFunction' is wm.constructor.name
        yield wm req, res, next
      else
        # run this wm, the next passed to the wm was not the co next, it was wrapped by thunkify.
        yield wm req, res

        # when the function middleware called next(), we go to here, and we call yield next, just like 
        # generator widdleware call yield next, go to the next middleware.
        yield next

    @middleware.push fn
    @

  # /**
  #  * [respond add something when an request was responed]
  #  * @param  {Function} next [description]
  #  * @return {[type]}        [description]
  ##
  respond : ( next )->

    # set cover header
    res.setHeader 'Server: Cover'

    # continue to the biz wms
    yield next

module.exports = -> new Index
