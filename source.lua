--[[ 
    🌑 HADES SOFTWARE v1.0 - OFFICIAL 2026
    Developer Valeriuss111ss
    Brand Cerberus Premium
    Features Aimbot, ESP, TP, Bring, Fly, RGB UI, Loader-Ready
]]

local Players = gameGetService(Players)
local RunService = gameGetService(RunService)
local UserInputService = gameGetService(UserInputService)
local CoreGui = gameGetService(CoreGui)
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- AYARLAR (Hades Central Config) ---
_G.HadesSettings = {
    Aimbot = false,
    SilentAim = false,
    FOV_Circle = false,
    FOV_Radius = 100,
    ESP_Enemy = false,
    Fly = false,
    FlySpeed = 50,
    TargetPlayer = nil
}

-- --- TEKNİK SİSTEMLER ---

-- Fly (Uçuş) Motoru
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local speed = 0

local function HadesFly()
    local bg = Instance.new(BodyGyro, LocalPlayer.Character.HumanoidRootPart)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
    local bv = Instance.new(BodyVelocity, LocalPlayer.Character.HumanoidRootPart)
    bv.velocity = Vector3.new(0,0.1,0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        repeat task.wait()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = _G.HadesSettings.FlySpeed
            else
                speed = 0
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((Camera.CFrame.lookVector  (ctrl.f + ctrl.b)) + ((Camera.CFrame  CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b)  .2, 0).p) - Camera.CFrame.p))  speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            else
                bv.velocity = Vector3.new(0, 0.1, 0)
            end
            bg.cframe = Camera.CFrame
        until not _G.HadesSettings.Fly
        bgDestroy(); bvDestroy()
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end)
end

-- Takım Kontrolü
local function IsEnemy(p)
    if not p or p == LocalPlayer then return false end
    if LocalPlayer.Team and p.Team then return p.Team ~= LocalPlayer.Team end
    return true
end

-- En Yakın Düşman
local function GetClosestEnemy()
    local target, dist = nil, _G.HadesSettings.FOV_Radius
    for _, v in pairs(PlayersGetPlayers()) do
        if IsEnemy(v) and v.Character and v.CharacterFindFirstChild(HumanoidRootPart) then
            local pos, vis = CameraWorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputServiceGetMouseLocation()).Magnitude
                if mag  dist then dist = mag; target = v end
            end
        end
    end
    return target
end

-- --- UI TASARIMI (CERBERUS EDITION) ---
if CoreGuiFindFirstChild(HadesV2) then CoreGui.HadesV2Destroy() end
local Master = Instance.new(ScreenGui, CoreGui); Master.Name = HadesV2

local Main = Instance.new(Frame, Master)
Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new(UICorner, Main).CornerRadius = UDim.new(0, 10)

-- RGB Kenarlık
local Stroke = Instance.new(UIStroke, Main); Stroke.Thickness = 2.5
task.spawn(function() while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5  5, 0.7, 1) end end)

-- Yan Menü & Logo
local Side = Instance.new(Frame, Main); Side.Size = UDim2.new(0, 140, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Instance.new(UICorner, Side)

local Logo = Instance.new(ImageLabel, Side) -- Buraya Cerberus gelecek
Logo.Size = UDim2.new(0, 100, 0, 100); Logo.Position = UDim2.new(0.5, -50, 0, 10); Logo.BackgroundTransparency = 1
Logo.Image = rbxassetid13508139595 -- Cerberus ID

local Tabs = Instance.new(Frame, Side); Tabs.Size = UDim2.new(1, 0, 1, -120); Tabs.Position = UDim2.new(0,0,0,120); Tabs.BackgroundTransparency = 1
Instance.new(UIListLayout, Tabs).HorizontalAlignment = Enum.HorizontalAlignment.Center; Tabs.UIListLayout.Padding = UDim.new(0,5)

local Pages = Instance.new(Frame, Main); Pages.Size = UDim2.new(1, -160, 1, -60); Pages.Position = UDim2.new(0, 150, 0, 50); Pages.BackgroundTransparency = 1

local function CreatePage(n)
    local p = Instance.new(ScrollingFrame, Pages); p.Name = n; p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new(UIListLayout, p).Padding = UDim.new(0, 10); return p
end

local CombatP = CreatePage(Combat); local VisualP = CreatePage(Visuals); local PlayerP = CreatePage(Players); CombatP.Visible = true

-- --- FOV Çemberi ---
local FOVCircle = Drawing.new(Circle); FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(220, 50, 50); FOVCircle.Transparency = 0.8; FOVCircle.Filled = false

-- --- ANA DÖNGÜ (Hades Core) ---
RunService.RenderSteppedConnect(function()
    FOVCircle.Visible = _G.HadesSettings.FOV_Circle
    FOVCircle.Radius = _G.HadesSettings.FOV_Radius
    FOVCircle.Position = UserInputServiceGetMouseLocation()

    local enemy = GetClosestEnemy()
    if _G.HadesSettings.Aimbot and enemy and UserInputServiceIsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy.Character.Head.Position)
    end

    for _, p in pairs(PlayersGetPlayers()) do
        if p.Character then
            local h = p.CharacterFindFirstChild(HadesESP)
            if _G.HadesSettings.ESP_Enemy and IsEnemy(p) then
                if not h then h = Instance.new(Highlight, p.Character); h.Name = HadesESP end
                h.FillColor = Color3.fromRGB(200, 0, 0); h.OutlineColor = Color3.new(1,1,1)
            elseif h then hDestroy() end
        end
    end
end)

-- --- UI ARAÇLARI ---
local function AddTab(n, pg)
    local t = Instance.new(TextButton, Tabs); t.Size = UDim2.new(0, 120, 0, 35); t.Text = n; t.BackgroundColor3 = Color3.fromRGB(20,20,20); t.TextColor3 = Color3.new(1,1,1); t.Font = Gotham
    Instance.new(UICorner, t); t.MouseButton1ClickConnect(function() for _,p in pairs(PagesGetChildren()) do p.Visible = false end pg.Visible = true end)
end

local function AddToggle(pg, txt, key, callback)
    local b = Instance.new(TextButton, pg); b.Size = UDim2.new(1,-10,0,40); b.Text = txt ..  [OFF]; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1)
    Instance.new(UICorner, b)
    b.MouseButton1ClickConnect(function()
        _G.HadesSettings[key] = not _G.HadesSettings[key]
        b.Text = txt .. (_G.HadesSettings[key] and  [ON] or  [OFF])
        b.BackgroundColor3 = _G.HadesSettings[key] and Color3.fromRGB(150,0,0) or Color3.fromRGB(25,25,25)
        if callback then callback(_G.HadesSettings[key]) end
    end)
end

-- Menü Elemanları
AddTab(Savaş, CombatP); AddTab(Görsel, VisualP); AddTab(Oyuncular, PlayerP)
AddToggle(CombatP, Aimbot, Aimbot)
AddToggle(CombatP, FOV Çemberi, FOV_Circle)
AddToggle(VisualP, Cerberus ESP, ESP_Enemy)
AddToggle(PlayerP, Hades Flight (Uçuş), Fly, function(state) if state then HadesFly() end end)

-- Işınlanma Butonları (Senin Önceki Kodun)
local PlayerLabel = Instance.new(TextLabel, PlayerP); PlayerLabel.Text = Seçili Yok; PlayerLabel.Size = UDim2.new(1,-10,0,30); PlayerLabel.TextColor3 = Color3.new(1,1,1); PlayerLabel.BackgroundTransparency = 1
local ActionRow = Instance.new(Frame, PlayerP); ActionRow.Size = UDim2.new(1,0,0,40); ActionRow.BackgroundTransparency = 1
Instance.new(UIListLayout, ActionRow).FillDirection = Enum.FillDirection.Horizontal; ActionRow.UIListLayout.Padding = UDim.new(0,10)

local function CreateAction(txt, func)
    local b = Instance.new(TextButton, ActionRow); b.Size = UDim2.new(0.45, 0, 1, 0); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(200, 50, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new(UICorner, b); b.MouseButton1ClickConnect(func)
end

CreateAction(Işınlan, function() if _G.HadesSettings.TargetPlayer then LocalPlayer.Character.HumanoidRootPart.CFrame = _G.HadesSettings.TargetPlayer.Character.HumanoidRootPart.CFrame end end)
CreateAction(Yanına Çek, function() if _G.HadesSettings.TargetPlayer then _G.HadesSettings.TargetPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end end)

-- Oyuncu Listesi
local function UpdateList()
    for _,v in pairs(PlayerPGetChildren()) do if vIsA(TextButton) and v.Text ~= Işınlan then vDestroy() end end
    for _, p in pairs(PlayersGetPlayers()) do if p ~= LocalPlayer then 
        local b = Instance.new(TextButton, PlayerP); b.Size = UDim2.new(1,-10,0,35); b.Text = p.Name; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); Instance.new(UICorner, b)
        b.MouseButton1ClickConnect(function() _G.HadesSettings.TargetPlayer = p; PlayerLabel.Text = Seçili  .. p.Name end)
    end end
end
UpdateList(); Players.PlayerAddedConnect(UpdateList); Players.PlayerRemovingConnect(UpdateList)

-- Kontroller
UserInputService.InputBeganConnect(function(i,p) 
    if not p then 
        if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end
        if i.KeyCode == Enum.KeyCode.W then ctrl.f = 1 elseif i.KeyCode == Enum.KeyCode.S then ctrl.b = -1 elseif i.KeyCode == Enum.KeyCode.A then ctrl.l = -1 elseif i.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
    end 
end)
UserInputService.InputEndedConnect(function(i) if i.KeyCode == Enum.KeyCode.W then ctrl.f = 0 elseif i.KeyCode == Enum.KeyCode.S then ctrl.b = 0 elseif i.KeyCode == Enum.KeyCode.A then ctrl.l = 0 elseif i.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end end)

print(Hades Software v1.0 Loaded. Press RightShift to Open.)
