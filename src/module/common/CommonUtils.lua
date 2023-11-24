--[[
    DO NOT EDIT, content will be changed irregularly
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

--> Services
local RunService = game:GetService("RunService")

_G.isServer = RunService:IsServer()
_G.isClient = RunService:IsClient()

--> Extended Syntaxes

_G.switch = function(param, caseTable)
    local case = caseTable[param]
    if case then return case() end
    local def = caseTable["default"]
    return def and def() or nil
end

return module