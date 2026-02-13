--[[ 
    🌑 HADES SOFTWARE v2.0 - OFFICIAL 2026
    Developer: Valeriuss111ss
    Features: Aimbot (RMB), Box ESP, Noclip Fly, Player List TP/Bring
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
    ESP_Box = false,
    Fly = false,
    FlySpeed = 50,
    Target = nil
}

-- --- FUNCTIONS ---

-- ✈️ NOCLIP FLY (Duvar Geçen Uçuş)
local function ToggleFly()
    task.spawn(function()
        local bg = Instance.new("BodyGyro", LocalPlayer.Character.HumanoidRootPart)
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = LocalPlayer.Character.HumanoidRootPart.CFrame
        bv.velocity = Vector3.new(0,0,0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        while _G.HadesSettings.Fly do
            RunService.RenderStepped:Wait()
            LocalPlayer.Character.Humanoid.PlatformStand = true
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            
            local direction = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
            
            bv.velocity = direction * _G.HadesSettings.FlySpeed
            bg.cframe = Camera.CFrame
        end
        bg:Destroy(); bv:Destroy()
        LocalPlayer.Character.Humanoid.PlatformStand = false
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end)
end

-- 👁️ BOX ESP
local function CreateESP(plr)
    local box = Drawing.new("Square")
    box.Visible = false; box.Color = Color3.new(1,0,0); box.Thickness = 1; box.Filled = false
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if _G.HadesSettings.ESP_Box and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = (Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)).Y - Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position - Vector3.new(0,4,0)).Y)
                box.Size = Vector2.new(size / 1.5, size)
                box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                box.Visible = true
            else box.Visible = false end
        else
            box.Visible = false
            if not plr.Parent then box:Destroy(); connection:Disconnect() end
        end
    end)
end
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(CreateESP)

-- 🔫 AIMBOT
RunService.RenderStepped:Connect(function()
    if _G.HadesSettings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = p end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

-- --- [ UI DESIGN ] ---
if CoreGui:FindFirstChild("HadesV2") then CoreGui.HadesV2:Destroy() end
local Master = Instance.new("ScreenGui", CoreGui); Master.Name = "HadesV2"

local Main = Instance.new("Frame", Master)
Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(12,12,12); Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main)
local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2
task.spawn(function() while task.wait() do Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end end)

local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 160, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(8,8,8); Instance.new("UICorner", Side)

-- 🖼️ LOGO ENTEGRASYONU (Sol Üst)
local Logo = Instance.new("ImageLabel", Side)
Logo.Size = UDim2.new(0, 100, 0, 100) -- Görseldeki gibi büyük ve net
Logo.Position = UDim2.new(0.5, -50, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://13508139595" -- Beyaz Cerberus Logosu

local Title = Instance.new("TextLabel", Side)
Title.Text = "HADES SOFTWARE"; Title.Position = UDim2.new(0,0,0,110); Title.Size = UDim2.new(1,0,0,30); Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1; Title.TextSize = 13

local Signature = Instance.new("TextLabel", Main)
Signature.Text = "by: Valeriuss111ss"; Signature.Position = UDim2.new(1,-160,1,-25); Signature.Size = UDim2.new(0,150,0,20); Signature.TextColor3 = Color3.new(0.7,0.7,0.7); Signature.BackgroundTransparency = 1; Signature.Font = "GothamMedium"; Signature.TextXAlignment = "Right"

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1,-180,1,-40); Pages.Position = UDim2.new(0,170,0,20); Pages.BackgroundTransparency = 1
local TabContainer = Instance.new("Frame", Side); TabContainer.Size = UDim2.new(1,0,1,-160); TabContainer.Position = UDim2.new(0,0,0,145); TabContainer.BackgroundTransparency = 1
Instance.new("UIListLayout", TabContainer).HorizontalAlignment = "Center"; TabContainer.UIListLayout.Padding = UDim.new(0,5)

local function CreatePage(n)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = n; p.Size = UDim2.new(1,0,1,0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0,10); return p
end

local CombatP = CreatePage("Combat"); local VisualP = CreatePage("Visuals"); local PlayerP = CreatePage("Players"); local ConfigP = CreatePage("Config")
CombatP.Visible = true

-- --- [ PLAYER LIST LOGIC ] ---
local function UpdatePlayerList()
    PlayerP:ClearAllChildren()
    local Layout = Instance.new("UIListLayout", PlayerP); Layout.Padding = UDim.new(0,5); Layout.HorizontalAlignment = "Center"
    
    local ActionContainer = Instance.new("Frame", PlayerP)
    ActionContainer.Size = UDim2.new(1,-20,0,85); ActionContainer.BackgroundTransparency = 1
    Instance.new("UIListLayout", ActionContainer).Padding = UDim.new(0,5)

    local tpBtn = Instance.new("TextButton", ActionContainer)
    tpBtn.Size = UDim2.new(1,0,0,40); tpBtn.Text = "Teleport to Selected"; tpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); tpBtn.TextColor3 = Color3.new(1,1,1); tpBtn.Font = "GothamBold"
    Instance.new("UICorner", tpBtn)
    tpBtn.MouseButton1Click:Connect(function()
        if _G.HadesSettings.Target and _G.HadesSettings.Target.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(_G.HadesSettings.Target.Character.HumanoidRootPart.CFrame)
        end
    end)

    local bringBtn = Instance.new("TextButton", ActionContainer)
    bringBtn.Size = UDim2.new(1,0,0,40); bringBtn.Text = "Bring Selected"; bringBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); bringBtn.TextColor3 = Color3.new(1,1,1); bringBtn.Font = "GothamBold"
    Instance.new("UICorner", bringBtn)
    bringBtn.MouseButton1Click:Connect(function()
        if _G.HadesSettings.Target and _G.HadesSettings.Target.Character then
            _G.HadesSettings.Target.Character:SetPrimaryPartCFrame(LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3))
        end
    end)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", PlayerP)
            pBtn.Size = UDim2.new(1,-20,0,30); pBtn.Text = p.DisplayName; pBtn.BackgroundColor3 = Color3.fromRGB(25,25,25); pBtn.TextColor3 = Color3.new(1,1,1); pBtn.Font = "Gotham"
            Instance.new("UICorner", pBtn)
            pBtn.MouseButton1Click:Connect(function()
                _G.HadesSettings.Target = p
                for _, btn in pairs(PlayerP:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(25,25,25) end end
                pBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
            end)
        end
    end
end
UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList); Players.PlayerRemoving:Connect(UpdatePlayerList)

-- --- [ UI COMPONENTS ] ---
local function AddTab(n, pg)
    local t = Instance.new("TextButton", TabContainer); t.Size = UDim2.new(0,140,0,35); t.Text = n; t.BackgroundColor3 = Color3.fromRGB(20,20,20); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"
    Instance.new("UICorner", t); t.MouseButton1Click:Connect(function() for _,p in pairs(Pages:GetChildren()) do p.Visible = false end pg.Visible = true end)
end

local function AddToggle(pg, txt, key, callback)
    local b = Instance.new("TextButton", pg); b.Size = UDim2.new(1,-20,0,40); b.Text = txt.." [OFF]"; b.BackgroundColor3 = Color3.fromRGB(25,25,25); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(function()
        _G.HadesSettings[key] = not _G.HadesSettings[key]
        b.Text = txt..(_G.HadesSettings[key] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = _G.HadesSettings[key] and Color3.fromRGB(150,0,0) or Color3.fromRGB(25,25,25)
        if callback then callback(_G.HadesSettings[key]) end
    end)
end

AddTab("Combat", CombatP); AddTab("Visuals", VisualP); AddTab("Players", PlayerP); AddTab("Config", ConfigP)
AddToggle(CombatP, "Aimbot (RightClick)", "Aimbot")
AddToggle(VisualP, "Box ESP", "ESP_Box")
AddToggle(ConfigP, "Flight Mode (WASD)", "Fly", function(v) if v then ToggleFly() end end)

UserInputService.InputBegan:Connect(function(i, g) if not g and (i.KeyCode == Enum.KeyCode.RightShift or i.KeyCode == Enum.KeyCode.Insert) then Main.Visible = not Main.Visible end end)

print("Hades Software v2.0 - Loaded by Valeriuss111ss")
