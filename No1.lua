-- ============================================
-- ADVANCED AIMBOT FOR BLOX FRUITS
-- ============================================

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera

-- ============================================
-- CẤU HÌNH AIMBOT
-- ============================================

local AimConfig = {
    Enabled = false,
    Target = nil,
    AimKey = Enum.UserInputType.MouseButton2, -- Right Mouse Button
    Smoothness = 0.15, -- Độ mượt (0-1)
    FOV = 100, -- Field of View
    TeamCheck = true, -- Không aim đồng đội
    VisibleCheck = true, -- Kiểm tra tầm nhìn
    WallCheck = false, -- Xuyên tường
    Prediction = 0.14, -- Dự đoán chuyển động
    Priority = "Closest", -- Closest, LowestHP, HighestHP
    AutoFire = false, -- Tự động bắn
    AutoFireDelay = 0.1, -- Delay giữa các phát bắn
    Humanizer = true, -- Giống người hơn
    FOVCircle = true, -- Hiển thị vòng FOV
    SilentAim = false, -- Aim lén (không di chuột)
}

-- ============================================
-- BIẾN HỆ THỐNG
-- ============================================

local Connections = {}
local LastTarget = nil
local LastShot = 0
local FOVCircle = nil
local PredictedPosition = Vector3.new(0, 0, 0)

-- ============================================
-- HÀM TIỆN ÍCH
-- ============================================

function IsAlive(target)
    if not target then return false end
    if not target:FindFirstChild("Humanoid") then return false end
    if not target:FindFirstChild("HumanoidRootPart") then return false end
    return target.Humanoid.Health > 0
end

function IsVisible(target)
    if not AimConfig.VisibleCheck then return true end
    if not target or not target:FindFirstChild("HumanoidRootPart") then return false end
    
    local origin = Camera.CFrame.Position
    local targetPos = target.HumanoidRootPart.Position
    local direction = (targetPos - origin).Unit
    local distance = (targetPos - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Player.Character, target}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, direction * distance, raycastParams)
    
    return raycastResult == nil
end

function GetClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    local fov = AimConfig.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local character = player.Character
            
            if IsAlive(character) then
                -- Kiểm tra đồng đội
                if AimConfig.TeamCheck and player.Team == Player.Team then
                    continue
                end
                
                -- Kiểm tra tầm nhìn
                if AimConfig.VisibleCheck and not IsVisible(character) then
                    continue
                end
                
                -- Tính khoảng cách màn hình
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                        local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                        local distance = (mousePos - targetPos).Magnitude
                        
                        if distance <= fov and distance < closestDistance then
                            closestDistance = distance
                            closestTarget = character
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget
end

function GetPredictedPosition(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then
        return Vector3.new(0, 0, 0)
    end
    
    local rootPart = target.HumanoidRootPart
    local velocity = rootPart.Velocity or Vector3.new(0, 0, 0)
    
    -- Tính thời gian đạn bay
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    local travelTime = distance / 1000 -- Giả sử tốc độ đạn
    
    -- Dự đoán vị trí
    local predicted = rootPart.Position + (velocity * travelTime * AimConfig.Prediction)
    
    -- Thêm độ cao (head level)
    predicted = predicted + Vector3.new(0, 2, 0)
    
    return predicted
end

function SmoothAim(targetPosition)
    if not targetPosition then return end
    
    local currentCF = Camera.CFrame
    local targetCF = CFrame.new(Camera.CFrame.Position, targetPosition)
    
    -- Tính toán smooth
    local smooth = AimConfig.Smoothness
    if AimConfig.Humanizer then
        smooth = smooth + (math.random(-30, 30) / 1000) -- Thêm ngẫu nhiên
    end
    
    -- Interpolate
    local newCF = currentCF:Lerp(targetCF, smooth)
    
    -- Áp dụng cho camera (Silent Aim)
    if AimConfig.SilentAim then
        Camera.CFrame = newCF
    else
        -- Di chuột thật
        local delta = (targetPosition - currentCF.Position).Unit
        local xAngle = math.atan2(delta.Y, delta.X)
        local yAngle = math.atan2(delta.Z, delta.X)
        
        -- Thực hiện di chuột
        mousemoverel(xAngle * 10, yAngle * 10)
    end
end

-- ============================================
-- FOV CIRCLE VISUAL
-- ============================================

function CreateFOVCircle()
    if FOVCircle then FOVCircle:Destroy() end
    
    local circleGui = Instance.new("ScreenGui")
    circleGui.Name = "AimbotFOV"
    circleGui.Parent = CoreGui
    circleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    circleGui.ResetOnSpawn = false
    
    local circle = Instance.new("Frame")
    circle.Name = "FOVCircle"
    circle.Parent = circleGui
    circle.Size = UDim2.new(0, AimConfig.FOV * 2, 0, AimConfig.FOV * 2)
    circle.Position = UDim2.new(0.5, -AimConfig.FOV, 0.5, -AimConfig.FOV)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = circle
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = circle
    UIStroke.Color = Color3.fromRGB(255, 50, 50)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.7
    
    FOVCircle = circleGui
    
    return circleGui
end

function UpdateFOVCircle()
    if FOVCircle and FOVCircle:FindFirstChild("FOVCircle") then
        local circle = FOVCircle.FOVCircle
        circle.Size = UDim2.new(0, AimConfig.FOV * 2, 0, AimConfig.FOV * 2)
        circle.Position = UDim2.new(0.5, -AimConfig.FOV, 0.5, -AimConfig.FOV)
        
        -- Đổi màu khi có target
        if AimConfig.Target then
            circle.UIStroke.Color = Color3.fromRGB(50, 255, 50)
        else
            circle.UIStroke.Color = Color3.fromRGB(255, 50, 50)
        end
    end
end

-- ============================================
-- AIMBOT MAIN LOOP
-- ============================================

local AimLoop = RunService.RenderStepped:Connect(function(deltaTime)
    if not AimConfig.Enabled then return end
    
    -- Tìm target
    local target = GetClosestTarget()
    AimConfig.Target = target
    
    -- Cập nhật FOV Circle
    if AimConfig.FOVCircle then
        if not FOVCircle then
            CreateFOVCircle()
        end
        UpdateFOVCircle()
    elseif FOVCircle then
        FOVCircle:Destroy()
        FOVCircle = nil
    end
    
    -- Nếu có target và đang giữ aim key
    if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        -- Dự đoán vị trí
        PredictedPosition = GetPredictedPosition(target)
        
        -- Thực hiện aim
        SmoothAim(PredictedPosition)
        
        -- Auto fire
        if AimConfig.AutoFire and tick() - LastShot > AimConfig.AutoFireDelay then
            local args = {
                [1] = "Click",
                [2] = PredictedPosition
            }
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
            LastShot = tick()
        end
        
        LastTarget = target
    else
        AimConfig.Target = nil
    end
end)

-- ============================================
-- HOTKEY SYSTEM
-- ============================================

local KeybindConnection
function SetupKeybinds()
    if KeybindConnection then KeybindConnection:Disconnect() end
    
    KeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Toggle aimbot (F6)
        if input.KeyCode == Enum.KeyCode.F6 then
            AimConfig.Enabled = not AimConfig.Enabled
            print("Aimbot:", AimConfig.Enabled and "ENABLED" : "DISABLED")
        end
        
        -- Toggle silent aim (F7)
        if input.KeyCode == Enum.KeyCode.F7 then
            AimConfig.SilentAim = not AimConfig.SilentAim
            print("Silent Aim:", AimConfig.SilentAim and "ON" : "OFF")
        end
        
        -- Toggle auto fire (F8)
        if input.KeyCode == Enum.KeyCode.F8 then
            AimConfig.AutoFire = not AimConfig.AutoFire
            print("Auto Fire:", AimConfig.AutoFire and "ON" : "OFF")
        end
        
        -- Toggle FOV circle (F9)
        if input.KeyCode == Enum.KeyCode.F9 then
            AimConfig.FOVCircle = not AimConfig.FOVCircle
            print("FOV Circle:", AimConfig.FOVCircle and "SHOW" : "HIDE")
        end
        
        -- Target lock (T)
        if input.KeyCode == Enum.KeyCode.T then
            local target = GetClosestTarget()
            if target then
                AimConfig.Target = target
                print("Target locked:", target.Name)
            end
        end
    end)
end

-- ============================================
-- UI CONTROL PANEL
-- ============================================

function CreateAimbotUI()
    local ui = Instance.new("ScreenGui")
    ui.Name = "AimbotUI"
    ui.Parent = CoreGui
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ui.ResetOnSpawn = false
    
    -- Main container
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = ui
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.02, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    main.BackgroundTransparency = 0.1
    main.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = main
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, -3)
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = main
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    title.BackgroundTransparency = 0
    title.Text = "🎯 ADVANCED AIMBOT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Content frame
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Parent = main
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    
    -- Toggles
    local yOffset = 10
    
    local function CreateToggle(name, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = name .. "Toggle"
        toggleFrame.Parent = content
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
        toggleFrame.BackgroundTransparency = 1
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Parent = toggleFrame
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = name
        toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        toggleLabel.TextSize = 14
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "Button"
        toggleButton.Parent = toggleFrame
        toggleButton.Size = UDim2.new(0, 50, 0, 25)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) : Color3.fromRGB(200, 50, 50)
        toggleButton.Text = default and "ON" : "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 12
        toggleButton.Font = Enum.Font.GothamBold
        toggleButton.BorderSizePixel = 0
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            local newState = not (toggleButton.Text == "ON")
            toggleButton.Text = newState and "ON" : "OFF"
            toggleButton.BackgroundColor3 = newState and Color3.fromRGB(50, 200, 50) : Color3.fromRGB(200, 50, 50)
            callback(newState)
        end)
        
        yOffset = yOffset + 35
        return toggleFrame
    end
    
    -- Slider function
    local function CreateSlider(name, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = name .. "Slider"
        sliderFrame.Parent = content
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.Position = UDim2.new(0, 0, 0, yOffset)
        sliderFrame.BackgroundTransparency = 1
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Parent = sliderFrame
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = name .. ": " .. default
        sliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        sliderLabel.TextSize = 14
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Name = "Bar"
        sliderBar.Parent = sliderFrame
        sliderBar.Size = UDim2.new(1, 0, 0, 6)
        sliderBar.Position = UDim2.new(0, 0, 0, 25)
        sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        sliderBar.BorderSizePixel = 0
        
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 3)
        barCorner.Parent = sliderBar
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Parent = sliderBar
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        sliderFill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Name = "Button"
        sliderButton.Parent = sliderBar
        sliderButton.Size = UDim2.new(0, 16, 0, 16)
        sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderButton.Text = ""
        sliderButton.BorderSizePixel = 0
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = sliderButton
        
        local dragging = false
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderBar.MouseButton1Down:Connect(function(x, y)
            local relativeX = x - sliderBar.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percentage
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
            sliderLabel.Text = name .. ": " .. string.format("%.2f", value)
            callback(value)
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local relativeX = mousePos.X - sliderBar.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * percentage
                
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
                sliderLabel.Text = name .. ": " .. string.format("%.2f", value)
                callback(value)
            end
        end)
        
        yOffset = yOffset + 60
        return sliderFrame
    end
    
    -- Create toggles
    CreateToggle("Enable Aimbot", AimConfig.Enabled, function(value)
        AimConfig.Enabled = value
    end)
    
    CreateToggle("Silent Aim", AimConfig.SilentAim, function(value)
        AimConfig.SilentAim = value
    end)
    
    CreateToggle("Auto Fire", AimConfig.AutoFire, function(value)
        AimConfig.AutoFire = value
    end)
    
    CreateToggle("FOV Circle", AimConfig.FOVCircle, function(value)
        AimConfig.FOVCircle = value
    end)
    
    CreateToggle("Team Check", AimConfig.TeamCheck, function(value)
        AimConfig.TeamCheck = value
    end)
    
    CreateToggle("Visible Check", AimConfig.VisibleCheck, function(value)
        AimConfig.VisibleCheck = value
    end)
    
    CreateToggle("Humanizer", AimConfig.Humanizer, function(value)
        AimConfig.Humanizer = value
    end)
    
    -- Create sliders
    CreateSlider("Smoothness", 0.01, 1, AimConfig.Smoothness, function(value)
        AimConfig.Smoothness = value
    end)
    
    CreateSlider("FOV Size", 10, 500, AimConfig.FOV, function(value)
        AimConfig.FOV = value
    end)
    
    CreateSlider("Prediction", 0, 0.5, AimConfig.Prediction, function(value)
        AimConfig.Prediction = value
    end)
    
    CreateSlider("Auto Fire Delay", 0.05, 1, AimConfig.AutoFireDelay, function(value)
        AimConfig.AutoFireDelay = value
    end)
    
    content.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = main
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)
    
    -- Drag functionality
    local dragging = false
    local dragStart, frameStart
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = main.Position
        end
    end)
    
    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X,
                                     frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
        end
    end)
    
    return ui
end

-- ============================================
-- INITIALIZATION
-- ============================================

SetupKeybinds()

print([[
========================================
🎯 ADVANCED AIMBOT LOADED
========================================
Hotkeys:
F6 - Toggle Aimbot
F7 - Toggle Silent Aim  
F8 - Toggle Auto Fire
F9 - Toggle FOV Circle
T - Lock Target
========================================
]])

-- Tạo UI
task.wait(1)
CreateAimbotUI()

-- Cleanup
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == Player then
        AimLoop:Disconnect()
        if KeybindConnection then KeybindConnection:Disconnect() end
        if FOVCircle then FOVCircle:Destroy() end
    end
end)