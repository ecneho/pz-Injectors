-- server only
if not isServer() then return end

local Common = {}
local FileLogger = require "Injectors/Utils/FileLogger"

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
        FileLogger.Error(message)
    end
    return value
end

function Common.InitVariables()
    FileLogger.Info("Loading sandbox variables.")

    Common.OVERDOSE_DECAY = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_DECAY, "GLOBAL_OVERDOSE_DECAY is nil")
    Common.OVERDOSE_RATE = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_RATE, "GLOBAL_OVERDOSE_RATE is nil")
    Common.OVERDOSE_THRESHOLD = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_THRESHOLD, "GLOBAL_OVERDOSE_THRESHOLD is nil")
    Common.PAINKILLERS_OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.GLOBAL_PAINKILLERS_OVERDOSE_PENALTY, "GLOBAL_PAINKILLERS_OVERDOSE_PENALTY is nil")
    Common.GLOBAL_LOGGER_OFFSET = ensure(SandboxVars.Injectors.GLOBAL_LOGGER_OFFSET, "GLOBAL_LOGGER_OFFSET is nil")

    FileLogger.Info("Sandbox variables loaded.")
end

function Common.DumpVariables()
    FileLogger.Info("Dumping sandbox variables.")

    FileLogger.Raw("    OVERDOSE_DECAY: " .. Common.OVERDOSE_DECAY)
    FileLogger.Raw("    OVERDOSE_RATE: " .. Common.OVERDOSE_RATE)
    FileLogger.Raw("    OVERDOSE_THRESHOLD: " .. Common.OVERDOSE_THRESHOLD)
    FileLogger.Raw("    PAINKILLERS_OVERDOSE_PENALTY: " .. Common.PAINKILLERS_OVERDOSE_PENALTY)
    FileLogger.Raw("    GLOBAL_LOGGER_OFFSET: " .. Common.GLOBAL_LOGGER_OFFSET)
end

return Common