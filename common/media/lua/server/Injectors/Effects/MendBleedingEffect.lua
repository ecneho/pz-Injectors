-- server only
if not isServer() then return end

local System = require "Injectors/System"

---@class MendBleedingTickArgs
---@field base number
---@field coefficients table<BodyPartType, number>

---@param player IsoPlayer
---@param ticks number
---@param args MendBleedingTickArgs
local function OnMendBleedingTick(player, ticks, args)
    local parts = player:getBodyDamage():getBodyParts()

    for i = 0, parts:size() - 1 do
        local part = parts:get(i) ---@type BodyPart
        local partType = part:getType()

        local coefficient = args.coefficients[partType] or 0.0
        local delta = args.base * coefficient

        if delta > 0 then
            if part:bleeding() then
                local bleedingTime = part:getBleedingTime()
                local clamped = math.max(0, bleedingTime - delta)

                if clamped ~= bleedingTime then
                    part:setBleedingTime(clamped)
                end
            end
        end

        if delta < 0 then
            if not part:bleeding() then
                part:setBleeding(true)
            end

            local bleedingTime = part:getBleedingTime()
            part:setBleedingTime(bleedingTime + math.abs(delta))
        end
    end
end

System.RegisterEffect("MendBleedingEffect", OnMendBleedingTick)