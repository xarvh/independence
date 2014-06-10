
var independence = module.exports = function(_require, moduleInjector) {

  var makeModule = function(injectedRequire) {
    var _module = { exports: {} }
    moduleInjector.call(_module.exports, injectedRequire, _module, _module.exports)
    return _module.exports
  }

  _exports = makeModule(_require)
  _exports.dependingOn = function() { return makeModule(independence.requireFactory(arguments, _require)) }
  _exports.dependingOnlyOn = function() { return makeModule(independence.requireFactory(arguments)) }
  return _exports
}


independence.requireFactory = function(mockArguments, _require) {
  var mocks = {}
  for (var index = 0; index < mockArguments.length; index++) {
    var arg = mockArguments[index]
    for (var attribute in arg) mocks[attribute] = arg[attribute]
  }

  return injectedRequire = function(dependency, options) {
    var name = (options && options.mockAs) || dependency.split('/').pop().split('.')[0]
    return mocks[name] || (typeof _require === "function" ? _require(dependency) : void 0)
  }
}

