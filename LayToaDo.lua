local player = game.Players.LocalPlayer

-- ======================
-- UI
-- ======================
local gui = Instance.new("ScreenGui")
gui.Name = "GetPositionUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220, 120)
frame.Position = UDim2.fromScale(0.5, 0.88)
frame.AnchorPoint = Vector2.new(0.5,1)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "LẤY TỌA ĐỘ"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)

local info = Instance.new("TextLabel", frame)
info.Position = UDim2.fromOffset(0,30)
info.Size = UDim2.new(1,0,0,25)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Text = "Chưa lấy tọa độ"

local getBtn = Instance.new("TextButton", frame)
getBtn.Position = UDim2.fromOffset(10,60)
getBtn.Size = UDim2.fromOffset(200,25)
getBtn.Text = "📍 LẤY TỌA ĐỘ"
getBtn.Font = Enum.Font.GothamBold
getBtn.TextSize = 13
getBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
getBtn.TextColor3 = Color3.fromRGB(0,255,120)
Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,8)

local copyBtn = Instance.new("TextButton", frame)
copyBtn.Position = UDim2.fromOffset(10,90)
copyBtn.Size = UDim2.fromOffset(200,25)
copyBtn.Text = "📋 COPY TỌA ĐỘ"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 13
copyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
copyBtn.TextColor3 = Color3.fromRGB(255,255,0)
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,8)

-- ======================
-- LOGIC
-- ======================
local lastCFrameText = ""

getBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = hrp.Position
        lastCFrameText = string.format(
            "CFrame.new(%.2f, %.2f, %.2f)",
            p.X, p.Y, p.Z
        )

        info.Text = string.format(
            "X: %.1f | Y: %.1f | Z: %.1f",
            p.X, p.Y, p.Z
        )

        warn("CFrame:", hrp.CFrame)
        warn("X:", p.X, "Y:", p.Y, "Z:", p.Z)
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if lastCFrameText ~= "" then
        if setclipboard then
            setclipboard(lastCFrameText)
            info.Text = "✅ Đã copy CFrame"
        else
            info.Text = "❌ Executor không hỗ trợ copy"
        end
    else
        info.Text = "⚠️ Chưa lấy tọa độ"
    end
end)