local L = LibStub("AceLocale-3.0"):NewLocale("Hermes-UI", "frFR")
if not L then return end

-- L["Alive"] = "Alive"
-- L["Anchor Point"] = "Anchor Point"
-- L["Available Bar Color"] = "Available Bar Color"
-- L["Available Font Color"] = "Available Font Color"
-- L["Background"] = "Background"
-- L["Bar Direction"] = "Bar Direction"
-- L["Bars"] = "Bars"
-- L["Bars to Show"] = "Bars to Show"
-- L["Behavior"] = "Behavior"
-- L["Bottom Left"] = "Bottom Left"
-- L["Bottom Right"] = "Bottom Right"
-- L["Bottom to Top"] = "Bottom to Top"
-- L["Cell Padding"] = "Cell Padding"
-- L["Class Colored Borders"] = "Class Colored Borders"
-- L["Color"] = "Color"
-- L["Configure"] = "Configure"
-- L["Conn"] = "Conn"
-- L["Container"] = "Container"
-- L["Cooldown Style"] = "Cooldown Style"
-- L["Default"] = "Default"
-- L["Delete"] = "Delete"
-- L["Drop Shadow"] = "Drop Shadow"
-- L["Enabled"] = "Enabled"
-- L["Font"] = "Font"
-- L["Font Size"] = "Font Size"
-- L["Foreground"] = "Foreground"
-- L["Gap Between Bars"] = "Gap Between Bars"
-- L["Height"] = "Height"
-- L["Hide"] = "Hide"
-- L["Hide Abilities without Senders"] = "Hide Abilities without Senders"
-- L["Hide Self"] = "Hide Self"
-- L["Icon"] = "Icon"
-- L["Inner Padding"] = "Inner Padding"
-- L["Layout"] = "Layout"
-- L["Left"] = "Left"
-- L["Left to Right"] = "Left to Right"
-- L["Lock Window"] = "Lock Window"
-- L["Merge Spells"] = "Merge Spells"
-- L["Name on Right"] = "Name on Right"
-- L["None found"] = "None found"
-- L["On Cooldown Bar Color"] = "On Cooldown Bar Color"
-- L["On Cooldown Font Color"] = "On Cooldown Font Color"
-- L["Only show bar when spell is on cooldown"] = "Only show bar when spell is on cooldown"
-- L["Outline"] = "Outline"
-- L["Padding"] = "Padding"
-- L["Player/Duration Width Ratio (%)"] = "Player/Duration Width Ratio (%)"
-- L["Range"] = "Range"
-- L["Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."] = "Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."
-- L["Reset Position"] = "Reset Position"
-- L["Reverse Direction"] = "Reverse Direction"
-- L["Right"] = "Right"
-- L["Right to Left"] = "Right to Left"
-- L["Scale"] = "Scale"
-- L["Show"] = "Show"
-- L["Show Icon"] = "Show Icon"
-- L["Show Nameplate"] = "Show Nameplate"
-- L["Size"] = "Size"
-- L["Spell Metadata"] = "Spell Metadata"
-- L["Spells"] = "Spells"
-- L["Starts Empty"] = "Starts Empty"
-- L["Starts Full"] = "Starts Full"
-- L["Swap Name and Duration"] = "Swap Name and Duration"
-- L["Texture"] = "Texture"
-- L["Time"] = "Time"
-- L["Tooltip"] = "Tooltip"
-- L["Top Left"] = "Top Left"
-- L["Top Right"] = "Top Right"
-- L["Top to Bottom"] = "Top to Bottom"
-- L["Unavailable Bar Color"] = "Unavailable Bar Color"
-- L["Unavailable Font Color"] = "Unavailable Font Color"
-- L["Use Class Color"] = "Use Class Color"
-- L["Width"] = "Width"
-- L["Window"] = "Window"
-- L["dead"] = "dead"
-- L["offline"] = "offline"
-- L["range"] = "range"

-- L["10 Man (hide 3-8)"] = "10 Man (hide 3-8)"
-- L["25 Man (hide 6-8)"] = "25 Man (hide 6-8)"
-- L["Apply"] = "Apply"
-- L["Blacklist"] = "Blacklist"
-- L["Container and it's settings will be deleted permanently. Continue?"] = "Container and it's settings will be deleted permanently. Continue?"
-- L["Containers"] = "Containers"
-- L["Copy"] = "Copy"
-- L["Disabled"] = "Disabled"
-- L["Duration Timer"] = "Duration Timer"
-- L["Filter Type"] = "Filter Type"
-- L["Hermes isn't tracking any spells or abilities."] = "Hermes isn't tracking any spells or abilities."
-- L["Hermes must be actively Receiving or in Config mode to change UI settings. Config Mode can be turned on in the General tab of Hermes."] = "Hermes must be actively Receiving or in Config mode to change UI settings. Config Mode can be turned on in the General tab of Hermes."
-- L["Hide Dead"] = "Hide Dead"
-- L["Hide Disconnected"] = "Hide Disconnected"
-- L["Hide Not In Range"] = "Hide Not In Range"
-- L["Include all enabled Hermes spells"] = "Include all enabled Hermes spells"
-- L["LOGGER_VIEW_DESCRIPTION"] = "A simple frame where messages are sent when a spell is used and becomes available."
-- L["Move Down"] = "Move Down"
-- L["Move Up"] = "Move Up"
-- L["Name"] = "Name"
-- L["New Container"] = "New Container"
-- L["No description provided"] = "No description provided"
-- L["No views are available, you must have at least one view addon enabled."] = "No views are available, you must have at least one view addon enabled."
-- L["Outline"] = "Outline"
-- L["Player Filters"] = "Player Filters"
-- L["Player Names"] = "Player Names"
-- L["Player Status"] = "Player Status"
-- L["Raid Groups"] = "Raid Groups"
-- L["Show Label"] = "Show Label"
-- L["Show Player Name"] = "Show Player Name"
-- L["Show Target Name"] = "Show Target Name"
-- L["Show Slider"] = "Show Slider"
-- L["Show Spell Name"] = "Show Spell Name"
-- L["Show Time"] = "Show Time"
-- L["Swap Label Positions"] = "Swap Label Positions"
-- L["View"] = "View"
-- L["View Description"] = "View Description"
-- L["View Settings"] = "View Settings"
-- L["Whitelist"] = "Whitelist"

-- L["Alpha"] = "Alpha"
-- L["COOLDOWNBARS_VIEW_DESCRIPTION"] = "Basic spell bars similar to oRA3 or DBM-SpellTimers. Only shows spells on cooldown. Great option for those that don't want to fiddle with Spell Monitor setup for monitoring non Hermes users."
-- L["Direction"] = "Direction"
-- L["Grow Up"] = "Grow Up"

-- L["Bar Options"] = "Bar Options"
-- L["Cell Options"] = "Cell Options"
--[==[ L["GRIDBARS_VIEW_DESCRIPTION"] = [=[A highly configurable spell bar view using a grid layout. Shows both available and unavailable spells.

Features include:
* Ability to merge spells as one.
* Tooltip for additional detail.
* Automatic grid layout based on window size.]=] ]==]
-- L["Vertex Color No Senders"] = "Vertex Color No Senders"
-- L["range"] = "range"

--[==[ L["GRIDBUTTONS_VIEW_DESCRIPTION"] = [=[A button view using a grid layout. Shows both available and unavailable spells.

Features include:
* Minimal screen space.
* Ability to merge spells as one.
* Tooltip for additional detail.
* Automatic grid layout based on window size.]=] ]==]
-- L["Icon Texture"] = "Icon Texture"
-- L["Select from loaded textures"] = "Select from loaded textures"
-- L["Vertex Color Unavailable"] = "Vertex Color Unavailable"

--[==[ L["BARS_VIEW_DESCRIPTION"] = [=[A highly configurable spell bar view. Fewer layout choices than GridBars, but with the advantage of not using a fixed bar count. Shows both available and unavailable spells.

Features include:
* Ability to merge spells as one.
* Adjusts bar count as needed.]=] ]==]
-- L["Bar Location"] = "Bar Location"
-- L["Bottom"] = "Bottom"
-- L["Padding"] = "Padding"
-- L["Top"] = "Top"


L["Blood Elf"] = "Elfe de sang"
L["Draenei"] = "Draeneï"
L["Dwarf"] = "Nain"
L["Gnome"] = "Gnome"
L["Human"] = "Humain"
L["Night Elf"] = "Elfe de la nuit"
L["Orc"] = "Orc"
L["Tauren"] = "Tauren"
L["Troll"] = "Troll"
L["Scourge"] = "Mort-vivant"