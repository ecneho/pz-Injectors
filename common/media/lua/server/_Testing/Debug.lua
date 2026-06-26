-- server only
if not isServer() then return end

local Ini = require "Injectors/Utils/Ini"
local Injectors = require "Injectors/Models/Injectors"

local function readAllLines(path)
    local reader = getFileReader(path, false)
    if not reader then
        print("[Injectors] File not found: " .. tostring(path))
        return
    end

    local lines = {}
    local line = reader:readLine()

    while line do
        print("reading line...")
        table.insert(lines, line)
        line = reader:readLine()
    end

    reader:close()
    return lines
end

local function readFile(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "Readfile" then return end

    print("reading test file...")

    local fileName = "Injectors/red_injector.ini"

    local lines = readAllLines(fileName)
    if not lines then return end

    print("[Injectors] Reading file: " .. fileName)

    for i, line in ipairs(lines) do
        print(i .. ": " .. line)
    end

    local ini = Ini.parse(lines)

    print(ini)
    print(ini.Effects)
    print(ini.effects)

    Injectors.Set("injector_red", ini)
    Injectors.Set("injector_blue", ini)
    Injectors.Set("injector_green", ini)
end

Events.OnClientCommand.Add(readFile)