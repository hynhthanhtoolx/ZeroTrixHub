--====================================================
-- PLAYER ESP (NAME + DISTANCE + LEVEL)
--====================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

--==============================
-- SERVICES
--==============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

--==============================
-- CONFIG
--==============================
getgenv().ESP_Config = getgenv().ESP_Config or {
    Enabled = true,
    ShowDistance = true,
    ShowLevel = true,
    MaxDistance = 5000 -- studs
}

-- LƯU ESP
local ESPObjects = {}

--==============================
-- TẠO ESP
--==============================
local function CreateESP(player)
    if player == LocalPlayer then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextStrokeTransparency = 0

    label.Parent = billboard

    ESPObjects[player] = billboard
end

--==============================
-- XÓA ESP
--==============================
local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

--==============================
-- UPDATE ESP
--==============================
RunService.RenderStepped:Connect(function()
    if not getgenv().ESP_Config.Enabled then return end

    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
        and player.Character
        and player.Character:FindFirstChild("HumanoidRootPart") then

            if not ESPObjects[player] then
                CreateESP(player)
                ESPObjects[player].Parent =
                    player.Character.HumanoidRootPart
            end

            local hrp = player.Character.HumanoidRootPart
            local myHrp = LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

            if myHrp then
                local distance =
                    math.floor((hrp.Position - myHrp.Position).Magnitude)

                if distance <= getgenv().ESP_Config.MaxDistance then
                    local text = player.Name

                    if getgenv().ESP_Config.ShowLevel then
                        local level = player:FindFirstChild("Data")
                            and player.Data:FindFirstChild("Level")
                        if level then
                            text = text .. " | Lv." .. level.Value
                        end
                    end

                    if getgenv().ESP_Config.ShowDistance then
                        text = text .. " | " .. distance .. "m"
                    end

                    ESPObjects[player].TextLabel.Text = text
                    ESPObjects[player].Enabled = true
                else
                    ESPObjects[player].Enabled = false
                end
            end
        else
            RemoveESP(player)
        end
    end
end)

--==============================
-- PLAYER JOIN / LEAVE
--==============================
Players.PlayerRemoving:Connect(RemoveESP)

warn("✅ PLAYER ESP LOADED")