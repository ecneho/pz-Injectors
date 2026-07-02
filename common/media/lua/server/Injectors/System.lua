-- server only
if not isServer() then return end

local System = {}
local Active = require "Injectors/Models/Active"
local FileLogger = require "Injectors/Utils/FileLogger"

System.EffectRegistry = {}

---@param effectId string
---@param tickFunction function
function System.RegisterEffect(effectId, tickFunction)
    System.EffectRegistry[effectId] = tickFunction
    FileLogger.Info(string.format(
        "Registered new effect function for [%s].",
        tostring(effectId)
    ))
end

---@param player IsoPlayer
---@param effectId string
---@param duration number
---@param delay number
---@param rate number
---@param customArgs table|nil
function System.AddPlayerEffect(player, effectId, duration, delay, rate, customArgs)
    if type(duration) ~= "number" or duration <= 0 then return end

    local username = player:getUsername()

    if not System.EffectRegistry[effectId] then
        FileLogger.Error(string.format(
            "Effect [%s] has no registered effect in EffectRegistry.",
            tostring(effectId)
        ))
        return
    end

    rate = math.max(1, rate)
    local activeList = Active.GetActiveList()

    if type(activeList[username]) ~= "table" then
        activeList[username] = {}
    end

    table.insert(activeList[username], {
        effectId = effectId,
        ticksLeft = duration,
        delayLeft = delay,
        delay = delay,
        duration = duration,
        rate = rate,
        procCounter = 0,
        customArgs = customArgs or {}
    })

    FileLogger.Info(string.format(
        "Added effect to character %s:",
        FileLogger.FormatPlayer(player)
    ))

    FileLogger.Raw(string.format("    Effect   : %s", tostring(effectId)))
    FileLogger.Raw(string.format("    Duration : %s", tostring(duration)))
    FileLogger.Raw(string.format("    Delay    : %s", tostring(delay)))
    FileLogger.Raw(string.format("    Rate     : %s", tostring(rate)))
end

---@param username string
function System.RemovePlayerEffect(username)
    local activeList = Active.GetActiveList()

    if activeList[username] then
        activeList[username] = nil
    end
end

return System