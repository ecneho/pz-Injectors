---@param iso IsoPlayer
function Painkill(iso)
    local stats = iso:getStats()
    local pain = stats:get(CharacterStat.PAIN)

    local base = Epinephrine.PAINKILL_BASE_REDUCTION
    local minRange = Epinephrine.PAINKILL_MIN_LINEAR_RANGE
    local maxRange = Epinephrine.PAINKILL_MAX_LINEAR_RANGE
    local minScale = Epinephrine.PAINKILL_MIN_LINEAR_SCALE
    local maxScale = Epinephrine.PAINKILL_MAX_LINEAR_SCALE

    local scale = 0.0

    if pain <= minRange then
        scale = minScale
    elseif pain >= maxRange then
        scale = maxScale
    else
        local norm = (pain - minRange) / (maxRange - minRange)
        scale = minScale + norm * (maxScale - minScale)
    end

    local delta = base * scale
    local value = Clamp(pain - delta, 0, 100)

    print("Changing pain value by: " .. value)

    stats:set(CharacterStat.PAIN, value)
end