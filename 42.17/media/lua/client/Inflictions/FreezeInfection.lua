--- B42.17 revision
--- @param iso IsoPlayer
function FreezeInfection(iso)
    local damage = iso:getBodyDamage()
    damage:setInfected(false)

    local stats = iso:getStats()
    stats:set(CharacterStat.ZOMBIE_INFECTION, 0)
end