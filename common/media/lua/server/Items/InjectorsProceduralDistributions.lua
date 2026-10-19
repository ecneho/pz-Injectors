local spawner = "Injectors.injector_empty"
local CONFIG_FILE = "Injectors/distribution.ini"

local function injectItem(containerName, item, weight)
    ---@diagnostic disable-next-line Undefined field `list`
    local container = ProceduralDistributions.list[containerName]
    if not container then return end

    table.insert(container.items, item)
    table.insert(container.items, weight)
end

local function readConfigLines()
    local reader = getFileReader(CONFIG_FILE, false)
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

local function readDefaultLines()
    local success, text = pcall(require, "Injectors/Defaults/distribution")

    if not success or type(text) ~= "string" then
        return nil
    end

    local lines = {}

    for line in string.gmatch(text, "[^\r\n]+") do
        table.insert(lines, line)
    end

    return lines
end

local function loadCustomDistributions()
    local lines = readConfigLines() or readDefaultLines()
    if not lines or not lines[1] then return end

    local chance = tonumber(lines[1]) or 10

    for i = 2, #lines do
        local containerName = lines[i]

        if containerName ~= "" then
            injectItem(containerName, spawner, chance)
        end
    end
end

loadCustomDistributions()