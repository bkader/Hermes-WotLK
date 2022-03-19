local Hermes = Hermes
local mod = Hermes:NewModule("HermesTalents", "AceEvent-3.0", "AceTimer-3.0")
if not mod then return end

local LGT = LibStub("LibGroupTalents-1.0")

local API = Hermes.Compat
local GetUnitIdFromGUID = API.GetUnitIdFromGUID
local UnitHasTalent = API.UnitHasTalent
local GetUnitSpec = API.GetUnitSpec

local roster = {}
local cantinspect = {}
local onupdate = nil
local onremove = nil
local onclasstalentsupdated = nil
local dbg = nil

function mod:OnInitialize()
end

function mod:OnEnable()
	wipe(roster)
	wipe(cantinspect)

	LGT.RegisterCallback(mod, "LibGroupTalents_Update")
	LGT.RegisterCallback(mod, "LibGroupTalents_Remove")
end

function mod:OnDisable()
	LGT.UnregisterCallback(mod, "LibGroupTalents_Update")
	LGT.UnregisterCallback(mod, "LibGroupTalents_Remove")

	wipe(roster)
	wipe(cantinspect)
end

local infoTable = {}
function mod:LibGroupTalents_Update(event, guid, unit, spec)
	wipe(infoTable)
	infoTable.unit = unit
	infoTable.name = UnitName(unit)
	infoTable.class = select(2, UnitClass(unit))
	onupdate(guid, unit, infoTable)
	if infoTable.class then
		onclasstalentsupdated(infoTable.class)
	end
end

function mod:LibGroupTalents_Remove(guid)
end

function mod:SetProfile(profile)
	-- dbg = profile
end

function mod:SetOnUpdate(func)
	onupdate = func
end

function mod:SetOnRemove(func)
	-- onremove = func
end

function mod:SetOnClassTalentsUpdated(func)
	onclasstalentsupdated = func
end

function mod:GetPrimarySpecializationForGuid(guid)
	local unit = guid and GetUnitIdFromGUID(guid, "group")
	if unit then
		return GetUnitSpec(unit)
	end
end

function mod:IsTalentAvailable(guid, talentID)
	local unit = guid and GetUnitIdFromGUID(guid, "group")
	return unit and UnitHasTalent(unit, talentID)
end