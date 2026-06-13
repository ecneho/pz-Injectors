-- server only
if not isServer() then return end

local Common = require "Injectors/Variables/Common"
local Epinephrine = require "Injectors/Variables/Epinephrine"
local Hemostatic = require "Injectors/Variables/Hemostatic"
local Propital = require "Injectors/Variables/Propital"

Events.OnInitGlobalModData.Add(Common.InitVariables)
Events.OnInitGlobalModData.Add(Epinephrine.InitVariables)
Events.OnInitGlobalModData.Add(Hemostatic.InitVariables)
Events.OnInitGlobalModData.Add(Propital.InitVariables)