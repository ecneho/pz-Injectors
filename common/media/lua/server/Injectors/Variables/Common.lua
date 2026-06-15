-- server only
if not isServer() then return end

local Common = {}
local Logging = require "Injectors/Utils/Logging"

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Common.InitVariables()
    Logging.Info("[Common] Loading sandbox variables...")

    Common.OVERDOSE_DECAY = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_DECAY)
    Common.OVERDOSE_THRESHOLD = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_THRESHOLD)
    Common.PAINKILLERS_OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.GLOBAL_PAINKILLERS_OVERDOSE_PENALTY)
end

function Common.DumpVariables()
    Logging.Table("Common Sandbox Variables Dump", {
        OVERDOSE_DECAY = Common.OVERDOSE_DECAY,
        OVERDOSE_THRESHOLD = Common.OVERDOSE_THRESHOLD,
        PAINKILLERS_OVERDOSE_PENALTY = Common.PAINKILLERS_OVERDOSE_PENALTY
    })
end

return Common