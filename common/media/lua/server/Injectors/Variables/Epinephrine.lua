-- server only
if not isServer() then return end

local Epinephrine = {}

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Epinephrine.InitVariables()
    print("[Injectors:Epinephrine] Loading sandbox variables...")

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

return Epinephrine