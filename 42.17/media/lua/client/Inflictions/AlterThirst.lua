--- B42.17 revision
--- @param iso IsoPlayer
function AlterThirst(iso, deviation)
    local stats = iso:getStats()
    local thirst = stats:get(CharacterStat.THIRST)
    local value = Clamp(thirst + deviation / 100, 0, 1)
    stats:set(CharacterStat.THIRST, value)
end