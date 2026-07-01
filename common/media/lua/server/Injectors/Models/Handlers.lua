-- server only
if not isServer() then return end

local System = require "Injectors/System"

-- TODO: move each handler into respective effect definitions
local Handlers = {}

Handlers.ChangePainEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangePainEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
            minRange = data.minRange,
            maxRange = data.maxRange,
            minScale = data.minScale,
            maxScale = data.maxScale,
        }
    )
end

Handlers.ChangeHungerEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeHungerEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

Handlers.ChangeThirstEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeThirstEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            amount = data.amount,
        }
    )
end

Handlers.ChangeOverdoseEffect = function(username, data)
    System.AddPlayerEffect(
        username,
        "ChangeOverdoseEffect",
        data.duration,
        data.delay,
        data.rate,
        {
            base = data.base,
        }
    )
end

return Handlers