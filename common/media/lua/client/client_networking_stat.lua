local function triggerStatEffect()
    local args = { duration = 10, healAmount = 5 }
    print("sending client command")
    sendClientCommand("InjectorsModule", "ChangeHunger", args)
end

local function onStatButtonClick(button)
    triggerStatEffect()
end

local function createHealButton()
    local button = ISButton:new(100, 100, 120, 30, "Send", nil, onStatButtonClick)
    button:initialise()
    button:instantiate()
    button.borderColor = { r=1, g=1, b=1, a=0.8 }

    local ui = getPlayerScreenLeft(0)
    getCore():getScreenWidth()

    button:addToUIManager()
end

Events.OnGameStart.Add(createHealButton)