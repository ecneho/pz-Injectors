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

-- effect schemas
local EFFECT_SCHEMA = {
    ChangeHungerEffect = { "duration", "delay", "rate", "amount" },
    ChangeThirstEffect = { "duration", "delay", "rate", "amount" },
    ChangeOverdoseEffect = { "duration", "delay", "rate", "base" },
    ChangePainEffect   = { "duration", "delay", "rate", "base", "minRange", "maxRange", "minScale", "maxScale" }
}

local EFFECT_UI = {
    ChangeHungerEffect = {
        notes = "Controls hunger stat value. (range: 0-1)",
        groups = {
            Timing = {
                { value = "duration", notes = "how long the effect lasts" },
                { value = "delay", notes = "delay before activation" },
                { value = "rate", notes = "update frequency" }
            },
            Values = {
                { value = "amount", notes = "hunger delta applied each activation" }
            }
        }
    },

    ChangeThirstEffect = {
        notes = "Controls thirst stat value. (range: 0-1)",
        groups = {
            Timing = {
                { value = "duration", notes = "how long the effect lasts" },
                { value = "delay", notes = "delay before activation" },
                { value = "rate", notes = "update frequency" }
            },
            Values = {
                { value = "amount", notes = "thirst delta applied each activation" }
            }
        }
    },

    ChangeOverdoseEffect = {
        notes = "Applies overdose penalty over time.",
        groups = {
            Timing = {
                { value = "duration", notes = "how long the effect lasts" },
                { value = "delay", notes = "delay before activation" },
                { value = "rate", notes = "update frequency" }
            },
            Values = {
                { value = "base", notes = "fixed overdose penalty applied each tick" }
            }
        }
    },

    ChangePainEffect = {
        notes = "Controls pain stat value. (range: 0-100)",
        groups = {
            Time = {
                { value = "duration", notes = "effect duration" },
                { value = "delay", notes = "activation delay" },
                { value = "rate", notes = "update frequency" }
            },
            Values = {
                { value = "base", notes = "base pain delta applied each activation" }
            },
            Scaling = {
                { value = "minRange", notes = "minimum linear scaling range" },
                { value = "maxRange", notes = "maximum linear scaling range" },
                { value = "minScale", notes = "minimum linear scaling multiplier" },
                { value = "maxScale", notes = "maximum linear scaling multiplier" }
            }
        }
    }
}

local ActiveInjectorUI = nil

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

    yOff = self.injectorCombo:getBottom() + UI_BORDER_SPACING

    self.btnLoad = ISButton:new(UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, "Load", self, self.onLoad)
    self.btnLoad:initialise()
    self.btnLoad:instantiate()
    self.btnLoad.borderColor = self.buttonBorderColor
    self:addChild(self.btnLoad)

    self.btnSave = ISButton:new(self.btnLoad:getRight() + UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, "Save", self, self.onSave)
    self.btnSave:initialise()
    self.btnSave:instantiate()
    self.btnSave.borderColor = self.buttonBorderColor
    self:addChild(self.btnSave)

    self.btnInvoke = ISButton:new(self.btnSave:getRight() + UI_BORDER_SPACING, yOff, 60, BUTTON_HGT, "Invoke", self, self.onInvoke)
    self.btnInvoke:initialise()
    self.btnInvoke:instantiate()
    self.btnInvoke.borderColor = self.buttonBorderColor
    self:addChild(self.btnInvoke)

    yOff = self.btnLoad:getBottom() + UI_BORDER_SPACING

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

    self.propertiesPanel.prerender = function(panel)
        ISPanel.prerender(panel)
        panel:setStencilRect(0, 0, panel.width, panel.height)
    end
    self.propertiesPanel.render = function(panel)
        ISPanel.render(panel)
        panel:clearStencilRect()
    end

    self.propertiesPanel.onMouseWheel = function(_self, del)
        if _self:getScrollHeight() > 0 then
            _self:setYScroll(_self:getYScroll() - (del * 40))
            return true
        end
        return false
    end

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

    local baseName, index = string.match(item.text, "^([a-zA-Z]+)_(%d+)$")
    baseName = baseName or item.text

    self:drawText(baseName, UI_BORDER_SPACING, textY, 1, 1, 1, 0.9, self.font)

    if index then
        local indexText = "#" .. index
        self:drawTextRight(indexText, self:getWidth() - UI_BORDER_SPACING, textY, 0.5, 0.5, 0.5, 0.6, self.font)
    end

    return y + self.itemheight
end

function InjectorConstructorUI:buildPropertiesUI(effectKey)
    self.propertiesPanel:clearChildren()

    self.propertiesPanel:addScrollBars()
    self.propertiesPanel:setScrollChildren(true)
    if self.propertiesPanel.vscroll then
        self.propertiesPanel.vscroll.doSetStencil = true
    end

    self.dynamicInputs = {}
    if not effectKey or not self.currentInjectorData.Effects[effectKey] then return end

    local effectData = self.currentInjectorData.Effects[effectKey]

    local baseEffect, index = string.match(effectKey, "^([a-zA-Z]+)_(%d+)$")
    baseEffect = baseEffect or effectKey

    local schemaFields = EFFECT_SCHEMA[baseEffect]
    if not schemaFields then return end

    local innerY = UI_BORDER_SPACING
    local labelWidth = 100
    local inputWidth = 120
    local scrollBarWid = 16

    local uiMeta = EFFECT_UI[baseEffect]

    local titleLabel = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_MEDIUM, baseEffect, 1, 1, 1, 1, UIFont.Medium, true)
    titleLabel:initialise()
    self.propertiesPanel:addChild(titleLabel)

    if index then
        local cornerX = self.propertiesPanel:getWidth() - UI_BORDER_SPACING - scrollBarWid
        local indexLabel = ISLabel:new(cornerX, innerY, FONT_HGT_MEDIUM, "#" .. index, 0.5, 0.5, 0.5, 0.6, UIFont.Medium, false)
        indexLabel:initialise()
        self.propertiesPanel:addChild(indexLabel)
    end

    innerY = innerY + FONT_HGT_MEDIUM + UI_BORDER_SPACING

    if uiMeta and uiMeta.notes then
        local notesLabel = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_SMALL, uiMeta.notes, 0.55, 0.55, 0.55, 1, UIFont.Small, true)
        notesLabel:initialise()
        self.propertiesPanel:addChild(notesLabel)
        innerY = innerY + FONT_HGT_SMALL + UI_BORDER_SPACING * 2
    end

    if uiMeta and uiMeta.groups then
        for groupName, fields in pairs(uiMeta.groups) do

            local groupLabel = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_SMALL, groupName, 0.6, 0.9, 0.6, 1, UIFont.Small, true)
            groupLabel:initialise()
            self.propertiesPanel:addChild(groupLabel)
            innerY = innerY + FONT_HGT_SMALL + UI_BORDER_SPACING

            for _, fieldDef in ipairs(fields) do
                local fieldName = fieldDef
                local fieldNotes = nil

                if type(fieldDef) == "table" then
                    fieldName = fieldDef.value
                    fieldNotes = fieldDef.notes
                end

                if fieldNotes then
                    local noteLabel = ISLabel:new(UI_BORDER_SPACING, innerY - 1, FONT_HGT_SMALL - 2, fieldNotes, 0.55, 0.55, 0.55, 1, UIFont.Small, true)
                    noteLabel:initialise()
                    self.propertiesPanel:addChild(noteLabel)
                    innerY = innerY + FONT_HGT_SMALL - 2 + UI_BORDER_SPACING * 0.3
                end

                local label = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_SMALL, fieldName, 1, 1, 1, 1, UIFont.Small, true)
                label:initialise()
                self.propertiesPanel:addChild(label)

                local input = ISTextEntryBox:new(tostring(effectData[fieldName] or "0"), UI_BORDER_SPACING + labelWidth, innerY - 2, inputWidth, BUTTON_HGT)
                input:initialise()
                input:instantiate()
                self.propertiesPanel:addChild(input)

                self.dynamicInputs[fieldName] = input

                innerY = innerY + BUTTON_HGT + UI_BORDER_SPACING
            end

            innerY = innerY + UI_BORDER_SPACING
        end
    else
        for _, fieldName in ipairs(schemaFields) do

            local label = ISLabel:new(UI_BORDER_SPACING, innerY, FONT_HGT_SMALL, fieldName, 1, 1, 1, 1, UIFont.Small, true)
            label:initialise()
            self.propertiesPanel:addChild(label)

            local input = ISTextEntryBox:new(tostring(effectData[fieldName] or "0"), UI_BORDER_SPACING + labelWidth, innerY - 2, inputWidth, BUTTON_HGT)
            input:initialise()
            input:instantiate()
            self.propertiesPanel:addChild(input)

            self.dynamicInputs[fieldName] = input

            innerY = innerY + BUTTON_HGT + UI_BORDER_SPACING
        end
    end

    self.propertiesPanel:setScrollHeight(innerY + UI_BORDER_SPACING)
end

function InjectorConstructorUI:onAddEffect()
    local baseEffect = self.effectTypeCombo:getOptionText(self.effectTypeCombo.selected)

    local index = 1
    while self.currentInjectorData.Effects[baseEffect .. "_" .. index] do
        index = index + 1
    end

    local newEffectKey = baseEffect .. "_" .. index

    local newEffectData = {}
    for _, fieldName in ipairs(EFFECT_SCHEMA[baseEffect]) do
        newEffectData[fieldName] = 0
    end

    self.currentInjectorData.Effects[newEffectKey] = newEffectData
    self:refreshEffectList()
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
    if not self.currentInjectorData.Effects then return end
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

    InjectorConstructorUI.instance = o

    return o
end

-- network load request
function InjectorConstructorUI:onLoad()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)

    self.effectList:clear()
    self.propertiesPanel:clearChildren()
    self.selectedEffectName = nil

    sendClientCommand(getPlayer(), "InjectorsModule", "LoadInjectorOptions", { id = selectedId })
end

-- network save request
function InjectorConstructorUI:onSave()
    self:saveCurrentPropertiesToTable()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)
    self.currentInjectorData.id = selectedId

    sendClientCommand(getPlayer(), "InjectorsModule", "SaveInjectorOptions", { id = selectedId, data = self.currentInjectorData })
end

-- network invoke request
function InjectorConstructorUI:onInvoke()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)

    if selectedId then
        sendClientCommand(getPlayer(), "InjectorsModule", "UseInjectorIgnoreSafety", { id = selectedId })
    end
end

function InjectorConstructorUI:close()
    InjectorConstructorUI.instance = nil
    ISCollapsableWindow.close(self)
end

-- server commands
local function OnServerCommand(module, command, args)
    if module ~= "InjectorsModule" then return end
    if command ~= "ReceiveInjectorOptions" then return end

    local ui = InjectorConstructorUI.instance
    if not ui then return end

    ui.currentInjectorData = args.data or {}
    ui.currentInjectorData.Effects = ui.currentInjectorData.Effects or {}
    ui:refreshEffectList()
end

Events.OnServerCommand.Add(OnServerCommand)
Events.OnServerCommand.Add(OnServerCommand)