local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("SeluwiaUI") then
    playerGui.SeluwiaUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SeluwiaUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local eventCount = 0
local entries = {}
local suppressingLog = false

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or Color3.fromRGB(40, 40, 56)
    s.Thickness = thickness or 1
    return s
end

local function corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, radius or 10)
    return c
end

local function getTime()
    return os.date("%H:%M:%S")
end

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 760, 0, 520)
panel.Position = UDim2.new(0.5, -380, 0.5, -260)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
panel.BorderSizePixel = 0
panel.Parent = screenGui
corner(panel, 16)
stroke(panel, Color3.fromRGB(30, 30, 42), 1)

local dragging, dragStart, startPos
local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end
local function onInputChanged(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end
local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
corner(titleBar, 16)
stroke(titleBar, Color3.fromRGB(22, 22, 31), 1)

local titleFill = Instance.new("Frame")
titleFill.Size = UDim2.new(1, 0, 0, 18)
titleFill.Position = UDim2.new(0, 0, 1, -18)
titleFill.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
titleFill.BorderSizePixel = 0
titleFill.ZIndex = titleBar.ZIndex + 1
titleFill.Parent = titleBar

titleBar.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)

local liveDot = Instance.new("Frame")
liveDot.Size = UDim2.new(0, 9, 0, 9)
liveDot.Position = UDim2.new(0, 20, 0.5, -4)
liveDot.BackgroundColor3 = Color3.fromRGB(61, 255, 160)
liveDot.BorderSizePixel = 0
liveDot.ZIndex = titleBar.ZIndex + 2
liveDot.Parent = titleBar
corner(liveDot, 999)

local liveLabel = Instance.new("TextLabel")
liveLabel.Size = UDim2.new(0, 50, 0, 20)
liveLabel.Position = UDim2.new(0, 34, 0.5, -10)
liveLabel.BackgroundTransparency = 1
liveLabel.Text = "LIVE"
liveLabel.TextColor3 = Color3.fromRGB(61, 255, 160)
liveLabel.TextSize = 11
liveLabel.Font = Enum.Font.GothamBold
liveLabel.TextXAlignment = Enum.TextXAlignment.Left
liveLabel.ZIndex = titleBar.ZIndex + 2
liveLabel.Parent = titleBar

task.spawn(function()
    while screenGui.Parent do
        TweenService:Create(liveDot, TweenInfo.new(1), {Size = UDim2.new(0,11,0,11), Position = UDim2.new(0,19,0.5,-5)}):Play()
        task.wait(1)
        TweenService:Create(liveDot, TweenInfo.new(1), {Size = UDim2.new(0,9,0,9), Position = UDim2.new(0,20,0.5,-4)}):Play()
        task.wait(1)
    end
end)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0.5, -100, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "SELUWIA"
titleText.TextColor3 = Color3.fromRGB(210, 210, 228)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.ZIndex = titleBar.ZIndex + 2
titleText.Parent = titleBar

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 76, 0, 30)
clearBtn.Position = UDim2.new(1, -92, 0.5, -15)
clearBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
clearBtn.Text = "✕ Clear"
clearBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
clearBtn.TextSize = 11
clearBtn.Font = Enum.Font.GothamBold
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = titleBar.ZIndex + 3
clearBtn.Parent = titleBar
corner(clearBtn, 8)
stroke(clearBtn, Color3.fromRGB(80, 28, 28), 1)

clearBtn.MouseEnter:Connect(function()
    clearBtn.BackgroundColor3 = Color3.fromRGB(28, 10, 10)
end)
clearBtn.MouseLeave:Connect(function()
    clearBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
end)

local logArea = Instance.new("ScrollingFrame")
logArea.Name = "LogArea"
logArea.Size = UDim2.new(1, -12, 1, -112)
logArea.Position = UDim2.new(0, 6, 0, 58)
logArea.BackgroundTransparency = 1
logArea.BorderSizePixel = 0
logArea.ScrollBarThickness = 3
logArea.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 90)
logArea.CanvasSize = UDim2.new(0, 0, 0, 0)
logArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
logArea.Parent = panel

local listLayout = Instance.new("UIListLayout", logArea)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 7)
listLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local logPad = Instance.new("UIPadding", logArea)
logPad.PaddingTop = UDim.new(0, 8)
logPad.PaddingBottom = UDim.new(0, 6)
logPad.PaddingLeft = UDim.new(0, 4)
logPad.PaddingRight = UDim.new(0, 4)

local function makeEmptyLabel()
    local el = Instance.new("TextLabel")
    el.Name = "EmptyState"
    el.Size = UDim2.new(1, 0, 0, 260)
    el.BackgroundTransparency = 1
    el.Text = "Waiting for events…\nAll marketplace events will appear here."
    el.TextColor3 = Color3.fromRGB(120, 120, 158)
    el.TextSize = 13
    el.Font = Enum.Font.Gotham
    el.TextWrapped = true
    el.LayoutOrder = 99999
    el.Parent = logArea
    return el
end
makeEmptyLabel()

local function setEmpty(show)
    local e = logArea:FindFirstChild("EmptyState")
    if show and not e then
        makeEmptyLabel()
    elseif not show and e then
        e:Destroy()
    end
end

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 50)
footer.Position = UDim2.new(0, 0, 1, -50)
footer.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
footer.BorderSizePixel = 0
footer.Parent = panel
corner(footer, 16)

local footerFill = Instance.new("Frame")
footerFill.Size = UDim2.new(1, 0, 0, 18)
footerFill.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
footerFill.BorderSizePixel = 0
footerFill.Parent = footer

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -40, 1, 0)
countLabel.Position = UDim2.new(0, 20, 0, 0)
countLabel.BackgroundTransparency = 1
countLabel.Text = "0 events captured"
countLabel.TextColor3 = Color3.fromRGB(160, 155, 200)
countLabel.TextSize = 12
countLabel.Font = Enum.Font.Gotham
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.ZIndex = footer.ZIndex + 1
countLabel.Parent = footer

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -6, 0, -6)
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 17
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10
closeBtn.Parent = panel
corner(closeBtn, 999)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local function addLog(label, id, signalType)
    if suppressingLog then return end
    setEmpty(false)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -2, 0, 46)
    entry.BackgroundColor3 = Color3.fromRGB(17, 17, 24)
    entry.BorderSizePixel = 0
    entry.LayoutOrder = -(eventCount)
    entry.Parent = logArea
    corner(entry, 10)
    stroke(entry, Color3.fromRGB(48, 46, 70), 1)

    entry.BackgroundTransparency = 1
    TweenService:Create(entry, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 14, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(61, 255, 160)
    dot.BorderSizePixel = 0
    dot.Parent = entry
    corner(dot, 999)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 76, 1, 0)
    lbl.Position = UDim2.new(0, 28, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(label)
    lbl.TextColor3 = Color3.fromRGB(160, 150, 210)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = entry

    local idEl = Instance.new("TextLabel")
    idEl.Size = UDim2.new(0, 200, 1, 0)
    idEl.Position = UDim2.new(0, 108, 0, 0)
    idEl.BackgroundTransparency = 1
    idEl.Text = tostring(id)
    idEl.TextColor3 = Color3.fromRGB(220, 220, 240)
    idEl.TextSize = 14
    idEl.Font = Enum.Font.GothamBold
    idEl.TextXAlignment = Enum.TextXAlignment.Left
    idEl.TextTruncate = Enum.TextTruncate.AtEnd
    idEl.Parent = entry

    local timeEl = Instance.new("TextLabel")
    timeEl.Size = UDim2.new(0, 70, 1, 0)
    timeEl.Position = UDim2.new(0, 320, 0, 0)
    timeEl.BackgroundTransparency = 1
    timeEl.Text = getTime()
    timeEl.TextColor3 = Color3.fromRGB(140, 135, 180)
    timeEl.TextSize = 11
    timeEl.Font = Enum.Font.Gotham
    timeEl.Parent = entry

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0, 200, 1, 0)
    buttonFrame.Position = UDim2.new(1, -200, 0, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = entry

    local autoBtn = Instance.new("TextButton")
    autoBtn.Size = UDim2.new(0, 56, 0, 28)
    autoBtn.Position = UDim2.new(0, 0, 0.5, -14)
    autoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    autoBtn.Text = "Auto"
    autoBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
    autoBtn.TextSize = 11
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.BorderSizePixel = 0
    autoBtn.Parent = buttonFrame
    corner(autoBtn, 7)
    stroke(autoBtn, Color3.fromRGB(55, 50, 85), 1)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 56, 0, 28)
    copyBtn.Position = UDim2.new(0, 62, 0.5, -14)
    copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
    copyBtn.TextSize = 11
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BorderSizePixel = 0
    copyBtn.Parent = buttonFrame
    corner(copyBtn, 7)
    stroke(copyBtn, Color3.fromRGB(55, 50, 85), 1)

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 52, 0, 28)
    runBtn.Position = UDim2.new(0, 124, 0.5, -14)
    runBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    runBtn.Text = "Run"
    runBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
    runBtn.TextSize = 11
    runBtn.Font = Enum.Font.GothamBold
    runBtn.BorderSizePixel = 0
    runBtn.Parent = buttonFrame
    corner(runBtn, 7)
    stroke(runBtn, Color3.fromRGB(55, 50, 85), 1)

    copyBtn.MouseEnter:Connect(function()
        copyBtn.TextColor3 = Color3.fromRGB(190, 180, 255)
        copyBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 40)
    end)
    copyBtn.MouseLeave:Connect(function()
        if copyBtn.Text ~= "Copied!" then
            copyBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
            copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        end
    end)
    copyBtn.MouseButton1Click:Connect(function()
        pcall(setclipboard, tostring(id))
        copyBtn.Text = "Copied!"
        copyBtn.TextColor3 = Color3.fromRGB(200, 190, 255)
        task.wait(1.5)
        copyBtn.Text = "Copy"
        copyBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
        copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    end)

    local autoActive = false
    local autoLoop = nil

    local function fireFakeSignal()
        suppressingLog = true
        if signalType == "Product" then
            pcall(function() MarketplaceService:SignalPromptProductPurchaseFinished(player.UserId, id, true) end)
        elseif signalType == "Gamepass" then
            pcall(function() MarketplaceService:SignalPromptGamePassPurchaseFinished(player, id, true) end)
        elseif signalType == "Bulk" then
            pcall(function() MarketplaceService:SignalPromptBulkPurchaseFinished(player.UserId, id, true) end)
        elseif signalType == "Purchase" then
            pcall(function() MarketplaceService:SignalPromptPurchaseFinished(player.UserId, id, true) end)
        end
        suppressingLog = false
    end

    local function startAuto()
        if autoActive then return end
        autoActive = true
        autoBtn.Text = "Auto ON"
        autoBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        autoBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
        autoLoop = task.spawn(function()
            while autoActive and autoBtn.Parent do
                fireFakeSignal()
                task.wait(0.01)
            end
        end)
    end

    local function stopAuto()
        autoActive = false
        if autoLoop then
            task.cancel(autoLoop)
            autoLoop = nil
        end
        if autoBtn.Parent then
            autoBtn.Text = "Auto"
            autoBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
            autoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        end
    end

    autoBtn.MouseButton1Click:Connect(function()
        if autoActive then stopAuto() else startAuto() end
    end)

    local holdStart = nil
    local holdConnection = nil
    local spamLoop = nil
    local isSpamming = false

    local function startSpam()
        if isSpamming then return end
        isSpamming = true
        runBtn.Text = "Spamming..."
        runBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        spamLoop = task.spawn(function()
            while isSpamming and runBtn.Parent do
                fireFakeSignal()
                task.wait(0.1)
            end
        end)
    end

    local function stopSpam()
        isSpamming = false
        if spamLoop then
            task.cancel(spamLoop)
            spamLoop = nil
        end
        if runBtn.Parent then
            runBtn.Text = "Run"
            runBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
            runBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        end
    end

    runBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            holdStart = tick()
            holdConnection = task.spawn(function()
                while holdStart and (tick() - holdStart) < 3 do
                    task.wait(0.1)
                end
                if holdStart and not isSpamming then
                    startSpam()
                end
            end)
        end
    end)

    runBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local heldDuration = holdStart and (tick() - holdStart) or 0
            holdStart = nil
            if holdConnection then
                task.cancel(holdConnection)
                holdConnection = nil
            end
            if isSpamming then
                stopSpam()
            elseif heldDuration < 3 then
                fireFakeSignal()
                runBtn.Text = "Sent!"
                runBtn.TextColor3 = Color3.fromRGB(61, 255, 160)
                task.wait(1.5)
                if runBtn.Parent then
                    runBtn.Text = "Run"
                    runBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
                end
            end
        end
    end)

    runBtn.MouseEnter:Connect(function()
        if not isSpamming then
            runBtn.TextColor3 = Color3.fromRGB(61, 255, 160)
            runBtn.BackgroundColor3 = Color3.fromRGB(10, 22, 18)
        end
    end)
    runBtn.MouseLeave:Connect(function()
        if not isSpamming and runBtn.Text == "Run" then
            runBtn.TextColor3 = Color3.fromRGB(170, 165, 220)
            runBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        end
    end)

    entry.AncestryChanged:Connect(function()
        if not entry.Parent then
            isSpamming = false
            autoActive = false
            if spamLoop then task.cancel(spamLoop) end
            if autoLoop then task.cancel(autoLoop) end
            if holdConnection then task.cancel(holdConnection) end
        end
    end)

    eventCount = eventCount + 1
    countLabel.Text = eventCount .. (eventCount == 1 and " event captured" or " events captured")
    table.insert(entries, entry)
end

clearBtn.MouseButton1Click:Connect(function()
    for _, e in ipairs(entries) do e:Destroy() end
    entries = {}
    eventCount = 0
    countLabel.Text = "0 events captured"
    setEmpty(true)
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(plr, id, bought)
    if not suppressingLog then addLog("Product", id, "Product") end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, id, bought)
    if not suppressingLog then addLog("Gamepass", id, "Gamepass") end
end)

MarketplaceService.PromptBulkPurchaseFinished:Connect(function(userId, id, bought)
    if not suppressingLog then addLog("Bulk", id, "Bulk") end
end)

MarketplaceService.PromptPurchaseFinished:Connect(function(userId, id, bought)
    if not suppressingLog then addLog("Purchase", id, "Purchase") end
end)
