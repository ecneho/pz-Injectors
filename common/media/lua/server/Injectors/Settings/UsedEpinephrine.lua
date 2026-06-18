-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Epinephrine = require "Injectors/Variables/Epinephrine"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    ---@type PainTickArgs
    local painTickArgs = {
        base = -Epinephrine.PAINKILL_BASE_REDUCTION,
        minRange = Epinephrine.PAINKILL_MIN_LINEAR_RANGE,
        maxRange = Epinephrine.PAINKILL_MAX_LINEAR_RANGE,
        minScale = Epinephrine.PAINKILL_MIN_LINEAR_SCALE,
        maxScale = Epinephrine.PAINKILL_MAX_LINEAR_SCALE,
    }

    System.AddPlayerEffect(username, "ChangePainEffect",
        Epinephrine.PAINKILL_DURATION,
        Epinephrine.PAINKILL_DELAY,
        Epinephrine.PAINKILL_RATE,
        painTickArgs)

    ---@type OverdoseTickArgs
    local overdoseTickArgs = {
        base = Epinephrine.OVERDOSE_PENALTY,
    }

    System.AddPlayerEffect(username, "ChangeOverdoseEffect",
        1, Epinephrine.OVERDOSE_DELAY, 1,
        overdoseTickArgs)

    ---@type HungerTickArgs
    local hungerTickArgs = {
        amount = Epinephrine.HUNGER_BASE_PENALTY,
    }

    System.AddPlayerEffect(username, "ChangeHungerEffect",
        Epinephrine.HUNGER_DURATION,
        Epinephrine.HUNGER_DELAY,
        Epinephrine.HUNGER_RATE,
        hungerTickArgs)

    ---@type ThirstTickArgs
    local thirstTickArgs = {
        amount = Epinephrine.THIRST_BASE_PENALTY,
    }

    System.AddPlayerEffect(username, "ChangeThirstEffect",
        Epinephrine.THIRST_DURATION,
        Epinephrine.THIRST_DELAY,
        Epinephrine.THIRST_RATE,
        thirstTickArgs)
end

return Settings