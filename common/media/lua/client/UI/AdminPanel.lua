require "ISUI/ISPanel"

InjectorsAdminWindow = ISPanel:derive("InjectorsAdminWindow")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

function InjectorsAdminWindow:initialise()
    ISPanel:initialise()
end

function InjectorsAdminWindow:createChildren()

    local x = UI_BORDER_SPACING + 1
    local y = FONT_HGT_MEDIUM + UI_BORDER_SPACING * 2 + 1
    local btnWid = 200

    self.buttons = {}

    -- TODO: locale support
    local commands = {
        {
            text = "Reload Sandbox Variables",
            command = "ReloadVariables"
        },
        {
            text = "Dump Sandbox Variables",
            command = "DumpVariables"
        },
        {
            text = "Dump Overdose Value",
            command = "DumpOverdose"
        },
        {
            text = "Test External Logs",
            command = "TestExternalLogs"
        },
        {
            text = "Apply Epinephrine Effect",
            command = "UseEpinephrineIgnoreSafety"
        },
        {
            text = "Apply Hemostatic Effect",
            command = "UseHemostaticIgnoreSafety"
        },
        {
            text = "Apply Propital Effect",
            command = "UsePropitalIgnoreSafety"
        },
        {
            text = "Clear Injector Effects",
            command = "ClearEffects"
        },
        {
            text = "Reduce General Health",
            command = "ReduceGeneralHealth"
        },
        {
            text = "Apply Bleeding and Deep Wounds",
            command = "ApplyBleedingDeepWounds"
        },
        {
            text = "Set Maximum Applicable Pain",
            command = "SetMaximumPain"
        },
        {
            text = "Dump Inventory Items",
            command = "DumpInventoryIDs"
        },
    }

    for _, config in ipairs(commands) do
        local btn = ISButton:new(x, y, btnWid, BUTTON_HGT, config.text, self, InjectorsAdminWindow.onCommandClick)

        btn.internal = config.command
        btn.borderColor = self.buttonBorderColor

        btn:initialise()
        btn:instantiate()

        self:addChild(btn)
        table.insert(self.buttons, btn)
    end

    local width = 0
    local bottom = 0
    local buttonValue = 0
    local columnCount = 1

    for _, child in ipairs(self.buttons) do
        width = math.max(width, child:getWidth())
    end

    -- table.sort(self.buttons, function(a, b)
    --     return string.sort(b.title, a.title)
    -- end)

    for _, child in ipairs(self.buttons) do
        child:setWidth(width)

        child:setX(x + math.fmod(buttonValue, columnCount) * (width + UI_BORDER_SPACING))
        child:setY(y + math.floor(buttonValue / columnCount) * (BUTTON_HGT + UI_BORDER_SPACING))

        bottom = math.max(bottom, child:getBottom())
        buttonValue = buttonValue + 1
    end

    self:setWidth(x * 2 + width * columnCount + UI_BORDER_SPACING * (columnCount - 1))
    self:setHeight(bottom + UI_BORDER_SPACING + BUTTON_HGT + 10)
end

function InjectorsAdminWindow:render()
    local title = "INJECTORS PANEL"
    self:drawText(
        title,
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, title) / 2),
        UI_BORDER_SPACING + 1,
        1, 1, 1, 1,
        UIFont.Medium
    )
end

function InjectorsAdminWindow:onCommandClick(button)
    if button.internal then
        print("Sending client command: " .. button.internal)
        sendClientCommand("InjectorsModule", button.internal, {})
    end
end

function InjectorsAdminWindow:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.title = "Injectors Admin Panel"
    o.pin = true
    o.moveWithMouse = true
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 }

    return o
end

local function ensureCustomWindow(self)
    if self.injectorsAdminWindow then return end

    self.injectorsAdminWindow = InjectorsAdminWindow:new(0, 0, 160, 155)
    self.injectorsAdminWindow:initialise()
    self.injectorsAdminWindow:addToUIManager()
end

local function updateCustomWindowPosition(self)
    if not self.injectorsAdminWindow then return end

    local core = getCore()
    local scale = core:getOptionFontSizeReal()

    local panel = self

    local ax = panel:getAbsoluteX()
    local ay = panel:getAbsoluteY()

    local offsetX = math.floor(panel:getWidth() + 20 * scale)
    local offsetY = math.floor(0)

    self.injectorsAdminWindow:setX(ax + offsetX)
    self.injectorsAdminWindow:setY(ay + offsetY)
end

local old_prerender = ISAdminPanelUI.prerender
function ISAdminPanelUI:prerender()
    old_prerender(self)

    updateCustomWindowPosition(self)
end

local old_createChildren = ISAdminPanelUI.createChildren
function ISAdminPanelUI:createChildren()
    old_createChildren(self)
    ensureCustomWindow(self)
end

local old_setVisible = ISAdminPanelUI.setVisible
function ISAdminPanelUI:setVisible(visible)
    old_setVisible(self, visible)

    if self.injectorsAdminWindow then
        self.injectorsAdminWindow:setVisible(visible)
    end
end

local old_remove = ISAdminPanelUI.removeFromUIManager
function ISAdminPanelUI:removeFromUIManager()
    old_remove(self)

    if self.injectorsAdminWindow then
        self.injectorsAdminWindow:removeFromUIManager()
        self.injectorsAdminWindow = nil
    end
end