print("=== Meik.win 起動 ===")

-- ============================================
-- Meik.win Script (Mobile / iPad 対応)
-- Tabs: Combat / ESP / Cheetah
-- ============================================

-- ============================
-- 1. サービス準備
-- ============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

print("=== サービス取得OK ===")

-- ============================
-- 2. 設定
-- ============================
local Settings = {
    -- Combat
    SilentAimEnabled = false,
    FOV = 120,
    HitChance = 100,
    HitPart = "Head",

    -- ESP
    ESPEnabled = true,
    ESPBox = true,
    ESPName = true,
    ESPDistance = true,
    ESPSkeleton = false,
    ESPLine = false,
    ESPColor = Color3.fromRGB(0, 255, 0),

    -- Cheetah
    SpeedEnabled = false,
    SpeedValue = 50,
    JumpEnabled = false,
    JumpValue = 100,
}

print("=== 設定OK ===")

-- ============================
-- 3. UI 構築
-- ============================
local gui = Instance.new("ScreenGui")
gui.Name = "MeikWin"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("=== ScreenGui作成OK ===")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 380)
main.Position = UDim2.new(0, 20, 0, 80)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

print("=== メインフレームOK ===")

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Meik.win"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

print("=== タイトルバーOK ===")

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 32)
tabBar.Position = UDim2.new(0, 10, 0, 45)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabBar

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -95)
content.Position = UDim2.new(0, 10, 0, 85)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 6)
contentLayout.Parent = content

print("=== コンテンツエリアOK ===")

-- タブ管理
local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.Parent = tabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = page

    tabs[name] = { button = btn, page = page }

    btn.MouseButton1Click:Connect(function()
        for n, t in pairs(tabs) do
            t.page.Visible = false
            t.button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)

    return page
end

local combatTab = createTab("Combat")
local espTab = createTab("ESP")
local cheetahTab = createTab("Cheetah")

tabs["Combat"].page.Visible = true
tabs["Combat"].button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)

print("=== タブ作成OK ===")

-- ============================
-- 4. UI 部品
-- ============================
local function makeToggle(parent, text, getValue, setValue)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 36, 0, 18)
    indicator.Position = UDim2.new(1, -48, 0.5, -9)
    indicator.BackgroundColor3 = getValue() and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    indicator.Parent = btn

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = getValue()
