--- @param iso IsoPlayer
function AddHealth(iso)
    local damage = iso:getBodyDamage()
    local health = damage:getOverallBodyHealth()
    -- this should be moved to sandbox vars
    -- normalize: 0 is min, 100 is max
    local min = 0
    local max = 100
    local norm = (health - min) / (max - min)
    norm = Clamp(norm, 0, 1)
    local inverted = 1 - norm
    -- this should be moved too
    -- min: 2.00x, max: 0.75x
    local scale = 0.75 + inverted * 2.0
    local value = Clamp(health + (Propital.FLAT_HEALING_BASE_ADDITION * scale), 0, 100)
    local delta = value - health
    if delta > 0 then
        damage:AddGeneralHealth(delta)
    end
end