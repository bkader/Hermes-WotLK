local parent, ns = ...
local Compat = ns.Compat

local UnitIterator = Compat.UnitIterator
local unitExists = Compat.Private.UnitExists

local select = select
local strfind = string.find
local strsub = string.sub
local tonumber = tonumber
local format = string.format
local max = math.max

local MAX_BOSS_FRAMES = MAX_BOSS_FRAMES or 5
local MAX_ARENA_ENEMIES = MAX_ARENA_ENEMIES or 5
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitName = UnitName
local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax

function Compat.GetUnitIdFromGUID(guid, filter)
	if filter == nil or filter == "boss" then
		for i = 1, MAX_BOSS_FRAMES do
			local unit = format("boss%d", i)
			if UnitExists(unit) and UnitGUID(unit) == guid then
				return unit
			end
		end
		if filter == "boss" then
			return -- no need to go further
		end
	end

	if filter == nil or filter == "player" then
		if UnitExists("target") and UnitGUID("target") == guid then
			return "target"
		elseif UnitExists("focus") and UnitGUID("focus") == guid then
			return "focus"
		elseif UnitExists("targettarget") and UnitGUID("targettarget") == guid then
			return "targettarget"
		elseif UnitExists("focustarget") and UnitGUID("focustarget") == guid then
			return "focustarget"
		elseif UnitExists("mouseover") and UnitGUID("mouseover") == guid then
			return "mouseover"
		elseif filter == "player" then
			return -- no need to go further
		end
	end

	if filter == nil or filter == "group" then
		for unit, owner in UnitIterator() do
			if UnitGUID(unit) == guid then
				return unit
			elseif UnitExists(unit .. "target") and UnitGUID(unit .. "target") == guid then
				return unit .. "target"
			elseif owner and UnitGUID(owner) == guid then
				return owner
			elseif owner and UnitGUID(owner .. "target") == guid then
				return owner .. "target"
			end
		end
		if filter == "group" then
			return -- no need to go further
		end
	end

	if filter == nil or filter == "arena" then
		for i = 1, MAX_ARENA_ENEMIES do
			local unit = format("arena%d", i)
			if UnitExists(unit) and UnitGUID(unit) == guid then
				return unit
			elseif UnitExists(unit .. "target") and UnitGUID(unit .. "target") == guid then
				return unit .. "target"
			end
		end
		if filter == "arena" then
			return -- no need to go further
		end
	end
end

function Compat.GetClassFromGUID(guid, filter)
	local unit = Compat.GetUnitIdFromGUID(guid, filter)
	local class
	if unit and strfind(unit, "pet") then
		class = "PET"
	elseif unit and strfind(unit, "boss") then
		class = "BOSS"
	elseif unit then
		class = select(2, UnitClass(unit))
	end
	return class, unit
end

function Compat.GetCreatureId(guid)
	return guid and tonumber(strsub(guid, 9, 12), 16) or 0
end

function Compat.GetUnitCreatureId(unit)
	return Compat.GetCreatureId(UnitGUID(unit))
end

local unknownUnits = {[UKNOWNBEING] = true, [UNKNOWNOBJECT] = true}

function Compat.UnitHealthInfo(unit, guid, filter)
	unit = (unit and not unknownUnits[unit]) and unit or (guid and Compat.GetUnitIdFromGUID(guid, filter))
	local percent, health, maxhealth
	if unitExists(unit) then
		health, maxhealth = UnitHealth(unit), UnitHealthMax(unit)
		if health and maxhealth then
			percent = 100 * health / max(1, maxhealth)
		end
	end
	return percent, health, maxhealth
end

function Compat.UnitPowerInfo(unit, guid, powerType, filter)
	unit = (unit and not unknownUnits[unit]) and unit or (guid and Compat.GetUnitIdFromGUID(guid, filter))
	local percent, power, maxpower
	if unitExists(unit) then
		power, maxpower = UnitPower(unit, powerType), UnitPowerMax(unit, powerType)
		if power and maxpower then
			percent = 100 * power / max(1, maxpower)
		end
	end
	return percent, power, maxpower
end

function Compat.UnitFullName(unit)
	local name, realm = UnitName(unit)
	local namerealm = realm and realm ~= "" and name .. "-" .. realm or name
	return namerealm
end