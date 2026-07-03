-- server only
if not isServer() then return end

local Injectors = require "Injectors/Models/Injectors"
local FileLogger = require "Injectors/Utils/FileLogger"
local File = require "Injectors/Utils/File"
local Ini = require "Injectors/Utils/Ini"

local INJECTORS = {
    "injector_red",
    "injector_blue",
    "injector_green"
}

local function loadInjector(id)
    local injectorData = Injectors.Get(id)
    if injectorData then return injectorData end

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
    return injectorData
end

local function onGameBoot()
    for _, id in ipairs(INJECTORS) do
        FileLogger.Info(string.format(
            "Loading injector configuration for '%s'.", id
        ))

        loadInjector(id)
    end
end

Events.OnGameBoot.Add(onGameBoot)