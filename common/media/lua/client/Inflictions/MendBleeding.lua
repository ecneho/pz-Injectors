-- no DRY for now, with sandbox vars it may be simpler and less time-consuming to write injector-specific funcs instead
--- @param iso IsoPlayer
function MendBleeding(iso)
    local parts = iso:getBodyDamage():getBodyParts()
    local baseDelta = Propital.MEND_BLEEDING_BASEDELTA

    for i = 0, parts:size() - 1 do
        local part = parts:get(i)

        if part:bleeding() then
            local partType = part:getType()
            local coef = Propital.COEFFICIENTS[partType] or 0.0 -- fallback if nothing's found
            local bleedTime = part:getBleedingTime() - (baseDelta * coef)
            part:setBleedingTime(math.max(0, bleedTime))
        end
    end
end