module.exports = require('..')(require, function(require, module, exports) {

  var fs = require('fs')
  this.getFs = function() {return fs}

  var path = require('path', {mockAs: 'thePath'})
  exports.getPath = function() {return path}

  var adep = require('./aDependency')
  module.exports.getADep = function() {return adep}
})

