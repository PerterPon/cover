
## Cover

简介...

### Basic Useage

```
var cover = require( 'node-cover' );

var app   = cover();

var fs    = require( 'fs' );

var thunkify = require( 'thunkify' );

var readFile = thunkify( fs.readFile );

// connect 中间件
app.use( function( req, res, next ){

  console.log( req.url );

  next();

} );

// koa 中间件
app.use( function( req, res, next ){
  
  yield next;

} );

app.use( function( req, res, next ){

  var fileContent = yield readFile './test.txt', 'utf-8'

  res.end( fileContent );

} );

app.listen( 8000 );

```

### 全局的错误事件

```
var cover = require( 'node-cover' );

var app   = require( 'app' );


// normal function

app.use( function( req, res, next ) {
  
  throw new Error( 'this is an error' );

} );

// or generator

app.use( function *( req, res, bext ){
  
  throw new Error( 'this is an error' );

} )

app.on( 'error', function( error ){
  console.log( error.message, error.stack );
) };

app.listen( 8000 );

```
