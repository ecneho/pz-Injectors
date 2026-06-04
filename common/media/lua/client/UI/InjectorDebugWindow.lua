require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISContextMenu"

-- very crude ui for easier debugging. not for production

local function giveItem(itemType)
    local player = getSpecificPlayer(0)
    if not player then return end
    player:getInventory():AddItem(itemType)
end

InjectorDebugWindow = ISCollapsableWindow:derive("InjectorDebugWindow")

function InjectorDebugWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    self.listBox = ISScrollingListBox:new(0, self:titleBarHeight(), self.width, self.height - self:titleBarHeight())

    self.listBox:initialise()
    self.listBox.itemheight = 24
    self.listBox.font = UIFont.Small

    self.listBox.doDrawItem = function(listbox, y, item)
        listbox:drawText(item.text, 10, y + (listbox.itemheight - 15) / 2, 1, 1, 1, 1, listbox.font)
        return y + listbox.itemheight
    end

    self.listBox.onRightMouseUp = function(listbox, x, y)
        local row = math.floor(y / listbox.itemheight) + 1
        local item = listbox.items[row]
        local context = ISContextMenu.get(0, x + listbox:getAbsoluteX(), y + listbox:getAbsoluteY())

        if item and item.item then
            context:addOption("Remove Infliction", item.item, function(infliction)
                local player = getSpecificPlayer(0)
                if not player then return end

                local inflictions = player:getModData().inflictions
                if not inflictions then return end

                for i = #inflictions, 1, -1 do
                    if inflictions[i] == infliction then
                        table.remove(inflictions, i)
                        break
                    end
                end
                self:populateList()
            end)
        end

        local addMenu = context:getNew(context)
        context:addSubMenu(context:addOption("Give Injector"), addMenu)

        addMenu:addOption("Propital",    nil, function() giveItem("Injectors.injector_propital")    end)
        addMenu:addOption("Epinephrine", nil, function() giveItem("Injectors.injector_epinephrine") end)
        addMenu:addOption("Hemostatic",  nil, function() giveItem("Injectors.injector_hemostatic")  end)

        return true
    end

    self:addChild(self.listBox)
    self:populateList()
end

function InjectorDebugWindow:update()
    ISCollapsableWindow.update(self)
    self:populateList()
end

function InjectorDebugWindow:populateList()
    self.listBox:clear()
    local player = getSpecificPlayer(0)

    if player then
        local stats = player:getStats()
        local damage = player:getBodyDamage()
        local health = damage:getOverallBodyHealth()
        local pain = stats:get(CharacterStat.PAIN)

        self.listBox:addItem(string.format("Health: %d", health), nil)
        self.listBox:addItem(string.format("Pain: %d", pain), nil)

        local modData = player:getModData()
        local inflictions = modData.inflictions

        if inflictions and #inflictions > 0 then
            for i = 1, #inflictions do
                local inf = inflictions[i]
                if inf then
                    local name = tostring(inf.func or "Function")
                    local delay = math.max(0, math.floor(tonumber(inf.delay) or 0))
                    local duration = math.max(0, math.floor(tonumber(inf.duration) or 0))
                    local text = string.format("[%d] %s Delay: %d Duration: %d", i, name, delay, duration)
                    self.listBox:addItem(text, inf)
                end
            end
        else
            self.listBox:addItem("No active inflictions.", nil)
        end
    else
        self.listBox:addItem("Player not found.", nil)
    end
end

function InjectorDebugWindow:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.title = "Debug: Inflictions"
    o.pin = true

    return o
end

local function InitInjectorDebugWindow()
    local debugUI = InjectorDebugWindow:new(50, 200, 350, 220)
    debugUI:initialise()
    debugUI:addToUIManager()
end

Events.OnGameStart.Add(InitInjectorDebugWindow)