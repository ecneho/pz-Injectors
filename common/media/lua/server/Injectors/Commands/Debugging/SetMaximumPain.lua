-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "SetMaximumPain" then
        local username = player:getUsername()

        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            player:getStats():set(CharacterStat.PAIN, 999)

            Logging.Info(username .. " set maximum pain (Debug)")
        else
            Logging.Warning(username .. " denied set maximum pain: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)