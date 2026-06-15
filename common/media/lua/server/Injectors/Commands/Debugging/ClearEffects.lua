-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "ClearEffects" then
        local username = player:getUsername()

        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            System.RemovePlayerEffect(username)

            Logging.Info(username .. " cleared effects (Debug)")
        else
            Logging.Warning(username .. " denied clear effects: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)