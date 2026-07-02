-- server only
if not isServer() then return end

local System = require "Injectors/System"
local Common = require "Injectors/Variables/Common"
local Overdose = require "Injectors/Models/Overdose"

---@class OverdoseTickArgs
---@field base number

---@param player IsoPlayer
---@param ticks number
---@param args OverdoseTickArgs
local function OnOverdoseTick(player, ticks, args)
    local username = player:getUsername()
    local overdose = Overdose.Get(username)

    local updated = overdose + args.base
    local clamped = math.max(0, math.min(Common.OVERDOSE_THRESHOLD + 10, updated))

    if clamped ~= overdose then
        Overdose.Set(username, clamped)
    end
end

System.RegisterEffect("ChangeOverdoseEffect", OnOverdoseTick)