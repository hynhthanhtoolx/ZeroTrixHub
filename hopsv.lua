--====================================================
-- AUTO HOP SERVER KHI CÓ BOSS RIP (BLOX FRUITS)
--====================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

--==============================
-- SERVICES
--==============================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

--==============================
-- CONFIG (LƯU QUA TELEPORT)
--==============================
getgenv().BossHopConfig = getgenv().BossHopConfig or {
    Enabled = true,
    DelayHop = 3,
    BossList = { -- TÊN BOSS RIP
        "Rip Indra",
        "rip_indra",
        "Rip_Indra"
    }
}

-- LƯU SERVER ĐÃ VÀO
getgenv().VisitedServer = getgenv().VisitedServer or {}

--==============================
-- QUEUE ON TELEPORT (GIỮ SCRIPT)
--==============================
if queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet("YOUR_RAW_LINK_HERE"))()
    ]])
end
-- (Nếu không dùng raw link thì bỏ đoạn trên)

--==============================
-- CHECK BOSS RIP
--==============================
local function BossExists()
    -- Check trong Workspace
    if workspace:FindFirstChild("Enemies") then
        for _,mob in pairs(workspace.Enemies:GetChildren()) do
            for _,bossName in pairs(getgenv().BossHopConfig.BossList) do
                if mob.Name == bossName
                and mob:FindFirstChild("Humanoid")
                and mob.Humanoid.Health > 0 then
                    return true
                end
            end
        end
    end

    -- Check ReplicatedStorage (boss sắp spawn)
    if ReplicatedStorage:FindFirstChild("Enemies") then
        for _,mob in pairs(ReplicatedStorage.Enemies:GetChildren()) do
            for _,bossName in pairs(getgenv().BossHopConfig.BossList) do
                if mob.Name == bossName then
                    return true
                end
            end
        end
    end

    return false
end

--==============================
-- FIND SERVER
--==============================
local function FindServer()
    local cursor = ""

    repeat
        local url =
            "https://games.roblox.com/v1/games/"..PlaceId..
            "/servers/Public?sortOrder=Asc&limit=100"

        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local data = HttpService:JSONDecode(game:HttpGet(url))

        for _,server in pairs(data.data) do
            if server.id ~= JobId
            and not getgenv().VisitedServer[server.id] then
                return server.id
            end
        end

        cursor = data.nextPageCursor
    until not cursor

    return nil
end

--==============================
-- HOP SERVER
--==============================
local function HopServer()
    if not getgenv().BossHopConfig.Enabled then return end

    local serverId = FindServer()
    if serverId then
        getgenv().VisitedServer[serverId] = true
        task.wait(getgenv().BossHopConfig.DelayHop)

        TeleportService:TeleportToPlaceInstance(
            PlaceId,
            serverId,
            Player
        )
    else
        warn("❌ Không còn server để hop, chờ 10s...")
        task.wait(10)
        HopServer()
    end
end

--==============================
-- MAIN LOOP
--==============================
task.spawn(function()
    while task.wait(2) do
        if getgenv().BossHopConfig.Enabled then
            if BossExists() then
                warn("👑 BOSS RIP ĐÃ SPAWN – DỪNG HOP")
                break
            else
                warn("❌ Chưa có boss RIP – HOP SERVER")
                HopServer()
            end
        end
    end
end)

--==============================
-- COMMAND NHANH
--==============================
-- getgenv().BossHopConfig.Enabled = true / false
