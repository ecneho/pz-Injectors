-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Propital = require "Injectors/Variables/Propital"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    ---@type GeneralHealthTickArgs
    local generalHealthTickArgs = {
        base = Propital.FLAT_HEALING_BASE_ADDITION,
        minRange = Propital.FLAT_HEALING_MIN_LINEAR_RANGE,
        maxRange = Propital.FLAT_HEALING_MAX_LINEAR_RANGE,
        minScale = Propital.FLAT_HEALING_MIN_LINEAR_SCALE,
        maxScale = Propital.FLAT_HEALING_MAX_LINEAR_SCALE,
    }

    System.AddPlayerEffect(username, "ChangeGeneralHealthEffect",
        Propital.FLAT_HEALING_DURATION,
        Propital.FLAT_HEALING_DELAY,
        Propital.FLAT_HEALING_RATE,
        generalHealthTickArgs)
end

return Settings