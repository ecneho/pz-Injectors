-- server only
if not isServer() then return end

local Injectors = require "Injectors/Models/Injectors"
local Handlers = require "Injectors/Models/Handlers"

local Settings = {}

---@param player IsoPlayer
---@param id string
function Settings.Used(player, id)
    local username = player:getUsername()
    local injector = Injectors.Get(id)

    if not injector then print("no injector") return end

    local effects = injector.Effects

    if not effects then print("no effects") return end

    for name, data in pairs(effects) do
        local handler = Handlers[name]
        if handler then
            print("found handler")
            handler(username, data)
        else
            print("no handler")
            -- TODO: log error
        end
    end
end

return Settings