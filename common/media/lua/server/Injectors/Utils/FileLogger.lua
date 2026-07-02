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

local function formatMillis(ms, offsetHours)
    local adjusted = math.floor(ms / 1000) + (offsetHours * 3600)
    local t = os.date("!*t", adjusted)
    return string.format(
        "%04d-%02d-%02d %02d:%02d:%02d",
        t.year, t.month, t.day, t.hour, t.min, t.sec
    )
end

local log = function(level, msg)
    local line = string.format(
        "[%s][Injectors:%s] %s",
        formatMillis(getTimeInMillis(), SandboxVars.Injectors.GLOBAL_LOGGER_OFFSET or 0),
        level, msg)

    writeToFile(line)
end

--- @param player IsoPlayer
function FileLogger.FormatPlayer(player)
    if not player or not player.getUsername then
        return "#Unknown#"
    end

    return string.format("'%s'", player:getUsername())
end

function FileLogger.Info(msg)
    log("INFO", msg)
end

function FileLogger.Warn(msg)
    log("WARN", msg)
end

function FileLogger.Error(msg)
    log("ERROR", msg)
end

function FileLogger.Raw(msg)
    writeToFile(msg)
end

return FileLogger