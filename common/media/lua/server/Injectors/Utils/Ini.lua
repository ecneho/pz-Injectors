-- server only
if not isServer() then return end

local ini = {}

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function toValue(value)
    value = trim(value)

    if value == "true" then return true end
    if value == "false" then return false end

    local num = tonumber(value)
    if num then return num end

    if string.find(value, ",") then
        local list = {}
        for v in string.gmatch(value, "([^,]+)") do
            local parsed = tonumber(trim(v)) or trim(v)
            table.insert(list, parsed)
        end
        return list
    end

    return value
end

local function getNested(data, path)
    local current = data

    for part in string.gmatch(path, "([^%.]+)") do
        current[part] = current[part] or {}
        current = current[part]
    end

    return current
end

function ini.parse(lines)
    local data = {}
    local sectionTable = nil

    for _, line in ipairs(lines) do
        line = trim(line)

        if line ~= "" and not line:match("^#") and not line:match("^;") then

            local section = line:match("^%[([^%[%]]+)%]$")
            if section then
                sectionTable = getNested(data, section)

            else
                local key, value = line:match("^([%w_]+)%s-=%s-(.+)$")

                if key and sectionTable then
                    sectionTable[key] = toValue(value)
                end
            end
        end
    end

    return data
end

return ini