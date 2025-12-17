repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- ======================================================
-- SAVE DATA QUA SERVER
-- ======================================================
getgenv().KenSave = getgenv().KenSave or {
    FarmCFrame = CFrame.new(-613.25, 38.97, 2552.57),
    FarmEnabled = true
}

-- ======================================================
-- QUEUE SCRIPT WHEN TELEPORT (FIX HOP DIE SCRIPT)
-- ======================================================
getgenv().KEN_SCRIPT_SOURCE = getgenv().KEN_SCRIPT_SOURCE or [[
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

getgenv().KenSave = getgenv().KenSave or {
    FarmCFrame = CFrame.new(-613.25, 38.97, 2552.57),
    FarmEnabled = true
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlaceId = game.PlaceId

repeat task.wait() until player

if not player.Team or player.Team.Name ~= "Pirates" then
    pcall(function()
        ReplicatedStorage
            :WaitForChild("Remotes")
            :WaitForChild("CommF_")
            :InvokeServer("SetTeam", "Pirates")
    end)
end

repeat task.wait() until player.Team and player.Team.Name == "Pirates"

getgenv().FarmKen = {
    CheckDelay = 0.3,
    HopWhenKenBreak = true,
    HopDelay = 5,
    MaxPlayer = 2,
    EnableKenDelay = 2
}

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "KenFarmUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,150)
frame.Position = UDim2.fromScale(0.02,0.25)
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
info.Text = "ON / OFF saved across servers"

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

toggleBtn.MouseButton1Click:Connect(function()
    getgenv().KenSave.FarmEnabled = not getgenv().KenSave.FarmEnabled
    UpdateUI()
end)

local function EnableKenOnServerJoin()
    local maxAttempts = 10
    local attempt = 0
    
    while attempt < maxAttempts do
        attempt += 1
        
        local char = player.Character
        if not char then
            task.wait(1)
            char = player.Character
        end
        
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                if not char:FindFirstChild("ObservationHaki") then
                    status.Text = "STATUS: BẬT KEN..."
                    status.TextColor3 = Color3.fromRGB(255, 200, 0)
                    
                    local success1 = pcall(function()
                        ReplicatedStorage
                            :WaitForChild("Remotes")
                            :WaitForChild("CommF_")
                            :InvokeServer("KenEvent", true)
                    end)
                    
                    task.wait(0.5)
                    
                    if not success1 or not char:FindFirstChild("ObservationHaki") then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                    
                    task.wait(1)
                    
                    if char:FindFirstChild("ObservationHaki") then
                        status.Text = "STATUS: KEN ĐÃ BẬT"
                        status.TextColor3 = Color3.fromRGB(0, 200, 255)
                        return true
                    else
                        status.Text = "STATUS: THỬ LẠI KEN..."
                        status.TextColor3 = Color3.fromRGB(255, 150, 0)
                    end
                else
                    status.Text = "STATUS: KEN ĐÃ BẬT"
                    status.TextColor3 = Color3.fromRGB(0, 200, 255)
                    return true
                end
            end
        end
        
        task.wait(1)
    end
    
    status.Text = "STATUS: KHÔNG BẬT ĐƯỢC KEN"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    return false
end

task.spawn(function()
    task.wait(3)
    EnableKenOnServerJoin()
end)

local lastKenCheck = 0
local kenEnabled = false

local function CheckAndEnableKen()
    local now = tick()
    if now - lastKenCheck < getgenv().FarmKen.EnableKenDelay then return end
    lastKenCheck = now
    
    local char = player.Character
    if not char then 
        kenEnabled = false
        return 
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then 
        kenEnabled = false
        return 
    end
    
    local hasKen = char:FindFirstChild("ObservationHaki")
    
    if not hasKen then
        kenEnabled = false
        EnableKenOnServerJoin()
    else
        kenEnabled = true
    end
end

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

task.spawn(function()
    local lastHealth = 0
    
    task.wait(5)

    while task.wait(getgenv().FarmKen.CheckDelay) do
        pcall(function()
            if not getgenv().KenSave.FarmEnabled then return end

            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then 
                kenEnabled = false
                return 
            end

            char:PivotTo(getgenv().KenSave.FarmCFrame)
            
            CheckAndEnableKen()
            
            hum:Move(Vector3.zero, true)

            if lastHealth == 0 then
                lastHealth = hum.Health
                return
            end

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
]]

if queue_on_teleport then
    queue_on_teleport(getgenv().KEN_SCRIPT_SOURCE)
end

-- ======================================================
-- SERVICES
-- ======================================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlaceId = game.PlaceId

-- ======================================================
-- AUTO SET TEAM PIRATES (NO UI)
-- ======================================================
repeat task.wait() until player

if not player.Team or player.Team.Name ~= "Pirates" then
    pcall(function()
        ReplicatedStorage
            :WaitForChild("Remotes")
            :WaitForChild("CommF_")
            :InvokeServer("SetTeam", "Pirates")
    end)
end

repeat task.wait() until player.Team and player.Team.Name == "Pirates"

-- ======================================================
-- CONFIG
-- ======================================================
getgenv().FarmKen = {
    CheckDelay = 0.3,
    HopWhenKenBreak = true,
    HopDelay = 5,
    MaxPlayer = 2,
    EnableKenDelay = 2
}

-- ======================================================
-- UI FARM
-- ======================================================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "KenFarmUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220,150)
frame.Position = UDim2.fromScale(0.02,0.25)
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
info.Text = "ON / OFF saved across servers"

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

toggleBtn.MouseButton1Click:Connect(function()
    getgenv().KenSave.FarmEnabled = not getgenv().KenSave.FarmEnabled
    UpdateUI()
end)

-- ======================================================
-- KIỂM TRA VÀ BẬT HAKI QUAN SÁT KHI VÀO MÁY CHỦ
-- ======================================================
local function EnableKenOnServerJoin()
    local maxAttempts = 10
    local attempt = 0
    
    while attempt < maxAttempts do
        attempt += 1
        
        -- Chờ character load
        local char = player.Character
        if not char then
            task.wait(1)
            char = player.Character
        end
        
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Kiểm tra xem đã có Ken chưa
                if not char:FindFirstChild("ObservationHaki") then
                    status.Text = "STATUS: BẬT KEN..."
                    status.TextColor3 = Color3.fromRGB(255, 200, 0)
                    
                    -- Phương pháp 1: Dùng Remote
                    local success1 = pcall(function()
                        ReplicatedStorage
                            :WaitForChild("Remotes")
                            :WaitForChild("CommF_")
                            :InvokeServer("KenEvent", true)
                    end)
                    
                    task.wait(0.5)
                    
                    -- Phương pháp 2: Nhấn phím E
                    if not success1 or not char:FindFirstChild("ObservationHaki") then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                    
                    task.wait(1)
                    
                    -- Kiểm tra kết quả
                    if char:FindFirstChild("ObservationHaki") then
                        status.Text = "STATUS: KEN ĐÃ BẬT"
                        status.TextColor3 = Color3.fromRGB(0, 200, 255)
                        return true
                    else
                        status.Text = "STATUS: THỬ LẠI KEN..."
                        status.TextColor3 = Color3.fromRGB(255, 150, 0)
                    end
                else
                    status.Text = "STATUS: KEN ĐÃ BẬT"
                    status.TextColor3 = Color3.fromRGB(0, 200, 255)
                    return true
                end
            end
        end
        
        task.wait(1)
    end
    
    status.Text = "STATUS: KHÔNG BẬT ĐƯỢC KEN"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    return false
end

-- Chạy ngay khi vào server
task.spawn(function()
    task.wait(3) -- Chờ 3 giây để game load hoàn toàn
    EnableKenOnServerJoin()
end)

-- ======================================================
-- KIỂM TRA VÀ GIỮ KEN TRONG LÚC FARM
-- ======================================================
local lastKenCheck = 0
local kenEnabled = false

local function CheckAndEnableKen()
    local now = tick()
    if now - lastKenCheck < getgenv().FarmKen.EnableKenDelay then return end
    lastKenCheck = now
    
    local char = player.Character
    if not char then 
        kenEnabled = false
        return 
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then 
        kenEnabled = false
        return 
    end
    
    -- Kiểm tra xem Ken có bị tắt không
    local hasKen = char:FindFirstChild("ObservationHaki")
    
    if not hasKen then
        kenEnabled = false
        -- Tự động bật lại Ken nếu bị tắt
        EnableKenOnServerJoin()
    else
        kenEnabled = true
    end
end

-- ======================================================
-- HOP SERVER
-- ======================================================
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

-- ======================================================
-- FARM LOOP
-- ======================================================
task.spawn(function()
    local lastHealth = 0
    
    -- Đợi một chút trước khi bắt đầu farm
    task.wait(5)

    while task.wait(getgenv().FarmKen.CheckDelay) do
        pcall(function()
            if not getgenv().KenSave.FarmEnabled then return end

            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then 
                kenEnabled = false
                return 
            end

            -- Di chuyển đến vị trí farm
            char:PivotTo(getgenv().KenSave.FarmCFrame)
            
            -- Kiểm tra và bật Ken nếu cần
            CheckAndEnableKen()
            
            -- Giữ nhân vật đứng yên
            hum:Move(Vector3.zero, true)

            -- Kiểm tra máu để phát hiện Ken break
            if lastHealth == 0 then
                lastHealth = hum.Health
                return
            end

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

-- ======================================================
-- THÔNG BÁO HOÀN THÀNH
-- ======================================================
print("╔════════════════════════════════════════════╗")
print("║        KEN FARM SCRIPT ĐÃ SẴN SÀNG        ║")
print("║   Tự động bật Ken khi vào máy chủ mới    ║")
print("║   Tự động bật lại Ken nếu bị tắt         ║")
print("║   Tự động hop server khi Ken break       ║")
print("╚════════════════════════════════════════════╝")