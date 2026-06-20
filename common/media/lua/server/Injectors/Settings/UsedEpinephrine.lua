-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Epinephrine = require "Injectors/Variables/Epinephrine"

local Settings = {}

---@param player IsoPlayer
function Settings.Used(player)
    local username = player:getUsername()

    if Epinephrine.PAINKILL_ENABLED then
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
    end

    if Epinephrine.FLAT_HEALING_ENABLED then
        ---@type GeneralHealthTickArgs
        local generalHealthTickArgs = {
            base = Epinephrine.FLAT_HEALING_BASE_ADDITION,
            minRange = Epinephrine.FLAT_HEALING_MIN_LINEAR_RANGE,
            maxRange = Epinephrine.FLAT_HEALING_MAX_LINEAR_RANGE,
            minScale = Epinephrine.FLAT_HEALING_MIN_LINEAR_SCALE,
            maxScale = Epinephrine.FLAT_HEALING_MAX_LINEAR_SCALE,
        }

        System.AddPlayerEffect(username, "ChangeGeneralHealthEffect",
            Epinephrine.FLAT_HEALING_DURATION,
            Epinephrine.FLAT_HEALING_DELAY,
            Epinephrine.FLAT_HEALING_RATE,
            generalHealthTickArgs)
    end

    if Epinephrine.OVERDOSE_ENABLED then
        ---@type OverdoseTickArgs
        local overdoseTickArgs = {
            base = Epinephrine.OVERDOSE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeOverdoseEffect",
            1, Epinephrine.OVERDOSE_DELAY, 1,
            overdoseTickArgs)
    end

    if Epinephrine.HUNGER_ENABLED then
        ---@type HungerTickArgs
        local hungerTickArgs = {
            amount = Epinephrine.HUNGER_BASE_PENALTY,
        }

        System.AddPlayerEffect(username, "ChangeHungerEffect",
            Epinephrine.HUNGER_DURATION,
            Epinephrine.HUNGER_DELAY,
            Epinephrine.HUNGER_RATE,
            hungerTickArgs)
    end

    if Epinephrine.THIRST_ENABLED then
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
end

return Settings