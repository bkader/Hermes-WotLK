local parent, ns = ...
local Compat = ns.Compat

local CreateFromMixins = Compat.CreateFromMixins
local WrapTextInColorCode = Compat.WrapTextInColorCode

local format = string.format

local ColorMixin = {
	OnLoad = function(self, r, g, b, a) self:SetRGBA(r, g, b, a) end,
	SetRGB = function(self, r, g, b) self:SetRGBA(r, g, b, nil) end,
	GetRGB = function(self) return self.r, self.g, self.b end,
	GetRGBA = function(self) return self.r, self.g, self.b, self.a end,
	SetRGBA = function(self, r, g, b, a) self.r, self.g, self.b, self.a = r, g, b, a end,
	GetRGBAsBytes = function(self) return self.r * 255, self.g * 255, self.b * 255 end,
	GetRGBAAsBytes = function(self) return self.r * 255, self.g * 255, self.b * 255, (self.a or 1) * 255 end,
	IsEqualTo = function(self, obj) return (self.r == obj.r and self.g == obj.g and self.b == obj.b and self.a == obj.a) end,
	GenerateHexColor = function(self) return format("ff%.2x%.2x%.2x", self:GetRGBAsBytes()) end,
	GenerateHexColorMarkup = function(self) return format("|c%s", self:GenerateHexColor()) end,
	WrapTextInColorCode = function(self, text) return WrapTextInColorCode(text, self:GenerateHexColor()) end
}

local function CreateColor(r, g, b, a)
	local color = CreateFromMixins(ColorMixin)
	color:OnLoad(r, g, b, a)
	return color
end

Compat.ColorMixin = ColorMixin
Compat.CreateColor = CreateColor