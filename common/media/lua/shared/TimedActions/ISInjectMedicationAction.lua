print("ISInjectMedicationAction.lua")

require "TimedActions/ISBaseTimedAction"

ISInjectMedicationAction = ISBaseTimedAction:derive("ISInjectMedicationAction");

local Injectors = {
    ["Injectors.injector_epinephrine"] = "epinephrine",
    ["Injectors.injector_morphine"] = "morphine",
    ["Injectors.injector_adrenaline"] = "adrenaline",
}

function ISInjectMedicationAction:isValid()
    return true;
end

function ISInjectMedicationAction:update()

end

function ISInjectMedicationAction:start()
    self:setOverrideHandModels(self.item, nil);
    self:setActionAnim("MedicalCheck")
end

function ISInjectMedicationAction:stop()
    ISBaseTimedAction.stop(self);
end

-- on client-side finish
function ISInjectMedicationAction:perform()
    print("injection done (client).")
    ISBaseTimedAction.perform(self);
end

-- on server-side finish
function ISInjectMedicationAction:complete()
    print("injection done (server).")

    if isServer() then
        local Container = require "Injectors/Utils/_Container" -- load order underscore
        local itemType = self.item:getFullType()
        local injector = Injectors[itemType]

        if injector then
            Container.Apply(self.character, injector)
        end
    end

    return true
end

function ISInjectMedicationAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end

    return 100
end

function ISInjectMedicationAction:new(character, item)
    local o = ISBaseTimedAction.new(self, character)
    o.item = item;
    o.maxTime = o:getDuration();
    return o
end