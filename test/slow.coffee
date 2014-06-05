should = require 'should'
fs = require 'fs'


describe 'independence', ->

  aModule = null

  describe 'normal usage', ->

    it 'should allow to require the module as normal', ->
      (-> aModule = require './aModule').should.not.throw()
      aModule.should.be.type 'object'

    it 'should provide the original module by default', ->
      aModule.getFs().should.be.exactly fs

    it 'should correctly load another module that uses independence', ->
      aModule.getADep().should.be.exactly '*aDependency*'


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

    it 'should work with multiple objetcs', ->
      obj1 = fs: 'mock to be overridden'
      obj2 = fs: 'overriding mock'
      aModule.dependingOnlyOn(obj1, obj2).getFs().should.be.exactly 'overriding mock'

    it 'should mock names when provided', ->
      aModule.dependingOnlyOn(path: 'wrong', thePath: 'right').getPath().should.be.exactly 'right'

    it 'should guess a relative dependency name', ->
      aModule.dependingOnlyOn(aDependency: 'mockDependency').getADep().should.be.exactly 'mockDependency'

