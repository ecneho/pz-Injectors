-- server only
if not isServer() then return end

local System = require "Injectors/System"

local TEMPERATURE_STAT = CharacterStat.TEMPERATURE

---@class TemperatureTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args TemperatureTickArgs
local function OnTemperatureTick(player, ticks, args)
    local stats = player:getStats()
    local temperature = stats:get(TEMPERATURE_STAT)

    local updated = temperature + args.amount
    local clamped = TEMPERATURE_STAT:clamp(updated)

    local changed = clamped ~= temperature
    if changed then
        stats:set(TEMPERATURE_STAT, clamped)
    end
end

System.RegisterEffect("ChangeTemperatureEffect", OnTemperatureTick)