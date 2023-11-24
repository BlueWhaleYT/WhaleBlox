--[[
    DO NOT EDIT, content will be changed irregularly
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
local GuiAnimationUtils = require(ReplicatedStorage.WhaleBlox.gui.GuiAnimationUtils)

local customProperties = {
    -->> "WB" means provided by WhaleBlox, for not misunderstanding
    "WB_Alignment", "WB_XAlignment", "WB_YAlignment",
    "WB_ListLayout", "WB_GridLayout",
    "WB_Corner", "WB_Gradient", "WB_AspectRatioConstraint", "WB_Stroke", "WB_Padding"
}

--> Constants
module.DEFAULT_SCREEN_GUI_NAME = "ScreenGui"

module.GRADIENT_RED = ColorSequence.new(Color3.fromHex("ff8b56"), Color3.fromHex("ff007b"))

module.NO_CORNER_RADIUS = UDim.new(0, 0)
module.SMALL_CORNER_RADIUS = UDim.new(0.1, 0)
module.MEDIUM_CORNER_RADIUS = UDim.new(0.3, 0)
module.LARGE_CORNER_RADIUS = UDim.new(1, 0)

--> Public Functions
function module:newScreenGui(name, isIgnoreGuiInset)
    name = name or self.DEFAULT_SCREEN_GUI_NAME
    isIgnoreGuiInset = isIgnoreGuiInset or true

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = name
    ScreenGui.IgnoreGuiInset = isIgnoreGuiInset
    return ScreenGui
end

function module.new(data)
    local className = data.className
    local properties = data.properties
    local children = data.children
    local events = data.events
    local animations = data.animations
    local functions = data.functions

    local instance = UIInstanceBuilder(className, nil, properties, function(instance, property, value)
        if table.find(customProperties, property) then
            applyCustomProperties(instance, className, property, value)
        else
            instance[property] = value
        end
    end)

    if children then
        for _, childData in ipairs(children) do
            local child = module.new(childData)
            child.Parent = instance
        end
    end

    if events then
        for event, callback in pairs(events) do
            if instance[event] and type(callback) == "function" then
                instance[event]:Connect(function()
                    callback(instance)
                end)
            end
        end
    end

    if animations then
        local duration = animations.Duration or 1
        local delayIn = animations.DelayIn or 0
        local delayOut = animations.DelayOut or duration + 2

        for _, value in pairs(animations) do
            if animations.In then
                task.wait(delayIn)
                GuiAnimationUtils:animate(instance, duration, value, true)
            end
            if animations.Out then
                task.wait(delayOut)
                GuiAnimationUtils:animate(instance, duration, value, false)
            end
        end
    end

    if functions then
        functions(instance)
    end

    return instance

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

function module:setAspectRatioConstraint(object, aspectRatio)
    aspectRatio = aspectRatio or 1

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", object)
    UIAspectRatioConstraint.AspectRatio = aspectRatio
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

    local frameFeatures = function()
        v.BackgroundColor3 = Color3.new(1,1,1)
        v.BorderSizePixel = 0
        v.Size = UDim2.new(0.097, 0, 0.166, 0)
    end
    local textFeatures = function()
        v.BackgroundColor3 = Color3.new(1,1,1)
        v.Size = UDim2.new(0.194, 0, 0.083, 0)
        v.Font = Enum.Font.Gotham
        v.TextScaled = true
        v.BorderSizePixel = 0

        local UIPadding = Instance.new("UIPadding", v)
        UIPadding.PaddingLeft = UDim.new(0.2, 0)
        UIPadding.PaddingRight = UDim.new(0.2, 0)
        UIPadding.PaddingTop = UDim.new(0.2, 0)
        UIPadding.PaddingBottom = UDim.new(0.2, 0)
    end
    local imageFeatures = function()
        v.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        v.Size = UDim2.new(0.097, 0, 0.166, 0)
        v.ScaleType = Enum.ScaleType.Stretch
        v.ImageColor3 = Color3.new(1,1,1)
    end

    _G.switch(className, {
        ["Frame"] = function()
            frameFeatures()
        end,
        ["ScrollingFrame"] = function()
            frameFeatures()
            v.BackgroundTransparency = 1
            v.ScrollBarImageTransparency = 0.9
            v.ScrollBarThickness = 8
        end,
        ["TextButton"] = function()
            textFeatures()
        end,
        ["TextLabel"] = function()
            textFeatures()
        end,
        ["ImageLabel"] = function()
            imageFeatures()
        end,
        ["ImageButton"] = function()
            imageFeatures()
        end,

        ["UICorner"] = function()
            v.CornerRadius = module.SMALL_CORNER_RADIUS
        end,
        ["UIGradient"] = function()
            v.Color = module.GRADIENT_RED
        end,
    })
end

function applyCustomProperties(v, className, property, data)

    _G.switch(property, {
        ["WB_Alignment"] = function()
            module:setAlignment(v, data)
        end,
        ["WB_XAlignment"] = function()
            module:setXAlignment(v, data)
        end,
        ["WB_YAlignment"] = function()
            module:setYAlignment(v, data)
        end,

        ["WB_Padding"] = function()
            UIInstanceBuilder("UIPadding", v, data)
        end,
        ["WB_Corner"] = function()
            UIInstanceBuilder("UICorner", v, data)
        end,
        ["WB_Gradient"] = function()
            UIInstanceBuilder("UIGradient", v, data)
        end,
        ["WB_AspectRatioConstraint"] = function()
            UIInstanceBuilder("UIAspectRatioConstraint", v, data)
        end,
        ["WB_Stroke"] = function()
            UIInstanceBuilder("UIStroke", v, data)
        end,
        ["WB_ListLayout"] = function()
            UIInstanceBuilder("UIListLayout", v, data)
        end,
        ["WB_GridLayout"] = function()
            UIInstanceBuilder("UIGridLayout", v, data)
        end
    })
end

function UIInstanceBuilder(className, parent, data, onIterate)
    data = data or {}
    
    local instance = Instance.new(className, parent)

    applyDefaultProperties(instance, className)

    if data then
        for property, value in pairs(data) do
            if onIterate == nil then
                instance[property] = value
            else
                onIterate(instance, property, value)
            end
        end
    end

    return instance
end

return module