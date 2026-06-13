-- server only
if not isServer() then return end

local Logging = {}

function Logging.Header(title)
    print("\n[InjectorSystem] " .. tostring(title) .. ":")
end

function Logging.Info(msg)
    print("  | " .. tostring(msg))
end

return Logging