require "TimedActions/ISBaseTimedAction"

ISInjectMedicationAction = ISBaseTimedAction:derive("ISInjectMedicationAction");

local Modules = {
    ["Injectors.injector_epinephrine"] = "Injectors/Settings/UsedEpinephrine",
    ["Injectors.injector_propital"]    = "Injectors/Settings/UsedPropital",
    ["Injectors.injector_hemostatic"]  = "Injectors/Settings/UsedHemostatic"
}

-- TODO: add server-side validation instead
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
-- TODO: replace with server-side checks, add validation container, remove item from inventory, etc
function ISInjectMedicationAction:complete()
    print("injection done (server).")

    if isServer() then
        local itemType = self.item:getFullType()
        local modulePath = Modules[itemType]

        if modulePath then
            local Injector = require(modulePath)
            if Injector and Injector.Used then
                Injector.Used(self.character)
            else
                -- TODO: inject proper logging
                print("Error: Could not find Used() function in " .. modulePath)
            end
        end
    end

    return true;
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