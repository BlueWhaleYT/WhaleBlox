--[[
    DO NOT EDIT, content will be changed irregularly
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--> Utils
local WBEnum = require(ReplicatedStorage.WhaleBlox.base.WBEnum)

--> Public Functions
function module:animate(object, duration, animationType, isIn)
    module.Object = object

    _G.switch(animationType, {
        [WBEnum.WB_AnimationType.Bounce] = function()
            animate(isIn, duration, Enum.EasingStyle.Bounce)
        end,
        [WBEnum.WB_AnimationType.Linear] = function()
            animate(isIn, duration, Enum.EasingStyle.Linear)
        end,
        [WBEnum.WB_AnimationType.Back] = function()
            animate(isIn, duration, Enum.EasingStyle.Back)
        end,
        [WBEnum.WB_AnimationType.Elastic] = function()
            animate(isIn, duration, Enum.EasingStyle.Elastic)
        end,
        [WBEnum.WB_AnimationType.Circular] = function()
            animate(isIn, duration, Enum.EasingStyle.Circular)
        end,
        [WBEnum.WB_AnimationType.Cubic] = function()
            animate(isIn, duration, Enum.EasingStyle.Cubic)
        end,
        [WBEnum.WB_AnimationType.Exponential] = function()
            animate(isIn, duration, Enum.EasingStyle.Exponential)
        end,
        [WBEnum.WB_AnimationType.Quad] = function()
            animate(isIn, duration, Enum.EasingStyle.Quad)
        end,
        [WBEnum.WB_AnimationType.Quart] = function()
            animate(isIn, duration, Enum.EasingStyle.Quart)
        end,
        [WBEnum.WB_AnimationType.Quint] = function()
            animate(isIn, duration, Enum.EasingStyle.Quint)
        end,
        [WBEnum.WB_AnimationType.Sine] = function()
            animate(isIn, duration, Enum.EasingStyle.Sine)
        end,
        [WBEnum.WB_AnimationType.Fade] = function()
            local transparency
            if isIn then transparency = 0
            else transparency = 1 end
            animate(isIn, duration, Enum.EasingStyle.Quad, {BackgroundTransparency = transparency})
        end
    })
end

--> Private Functions
function animate(isIn, duration, easingStyle, data)
    if isIn then
        animateIn(duration, easingStyle, data)
    else
        animateOut(duration, easingStyle, data)
    end
end

function animateIn(duration, easingStyle, tweenData)
    tweenData = tweenData or {}
    local originalPosition = module.Object.Position
    tweenData.Position = originalPosition

    module.Object.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 2, 0)
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out)
    local tween = TweenService:Create(module.Object, tweenInfo, tweenData)

    tween:Play()

    module.Object.Visible = true
end

function animateOut(duration, easingStyle, tweenData)
    tweenData = tweenData or {}
    local originalPosition = module.Object.Position
    local targetPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 2, 0)
    tweenData.Position = targetPosition
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, Enum.EasingDirection.In)
    local tween = TweenService:Create(module.Object, tweenInfo, tweenData)

    tween:Play()

    task.wait(duration) 
    module.Object.Visible = false
end

return module