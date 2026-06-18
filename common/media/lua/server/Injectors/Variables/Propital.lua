-- server only
if not isServer() then return end

local Propital = {}
local Logging = require "Injectors/Utils/Logging"

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Propital.InitVariables()
    Logging.Info("[Propital] Loading sandbox variables...")

    Propital.FLAT_HEALING_RATE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_RATE)
    Propital.FLAT_HEALING_DELAY = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DELAY)
    Propital.FLAT_HEALING_DURATION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DURATION)
    Propital.FLAT_HEALING_BASE_ADDITION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_BASE_ADDITION)
    Propital.FLAT_HEALING_MIN_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_RANGE)
    Propital.FLAT_HEALING_MAX_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_RANGE)
    Propital.FLAT_HEALING_MIN_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_SCALE)
    Propital.FLAT_HEALING_MAX_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_SCALE)

    Propital.OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.PROPITAL_OVERDOSE_PENALTY)
    Propital.OVERDOSE_DELAY = ensure(SandboxVars.Injectors.PROPITAL_OVERDOSE_DELAY)

    Propital.HUNGER_DELAY = ensure(SandboxVars.Injectors.PROPITAL_HUNGER_DELAY)
    Propital.HUNGER_RATE = ensure(SandboxVars.Injectors.PROPITAL_HUNGER_RATE)
    Propital.HUNGER_DURATION = ensure(SandboxVars.Injectors.PROPITAL_HUNGER_DURATION)
    Propital.HUNGER_BASE_PENALTY = ensure(SandboxVars.Injectors.PROPITAL_HUNGER_BASE_PENALTY)

    Propital.THIRST_DELAY = ensure(SandboxVars.Injectors.PROPITAL_THIRST_DELAY)
    Propital.THIRST_RATE = ensure(SandboxVars.Injectors.PROPITAL_THIRST_RATE)
    Propital.THIRST_DURATION = ensure(SandboxVars.Injectors.PROPITAL_THIRST_DURATION)
    Propital.THIRST_BASE_PENALTY = ensure(SandboxVars.Injectors.PROPITAL_THIRST_BASE_PENALTY)
end

function Propital.DumpVariables()
    Logging.Table("Propital Sandbox Variables Dump", {
        FLAT_HEALING_RATE = Propital.FLAT_HEALING_RATE,
        FLAT_HEALING_DELAY = Propital.FLAT_HEALING_DELAY,
        FLAT_HEALING_DURATION = Propital.FLAT_HEALING_DURATION,
        FLAT_HEALING_BASE_ADDITION = Propital.FLAT_HEALING_BASE_ADDITION,
        FLAT_HEALING_MIN_LINEAR_RANGE = Propital.FLAT_HEALING_MIN_LINEAR_RANGE,
        FLAT_HEALING_MAX_LINEAR_RANGE = Propital.FLAT_HEALING_MAX_LINEAR_RANGE,
        FLAT_HEALING_MIN_LINEAR_SCALE = Propital.FLAT_HEALING_MIN_LINEAR_SCALE,
        FLAT_HEALING_MAX_LINEAR_SCALE = Propital.FLAT_HEALING_MAX_LINEAR_SCALE,

        OVERDOSE_PENALTY = Propital.OVERDOSE_PENALTY,
        OVERDOSE_DELAY = Propital.OVERDOSE_DELAY,

        HUNGER_DELAY = Propital.HUNGER_DELAY,
        HUNGER_RATE = Propital.HUNGER_RATE,
        HUNGER_DURATION = Propital.HUNGER_DURATION,
        HUNGER_BASE_PENALTY = Propital.HUNGER_BASE_PENALTY,

        THIRST_DELAY = Propital.THIRST_DELAY,
        THIRST_RATE = Propital.THIRST_RATE,
        THIRST_DURATION = Propital.THIRST_DURATION,
        THIRST_BASE_PENALTY = Propital.THIRST_BASE_PENALTY,
    })
end

return Propital