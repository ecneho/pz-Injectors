if isClient() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local System = require "Injectors/System"
local Roles = require "Injectors/Utils/Roles"
local Players = require "Injectors/Utils/Players"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "ClearEffects" then return end

    if not player then return end
    local username = Players.Key(player)

    if not Roles.hasCapability(player, "CanMedicalCheat") then
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