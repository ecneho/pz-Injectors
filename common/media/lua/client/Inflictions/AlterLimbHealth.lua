--- @param iso IsoPlayer
function AlterLimbHealth(iso, deviation)
    local damage = iso:getBodyDamage()
    local parts = damage:getBodyParts()
    local value = Clamp(deviation, 0, 100)

    for index = 0, parts:size() - 1 do
        local part = parts:get(index) ---@type BodyPart
        part:AddHealth(value)
    end
end