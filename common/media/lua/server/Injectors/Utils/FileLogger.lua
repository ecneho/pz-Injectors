-- server only
if not isServer() then return end

local FileLogger = {}

local LOG_FILE = "Injectors/latest.log"

local function writeToFile(line)
    local writer = getFileWriter(LOG_FILE, true, true)

    if writer then
        writer:write(line .. "\n")
        writer:close()
    end
end

function FileLogger.Info(msg)
    local line = string.format(
        "[%s] [Injectors:INFO] %s",
        os.date("%Y-%m-%d %H:%M:%S"),
        tostring(msg))

    writeToFile(line)
end

return FileLogger