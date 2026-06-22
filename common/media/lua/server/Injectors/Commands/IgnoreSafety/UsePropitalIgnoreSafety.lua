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
    if module ~= "InjectorsModule" then return end
    if command ~= "UsePropitalIgnoreSafety" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        Logging.Warning(username .. " denied Propital admin override: missing CanMedicalCheat capability")
        return
    end

    Logging.Info(username .. " used Propital (Admin Override)")
    Propital.Used(player)
end

Events.OnClientCommand.Add(OnClientCommand)