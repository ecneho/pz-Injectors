-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "ReduceGeneralHealth" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        Logging.Warning(username .. " denied reduce general health: missing CanMedicalCheat capability")
        return
    end

    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then return end

    bodyDamage:ReduceGeneralHealth(20)
    Logging.Info(username .. " reduced general health (Debug)")
end

Events.OnClientCommand.Add(OnClientCommand)