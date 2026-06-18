-- server only
if not isServer() then return end

local Logging = require "Injectors/Utils/Logging"
local Loader = {}

local BodyPartsMapped = {
    [BodyPartType.Head]        = "HEAD",
    [BodyPartType.Neck]        = "NECK",
    [BodyPartType.Torso_Upper] = "UPPER_TORSO",
    [BodyPartType.Torso_Lower] = "LOWER_TORSO",
    [BodyPartType.UpperArm_L]  = "LEFT_UPPER_ARM",
    [BodyPartType.UpperArm_R]  = "RIGHT_UPPER_ARM",
    [BodyPartType.ForeArm_L]   = "LEFT_FOREARM",
    [BodyPartType.ForeArm_R]   = "RIGHT_FOREARM",
    [BodyPartType.Hand_L]      = "LEFT_HAND",
    [BodyPartType.Hand_R]      = "RIGHT_HAND",
    [BodyPartType.Groin]       = "GROIN",
    [BodyPartType.UpperLeg_L]  = "LEFT_UPPER_LEG",
    [BodyPartType.UpperLeg_R]  = "RIGHT_UPPER_LEG",
    [BodyPartType.LowerLeg_L]  = "LEFT_LOWER_LEG",
    [BodyPartType.LowerLeg_R]  = "RIGHT_LOWER_LEG",
    [BodyPartType.Foot_L]      = "LEFT_FOOT",
    [BodyPartType.Foot_R]      = "RIGHT_FOOT"
}

local function ensure(value, message)
    if value == nil then
        error(message or "Unexpected nil value")
    end
    return value
end

function Loader.Populate(class, prefix, simpleKeys, bodyParts)
    function class.InitVariables()
        Logging.Info(string.format("[%s] Loading sandbox variables...", prefix))
        local sv = SandboxVars.Injectors

        if simpleKeys then
            for _, key in ipairs(simpleKeys) do
                local variableKey = prefix .. "_" .. key
                class[key] = ensure(sv[variableKey], "Missing variable: " .. variableKey)
            end
        end

        if bodyParts then
            for name, suffix in pairs(bodyParts) do
                class[name] = {}
                for partType, partName in pairs(BodyPartsMapped) do
                    local variableKey = prefix .. "_" .. partName .. "_" .. suffix
                    class[name][partType] = ensure(sv[variableKey], "Missing variable: " .. variableKey)
                end
            end
        end
    end

    function class.DumpVariables()
        if simpleKeys then
            local dumpData = {}
            for _, key in ipairs(simpleKeys) do
                dumpData[key] = class[key]
            end
            Logging.Table(prefix .. " Sandbox Variables Dump", dumpData)
        end

        if bodyParts then
            for name, _ in pairs(bodyParts) do
                local flattened = {}
                for partType, value in pairs(class[name]) do
                    flattened[tostring(partType)] = value
                end
                Logging.Table(prefix .. " " .. name .. " Dump", flattened)
            end
        end
    end

    return class
end

return Loader