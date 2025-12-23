repeat task.wait() until game:IsLoaded()

-- ======================
-- CONFIG
-- ======================
local PlaceId = game.PlaceId
local BossNames = {
    "Dragon King",
    "Hydra",
    "Sea King",
    "King Samurai",
    "Inferno King",
    "Snow King",
    "Gold King"
}

getgenv().AutoHop = true
getgenv().AutoFarmBoss = true
getgenv().HopDelay = 3
getgenv().Distance = 8 -- khoảng cách đứng đánh boss

-- ======================
-- SERVICES
-- ======================
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- ======================
-- CHECK BOSS
-- ======================
local function GetBoss()
    for _, name in pairs(BossNames) do
        local boss = workspace:FindFirstChild(name)
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            return boss
        end
    end
    return nil
end

-- ======================
-- SERVER HOP
-- ======================
getgenv().VisitedServers = getgenv().VisitedServers or {}

local function HopServer()
    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers
        and not getgenv().VisitedServers[server.id] then
            getgenv().VisitedServers[server.id] = true
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Player)
            task.wait(5)
            return
        end
    end
end

-- ======================
-- AUTO FARM BOSS
-- ======================
task.spawn(function()
    while task.wait() do
        if getgenv().AutoFarmBoss then
            local boss = GetBoss()
            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                getgenv().AutoHop = false

                pcall(function()
                    HumanoidRootPart.CFrame =
                        boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, getgenv().Distance)
                end)

                -- auto click
                pcall(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait()
                    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end
        end
    end
end)

-- ======================
-- MAIN LOOP AUTO HOP
-- ======================
task.spawn(function()
    while getgenv().AutoHop do
        if not GetBoss() then
            warn("❌ Không có boss → Hop server")
            HopServer()
        else
            warn("✅ Tìm thấy boss → TP & đánh")
            break
        end
        task.wait(getgenv().HopDelay)
    end
end)