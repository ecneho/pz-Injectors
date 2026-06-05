Propital = Propital or {} -- propital variables

-- if there are any changes that don't trigger OnSave, this must be reloaded manually
function InitSandboxVariables()
    print("Loading Injectors sandbox variables...")
    Propital.MEND_BLEEDING_BASEDELTA = SandboxVars.Injectors.PROPITAL_MEND_BLEEDING_BASEDELTA
    Propital.COEFFICIENTS = {
        [BodyPartType.Head] = SandboxVars.Injectors.PROPITAL_HEAD_BLEEDING_COEFFICIENT,
        [BodyPartType.Neck] = SandboxVars.Injectors.PROPITAL_NECK_BLEEDING_COEFFICIENT,

        [BodyPartType.Torso_Upper] = SandboxVars.Injectors.PROPITAL_UPPER_TORSO_BLEEDING_COEFFICIENT,
        [BodyPartType.Torso_Lower] = SandboxVars.Injectors.PROPITAL_LOWER_TORSO_BLEEDING_COEFFICIENT,

        [BodyPartType.UpperArm_L] = SandboxVars.Injectors.PROPITAL_LEFT_UPPERARM_BLEEDING_COEFFICIENT,
        [BodyPartType.UpperArm_R] = SandboxVars.Injectors.PROPITAL_RIGHT_UPPERARM_BLEEDING_COEFFICIENT,

        [BodyPartType.ForeArm_L] = SandboxVars.Injectors.PROPITAL_LEFT_FOREARM_BLEEDING_COEFFICIENT,
        [BodyPartType.ForeArm_R] = SandboxVars.Injectors.PROPITAL_RIGHT_FOREARM_BLEEDING_COEFFICIENT,

        [BodyPartType.Hand_L] = SandboxVars.Injectors.PROPITAL_LEFT_HAND_BLEEDING_COEFFICIENT,
        [BodyPartType.Hand_R] = SandboxVars.Injectors.PROPITAL_RIGHT_HAND_BLEEDING_COEFFICIENT,

        [BodyPartType.Groin] = SandboxVars.Injectors.PROPITAL_GROIN_BLEEDING_COEFFICIENT,

        [BodyPartType.UpperLeg_L] = SandboxVars.Injectors.PROPITAL_LEFT_UPPERLEG_BLEEDING_COEFFICIENT,
        [BodyPartType.UpperLeg_R] = SandboxVars.Injectors.PROPITAL_RIGHT_UPPERLEG_BLEEDING_COEFFICIENT,

        [BodyPartType.LowerLeg_L] = SandboxVars.Injectors.PROPITAL_LEFT_LOWERLEG_BLEEDING_COEFFICIENT,
        [BodyPartType.LowerLeg_R] = SandboxVars.Injectors.PROPITAL_RIGHT_LOWERLEG_BLEEDING_COEFFICIENT,

        [BodyPartType.Foot_L] = SandboxVars.Injectors.PROPITAL_LEFT_FOOT_BLEEDING_COEFFICIENT,
        [BodyPartType.Foot_R] = SandboxVars.Injectors.PROPITAL_RIGHT_FOOT_BLEEDING_COEFFICIENT
    }
end

Events.OnInitGlobalModData.Add(InitSandboxVariables)
Events.OnSave.Add(InitSandboxVariables)