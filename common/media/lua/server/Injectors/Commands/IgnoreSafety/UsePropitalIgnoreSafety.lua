-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"
local Propital = require "Injectors/Settings/UsedPropital"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "UsePropitalIgnoreSafety" then
        local username = player:getUsername()
        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " used Propital (Admin Override)")
            Propital.Used(player)
        else
            Logging.Warning(username .. " denied Propital admin override: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)