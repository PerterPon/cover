
"use strict";

if ( require.extensions['.coffee'] ) {
  module.exports = require( './lib/index.coffee' );
} else {
  module.exports = require( './out/lib/index.js' );
}
