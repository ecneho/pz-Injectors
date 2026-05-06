--- B42.17 revision
--- @param iso IsoPlayer
function AlterInfected(iso, isInfected)
    local damage = iso:getBodyDamage()
    damage:setInfected(isInfected)
    damage:setIsFakeInfected(isInfected)
end