-- server only
if not isServer() then return end

local Roles = require "Injectors/Utils/Roles"
local Logging = require "Injectors/Utils/Logging"

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    if module == "InjectorsModule" and command == "ApplyBleedingDeepWounds" then
        local username = player:getUsername()

        if Roles.hasCapability(player, Capability.CanMedicalCheat) then
            local bodyDamage = player:getBodyDamage()

            local bleedingParts = {
                BodyPartType.ForeArm_L,
                BodyPartType.ForeArm_R,
                BodyPartType.UpperArm_L,
                BodyPartType.UpperArm_R,
                BodyPartType.Torso_Upper,
            }

            for _, partType in ipairs(bleedingParts) do
                local part = bodyDamage:getBodyPart(partType)
                part:setBleeding(true)
                part:setBleedingTime(10)
            end

            local deepWoundParts = {
                BodyPartType.UpperLeg_L,
                BodyPartType.UpperLeg_R,
                BodyPartType.LowerLeg_L,
                BodyPartType.LowerLeg_R,
                BodyPartType.Torso_Lower,
            }

            for _, partType in ipairs(deepWoundParts) do
                local part = bodyDamage:getBodyPart(partType)
                part:setDeepWounded(true)
                part:setDeepWoundTime(10)
            end

            Logging.Info(username .. " applied bleeding and deep wounds (Debug)")
        else
            Logging.Warning(username .. " denied apply bleeding and deep wounds: missing CanMedicalCheat capability")
        end
    end
end

Events.OnClientCommand.Add(OnClientCommand)