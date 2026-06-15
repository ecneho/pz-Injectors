-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Logging = require "Injectors/Utils/Logging"

local Common = require "Injectors/Variables/Common"
local Epinephrine = require "Injectors/Variables/Epinephrine"
local Hemostatic = require "Injectors/Variables/Hemostatic"
local Propital = require "Injectors/Variables/Propital"

---@param player IsoPlayer
local function UsedEpinephrine(player)
    local username = player:getUsername()

    ---@type PainTickArgs
    local painTickArgs = {
        base = Epinephrine.PAINKILL_BASE_REDUCTION,
        minRange = Epinephrine.PAINKILL_MIN_LINEAR_RANGE,
        maxRange = Epinephrine.PAINKILL_MAX_LINEAR_RANGE,
        minScale = Epinephrine.PAINKILL_MIN_LINEAR_SCALE,
        maxScale = Epinephrine.PAINKILL_MAX_LINEAR_SCALE,
    }

    System.AddPlayerEffect(username, "ChangePainEffect",
        Epinephrine.PAINKILL_DURATION,
        Epinephrine.PAINKILL_DELAY,
        Epinephrine.PAINKILL_RATE,
        painTickArgs)
end

---@param player IsoPlayer
local function UsedPropital(player)
    local username = player:getUsername()

    ---@type GeneralHealthTickArgs
    local generalHealthTickArgs = {
        base = Propital.FLAT_HEALING_BASE_ADDITION,
        minRange = Propital.FLAT_HEALING_MIN_LINEAR_RANGE,
        maxRange = Propital.FLAT_HEALING_MAX_LINEAR_RANGE,
        minScale = Propital.FLAT_HEALING_MIN_LINEAR_SCALE,
        maxScale = Propital.FLAT_HEALING_MAX_LINEAR_SCALE,
    }

    System.AddPlayerEffect(username, "ChangeGeneralHealthEffect",
        Propital.FLAT_HEALING_DURATION,
        Propital.FLAT_HEALING_DELAY,
        Propital.FLAT_HEALING_RATE,
        generalHealthTickArgs)
end

---@param player IsoPlayer
local function UsedHemostatic(player)
    local username = player:getUsername()

    ---@type MendBleedingTickArgs
    local mendBleedingTickArgs = {
        base = Hemostatic.MEND_BLEEDING_BASE_REDUCTION,
        coefficients = Hemostatic.BLEEDING_COEFFICIENTS,
    }

    System.AddPlayerEffect(username, "MendBleedingEffect",
        Hemostatic.MEND_BLEEDING_DURATION,
        Hemostatic.MEND_BLEEDING_DELAY,
        Hemostatic.MEND_BLEEDING_RATE,
        mendBleedingTickArgs
    )

    ---@type MendDeepWoundTickArgs
    local mendDeepWoundTickArgs = {
        base = Hemostatic.MEND_DEEP_WOUND_BASE_REDUCTION,
        coefficients = Hemostatic.DEEPWOUND_COEFFICIENTS,
    }

    System.AddPlayerEffect(username, "MendDeepWoundEffect",
        Hemostatic.MEND_DEEP_WOUND_DURATION,
        Hemostatic.MEND_DEEP_WOUND_DELAY,
        Hemostatic.MEND_DEEP_WOUND_RATE,
        mendDeepWoundTickArgs
    )
end

---@param player IsoPlayer
---@param capability Capability
local function hasCapability(player, capability)
    return player:getRole():hasCapability(capability)
end

---@param module string
---@param command string
---@param player IsoPlayer
---@param clientArgs table|nil
local function OnClientCommand(module, command, player, clientArgs)
    -- admin sandbox variables commands. TODO: separate
    if module == "InjectorsModule" and command == "ReloadVariables" then
        local username = player:getUsername()
        if hasCapability(player, Capability.SandboxOptions) then
            Logging.Info(username .. " reloaded Sandbox Variables")
            Common.InitVariables()
            Propital.InitVariables()
            Epinephrine.InitVariables()
            Hemostatic.InitVariables()
        else
            Logging.Warning(username .. " denied reload use: missing SandboxOptions capability")
        end
    end

    if module == "InjectorsModule" and command == "DumpVariables" then
        local username = player:getUsername()
        if hasCapability(player, Capability.SandboxOptions) then
            Logging.Info(username .. " dumping sandbox variables...")
            Common.DumpVariables()
            Propital.DumpVariables()
            Epinephrine.DumpVariables()
            Hemostatic.DumpVariables()
        else
            Logging.Warning(username .. " denied variables dump: missing SandboxOptions capability")
        end
    end

    -- admin safety-free debugging commands. TODO: separate
    if module == "InjectorsModule" and command == "UseEpinephrineIgnoreSafety" then
        local username = player:getUsername()
        if hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " used Epinephrine (Admin Override)")
            UsedEpinephrine(player)
        else
            Logging.Warning(username .. " denied Epinephrine admin override: missing CanMedicalCheat capability")
        end
    end

    if module == "InjectorsModule" and command == "UsePropitalIgnoreSafety" then
        local username = player:getUsername()
        if hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " used Propital (Admin Override)")
            UsedPropital(player)
        else
            Logging.Warning(username .. " denied Propital admin override: missing CanMedicalCheat capability")
        end
    end

    if module == "InjectorsModule" and command == "UseHemostaticIgnoreSafety" then
        local username = player:getUsername()
        if hasCapability(player, Capability.CanMedicalCheat) then
            Logging.Info(username .. " used Hemostatic (Admin Override)")
            UsedHemostatic(player)
        else
            Logging.Warning(username .. " denied Hemostatic admin override: missing CanMedicalCheat capability")
        end
    end

    -- TODO: commands below needs further safety improvement
    if module == "InjectorsModule" and command == "UseEpinephrine" then
        print("Using Epinephrine")
        UsedEpinephrine(player)
        -- TODO: add client safety checks here
    end
end

Events.OnClientCommand.Add(OnClientCommand)