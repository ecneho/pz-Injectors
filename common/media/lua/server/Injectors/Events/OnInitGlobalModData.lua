if isClient() then return end

local Common = require "Injectors/Variables/Common"

Events.OnInitGlobalModData.Add(Common.InitVariables)

if not isServer() then
    Events.OnGameStart.Add(Common.InitVariables)
end