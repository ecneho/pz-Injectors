-- server only
if not isServer() then return end

local System = require "Injectors/System"

---@param module string The module the command was sent with
---@param command string The command the command was sent with
---@param player IsoPlayer The player who sent the command
---@param args table|nil The arguments table the command was sent with or nil
local function OnClientCommand(module, command, player, args)
    if module == "InjectorsModule" and command == "ChangeHunger" then
        System.AddPlayerEffect(player:getUsername(), 5000)
    end
end

Events.OnClientCommand.Add(OnClientCommand)