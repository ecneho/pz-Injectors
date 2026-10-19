if isClient() then return end

local File = require "Injectors/Utils/File"
local Ini = require "Injectors/Utils/Ini"
local Registry = require "Injectors/Registry"

local Injectors = {}

Injectors.Ids = Registry.Ids

local function getStorage()
    return ModData.getOrCreate("Injectors_InjectorList")
end

local function isKnown(id)
    for _, known in ipairs(Injectors.Ids) do
        if known == id then return true end
    end

    return false
end

local function loadDefault(id)
    local success, text = pcall(require, "Injectors/Defaults/" .. id)

    if not success or type(text) ~= "string" then
        return nil
    end

    local lines = {}

    for line in string.gmatch(text, "[^\r\n]+") do
        table.insert(lines, line)
    end

    local injectorData = Ini.parse(lines)
    injectorData.id = id
    injectorData.Effects = injectorData.Effects or {}

    return injectorData
end

---@param id string
function Injectors.Load(id)
    local injectorData = nil
    local lines = File.ReadLines("Injectors/" .. id .. ".ini")

    if lines then
        injectorData = Ini.parse(lines)
        injectorData.id = id
    else
        injectorData = loadDefault(id) or {
            id = id,
            Effects = {}
        }
    end

    getStorage()[id] = injectorData
    return injectorData
end

---@param injector string
function Injectors.Get(injector)
    local injectorData = getStorage()[injector]
    if injectorData then return injectorData end

    if isKnown(injector) then
        return Injectors.Load(injector)
    end

    return nil
end

---@param id string
---@param injector table
function Injectors.Set(id, injector)
    local data = getStorage()
    data[id] = injector
end

return Injectors