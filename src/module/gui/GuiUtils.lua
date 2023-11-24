--[[
    DO NOT EDIT
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-->> Variables
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-->> Utils
local WBEnum = require(ReplicatedStorage.WhaleBlox.base.WBEnum)
local CommonUtils = require(ReplicatedStorage.WhaleBlox.common.CommonUtils)

local customProperties = {
    -->> "WB" means provided by WhaleBlox, for not misunderstanding
    "WB_Alignment", "WB_XAlignment", "WB_YAlignment",
    "WB_PaddingAll", "WB_PaddingLeft", "WB_PaddingRight", "WB_PaddingTop", "WB_PaddingBottom",
    "WB_CornerRadiusAll",
    "WB_Gradient"
}

--> Constants

module.DEFAULT_SCREEN_GUI_NAME = "ScreenGui"

--> Public Functions

function module:newScreenGui(name, isIgnoreGuiInset)
    name = name or self.DEFAULT_SCREEN_GUI_NAME
    isIgnoreGuiInset = isIgnoreGuiInset or true

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = name
    ScreenGui.IgnoreGuiInset = isIgnoreGuiInset
    return ScreenGui
end

function module:new(data)
    local className = data.className
    local properties = data.properties
    local children = data.childrens
    local events = data.events
    local functions = data.functions

    local instance = Instance.new(className)

    applyDefaultProperties(instance, className)

    if properties then
        for property, value in pairs(properties) do
            if table.find(customProperties, property) then
                applyCustomProperties(instance, className, property, value)
            else
                instance[property] = value
            end
        end
    end

    if children then
        for _, childData in ipairs(children) do
            local child = self:new(childData)
            child.Parent = instance
        end
    end

    if events then
        for event, callback in pairs(events) do
            if instance[event] and type(callback) == "function" then
                callback(instance)
            end
        end
    end

    if functions then
        functions(instance)
    end

end

function module:setAlignment(object, alignment)
    local anchorPoint, position
    _G.switch(alignment, {
        [WBEnum.WB_Alignment.Left] = function()
            anchorPoint = Vector2.new(0, 0.5)
            position = UDim2.new(0, 0, 0.5, 0)
        end,
        [WBEnum.WB_Alignment.Right] = function()
            anchorPoint = Vector2.new(1, 0.5)
            position = UDim2.new(1, 0, 0.5, 0)
        end,
        [WBEnum.WB_Alignment.Center] = function()
            anchorPoint = Vector2.new(0.5, 0.5)
            position = UDim2.new(0.5, 0, 0.5, 0)
        end
    })
    object.AnchorPoint = anchorPoint
    object.Position = position
end

function module:setXAlignment(object, alignment)
    local anchorPoint, position

    _G.switch(alignment, {
        [WBEnum.WB_XAlignment.Left] = function()
            anchorPoint = Vector2.new(0, object.AnchorPoint.Y)
            position = UDim2.new(0, 0, object.Position.Y.Scale, object.Position.Y.Offset)
        end,
        [WBEnum.WB_XAlignment.Right] = function()
            anchorPoint = Vector2.new(1, object.AnchorPoint.Y)
            position = UDim2.new(1, -object.Size.X.Offset, object.Position.Y.Scale, object.Position.Y.Offset)
        end,
        [WBEnum.WB_XAlignment.Center] = function()
            anchorPoint = Vector2.new(0.5, object.AnchorPoint.Y)
            position = UDim2.new(0.5, -object.Size.X.Offset/2, object.Position.Y.Scale, object.Position.Y.Offset)
        end
    })
    object.AnchorPoint = anchorPoint
    object.Position = position
end

function module:setYAlignment(object, alignment)
    local anchorPoint, position

    _G.switch(alignment, {
        [WBEnum.WB_YAlignment.Top] = function()
            anchorPoint = Vector2.new(object.AnchorPoint.X, 0)
            position = UDim2.new(object.Position.X.Scale, object.Position.X.Offset, 0, 0)
        end,
        [WBEnum.WB_YAlignment.Bottom] = function()
            anchorPoint = Vector2.new(object.AnchorPoint.X, 1)
            position = UDim2.new(object.Position.X.Scale, object.Position.X.Offset, 1, -object.Size.Y.Offset)
        end,
        [WBEnum.WB_YAlignment.Center] = function()
            anchorPoint = Vector2.new(object.AnchorPoint.X, 0.5)
            position = UDim2.new(object.Position.X.Scale, object.Position.X.Offset, 0.5, -object.Size.Y.Offset/2)
        end
    })
    object.AnchorPoint = anchorPoint
    object.Position = position
end

function module:setPadding(object, left, right, top, bottom)
    left = left or 0
    right = right or 0
    top = top or 0
    bottom = bottom or 0

    local UIPadding = Instance.new("UIPadding", object)
    UIPadding.PaddingLeft = left
    UIPadding.PaddingRight = right
    UIPadding.PaddingTop = top
    UIPadding.PaddingBottom = bottom
end

function module:setPaddingAll(object, padding)
    self:setPadding(object, padding, padding, padding, padding)
end

function module:setCornerRadiusAll(object, radius)
    local UICorner = Instance.new("UICorner", object)
    UICorner.CornerRadius = radius
end

function module:applyGradient(object, colorSequence)
    local UIGradient = Instance.new("UIGradient", object)
    UIGradient.Color = colorSequence
end

function module.isGuiObject(object)
    return object:IsA("GuiObject")
end

--> Private Functions

function applyDefaultProperties(v, className)
    _G.switch(className, {
        ["Frame"] = function()
            v.BackgroundColor3 = Color3.new(1,1,1)
            v.BorderSizePixel = 0
            v.Size = UDim2.new(0.097, 0, 0.166, 0)
        end
    })
end

function applyCustomProperties(v, className, property, value)

    _G.switch(property, {
        ["WB_Alignment"] = function()
            module:setAlignment(v, value)
        end,
        ["WB_XAlignment"] = function()
            module:setXAlignment(v, value)
        end,
        ["WB_YAlignment"] = function()
            module:setYAlignment(v, value)
        end,

        ["WB_PaddingAll"] = function()
            module:setPaddingAll(v, value)
        end,
        ["WB_PaddingLeft"] = function()
            module:setPadding(v, value, 0, 0, 0)
        end,
        ["WB_PaddingRight"] = function()
            module:setPadding(v, 0, value, 0, 0)
        end,
        ["WB_PaddingTop"] = function()
            module:setPadding(v, 0, 0, value, 0)
        end,
        ["WB_PaddingBottom"] = function()
            module:setPadding(v, 0, 0, 0, value)
        end,

        ["WB_CornerRadiusAll"] = function()
            module:setCornerRadiusAll(v, value)
        end,

        ["WB_Gradient"] = function()
            module:applyGradient(v, value)
        end
    })
end

return module