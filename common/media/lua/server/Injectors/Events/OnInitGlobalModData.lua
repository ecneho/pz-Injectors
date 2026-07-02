-- server only
if not isServer() then return end

local Common = require "Injectors/Variables/Common"

Events.OnInitGlobalModData.Add(Common.InitVariables)