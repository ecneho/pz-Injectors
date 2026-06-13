-- server only
if not isServer() then return end

local System = {}
local Data = require "Data"
local Logging = require "Logging"

function System.AddPlayerEffect(username, durationInTicks)
    if type(durationInTicks) ~= "number" or durationInTicks <= 0 then return end

    local activeList = Data.GetActiveList()

    if type(activeList[username]) ~= "table" then
        activeList[username] = {}
    end

    table.insert(activeList[username], durationInTicks)

    Logging.Header("Effect Added")
    Logging.Info("Player: " .. username)
    Logging.Info("Duration: " .. tostring(durationInTicks) .. " ticks")
    Logging.Info("Total effects: " .. tostring(#activeList[username]))
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