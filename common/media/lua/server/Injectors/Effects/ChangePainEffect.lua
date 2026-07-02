-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Math = require "Injectors/Utils/Math"

local PAIN_STAT = CharacterStat.PAIN

---@class PainTickArgs
---@field base number
---@field minRange number
---@field maxRange number
---@field minScale number
---@field maxScale number

---@param player IsoPlayer
---@param ticks number
---@param args PainTickArgs
local function OnPainTick(player, ticks, args)
    local stats = player:getStats()
    local pain = stats:get(PAIN_STAT)

    local scaled = Math.LinearScale(
        pain,
        args.minRange,
        args.maxRange,
        args.minScale,
        args.maxScale
    )

    local delta = args.base * scaled

    local updated = pain + delta
    local clamped = PAIN_STAT:clamp(updated)

    local changed = clamped ~= pain
    if changed then
        stats:set(PAIN_STAT, clamped)
    end
end

System.RegisterEffect("ChangePainEffect", OnPainTick)