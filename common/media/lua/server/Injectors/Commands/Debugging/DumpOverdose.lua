-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Data = require "Injectors/Utils/Data"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "DumpOverdose" then
        local username = player:getUsername()
        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " dumping overdose value...")
            local overdoseList = Data.GetOverdoseList()
            local overdose = overdoseList[username] or 0
            print(overdose)
        else
            Logging.Warning(username .. " denied overdose dump: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)