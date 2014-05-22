should = require 'should'
fs = require 'fs'


describe 'independence', ->

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

