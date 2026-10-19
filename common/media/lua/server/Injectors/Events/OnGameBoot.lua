if isClient() then return end

local Injectors = require "Injectors/Models/Injectors"
local FileLogger = require "Injectors/Utils/FileLogger"

local function onGameBoot()
    for _, id in ipairs(Injectors.Ids) do
        FileLogger.Info(string.format(
            "Loading injector configuration for '%s'.", id
        ))

        Injectors.Get(id)
    end
end

Events.OnGameBoot.Add(onGameBoot)