if isClient() then return end

local CarryWeight = require "Injectors/Models/CarryWeight"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "RequestCarryWeight" then return end

    if not player then return end
    CarryWeight.Sync(player, true)
end

Events.OnClientCommand.Add(OnClientCommand)