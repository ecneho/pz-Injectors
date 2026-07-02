-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Roles = require "Injectors/Utils/Roles"
local Overdose = require "Injectors/Models/Overdose"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "DumpOverdose" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied overdose dump: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    FileLogger.Info(string.format(
        "%s dumped overdose value: %s",
        FileLogger.FormatPlayer(player),
        tostring(Overdose.Get(username))
    ))
end

Events.OnClientCommand.Add(OnClientCommand)