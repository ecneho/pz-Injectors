-- TODO: add networking

require "ISUI/ISCollapsableWindow"
require "ISUI/ISScrollingListBox"
require "ISUI/ISComboBox"
require "ISUI/ISTextEntryBox"
require "ISUI/ISButton"
require "ISUI/ISLabel"

-- constants
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6
local COMBO_HGT = FONT_HGT_SMALL + 8

-- mock file system
local MOCK_FILE_SYSTEM = {
    injector_red = {
        id = "injector_red",
        Effects = {
            ChangeHungerEffect = {
                duration = 30,
                delay = 10,
                rate = 1,
                amount = 0.1
            }
        }
    },

    injector_blue = {
        id = "injector_blue",
        Effects = {}
    },

    injector_green = {
        id = "injector_green",
        Effects = {}
    }
}

local function LOAD_INI(id)
    print("REPLACE_THIS: Loading INI for " .. tostring(id))

    if not MOCK_FILE_SYSTEM[id] then
        MOCK_FILE_SYSTEM[id] = { id = id, Effects = {} }
    end

    local copy = { id = MOCK_FILE_SYSTEM[id].id, Effects = {} }
    for effName, effData in pairs(MOCK_FILE_SYSTEM[id].Effects) do
        copy.Effects[effName] = {}
        for k, v in pairs(effData) do
            copy.Effects[effName][k] = v
        end
    end

    return copy
end

local function SAVE_INI(id, data)
    print("REPLACE_THIS: Saving INI for " .. tostring(id))

    MOCK_FILE_SYSTEM[id] = data

    for effectName, effectData in pairs(data.Effects) do
        print("  Saved Effect: " .. effectName)
        for k, v in pairs(effectData) do
            print("    " .. k .. " = " .. tostring(v))
        end
    end
end

-- effect schemas
local EFFECT_SCHEMA = {
    ChangeHungerEffect = { "duration", "delay", "rate", "amount" },
    ChangeThirstEffect = { "duration", "delay", "rate", "amount" },
    ChangePainEffect   = { "duration", "delay", "rate", "base", "minRange", "maxRange", "minScale", "maxScale" }
}

-- ui class
InjectorConstructorUI = ISCollapsableWindow:derive("InjectorConstructorUI")

function InjectorConstructorUI:initialise()
    ISCollapsableWindow.initialise(self)
    self.title = "Injector Constructor"
end

function InjectorConstructorUI:createChildren()
    ISCollapsableWindow.createChildren(self)

    local yOff = self:titleBarHeight() + UI_BORDER_SPACING

    local leftPanelWidth = 240

    self.injectorCombo = ISComboBox:new(UI_BORDER_SPACING, yOff, 120, COMBO_HGT, self, self.onSelectInjector)
    self.injectorCombo:initialise()
    self:addChild(self.injectorCombo)
    self.injectorCombo:addOption("injector_red")
    self.injectorCombo:addOption("injector_blue")
    self.injectorCombo:addOption("injector_green")

    self.btnLoad = ISButton:new(self.injectorCombo:getRight() + UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, "Load", self, self.onLoad)
    self.btnLoad:initialise()
    self.btnLoad:instantiate()
    self.btnLoad.borderColor = self.buttonBorderColor
    self:addChild(self.btnLoad)

    self.btnSave = ISButton:new(self.btnLoad:getRight() + UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, "Save", self, self.onSave)
    self.btnSave:initialise()
    self.btnSave:instantiate()
    self.btnSave.borderColor = self.buttonBorderColor
    self:addChild(self.btnSave)

    yOff = self.injectorCombo:getBottom() + UI_BORDER_SPACING

    local effectListHeight = self.height - yOff - COMBO_HGT - BUTTON_HGT - (UI_BORDER_SPACING * 3)

    self.effectList = ISScrollingListBox:new(UI_BORDER_SPACING, yOff, leftPanelWidth, effectListHeight)
    self.effectList:initialise()
    self.effectList:instantiate()
    self.effectList.itemheight = BUTTON_HGT + 4
    self.effectList.selected = 0
    self.effectList.font = UIFont.Small
    self.effectList.doDrawItem = self.drawEffectListItem
    self.effectList.drawBorder = true
    self.effectList.borderColor = self.borderColor
    self.effectList:setOnMouseDownFunction(self, self.onSelectEffectInList)
    self:addChild(self.effectList)

    local bottomControlsY = self.effectList:getBottom() + UI_BORDER_SPACING

    self.effectTypeCombo = ISComboBox:new(UI_BORDER_SPACING, bottomControlsY, leftPanelWidth, COMBO_HGT, self, nil)
    self.effectTypeCombo:initialise()
    self:addChild(self.effectTypeCombo)

    for effectName, _ in pairs(EFFECT_SCHEMA) do
        self.effectTypeCombo:addOption(effectName)
    end

    local actionBtnY = self.effectTypeCombo:getBottom() + UI_BORDER_SPACING
    local actionBtnWidth = (leftPanelWidth - UI_BORDER_SPACING) / 2

    self.btnAddEffect = ISButton:new(UI_BORDER_SPACING, actionBtnY, actionBtnWidth, BUTTON_HGT, "Add Effect", self, self.onAddEffect)
    self.btnAddEffect:initialise()
    self.btnAddEffect:instantiate()
    self.btnAddEffect:enableAcceptColor()
    self:addChild(self.btnAddEffect)

    self.btnRemoveEffect = ISButton:new(self.btnAddEffect:getRight() + UI_BORDER_SPACING, actionBtnY, actionBtnWidth, BUTTON_HGT, "Remove", self, self.onRemoveEffect)
    self.btnRemoveEffect:initialise()
    self.btnRemoveEffect:instantiate()
    self.btnRemoveEffect:enableCancelColor()
    self:addChild(self.btnRemoveEffect)

    local propPanelX = self.effectList:getRight() + UI_BORDER_SPACING
    self.propertiesPanel = ISPanel:new(propPanelX, self:titleBarHeight() + UI_BORDER_SPACING, self.width - propPanelX - UI_BORDER_SPACING, self.height - self:titleBarHeight() - (UI_BORDER_SPACING * 2))
    self.propertiesPanel:initialise()
    self.propertiesPanel.borderColor = self.borderColor
    self:addChild(self.propertiesPanel)

    self.dynamicInputs = {}
    self.currentInjectorData = { id = "injector_red", Effects = {} }
    self.selectedEffectName = nil

    self:onLoad()
end

-- rendering
function InjectorConstructorUI:drawEffectListItem(y, item, alt)
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.3, 0.7, 0.35, 0.15)
    elseif alt then
        self:drawRect(0, y, self:getWidth(), self.itemheight, 0.3, 0.6, 0.5, 0.5)
    end

    self:drawRectBorder(0, y, self:getWidth(), self.itemheight, 0.9, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    local fontHgt = getTextManager():getFontHeight(self.font)
    local textY = y + (self.itemheight - fontHgt) / 2
    self:drawText(item.text, UI_BORDER_SPACING, textY, 1, 1, 1, 0.9, self.font)

    return y + self.itemheight
end

function InjectorConstructorUI:buildPropertiesUI(effectName)
    self.propertiesPanel:clearChildren()
    self.dynamicInputs = {}

    if not effectName or not self.currentInjectorData.Effects[effectName] then return end

    local effectData = self.currentInjectorData.Effects[effectName]
    local schemaFields = EFFECT_SCHEMA[effectName]

    if not schemaFields then return end

    local innerY = UI_BORDER_SPACING
    local labelWidth = 100
    local inputWidth = 120

    local titleLabel = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_MEDIUM, effectName, 1, 1, 1, 1, UIFont.Medium, true)
    titleLabel:initialise()
    self.propertiesPanel:addChild(titleLabel)

    innerY = innerY + FONT_HGT_MEDIUM + UI_BORDER_SPACING

    for _, fieldName in ipairs(schemaFields) do
        local label = ISLabel:new(UI_BORDER_SPACING, innerY + 3, FONT_HGT_SMALL, fieldName, 1, 1, 1, 1, UIFont.Small, true)
        label:initialise()
        self.propertiesPanel:addChild(label)

        local input = ISTextEntryBox:new(tostring(effectData[fieldName] or "0"), UI_BORDER_SPACING + labelWidth, innerY, inputWidth, BUTTON_HGT)
        input:initialise()
        input:instantiate()
        self.propertiesPanel:addChild(input)

        self.dynamicInputs[fieldName] = input
        innerY = innerY + BUTTON_HGT + (UI_BORDER_SPACING / 2)
    end
end

-- buttons
function InjectorConstructorUI:onLoad()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)
    self.currentInjectorData = LOAD_INI(selectedId)
    self.currentInjectorData.Effects = self.currentInjectorData.Effects or {}

    self:refreshEffectList()
    self.propertiesPanel:clearChildren()
    self.selectedEffectName = nil
end

function InjectorConstructorUI:onSave()
    self:saveCurrentPropertiesToTable()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)
    self.currentInjectorData.id = selectedId
    SAVE_INI(selectedId, self.currentInjectorData)
end

function InjectorConstructorUI:onAddEffect()
    local effectToAdd = self.effectTypeCombo:getOptionText(self.effectTypeCombo.selected)

    if not self.currentInjectorData.Effects[effectToAdd] then
        local newEffectData = {}
        for _, fieldName in ipairs(EFFECT_SCHEMA[effectToAdd]) do
            newEffectData[fieldName] = 0
        end

        self.currentInjectorData.Effects[effectToAdd] = newEffectData
        self:refreshEffectList()
    end
end

function InjectorConstructorUI:onRemoveEffect()
    if not self.selectedEffectName then return end

    self.currentInjectorData.Effects[self.selectedEffectName] = nil
    self.selectedEffectName = nil
    self.propertiesPanel:clearChildren()
    self:refreshEffectList()
end

function InjectorConstructorUI:onSelectEffectInList()
    local selectedItem = self.effectList.items[self.effectList.selected]
    if selectedItem then
        self:saveCurrentPropertiesToTable()
        self.selectedEffectName = selectedItem.text
        self:buildPropertiesUI(self.selectedEffectName)
    end
end

function InjectorConstructorUI:onSelectInjector()
    self:onLoad()
end

-- utility
function InjectorConstructorUI:refreshEffectList()
    self.effectList:clear()
    for effectName, _ in pairs(self.currentInjectorData.Effects) do
        self.effectList:addItem(effectName, effectName)
    end
end

function InjectorConstructorUI:saveCurrentPropertiesToTable()
    if self.selectedEffectName and self.currentInjectorData.Effects[self.selectedEffectName] then
        local targetTable = self.currentInjectorData.Effects[self.selectedEffectName]
        for fieldName, inputUI in pairs(self.dynamicInputs) do
            local textVal = inputUI:getText()
            targetTable[fieldName] = tonumber(textVal) or textVal
        end
    end
end

-- constructor
function InjectorConstructorUI:new(x, y, width, height)
    if x == 0 and y == 0 then
        x = (getCore():getScreenWidth() / 2) - (width / 2)
        y = (getCore():getScreenHeight() / 2) - (height / 2)
    end

    local o = ISCollapsableWindow.new(self, x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.title = "Injector Constructor"
    o.resizable = false
    o.moveWithMouse = true

    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}

    return o
end

-- open ui
function OpenInjectorConstructor()
    local ui = InjectorConstructorUI:new(0, 0, 600, 450)
    ui:initialise()
    ui:addToUIManager()
end

-- TODO: move ui startup to the admin panel
Events.OnGameStart.Add(OpenInjectorConstructor)