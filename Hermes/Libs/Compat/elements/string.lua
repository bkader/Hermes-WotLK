local parent, ns = ...
local Compat = ns.Compat

local band, rshift, lshift = bit.band, bit.rshift, bit.lshift
local strlen, byte, char = string.len, string.byte, string.char
local tconcat = table.concat

function Compat.HexEncode(str, title)
	local hex = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	local t = (title and title ~= "") and {format("[=== %s ===]", title)} or {}
	local j = 0
	for i = 1, #str do
		if j <= 0 then
			t[#t + 1], j = "\n", 32
		end
		j = j - 1

		local b = byte(str, i)
		t[#t + 1] = hex[band(b, 15) + 1]
		t[#t + 1] = hex[band(rshift(b, 4), 15) + 1]
	end
	if title and title ~= "" then
		t[#t + 1] = "\n" .. t[1]
	end
	return tconcat(t)
end

function Compat.HexDecode(str)
	str = str:gsub("%[.-%]", ""):gsub("[^0123456789ABCDEF]", "")
	if (#str == 0) or (#str % 2 ~= 0) then
		return false, "Invalid Hex string"
	end

	local t, bl, bh = {}
	local i = 1
	repeat
		bl = byte(str, i)
		bl = bl >= 65 and bl - 55 or bl - 48
		i = i + 1
		bh = byte(str, i)
		bh = bh >= 65 and bh - 55 or bh - 48
		i = i + 1
		t[#t + 1] = char(lshift(bh, 4) + bl)
	until i >= #str
	return tconcat(t)
end

local escapeFrame = CreateFrame("Frame")
escapeFrame.fs = escapeFrame:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
escapeFrame:Hide()

function Compat.EscapeStr(str)
	escapeFrame.fs:SetText(str)
	str = escapeFrame.fs:GetText()
	escapeFrame.fs:SetText("")
	return str
end