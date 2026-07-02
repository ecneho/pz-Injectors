-- non-server only
if isServer() then return end

InjectorData = {
    overdoseLevel = 0,
    maxOverdose = 100,
    effects = {}
}

local function OnServerCommand(module, command, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "InjectorEffectData" then return end
    InjectorData = args
end

Events.OnServerCommand.Add(OnServerCommand)