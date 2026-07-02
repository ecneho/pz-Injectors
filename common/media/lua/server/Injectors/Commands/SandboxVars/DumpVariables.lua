-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Roles = require "Injectors/Utils/Roles"
local Common = require "Injectors/Variables/Common"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "DumpVariables" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.SandboxOptions) then
        FileLogger.Warn(string.format(
            "%s was denied sandbox variables dump: missing SandboxOptions capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    FileLogger.Info(string.format(
        "%s requested sandbox variables dump.",
        FileLogger.FormatPlayer(player)
    ))
    Common.DumpVariables()
end

Events.OnClientCommand.Add(OnClientCommand)