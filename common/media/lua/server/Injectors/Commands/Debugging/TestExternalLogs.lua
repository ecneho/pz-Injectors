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
    if module == "InjectorsModule" and command == "TestExternalLogs" then
        local username = player:getUsername()
        if Roles.hasCapability(player, Capability.GeneralCheats) then
            FileLogger.Info("external log")
            Logging.Info(username .. " testing external logs...")
        else
            Logging.Warning(username .. " denied test external logs: missing GeneralCheats capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)