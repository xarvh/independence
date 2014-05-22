should = require 'should'
fs = require 'fs'


{getNameFromDependency} = require '..'


describe 'independence', ->


  describe 'independence()', ->

    aModule = null

    it 'should allow to require the module as normal', ->
      (-> aModule = require './aModule').should.not.throw()
      aModule.should.be.type 'object'

    it 'should provide the original module by default', ->
      aModule.getFs().should.be.exactly fs


    describe 'dependingOn', ->

      it 'should provide the overridden module', ->
        aModule.dependingOn(fs: 'xxx').getFs().should.be.exactly 'xxx'

      it 'should provide the original module when not overridden', ->
        aModule.dependingOn({}).getFs().should.be.exactly fs


    describe 'dependingOnlyOn', ->

      it 'should provide the overridden module', ->
        aModule.dependingOnlyOn(fs: 'yyy').getFs().should.be.exactly 'yyy'

      it 'should provide undefined when a module is not provided', ->
        (aModule.dependingOnlyOn({}).getFs() is undefined).should.be.true


  describe 'getNameFromDependency()', ->

    it 'should work on different names', ->
      getNameFromDependency('monkey').should.be.equal 'monkey'
      getNameFromDependency('module.coffee').should.be.equal 'module'
      getNameFromDependency('banana.x.coffee').should.be.equal 'banana'
      getNameFromDependency('../comon/../lib/tables/myTable').should.be.equal 'myTable'
      getNameFromDependency('../comon/../lib/tables/myTable.js').should.be.equal 'myTable'

    it 'should throw if dependency is invalid', ->
      (-> getNameFromDependency undefined).should.throw /Invalid module name/
      (-> getNameFromDependency {}).should.throw /Invalid module name/
      (-> getNameFromDependency '').should.throw /Invalid module name/
      (-> getNameFromDependency '.').should.throw /Invalid module name/
      (-> getNameFromDependency '/.').should.throw /Invalid module name/

