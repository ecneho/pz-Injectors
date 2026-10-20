if isClient() then return end

local Active = require "Injectors/Models/Active"
local Players = require "Injectors/Utils/Players"
local Net = require "Injectors/Utils/Net"

local CarryWeight = {}

local sent = {}

---@param player IsoPlayer
function CarryWeight.GetTarget(player)
    local effects = Active.GetActiveList()[Players.Key(player)]
    local total = 0

    if effects then
        for _, effect in ipairs(effects) do
            if effect.effectId == "ChangeCarryWeightEffect" and effect.delayLeft <= 0 then
                total = total + (tonumber(effect.customArgs.amount) or 0)
            end
        end
    end

    return total
end

---@param player IsoPlayer
---@param force boolean|nil
function CarryWeight.Sync(player, force)
    local username = Players.Key(player)
    local target = CarryWeight.GetTarget(player)

    if not force and (sent[username] or 0) == target then return end

    sent[username] = target
    Net.Reply(player, "CarryWeight", { delta = target })
end

return CarryWeight