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
    })
end

return Propital