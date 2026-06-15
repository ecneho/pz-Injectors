-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Hemostatic = require "Injectors/Variables/Hemostatic"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    ---@type MendBleedingTickArgs
    local mendBleedingTickArgs = {
        base = Hemostatic.MEND_BLEEDING_BASE_REDUCTION,
        coefficients = Hemostatic.BLEEDING_COEFFICIENTS,
    }

    System.AddPlayerEffect(username, "MendBleedingEffect",
        Hemostatic.MEND_BLEEDING_DURATION,
        Hemostatic.MEND_BLEEDING_DELAY,
        Hemostatic.MEND_BLEEDING_RATE,
        mendBleedingTickArgs
    )

    ---@type MendDeepWoundTickArgs
    local mendDeepWoundTickArgs = {
        base = Hemostatic.MEND_DEEP_WOUND_BASE_REDUCTION,
        coefficients = Hemostatic.DEEPWOUND_COEFFICIENTS,
    }

    System.AddPlayerEffect(username, "MendDeepWoundEffect",
        Hemostatic.MEND_DEEP_WOUND_DURATION,
        Hemostatic.MEND_DEEP_WOUND_DELAY,
        Hemostatic.MEND_DEEP_WOUND_RATE,
        mendDeepWoundTickArgs
    )
end

return Settings