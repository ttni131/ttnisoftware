-- --- ULTIMATE PRO HUB V10.0 (FINAL) ---
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = { Aimbot = false, ESP = false, Mevlana = false, Fly = false }
local CorrectKey = "TTNİSOFTWAREKJS"

-- [KEY SİSTEMİ]
local function showLogin()
    local Screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Frame = Instance.new("Frame", Screen); Frame.Size = UDim2.new(0, 250, 0, 120); Frame.Position = UDim2.new(0.5, -125, 0.5, -60); Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Frame)
    local Box = Instance.new("TextBox", Frame); Box.Size = UDim2.new(0.9, 0, 0, 40); Box.Position = UDim2.new(0.05, 0, 0.1, 0); Box.PlaceholderText = "Key Gir..."
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0.9, 0, 0, 40); Btn.Position = UDim2.new(0.05, 0, 0.55, 0); Btn.Text = "GİRİŞ YAP"; Btn.BackgroundColor3 = Color3.fromRGB(60,60,60); Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function() if Box.Text == CorrectKey then Screen:Destroy(); loadHub() end end)
end

-- [ANA HUB]
function loadHub()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local MainFrame = Instance.new("Frame", ScreenGui); MainFrame.Size = UDim2.new(0, 220, 0, 350); MainFrame.Position = UDim2.new(0.5, -110, 0.5, -175); MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MainFrame.Active = true; MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame)

    local isVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.K then
            isVisible = not isVisible
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = isVisible and UDim2.new(0, 220, 0, 350) or UDim2.new(0, 0, 0, 0)}):Play()
        end
    end)

    local function addButton(text, action)
        local btn = Instance.new("TextButton", MainFrame); btn.Size = UDim2.new(0.9, 0, 0, 40); btn.Position = UDim2.new(0.05, 0, 0, 45 + (#MainFrame:GetChildren() * 45)); btn.Text = text; btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(function() action(btn) end)
    end

    addButton("Aimbot: OFF", function(btn) Settings.Aimbot = not Settings.Aimbot; btn.Text = "Aimbot: " .. (Settings.Aimbot and "ON" or "OFF") end)
    addButton("ESP: OFF", function(btn) Settings.ESP = not Settings.ESP; btn.Text = "ESP: " .. (Settings.ESP and "ON" or "OFF") end)
    addButton("Mevlana: OFF", function(btn) Settings.Mevlana = not Settings.Mevlana; btn.Text = "Mevlana: " .. (Settings.Mevlana and "ON" or "OFF") end)
    addButton("Fly: OFF", function(btn) 
        Settings.Fly = not Settings.Fly
        if Settings.Fly then
            local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
        elseif LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyVel") then LocalPlayer.Character.HumanoidRootPart.FlyVel:Destroy() end
        btn.Text = "Fly: " .. (Settings.Fly and "ON" or "OFF") 
    end)

    -- [DÖNGÜLER]
    RunService.Heartbeat:Connect(function()
        -- AIMBOT (WallCheck + Smooth + Sadece Oyuncu)
        if Settings.Aimbot then
            local closest, dist = nil, 200
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if vis and mag < dist then
                        local params = RaycastParams.new(); params.FilterDescendantsInstances = {LocalPlayer.Character}; params.FilterType = Enum.RaycastFilterType.Exclude
                        local ray = workspace:Raycast(Camera.CFrame.Position, (p.Character.Head.Position - Camera.CFrame.Position).Unit * 500, params)
                        if ray and ray.Instance:IsDescendantOf(p.Character) then closest = p.Character.Head; dist = mag end
                    end
                end
            end
            if closest then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), 0.15) end
        end

        -- MEVLANA
        if Settings.Mevlana and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end

        -- FLY
        if Settings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
            LocalPlayer.Character.HumanoidRootPart.FlyVel.Velocity = move * 50
        end

        -- ESP (Optimize: Sadece Oyuncular)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.Enabled = (Settings.ESP and p.Character.Humanoid.Health > 0)
            end
        end
    end)
end

showLogin()
