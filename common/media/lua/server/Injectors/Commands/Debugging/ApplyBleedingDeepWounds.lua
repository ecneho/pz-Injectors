-- server only
if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Roles = require "Injectors/Utils/Roles"

local bleedingParts = {
    BodyPartType.ForeArm_L,
    BodyPartType.ForeArm_R,
    BodyPartType.UpperArm_L,
    BodyPartType.UpperArm_R,
    BodyPartType.Torso_Upper,
}

local deepWoundParts = {
    BodyPartType.UpperLeg_L,
    BodyPartType.UpperLeg_R,
    BodyPartType.LowerLeg_L,
    BodyPartType.LowerLeg_R,
    BodyPartType.Torso_Lower,
}

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module ~= "InjectorsModule" then return end
    if command ~= "ApplyBleedingDeepWounds" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.CanMedicalCheat) then
        FileLogger.Warn(string.format(
            "%s was denied apply bleeding and deep wounds: missing CanMedicalCheat capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then return end

    for _, partType in ipairs(bleedingParts) do
        local part = bodyDamage:getBodyPart(partType)
        if part then
            part:setBleeding(true)
            part:setBleedingTime(10)
        end
    end

    for _, partType in ipairs(deepWoundParts) do
        local part = bodyDamage:getBodyPart(partType)
        if part then
            part:setDeepWounded(true)
            part:setDeepWoundTime(10)
        end
    end

    FileLogger.Info(string.format(
        "%s applied bleeding and deep wounds (debug).",
        FileLogger.FormatPlayer(player)
    ))
end

Events.OnClientCommand.Add(OnClientCommand)