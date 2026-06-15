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
    })
end

return Epinephrine