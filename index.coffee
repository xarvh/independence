
dependDefault = (name, dependency) ->
  dependency ?= name
  return if typeof dependency is 'string' then require dependency else dependency


dependOnlyOnFactory = (mocks) ->
  return dependOnlyOn = (name, dependency) ->
    if !dependency then name = getNameFromDependency dependency = name
    return mocks[name]


dependOnFactory = (mocks) ->
  return dependOn = (name, dependency) ->
    if !dependency then name = getNameFromDependency dependency = name
    return mocks[name] or dependDefault name, dependency


module.exports = independence = (moduleFactory) ->
  mod = moduleFactory dependDefault
  mod.dependingOn = (mocks) -> moduleFactory dependOnFactory mocks
  mod.dependingOnlyOn = (mocks) -> moduleFactory dependOnlyOnFactory mocks
  return mod


module.exports.getNameFromDependency = getNameFromDependency = (dependency) ->
  return dependency?.split?('/').pop().split('.')[0] or throw new Error 'Invalid module name'
