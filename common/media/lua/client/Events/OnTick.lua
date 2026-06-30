-- non-server only
if isServer() then return end

local counter = 0

local function onTick()
    local rate = SandboxVars.Injectors.GLOBAL_EFFECT_POLLING_RATE
    if not rate then return end

    counter = counter + 1
    if counter % rate == 0 then
        sendClientCommand("InjectorsModule", "RequestEffects", {})
    end
end

Events.OnTick.Add(onTick)