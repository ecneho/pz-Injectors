---@param iso IsoPlayer
function AddHealth(iso)
    local damage = iso:getBodyDamage()
    local health = damage:getOverallBodyHealth()

    local base = Propital.FLAT_HEALING_BASE_ADDITION
    local minRange = Propital.FLAT_HEALING_MIN_LINEAR_RANGE
    local maxRange = Propital.FLAT_HEALING_MAX_LINEAR_RANGE
    local minScale = Propital.FLAT_HEALING_MIN_LINEAR_SCALE
    local maxScale = Propital.FLAT_HEALING_MAX_LINEAR_SCALE

    local scale = 0.0

    if health <= minRange then
        scale = minScale
    elseif health >= maxRange then
        scale = maxScale
    else
        local norm = (health - minRange) / (maxRange - minRange)
        scale = minScale + norm * (maxScale - minScale)
    end

    local delta = base * scale

    if delta > 0 then
        damage:AddGeneralHealth(delta)
    end
end