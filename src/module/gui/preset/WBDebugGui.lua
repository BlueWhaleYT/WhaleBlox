--[[
    DO NOT EDIT
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local preset = {}

-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-->> Utils
local WBEnum = require(ReplicatedStorage.WhaleBlox.base.WBEnum)
local CommonUtils = require(ReplicatedStorage.WhaleBlox.common.CommonUtils)
local GuiUtils = require(ReplicatedStorage.WhaleBlox.gui.GuiUtils)

--> Public Functions
function preset:init(parent)
    for _, child in pairs(parent:GetDescendants()) do
        local propertyText = nil
        if GuiUtils.isGuiObject(child) then
            propertyText = "<b>ClassName: </b>" .. child.ClassName ..
                "\n<b>Name: </b>" .. child.Name ..
                "\n<b>Parent: </b>" .. child.Parent.Name ..
                "\n<b>Position: </b>" .. tostring(child.Position) ..
                "\n<b>Size: </b>" .. tostring(child.Size)
            -- if child:IsA("TextLabel") or child:IsA("TextButton") then
            --     propertyText = propertyText ..
            --         "\nTextColor3: " .. color3torgb(child.TextColor3)
            -- end
        end
        if GuiUtils.isGuiObject(child) then
            local DebugFrame = nil

            GuiUtils:new({
                className = "Frame",
                properties = {
                    Name = "DebugFrame",
                    Parent = parent,
                    Size = UDim2.new(1, 0, 0.3, 0),
                    WB_XAlignment = WBEnum.WB_XAlignment.Left,
                    WB_YAlignment = WBEnum.WB_YAlignment.Bottom,
                    BackgroundColor3 = Color3.new(0,0,0),
                    BackgroundTransparency = 0.4,
                    Visible = false,
                    WB_Stroke = {
                        Name = "DebugStroke",
                        Parent = child,
                        Thickness = 0,
                        Color = Color3.fromRGB(124, 165, 255),
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                },
                children = {
                    {
                        className = "TextLabel",
                        properties = {
                            Name = "DebugLabel",
                            Text = propertyText,
                            Size = UDim2.new(1, 0, 1, 0),
                            TextColor3 = Color3.new(1,1,1),
                            BackgroundTransparency = 1,
                            TextScaled = true,
                            Font = Enum.Font.Gotham,
                            WB_PaddingAll = UDim.new(0.1, 0),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextTransparency = 0.1,
                            RichText = true
                        },
                    },
                    WB_Corner = {}
                },
                functions = function(frame)
                    DebugFrame = frame
                end
            })

            child.MouseEnter:Connect(function()
                child.DebugStroke.Thickness = 3
                --DebugFrame.Position = UDim2.new(0, child.AbsolutePosition.X, 0, child.AbsolutePosition.Y + child.AbsoluteSize.Y)
                DebugFrame.Visible = true
            end)

            child.MouseLeave:Connect(function()
                child.DebugStroke.Thickness = 0
                DebugFrame.Visible = false
            end)
            
        end
    end
end

return preset