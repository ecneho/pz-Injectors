-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Logging = require "Injectors/Utils/Logging"
local Roles = require "Injectors/Utils/Roles"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "TestExternalLogs" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.GeneralCheats) then
        Logging.Warning(username .. " denied test external logs: missing GeneralCheats capability")
        return
    end

    FileLogger.Info("external log")
    Logging.Info(username .. " creating external logs...")
end

Events.OnClientCommand.Add(OnClientCommand)