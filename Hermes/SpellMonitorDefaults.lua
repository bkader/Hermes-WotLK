local AddonName, Hermes = ...

local hero = (Hermes.Faction == "Alliance") and 32182 or 2825

Hermes.SPELL_MONITOR_SCHEMA = {
	["schema"] = 30300,
	["revision"] = 2,
	["spellmetadata"] = {

		-- DEATHKNIGHT
		[51052] = {duration = 10}, -- Anti-magic Zone
		[49222] = {duration = 300}, -- Bone Shield
		[49576] = {duration = 3}, -- Death Grip
		[48792] = {duration = 12}, -- Icebound Fortitude
		[49039] = {duration = 10}, -- Lichborne
		[47528] = {duration = 4}, -- Mind Freeze
		[56222] = {duration = 3}, -- Dark Command
		[49016] = {duration = 30}, -- Hysteria
		[48707] = {duration = 5}, -- Anti-Magic Shell
		[51271] = {duration = 20}, -- Unbreakable Armor
		[49206] = {duration = 30}, -- Summon Gargoyle
		[55233] = {duration = 10}, -- Vamp Blood
		[42650] = {duration = 4}, -- Army of the Dead
		[49005] = {duration = 20}, -- Mark of Blood
		[47476] = {duration = 3}, -- Strangulate
		[45529] = {duration = 20}, -- Blood Tap

		-- DRUID
		[16857] = {duration = 300}, -- Faerie Fire (Feral)
		[17116] = {duration = 10}, -- Nature's Swiftness
		[22812] = {duration = 12}, -- Barkskin
		[22842] = {duration = 10}, -- Frenzied Regeneration
		[29166] = {duration = 10}, -- Innervate
		[33357] = {duration = 15}, -- Dash
		[48447] = {duration = 8}, -- Tranquility
		[50334] = {duration = 15}, -- Berserk
		[5209] = {duration = 6}, -- Challenging Roar
		[5229] = {duration = 10}, -- Enrage
		[53201] = {duration = 10}, -- Starfall
		[53227] = {duration = 6}, -- Typhoon
		[61336] = {duration = 20}, -- Survival Instincts
		[6795] = {duration = 3}, -- Growl
		[8983] = {duration = 4}, -- Bash
		[33831] = {duration = 30}, -- Force of Nature

		-- HUNTER
		[60192] = {duration = 20}, -- Freezing Arrow
		[34477] = {duration = 30}, -- Misdirection
		[19574] = {duration = 10}, -- Bestial Wrath
		[19263] = {duration = 5}, -- Deterrence
		[13809] = {duration = 30}, -- Frost Trap
		[3045] = {duration = 15}, -- Rapid Fire
		[49067] = {duration = 30}, -- Explosive Trap
		[34600] = {duration = 30}, -- Snake Trap
		[34490] = {duration = 3}, -- Silencing Shot

		-- MAGE
		[2139] = {duration = 8}, -- Counterspell
		[45438] = {duration = 10}, -- Ice Block
		[1953] = {duration = 1}, -- Blink
		[12051] = {duration = 8}, -- Evocation
		[66] = {duration = 3}, -- Invisibility
		[55342] = {duration = 30}, -- Mirror Image

		-- PALADIN
		[53601] = {duration = 30}, -- Sacred Shield
		[498] = {duration = 12}, -- Divine Protection
		[64205] = {duration = 10}, -- Divine Sacrifice
		[642] = {duration = 12}, -- Divine Shield
		[10278] = {duration = 10}, -- Hand of Protection
		[1044] = {duration = 6}, -- Hand of Freedom
		[6940] = {duration = 12}, -- Hand of Sacrifice
		[1038] = {duration = 10}, -- Hand of Salvation
		[31821] = {duration = 6}, -- Aura Mastery
		[20066] = {duration = 60}, -- Repentance
		[10308] = {duration = 6}, -- Hammer of Justice
		[48817] = {duration = 3}, -- Holy Wrath
		[31884] = {duration = 20}, -- Avenging Wrath
		[54428] = {duration = 15}, -- Divine Plea
		[62124] = {duration = 3}, -- Hand of Reckoning
		[66233] = {duration = 120}, -- Ardent Defender
		[31842] = {duration = 15}, -- Divine Illumination

		-- PRIEST
		[64044] = {duration = 3}, -- Psychic Horror
		[15487] = {duration = 5}, -- Silence
		[64843] = {duration = 8}, -- Divine Hymn
		[6346] = {duration = 180}, -- Fear Ward
		[47788] = {duration = 10}, -- Guardian Spirit
		[64901] = {duration = 8}, -- Hymn of Hope
		[33206] = {duration = 8}, -- Pain Suppression
		[47585] = {duration = 6}, -- Dispersion
		[10890] = {duration = 8}, -- Psychic Scream
		[34433] = {duration = 15}, -- Shadowfiend
		[586] = {duration = 10}, -- Fade
		[10060] = {duration = 15}, -- Powers Infusion
		[724] = {duration = 180}, -- Prayer of Mending

		-- ROGUE
		[31224] = {duration = 5}, -- Cloak of Shadows
		[8643] = {duration = 1}, -- Kidney Shot
		[57934] = {duration = 30}, -- Tricks of the Trade
		[1766] = {duration = 5}, -- Kick
		[51690] = {duration = 2}, -- Killing Spree
		[26669] = {duration = 15}, -- Evasion
		[13877] = {duration = 15}, -- Blade Flurry
		[13750] = {duration = 15}, -- Adrenaline Rush
		[51722] = {duration = 10}, -- Dismantle
		[11305] = {duration = 15}, -- Sprint
		[2094] = {duration = 10}, -- Blind
		[48659] = {duration = 6}, -- Feint

		-- SHAMAN
		[hero] = {duration = 40}, -- Bloodlust/Heroism
		[57994] = {duration = 2}, -- Wind Shear
		[51514] = {duration = 30}, -- Hex
		[16190] = {duration = 13}, -- Mana Tide Totem
		[16166] = {duration = 30}, -- Elemental Mastery
		[51533] = {duration = 45}, -- Feral Spirit
		[2894] = {duration = 120}, -- Fire Elemental Totem

		-- WARLOCK
		[48020] = {duration = 1}, -- Demonic Circle: Teleport
		[47883] = {duration = 900}, -- Soulstone Resurrection
		[47241] = {duration = 30}, -- Metamorphosis
		[698] = {duration = 120}, -- Ritual of Summoning
		[29893] = {duration = 60}, -- Ritual of Souls

		-- WARRIOR
		[1161] = {duration = 6}, -- Challenging Shout
		[12292] = {duration = 30}, -- Death Wish
		[12323] = {duration = 6}, -- Piercing Howl
		[1719] = {duration = 12}, -- Recklessness
		[3411] = {duration = 10}, -- Intervene
		[355] = {duration = 3}, -- Taunt
		[46924] = {duration = 6}, -- Bladestorm
		[5246] = {duration = 8}, -- Intimidating Shout
		[60970] = {duration = 0.1}, -- Heroic Fury
		[64382] = {duration = 10}, -- Shattering Throw
		[6552] = {duration = 4}, -- Pummel
		[676] = {duration = 10}, -- Disarm
		[70845] = {duration = 10}, -- Stoicism
		[72] = {duration = 6}, -- Shield Bash
		[871] = {duration = 12}, -- Shield Wall
	},
	["requirements"] = {
		-- level requirement
		[698] = {{k = 10, level = 20}},
		[47528] = {{k = 10, level = 57}},
		[48792] = {{k = 10, level = 62}},
		[1038] = {{k = 10, level = 26}},
		[2139] = {{k = 10, level = 24}},
		[57994] = {{k = 10, level = 16}},
		[29893] = {{k = 10, level = 68}},
		[6940] = {{k = 10, level = 46}},
		[49576] = {{k = 10, level = 55}},
		[42650] = {{k = 10, level = 80}},
		[22842] = {{k = 10, level = 36}},
		[31224] = {{k = 10, level = 66}},
		[64901] = {{k = 10, level = 80}},
		[34477] = {{k = 10, level = 70}},
		[45438] = {{k = 10, level = 30}},
		[2094] = {{k = 10, level = 34}},
		[46584] = {{k = 10, level = 56}},
		[498] = {{k = 10, level = 6}},
		[642] = {{k = 10, level = 34}},
		[1022] = {{k = 10, level = 18}},
		[32182] = {{k = 10, level = 10}},
		[47476] = {{k = 10, level = 59}},
		[6552] = {{k = 10, level = 38}},
		[1044] = {{k = 10, level = 18}},
		[29166] = {{k = 10, level = 40}},
		[853] = {{k = 10, level = 8}},
		[31687] = {{k = 10, level = 50}},
		[22812] = {{k = 10, level = 44}},
		[64382] = {{k = 10, level = 71}},
		[20608] = {{k = 10, level = 30}},
		[48707] = {{k = 10, level = 68}},
		[20484] = {{k = 10, level = 20}},
		[740] = {{k = 10, level = 30}},
		[61999] = {{k = 10, level = 72}},
		[64843] = {{k = 10, level = 80}},
		[633] = {{k = 10, level = 10}},
		-----------------------------------
		-- Talent Requirements
		-----------------------------------

		-- Death Knight
		[49039] = {{k = 25, talentIndex = 49039}}, -- Lichborne
		[51052] = {{k = 25, talentIndex = 51052}}, -- Anti-magic Zone
		[49222] = {{k = 25, talentIndex = 49222}}, -- Bone Shield
		[48792] = {{k = 25, talentIndex = 48792}}, -- Icebound Fortitude
		[49016] = {{k = 25, talentIndex = 49016}}, -- Hysteria
		[51271] = {{k = 25, talentIndex = 51271}}, -- Unbreakable Armor
		[49206] = {{k = 25, talentIndex = 49206}}, -- Summon Gargoyle
		[55233] = {{k = 25, talentIndex = 55233}}, -- Vamp Blood
		[49005] = {{k = 25, talentIndex = 49005}}, -- Mark of Blood
		[48982] = {{k = 25, talentIndex = 48982}}, -- Rune Tap
		[49028] = {{k = 25, talentIndex = 250}}, -- Dancing Rune Weapon

		-- Druid
		[16857] = {{k = 25, talentIndex = 16857}}, -- Faerie Fire (Feral)
		[17116] = {{k = 25, talentIndex = 17116}}, -- Nature's Swiftness
		[18562] = {{k = 25, talentIndex = 18562}}, -- Swiftmend
		[22812] = {{k = 25, talentIndex = 22812}}, -- Barkskin
		[22842] = {{k = 25, talentIndex = 22842}}, -- Frenzied Regeneration
		[33357] = {{k = 25, talentIndex = 33357}}, -- Dash
		[50334] = {{k = 25, talentIndex = 50334}}, -- Berserk
		[5209] = {{k = 25, talentIndex = 5209}}, -- Challenging Roar
		[5229] = {{k = 25, talentIndex = 5229}}, -- Enrage
		[53201] = {{k = 25, talentIndex = 53201}}, -- Starfall
		[53227] = {{k = 25, talentIndex = 53227}}, -- Typhoon
		[61336] = {{k = 25, talentIndex = 61336}}, -- Survival Instincts
		[6795] = {{k = 25, talentIndex = 6795}}, -- Growl
		[8983] = {{k = 25, talentIndex = 8983}}, -- Bash
		[33831] = {{k = 25, talentIndex = 33831}}, -- Force of Nature

		-- Hunter
		[19574] = {{k = 25, talentIndex = 19574}}, -- Bestial Wrath
		[23989] = {{k = 25, talentIndex = 23989}}, -- Readiness
		[34490] = {{k = 25, talentIndex = 34490}}, -- Silencing Shot

		-- Mage
		[31687] = {{k = 25, talentIndex = 31687}}, -- Summon Water Elemental

		-- Paladin
		[19752] = {{k = 25, talentIndex = 19752}}, -- Divine Intervention
		[498] = {{k = 25, talentIndex = 498}}, -- Divine Protection
		[64205] = {{k = 25, talentIndex = 64205}}, -- Divine Sacrifice
		[31821] = {{k = 25, talentIndex = 31821}}, -- Aura Mastery
		[20066] = {{k = 25, talentIndex = 20066}}, -- Repentance
		[62124] = {{k = 25, talentIndex = 62124}}, -- Hand of Reckoning
		[31789] = {{k = 25, talentIndex = 31789}}, -- Righteous Defense
		[66233] = {{k = 25, talentIndex = 66233}}, -- Ardent Defender
		[31842] = {{k = 25, talentIndex = 31842}}, -- Divine Illumination
		[20216] = {{k = 25, talentIndex = 20216}}, -- Divine Favor

		-- Priest
		[64044] = {{k = 25, talentIndex = 64044}}, -- Psychic Horror
		[15487] = {{k = 25, talentIndex = 15487}}, -- Silence
		[47788] = {{k = 25, talentIndex = 47788}}, -- Guardian Spirit
		[33206] = {{k = 25, talentIndex = 33206}}, -- Pain Suppression
		[47585] = {{k = 25, talentIndex = 47585}}, -- Dispersion
		[10060] = {{k = 25, talentIndex = 10060}}, -- Powers Infusion
		[48113] = {{k = 25, talentIndex = 48113}}, -- Prayer of Mending
		[724] = {{k = 25, talentIndex = 724}}, -- Prayer of Mending

		-- Rogue
		[51690] = {{k = 25, talentIndex = 51690}}, -- Killing Spree
		[13877] = {{k = 25, talentIndex = 13877}}, -- Blade Flurry
		[13750] = {{k = 25, talentIndex = 13750}}, -- Adrenaline Rush

		-- Shaman
		[16190] = {{k = 25, talentIndex = 16190}}, -- Mana Tide Totem
		[16188] = {{k = 25, talentIndex = 16188}}, -- Nature's Swiftness
		[16166] = {{k = 25, talentIndex = 16166}}, -- Elemental Mastery
		[51533] = {{k = 25, talentIndex = 51533}}, -- Feral Spirit
		[59159] = {{k = 25, talentIndex = 59159}}, -- Thunderstorm

		-- Warlock
		[47241] = {{k = 25, talentIndex = 47241}}, -- Metamorphosis
		[698] = {{k = 25, talentIndex = 698}}, -- Ritual of Summoning
		[29893] = {{k = 25, talentIndex = 29893}}, -- Ritual of Souls

		-- Warrior
		[1161] = {{k = 25, talentIndex = 1161}}, -- Challenging Shout
		[12292] = {{k = 25, talentIndex = 12292}}, -- Death Wish
		[12975] = {{k = 25, talentIndex = 12975}}, -- Last Stand
		[1680] = {{k = 25, talentIndex = 1680}}, -- Whirlwind
		[23881] = {{k = 25, talentIndex = 23881}}, -- Bloodthirst
		[355] = {{k = 25, talentIndex = 355}}, -- Taunt
		[46924] = {{k = 25, talentIndex = 46924}}, -- Bladestorm
		[70845] = {{k = 25, talentIndex = 70845}}, -- Stoicism
		[871] = {{k = 25, talentIndex = 871}}, -- Shield Wall

		-----------------------------------
		-- Specialization Requirements
		-----------------------------------

		-- Shaman
		[2894] = {{k = 30, specialization = 262}}, -- Fire Elemental Totem

		-- Priest (Shadow)
		[15286] = {{k = 30, specialization = 258}}, -- Vampiric Embrace

		-- Priest (Holy)
		[47788] = {{k = 30, specialization = 257}}, -- Guardian Spirit

		-- Priest (Discipline)
		[33206] = {{k = 30, specialization = 256}}, -- Pain Suppression
	},
	["cooldowns"] = {
		-- DEATHKNIGHT
		[51052] = 120, -- Anti-magic Zone
		[49222] = 60, -- Bone Shield
		[49576] = 35, -- Death Grip
		[48792] = 120, -- Icebound Fortitude
		[49039] = 120, -- Lichborne
		[47528] = 10, -- Mind Freeze
		[56222] = 8, -- Dark Command
		[49016] = 180, -- Hysteria
		[48707] = 45, -- Anti-Magic Shell
		[51271] = 60, -- Unbreakable Armor
		[49206] = 180, -- Summon Gargoyle
		[47568] = 300, -- Empower Rune Weapon
		[55233] = 60, -- Vamp Blood
		[42650] = 600, -- Army of the Dead
		[49005] = 180, -- Mark of Blood
		[47476] = 120, -- Strangulate
		[45529] = 60, -- Blood Tap
		[48982] = 30, -- Rune Tap

		-- DRUID
		[16857] = 6, -- Faerie Fire (Feral)
		[17116] = 180, -- Nature's Swiftness
		[18562] = 15, -- Swiftmend
		[22812] = 60, -- Barkskin
		[22842] = 180, -- Frenzied Regeneration
		[29166] = 180, -- Innervate
		[33357] = 180, -- Dash
		[48447] = 480, -- Tranquility
		[48477] = 600, -- Rebirth
		[50334] = 180, -- Berserk
		[5209] = 180, -- Challenging Roar
		[5229] = 60, -- Enrage
		[53201] = 60, -- Starfall
		[53227] = 20, -- Typhoon
		[61336] = 180, -- Survival Instincts
		[6795] = 8, -- Growl
		[8983] = 30, -- Bash
		[33831] = 180, -- Force of Nature

		-- HUNTER
		[60192] = 30, -- Freezing Arrow
		[34477] = 30, -- Misdirection
		[19574] = 120, -- Bestial Wrath
		[19263] = 90, -- Deterrence
		[781] = 25, -- Disengage
		[13809] = 30, -- Frost Trap
		[19801] = 8, -- Tranquilizing Shot
		[3045] = 180, -- Rapid Fire
		[23989] = 180, -- Readiness
		[49067] = 30, -- Explosive Trap
		[34600] = 30, -- Snake Trap
		[34490] = 30,

		-- MAGE
		[2139] = 24, -- Counterspell
		[45438] = 300, -- Ice Block
		[1953] = 15, -- Blink
		[12051] = 240, -- Evocation
		[66] = 180, -- Invisibility
		[55342] = 180, -- Mirror Image

		-- PALADIN
		[53601] = 60, -- Sacred Shield
		[19752] = 600, -- Divine Intervention
		[498] = 180, -- Divine Protection
		[64205] = 120, -- Divine Sacrifice
		[642] = 300, -- Divine Shield
		[10278] = 300, -- Hand of Protection
		[48788] = 1200, -- Lay on Hands
		[1044] = 25, -- Hand of Freedom
		[6940] = 120, -- Hand of Sacrifice
		[1038] = 120, -- Hand of Salvation
		[31821] = 120, -- Aura Mastery
		[20066] = 60, -- Repentance
		[10308] = 60, -- Hammer of Justice
		[48817] = 30, -- Holy Wrath
		[31884] = 120, -- Avenging Wrath
		[54428] = 60, -- Divine Plea
		[62124] = 8, -- Hand of Reckoning
		[31789] = 8, -- Righteous Defense
		[66233] = 120, -- Ardent Defender
		[31842] = 180, -- Divine Illumination
		[20216] = 120, -- Divine Favor

		-- PRIEST
		[64044] = 120, -- Psychic Horror
		[15487] = 45, -- Silence
		[64843] = 480, -- Divine Hymn
		[6346] = 180, -- Fear Ward
		[47788] = 72, -- Guardian Spirit
		[64901] = 360, -- Hymn of Hope
		[33206] = 180, -- Pain Suppression
		[47585] = 75, -- Dispersion
		[10890] = 30, -- Psychic Scream
		[34433] = 300, -- Shadowfiend
		[586] = 30, -- Fade
		[10060] = 96, -- Powers Infusion
		[48113] = 10, -- Prayer of Mending
		[724] = 180, -- Prayer of Mending

		-- ROGUE
		[31224] = 90, -- Cloak of Shadows
		[8643] = 20, -- Kidney Shot
		[57934] = 30, -- Tricks of the Trade
		[1766] = 10, -- Kick
		[51690] = 120, -- Killing Spree
		[26889] = 120, -- Vanish
		[26669] = 150, -- Evasion
		[13877] = 120, -- Blade Flurry
		[13750] = 120, -- Adrenaline Rush
		[51722] = 60, -- Dismantle
		[11305] = 240, -- Sprint
		[2094] = 240, -- Blind
		[48659] = 10, -- Feint

		-- SHAMAN
		[hero] = 300, -- Bloodlust/Heroism
		[57994] = 6, -- Wind Shear
		[51514] = 45, -- Hex
		[16190] = 300, -- Mana Tide Totem
		[16188] = 180, -- Nature's Swiftness
		[21169] = 1800, -- Reincarnation
		[16166] = 180, -- Elemental Mastery
		[51533] = 180, -- Feral Spirit
		[59159] = 35, -- Thunderstorm
		[2894] = 600,

		-- WARLOCK
		[29858] = 300, -- Soulshatter
		[48020] = 30, -- Demonic Circle: Teleport
		[47883] = 900, -- Soulstone Resurrection
		[47241] = 126, -- Metamorphosis
		[698] = 126, -- Ritual of Summoning
		[29893] = 126, -- Ritual of Souls

		-- WARRIOR
		[1161] = 180, -- Challenging Shout
		[12292] = 180, -- Death Wish
		[12323] = 5, -- Piercing Howl
		[12975] = 180, -- Last Stand
		[1680] = 8, -- Whirlwind
		[1719] = 200, -- Recklessness
		[23881] = 4, -- Bloodthirst
		[3411] = 30, -- Intervene
		[355] = 8, -- Taunt
		[46924] = 90, -- Bladestorm
		[5246] = 120, -- Intimidating Shout
		[60970] = 45, -- Heroic Fury
		[64382] = 300, -- Shattering Throw
		[6552] = 10, -- Pummel
		[676] = 60, -- Disarm
		[70845] = 60, -- Stoicism
		[72] = 12, -- Shield Bash
		[871] = 300, -- Shield Wall
	},
	["adjustments"] = {}
}