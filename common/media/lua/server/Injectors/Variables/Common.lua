-- server only
if not isServer() then return end

local Loader = require "Injectors/Utils/Loader"
local Common = {}

Loader.Populate(Common, "GLOBAL",
{
    "OVERDOSE_DEATH_ENABLED",
    "OVERDOSE_DECAY",
    "OVERDOSE_RATE",
    "OVERDOSE_THRESHOLD",
    "PAINKILLERS_OVERDOSE_PENALTY"
})

return Common