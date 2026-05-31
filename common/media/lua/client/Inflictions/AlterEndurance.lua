--- B42.17 revision
--- @param iso IsoPlayer
function AlterEndurance(iso, deviation)
    local stats = iso:getStats()
    local endurance = stats:get(CharacterStat.ENDURANCE)
    local value = Clamp(endurance + deviation / 100, 0, 1)
    stats:set(CharacterStat.ENDURANCE, value)
end