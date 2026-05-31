--- B42.17 revision
--- @param iso IsoPlayer
function AlterHunger(iso, deviation)
    local stats = iso:getStats()
    local hunger = stats:get(CharacterStat.HUNGER)
    local value = Clamp(hunger + deviation / 100, 0, 1)
    stats:set(CharacterStat.HUNGER, value)
end