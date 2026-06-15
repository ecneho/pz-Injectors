-- server only
if not isServer() then return end

local Roles = {}

---@param player IsoPlayer
---@param capability Capability
function Roles.hasCapability(player, capability)
    return player:getRole():hasCapability(capability)
end

return Roles