module.exports = require('..') (depend, {exports}) ->

  fs = depend 'fs'

  exports.getFs = -> fs

