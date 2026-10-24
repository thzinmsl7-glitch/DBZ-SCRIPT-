-- language: Lua, target: Roblox Delta Executor
-- Smith DBZ Hub (GitHub Version - Corrigida)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if game:GetService("CoreGui"):FindFirstChild("SmithDBZ_Hub") then
    game:GetService("CoreGui").SmithDBZ_Hub:Destroy()
end

local CORE_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
CORE_GUI.Name = "SmithDBZ_Hub"
CORE_GUI.ResetOnSpawn = false

local Theme = {
    Background = Color3.fromRGB(12, 10, 18),
    Sidebar = Color3.fromRGB(20, 15, 30),
    Accent = Color3.fromRGB(150, 50, 255),
    Text = Color3.fromRGB(230, 230, 240),
    InactiveText = Color3.fromRGB(130, 130, 150),
    ToggleOff = Color3.fromRGB(40, 35, 50),
    ToggleOn = Color3.fromRGB(150, 50, 255),
    RedBtn = Color3.fromRGB(200, 50, 50),
    GoldBtn = Color3.fromRGB(255, 200, 0)
}

-- ==========================================
-- UI CONSTRUCTION
-- ==========================================
local MainFrame = Instance.new("Frame", CORE_GUI)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Accent

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SMITH // DBZ HUB (PRIVATE)"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() CORE_GUI:Destroy() end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Size = UDim2.new(1, -150, 1, -40)
PagesContainer.Position = UDim2.new(0, 150, 0, 40)
PagesContainer.BackgroundTransparency = 1

local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    MainFrame.Size = Minimized and UDim2.new(0, 550, 0, 40) or UDim2.new(0, 550, 0, 400)
    Sidebar.Visible = not Minimized
    PagesContainer.Visible = not Minimized
    MinBtn.Text = Minimized and "+" or "-"
end)

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
    page.Active = true
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    return page
end

local FarmPage = createPage("Farm Auto")
local TeleportPage = createPage("Teleport")
local VipPage = createPage("VIP Forms")
local ClientPage = createPage("Client")
local MiscPage = createPage("Misc")

local navDebounce = false
local function createNavBtn(text, yPos, pageToShow)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Theme.Background
    btn.Text = text
    btn.TextColor3 = Theme.InactiveText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        if navDebounce then return end
        navDebounce = true
        for _, p in ipairs(PagesContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Theme.InactiveText end
        end
        pageToShow.Visible = true
        btn.TextColor3 = Theme.Accent
        task.wait(0.1)
        navDebounce = false
    end)
    return btn
end

local navFarm = createNavBtn("Farm Auto", 60, FarmPage)
local navTele = createNavBtn("Teleport", 100, TeleportPage)
local navVip = createNavBtn("VIP Forms", 140, VipPage)
local navClient = createNavBtn("Client", 180, ClientPage)
local navMisc = createNavBtn("Misc", 220, MiscPage)

FarmPage.Visible = true
navFarm.TextColor3 = Theme.Accent

-- ==========================================
-- UI HELPERS
-- ==========================================
local function createHeader(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function createToggle(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Theme.Sidebar
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = Theme.ToggleOff
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local knob = Instance.new("Frame", btn)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = { Enabled = false }
    btn.MouseButton1Click:Connect(function()
        state.Enabled = not state.Enabled
        btn.BackgroundColor3 = state.Enabled and Theme.ToggleOn or Theme.ToggleOff
        knob.Position = state.Enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        if callback then callback(state.Enabled) end
    end)
    return state
end

-- ==========================================
-- ENGINE LOGIC (SEM LOOP BUG)
-- ==========================================
local autoFarmState = createToggle(FarmPage, "Farm Automático (Boss)", false, nil)
local autoChargeState = createToggle(FarmPage, "Auto-Charge de Ki", true, nil)
local autoTransformState = createToggle(FarmPage, "Auto-Transform", false, nil)
local autoRebirthState = createToggle(FarmPage, "Auto-Rebirth", false, nil)

local isTransforming = false
local currentBoss = nil

local function getPlayerData()
    local data = ReplicatedStorage:FindFirstChild("Datas")
    return data and data:FindFirstChild(tostring(LocalPlayer.UserId))
end

local function getLowestStat()
    local myData = getPlayerData()
    if not myData then return 0 end
    local stats = {"Strength", "Speed", "Defense", "Energy"}
    local lowest = math.huge
    for _, stat in ipairs(stats) do
        local s = myData:FindFirstChild(stat)
        if s and s.Value < lowest then lowest = s.Value end
    end
    return lowest
end

local function getRebirthPrice()
    local myData = getPlayerData()
    if not myData then return math.huge end
    local rebirths = myData:FindFirstChild("Rebirth")
    return rebirths and (rebirths.Value * 3e6 + 2e6) or 2e6
end

local function forceTransform()
    if isTransforming then return end
    local strength = getLowestStat()
    if strength < 34000 then return end
    
    local forms = {
        {"Beast",120e6}, {"SSJBUI",120e6}, {"LBSSJ4",100e6}, {"SSJB3",50e6},
        {"God of Creation",30e6}, {"Mastered Ultra Instinct",14e6}, {"Godly SSJ2",8e6},
        {"SSJ Blue",1.2e6}, {"SSJ3",95000}, {"SSJ2",34000}
    }
    local bestForm = nil
    for _, form in ipairs(forms) do
        if strength >= form[2] then bestForm = form[1]; break end
    end
    if not bestForm then return end
    
    pcall(function()
        local status = LocalPlayer:FindFirstChild("Status")
        local currentForm = status and status:FindFirstChild("Transformation") and status.Transformation.Value
        if currentForm and currentForm ~= bestForm then
            isTransforming = true
            local equipSkill = ReplicatedStorage.Package.Events:FindFirstChild("equipskill")
            local ta = ReplicatedStorage.Package.Events:FindFirstChild("ta")
            if equipSkill and ta then
                equipSkill:InvokeServer(bestForm)
                task.wait(0.1)
                ta:InvokeServer()
            end
            task.wait(1)
            isTransforming = false
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not autoFarmState.Enabled or not LocalPlayer.Character then return end
    
    if autoChargeState.Enabled then
        pcall(function()
            local stats = LocalPlayer.Character:FindFirstChild("Stats")
            if stats and stats:FindFirstChild("Ki") and stats.Ki.Value < stats.Ki.MaxValue / 3 then
                ReplicatedStorage.Package.Events.cha:InvokeServer("Blacknwhite27") 
            end
        end)
    end
    
    if autoTransformState.Enabled then forceTransform() end

    if autoRebirthState.Enabled then
        local myData = getPlayerData()
        if myData and getLowestStat() >= getRebirthPrice() then
            local rebirthEvent = ReplicatedStorage.Package.Events:FindFirstChild("rebirth")
            if rebirthEvent then
                pcall(function() rebirthEvent:InvokeServer() end)
                task.wait(2)
            end
        end
    end
    
    if not currentBoss or not currentBoss.Parent or not currentBoss:FindFirstChildOfClass("Humanoid") or currentBoss:FindFirstChildOfClass("Humanoid").Health <= 0 then
        currentBoss = nil
        pcall(function()
            local living = workspace:FindFirstChild("Living")
            if living then
                for _, mob in ipairs(living:GetChildren()) do
                    local hum = mob:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then currentBoss = mob; break end
                end
            end
        end)
    end
    
    if currentBoss then
        local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local bossRoot = currentBoss:FindFirstChild("HumanoidRootPart")
        if myRoot and bossRoot then
            myRoot.CFrame = bossRoot.CFrame * CFrame.new(0, 0, 4.5)
            pcall(function()
                local args = {
                    [1] = "Energy Volley",
                    [2] = {["MouseHit"] = CFrame.new(bossRoot.Position), ["FaceMouse"] = true},
                    [3] = "Blacknwhite27"
                }
                ReplicatedStorage.Package.Events.voleys:InvokeServer(unpack(args))
            end)
        end
    end
end)

-- ==========================================
-- PÁGINA: VIP FORMS
-- ==========================================
createHeader(VipPage, "Transformações VIP")
for _, form in ipairs({"SSJ", "SSJ2", "SSJ3", "SSJ Blue", "MUI", "Beast"}) do
    local btn = Instance.new("TextButton", VipPage)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Theme.GoldBtn
    btn.Text = "Ativar: " .. form
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            local equipSkill = ReplicatedStorage.Package.Events:FindFirstChild("equipskill")
            if equipSkill then equipSkill:InvokeServer(form) end
        end)
    end)
end

-- ==========================================
-- PÁGINAS: TELEPORT, CLIENT, MISC
-- ==========================================
createHeader(TeleportPage, "Planetas")
for _, isl in ipairs({"Earth", "Bills"}) do
    local btn = Instance.new("TextButton", TeleportPage)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Theme.Sidebar
    btn.Text = "Ir para " .. isl
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        pcall(function() ReplicatedStorage.Package.Events.TP:InvokeServer(isl) end)
    end)
end

local walkToggle = createToggle(ClientPage, "WalkSpeed", nil)
local jumpToggle = createToggle(ClientPage, "JumpPower", nil)
local nodlipToggle = createToggle(ClientPage, "NoClip", nil)
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if walkToggle.Enabled then hum.WalkSpeed = 100 else hum.WalkSpeed = 16 end
        if jumpToggle.Enabled then hum.JumpPower = 150; hum.UseJumpPower = true else hum.JumpPower = 50 end
    end
end)
RunService.Stepped:Connect(function()
    if nodlipToggle.Enabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

createHeader(MiscPage, "Otimização")
local fpsBtn = Instance.new("TextButton", MiscPage)
fpsBtn.Size = UDim2.new(1, 0, 0, 35)
fpsBtn.BackgroundColor3 = Theme.RedBtn
fpsBtn.Text = "Aplicar FPS Booster"
fpsBtn.TextColor3 = Theme.Text
fpsBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0, 6)
fpsBtn.MouseButton1Click:Connect(function()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") then v.Enabled = false end
    end
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled = false; v:Destroy() end
        if v:IsA("Decal") or v:IsA("Texture") then v:Transparency = 1 end
    end
    fpsBtn.Text = "FPS Otimizado!"
    fpsBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
end)
