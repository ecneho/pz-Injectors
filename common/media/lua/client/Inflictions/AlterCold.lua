--- B42.17 revision
--- @param iso IsoPlayer
function AlterCold(iso, deviation)
    local damage = iso:getBodyDamage()
    local cold = damage:getCatchACold()
    local value = Clamp(cold + deviation, 0, 100)
    damage:setCatchACold(value)
end