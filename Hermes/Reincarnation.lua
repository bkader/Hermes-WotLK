--[[
Rules:
	If a shaman had a SS on them and they die, events are as follows:
		SPELL_AURA_REMOVED, Shimano, Curvy, 20707, Soulstone Resurrection
		UNIT_DIED, nil, Curvy, nil, nil

	The big assumption here is that SPELL_AURA_REMOVED will always happen before UNIT_DIED

	Also note that is a Shaman has a SS, they are unable to use Reincarnation.

- -note: testing indicates that upon using reincarnation they are not in combat

]] --

local Hermes = Hermes
local mod = Hermes:NewModule("HermesReincarnation", "AceEvent-3.0")
if not mod then return end

local callback = nil
local deadshaman = {}
local soulstones = {}

local SOULSTONE = 20707 --Soulstone Resurrection: 30% health and mana.
local RESURRECTIONS = {
	[61999] = true, -- Death Knight Raise Ally: Returns the spirit to the body, restoring a dead target to life with 20% health and 20% mana.
	[20484] = true, -- Druid Rebirth: Returns the spirit to the body, restoring a dead target to life with 20% health and 20% mana. Glyph causes 100% health
	[7328] = true, -- Paladin Redemption: 35% of maximum health and mana
	[2006] = true -- Priest Resurrection:
}

local function send(unit, name, guid)
	if callback and type(callback) == "function" then
		callback(unit, name, guid)
	end
end

local function reset()
	wipe(deadshaman)
	wipe(soulstones)
end

function mod:DelDeadShaman(name)
	deadshaman[name] = nil
	soulstones[name] = nil
	if #deadshaman == 0 then
		self:UnregisterEvent("UNIT_HEALTH")
	end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, _, _, _, dstName, _, spellID, ...)
	self:ProcessCombatLogEvent(event, dstName, spellID)
end

function mod:ProcessCombatLogEvent(event, dstName, spellID)
	--we're only interested in these events
	if event ~= "SPELL_AURA_REMOVED" and event ~= "UNIT_DIED" and event ~= "SPELL_RESURRECT" then
		return
	end

	--target must not be nil (not sure if it ever will be though)
	if not dstName then
		return
	end

	--at this point, we only care about things happening to SHAMAN in our raid
	if select(2, UnitClass(dstName)) == "SHAMAN" and (UnitInRaid(dstName) or UnitInParty(dstName)) then
		--a SHAMAN is about to die that has a soulstone
		if spellID == SOULSTONE and event == "SPELL_AURA_REMOVED" then
			--a SHAMAN just died
			soulstones[dstName] = true
		elseif event == "UNIT_DIED" then
			--a shaman just got resurrected by someone else, remove it from dead shaman and soulstones
			deadshaman[dstName] = true
			--start trying to detect Resurrection
			self:RegisterEvent("UNIT_HEALTH")
		elseif event == "SPELL_RESURRECT" and RESURRECTIONS[spellID] then
			self:DelDeadShaman(dstName)
		end
	end
end

--if someone zones in after dying, they have 50% health and mana
function mod:UNIT_HEALTH(event, unit)
	local name = UnitName(unit)
	if not deadshaman[name] then
		return
	end --ignore if not in list of dead shaman

	local visible = UnitIsVisible(unit) --I think this is an important check due to combat log restrictions and how long it might take for unit health updates when not in range. I worry about what would happen if I don't have this visible check, even though it technically might cause more harm that good.
	local connected = UnitIsConnected(unit)
	local deadorghost = UnitIsDeadOrGhost(unit)
	local health = UnitHealth(unit)
	local max_health = UnitHealthMax(unit)
	local mana = UnitPower(unit)
	local max_mana = UnitPowerMax(unit)
	local health_per = health / max_health
	local mana_per = mana / max_mana

	if deadorghost and UnitHealth(unit) == 1 then
		--unit most likely released, which means they didn't use reincarnation
		self:DelDeadShaman(name)
	elseif not deadorghost and visible and connected and health_per < 0.31 and mana_per < 0.31 then --0.31 to ensure that we account for any rounding errors and get soulstone events too
		--unit likely either used a soulstone, or reincarnation

		--if they didn't have a soulstone, then they must have used Reincarnation
		if not soulstones[name] then
			send(unit, name, UnitGUID(unit))
		else
		end
		self:DelDeadShaman(name)
	elseif not deadorghost and health_per >= 0.31 and mana_per >= 0.31 then
		--they either zoned in just now, or something else I am not considering happened. Most likely that they didn't use reincarnation though.
		--either way, this is a good failsafe to ensure that they get removed from the list of dead shaman
		self:DelDeadShaman(name)
	else
		--unit is probably still dead and laying on the ground eating some old bubble gum. Almost certainly hasn't released yet.
	end
end

function mod:PLAYER_REGEN_DISABLED() -- Starting combat, reset state of people
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("UNIT_HEALTH")
	reset()
end

function mod:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	reset()
end

function mod:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	reset()
end

function mod:SetCallback(func)
	callback = func
end