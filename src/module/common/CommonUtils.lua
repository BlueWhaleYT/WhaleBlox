--[[
    DO NOT EDIT
    Developer: BlueWhaleYT (IGN: Whale0u0u)
--]]

local module = {}

--> Extended Syntaxes

_G.switch = function(param, case_table)
    local case = case_table[param]
    if case then return case() end
    local def = case_table["default"]
    return def and def() or nil
end

return module