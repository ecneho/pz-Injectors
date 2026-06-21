--- @param player IsoPlayer
function Epinephrine_OnInject(food, player, _)
    sendClientCommand("InjectorsModule", "UseEpinephrineIgnoreSafety", {})
end

--- @param player IsoPlayer
function Hemostatic_OnInject(food, player, _)
    sendClientCommand("InjectorsModule", "UseHemostaticIgnoreSafety", {})
end

--- @param player IsoPlayer
function Propital_OnInject(food, player, _)
    sendClientCommand("InjectorsModule", "UsePropitalIgnoreSafety", {})
end