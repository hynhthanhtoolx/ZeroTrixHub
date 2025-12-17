repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- ======================
-- SAVE DATA QUA SERVER
-- ======================
getgenv().KenSave = getgenv().KenSave or {
    FarmCFrame = CFrame.new(-613.25, 38.97, 2552.57),
    FarmEnabled = true -- ON / OFF FARM (LƯU QUA SERVER)
}

if queue_on_teleport then
    queue_on_teleport([[
        getgenv().KenSave = getgenv().KenSave or {}
    ]])
end

-- ======================
-- CONFIG
-- ======================
getgenv().FarmKen = {
    CheckDelay = 0.3,
    HopWhenKenBreak = true,
    HopDelay = 5,
    MaxPlayer = 6,
}

-- ======================
-- SERVICES
-- ======================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local PlaceId = game.PlaceId

-- ======================
-- UI
-- ======================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "KenFarmUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220, 150)
frame.Position = UDim2.fromScale(0.02, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "KEN FARM"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.fromOffset(0,30)
status.Size = UDim2.new(1,0,0,25)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamBold
status.TextSize = 15

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Position = UDim2.fromOffset(10,65)
toggleBtn.Size = UDim2.fromOffset(200,30)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)

local info = Instance.new("TextLabel", frame)
info.Position = UDim2.fromOffset(0,105)
info.Size = UDim2.new(1,0,0,25)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(150,150,150)
info.Text = "ON/OFF saved across servers"

-- ======================
-- UPDATE UI STATE
-- ======================
local function UpdateUI()
    if getgenv().KenSave.FarmEnabled then
        toggleBtn.Text = "FARM: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,90)
        status.Text = "STATUS: FARMING"
        status.TextColor3 = Color3.fromRGB(0,255,120)
    else
        toggleBtn.Text = "FARM: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
        status.Text = "STATUS: OFF"
        status.TextColor3 = Color3.fromRGB(255,80,80)
    end
end

UpdateUI()

-- ======================
-- TOGGLE BUTTON
-- ======================
toggleBtn.MouseButton1Click:Connect(function()
    getgenv().KenSave.FarmEnabled = not getgenv().KenSave.FarmEnabled
    UpdateUI()
end)

-- ======================
-- HOP SERVER
-- ======================
local lastHop = 0
local function HopServer()
    if os.clock() - lastHop < getgenv().FarmKen.HopDelay then return end
    lastHop = os.clock()

    status.Text = "STATUS: HOP SERVER"
    status.TextColor3 = Color3.fromRGB(255,170,0)

    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _, v in pairs(servers.data) do
        if v.id ~= game.JobId and v.playing <= getgenv().FarmKen.MaxPlayer then
            TeleportService:TeleportToPlaceInstance(PlaceId, v.id, player)
            break
        end
    end
end

-- ======================
-- FARM KEN LOOP
-- ======================
task.spawn(function()
    local lastHealth = 0

    while task.wait(getgenv().FarmKen.CheckDelay) do
        pcall(function()
            if not getgenv().KenSave.FarmEnabled then return end

            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            -- TELE ĐÚNG VỊ TRÍ FARM
            char:PivotTo(getgenv().KenSave.FarmCFrame)

            -- BẬT KEN
            if not char:FindFirstChild("ObservationHaki") then
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end

            hum:Move(Vector3.zero, true)

            if lastHealth == 0 then
                lastHealth = hum.Health
                return
            end

            -- KEN BỊ PHÁ → HOP
            if hum.Health < lastHealth then
                status.Text = "STATUS: KEN BREAK"
                status.TextColor3 = Color3.fromRGB(255,0,0)
                if getgenv().FarmKen.HopWhenKenBreak then
                    HopServer()
                end
            end

            lastHealth = hum.Health
        end)
    end
end)