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

        if part:isDeepWounded() then
            local partType = part:getType()
            local coefficient = args.coefficients[partType] or 1.0

            local deepWoundTime = part:getDeepWoundTime()
            local delta = args.base * coefficient

            local updated = deepWoundTime - delta
            local clamped = math.max(0, updated)

            if clamped ~= deepWoundTime then
                part:setDeepWoundTime(clamped)
            end

            if clamped <= 3 then
                part:setDeepWounded(false)
            end
        end
    end
end

System.RegisterEffect("MendDeepWoundEffect", OnMendDeepWoundTick)