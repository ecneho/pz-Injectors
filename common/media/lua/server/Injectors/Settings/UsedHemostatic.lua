-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Hemostatic = require "Injectors/Variables/Hemostatic"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    if Hemostatic.MEND_BLEEDING_ENABLED then
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
    end

    if Hemostatic.MEND_DEEP_WOUND_ENABLED then
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

    if Hemostatic.OVERDOSE_ENABLED then
        ---@type OverdoseTickArgs
        local overdoseTickArgs = {
            base = Hemostatic.OVERDOSE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeOverdoseEffect",
            1, Hemostatic.OVERDOSE_DELAY, 1,
            overdoseTickArgs)
    end

    if Hemostatic.HUNGER_ENABLED then
        ---@type HungerTickArgs
        local hungerTickArgs = {
            amount = Hemostatic.HUNGER_BASE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeHungerEffect",
            Hemostatic.HUNGER_DURATION,
            Hemostatic.HUNGER_DELAY,
            Hemostatic.HUNGER_RATE,
            hungerTickArgs)
    end

    if Hemostatic.THIRST_ENABLED then
        ---@type ThirstTickArgs
        local thirstTickArgs = {
            amount = Hemostatic.THIRST_BASE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeThirstEffect",
            Hemostatic.THIRST_DURATION,
            Hemostatic.THIRST_DELAY,
            Hemostatic.THIRST_RATE,
            thirstTickArgs)
    end
end

return Settings