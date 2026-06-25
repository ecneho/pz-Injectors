-- server only
if not isServer() then return end

local function readAllLines(path)
    local reader = getFileReader(path, false)
    if not reader then
        print("[Injectors] File not found: " .. tostring(path))
        return
    end

    local lines = {}
    local line = reader:readLine()

    while line do
        print("reading line...")
        table.insert(lines, line)
        line = reader:readLine()
    end

    reader:close()
    return lines
end

local function readFile(module, command, player, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "Readfile" then return end

    print("reading test file...")

    local fileName = "Injectors/testfile.txt"

    local lines = readAllLines(fileName)
    if not lines then return end

    print("[Injectors] Reading file: " .. fileName)

    for i, line in ipairs(lines) do
        print(i .. ": " .. line)
    end
end

Events.OnClientCommand.Add(readFile)

-- TODO: parse scripting syntax, similar to sql
-- DEFINE <injector>
-- APPLY <effect>
--  EACH <n ticks, rate> t
--  FOR <n ticks, duration> t
--  AFTER <n ticks, delay> t
-- VALUES
--  base 10
-- measure time in ticks, frames (60 ticks), segments (60 frames) and cycles (24 segments)
-- units are sandbox variables