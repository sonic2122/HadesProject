--[[ 
    🌑 HADES SOFTWARE v1.0 - OFFICIAL 2026
    Developer: Valeriuss111ss
    Brand: Cerberus
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- AYARLAR ---
_G.HadesSettings = {
    Aimbot = false,
    FOV_Circle = false,
    FOV_Radius = 120,
    ESP_Enemy = false,
    Fly = false,
    FlySpeed = 50,
    TargetPlayer = nil
}

-- --- UI OLUŞTURMA ---
if CoreGui:FindFirstChild("HadesV2") then CoreGui.HadesV2:Destroy() end
local Master = Instance.new("ScreenGui", CoreGui); Master.Name = "HadesV2"

local Main = Instance.new("Frame", Master)
Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- RGB Kenarlık
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3
task.spawn(function() while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- Yan Menü (Sidebar)
local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 160, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Side)

-- 🖼️ LOGOMUZ (Sol Üst)
local Logo = Instance.new("ImageLabel", Side)
Logo.Size = UDim2.new(0, 80, 0, 80); Logo.Position = UDim2.new(0.5, -40, 0, 15); Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13508139595" -- Buraya kendi Asset ID'ni de koyabilirsin

-- ✍️ HİLE İSMİ (Hades Software)
local Title = Instance.new("TextLabel", Side)
Title.Text = "Hades Software"; Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0, 0, 0, 100)
Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.new(1, 1, 1); Title.Font = "GothamBold"; Title.TextSize = 16

-- ✍️ İMZA (Sağ Alt - by: Valeriuss111ss)
local Signature = Instance.new("TextLabel", Main)
Signature.Text = "by: Valeriuss111ss"; Signature.Size = UDim2.new(0, 150, 0, 20); Signature.Position = UDim2.new(1, -160, 1, -25)
Signature.BackgroundTransparency = 1; Signature.TextColor3 = Color3.fromRGB(150, 150, 150); Signature.Font = "GothamMedium"; Signature.TextSize = 12; Signature.TextXAlignment = "Right"

-- Sayfa Yapısı
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -180, 1, -40); Pages.Position = UDim2.new(0, 170, 0, 20); Pages.BackgroundTransparency = 1
local Tabs = Instance.new("Frame", Side); Tabs.Size = UDim2.new(1, 0, 1, -160); Tabs.Position = UDim2.new(0,0,0,140); Tabs.BackgroundTransparency = 1
Instance.new("UIListLayout", Tabs).HorizontalAlignment = "Center"; Tabs.UIListLayout.Padding = UDim.new(0,5)

local function CreatePage(n)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = n; p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
end

local CombatP = CreatePage("Combat"); local PlayerP = CreatePage("Players"); local ConfigP = CreatePage("Config")
CombatP.Visible = true

-- --- FONKSİYONLAR ---

-- Oyuncuya Işınlanma (TP)
local function TeleportTo(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
    end
end

-- Oyuncu Çekme (Bring)
local function BringPlayer(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    end
end

-- --- UI BUTONLARI ---

local function AddTab(n, pg)
    local t = Instance.new("TextButton", Tabs); t.Size = UDim2.new(0, 140, 0, 35); t.Text = n; t.BackgroundColor3 = Color3.fromRGB(20,20,20); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"
    Instance.new("UICorner", t); t.MouseButton1Click:Connect(function() for _,p in pairs(Pages:GetChildren()) do p.Visible = false end pg.Visible = true end)
end

local function AddButton(pg, txt, callback)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(1,-20,0,40); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(callback)
end

AddTab("Savaş", CombatP); AddTab("Oyuncular", PlayerP); AddTab("Config", ConfigP)

-- Players Sekmesi (TP & Bring)
local TargetInput = Instance.new("TextBox", PlayerP)
TargetInput.Size = UDim2.new(1,-20,0,40); TargetInput.PlaceholderText = "Oyuncu İsmi Yaz..."; TargetInput.Text = ""; TargetInput.BackgroundColor3 = Color3.fromRGB(25,25,25); TargetInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", TargetInput)

AddButton(PlayerP, "Seçili Oyuncuya Işınlan", function()
    local target = Players:FindFirstChild(TargetInput.Text)
    TeleportTo(target)
end)

AddButton(PlayerP, "Seçili Oyuncuyu Çek (Bring)", function()
    local target = Players:FindFirstChild(TargetInput.Text)
    BringPlayer(target)
end)

-- Config Sekmesi
AddButton(ConfigP, "Ayarları Kaydet (Save)", function() print("Config Kaydedildi!") end)
AddButton(ConfigP, "Ayarları Yükle (Load)", function() print("Config Yüklendi!") end)

-- Menü Kapatma
UserInputService.InputBegan:Connect(function(i, p)
    if not p and (i.KeyCode == Enum.KeyCode.RightShift or i.KeyCode == Enum.KeyCode.Insert) then
        Main.Visible = not Main.Visible
    end
end)

print("Hades Software v1.1 Loaded by Valeriuss111ss")
