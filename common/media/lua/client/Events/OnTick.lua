-- non-server only
if isServer() then return end

local function onTick()
    print("RequestInjectorEffectData")
    sendClientCommand("InjectorsModule", "RequestInjectorEffectData", {})
end

-- TODO: poll less
Events.OnTick.Add(onTick)