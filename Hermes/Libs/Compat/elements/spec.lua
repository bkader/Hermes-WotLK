local parent, ns = ...

local LGT = LibStub and LibStub("LibGroupTalents-1.0", true)
if not LGT then return end

local Compat = ns.Compat
local unitExists = Compat.Private.UnitExists

local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local MAX_TALENT_TABS = MAX_TALENT_TABS or 3
local GetActiveTalentGroup = GetActiveTalentGroup
local GetTalentTabInfo = GetTalentTabInfo
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass

local LGTRoleTable = {melee = "DAMAGER", caster = "DAMAGER", healer = "HEALER", tank = "TANK"}

local specsTable = {
	["MAGE"] = {62, 63, 64},
	["PRIEST"] = {256, 257, 258},
	["ROGUE"] = {259, 260, 261},
	["WARLOCK"] = {265, 266, 267},
	["WARRIOR"] = {71, 72, 73},
	["PALADIN"] = {65, 66, 70},
	["DEATHKNIGHT"] = {250, 251, 252},
	["DRUID"] = {102, 103, 104, 105},
	["HUNTER"] = {253, 254, 255},
	["SHAMAN"] = {262, 263, 264}
}

function Compat.GetSpecialization(isInspect, isPet, specGroup)
	local currentSpecGroup = GetActiveTalentGroup(isInspect, isPet) or (specGroup or 1)
	local points, specname, specid = 0, nil, nil

	for i = 1, MAX_TALENT_TABS do
		local name, _, pointsSpent = GetTalentTabInfo(i, isInspect, isPet, currentSpecGroup)
		if points <= pointsSpent then
			points = pointsSpent
			specname = name
			specid = i
		end
	end
	return specid, specname, points
end

function Compat.UnitHasTalent(unit, spell, talentGroup)
	spell = (type(spell) == "number") and GetSpellInfo(spell) or spell
	return LGT:UnitHasTalent(unit, spell, talentGroup)
end

function Compat.GetInspectSpecialization(unit, class)
	local spec  -- start with nil

	if unitExists(unit) then
		class = class or select(2, UnitClass(unit))
		if class and specsTable[class] then
			local talentGroup = LGT:GetActiveTalentGroup(unit)
			local maxPoints, index = 0, 0

			for i = 1, MAX_TALENT_TABS do
				local _, _, pointsSpent = LGT:GetTalentTabInfo(unit, i, talentGroup)
				if pointsSpent ~= nil then
					if maxPoints < pointsSpent then
						maxPoints = pointsSpent
						if class == "DRUID" and i >= 2 then
							if i == 3 then
								index = 4
							elseif i == 2 then
								local points = Compat.UnitHasTalent(unit, 57881)
								index = (points and points > 0) and 3 or 2
							end
						else
							index = i
						end
					end
				end
			end
			spec = specsTable[class][index]
		end
	end

	return spec
end

function Compat.GetSpecializationRole(unit, class)
	unit = unit or "player" -- always fallback to player

	-- For LFG using "UnitGroupRolesAssigned" is enough.
	local isTank, isHealer, isDamager = UnitGroupRolesAssigned(unit)
	if isTank then
		return "TANK"
	elseif isHealer then
		return "HEALER"
	elseif isDamager then
		return "DAMAGER"
	end

	-- speedup things using classes.
	class = class or select(2, UnitClass(unit))
	if class == "HUNTER" or class == "MAGE" or class == "ROGUE" or class == "WARLOCK" then
		return "DAMAGER"
	end
	return LGTRoleTable[LGT:GetUnitRole(unit)] or "NONE"
end

-- aliases
Compat.UnitGroupRolesAssigned = Compat.GetSpecializationRole
Compat.GetUnitSpec = Compat.GetInspectSpecialization
Compat.GetUnitRole = Compat.GetSpecializationRole

function Compat.GetSpecializationInfo(specIndex, isInspect, isPet, specGroup)
	local name, icon, _, background = GetTalentTabInfo(specIndex, isInspect, isPet, specGroup)
	local id, role
	if isInspect and unitExists("target") then
		id, role = Compat.GetInspectSpecialization("target"), Compat.GetSpecializationRole("target")
	else
		id, role = Compat.GetInspectSpecialization("player"), Compat.GetSpecializationRole("player")
	end
	return id, name, "NaN", icon, background, role
end

local LT = LibStub("LibBabble-TalentTree-3.0"):GetLookupTable()
function Compat.GetSpecializationInfoByID(id)
	local name, icon, class
	local role = "DAMAGER"

	-- DEATHKNIGHT --
	if id == 250 then -- Blood
		name = LT.Blood
		icon = [[Interface\\Icons\\spell_deathknight_bloodpresence]]
		class = "DEATHKNIGHT"
	elseif id == 251 then -- Frost
		name = LT.Frost
		icon = [[Interface\\Icons\\spell_deathknight_frostpresence]]
		class = "DEATHKNIGHT"
	elseif id == 252 then -- Unholy
		name = LT.Unholy
		icon = [[Interface\\Icons\\spell_deathknight_unholypresence]]
		class = "DEATHKNIGHT"
	-- DRUID --
	elseif id == 102 then -- Balance
		name = LT.Balance
		icon = [[Interface\\Icons\\spell_nature_starfall]]
		class = "DRUID"
	elseif id == 103 then -- Feral Combat (Damager)
		name = LT["Feral Combat"]
		icon = [[Interface\\Icons\\ability_druid_catform]]
		class = "DRUID"
	elseif id == 104 then -- Feral Combat (Tank)
		name = LT["Feral Combat"]
		icon = [[Interface\\Icons\\ability_racial_bearform]]
		role = "TANK"
		class = "DRUID"
	elseif id == 105 then -- Restoration
		name = LT.Restoration
		icon = [[Interface\\Icons\\spell_nature_healingtouch]]
		role = "HEALER"
		class = "DRUID"
	-- HUNTER --
	elseif id == 253 then -- Beast Mastery
		name = LT["Beast Mastery"]
		icon = [[Interface\\Icons\\ability_hunter_beasttaming]]
		class = "HUNTER"
	elseif id == 254 then -- Marksmanship
		name = LT.Marksmalship
		icon = [[Interface\\Icons\\ability_hunter_focusedaim]]
		role = "TANK"
		class = "HUNTER"
	elseif id == 255 then -- Survival
		name = LT.Survival
		icon = [[Interface\\Icons\\ability_hunter_swiftstrike]]
		role = "HEALER"
		class = "HUNTER"
	-- MAGE --
	elseif id == 62 then -- Arcane
		name = LT.Arcane
		icon = [[Interface\\Icons\\spell_holy_magicalsentry]]
		class = "MAGE"
	elseif id == 63 then -- Fire
		name = LT.Fire
		icon = [[Interface\\Icons\\spell_fire_flamebolt]]
		class = "MAGE"
	elseif id == 64 then -- Frost
		name = LT.Frost
		icon = [[Interface\\Icons\\spell_frost_frostbolt02]]
		class = "MAGE"
	-- PALADIN --
	elseif id == 65 then -- Holy
		name = LT.Holy
		icon = [[Interface\\Icons\\spell_holy_holybolt]]
		role = "HEALER"
		class = "PALADIN"
	elseif id == 66 then -- Protection
		name = LT.Protection
		icon = [[Interface\\Icons\\ability_paladin_shieldofthetemplar]]
		role = "TANK"
		class = "PALADIN"
	elseif id == 70 then -- Retribution
		name = LT.Retribution
		icon = [[Interface\\Icons\\spell_holy_auraoflight]]
		class = "PALADIN"
	-- PRIEST --
	elseif id == 256 then -- Discipline
		name = LT.Discipline
		icon = [[Interface\\Icons\\spell_holy_holybolt]]
		role = "HEALER"
		class = "PRIEST"
	elseif id == 257 then -- Holy
		name = LT.Holy
		icon = [[Interface\\Icons\\ability_paladin_shieldofthetemplar]]
		role = "HEALER"
		class = "PRIEST"
	elseif id == 258 then -- Shadow
		name = LT.Shadow
		icon = [[Interface\\Icons\\spell_holy_auraoflight]]
		class = "PRIEST"
	-- ROGUE --
	elseif id == 259 then -- Assassination
		name = LT.Assassination
		icon = [[Interface\\Icons\\ability_rogue_eviscerate]]
		class = "ROGUE"
	elseif id == 260 then -- Combat
		name = LT.Combat
		icon = [[Interface\\Icons\\ability_backstab]]
		class = "ROGUE"
	elseif id == 261 then -- Subtlety
		name = LT.Subtlety
		icon = [[Interface\\Icons\\ability_stealth]]
		class = "ROGUE"
	-- SHAMAN --
	elseif id == 262 then -- Elemental
		name = LT.Elemental
		icon = [[Interface\\Icons\\spell_nature_lightning]]
		class = "SHAMAN"
	elseif id == 263 then -- Enhancement
		name = LT.Enhancement
		icon = [[Interface\\Icons\\spell_shaman_improvedstormstrike]]
		class = "SHAMAN"
	elseif id == 264 then -- Restoration
		name = LT.Restoration
		icon = [[Interface\\Icons\\spell_nature_healingwavegreater]]
		role = "HEALER"
		class = "SHAMAN"
	-- WARLOCK --
	elseif id == 265 then -- Affliction
		name = LT.Affliction
		icon = [[Interface\\Icons\\spell_shadow_deathcoil]]
		class = "WARLOCK"
	elseif id == 266 then -- Demonology
		name = LT.Demonology
		icon = [[Interface\\Icons\\spell_shadow_metamorphosis]]
		class = "WARLOCK"
	elseif id == 267 then -- Destruction
		name = LT.Destruction
		icon = [[Interface\\Icons\\spell_shadow_rainoffire]]
		class = "WARLOCK"
	-- WARRIOR --
	elseif id == 71 then -- Arms
		name = LT.Arms
		icon = [[Interface\\Icons\\ability_warrior_savageblow]]
		class = "WARRIOR"
	elseif id == 72 then -- Fury
		name = LT.Fury
		icon = [[Interface\\Icons\\ability_warrior_innerrage]]
		class = "WARRIOR"
	elseif id == 73 then -- Protection
		name = LT.Protection
		icon = [[Interface\\Icons\\ability_warrior_defensivestance]]
		role = "TANK"
		class = "WARRIOR"
	end

	return id, name, "NaN", icon, nil, role, class
end

-- utilities

function Compat.UnitHasTalent(unit, spell, talentGroup)
	spell = (type(spell) == "number") and GetSpellInfo(spell) or spell
	return LGT:UnitHasTalent(unit, spell, talentGroup)
end

function Compat.UnitHasGlyph(unit, glyphID)
	return LGT:UnitHasGlyph(unit, glyphID)
end


-- functions that simply replaced other api functions
local GetNumTalentTabs = GetNumTalentTabs
local GetNumTalentGroups = GetNumTalentGroups
local GetUnspentTalentPoints = GetUnspentTalentPoints
local SetActiveTalentGroup = SetActiveTalentGroup

Compat.GetNumSpecializations = GetNumTalentTabs
Compat.GetNumSpecGroups = GetNumTalentGroups
Compat.GetNumUnspentTalents = GetUnspentTalentPoints
Compat.GetActiveSpecGroup = GetActiveTalentGroup
Compat.SetActiveSpecGroup = SetActiveTalentGroup