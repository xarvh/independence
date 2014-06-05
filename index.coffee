
module.exports = independence = (localRequire, moduleInjector) ->

  makeModule = (injectedRequire) ->
    modu1e = exports: {}
    moduleInjector injectedRequire, modu1e, modu1e.exports
    return modu1e.exports

  exportz = makeModule localRequire
  exportz.dependingOn = -> makeModule independence.requireFactory arguments, localRequire
  exportz.dependingOnlyOn = -> makeModule independence.requireFactory arguments

  return exportz


independence.requireFactory = (mockArguments, localRequire) ->

  mocks = {}
  for arg in mockArguments
    for attribute of arg
      mocks[attribute] = arg[attribute]

  return injectedRequire = (dependency, options) ->
    name = options?.mockAs or dependency.split('/').pop().split('.')[0]
    return mocks[name] or localRequire? dependency

