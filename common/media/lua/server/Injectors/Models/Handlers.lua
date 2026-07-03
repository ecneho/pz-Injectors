-- server only
if not isServer() then return end

local System = require "Injectors/System"

local Handlers = {}

-- pain
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

-- hunger
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

-- thirst
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

-- overdose
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

-- id parsing
setmetatable(Handlers, {
    __index = function(t, key)
        if type(key) == "string" then
            local baseName = string.match(key, "^([a-zA-Z]+)")
            if baseName then
                return rawget(t, baseName)
            end
        end
        return nil
    end
})

return Handlers