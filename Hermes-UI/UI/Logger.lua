local Lib_AceAddon = LibStub("AceAddon-3.0", true)
if not Lib_AceAddon then return end

local Hermes = Lib_AceAddon:GetAddon("Hermes")
local UI = Lib_AceAddon:GetAddon("Hermes-UI")
local ViewManager = UI:GetModule("ViewManager")

local mod = ViewManager:NewModule("Logger")
local L = LibStub("AceLocale-3.0"):GetLocale("Hermes-UI")

-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local FRAMEPOOL = nil

local RESIZER_SIZE = 18
local BUTTON_SIZE = 22

local SLIDER_WIDTH = 18
local SLIDER_THUMB_HEIGHT = 26
local SLIDER_THUMB_WIDTH = 26

local FRAME_WIDTH = 400
local FRAME_HEIGHT = 100

local MIN_FRAME_WIDTH = 160
local MIN_FRAME_HEIGHT = 40

local HEADER_HEIGHT = 18
local ICON_RESIZE = [[Interface\AddOns\Hermes-UI\Textures\Resize.tga]]
local ICON_RESET = [[Interface\AddOns\Hermes-UI\Textures\Reset.tga]]
local ICON_STATUS_NOTREADY = [[Interface\RAIDFRAME\ReadyCheck-NotReady]]
local ICON_STATUS_READY = [[Interface\RAIDFRAME\ReadyCheck-Ready]]

local format = format or string.format

-----------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------
local _deepcopy = Hermes._deepcopy
local _deleteIndexedTable = Hermes._deleteIndexedTable

local function _rotateTexture(self, angle)
	local function GetCorner(angle)
		local Root2 = 2 ^ 0.5
		return 0.5 + cos(angle) / Root2, 0.5 + sin(angle) / Root2
	end

	local LRx, LRy = GetCorner(angle + 45)
	local LLx, LLy = GetCorner(angle + 135)
	local ULx, ULy = GetCorner(angle - 135)
	local URx, URy = GetCorner(angle - 45)
	self:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end

local function _secondsToClock(sSeconds)
	local nSeconds = tonumber(sSeconds)
	if not nSeconds then
		return nil
	end
	if nSeconds < 60 then
		--seconds
		return nil, nil, floor(nSeconds)
	else
		if (nSeconds > 3600) then
			--hours
			local nHours = floor(nSeconds / 3600)
			local nMins = floor(nSeconds / 60 - (nHours * 60))
			local nSecs = floor(nSeconds - nHours * 3600 - nMins * 60)
			return nHours, nMins, nSecs
		else
			--minutes
			local nMins = floor(nSeconds / 60)
			local nSecs = floor(nSeconds - nMins * 60)
			return nil, nMins, nSecs
		end
	end
end

local function _round(num, idp)
	local mult = 10 ^ (idp or 0)
	return floor(num * mult + 0.5) / mult
end

local function _getColorHEX(r, g, b)
	return format("FF%02x%02x%02x", r * 255, g * 255, b * 255)
end

function mod:CreateFramePool()
	FRAMEPOOL = CreateFrame("Frame", nil, UIParent)
	FRAMEPOOL:SetPoint("CENTER")
	FRAMEPOOL:SetWidth(50)
	FRAMEPOOL:SetHeight(50)
	FRAMEPOOL:Hide()
	FRAMEPOOL:EnableMouse(false)
	FRAMEPOOL:SetMovable(false)
	FRAMEPOOL:SetToplevel(false)
	FRAMEPOOL.Frames = {}
end

-----------------------------------------------------------------------
-- Frame
-----------------------------------------------------------------------
function mod:RestoreFramePos(frame)
	local profile = frame.profile
	if (not profile.x or not profile.y) then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:SetWidth(FRAME_WIDTH)
		frame:SetHeight(FRAME_HEIGHT)
		profile.x = frame:GetLeft()
		profile.y = frame:GetTop()
		profile.w = FRAME_WIDTH
		profile.h = FRAME_HEIGHT
	else
		local x = profile.x
		local y = profile.y

		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
		frame:SetWidth(profile.w)
		frame:SetHeight(profile.h)
	end

	frame:SetUserPlaced(nil)
end

function mod:SaveFramePos(frame) --updates saved variables for anchor position
	frame.profile.x = frame:GetLeft()
	frame.profile.y = frame:GetTop()
	frame.profile.w = frame:GetWidth()
	frame.profile.h = frame:GetHeight()
end

function mod:LockFrame(frame, force) --shows or hides the anchor and enabled/disables dragging
	--we don't actually hide the window because everything is parented to it.
	--instead we'll just change the properties to make it appear invisible
	if frame.profile.locked == true or force then
		frame.header:Hide()
		frame.resizer:EnableMouse(false)
		frame.resizer:Hide()
	else
		frame.header:Show()
		frame.resizer:EnableMouse(true)
		frame.resizer:Show()
	end
end

function mod:InitializeFrame(frame, profile)
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetScale(profile.scale)
	frame:SetAlpha(profile.alpha)
	frame:SetBackdropColor(profile.bgColor.r, profile.bgColor.g, profile.bgColor.b, profile.bgColor.a)
	local font = UI:MediaFetch("font", profile.font)
	frame.message:SetFont(font, profile.fontSize)
	if profile.showSlider == true then
		frame.slider:Show()
	else
		frame.slider:Hide()
	end
end

local frame_backdrop = {
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	tile = false,
	tileSize = 32,
	edgeSize = 10,
	insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local header_backdrop = {
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	tile = false,
	tileSize = 32,
	edgeSize = 10,
	insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local function frame_OnHide(self)
	self.resizer:StopMovingOrSizing()
	self:StopMovingOrSizing()
end

local function frame_OnSizeChanged(self)
	self.header:SetWidth(self:GetWidth())
end

local function header_OnDragStart(self)
	local frame = self:GetParent()
	if frame and frame.profile and frame.profile.locked == false then
		frame:StartMoving()
	end
end

local function header_OnDragStop(self)
	local frame = self:GetParent()
	if frame then
		frame:StopMovingOrSizing()
		frame.resizer:StopMovingOrSizing()
		mod:SaveFramePos(frame)
	end
end

local function message_OnMouseWheel(self, direction)
	if direction == 1 then
		self:ScrollUp()
	elseif direction == -1 then
		self:ScrollDown()
	end
end

local function message_OnMessageScrollChanged(self)
	mod:UpdateScrollPosition(self:GetParent())
end

local function reset_OnClick(self, button)
	self.frame.message:Clear()
end

local function reset_OnEnter(self)
	self:SetAlpha(1)
end

local function reset_OnLeave(self)
	self:SetAlpha(0.25)
end

local function slider_OnValueChanged(self)
	local frame = self:GetParent()
	if frame and not self.override then
		local total = frame.message:GetNumMessages()
		local displayed = frame.message:GetNumLinesDisplayed()
		local offset = total - self:GetValue() - displayed
		frame.message:SetScrollOffset(offset)
	end
end

local function resizer_OnEnter(self)
	self:SetAlpha(1)
end

local function resizer_OnLeave(self)
	self:SetAlpha(0.35)
end

local function resizer_OnMouseDown(self, button)
	self:StopMovingOrSizing()
	local frame = self:GetParent()
	frame:StopMovingOrSizing()
	frame:StartSizing()
end

local function resizer_OnMouseUp(self, button)
	self:StopMovingOrSizing()
	local frame = self:GetParent()
	frame:StopMovingOrSizing()
	mod:SaveFramePos(frame)
	mod:UpdateScrollRange(frame)
	mod:UpdateScrollPosition(frame)
end

function mod:CreateFrame()
	---------------------
	--main
	---------------------
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetWidth(FRAME_WIDTH)
	frame:SetHeight(FRAME_HEIGHT)
	frame:SetScale(1)

	frame:EnableMouse(false)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetUserPlaced(false)
	frame:SetToplevel(false)
	frame:SetScript("OnHide", frame_OnHide) -- prevents stuck dragging
	frame:SetScript("OnSizeChanged", frame_OnSizeChanged)
	frame:SetMinResize(MIN_FRAME_WIDTH, MIN_FRAME_HEIGHT)
	frame:SetBackdrop(frame_backdrop)
	frame:SetBackdropColor(0, 0, 0, 0.75)

	---------------------
	--header
	---------------------
	frame.header = frame.header or CreateFrame("Frame", nil, frame)
	frame.header:SetHeight(HEADER_HEIGHT)
	frame.header:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
	frame.header:SetWidth(FRAME_WIDTH)
	frame.header:EnableMouse(true)
	frame.header:SetMovable(true)
	frame.header:SetResizable(true)
	frame.header:SetUserPlaced(false)
	frame.header:SetToplevel(false)
	frame.header:RegisterForDrag("LeftButton")
	frame.header:SetScript("OnDragStart", header_OnDragStart)
	frame.header:SetScript("OnDragStop", header_OnDragStop)
	frame.header:SetBackdrop(header_backdrop)
	frame.header:SetBackdropColor(0.6, 0.6, 0.6, 0.7)
	frame.header:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.7)
	frame.header.text = frame.header:CreateFontString(nil, "ARTWORK")
	frame.header.text:SetFontObject(GameFontNormalSmall)
	frame.header.text:SetTextColor(0.9, 0.9, 0.9, 1)
	frame.header.text:SetText("")
	frame.header.text:SetWordWrap(false)
	frame.header.text:SetNonSpaceWrap(false)
	frame.header.text:SetJustifyH("CENTER")
	frame.header.text:SetJustifyV("CENTER")
	frame.header.text:SetAllPoints()

	---------------------
	--message frame
	---------------------
	frame.message = frame.message or CreateFrame("ScrollingMessageFrame", nil, frame)
	frame.message:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	frame.message:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SLIDER_WIDTH, -2)
	frame.message:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
	frame.message:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SLIDER_WIDTH + 2, 2)
	frame.message:SetJustifyH("LEFT")
	frame.message:SetFading(true)
	frame.message:SetFadeDuration(5)
	frame.message:SetTimeVisible(120)
	frame.message:SetFontObject("ChatFontNormal")
	frame.message:SetMaxLines(1000)
	frame.message:EnableMouse(false)
	frame.message:EnableMouseWheel(1)
	frame.message:SetHyperlinksEnabled(true)
	frame.message:SetScript("OnHyperlinkClick", function(self, link, text, button)
		SetItemRef(link, text)
	end)
	frame.message:SetScript("OnMouseWheel", message_OnMouseWheel)
	frame.message:SetScript("OnMessageScrollChanged", message_OnMessageScrollChanged)

	---------------------
	--reset button
	---------------------
	frame.resetbutton = frame.resetbutton or CreateFrame("Button", nil, frame.message)
	frame.resetbutton:SetWidth(BUTTON_SIZE)
	frame.resetbutton:SetHeight(BUTTON_SIZE)
	frame.resetbutton:SetAlpha(0.3)
	frame.resetbutton:SetPoint("TOPRIGHT", frame.message, "TOPRIGHT", -1, -1)
	frame.resetbutton:SetNormalTexture(ICON_RESET)
	frame.resetbutton:RegisterForClicks("AnyUp")
	frame.resetbutton.frame = frame
	frame.resetbutton:SetScript("OnClick", reset_OnClick)
	frame.resetbutton:SetScript("OnEnter", reset_OnEnter)
	frame.resetbutton:SetScript("OnLeave", reset_OnLeave)

	---------------------
	--slider
	---------------------
	frame.slider = frame.slider or CreateFrame("Slider", nil, frame)
	frame.slider:SetValueStep(1)
	frame.slider.bg = frame.slider:CreateTexture(nil, "BACKGROUND")
	frame.slider.bg:SetAllPoints(true)
	frame.slider.bg:SetTexture(0, 0, 0, 0.5)

	frame.slider.thumb = frame.slider.thumb or frame.slider:CreateTexture(nil, "OVERLAY")
	frame.slider.thumb:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
	frame.slider.thumb:SetSize(SLIDER_THUMB_WIDTH, SLIDER_THUMB_HEIGHT)
	frame.slider:SetThumbTexture(frame.slider.thumb)

	frame.slider:SetOrientation("VERTICAL")
	frame.slider:SetWidth(SLIDER_WIDTH)
	frame.slider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	frame.slider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, RESIZER_SIZE)
	frame.slider:SetScript("OnValueChanged", slider_OnValueChanged)

	---------------------
	--resizer
	---------------------
	frame.resizer = CreateFrame("Frame", nil, frame)
	frame.resizer:SetAlpha(0.35)
	frame.resizer:SetWidth(RESIZER_SIZE)
	frame.resizer:SetHeight(RESIZER_SIZE)
	frame.resizer:EnableMouse(true)
	frame.resizer:RegisterForDrag("LeftButton")
	frame.resizer:SetPoint("BOTTOMRIGHT", frame)
	frame.resizer:SetScript("OnEnter", resizer_OnEnter)
	frame.resizer:SetScript("OnLeave", resizer_OnLeave)
	frame.resizer:SetScript("OnMouseDown", resizer_OnMouseDown)
	frame.resizer:SetScript("OnMouseUp", resizer_OnMouseUp)
	frame.resizer.texture = frame.resizer:CreateTexture()
	frame.resizer.texture:SetTexture(ICON_RESIZE)
	frame.resizer.texture:SetDrawLayer("OVERLAY")
	frame.resizer.texture:SetAllPoints()

	return frame
end

function mod:UpdateScrollRange(frame)
	local total = frame.message:GetNumMessages()
	local displayed = frame.message:GetNumLinesDisplayed()
	frame.slider:SetMinMaxValues(0, total - displayed)
end

function mod:UpdateScrollPosition(frame)
	local total = frame.message:GetNumMessages()
	local current = frame.message:GetCurrentScroll()
	local displayed = frame.message:GetNumLinesDisplayed()
	frame.slider.override = 1
	frame.slider:SetValue(total - current - displayed)
	frame.slider.override = nil
end

function mod:AddMessage(frame, msg)
	local profile = frame.profile
	if profile.showTimestamp == true then
		frame.message:AddMessage(format("|c%s[%s]|r %s",_getColorHEX(profile.fontColor.r, profile.fontColor.g, profile.fontColor.b), date("%X"), msg), 1, 1, 1, 1)
	else
		frame.message:AddMessage(format("%s", msg), 1, 1, 1, 1)
	end

	self:UpdateScrollRange(frame)
	self:UpdateScrollPosition(frame)
end

local outputStr = "|T%s:0:0:0:0|t %s %s"
function mod:AddMessageUsed(frame, instance)
	local link = GetSpellLink(instance.ability.id) or instance.ability.name
	local output = format(outputStr, ICON_STATUS_NOTREADY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), link)

	if instance.target then --add target
		self:AddMessage(frame, output .. " > " .. Hermes:GetClassColorString(instance.target, instance.targetClass))
	else
		self:AddMessage(frame, output)
	end
end

function mod:AddMessageReady(frame, instance)
	local link = GetSpellLink(instance.ability.id) or instance.ability.name
	self:AddMessage(frame, format(outputStr, ICON_STATUS_READY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), link))
end

function mod:FetchFrame(profile)
	local frame
	if (#FRAMEPOOL.Frames > 0) then
		frame = FRAMEPOOL.Frames[1]
		_deleteIndexedTable(FRAMEPOOL.Frames, frame)
	else
		frame = self:CreateFrame()
	end

	self:InitializeFrame(frame, profile)

	return frame
end

function mod:RecycleFrame(frame)
	tinsert(FRAMEPOOL.Frames, frame)
	frame:Hide()
	frame:SetParent(FRAMEPOOL)
	frame:ClearAllPoints()
	frame.message:Clear()
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "Logger"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["LOGGER_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		locked = false,
		scale = 1,
		bgColor = {r = 0, g = 0, b = 0, a = 0.75},
		showSlider = true,
		showTimestamp = true,
		alpha = 1,
		font = "Friz Quadrata TT",
		fontColor = {r = 0.6, g = 0.6, b = 0.6, a = 1},
		fontSize = 12
	}

	return defaults
end

function mod:GetViewOptionsTable(view) --REQUIRED
	local profile = view.profile
	local frame = view.frame
	local options = {
		locked = {
			type = "toggle",
			name = L["Lock Window"],
			width = "normal",
			get = function(info)
				return profile.locked
			end,
			order = 5,
			set = function(info, value)
				profile.locked = value
				self:LockFrame(frame)
			end
		},
		window = {
			type = "group",
			name = L["Window"],
			inline = false,
			order = 10,
			args = {
				scale = {
					type = "range",
					min = 0.1,
					max = 3,
					step = 0.01,
					name = L["Scale"],
					order = 5,
					width = "full",
					get = function(info)
						return profile.scale
					end,
					set = function(info, value)
						profile.scale = value
						frame:SetScale(profile.scale)
					end
				},
				alpha = {
					type = "range",
					min = 0,
					max = 1,
					step = 0.01,
					name = L["Alpha"],
					order = 10,
					width = "full",
					get = function(info)
						return profile.alpha
					end,
					set = function(info, value)
						profile.alpha = value
						frame:SetAlpha(profile.alpha)
					end
				},
				showSlider = {
					type = "toggle",
					name = L["Show Slider"],
					width = "full",
					get = function(info)
						return profile.showSlider
					end,
					order = 15,
					set = function(info, value)
						profile.showSlider = value
						if profile.showSlider == true then
							frame.slider:Show()
						else
							frame.slider:Hide()
						end
					end
				},
				font = {
					type = "select",
					dialogControl = "LSM30_Font",
					order = 20,
					name = L["Font"],
					width = "full",
					values = AceGUIWidgetLSMlists.font,
					get = function(info)
						return profile.font
					end,
					set = function(info, value)
						profile.font = value
						frame.message:SetFont(UI:MediaFetch("font", profile.font), profile.fontSize)
					end
				},
				fontSize = {
					type = "range",
					min = 5,
					max = 30,
					step = 1,
					name = L["Font Size"],
					width = "full",
					get = function(info)
						return profile.fontSize
					end,
					order = 25,
					set = function(info, value)
						profile.fontSize = value
						frame.message:SetFont(UI:MediaFetch("font", profile.font), profile.fontSize)
					end
				},
				bgColor = {
					type = "color",
					hasAlpha = true,
					order = 30,
					name = L["Color"],
					width = "full",
					get = function(info)
						return profile.bgColor.r, profile.bgColor.g, profile.bgColor.b, profile.bgColor.a
					end,
					set = function(info, r, g, b, a)
						profile.bgColor.r = r
						profile.bgColor.g = g
						profile.bgColor.b = b
						profile.bgColor.a = a
						frame:SetBackdropColor(
							profile.bgColor.r,
							profile.bgColor.g,
							profile.bgColor.b,
							profile.bgColor.a
						)
					end
				}
			}
		}
	}

	return options
end

function mod:OnViewNameChanged(view, old, new)
	view.frame.header.text:SetText(view.name)
end

function mod:OnEnable() --REQUIRED
	--add any code here that needs to run whenever Hermes enables/disables the UI plugin
end

function mod:OnDisable() --REQUIRED
	--add any code here that needs to run whenever Hermes enables/disables the UI plugin
end

function mod:OnInitialize() --REQUIRED
	--be default, do not enable this module
	self:SetEnabledState(false)
	self:CreateFramePool()
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	frame.header.text:SetText(view.name)
	self:RestoreFramePos(frame)
	self:LockFrame(frame)
	frame:Show()
end

function mod:ReleaseView(view) --REQUIRED
	self:RecycleFrame(view.frame)
end

function mod:EnableView(view) --REQUIRED
end

function mod:DisableView(view) --REQUIRED
end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local elapsed = instance.initialDuration - instance.remaining
	if elapsed < 1 then
		--only add if it's fresh
		self:AddMessageUsed(view.frame, instance)
	end
end

function mod:OnInstanceStopCooldown(view, ability, instance) --OPTIONAL
	self:AddMessageReady(view.frame, instance)
end

function mod:OnLibSharedMediaUpdate(view, mediatype, key) --OPTIONAL
	--update all the cells in the container
	if view.frame and view.profile and mediatype == "font" and view.profile then
		view.frame.message:SetFont(UI:MediaFetch("font", view.profile.font), view.profile.fontSize)
	end
end