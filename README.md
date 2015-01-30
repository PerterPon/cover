
## Cover

简介...

### Basic Usage

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
app.use( function *( req, res, next ){
  
  yield next;

} );

app.use( function *( req, res, next ){

  var fileContent = yield readFile( './test.txt', 'utf-8' );

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

### 在中间件中捕获错误

#### connect式的中间件

```
app.use( function *( req, res, next ){
  try {
    yield next
  } catch ( e ) {
    console.log( e )
  }
} );

app.use( function( req, res, next ){
  throw new Error( 'this is an error' );
} );
```

#### koa式的中间件

```
app.use( function *( req, res, next ){
  try {
    yield next;
  } catch( e ) {
    console.log( e );
  }
  
} );

app.use( function *( req, res, next ){
  throw new Error( 'this is an error' );
} )
```
