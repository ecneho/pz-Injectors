-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local System = require "Injectors/System"
local Roles = require "Injectors/Utils/Roles"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "ClearEffects" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied clear effects: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    FileLogger.Info(string.format(
        "%s requested effect clearance (debug).",
        FileLogger.FormatPlayer(player)
    ))
    System.RemovePlayerEffect(username)
end

Events.OnClientCommand.Add(OnClientCommand)