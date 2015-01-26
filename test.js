

require('coffee-script' ).register();

require( 'response-patch' );

var app = require( './lib/index' );

var a = new app();

a.use ( function *( req, res, next ) {

  yield next;

} )

a.use( function *( req, res, next ){
  yield next;
} );

a.use( function *( req, res, next ){

  try {
    res.send( '22222' );
  } catch ( e ){
    console.log( e, '1111111' );
  }

} );

a.listen( 4239 );
