if not isServer() then return end

local FileLogger = require "Injectors/Utils/FileLogger"
local Injectors = require "Injectors/Models/Injectors"
local Roles = require "Injectors/Utils/Roles"

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "SaveInjectorOptions" then return end

    if not player then return end

    if not Roles.hasCapability(player, Capability.SandboxOptions) then
        FileLogger.Warn(string.format(
            "%s was denied injector save: missing SandboxOptions capability.",
            FileLogger.FormatPlayer(player)
        ))
        return
    end

    local id = args.id
    local data = args.data

    local fileName = "Injectors/" .. id .. ".ini"
    local writer = getFileWriter(fileName, true, false)

    if writer and data.Effects then
        for effectName, effectProps in pairs(data.Effects) do
            writer:write("[Effects." .. effectName .. "]\n")
            for k, v in pairs(effectProps) do
                writer:write(k .. " = " .. tostring(v) .. "\n")
            end
            writer:write("\n")
        end
        writer:close()
        FileLogger.Info(string.format(
            "Saved injector configuration to '%s'.",
            tostring(fileName)
        ))
    end

    Injectors.Set(id, data)
end

Events.OnClientCommand.Add(OnClientCommand)