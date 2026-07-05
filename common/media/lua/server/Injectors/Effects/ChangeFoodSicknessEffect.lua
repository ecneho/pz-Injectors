-- server only
if not isServer() then return end

local System = require "Injectors/System"

local FOOD_SICKNESS_STAT = CharacterStat.FOOD_SICKNESS

---@class FoodSicknessTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args FoodSicknessTickArgs
local function OnFoodSicknessTick(player, ticks, args)
    local stats = player:getStats()
    local sickness = stats:get(FOOD_SICKNESS_STAT)

    local updated = sickness + args.amount
    local clamped = FOOD_SICKNESS_STAT:clamp(updated)

    local changed = clamped ~= sickness
    if changed then
        stats:set(FOOD_SICKNESS_STAT, clamped)
    end
end

System.RegisterEffect("ChangeFoodSicknessEffect", OnFoodSicknessTick)