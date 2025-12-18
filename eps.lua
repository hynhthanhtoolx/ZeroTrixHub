--====================================================
-- PLAYER ESP FIXED (BLOX FRUITS)
--====================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

--==============================
-- SERVICES
--==============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--==============================
-- CONFIG
--==============================
getgenv().ESP_Config = {
    Enabled = true,
    MaxDistance = 5000
}

--==============================
-- ESP STORAGE
--==============================
local ESPs = {}

--==============================
-- GET LEVEL (FIX)
--==============================
local function GetLevel(player)
    local ls = player:FindFirstChild("leaderstats")
    if ls and ls:FindFirstChild("Level") then
        return ls.Level.Value
    end
    return "?"
end

--==============================
-- CREATE ESP
--==============================
local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPs[player] then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP"
    bb.Size = UDim2.new(0, 220, 0, 50)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3, 0)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = false
    txt.TextSize = 14
    txt.Font = Enum.Font.SourceSansBold
    txt.TextColor3 = Color3.fromRGB(255, 80, 80)
    txt.TextStrokeTransparency = 0

    txt.Parent = bb
    ESPs[player] = bb
end

--==============================
-- REMOVE ESP
--==============================
local function RemoveESP(player)
    if ESPs[player] then
        ESPs[player]:Destroy()
        ESPs[player] = nil
    end
end

--==============================
-- UPDATE ESP
--==============================
RunService.RenderStepped:Connect(function()
    if not getgenv().ESP_Config.Enabled then return end

    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
        and player.Character
        and player.Character:FindFirstChild("HumanoidRootPart") then

            local hrp = player.Character.HumanoidRootPart
            local distance = math.floor(
                (hrp.Position - myHRP.Position).Magnitude
            )

            if distance <= getgenv().ESP_Config.MaxDistance then
                if not ESPs[player] then
                    CreateESP(player)
                    ESPs[player].Parent = hrp
                end

                local level = GetLevel(player)
                ESPs[player].TextLabel.Text =
                    player.Name .. " | Lv." .. level .. " | " .. distance .. "m"
                ESPs[player].Enabled = true
            else
                if ESPs[player] then
                    ESPs[player].Enabled = false
                end
            end
        else
            RemoveESP(player)
        end
    end
end)

--==============================
-- CLEANUP
--==============================
Players.PlayerRemoving:Connect(RemoveESP)

warn("✅ ESP PLAYER FIXED – ĐÃ HOẠT ĐỘNG")
