local parent, ns = ...
local Compat = ns.Compat

local type = type
local select = select
local unpack = unpack
local fomrat = string.format
local tinsert = table.insert
local tremove = table.remove

local DelayTable = ns.DelayTable or {}
ns.DelayTable = DelayTable

local function WaitFunc(self, elapsed)
	local total = #DelayTable
	local i = 1

	while i <= total do
		local data = DelayTable[i]

		if data[1] > elapsed then
			data[1] = data[1] - elapsed
			i = i + 1
		else
			tremove(DelayTable, i)

			if data[3] then
				if data[3] > 1 then
					data[2](unpack(data[4], 1, data[3]))
				else
					data[2](unpack(data[4]))
				end
			else
				data[2]()
			end

			total = total - 1
		end
	end

	if #DelayTable == 0 then
		self:Hide()
	end
end

local DelayFrame = _G[parent .. "_DelayFrame"] or CreateFrame("Frame", parent .. "_DelayFrame", UIParent)
DelayFrame:SetScript("OnUpdate", WaitFunc)

function Compat.Delay(delay, func, ...)
	if type(delay) ~= "number" then
		error(format("Bad argument #1 to 'Delay' (number expected, got %s)", delay ~= nil and type(delay) or "no value"), 2)
	elseif type(func) ~= "function" then
		error(format("Bad argument #2 to 'Delay' (function expected, got %s)", func ~= nil and type(func) or "no value"), 2)
	end

	local argCount = select("#", ...)
	tinsert(DelayTable, {delay, func, argCount > 0 and argCount, argCount == 1 and (...) or argCount > 1 and {...}})
	DelayFrame:Show()

	return true
end