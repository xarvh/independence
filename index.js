
var independence = module.exports = function(_require, _module, moduleInjector) {

  var cloneModule = function() {
    var clone = {}
    for (var a in _module) { clone[a] = _module[a] }
    clone.exports = {}
    return clone
  }

  var makeModule = function(injectedModule, injectedRequire) {
    moduleInjector.call(injectedModule.exports, injectedRequire, injectedModule, injectedModule.exports)
    return injectedModule.exports
  }

  _exports = makeModule(_module, _require)
  _exports.override = function() { return makeModule(cloneModule(), independence.requireFactory(arguments, _require)) }
  _exports.isolate = function() { return makeModule(cloneModule(), independence.requireFactory(arguments)) }

  return _exports
}


independence.requireFactory = function(mockArguments, _require) {
  var mocks = {}
  for (var index = 0; index < mockArguments.length; index++) {
    var arg = mockArguments[index]
    for (var attribute in arg) mocks[attribute] = arg[attribute]
  }

  return injectedRequire = function(dependency, options) {
    var name = (options && options.alias) || dependency.split('/').pop().split('.')[0]
    return mocks[name] || (typeof _require === "function" ? _require(dependency) : void 0)
  }
}

