--[[ 
    🌑 HADES SOFTWARE v1.0 - OFFICIAL 2026 REBORN
    Developer: Valeriuss111ss
    Brand: Cerberus Premium
    
    KONTROLLER:
    - Menü Aç/Kapat: RightShift veya Insert
    - Uçuş (Fly): 'E' Tuşu (Açıksa)
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

-- --- TEKNİK SİSTEMLER (FLY & AIM) ---
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local speed = 0

local function HadesFly()
    local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
    local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        repeat task.wait()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then speed = _G.HadesSettings.FlySpeed else speed = 0 end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((Camera.CFrame.lookVector * (ctrl.f + ctrl.b)) + ((Camera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - Camera.CFrame.p)) * speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            else
                bv.velocity = Vector3.new(0, 0.1, 0)
            end
            bg.cframe = Camera.CFrame
        until not _G.HadesSettings.Fly
        bg:Destroy(); bv:Destroy()
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end)
end

local function IsEnemy(p)
    if not p or p == LocalPlayer then return false end
    if LocalPlayer.Team and p.Team then return p.Team ~= LocalPlayer.Team end
    return true
end

local function GetClosestEnemy()
    local target, dist = nil, _G.HadesSettings.FOV_Radius
    for _, v in pairs(Players:GetPlayers()) do
        if IsEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end

-- --- UI TASARIMI (CERBERUS EDITION) ---
if CoreGui:FindFirstChild("HadesV2") then CoreGui.HadesV2:Destroy() end
local Master = Instance.new("ScreenGui", CoreGui); Master.Name = "HadesV2"

local Main = Instance.new("Frame", Master)
Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- RGB Kenarlık
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 3
task.spawn(function() while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.7, 1) end end)

-- Yan Menü
local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 150, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Side)

local Logo = Instance.new("ImageLabel", Side)
Logo.Size = UDim2.new(0, 100, 0, 100); Logo.Position = UDim2.new(0.5, -50, 0, 15); Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13508139595" -- Cerberus ID

local Tabs = Instance.new("Frame", Side); Tabs.Size = UDim2.new(1, 0, 1, -140); Tabs.Position = UDim2.new(0,0,0,130); Tabs.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", Tabs); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0,8)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -170, 1, -70); Pages.Position = UDim2.new(0, 160, 0, 60); Pages.BackgroundTransparency = 1

local function CreatePage(n)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = n; p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 12); return p
end

local CombatP = CreatePage("Combat"); local VisualP = CreatePage("Visuals"); local PlayerP = CreatePage("Players"); CombatP.Visible = true

-- --- FOV Çemberi ---
local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 2; FOVCircle.Color = Color3.fromRGB(255, 0, 0); FOVCircle.Transparency = 1; FOVCircle.Filled = false

-- --- DÖNGÜ ---
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.HadesSettings.FOV_Circle
    FOVCircle.Radius = _G.HadesSettings.FOV_Radius
    FOVCircle.Position = UserInputService:GetMouseLocation()

    if _G.HadesSettings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local enemy = GetClosestEnemy()
        if enemy then Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy.Character.Head.Position) end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("HadesESP")
            if _G.HadesSettings.ESP_Enemy and IsEnemy(p) then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "HadesESP" end
                h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.new(1,1,1)
            elseif h then h:Destroy() end
        end
    end
end)

-- --- UI BUTONLARI ---
local function AddTab(n, pg)
    local t = Instance.new("TextButton", Tabs); t.Size = UDim2.new(0, 130, 0, 35); t.Text = n; t.BackgroundColor3 = Color3.fromRGB(25,25,25); t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"
    Instance.new("UICorner", t); t.MouseButton1Click:Connect(function() for _,p in pairs(Pages:GetChildren()) do p.Visible = false end pg.Visible = true end)
end

local function AddToggle(pg, txt, key, callback)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(1,-20,0,45); b.Text = txt .. " [KAPALI]"; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(0.7,0.7,0.7); b.Font = "Gotham"
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.HadesSettings[key] = not _G.HadesSettings[key]
        b.Text = txt .. (_G.HadesSettings[key] and " [AÇIK]" or " [KAPALI]")
        b.BackgroundColor3 = _G.HadesSettings[key] and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30,30,30)
        b.TextColor3 = _G.HadesSettings[key] and Color3.new(1,1,1) or Color3.new(0.7,0.7,0.7)
        if callback then callback(_G.HadesSettings[key]) end
    end)
end

AddTab("Savaş", CombatP); AddTab("Görsel", VisualP); AddTab("Oyuncular", PlayerP)
AddToggle(CombatP, "Aimbot (Sağ Tık)", "Aimbot")
AddToggle(CombatP, "FOV Çemberi", "FOV_Circle")
AddToggle(VisualP, "Cerberus ESP", "ESP_Enemy")
AddToggle(PlayerP, "Hades Uçuş (E)", "Fly", function(s) if s then HadesFly() end end)

-- Menü Aç/Kapat
UserInputService.InputBegan:Connect(function(i, p)
    if not p then
        if i.KeyCode == Enum.KeyCode.RightShift or i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end
        if i.KeyCode == Enum.KeyCode.W then ctrl.f = 1 elseif i.KeyCode == Enum.KeyCode.S then ctrl.b = -1 elseif i.KeyCode == Enum.KeyCode.A then ctrl.l = -1 elseif i.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.KeyCode == Enum.KeyCode.W then ctrl.f = 0 elseif i.KeyCode == Enum.KeyCode.S then ctrl.b = 0 elseif i.KeyCode == Enum.KeyCode.A then ctrl.l = 0 elseif i.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end end)

Main.Visible = true -- Yüklendiğinde direkt açılır
print("Hades Software v1.0 Loaded. Press RightShift to Toggle.")
