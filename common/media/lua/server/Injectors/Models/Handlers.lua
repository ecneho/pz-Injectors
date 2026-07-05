-- server only
if not isServer() then return end

local System = require "Injectors/System"

local Handlers = {}

-- general health
Handlers.ChangeGeneralHealthEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeGeneralHealthEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
            minRange = data.minRange,
            maxRange = data.maxRange,
            minScale = data.minScale,
            maxScale = data.maxScale,
        }
    )
end

-- hunger
Handlers.ChangeHungerEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeHungerEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- overdose
Handlers.ChangeOverdoseEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeOverdoseEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
        }
    )
end

-- pain
Handlers.ChangePainEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangePainEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
            minRange = data.minRange,
            maxRange = data.maxRange,
            minScale = data.minScale,
            maxScale = data.maxScale,
        }
    )
end

-- thirst
Handlers.ChangeThirstEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeThirstEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- bleeding
Handlers.MendBleedingEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "MendBleedingEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
            coefficients = {
                [BodyPartType.Head] = data.Head,
                [BodyPartType.Neck] = data.Neck,

                [BodyPartType.Torso_Upper] = data.Torso_Upper,
                [BodyPartType.Torso_Lower] = data.Torso_Lower,

                [BodyPartType.UpperArm_L] = data.UpperArm_L,
                [BodyPartType.UpperArm_R] = data.UpperArm_R,

                [BodyPartType.ForeArm_L] = data.ForeArm_L,
                [BodyPartType.ForeArm_R] = data.ForeArm_R,

                [BodyPartType.Hand_L] = data.Hand_L,
                [BodyPartType.Hand_R] = data.Hand_R,

                [BodyPartType.Groin] = data.Groin,

                [BodyPartType.UpperLeg_L] = data.UpperLeg_L,
                [BodyPartType.UpperLeg_R] = data.UpperLeg_R,

                [BodyPartType.LowerLeg_L] = data.LowerLeg_L,
                [BodyPartType.LowerLeg_R] = data.LowerLeg_R,

                [BodyPartType.Foot_L] = data.Foot_L,
                [BodyPartType.Foot_R] = data.Foot_R,
            }
        }
    )
end

-- deep wounds
Handlers.MendDeepWoundEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "MendDeepWoundEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
            coefficients = {
                [BodyPartType.Head] = data.Head,
                [BodyPartType.Neck] = data.Neck,

                [BodyPartType.Torso_Upper] = data.Torso_Upper,
                [BodyPartType.Torso_Lower] = data.Torso_Lower,

                [BodyPartType.UpperArm_L] = data.UpperArm_L,
                [BodyPartType.UpperArm_R] = data.UpperArm_R,

                [BodyPartType.ForeArm_L] = data.ForeArm_L,
                [BodyPartType.ForeArm_R] = data.ForeArm_R,

                [BodyPartType.Hand_L] = data.Hand_L,
                [BodyPartType.Hand_R] = data.Hand_R,

                [BodyPartType.Groin] = data.Groin,

                [BodyPartType.UpperLeg_L] = data.UpperLeg_L,
                [BodyPartType.UpperLeg_R] = data.UpperLeg_R,

                [BodyPartType.LowerLeg_L] = data.LowerLeg_L,
                [BodyPartType.LowerLeg_R] = data.LowerLeg_R,

                [BodyPartType.Foot_L] = data.Foot_L,
                [BodyPartType.Foot_R] = data.Foot_R,
            }
        }
    )
end

-- intoxication
Handlers.ChangeIntoxicationEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeIntoxicationEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- zombie infection
Handlers.ChangeZombieInfectionEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeZombieInfectionEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- food sickness
Handlers.ChangeFoodSicknessEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeFoodSicknessEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- endurance
Handlers.ChangeEnduranceEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeEnduranceEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- temperature
Handlers.ChangeTemperatureEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeTemperatureEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

-- id parsing
setmetatable(Handlers, {
    __index = function(t, key)
        if type(key) == "string" then
            local baseName = string.match(key, "^([a-zA-Z]+)")
            if baseName then
                return rawget(t, baseName)
            end
        end
        return nil
    end
})

return Handlers