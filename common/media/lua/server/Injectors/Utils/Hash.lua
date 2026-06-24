-- server only
if not isServer() then return end

local Hash = {}

local PRIVATE_KEY = "todo-move-this-key-to-sandbox-vars"

-- Fletcher-32 hashing, basic tampering prevention
local function hash(string_to_hash)
    local sum1 = 0xffff
    local sum2 = 0xffff

    for i = 1, #string_to_hash do
        local char_code = string.byte(string_to_hash, i)
        sum1 = (sum1 + char_code) % 65535
        sum2 = (sum2 + sum1) % 65535
    end

    return string.format("%04X%04X", sum1, sum2)
end

function Hash.Sign(data)
    if data == nil then return nil end

    local payload = tostring(data) .. ":" .. PRIVATE_KEY
    local signature = hash(payload)

    return signature
end

function Hash.Verify(data, provided)
    if data == nil or not provided then
        return false
    end

    local expected = Hash.Sign(data)
    return expected == provided
end

return Hash