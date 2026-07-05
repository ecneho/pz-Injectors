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

local BODY_PARTS = {
    "Head",
    "Neck",
    "Torso_Upper",
    "Torso_Lower",
    "UpperArm_L",
    "UpperArm_R",
    "ForeArm_L",
    "ForeArm_R",
    "Hand_L",
    "Hand_R",
    "Groin",
    "UpperLeg_L",
    "UpperLeg_R",
    "LowerLeg_L",
    "LowerLeg_R",
    "Foot_L",
    "Foot_R",
}

local BODY_PART_GROUPS = {
    { value = "Head",         notes = getText("UI_Injectors_Note_Head") },
    { value = "Neck",         notes = getText("UI_Injectors_Note_Neck") },

    { value = "Torso_Upper",  notes = getText("UI_Injectors_Note_TorsoUpper") },
    { value = "Torso_Lower",  notes = getText("UI_Injectors_Note_TorsoLower") },

    { value = "UpperArm_L",   notes = getText("UI_Injectors_Note_LeftUpperArm") },
    { value = "UpperArm_R",   notes = getText("UI_Injectors_Note_RightUpperArm") },

    { value = "ForeArm_L",    notes = getText("UI_Injectors_Note_LeftForeArm") },
    { value = "ForeArm_R",    notes = getText("UI_Injectors_Note_RightForeArm") },

    { value = "Hand_L",       notes = getText("UI_Injectors_Note_LeftHand") },
    { value = "Hand_R",       notes = getText("UI_Injectors_Note_RightHand") },

    { value = "Groin",        notes = getText("UI_Injectors_Note_Groin") },

    { value = "UpperLeg_L",   notes = getText("UI_Injectors_Note_LeftUpperLeg") },
    { value = "UpperLeg_R",   notes = getText("UI_Injectors_Note_RightUpperLeg") },

    { value = "LowerLeg_L",   notes = getText("UI_Injectors_Note_LeftLowerLeg") },
    { value = "LowerLeg_R",   notes = getText("UI_Injectors_Note_RightLowerLeg") },

    { value = "Foot_L",       notes = getText("UI_Injectors_Note_LeftFoot") },
    { value = "Foot_R",       notes = getText("UI_Injectors_Note_RightFoot") },
}

-- effect schemas
local EFFECT_SCHEMA = {
    ChangeGeneralHealthEffect = { "duration", "delay", "rate", "base", "minRange", "maxRange", "minScale", "maxScale" },
    ChangeHungerEffect = { "duration", "delay", "rate", "amount" },
    ChangeThirstEffect = { "duration", "delay", "rate", "amount" },
    ChangeOverdoseEffect = { "duration", "delay", "rate", "base" },
    ChangePainEffect = { "duration", "delay", "rate", "base", "minRange", "maxRange", "minScale", "maxScale" },
    ChangeIntoxicationEffect = { "duration", "delay", "rate", "amount" },
    ChangeZombieInfectionEffect = { "duration", "delay", "rate", "amount" },
    ChangeFoodSicknessEffect = { "duration", "delay", "rate", "amount" },
    ChangeEnduranceEffect = { "duration", "delay", "rate", "amount" },
    ChangeTemperatureEffect = { "duration", "delay", "rate", "amount" },
    MendBleedingEffect = { "duration", "delay", "rate", "base", unpack(BODY_PARTS) },
    MendDeepWoundEffect = { "duration", "delay", "rate", "base", unpack(BODY_PARTS) }
}

local EFFECT_UI = {
    ChangeHungerEffect = {
        notes = getText("UI_Injectors_Notes_ChangeHunger"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_HungerAmount") }
            }
        }
    },

    ChangeThirstEffect = {
        notes = getText("UI_Injectors_Notes_ChangeThirst"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_ThirstAmount") }
            }
        }
    },

    ChangeOverdoseEffect = {
        notes = getText("UI_Injectors_Notes_ChangeOverdose"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "base", notes = getText("UI_Injectors_Note_OverdoseBase") }
            }
        }
    },

    ChangePainEffect = {
        notes = getText("UI_Injectors_Notes_ChangePain"),
        groups = {
            [getText("UI_Injectors_Group_Time")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_PainDuration") },
                { value = "delay", notes = getText("UI_Injectors_Note_PainDelay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "base", notes = getText("UI_Injectors_Note_PainBase") },
            },
            [getText("UI_Injectors_Group_Scaling")] = {
                { value = "minRange", notes = getText("UI_Injectors_Note_MinRange") },
                { value = "maxRange", notes = getText("UI_Injectors_Note_MaxRange") },
                { value = "minScale", notes = getText("UI_Injectors_Note_MinScale") },
                { value = "maxScale", notes = getText("UI_Injectors_Note_MaxScale") }
            }
        }
    },

    ChangeIntoxicationEffect = {
        notes = getText("UI_Injectors_Notes_ChangeIntoxication"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_IntoxicationAmount") }
            }
        }
    },

    ChangeZombieInfectionEffect = {
        notes = getText("UI_Injectors_Notes_ChangeZombieInfection"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_ZombieInfectionAmount") }
            }
        }
    },

    ChangeFoodSicknessEffect = {
        notes = getText("UI_Injectors_Notes_ChangeFoodSickness"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_FoodSicknessAmount") }
            }
        }
    },

    ChangeEnduranceEffect = {
        notes = getText("UI_Injectors_Notes_ChangeEndurance"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_EnduranceAmount") }
            }
        }
    },

    ChangeTemperatureEffect = {
        notes = getText("UI_Injectors_Notes_ChangeTemperature"),
        groups = {
            [getText("UI_Injectors_Group_Timing")] = {
                { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
                { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
                { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
            },
            [getText("UI_Injectors_Group_Values")] = {
                { value = "amount", notes = getText("UI_Injectors_Note_TemperatureAmount") }
            }
        }
    },
}

EFFECT_UI.MendBleedingEffect = {
    notes = getText("UI_Injectors_Notes_MendBleeding"),
    groups = {
        [getText("UI_Injectors_Group_Timing")] = {
            { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
            { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
            { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
        },
        [getText("UI_Injectors_Group_Values")] = {
            { value = "base", notes = getText("UI_Injectors_Note_MendBleedingBase") }
        },
        [getText("UI_Injectors_Group_BodyParts")] = BODY_PART_GROUPS
    }
}

EFFECT_UI.MendDeepWoundEffect = {
    notes = getText("UI_Injectors_Notes_MendDeepWound"),
    groups = {
        [getText("UI_Injectors_Group_Timing")] = {
            { value = "duration", notes = getText("UI_Injectors_Note_Duration") },
            { value = "delay", notes = getText("UI_Injectors_Note_Delay") },
            { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
        },
        [getText("UI_Injectors_Group_Values")] = {
            { value = "base", notes = getText("UI_Injectors_Note_MendDeepWoundBase") }
        },
        [getText("UI_Injectors_Group_BodyParts")] = BODY_PART_GROUPS
    }
}

EFFECT_UI.ChangeGeneralHealthEffect = {
    notes = getText("UI_Injectors_Notes_ChangeGeneralHealth"),
    groups = {
        [getText("UI_Injectors_Group_Time")] = {
            { value = "duration", notes = getText("UI_Injectors_Note_GeneralHealthDuration") },
            { value = "delay", notes = getText("UI_Injectors_Note_GeneralHealthDelay") },
            { value = "rate", notes = getText("UI_Injectors_Note_Rate") }
        },
        [getText("UI_Injectors_Group_Values")] = {
            { value = "base", notes = getText("UI_Injectors_Note_GeneralHealthBase") },
        },
        [getText("UI_Injectors_Group_Scaling")] = {
            { value = "minRange", notes = getText("UI_Injectors_Note_MinRange") },
            { value = "maxRange", notes = getText("UI_Injectors_Note_MaxRange") },
            { value = "minScale", notes = getText("UI_Injectors_Note_MinScale") },
            { value = "maxScale", notes = getText("UI_Injectors_Note_MaxScale") }
        }
    }
}

-- ui class
InjectorConstructorUI = ISCollapsableWindow:derive("InjectorConstructorUI")

function InjectorConstructorUI:initialise()
    ISCollapsableWindow.initialise(self)
    self.title = getText("UI_Injectors_Title")
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

    self.btnLoad = ISButton:new(UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, getText("UI_Injectors_BtnLoad"), self, self.onLoad)
    self.btnLoad:initialise()
    self.btnLoad:instantiate()

    self.btnLoad.borderColor = { r = self.buttonBorderColor.r, g = self.buttonBorderColor.g, b = self.buttonBorderColor.b, a = self.buttonBorderColor.a }
    self:addChild(self.btnLoad)

    self.btnSave = ISButton:new(self.btnLoad:getRight() + UI_BORDER_SPACING, yOff, 50, BUTTON_HGT, getText("UI_Injectors_BtnSave"), self, self.onSave)
    self.btnSave:initialise()
    self.btnSave:instantiate()
    self.btnSave.borderColor = { r = self.buttonBorderColor.r, g = self.buttonBorderColor.g, b = self.buttonBorderColor.b, a = self.buttonBorderColor.a }
    self:addChild(self.btnSave)

    self.btnSaveDefaultBG = { r = self.btnSave.backgroundColor.r, g = self.btnSave.backgroundColor.g, b = self.btnSave.backgroundColor.b, a = self.btnSave.backgroundColor.a }
    self.btnSaveDefaultBorder = { r = self.btnSave.borderColor.r, g = self.btnSave.borderColor.g, b = self.btnSave.borderColor.b, a = self.btnSave.borderColor.a }
    self.btnSaveDefaultHover = { r = self.btnSave.backgroundColorMouseOver.r, g = self.btnSave.backgroundColorMouseOver.g, b = self.btnSave.backgroundColorMouseOver.b, a = self.btnSave.backgroundColorMouseOver.a }

    self.btnInvoke = ISButton:new(self.btnSave:getRight() + UI_BORDER_SPACING, yOff, 60, BUTTON_HGT, getText("UI_Injectors_BtnInvoke"), self, self.onInvoke)
    self.btnInvoke:initialise()
    self.btnInvoke:instantiate()
    self.btnInvoke.borderColor = { r = self.buttonBorderColor.r, g = self.buttonBorderColor.g, b = self.buttonBorderColor.b, a = self.buttonBorderColor.a }
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

    self.btnAddEffect = ISButton:new(UI_BORDER_SPACING, actionBtnY, actionBtnWidth, BUTTON_HGT, getText("UI_Injectors_BtnAddEffect"), self, self.onAddEffect)
    self.btnAddEffect:initialise()
    self.btnAddEffect:instantiate()
    self.btnAddEffect:enableAcceptColor()
    self:addChild(self.btnAddEffect)

    self.btnRemoveEffect = ISButton:new(self.btnAddEffect:getRight() + UI_BORDER_SPACING, actionBtnY, actionBtnWidth, BUTTON_HGT, getText("UI_Injectors_BtnRemoveEffect"), self, self.onRemoveEffect)
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

function InjectorConstructorUI:setUnsavedChanges(hasChanges)
    if not self.btnSave then return end

    if hasChanges then
        self.btnSave.backgroundColor = { r = 0, g = 0.5, b = 0, a = 1 }
        self.btnSave.borderColor = { r = 0, g = 1, b = 0, a = 0.7 }
        self.btnSave.backgroundColorMouseOver = { r = 0, g = 1, b = 0, a = 0.5 }
    else
        self.btnSave.backgroundColor = {
            r = self.btnSaveDefaultBG.r,
            g = self.btnSaveDefaultBG.g,
            b = self.btnSaveDefaultBG.b,
            a = self.btnSaveDefaultBG.a
        }
        self.btnSave.borderColor = { 
            r = self.btnSaveDefaultBorder.r,
            g = self.btnSaveDefaultBorder.g,
            b = self.btnSaveDefaultBorder.b,
            a = self.btnSaveDefaultBorder.a
        }
        self.btnSave.backgroundColorMouseOver = {
            r = self.btnSaveDefaultHover.r,
            g = self.btnSaveDefaultHover.g,
            b = self.btnSaveDefaultHover.b,
            a = self.btnSaveDefaultHover.a
        }
    end
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

                input.onTextChange = function(box) self:setUnsavedChanges(true) end
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

            input.onTextChange = function(box) self:setUnsavedChanges(true) end

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

    if self.selectedEffectName then
        self:saveCurrentPropertiesToTable()
    end

    self.currentInjectorData.Effects[newEffectKey] = newEffectData
    self:refreshEffectList()

    self:setUnsavedChanges(true)

    for i, item in ipairs(self.effectList.items) do
        if item.text == newEffectKey then
            self.effectList.selected = i
            self:onSelectEffectInList()
            break
        end
    end
end

function InjectorConstructorUI:onRemoveEffect()
    if not self.selectedEffectName then return end

    local oldIndex = self.effectList.selected
    self.currentInjectorData.Effects[self.selectedEffectName] = nil
    self.selectedEffectName = nil
    self.propertiesPanel:clearChildren()
    self:refreshEffectList()

    self:setUnsavedChanges(true)

    if #self.effectList.items > 0 then
        self.effectList.selected = math.min(oldIndex, #self.effectList.items)
        self:onSelectEffectInList()
    end
end

function InjectorConstructorUI:onSelectEffectInList()
    local selectedItem = self.effectList.items[self.effectList.selected]
    if selectedItem then
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
    self:setUnsavedChanges(false)

    sendClientCommand(getPlayer(), "InjectorsModule", "LoadInjectorOptions", { id = selectedId })
end

-- network save request
function InjectorConstructorUI:onSave()
    self:saveCurrentPropertiesToTable()
    local selectedId = self.injectorCombo:getOptionText(self.injectorCombo.selected)
    self.currentInjectorData.id = selectedId

    sendClientCommand(getPlayer(), "InjectorsModule", "SaveInjectorOptions", { id = selectedId, data = self.currentInjectorData })
    self:setUnsavedChanges(false)
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
    ui:setUnsavedChanges(false)

    if #ui.effectList.items > 0 then
        ui.effectList.selected = 1
        ui:onSelectEffectInList()
    else
        ui.selectedEffectName = nil
        ui.propertiesPanel:clearChildren()
    end
end

Events.OnServerCommand.Add(OnServerCommand)