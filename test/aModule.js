module.exports = require('..')(require, function(require, module, exports) {

  var fs = require('fs')
  exports.getFs = function() {return fs}

  var path = require('path', {mockAs: 'thePath'})
  exports.getPath = function() {return path}

  var adep = require('./aDependency')
  exports.getADep = function() {return adep}
})

