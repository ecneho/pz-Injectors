--- @param iso IsoPlayer
function MendDeepWounds(iso)
    local parts = iso:getBodyDamage():getBodyParts()
    local baseDelta = Hemostatic.MEND_DEEPWOUND_BASEDELTA

    for i = 0, parts:size() - 1 do
        local part = parts:get(i) ---@type BodyPart

        if part:isDeepWounded() then
            local partType = part:getType()
            local coef = Hemostatic.DEEP_WOUND_COEFFICIENTS[partType] or 0.0

            local deepTime = part:getDeepWoundTime() - (baseDelta * coef)
            part:setDeepWoundTime(math.max(0, deepTime))

            -- deep wounds seem to force cancel any value in the 0-3 range
            if part:getDeepWoundTime() <= 3 then
                part:setDeepWounded(false)
            end
        end
    end
end