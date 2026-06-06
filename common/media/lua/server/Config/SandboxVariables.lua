Hemostatic = Hemostatic or {} -- hemostatic variables
Propital = Propital or {} -- propital variables

Hemostatic_S = Hemostatic_S or {} -- hemostatic settings
Propital_S = Propital_S or {} -- propital settings

-- nil check, throws error
local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

-- if there are any changes that don't trigger OnSave, this must be reloaded manually
function InitSandboxVariables()
    print("Loading Injectors sandbox variables...")
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

    Hemostatic_S = {
        Bleeding = {
            rate = Hemostatic.MEND_BLEEDING_RATE,
            delay = Hemostatic.MEND_BLEEDING_DELAY,
            duration = Hemostatic.MEND_BLEEDING_DURATION,
            func = MendBleeding
        },
        DeepWound = {
            rate = Hemostatic.MEND_DEEP_WOUND_RATE,
            delay = Hemostatic.MEND_DEEP_WOUND_DELAY,
            duration = Hemostatic.MEND_DEEP_WOUND_DURATION,
            func = MendDeepWound
        }
    }

    Propital.FLAT_HEALING_RATE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_RATE)
    Propital.FLAT_HEALING_DELAY = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DELAY)
    Propital.FLAT_HEALING_DURATION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_DURATION)
    Propital.FLAT_HEALING_BASE_ADDITION = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_BASE_ADDITION)
    Propital.FLAT_HEALING_MIN_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_RANGE)
    Propital.FLAT_HEALING_MAX_LINEAR_RANGE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_RANGE)
    Propital.FLAT_HEALING_MIN_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MIN_LINEAR_SCALE)
    Propital.FLAT_HEALING_MAX_LINEAR_SCALE = ensure(SandboxVars.Injectors.PROPITAL_FLAT_HEALING_MAX_LINEAR_SCALE)

    Propital_S = {
        Heal = {
            rate = Propital.FLAT_HEALING_RATE,
            delay = Propital.FLAT_HEALING_DELAY,
            duration = Propital.FLAT_HEALING_DURATION,
            func = AddHealth
        }
    }
end

Events.OnInitGlobalModData.Add(InitSandboxVariables)
Events.OnSave.Add(InitSandboxVariables)