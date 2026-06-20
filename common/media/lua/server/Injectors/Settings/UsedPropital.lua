-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Propital = require "Injectors/Variables/Propital"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    if Propital.FLAT_HEALING_ENABLED then
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

    if Propital.OVERDOSE_ENABLED then
        ---@type OverdoseTickArgs
        local overdoseTickArgs = {
            base = Propital.OVERDOSE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeOverdoseEffect",
            1, Propital.OVERDOSE_DELAY, 1,
            overdoseTickArgs)
    end

    if Propital.HUNGER_ENABLED then
        ---@type HungerTickArgs
        local hungerTickArgs = {
            amount = Propital.HUNGER_BASE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeHungerEffect",
            Propital.HUNGER_DURATION,
            Propital.HUNGER_DELAY,
            Propital.HUNGER_RATE,
            hungerTickArgs)
    end

    if Propital.THIRST_ENABLED then
        ---@type ThirstTickArgs
        local thirstTickArgs = {
            amount = Propital.THIRST_BASE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeThirstEffect",
            Propital.THIRST_DURATION,
            Propital.THIRST_DELAY,
            Propital.THIRST_RATE,
            thirstTickArgs)
    end
end

return Settings