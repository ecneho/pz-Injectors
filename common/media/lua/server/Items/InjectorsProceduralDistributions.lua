local spawner = "Injectors.injector_empty"
local CONFIG_FILE = "Injectors/distribution.ini"

local function injectItem(containerName, item, weight)
    ---@diagnostic disable-next-line Undefined field `list`
    local container = ProceduralDistributions.list[containerName]
    table.insert(container.items, item)
    table.insert(container.items, weight)
end

local function initializeFile()
    local writer = getFileWriter(CONFIG_FILE, false, false)
    if writer then
        writer:write("10\n")
        writer:write("MedicalCabinet\n")
        writer:write("HospitalRoomCounter\n")
        writer:write("HospitalRoomShelves\n")
        writer:write("MedicalStorageOutfit\n")
        writer:write("MedicalStorageTools\n")
        writer:write("BinHospital\n")
        writer:write("HospitalLockers\n")
        writer:write("MedicalClinicTools\n")
        writer:write("MedicalClinicDrugs\n")
        writer:close()
    end
end

local function loadCustomDistributions()
    local reader = getFileReader(CONFIG_FILE, false)
    if not reader then
        initializeFile()
        reader = getFileReader(CONFIG_FILE, false)
    end

    if not reader then return end

    local chanceStr = reader:readLine()
    if not chanceStr then
        reader:close()
        return
    end

    local chance = tonumber(chanceStr) or 10

    local containerName = reader:readLine()
    while containerName ~= nil do
        if containerName ~= "" then
            injectItem(containerName, spawner, chance)
        end
        containerName = reader:readLine()
    end

    reader:close()
end

loadCustomDistributions()