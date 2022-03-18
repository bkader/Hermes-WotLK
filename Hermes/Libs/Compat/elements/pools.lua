local parent, ns = ...
local Compat = ns.Compat
local Noop = Compat.Private.Noop

local select, next = select, next
local pairs, ipairs = pairs, ipairs
local CreateFrame = CreateFrame

local function Mixin(obj, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...)
		for k, v in pairs(mixin) do
			obj[k] = v
		end
	end
	return obj
end

local function CreateFromMixins(...)
	return Mixin({}, ...)
end

local function CreateAndInitFromMixin(mixin, ...)
	local obj = CreateFromMixins(mixin)
	obj:Init(...)
	return obj
end

local ObjectPoolMixin = {}

function ObjectPoolMixin:OnLoad(createFunc, resetFunc)
	self.createFunc, self.resetFunc = createFunc, resetFunc
	self.activeObjects, self.inactiveObjects = {}, {}
	self.numActiveObjects = 0
end

function ObjectPoolMixin:Acquire()
	local numInactiveObjects = #self.inactiveObjects
	if numInactiveObjects > 0 then
		local obj = self.inactiveObjects[numInactiveObjects]
		self.activeObjects[obj] = true
		self.numActiveObjects = self.numActiveObjects + 1
		self.inactiveObjects[numInactiveObjects] = nil
		return obj, false
	end

	local newObj = self.createFunc(self)
	if self.resetFunc and not self.disallowResetIfNew then
		self.resetFunc(self, newObj)
	end
	self.activeObjects[newObj] = true
	self.numActiveObjects = self.numActiveObjects + 1
	return newObj, true
end

function ObjectPoolMixin:Release(obj)
	if self:IsActive(obj) then
		self.inactiveObjects[#self.inactiveObjects + 1] = obj
		self.activeObjects[obj] = nil
		self.numActiveObjects = self.numActiveObjects - 1
		if self.resetFunc then
			self.resetFunc(self, obj)
		end
		return true
	end
	return false
end

function ObjectPoolMixin:ReleaseAll()
	for obj in pairs(self.activeObjects) do
		self:Release(obj)
	end
end

function ObjectPoolMixin:SetResetDisallowedIfNew(disallowed)
	self.disallowResetIfNew = disallowed
end

function ObjectPoolMixin:EnumerateActive()
	return pairs(self.activeObjects)
end

function ObjectPoolMixin:GetNextActive(current)
	return (next(self.activeObjects, current))
end

function ObjectPoolMixin:GetNextInactive(current)
	return (next(self.inactiveObjects, current))
end

function ObjectPoolMixin:IsActive(object)
	return (self.activeObjects[object] ~= nil)
end

function ObjectPoolMixin:GetNumActive()
	return self.numActiveObjects
end

function ObjectPoolMixin:EnumerateInactive()
	return ipairs(self.inactiveObjects)
end

local function CreateObjectPool(createFunc, resetFunc)
	local objectPool = CreateFromMixins(ObjectPoolMixin)
	objectPool:OnLoad(createFunc, resetFunc)
	return objectPool
end

local FramePoolMixin = CreateFromMixins(ObjectPoolMixin)

local function FramePoolFactory(framePool)
	return CreateFrame(framePool.frameType, nil, framePool.parent, framePool.frameTemplate)
end

local CreateForbiddenFrame = CreateForbiddenFrame or Noop
local function ForbiddenFramePoolFactory(framePool)
	return CreateForbiddenFrame(framePool.frameType, nil, framePool.parent, framePool.frameTemplate)
end

function FramePoolMixin:OnLoad(frameType, parent, frameTemplate, resetFunc, forbidden)
	if forbidden then
		ObjectPoolMixin.OnLoad(self, ForbiddenFramePoolFactory, resetFunc)
	else
		ObjectPoolMixin.OnLoad(self, FramePoolFactory, resetFunc)
	end
	self.frameType = frameType
	self.parent = parent
	self.frameTemplate = frameTemplate
end

function FramePoolMixin:GetTemplate()
	return self.frameTemplate
end

local function FramePool_Hide(_, frame)
	frame:Hide()
end

local function FramePool_HideAndClearAnchors(_, frame)
	frame:Hide()
	frame:ClearAllPoints()
end

local function CreateFramePool(frameType, parent, frameTemplate, resetFunc, forbidden)
	local framePool = CreateFromMixins(FramePoolMixin)
	framePool:OnLoad(frameType, parent, frameTemplate, resetFunc or FramePool_HideAndClearAnchors, forbidden)
	return framePool
end

local TexturePoolMixin = CreateFromMixins(ObjectPoolMixin)

local function TexturePoolFactory(texturePool)
	return texturePool.parent:CreateTexture(nil, texturePool.layer, texturePool.textureTemplate, texturePool.subLayer)
end

function TexturePoolMixin:OnLoad(parent, layer, subLayer, textureTemplate, resetFunc)
	ObjectPoolMixin.OnLoad(self, TexturePoolFactory, resetFunc)
	self.parent = parent
	self.layer = layer
	self.subLayer = subLayer
	self.textureTemplate = textureTemplate
end

local function CreateTexturePool(parent, layer, subLayer, textureTemplate, resetFunc)
	local texturePool = CreateFromMixins(TexturePoolMixin)
	texturePool:OnLoad(parent, layer, subLayer, textureTemplate, resetFunc or FramePool_HideAndClearAnchors)
	return texturePool
end

Compat.Mixin = Mixin
Compat.CreateFromMixins = CreateFromMixins
Compat.CreateAndInitFromMixin = CreateAndInitFromMixin
Compat.ObjectPoolMixin = ObjectPoolMixin
Compat.CreateObjectPool = CreateObjectPool
Compat.FramePoolMixin = FramePoolMixin
Compat.FramePool_Hide = FramePool_Hide
Compat.FramePool_HideAndClearAnchors = FramePool_HideAndClearAnchors
Compat.CreateFramePool = CreateFramePool
Compat.TexturePoolMixin = TexturePoolMixin
Compat.TexturePool_Hide = FramePool_Hide
Compat.TexturePool_HideAndClearAnchors = FramePool_HideAndClearAnchors
Compat.CreateTexturePool = CreateTexturePool