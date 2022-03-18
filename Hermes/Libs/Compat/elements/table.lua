local parent, ns = ...
local Compat = ns.Compat

local select = select
local unpack = unpack
local pairs, ipairs = pairs, ipairs
local tinsert = table.insert
local setmetatable = setmetatable
local wipe = wipe
local next = next

function Compat.SafePack(...)
	local t = {...}
	t.n = select("#", ...)
	return t
end

function Compat.SafeUnpack(t)
	return unpack(t, 1, t.n)
end

function Compat.tLength(t)
	local len = 0
	for _ in pairs(t) do
		len = len + 1
	end
	return len
end

function Compat.tCopy(to, from, ...)
	for k, v in pairs(from) do
		local skip = false
		if ... then
			for _, j in ipairs(...) do
				if j == k then
					skip = true
					break
				end
			end
		end
		if not skip then
			if type(v) == "table" then
				to[k] = {}
				Compat.tCopy(to[k], v, ...)
			else
				to[k] = v
			end
		end
	end
end

function Compat.tInvert(t)
	local inverted = {}
	for k, v in pairs(t) do
		inverted[v] = k
	end
	return inverted
end

function Compat.tIndexOf(t, item)
	for i, v in ipairs(t) do
		if item == v then
			return i
		end
	end
end

function Compat.tContains(t, item)
	return (Compat.tIndexOf(t, item) ~= nil)
end

function Compat.tAppendAll(tbl, elems)
	for _, elem in ipairs(elems) do
		tinsert(tbl, elem)
	end
end

local weaktable = {__mode = "v"}
function Compat.WeakTable(t)
	return setmetatable(wipe(t or {}), weaktable)
end

do
	local Table = {}
	local max_pool_size = 200
	local pools = {}

	-- attempts to get a table from the table pool of the
	-- specified tag name. if the pool doesn't exist or is empty
	-- it creates a lua table.
	function Table.get(tag)
		local pool = pools[tag]
		if not pool then
			pool = {}
			pools[tag] = pool
			pool.c = 0
			pool[0] = 0
		else
			local len = pool[0]
			if len > 0 then
				local obj = pool[len]
				pool[len] = nil
				pool[0] = len - 1
				return obj
			end
		end
		return {}
	end

	-- releases the already used lua table into the table pool
	-- named "tag" or creates it right away.
	function Table.free(tag, obj, noclear)
		if not obj then return end

		local pool = pools[tag]
		if not pool then
			pool = {}
			pools[tag] = pool
			pool.c = 0
			pool[0] = 0
		end

		if not noclear then
			setmetatable(obj, nil)
			for k, _ in pairs(obj) do
				obj[k] = nil
			end
		end

		do
			local cnt = pool.c + 1
			if cnt >= 20000 then
				pool = {}
				pools[tag] = pool
				pool.c = 0
				pool[0] = 0
				return
			end
			pool.c = cnt
		end

		local len = pool[0] + 1
		if len > max_pool_size then
			return
		end

		pool[len] = obj
		pool[0] = len
	end

	Compat.Table = Table
end

-- Table Pool for recycling tables
-- creates a new table system that can be used to reuse tables
-- it returns both "new" and "del" functions.
function Compat.TablePool(mode)
	local pool = {}
	setmetatable(pool, {__mode = mode or "k"})

	-- attempts to retrieve a table from the cache
	-- creates if if it doesn't exist.
	local new = function()
		local t = next(pool) or {}
		pool[t] = nil
		return t
	end

	-- it will wipe the provided table then cache it
	-- to be reusable later.
	local del = function(t)
		if type(t) == "table" then
			setmetatable(t, nil)
			for k, _ in pairs(t) do
				t[k] = nil
			end
			t[""] = true
			t[""] = nil
			pool[t] = true
		end
		return nil
	end

	return new, del
end