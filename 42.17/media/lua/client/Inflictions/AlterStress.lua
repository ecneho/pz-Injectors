--- B42.17 revision
--- @param iso IsoPlayer
function AlterStress(iso, deviation)
    local stats = iso:getStats()
    local stress = stats:get(CharacterStat.STRESS)
    local value = Clamp(stress + deviation / 100, 0, 1)
    stats:set(CharacterStat.STRESS, value)
end