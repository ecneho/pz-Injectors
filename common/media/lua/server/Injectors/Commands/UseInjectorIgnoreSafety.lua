-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"
local UsedInjector = require "Injectors/Settings/UsedInjector"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "UseInjectorIgnoreSafety" then return end

    if not player then return end
    if not clientArgs then return end

    local username = player:getUsername()
    local id = clientArgs.id

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        Logging.Warning(username .. " denied Injector (" .. id ..") admin override: missing CanMedicalCheat capability")
        return
    end

    Logging.Info(username .. " used Injector " .. id .. " (Admin Override)")
    UsedInjector.Used(player, id)
end

Events.OnClientCommand.Add(OnClientCommand)