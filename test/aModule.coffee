module.exports = require('..') require, (require, module, exports) ->
  fs = require 'fs'
  exports.getFs = -> fs

  path = require 'path', mockAs: 'thePath'
  exports.getPath = -> path

  adep = require './aDependency'
  exports.getADep = -> adep

