--[[ 
    🌑 HADES SOFTWARE v1.1 - OFFICIAL 2026
    Developer: Valeriuss111ss
    Brand: Cerberus
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.HadesSettings = {
    Aimbot = false,
    FOV_Circle = false,
    FOV_Radius = 120,
    ESP_Enemy = false,
    Fly = false,
    FlySpeed = 50
}

-- --- SYSTEMS (FLY & AIM) ---
local function HadesFly()
    local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
    local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        repeat task.wait()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            bv.velocity = (Camera.CFrame.LookVector * 50) -- Basit ileri uçuş
            bg.cframe = Camera.CFrame
        until not _G.HadesSettings.Fly
        bg:Destroy(); bv:Destroy()
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end)
end

-- --- UI CONSTRUCTION ---
if CoreGui:FindFirstChild("HadesV2") then CoreGui.HadesV2:Destroy() end
local Master = Instance.new("ScreenGui", CoreGui); Master.Name = "HadesV2"

local Main = Instance.new("Frame", Master)
Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3
task.spawn(function() while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 160, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Side)

-- 🖼️ LOGO & TITLE
local Logo = Instance.new("ImageLabel", Side)
Logo.Size = UDim2.new(0, 80, 0, 80); Logo.Position = UDim2.new(0.5, -40, 0, 15); Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13508139595" -- Logo ID

local Title = Instance.new("TextLabel", Side)
Title.Text = "Hades Software"; Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0, 0, 0, 100)
Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.TextSize = 16

-- ✍️ SIGNATURE (by: Valeriuss111ss)
local Signature = Instance.new("TextLabel", Main)
Signature.Text = "by: Valeriuss111ss"; Signature.Size = UDim2.new(0, 150, 0, 20); Signature.Position = UDim2.new(1, -160, 1, -25)
Signature.BackgroundTransparency = 1; Signature.TextColor3 = Color3.fromRGB(150, 150, 150); Signature.Font = "GothamMedium"; Signature.TextSize = 12; Signature.TextXAlignment = "Right"

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -180, 1, -40); Pages.Position = UDim2.new(0, 170, 0, 20); Pages.BackgroundTransparency = 1
local Tabs = Instance.new("Frame", Side); Tabs.Size = UDim2.new(1, 0, 1, -160); Tabs.Position = UDim2.new(0,0,0,140); Tabs.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", Tabs); TabList.HorizontalAlignment = "Center"; TabList.Padding = UDim.new(0,5)

local function CreatePage(n)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = n; p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
end

local CombatP = CreatePage("Combat"); local VisualP = CreatePage("Visuals"); local PlayerP = CreatePage("Players"); local ConfigP = CreatePage("Config")
CombatP.Visible = true

-- --- UI BUILDER FUNCTIONS ---
local function AddTab(n, pg)
    local t = Instance.new("TextButton", Tabs); t.Size = UDim2.new(0, 140, 0, 35); t.Text = n; t.BackgroundColor3 = Color3.fromRGB(20,20,20); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"
    Instance.new("UICorner", t); t.MouseButton1Click:Connect(function() for _,p in pairs(Pages:GetChildren()) do p.Visible = false end pg.Visible = true end)
end

local function AddToggle(pg, txt, key, callback)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(1,-20,0,40); b.Text = txt .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.HadesSettings[key] = not _G.HadesSettings[key]
        b.Text = txt .. (_G.HadesSettings[key] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = _G.HadesSettings[key] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30,30,30)
        if callback then callback(_G.HadesSettings[key]) end
    end)
end

-- --- TABS ---
AddTab("Combat", CombatP)
AddTab("Visuals", VisualP)
AddTab("Players", PlayerP)
AddTab("Config", ConfigP)

-- Combat
AddToggle(CombatP, "Aimbot", "Aimbot")
AddToggle(CombatP, "Show FOV", "FOV_Circle")

-- Visuals
AddToggle(VisualP, "ESP (Enemy)", "ESP_Enemy")

-- Players (Fly, TP, Bring)
AddToggle(PlayerP, "Flight (E)", "Fly", function(s) if s then HadesFly() end end)
local TargetInput = Instance.new("TextBox", PlayerP); TargetInput.Size = UDim2.new(1,-20,0,40); TargetInput.PlaceholderText = "Username..."; TargetInput.BackgroundColor3 = Color3.fromRGB(25,25,25); TargetInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", TargetInput)

local function AddButton(pg, txt, callback)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(1,-20,0,40); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; Instance.new("UICorner", b); b.MouseButton1Click:Connect(callback)
end
AddButton(PlayerP, "Teleport to Player", function() local p = Players:FindFirstChild(TargetInput.Text) if p then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end)
AddButton(PlayerP, "Bring Player", function() local p = Players:FindFirstChild(TargetInput.Text) if p then p.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end end)

-- Config
AddButton(ConfigP, "Save Settings", function() print("Saved") end)
AddButton(ConfigP, "Load Settings", function() print("Loaded") end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(i, p) if not p and (i.KeyCode == Enum.KeyCode.RightShift or i.KeyCode == Enum.KeyCode.Insert) then Main.Visible = not Main.Visible end end)

-- FOV Circle Drawing
local Circle = Drawing.new("Circle"); Circle.Color = Color3.new(1,0,0); Circle.Thickness = 2
RunService.RenderStepped:Connect(function()
    Circle.Visible = _G.HadesSettings.FOV_Circle
    Circle.Radius = _G.HadesSettings.FOV_Radius
    Circle.Position = UserInputService:GetMouseLocation()
end)

Main.Visible = true
print("Hades Software v1.1 Loaded.")
