-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"
local Hemostatic = require "Injectors/Settings/UsedHemostatic"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "UseHemostaticIgnoreSafety" then
        local username = player:getUsername()
        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " used Hemostatic (Admin Override)")
            Hemostatic.Used(player)
        else
            Logging.Warning(username .. " denied Hemostatic admin override: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)