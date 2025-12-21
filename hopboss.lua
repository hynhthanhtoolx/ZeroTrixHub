-- =========================
-- INIT
-- =========================
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================
getgenv().Team = "Marines"
getgenv()["Black Screen"] = false

getgenv().Config = {
    ["Hop Boss"] = {
        ["Weapon"] = "Melee",
        ["Bosses"] = {"rip_indra"},
        ["FPS Booster"] = false
    }
}

-- =========================
-- TEAM
-- =========================
pcall(function()
    if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= getgenv().Team then
        repeat task.wait()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team)
        until LocalPlayer.Team and LocalPlayer.Team.Name == getgenv().Team
    end
end)

-- =========================
-- FPS BOOST
-- =========================
if getgenv().Config["Hop Boss"]["FPS Booster"] then
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

-- =========================
-- BLACK SCREEN
-- =========================
if getgenv()["Black Screen"] then
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "BlackScreen"
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.new(0,0,0)
end

-- =========================
-- CHECK BOSS
-- =========================
local function BossExists(name)
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if string.find(string.lower(v.Name), string.lower(name)) then
            return v
        end
    end
    return nil
end

-- =========================
-- ATTACK SIMPLE
-- =========================
local function AttackBoss(boss)
    local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

    repeat task.wait()
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0,0,5)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
        end
    until not boss
end

-- =========================
-- SERVER HOP
-- =========================
local function ServerHop()
    local servers = HttpService:JSONDecode(
        game:HttpGet(
            "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        )
    )

    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
            break
        end
    end
end

-- =========================
-- MAIN LOOP
-- =========================
task.spawn(function()
    while task.wait(3) do
        for _,bossName in pairs(getgenv().Config["Hop Boss"]["Bosses"]) do
            local boss = BossExists(bossName)

            if boss then
                AttackBoss(boss)
            else
                ServerHop()
            end
        end
    end
end)