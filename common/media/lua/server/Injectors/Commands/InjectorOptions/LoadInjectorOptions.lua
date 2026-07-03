if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Ini = require "Injectors/Utils/Ini"
local File = require "Injectors/Utils/File"
local Injectors = require "Injectors/Models/Injectors"
local Roles = require "Injectors/Utils/Roles"

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "LoadInjectorOptions" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.SandboxOptions) then
        FileLogger.Warn(string.format(
            "%s was denied injector load: missing SandboxOptions capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local id = args.id
    local injectorData = Injectors.Get(id)

    if not injectorData then
        local lines = File.ReadLines("Injectors/" .. id .. ".ini")

        if lines then
            injectorData = Ini.parse(lines)
            injectorData.id = id
        else
            injectorData = {
                id = id,
                Effects = {}
            }
        end

        Injectors.Set(id, injectorData)
    end

    FileLogger.Info(string.format(
        "Sending injector configuration to %s.",
        FileLogger.FormatPlayer(player)
    ))

    sendServerCommand(player, "InjectorsModule", "ReceiveInjectorOptions", {
        data = injectorData
    })
end

Events.OnClientCommand.Add(OnClientCommand)