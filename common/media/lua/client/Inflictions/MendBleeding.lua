-- no DRY for now, with sandbox vars it may be simpler and less time-consuming to write injector-specific funcs instead
--- @param iso IsoPlayer
function MendBleeding(iso)
    local parts = iso:getBodyDamage():getBodyParts()
    local baseDelta = Hemostatic.MEND_BLEEDING_BASE_REDUCTION

    for i = 0, parts:size() - 1 do
        local part = parts:get(i)

        if part:bleeding() then
            local partType = part:getType()
            local coef = Hemostatic.BLEEDING_COEFFICIENTS[partType] or 0.0

            local bleedTime = part:getBleedingTime() - (baseDelta * coef)
            part:setBleedingTime(math.max(0, bleedTime))
        end
    end
end