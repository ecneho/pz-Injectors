-- server only
if not isServer() then return end

local Hemostatic = {}
local Logging = require "Injectors/Utils/Logging"

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Hemostatic.InitVariables()
    Logging.Info("[Hemostatic] Loading sandbox variables...")

    Hemostatic.MEND_BLEEDING_RATE = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_RATE)
    Hemostatic.MEND_BLEEDING_DELAY = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_DELAY)
    Hemostatic.MEND_BLEEDING_DURATION = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_DURATION)
    Hemostatic.MEND_BLEEDING_BASE_REDUCTION = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_BASE_REDUCTION)
    Hemostatic.BLEEDING_COEFFICIENTS = {
        [BodyPartType.Head] = ensure(SandboxVars.Injectors.HEMOSTATIC_HEAD_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.Neck] = ensure(SandboxVars.Injectors.HEMOSTATIC_NECK_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.Torso_Upper] = ensure(SandboxVars.Injectors.HEMOSTATIC_UPPER_TORSO_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.Torso_Lower] = ensure(SandboxVars.Injectors.HEMOSTATIC_LOWER_TORSO_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.UpperArm_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPER_ARM_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.UpperArm_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPER_ARM_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.ForeArm_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_FOREARM_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.ForeArm_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOREARM_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.Hand_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_HAND_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.Hand_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_HAND_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.Groin] = ensure(SandboxVars.Injectors.HEMOSTATIC_GROIN_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.UpperLeg_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPER_LEG_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.UpperLeg_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPER_LEG_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.LowerLeg_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_LOWER_LEG_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.LowerLeg_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_LOWER_LEG_MEND_BLEEDING_COEFFICIENT),

        [BodyPartType.Foot_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_FOOT_MEND_BLEEDING_COEFFICIENT),
        [BodyPartType.Foot_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOOT_MEND_BLEEDING_COEFFICIENT)
    }

    Hemostatic.MEND_DEEP_WOUND_RATE = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_DEEP_WOUND_RATE)
    Hemostatic.MEND_DEEP_WOUND_DELAY = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_DEEP_WOUND_DELAY)
    Hemostatic.MEND_DEEP_WOUND_DURATION = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_DEEP_WOUND_DURATION)
    Hemostatic.MEND_DEEP_WOUND_BASE_REDUCTION = ensure(SandboxVars.Injectors.HEMOSTATIC_MEND_DEEP_WOUND_BASE_REDUCTION)
    Hemostatic.DEEPWOUND_COEFFICIENTS = {
        [BodyPartType.Head] = ensure(SandboxVars.Injectors.HEMOSTATIC_HEAD_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.Neck] = ensure(SandboxVars.Injectors.HEMOSTATIC_NECK_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.Torso_Upper] = ensure(SandboxVars.Injectors.HEMOSTATIC_UPPER_TORSO_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.Torso_Lower] = ensure(SandboxVars.Injectors.HEMOSTATIC_LOWER_TORSO_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.UpperArm_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPER_ARM_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.UpperArm_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPER_ARM_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.ForeArm_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_FOREARM_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.ForeArm_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOREARM_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.Hand_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_HAND_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.Hand_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_HAND_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.Groin] = ensure(SandboxVars.Injectors.HEMOSTATIC_GROIN_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.UpperLeg_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPER_LEG_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.UpperLeg_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPER_LEG_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.LowerLeg_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_LOWER_LEG_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.LowerLeg_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_LOWER_LEG_MEND_DEEP_WOUND_COEFFICIENT),

        [BodyPartType.Foot_L] = ensure(SandboxVars.Injectors.HEMOSTATIC_LEFT_FOOT_MEND_DEEP_WOUND_COEFFICIENT),
        [BodyPartType.Foot_R] = ensure(SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOOT_MEND_DEEP_WOUND_COEFFICIENT)
    }
end

local function flatten(t)
    local out = {}
    for bodyPart, value in pairs(t) do
        out[tostring(bodyPart)] = value
    end
    return out
end

function Hemostatic.DumpVariables()
    local dumpData = {
        MEND_BLEEDING_RATE = Hemostatic.MEND_BLEEDING_RATE,
        MEND_BLEEDING_DELAY = Hemostatic.MEND_BLEEDING_DELAY,
        MEND_BLEEDING_DURATION = Hemostatic.MEND_BLEEDING_DURATION,
        MEND_BLEEDING_BASE_REDUCTION = Hemostatic.MEND_BLEEDING_BASE_REDUCTION,
        MEND_DEEP_WOUND_RATE = Hemostatic.MEND_DEEP_WOUND_RATE,
        MEND_DEEP_WOUND_DELAY = Hemostatic.MEND_DEEP_WOUND_DELAY,
        MEND_DEEP_WOUND_DURATION = Hemostatic.MEND_DEEP_WOUND_DURATION,
        MEND_DEEP_WOUND_BASE_REDUCTION = Hemostatic.MEND_DEEP_WOUND_BASE_REDUCTION,
    }

    Logging.Table("Hemostatic Sandbox Variables Dump", dumpData)

    Logging.Table("Hemostatic Bleeding Coefficients (body parts)",
        flatten(Hemostatic.BLEEDING_COEFFICIENTS)
    )

    Logging.Table("Hemostatic Deep Wound Coefficients (body parts)",
        flatten(Hemostatic.DEEPWOUND_COEFFICIENTS)
    )
end

return Hemostatic