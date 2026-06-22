-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"
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
        Logging.Warning(username .. " denied overdose dump: missing CanMedicalCheat capability")
        return
    end

    Logging.Info(username .. " dumping overdose value...")
    print(Overdose.Get(username))
end

Events.OnClientCommand.Add(OnClientCommand)