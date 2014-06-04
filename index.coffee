
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


module.exports = independence = (basePath..., moduleFactory) ->
  dependDefault = dependDefaultFactory basePath
  mod = moduleFactory dependDefault
  mod.dependingOn = (mocks) -> moduleFactory dependOnFactory mocks, dependDefault
  mod.dependingOnlyOn = (mocks) -> moduleFactory dependOnlyOnFactory mocks
  return mod


module.exports.getNameFromDependency = getNameFromDependency = (dependency) ->
  return dependency?.split?('/').pop().split('.')[0] or throw new Error 'Invalid module name'

