-- cached vanilla function
local original_ISTakePillAction_perform = ISTakePillAction.perform

-- overdose penalty - FIX: client-sided, unsafe!!!
local function onUsePainkillers(player, item)
    if not player or player:isDead() then return end

    local modData = player:getModData()
    modData.overdose = modData.overdose or 0
    modData.overdose = modData.overdose + InjectorVars.PAINKILLERS_OVERDOSE_PENALTY
end

-- vanilla function hook
function ISTakePillAction:perform()
    if self.item and self.item:getFullType() == "Base.Pills" then
        onUsePainkillers(self.character, self.item)
    end
    original_ISTakePillAction_perform(self)
end