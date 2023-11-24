--[[
    DO NOT EDIT, content will be changed irregularly
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

--> Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--> Public Functions
function module:onServerStarts(onExecute)
    RunService.RenderStepped:Connect(onExecute)
end

function module:onServerShutdown(onExecute)
    game:BindToClose(onExecute)
end

function module:onPlayersJoined(onExecute)
    Players.PlayerAdded:Connect(onExecute)
end

function module:onPlayersLeaving(onExecute)
    Players.PlayerRemoving:Connect(onExecute)
end

function module:onPlayerDied(player, onExecute)
    self:onCharacterSpawned(player, function(character)
        character.Humanoid.Died:Connect(onExecute)
    end)
end

function module:onPlayerJumping(player, onExecute)
    self:onCharacterSpawned(player, function(character)
        character.Humanoid.Jumping:Connect(onExecute)
    end)
end

function module:onPlayerRunning(player, onExecute)
    self:onCharacterSpawned(player, function(character)
        character.Humanoid.Running:Connect(onExecute)
    end)
end

function module:onPlayerSeated(player, onExecute)
    self:onCharacterSpawned(player, function(character)
        character.Humanoid.Seated:Connect(onExecute)
    end)
end

function module:onCharacterSpawned(player, onExecute)
    player.CharacterAdded:Connect(onExecute)
end

return module