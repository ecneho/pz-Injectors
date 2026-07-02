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
    if command ~= "ReduceGeneralHealth" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied reduce general health: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then return end

    bodyDamage:ReduceGeneralHealth(20)
    FileLogger.Info(string.format(
        "%s reduced general health (debug).",
        FileLogger.FormatPlayer(player)
    ))
end

Events.OnClientCommand.Add(OnClientCommand)