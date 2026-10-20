-- for future ref:
-- ISApplyBandage.lua
-- ISDrinkFromBottle.lua

require "TimedActions/ISBaseTimedAction"

ISInjectMedicationAction = ISBaseTimedAction:derive("ISInjectMedicationAction");

-- client
function ISInjectMedicationAction:isBlocked()
    local Overdose = require "Injectors/Models/Overdose"
    local Players = require "Injectors/Utils/Players"
    local Safety = require "Injectors/Utils/Safety"
    local Net = require "Injectors/Utils/Net"

    if Safety.IsBlocked(Overdose.Get(Players.Key(self.character))) then
        Net.Reply(self.character, "OverdoseBlocked", {})
        return true
    end

    return false
end

function ISInjectMedicationAction:isValidStart()
    if isClient() then return true end

    return not self:isBlocked()
end

function ISInjectMedicationAction:isValid()
    if self.item then
        if isClient() then
            return self.itemWasPresent
        else
            return self.character:getInventory():contains(self.item)
        end
    end
    return false;
end

-- client
function ISInjectMedicationAction:update()
    if self.item then
        self.item:setJobDelta(self:getJobDelta());
    end
end

-- server
function ISInjectMedicationAction:serverStart()
    local FileLogger = require "Injectors/Utils/FileLogger"

    if type(FileLogger) == "table" then
        FileLogger.Info(string.format(
            "%s started injector timed action.",
            FileLogger.FormatPlayer(self.character)
        ))
    else
        print("injectors: logger not loaded")
    end
end

-- server
function ISInjectMedicationAction:serverStop()
    local FileLogger = require "Injectors/Utils/FileLogger"

    if type(FileLogger) == "table" then
        FileLogger.Info(string.format(
            "%s stopped injector timed action.",
            FileLogger.FormatPlayer(self.character)
        ))
    else
        print("injectors: logger not loaded")
    end
end

-- client
function ISInjectMedicationAction:start()
    if isClient() and self.item then
        self.item = self.character:getInventory():getItemById(self.item:getID())
    end

    self:setActionAnim("Loot")
    self.character:SetVariable("LootPosition", "Mid")
    self.character:reportEvent("EventLootItem");
    self:setOverrideHandModels(nil, nil);

    if self.item then
        self.item:setJobType(getText("ContextMenu_InjectMedication"));
        self.item:setJobDelta(0.0);
    end
end

-- client
function ISInjectMedicationAction:stop()
    if self.item then
        self.item:setJobDelta(0.0);
    end
    ISBaseTimedAction.stop(self);
end

-- on client-side finish
function ISInjectMedicationAction:perform()
    print("injectors: injection done (client).")

    if self.item then
        self.item:setJobDelta(0.0);
    end

    ISBaseTimedAction.perform(self);
end

-- on server-side finish
function ISInjectMedicationAction:complete()
    print("injectors: injection done (server).")

    local FileLogger = require "Injectors/Utils/FileLogger"

    if type(FileLogger) == "table" then
        FileLogger.Info(string.format(
            "%s finished injector timed action.",
            FileLogger.FormatPlayer(self.character)
        ))
    else
        print("injectors: logger not loaded")
    end

    if not isClient() then
        if self.injected then return false end
        if self:isBlocked() then return false end

        local character = self.character ---@type IsoPlayer
        local item = self.item ---@type InventoryItem

        if not character then print("injectors: character not found") return false end
        if not item then print("injectors: item not found") return false end

        local module = item:getModule()

        if module ~= "Injectors" then print("injectors: wrong module") return false end

        local Settings = require "Injectors/Settings/UsedInjector"

        if not Settings then print("injectors: settings not loaded") return false end

        local type = item:getType()

        print("injectors: using " .. type)

        local status = Settings.Used(character, item, type)

        if status then
            print("injectors: success")
            self.injected = true
            local inventory = character:getInventory()

            if not inventory:contains(item) then
                return false
            end

            inventory:DoRemoveItem(item)
            if isServer() then
                sendRemoveItemFromContainer(inventory, item)
            end

            return true
        else
            print("injectors: failure")
        end
    end

    return false
end

function ISInjectMedicationAction:getDuration()
    if self.character:isTimedActionInstant() then
        return 1
    end

    return SandboxVars.Injectors.GLOBAL_INJECTION_DURATION or 1
end

function ISInjectMedicationAction:new(character, item)
    local o = ISBaseTimedAction.new(self, character)
    o.item = item;
    o.maxTime = o:getDuration();

    o.itemWasPresent = item ~= nil;
    o.stopOnWalk = false;
    o.stopOnRun = true;

    return o
end