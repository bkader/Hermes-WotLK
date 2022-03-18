local parent, ns = ...
local Compat = ns.Compat

local type = type
local error = error
local unpack = unpack
local tostring = tostring
local getmetatable = getmetatable

local memoizedFunc = ns.memoizedFunc or {}
ns.memoizedFunc = memoizedFunc

local function isCallable(func)
	-- function or method?
	if type(func) == "function" then
		return true
	end
	-- maybe a metatable.
	if type(func) == "table" then
		local mt = getmetatable(func)
		return (type(mt) == "table" and isCallable(mt.__call))
	end
	return false
end

local function cacheGet(cache, params)
	local node = cache
	for i = 1, #params do
		node = node.children and node.children[params[i]]
		if not node then
			return nil
		end
	end
	return node.results
end

local function cachePut(cache, params, results)
	local node = cache
	local i = 1
	local param = params[i]
	while param do
		node.children = node.children or {}
		node.children[param] = node.children[param] or {}
		node = node.children[param]
		i = i + 1
		param = params[i]
	end
	node.results = results
end

function Compat.memoize(func, cache)
	if not isCallable(func) then
		error(("Only functions and callable tables are memoizable. Received %s (a %s)"):format(tostring(func), type(func)), 2)
	end

	cache = cache or memoizedFunc[func]
	if not cache then
		memoizedFunc[func] = {}
		cache = memoizedFunc[func]
	end

	return function(...)
		local params = {...}
		local results = cacheGet(cache, params)
		if not results then
			results = {func(...)}
			cachePut(cache, params, results)
		end
		return unpack(results)
	end
end