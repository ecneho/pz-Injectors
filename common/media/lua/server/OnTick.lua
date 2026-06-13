-- server only
if not isServer() then return end

local Data = require "Data"
local Logging = require "Logging"

local function onTick()
    local activeList = Data.GetActiveList()
    local onlinePlayers = getOnlinePlayers()

    if not onlinePlayers or onlinePlayers:size() == 0 then return end

    for i = 0, onlinePlayers:size() - 1 do
        local player = onlinePlayers:get(i)
        local username = player:getUsername()
        local effects = activeList[username]

        if effects and #effects > 0 then

            Logging.Header("Tick Update for " .. username)
            Logging.Info("Active effects: " .. tostring(#effects))

            for j = #effects, 1, -1 do
                effects[j] = effects[j] - 1

                Logging.Info("Effect[" .. j .. "]: " .. effects[j] .. " ticks left")

                if effects[j] <= 0 then
                    table.remove(effects, j)
                    Logging.Info("Effect[" .. j .. "]: expired")
                end
            end

            if #effects == 0 then
                activeList[username] = nil
                Logging.Info("All effects ended")
            end
        end
    end
end

Events.OnTick.Add(onTick)