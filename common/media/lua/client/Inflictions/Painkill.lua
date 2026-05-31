--- B42.17 revision
--- @param iso IsoPlayer
function Painkill(iso, deviation)
    local stats = iso:getStats()
    local pain = stats:get(CharacterStat.PAIN)
    local value = Clamp(pain - deviation, 0, 100)
    stats:set(CharacterStat.PAIN, value)
end