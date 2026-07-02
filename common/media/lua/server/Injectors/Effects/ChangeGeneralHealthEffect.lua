-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Math = require "Injectors/Utils/Math"

---@class GeneralHealthTickArgs
---@field base number
---@field minRange number
---@field maxRange number
---@field minScale number
---@field maxScale number

---@param player IsoPlayer
---@param ticks number
---@param args GeneralHealthTickArgs
local function OnGeneralHealthTick(player, ticks, args)
    local damage = player:getBodyDamage()
    local health = damage:getOverallBodyHealth()

    local scaled = Math.LinearScale(
        health,
        args.minRange,
        args.maxRange,
        args.minScale,
        args.maxScale
    )

    local delta = args.base * scaled

    if delta > 0 then
        damage:AddGeneralHealth(delta)
    elseif delta < 0 then
        damage:ReduceGeneralHealth(-delta)
    end
end

System.RegisterEffect("ChangeGeneralHealthEffect", OnGeneralHealthTick)