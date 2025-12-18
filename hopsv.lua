--====================================================
-- AUTO JOIN / AUTO HOP SERVER 3–4 NGƯỜI (FULL)
--====================================================

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

--==============================
-- SERVICES
--==============================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

--==============================
-- CONFIG (LƯU QUA TELEPORT)
--==============================
getgenv().ServerConfig = getgenv().ServerConfig or {
    Enabled = true,        -- ON / OFF AUTO JOIN
    MinPlayer = 3,         -- tối thiểu
    MaxPlayer = 4,         -- tối đa
    DelayHop = 3           -- delay trước khi hop
}

-- LƯU SERVER ĐÃ VÀO (TRÁNH VÒNG LẶP)
getgenv().JoinedServers = getgenv().JoinedServers or {}

--==============================
-- QUEUE ON TELEPORT (GIỮ SCRIPT)
--==============================
if queue_on_teleport then
    queue_on_teleport([[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yourlink/fullcode.lua"))()
    ]])
end
-- (nếu bạn không dùng raw link thì bỏ đoạn trên)

--==============================
-- KIỂM TRA SERVER HIỆN TẠI
--==============================
local function CurrentServerValid()
    local count = #Players:GetPlayers()
    return count >= getgenv().ServerConfig.MinPlayer
       and count <= getgenv().ServerConfig.MaxPlayer
end

--==============================
-- TÌM SERVER 3–4 NGƯỜI
--==============================
local function FindLowServer()
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
            if server.playing >= getgenv().ServerConfig.MinPlayer
            and server.playing <= getgenv().ServerConfig.MaxPlayer
            and server.id ~= JobId
            and not getgenv().JoinedServers[server.id] then
                return server.id
            end
        end

        cursor = data.nextPageCursor
    until not cursor

    return nil
end

--==============================
-- TELEPORT
--==============================
local function HopServer()
    if not getgenv().ServerConfig.Enabled then return end

    local serverId = FindLowServer()
    if serverId then
        getgenv().JoinedServers[serverId] = true
        task.wait(getgenv().ServerConfig.DelayHop)

        TeleportService:TeleportToPlaceInstance(
            PlaceId,
            serverId,
            Player
        )
    else
        warn("❌ Không tìm thấy server 3–4 người, thử lại...")
        task.wait(5)
        HopServer()
    end
end

--==============================
-- MAIN
--==============================
if getgenv().ServerConfig.Enabled then
    if not CurrentServerValid() then
        HopServer()
    else
        warn("✅ Server hiện tại đã đúng 3–4 người, không cần hop")
    end
end

--==============================
-- COMMAND NHANH
--==============================
-- getgenv().ServerConfig.Enabled = true / false
-- getgenv().ServerConfig.MinPlayer = 3
-- getgenv().ServerConfig.MaxPlayer = 4
