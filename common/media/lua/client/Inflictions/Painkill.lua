--- @param iso IsoPlayer
function Painkill(iso, deviation)
    local stats = iso:getStats()
    local pain = stats:get(CharacterStat.PAIN)
    -- this should be moved to sandbox vars
    -- normalize: 0 is min, 25 is max
    local min = 0
    local max = 25
    local norm = (pain - min) / (max - min)
    norm = Clamp(norm, 0, 1)
    -- this should be moved too
    -- min: 0.75x, max: 3.0x
    local scale = 0.75 + norm * 3.0
    local value = Clamp(pain - (deviation * scale), 0, 100)
    stats:set(CharacterStat.PAIN, value)
end