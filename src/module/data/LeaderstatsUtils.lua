--[[
    DO NOT EDIT, content will be changed irregularly
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

--> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

--> Utils
local EventUtils = require(ReplicatedStorage.WhaleBlox.common.EventUtils)

--> Variables
local leaderboard = Instance.new("Folder")
leaderboard.Name = "leaderstats"                -- must be "leaderstats"

local dataStore = DataStoreService:GetDataStore("SaveLeaderstats")

--> Public Functions
function module.new(valueName, valueType)
    valueType = valueType or "IntValue"

    local instance = Instance.new(valueType, leaderboard)
    instance.Name = valueName

    module.Value = instance
    module.ValueName = valueName
    return module
end

function module:displayToPlayer(player)
    Stats = leaderboard:Clone()
    Stats.Parent = player
end

function module:increment(value, valueName, player)
    valueName = valueName or module.ValueName
    
    player.leaderstats:WaitForChild(valueName).Value += value
    return module
end

function module:decrement(value, valueName, player)
    valueName = valueName or module.ValueName
    
    player.leaderstats:WaitForChild(valueName).Value -= value
    return module
end

function module:setValue(value, valueName, player)
    valueName = valueName or module.ValueName
    
    player.leaderstats:WaitForChild(valueName).Value = value
    return module
end

function module:resetValue(valueName, player)
    valueName = valueName or m.ValueName
    
    self:setValue(0, valueName, player)
    return module
end

function module:onValueHandle(onExecute)
    onExecute(module.Value)
    return module
end

function module:storeAllValues(player)
    local savedData = {}
    for _, v in pairs(player.leaderstats:GetChildren()) do
        savedData[v.Name] = v.Value
    end
    local success, err = pcall(function()
        dataStore:SetAsync(player.UserId, savedData)
    end)
    if not success then error(err) end
end

function module:loadAllStoredValues(player)
    local data = nil
    local success, err = pcall(function()
        data = dataStore:GetAsync(player.UserId)
    end)
    if success then
        if data then
            for i, v in data do
                local valueName = player:WaitForChild("leaderstats"):WaitForChild(i)
                valueName.Value = v
            end
        end
    else
        error(err)
    end
end

return module