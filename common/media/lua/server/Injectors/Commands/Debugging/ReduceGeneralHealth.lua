-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "ReduceGeneralHealth" then
        local username = player:getUsername()

        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            player:getBodyDamage():ReduceGeneralHealth(20)

            Logging.Info(username .. " reduced general health (Debug)")
        else
            Logging.Warning(username .. " denied reduce general health: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)