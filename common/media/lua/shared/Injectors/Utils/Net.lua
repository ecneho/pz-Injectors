local Net = {}

local MODULE = "InjectorsModule"

local function copy(value)
    if type(value) ~= "table" then return value end

    local result = {}

    for k, v in pairs(value) do
        result[k] = copy(v)
    end

    return result
end

function Net.Send(command, args)
    local player = getPlayer()

    if isClient() then
        sendClientCommand(player, MODULE, command, args or {})
    else
        triggerEvent("OnClientCommand", MODULE, command, player, copy(args or {}))
    end
end

function Net.Reply(player, command, args)
    if isServer() then
        sendServerCommand(player, MODULE, command, args)
    else
        triggerEvent("OnServerCommand", MODULE, command, copy(args))
    end
end

return Net