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

        if part:bleeding() then
            local partType = part:getType()
            local coefficient = args.coefficients[partType] or 0.0

            local bleedingTime = part:getBleedingTime()
            local delta = args.base * coefficient

            local updated = bleedingTime - delta
            local clamped = math.max(0, updated)

            if clamped ~= bleedingTime then
                part:setBleedingTime(clamped)
            end

            print("part: " .. tostring(partType))
            print("bleeding time: " .. bleedingTime)
            print("updated: " .. updated)
            print("clamped: " .. clamped)
            print("delta: " .. delta)
            print("ticks left: " .. ticks)
        end
    end
end

System.RegisterEffect("MendBleedingEffect", OnMendBleedingTick)