-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Data = require "Injectors/Utils/Data"

---@class OverdoseTickArgs
---@field base number

---@param player IsoPlayer
---@param ticks number
---@param args OverdoseTickArgs
local function OnOverdoseTick(player, ticks, args)
    local username = player:getUsername()
    local overdoseList = Data.GetOverdoseList()

    local overdose = overdoseList[username] or 0

    local updated = overdose + args.base

    local clamped = math.max(0, math.min(100, updated))
    local changed = clamped ~= overdose

    if changed then
        overdoseList[username] = clamped
    end

    print("---- Overdose Args ----")
    print("args.base: " .. args.base)
    print("-----------------------")
    print("Player: " .. username)
    print("OD current: " .. overdose)
    print("OD updated: " .. updated)
    print("OD clamped: " .. clamped)
    print("OD delta: " .. args.base)
    print("OD tick. ticks left: " .. ticks)
end

System.RegisterEffect("ChangeOverdoseEffect", OnOverdoseTick)