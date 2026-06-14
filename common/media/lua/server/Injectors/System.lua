-- server only
if not isServer() then return end

local System = {}
local Data = require "Injectors/Utils/Data"
local Logging = require "Injectors/Utils/Logging"

System.EffectRegistry = {}

---@param effectId string
---@param tickFunction function
function System.RegisterEffect(effectId, tickFunction)
    System.EffectRegistry[effectId] = tickFunction
    Logging.Info("Registered new effect function: " .. effectId)
end

---@param username string
---@param effectId string
---@param duration number
---@param delay number
---@param procRate number
---@param customArgs table|nil
function System.AddPlayerEffect(username, effectId, duration, delay, procRate, customArgs)
    if type(duration) ~= "number" or duration <= 0 then return end

    if not System.EffectRegistry[effectId] then
        Logging.Info("Error: No registered effect found for ID '" .. tostring(effectId) .. "'.")
        return
    end

    procRate = math.max(1, procRate or 1)
    local activeList = Data.GetActiveList()

    if type(activeList[username]) ~= "table" then
        activeList[username] = {}
    end

    table.insert(activeList[username], {
        effectId = effectId,
        ticksLeft = duration,
        delayLeft = delay,
        procRate = procRate,
        procCounter = 0,
        customArgs = customArgs or {}
    })

    Logging.Header("Effect Added")
    Logging.Info("Player: " .. username)
    Logging.Info("Effect ID: " .. effectId)
    Logging.Info("Duration: " .. tostring(duration))
    Logging.Info("Delay: " .. tostring(delay))
    Logging.Info("Rate: " .. tostring(procRate))
end

---@param username string
function System.RemovePlayerEffect(username)
    local activeList = Data.GetActiveList()

    if activeList[username] then
        activeList[username] = nil
        Logging.Header("Effects Removed")
        Logging.Info("Player: " .. username)
    end
end

return System