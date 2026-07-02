-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Roles = require "Injectors/Utils/Roles"
local UsedInjector = require "Injectors/Settings/UsedInjector"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "UseInjectorIgnoreSafety" then return end

    if not player then return end
    if not clientArgs then return end

    local id = clientArgs.id

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied Injector [%s] admin override: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player), tostring(id)
        ))
        return
    end

    FileLogger.Info(string.format(
        "%s used Injector '%s' with admin override.",
        FileLogger.FormatPlayer(player), tostring(id)
    ))
    UsedInjector.Used(player, id)
end

Events.OnClientCommand.Add(OnClientCommand)