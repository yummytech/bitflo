var bitcoin = require("https://s3.amazonaws.com/helloblock-cdn/bitcoinjs-lib.min.js")
var helloblock = require('https://s3.amazonaws.com/helloblock-cdn/helloblock-js.min.js')({
  network: 'testnet'
})
  
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
