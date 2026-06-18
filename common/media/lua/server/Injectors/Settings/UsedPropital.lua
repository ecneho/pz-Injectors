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

    ---@type OverdoseTickArgs
    local overdoseTickArgs = {
        base = Propital.OVERDOSE_PENALTY,
    }

    System.AddPlayerEffect(username, "ChangeOverdoseEffect",
        1, Propital.OVERDOSE_DELAY, 1,
        overdoseTickArgs)

    ---@type HungerTickArgs
    local hungerTickArgs = {
        amount = Propital.HUNGER_BASE_PENALTY,
    }

    System.AddPlayerEffect(username, "ChangeHungerEffect",
        Propital.HUNGER_DURATION,
        Propital.HUNGER_DELAY,
        Propital.HUNGER_RATE,
        hungerTickArgs)

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

return Settings