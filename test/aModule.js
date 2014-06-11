originalModule = module

require('..')(require, module, function(require, module, exports) {

  var fs = require('fs')
  this.getFs = function() {return fs}

  var path = require('path', {mockAs: 'thePath'})
  exports.getPath = function() {return path}

  var adep = require('./aDependency')
  module.exports.getADep = function() {return adep}

  module.exports.module = module
  module.exports.originalModule = originalModule
})

