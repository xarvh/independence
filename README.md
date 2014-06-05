Independence
============

[![Build Status](https://secure.travis-ci.org/xarvh/independence.png?branch=master)](http://travis-ci.org/xarvh/independence)

Module dependency injection for easy and ridiculaously *fast* mocking.

Enables a module to quickly create clones of itself that have their dependencies mocked.


When writing the module
-----------------------
In CoffeeScript, just add `module.exports = require('independence') require, (require, module, exports) ->` on top and indent everything right.

```coffee
# monkey.coffee

module.exports = require('independence') require, (require, module, exports) ->

  moment = require 'moment'
  _ = depend require 'lodash', mockAs: '_'
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


# Provide only moment and leave all other dependenice undefined:
pureMonkey = monkey.dependingOnlyOn
  moment: -> format: -> 'Yip!'

pureMonkey.fling() # Will output `fling Yip!`
pureMonkey.swing() # Will fail because `_` is undefined
```


You can also chain dependency objects:
```coffee
commonDependencies =
  _: require 'lodash'
  database: log: ->
  myService: -> 'serviced'

pureMonkey = monkey.dependingOnlyOn commonDependencies,
  moment: -> format: -> 'Yip!'
```

