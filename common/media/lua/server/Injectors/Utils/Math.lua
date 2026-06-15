-- server only
if not isServer() then return end

local Math = {}

---@param value number
---@param minRange number
---@param maxRange number
---@param minScale number
---@param maxScale number
---@return number
function Math.LinearScale(value, minRange, maxRange, minScale, maxScale)
    if value <= minRange then
        return minScale
    elseif value >= maxRange then
        return maxScale
    end

    local norm = (value - minRange) / (maxRange - minRange)
    return minScale + norm * (maxScale - minScale)
end

return Math