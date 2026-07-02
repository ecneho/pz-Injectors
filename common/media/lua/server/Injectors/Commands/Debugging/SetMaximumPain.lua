-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Roles = require "Injectors/Utils/Roles"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "SetMaximumPain" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied set maximum pain: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local stats = player:getStats()
    if not stats then return end

    stats:set(CharacterStat.PAIN, 999)
    FileLogger.Info(string.format(
        "%s set maximum pain (debug).",
        FileLogger.FormatPlayer(player)
    ))
end

Events.OnClientCommand.Add(OnClientCommand)