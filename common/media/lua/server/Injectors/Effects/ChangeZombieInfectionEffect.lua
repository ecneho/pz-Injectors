-- server only
if not isServer() then return end

local System = require "Injectors/System"

local ZOMBIE_INFECTION_STAT = CharacterStat.ZOMBIE_INFECTION

---@class ZombieInfectionTickArgs
---@field amount number

---@param player IsoPlayer
---@param ticks number
---@param args ZombieInfectionTickArgs
local function OnZombieInfectionTick(player, ticks, args)
    local stats = player:getStats()
    local infection = stats:get(ZOMBIE_INFECTION_STAT)

    local updated = infection + args.amount
    local clamped = ZOMBIE_INFECTION_STAT:clamp(updated)

    local changed = clamped ~= infection
    if changed then
        stats:set(ZOMBIE_INFECTION_STAT, clamped)
    end
end

System.RegisterEffect("ChangeZombieInfectionEffect", OnZombieInfectionTick)