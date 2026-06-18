-- server only
if not isServer() then return end

local Epinephrine = {}
local Logging = require "Injectors/Utils/Logging"

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Epinephrine.InitVariables()
    Logging.Info("[Epinephrine] Loading sandbox variables...")

    Epinephrine.PAINKILL_RATE = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_RATE)
    Epinephrine.PAINKILL_DELAY = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_DELAY)
    Epinephrine.PAINKILL_DURATION = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_DURATION)
    Epinephrine.PAINKILL_BASE_REDUCTION = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_BASE_REDUCTION)
    Epinephrine.PAINKILL_MIN_LINEAR_RANGE = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_MIN_LINEAR_RANGE)
    Epinephrine.PAINKILL_MAX_LINEAR_RANGE = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_MAX_LINEAR_RANGE)
    Epinephrine.PAINKILL_MIN_LINEAR_SCALE = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_MIN_LINEAR_SCALE)
    Epinephrine.PAINKILL_MAX_LINEAR_SCALE = ensure(SandboxVars.Injectors.EPINEPHRINE_PAINKILL_MAX_LINEAR_SCALE)

    Epinephrine.OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.EPINEPHRINE_OVERDOSE_PENALTY)
    Epinephrine.OVERDOSE_DELAY = ensure(SandboxVars.Injectors.EPINEPHRINE_OVERDOSE_DELAY)

    Epinephrine.HUNGER_DELAY = ensure(SandboxVars.Injectors.EPINEPHRINE_HUNGER_DELAY)
    Epinephrine.HUNGER_RATE = ensure(SandboxVars.Injectors.EPINEPHRINE_HUNGER_RATE)
    Epinephrine.HUNGER_DURATION = ensure(SandboxVars.Injectors.EPINEPHRINE_HUNGER_DURATION)
    Epinephrine.HUNGER_BASE_PENALTY = ensure(SandboxVars.Injectors.EPINEPHRINE_HUNGER_BASE_PENALTY)

    Epinephrine.THIRST_DELAY = ensure(SandboxVars.Injectors.EPINEPHRINE_THIRST_DELAY)
    Epinephrine.THIRST_RATE = ensure(SandboxVars.Injectors.EPINEPHRINE_THIRST_RATE)
    Epinephrine.THIRST_DURATION = ensure(SandboxVars.Injectors.EPINEPHRINE_THIRST_DURATION)
    Epinephrine.THIRST_BASE_PENALTY = ensure(SandboxVars.Injectors.EPINEPHRINE_THIRST_BASE_PENALTY)
end

function Epinephrine.DumpVariables()
    Logging.Table("Epinephrine Sandbox Variables Dump", {
        PAINKILL_RATE = Epinephrine.PAINKILL_RATE,
        PAINKILL_DELAY = Epinephrine.PAINKILL_DELAY,
        PAINKILL_DURATION = Epinephrine.PAINKILL_DURATION,
        PAINKILL_BASE_REDUCTION = Epinephrine.PAINKILL_BASE_REDUCTION,
        PAINKILL_MIN_LINEAR_RANGE = Epinephrine.PAINKILL_MIN_LINEAR_RANGE,
        PAINKILL_MAX_LINEAR_RANGE = Epinephrine.PAINKILL_MAX_LINEAR_RANGE,
        PAINKILL_MIN_LINEAR_SCALE = Epinephrine.PAINKILL_MIN_LINEAR_SCALE,
        PAINKILL_MAX_LINEAR_SCALE = Epinephrine.PAINKILL_MAX_LINEAR_SCALE,

        OVERDOSE_PENALTY = Epinephrine.OVERDOSE_PENALTY,
        OVERDOSE_DELAY = Epinephrine.OVERDOSE_DELAY,

        HUNGER_DELAY = Epinephrine.HUNGER_DELAY,
        HUNGER_RATE = Epinephrine.HUNGER_RATE,
        HUNGER_DURATION = Epinephrine.HUNGER_DURATION,
        HUNGER_BASE_PENALTY = Epinephrine.HUNGER_BASE_PENALTY,

        THIRST_DELAY = Epinephrine.THIRST_DELAY,
        THIRST_RATE = Epinephrine.THIRST_RATE,
        THIRST_DURATION = Epinephrine.THIRST_DURATION,
        THIRST_BASE_PENALTY = Epinephrine.THIRST_BASE_PENALTY,
    })
end

return Epinephrine