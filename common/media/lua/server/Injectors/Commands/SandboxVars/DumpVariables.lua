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
    if module ~= "InjectorsModule" then return end
    if command ~= "DumpVariables" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.SandboxOptions) then
        Logging.Warning(username .. " denied variables dump: missing SandboxOptions capability")
        return
    end

    Logging.Info(username .. " dumping sandbox variables...")
    Common.DumpVariables()
    Propital.DumpVariables()
    Epinephrine.DumpVariables()
    Hemostatic.DumpVariables()
end

Events.OnClientCommand.Add(OnClientCommand)