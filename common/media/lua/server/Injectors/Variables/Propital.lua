-- server only
if not isServer() then return end

local Propital = {}

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Propital.InitVariables()
    print("[Injectors:Propital] Loading sandbox variables...")

    Propital.FLAT_HEALING_RATE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_RATE)
    Propital.FLAT_HEALING_DELAY = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DELAY)
    Propital.FLAT_HEALING_DURATION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DURATION)
    Propital.FLAT_HEALING_BASE_ADDITION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_BASE_ADDITION)
    Propital.FLAT_HEALING_MIN_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_RANGE)
    Propital.FLAT_HEALING_MAX_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_RANGE)
    Propital.FLAT_HEALING_MIN_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_SCALE)
    Propital.FLAT_HEALING_MAX_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_SCALE)
end

return Propital