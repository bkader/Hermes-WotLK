local parent, ns = ...
local Compat = ns.Compat

local strlen = string.len
local strmatch = string.match
local format = string.format
local tonumber = tonumber

function Compat.HexToRGB(hex)
	local rhex, ghex, bhex
	if strlen(hex) == 6 then
		rhex, ghex, bhex = strmatch("([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})", hex)
	elseif strlen(hex) == 3 then
		rhex, ghex, bhex = strmatch("([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])", hex)
		if rhex and ghex and bhex then
			rhex = rhex .. rhex
			ghex = ghex .. ghex
			bhex = bhex .. bhex
		end
	end
	if not (rhex and ghex and bhex) then
		return 0, 0, 0
	else
		return tonumber(rhex, 16), tonumber(ghex, 16), tonumber(bhex, 16)
	end
end

function Compat.RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return format("%02x%02x%02x", r, g, b)
end

function Compat.HexToRGBPerc(hex)
	local rhex, ghex, bhex, base
	if strlen(hex) == 6 then
		rhex, ghex, bhex = strmatch("([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})", hex)
		base = 255
	elseif strlen(hex) == 3 then
		rhex, ghex, bhex = strmatch("([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])", hex)
		base = 16
	end
	if not (rhex and ghex and bhex) then
		return 0, 0, 0
	else
		return tonumber(rhex, 16) / base, tonumber(ghex, 16) / base, tonumber(bhex, 16) / base
	end
end

function Compat.RGBPercToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function Compat.WrapTextInColorCode(text, colorHexString)
	return format("|c%s%s|r", colorHexString, text)
end