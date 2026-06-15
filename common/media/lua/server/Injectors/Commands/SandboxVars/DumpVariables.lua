-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"
local Common = require "Injectors/Variables/Common"
local Epinephrine = require "Injectors/Variables/Epinephrine"
local Hemostatic = require "Injectors/Variables/Hemostatic"
local Propital = require "Injectors/Variables/Propital"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "DumpVariables" then
        local username = player:getUsername()
        if Roles.hasCapability(player, Capability.SandboxOptions) then
            Logging.Info(username .. " dumping sandbox variables...")
            Common.DumpVariables()
            Propital.DumpVariables()
            Epinephrine.DumpVariables()
            Hemostatic.DumpVariables()
        else
            Logging.Warning(username .. " denied variables dump: missing SandboxOptions capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)