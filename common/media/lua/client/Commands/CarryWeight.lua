if isServer() then return end

local Net = require "Injectors/Utils/Net"

local applied = 0

---@param player IsoPlayer
---@param delta number
local function applyDelta(player, delta)
    if not player or not player.getMaxWeightDelta or not player.setMaxWeightDelta then return end

    player:setMaxWeightDelta(player:getMaxWeightDelta() - applied / 100 + delta / 100)
    applied = delta
end

local function OnServerCommand(module, command, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "CarryWeight" then return end

    applyDelta(getPlayer(), tonumber(args.delta) or 0)
end

local function OnCreatePlayer(playerIndex, player)
    applied = 0
    Net.Send("RequestCarryWeight", {})
end

Events.OnServerCommand.Add(OnServerCommand)
Events.OnCreatePlayer.Add(OnCreatePlayer)