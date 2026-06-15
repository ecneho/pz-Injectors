-- server only
if not isServer() then return end

local System = require "Injectors/System"

local HUNGER_STAT = CharacterStat.HUNGER

---@class HungerTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args HungerTickArgs
local function OnHungerTick(player, ticks, args)
    local stats = player:getStats()
    local hunger = stats:get(HUNGER_STAT)

    local updated = hunger + args.amount
    local clamped = HUNGER_STAT:clamp(updated)

    local changed = clamped ~= hunger
    if changed then
        stats:set(HUNGER_STAT, clamped)
    end

    print("hunger: " .. hunger)
    print("hunger updated: " .. updated)
    print("hunger clamped: " .. clamped)
    print("hunger tick: " .. args.amount .. ". ticks left: " .. ticks)
end

System.RegisterEffect("ChangeHungerEffect", OnHungerTick)