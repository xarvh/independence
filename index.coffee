
path = try require 'path' catch e then join: (args...) -> args.join ''

dependDefaultFactory = (basePath) ->
  return dependDefault = (name, dependency) ->
    dependency ?= name
    if typeof dependency isnt 'string' then return dependency

    if '/' in dependency then dependency = path.join basePath..., dependency
    return require dependency


dependOnlyOnFactory = (mocks = {}) ->
  return dependOnlyOn = (name, dependency) ->
    if !dependency then name = getNameFromDependency dependency = name
    return mocks[name]


dependOnFactory = (mocks = {}, dependDefault) ->
  return dependOn = (name, dependency) ->
    if !dependency then name = getNameFromDependency dependency = name
    return mocks[name] or dependDefault name, dependency


module.exports = independence = (basePath..., moduleInjector) ->

  makeModule = (depend) ->
    modu1e = exports: {}
    moduleInjector depend, modu1e
    return modu1e.exports

  dependDefault = dependDefaultFactory basePath
  exportz = makeModule dependDefault
  exportz.dependingOn = (mocks) -> makeModule dependOnFactory mocks, dependDefault
  exportz.dependingOnlyOn = (mocks) -> makeModule dependOnlyOnFactory mocks

  return exportz


module.exports.getNameFromDependency = getNameFromDependency = (dependency) ->
  return dependency?.split?('/').pop().split('.')[0] or throw new Error 'Invalid module name'

