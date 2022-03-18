local parent, ns = ...
local Compat = ns.Compat

local select = select
local IsInInstance = IsInInstance

local C_PvP = {}

function C_PvP.IsPvPMap()
	local instanceType = select(2, IsInInstance())
	return (instanceType == "pvp" or instanceType == "arena")
end

function C_PvP.IsBattleground()
	return (select(2, IsInInstance()) == "pvp")
end

function C_PvP.IsArena()
	return (select(2, IsInInstance()) == "arena")
end

function C_PvP.IsRatedBattleground()
	return false
end

function C_PvP.IsWarModeDesired()
	return false
end

Compat.C_PvP = C_PvP