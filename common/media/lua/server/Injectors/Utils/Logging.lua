-- server only
if not isServer() then return end

local Logging = {}

-- mod info
function Logging.Info(msg)
    print("[Injectors:INFO] " .. msg)
end

-- suspicious activity
function Logging.Warning(msg)
    print("[Injectors:WARN] " .. msg)
end

-- mod errors
function Logging.Error(msg)
    print("[Injectors:ERROR] " .. msg)
end

-- table dump
function Logging.Table(header, tbl)
    local header = "[Injectors:TABLE] " .. header
    local indent = string.rep(" ", 20)

    local keyWidth = 0
    local valueWidth = 0

    for k, v in pairs(tbl) do
        keyWidth = math.max(keyWidth, #tostring(k))
        valueWidth = math.max(valueWidth, #tostring(v))
    end

    local sep = " | "

    local lines = {}
    table.insert(lines, header)
    table.insert(lines, indent)

    for k, v in pairs(tbl) do
        table.insert(lines, indent .. string.format(
            "| %-"
            .. keyWidth
            .. "s%s%-"
            .. valueWidth
            .. "s |",
            tostring(k), sep, tostring(v)
        ))
    end

    table.insert(lines, indent)
    print(table.concat(lines, "\n"))
end

return Logging