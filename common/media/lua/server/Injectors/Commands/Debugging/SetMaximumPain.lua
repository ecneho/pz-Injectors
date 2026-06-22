-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "SetMaximumPain" then return end

    if not player then return end
    local username = player:getUsername()

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        Logging.Warning(username .. " denied set maximum pain: missing CanMedicalCheat capability")
        return
    end

    local stats = player:getStats()
    if not stats then return end

    stats:set(CharacterStat.PAIN, 999)
    Logging.Info(username .. " set maximum pain (Debug)")
end

Events.OnClientCommand.Add(OnClientCommand)