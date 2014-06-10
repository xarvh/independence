
var independence = module.exports = function(localRequire, moduleInjector) {

  var makeModule = function(injectedRequire) {
    var modu1e = {exports: {}}
    moduleInjector.call(module.exports, injectedRequire, modu1e, modu1e.exports)
    return modu1e.exports
  }

  exportz = makeModule(localRequire)
  exportz.dependingOn = function() { return makeModule(independence.requireFactory(arguments, localRequire)) }
  exportz.dependingOnlyOn = function() { return makeModule(independence.requireFactory(arguments)) }
  return exportz
}


independence.requireFactory = function(mockArguments, localRequire) {
  var mocks = {}
  for (var index = 0; index < mockArguments.length; index++) {
    var arg = mockArguments[index]
    for (var attribute in arg) mocks[attribute] = arg[attribute]
  }

  return injectedRequire = function(dependency, options) {
    var name = (options && options.mockAs) || dependency.split('/').pop().split('.')[0]
    return mocks[name] || (typeof localRequire === "function" ? localRequire(dependency) : void 0)
  }
}

