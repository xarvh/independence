Independence
============

[![Build Status](https://secure.travis-ci.org/xarvh/independence.png?branch=master)](http://travis-ci.org/xarvh/independence)

Module dependency injection for easy and ridiculously *fast* mocking.

Enables a module to quickly create clones of itself that have their dependencies mocked.


When writing the module
-----------------------
Wrap your module in `"require('independence')(require, module, (function(require, module, exports) {" + yourCode + "}))"`.

In CoffeeScript:
```coffee
# monkey.coffee

require('independence') require, module, (require, module, exports) ->

  moment = require 'moment'
  _ = require 'lodash', mockAs: '_'
  myService = require '../common/lib/services/myService'
  myDatabase = require '../common/lib/myDatabase', mockAs: 'database'

  exports.fling = ->
    console.log 'fling', moment().format 'YYYY-MM-DD'

  exports.swing = ->
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


# Provide only moment and leave all other dependencies undefined:
pureMonkey = monkey.dependingOnlyOn
  moment: -> format: -> 'Yip!'

pureMonkey.fling() # Will output `fling Yip!`
pureMonkey.swing() # Will fail because `_` is undefined
```


Other stuff you can do
----------------------

You can chain dependency objects:
```coffee
commonDependencies =
  _: require 'lodash'
  database: log: ->
  myService: -> 'serviced'

pureMonkey = monkey.dependingOnlyOn commonDependencies,
  moment: -> format: -> 'Yip!'
```


You can monkey-patch cleanly and nest <b>in</b>dependencies:
```coffee
database = require 'database'
fruitData = require 'fruitData' # depends on database
smootie = require 'smootie' # depends on fruitData

databaseTest = database.dependingOn()
databaseTest.getBananas = (callback) -> callback null, ['banana1', 'banana2']

smootieTest = smootie.dependingOn
  fruit: fruitData.dependingOn database: databaseTest
```

