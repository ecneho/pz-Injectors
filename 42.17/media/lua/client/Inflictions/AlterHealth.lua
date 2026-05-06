--- B42.17 revision
--- @param iso IsoPlayer
function AlterHealth(iso, deviation)
    local damage = iso:getBodyDamage()
    local health = damage:getOverallBodyHealth()
    local value = health + deviation

    if deviation >= 0 then
        if value < 100 then
            damage:AddGeneralHealth(deviation)
        end
    else
        damage:ReduceGeneralHealth(math.abs(deviation))
    end
end