-- server only
if not isServer() then return end

local File = {}

function File.ReadLines(path)
    local reader = getFileReader(path, false)
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

return File