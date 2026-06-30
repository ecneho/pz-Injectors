if not isServer() then return end

local Ini = require "Injectors/Utils/Ini"
local Injectors = require "Injectors/Models/Injectors"

local function readAllLines(path)
    local reader = getFileReader(path, false)
    if not reader then return nil end

    local lines = {}
    local line = reader:readLine()
    while line do
        table.insert(lines, line)
        line = reader:readLine()
    end
    reader:close()
    return lines
end

local function OnClientCommand(module, command, player, args)
    if module ~= "InjectorsModule" then return end

    if command == "SaveInjectorOptions" then
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
            print("[Injectors] Saved configuration to " .. fileName)
        end

        Injectors.Set(id, data)


    elseif command == "LoadInjectorOptions" then
        local id = args.id

        local injectorData = Injectors.Get(id)

        if not injectorData then
            local lines = readAllLines("Injectors/" .. id .. ".ini")

            if lines then
                injectorData = Ini.parse(lines)
                injectorData.id = id
            else
                injectorData = { id = id, Effects = {} }
            end

            Injectors.Set(id, injectorData)
        end

        sendServerCommand(player, "InjectorsModule", "ReceiveInjectorOptions", { data = injectorData })
    end
end

Events.OnClientCommand.Add(OnClientCommand)