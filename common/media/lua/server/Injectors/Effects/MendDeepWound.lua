-- server only
if not isServer() then return end

local System = require "Injectors/System"

---@class MendDeepWoundTickArgs
---@field base number
---@field coefficients table<BodyPartType, number>

---@param player IsoPlayer
---@param ticks number
---@param args MendDeepWoundTickArgs
local function OnMendDeepWoundTick(player, ticks, args)
    local parts = player:getBodyDamage():getBodyParts()

    for i = 0, parts:size() - 1 do
        local part = parts:get(i) ---@type BodyPart
        local partType = part:getType()

        local coefficient = args.coefficients[partType] or 1.0
        local delta = args.base * coefficient

        if delta < 0 and not part:isDeepWounded() then
            part:setDeepWounded(true)
        end

        if part:isDeepWounded() then
            local deepWoundTime = part:getDeepWoundTime()
            local updated = math.max(0, deepWoundTime - delta)

            if updated ~= deepWoundTime then
                part:setDeepWoundTime(updated)
            end

            if delta > 0 and updated <= 3 then
                part:setDeepWounded(false)
            end
        end
    end
end

System.RegisterEffect("MendDeepWoundEffect", OnMendDeepWoundTick)