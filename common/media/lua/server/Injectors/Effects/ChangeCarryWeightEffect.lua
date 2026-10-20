if isClient() then return end

local System = require "Injectors/System"
local CarryWeight = require "Injectors/Models/CarryWeight"

---@param player IsoPlayer
local function OnCarryWeightTick(player)
    CarryWeight.Sync(player)
end

System.RegisterEffect("ChangeCarryWeightEffect", OnCarryWeightTick)