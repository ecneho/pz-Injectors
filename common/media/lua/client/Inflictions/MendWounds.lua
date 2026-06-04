--- @param iso IsoPlayer
function MendWounds(iso, deviation)
    -- this should be moved to sandbox vars
    -- multiplier for deep wounds
    local multiplier = 0.5
    local parts = iso:getBodyDamage():getBodyParts()
    for index = 0, parts:size() - 1 do
        local part = parts:get(index) ---@type BodyPart

        if (part:isDeepWounded()) then
            local deepTime = part:getDeepWoundTime() - deviation * multiplier;
            part:setDeepWoundTime(math.max(deepTime, 0));

            -- deep wounds seem to force cancel any value in the 0-3 range
            if (part:getDeepWoundTime() <= 3) then
                part:setDeepWounded(false);
            end
        end

        if (part:bleeding()) then
            local bleedTime = part:getBleedingTime() - deviation;
            part:setBleedingTime(math.max(bleedTime, 0))
        end
    end
end