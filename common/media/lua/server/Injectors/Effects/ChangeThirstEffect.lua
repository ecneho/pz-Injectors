-- server only
if not isServer() then return end

local System = require "Injectors/System"

local THIRST_STAT = CharacterStat.THIRST

---@class ThirstTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args ThirstTickArgs
local function OnThirstTick(player, ticks, args)
    local stats = player:getStats()
    local thirst = stats:get(THIRST_STAT)

    local updated = thirst + args.amount
    local clamped = THIRST_STAT:clamp(updated)

    local changed = clamped ~= thirst
    if changed then
        stats:set(THIRST_STAT, clamped)
    end
end

System.RegisterEffect("ChangeThirstEffect", OnThirstTick)