-- ======================================
-- BUDDY SWORD AIM (ANTI MOVE / PREDICTION)
-- ======================================

repeat task.wait() until game:IsLoaded()

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= CONFIG =================
getgenv().BuddyAim = {
    Enabled = true,
    ToggleKey = Enum.KeyCode.Q,   -- bật / tắt aim
    FOV = 140,                   -- vùng lock
    MaxDistance = 400,           -- khoảng cách tối đa
    Smoothness = 0.15,           -- mượt (nhỏ = dính hơn)
    Prediction = 0.135,          -- ⭐ dự đoán di chuyển
    AimPart = "HumanoidRootPart" -- Head / HumanoidRootPart
}

-- ================= TOGGLE =================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == getgenv().BuddyAim.ToggleKey then
        getgenv().BuddyAim.Enabled = not getgenv().BuddyAim.Enabled
    end
end)

-- ================= CHECK BUDDY =================
local function HasBuddy()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("buddy") then
            return true
        end
    end
    return false
end

-- ================= GET TARGET =================
local function GetTarget()
    local bestTarget = nil
    local shortest = math.huge

    local camPos = Camera.CFrame.Position
    local screenCenter = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(getgenv().BuddyAim.AimPart)

            if hum and hum.Health > 0 and part then
                local dist = (part.Position - camPos).Magnitude
                if dist <= getgenv().BuddyAim.MaxDistance then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local fovDist =
                            (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                        if fovDist <= getgenv().BuddyAim.FOV and fovDist < shortest then
                            shortest = fovDist
                            bestTarget = part
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

-- ================= AIM LOOP =================
RunService.RenderStepped:Connect(function()
    if not getgenv().BuddyAim.Enabled then return end
    if not HasBuddy() then return end

    local target = GetTarget()
    if target then
        local camCF = Camera.CFrame
        local velocity = target.AssemblyLinearVelocity or Vector3.zero

        -- ⭐ dự đoán vị trí khi địch di chuyển
        local predictedPosition =
            target.Position + (velocity * getgenv().BuddyAim.Prediction)

        local aimCF = CFrame.new(camCF.Position, predictedPosition)
        Camera.CFrame = camCF:Lerp(aimCF, getgenv().BuddyAim.Smoothness)
    end
end)