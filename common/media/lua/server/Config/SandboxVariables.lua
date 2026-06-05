Hemostatic = Hemostatic or {} -- hemostatic variables
Hemostatic_S = Hemostatic_S or {} -- hemostatic settings

-- if there are any changes that don't trigger OnSave, this must be reloaded manually
function InitSandboxVariables()
    print("Loading Injectors sandbox variables...")
    Hemostatic.MEND_BLEEDING_RATE = SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_RATE
    Hemostatic.MEND_BLEEDING_DELAY = SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_DELAY
    Hemostatic.MEND_BLEEDING_DURATION = SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_DURATION
    Hemostatic.MEND_BLEEDING_BASEDELTA = SandboxVars.Injectors.HEMOSTATIC_MEND_BLEEDING_BASEDELTA
    Hemostatic.BLEEDING_COEFFICIENTS = {
        [BodyPartType.Head] = SandboxVars.Injectors.HEMOSTATIC_HEAD_BLEEDING_COEFFICIENT,
        [BodyPartType.Neck] = SandboxVars.Injectors.HEMOSTATIC_NECK_BLEEDING_COEFFICIENT,

        [BodyPartType.Torso_Upper] = SandboxVars.Injectors.HEMOSTATIC_UPPER_TORSO_BLEEDING_COEFFICIENT,
        [BodyPartType.Torso_Lower] = SandboxVars.Injectors.HEMOSTATIC_LOWER_TORSO_BLEEDING_COEFFICIENT,

        [BodyPartType.UpperArm_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPERARM_BLEEDING_COEFFICIENT,
        [BodyPartType.UpperArm_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPERARM_BLEEDING_COEFFICIENT,

        [BodyPartType.ForeArm_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_FOREARM_BLEEDING_COEFFICIENT,
        [BodyPartType.ForeArm_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOREARM_BLEEDING_COEFFICIENT,

        [BodyPartType.Hand_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_HAND_BLEEDING_COEFFICIENT,
        [BodyPartType.Hand_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_HAND_BLEEDING_COEFFICIENT,

        [BodyPartType.Groin] = SandboxVars.Injectors.HEMOSTATIC_GROIN_BLEEDING_COEFFICIENT,

        [BodyPartType.UpperLeg_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPERLEG_BLEEDING_COEFFICIENT,
        [BodyPartType.UpperLeg_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPERLEG_BLEEDING_COEFFICIENT,

        [BodyPartType.LowerLeg_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_LOWERLEG_BLEEDING_COEFFICIENT,
        [BodyPartType.LowerLeg_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_LOWERLEG_BLEEDING_COEFFICIENT,

        [BodyPartType.Foot_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_FOOT_BLEEDING_COEFFICIENT,
        [BodyPartType.Foot_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOOT_BLEEDING_COEFFICIENT
    }

    Hemostatic.MEND_DEEPWOUND_RATE = SandboxVars.Injectors.HEMOSTATIC_MEND_DEEPWOUND_RATE
    Hemostatic.MEND_DEEPWOUND_DELAY = SandboxVars.Injectors.HEMOSTATIC_MEND_DEEPWOUND_DELAY
    Hemostatic.MEND_DEEPWOUND_DURATION = SandboxVars.Injectors.HEMOSTATIC_MEND_DEEPWOUND_DURATION
    Hemostatic.MEND_DEEPWOUND_BASEDELTA = SandboxVars.Injectors.HEMOSTATIC_MEND_DEEPWOUND_BASEDELTA
    Hemostatic.DEEPWOUND_COEFFICIENTS = {
        [BodyPartType.Head] = SandboxVars.Injectors.HEMOSTATIC_HEAD_DEEPWOUND_COEFFICIENT,
        [BodyPartType.Neck] = SandboxVars.Injectors.HEMOSTATIC_NECK_DEEPWOUND_COEFFICIENT,

        [BodyPartType.Torso_Upper] = SandboxVars.Injectors.HEMOSTATIC_UPPER_TORSO_DEEPWOUND_COEFFICIENT,
        [BodyPartType.Torso_Lower] = SandboxVars.Injectors.HEMOSTATIC_LOWER_TORSO_DEEPWOUND_COEFFICIENT,

        [BodyPartType.UpperArm_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPERARM_DEEPWOUND_COEFFICIENT,
        [BodyPartType.UpperArm_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPERARM_DEEPWOUND_COEFFICIENT,

        [BodyPartType.ForeArm_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_FOREARM_DEEPWOUND_COEFFICIENT,
        [BodyPartType.ForeArm_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOREARM_DEEPWOUND_COEFFICIENT,

        [BodyPartType.Hand_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_HAND_DEEPWOUND_COEFFICIENT,
        [BodyPartType.Hand_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_HAND_DEEPWOUND_COEFFICIENT,

        [BodyPartType.Groin] = SandboxVars.Injectors.HEMOSTATIC_GROIN_DEEPWOUND_COEFFICIENT,

        [BodyPartType.UpperLeg_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_UPPERLEG_DEEPWOUND_COEFFICIENT,
        [BodyPartType.UpperLeg_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_UPPERLEG_DEEPWOUND_COEFFICIENT,

        [BodyPartType.LowerLeg_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_LOWERLEG_DEEPWOUND_COEFFICIENT,
        [BodyPartType.LowerLeg_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_LOWERLEG_DEEPWOUND_COEFFICIENT,

        [BodyPartType.Foot_L] = SandboxVars.Injectors.HEMOSTATIC_LEFT_FOOT_DEEPWOUND_COEFFICIENT,
        [BodyPartType.Foot_R] = SandboxVars.Injectors.HEMOSTATIC_RIGHT_FOOT_DEEPWOUND_COEFFICIENT
    }

    Hemostatic_S = {
        Bleeding = {
            rate = Hemostatic.MEND_BLEEDING_RATE,
            delay = Hemostatic.MEND_BLEEDING_DELAY,
            duration = Hemostatic.MEND_BLEEDING_DURATION,
            func = MendBleeding
        },
        DeepWound = {
            rate = Hemostatic.MEND_DEEPWOUND_RATE,
            delay = Hemostatic.MEND_DEEPWOUND_DELAY,
            duration = Hemostatic.MEND_DEEPWOUND_DURATION,
            func = MendDeepWounds
        }
    }
end

Events.OnInitGlobalModData.Add(InitSandboxVariables)
Events.OnSave.Add(InitSandboxVariables)