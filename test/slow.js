
var should = require('should');
var fs = require('fs');


describe('independence', function() {

  var aModule = null;


  describe('normal usage', function() {

    it('should allow to require the module as normal', function() {
      (function() {
        return aModule = require('./aModule')
      }).should.not.throw()
      aModule.should.be.type('object')
    })

    it('should provide the original module by default', function() {
      aModule.getFs().should.be.exactly(fs)
    })

    it('should correctly load another module that uses independence', function() {
      aModule.getADep().should.be.exactly('*aDependency*')
    })

    it('should correctly inject the original module', function() {
      (aModule.module === aModule.originalModule).should.be.true
    })

  })


  describe('dependingOn', function() {

    it('should provide the overridden module', function() {
      aModule.dependingOn({
        fs: 'xxx'
      }).getFs().should.be.exactly('xxx')
    })

    it('should provide the original module when not overridden', function() {
      aModule.dependingOn({}).getFs().should.be.exactly(fs)
    })

    it('should correctly clone the original module', function() {
      (aModule.module !== aModule.originalModule).should.be.true
      aModule.module.id.should.match(/aModule.js/)
    })

  })


  describe('dependingOnlyOn', function() {

    it('should provide the overridden module', function() {
      aModule.dependingOnlyOn({
        fs: 'yyy'
      }).getFs().should.be.exactly('yyy')
    })

    it('should provide undefined when a module is not provided', function() {
      (aModule.dependingOnlyOn({}).getFs() === void 0).should.be.true
    })

    it('should work with multiple objetcs', function() {
      var obj1 = {
        fs: 'mock to be overridden'
      }
      var obj2 = {
        fs: 'overriding mock'
      }
      aModule.dependingOnlyOn(obj1, obj2).getFs().should.be.exactly('overriding mock')
    })

    it('should mock names when provided', function() {
      aModule.dependingOnlyOn({
        path: 'wrong',
        thePath: 'right'
      }).getPath().should.be.exactly('right')
    })

    it('should guess a relative dependency name', function() {
      aModule.dependingOnlyOn({
        aDependency: 'mockDependency'
      }).getADep().should.be.exactly('mockDependency')
    })

  })
})

