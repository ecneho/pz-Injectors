-- server only
if not isServer() then return end

local Common = {}

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Common.InitVariables()
    print("[Injectors:Common] Loading sandbox variables...")

    Common.OVERDOSE_DECAY = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_DECAY)
    Common.OVERDOSE_THRESHOLD = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_THRESHOLD)
    Common.PAINKILLERS_OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.GLOBAL_PAINKILLERS_OVERDOSE_PENALTY)
end

return Common