-- server only
if not isServer() then return end

local System = require "Injectors/System"

local INTOXICATION_STAT = CharacterStat.INTOXICATION

---@class IntoxicationTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args IntoxicationTickArgs
local function OnIntoxicationTick(player, ticks, args)
    local stats = player:getStats()
    local intoxication = stats:get(INTOXICATION_STAT)

    local updated = intoxication + args.amount
    local clamped = INTOXICATION_STAT:clamp(updated)

    local changed = clamped ~= intoxication
    if changed then
        stats:set(INTOXICATION_STAT, clamped)
    end
end

System.RegisterEffect("ChangeIntoxicationEffect", OnIntoxicationTick)