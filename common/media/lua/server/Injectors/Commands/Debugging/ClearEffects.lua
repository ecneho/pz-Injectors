-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

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
        Logging.Warning(username .. " denied clear effects: missing CanMedicalCheat capability")
        return
    end

    System.RemovePlayerEffect(username)
    Logging.Info(username .. " cleared effects (Debug)")
end

Events.OnClientCommand.Add(OnClientCommand)