Independence
============

[![Build Status](https://secure.travis-ci.org/xarvh/independence.png?branch=master)](http://travis-ci.org/xarvh/independence)

Module dependency injection for easy and fast mocking.

Enables a module to create clones of itself that have their dependencies mocked.


When writing the module
-----------------------
```coffee
# monkey.coffee

module.exports = require('independence') (depend) ->

  # Implicit require
  async = depend 'async'

  # Implicit require with path
  myDatabase = depend 'common/lib/myDatabase'

  # Implicit require with explicit mock target name
  _ = depend '_', 'lodash'

  # Explicit require, suitable for browserify
  moment = depend 'moment', require 'moment'


  # The actual module object
  fling: ->
    console.log 'fling', moment().format 'YYYY-MM-DD'

  swing: ->
    console.log 'swing', _.find [1, 2, 3, 5, 7], (n) -> n % 2 is 0
```


When using the module
---------------------
This works as normal:
```coffee
monkey = require './monkey'

monkey.fling() # Will output `fling 2014-05-23`
monkey.swing() # Will output `swing 2`
```


When testing the module
-----------------------
```coffee
monkey = require './monkey'

# Override moment, but leave all other dependencies nominal:
testMonkey = monkey.dependingOn
  moment: -> format: -> 'Yaaap!'

testMonkey.fling() # Will output `fling Yaaap!`
testMonkey.swing() # Will work as normal


# Provide only moment and leave all other dependenice undefined:
pureMonkey = monkey.dependingOnlyOn
  moment: -> format: -> 'Yip!'

pureMonkey.fling() # Will output `fling Yip!`
pureMonkey.swing() # Will fail because `_` is undefined
```


TODO
----

* Add unit tests against browserify
* Add support for relative paths

