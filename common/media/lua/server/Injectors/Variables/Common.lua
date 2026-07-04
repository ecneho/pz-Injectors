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
    Common.OVERDOSE_DEATH_ENABLED = ensure(SandboxVars.Injectors.GLOBAL_OVERDOSE_DEATH_ENABLED, "GLOBAL_OVERDOSE_DEATH_ENABLED is nil")
    Common.PAINKILLERS_OVERDOSE_PENALTY = ensure(SandboxVars.Injectors.GLOBAL_PAINKILLERS_OVERDOSE_PENALTY, "GLOBAL_PAINKILLERS_OVERDOSE_PENALTY is nil")
    Common.LOGGER_OFFSET = ensure(SandboxVars.Injectors.GLOBAL_LOGGER_OFFSET, "GLOBAL_LOGGER_OFFSET is nil")
    Common.INJECTION_DURATION = ensure(SandboxVars.Injectors.GLOBAL_INJECTION_DURATION, "GLOBAL_INJECTION_DURATION is nil")
    Common.INJECTOR_EQUIP_SPEED = ensure(SandboxVars.Injectors.GLOBAL_INJECTOR_EQUIP_SPEED, "GLOBAL_INJECTOR_EQUIP_SPEED is nil")
    Common.RED_INJECTOR_SPAWN_WEIGHT = ensure(SandboxVars.Injectors.GLOBAL_RED_INJECTOR_SPAWN_WEIGHT, "GLOBAL_RED_INJECTOR_SPAWN_WEIGHT is nil")
    Common.BLUE_INJECTOR_SPAWN_WEIGHT = ensure(SandboxVars.Injectors.GLOBAL_BLUE_INJECTOR_SPAWN_WEIGHT, "GLOBAL_BLUE_INJECTOR_SPAWN_WEIGHT is nil")
    Common.GREEN_INJECTOR_SPAWN_WEIGHT = ensure(SandboxVars.Injectors.GLOBAL_GREEN_INJECTOR_SPAWN_WEIGHT, "GLOBAL_GREEN_INJECTOR_SPAWN_WEIGHT is nil")

    FileLogger.Info("Sandbox variables loaded.")
end

function Common.DumpVariables()
    FileLogger.Info("Dumping sandbox variables.")

    FileLogger.Raw("    OVERDOSE_DECAY: " .. Common.OVERDOSE_DECAY)
    FileLogger.Raw("    OVERDOSE_RATE: " .. Common.OVERDOSE_RATE)
    FileLogger.Raw("    OVERDOSE_THRESHOLD: " .. Common.OVERDOSE_THRESHOLD)
    FileLogger.Raw("    OVERDOSE_DEATH_ENABLED: " .. tostring(Common.OVERDOSE_DEATH_ENABLED))
    FileLogger.Raw("    PAINKILLERS_OVERDOSE_PENALTY: " .. Common.PAINKILLERS_OVERDOSE_PENALTY)
    FileLogger.Raw("    LOGGER_OFFSET: " .. Common.LOGGER_OFFSET)
    FileLogger.Raw("    INJECTION_DURATION: " .. Common.INJECTION_DURATION)
    FileLogger.Raw("    INJECTOR_EQUIP_SPEED: " .. Common.INJECTOR_EQUIP_SPEED)
    FileLogger.Raw("    RED_INJECTOR_SPAWN_WEIGHT: " .. Common.RED_INJECTOR_SPAWN_WEIGHT)
    FileLogger.Raw("    BLUE_INJECTOR_SPAWN_WEIGHT: " .. Common.BLUE_INJECTOR_SPAWN_WEIGHT)
    FileLogger.Raw("    GREEN_INJECTOR_SPAWN_WEIGHT: " .. Common.GREEN_INJECTOR_SPAWN_WEIGHT)
end

return Common