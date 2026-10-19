if isClient() then return end

local Roles = {}

---@param player IsoPlayer
---@param capability string
function Roles.hasCapability(player, capability)
    if not isServer() then return true end

    return player:getRole():hasCapability(Capability[capability])
end

return Roles