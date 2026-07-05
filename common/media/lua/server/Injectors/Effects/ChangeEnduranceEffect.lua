-- server only
if not isServer() then return end

local System = require "Injectors/System"

local ENDURANCE_STAT = CharacterStat.ENDURANCE

---@class EnduranceTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args EnduranceTickArgs
local function OnEnduranceTick(player, ticks, args)
    local stats = player:getStats()
    local endurance = stats:get(ENDURANCE_STAT)

    local updated = endurance + args.amount
    local clamped = ENDURANCE_STAT:clamp(updated)

    local changed = clamped ~= endurance
    if changed then
        stats:set(ENDURANCE_STAT, clamped)
    end
end

System.RegisterEffect("ChangeEnduranceEffect", OnEnduranceTick)