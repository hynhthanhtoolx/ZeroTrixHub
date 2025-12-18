--==============================
-- AUTO JOIN SERVER ÍT NGƯỜI
--==============================
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local JobId = game.JobId

-- LƯU SERVER ĐÃ VÀO (TRÁNH VÀO LẠI)
getgenv().JoinedServers = getgenv().JoinedServers or {}

local function GetLowPlayerServer()
    local cursor = ""
    local lowestServer = nil
    local lowestCount = math.huge

    repeat
        local url = "https://games.roblox.com/v1/games/"..PlaceId..
            "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _,server in pairs(data.data) do
            if server.playing < lowestCount
            and server.id ~= JobId
            and not getgenv().JoinedServers[server.id] then
                lowestCount = server.playing
                lowestServer = server
            end
        end

        cursor = data.nextPageCursor
    until not cursor or lowestCount <= 1

    return lowestServer
end

--==============================
-- TELEPORT
--==============================
local function JoinLowServer()
    local server = GetLowPlayerServer()
    if server then
        getgenv().JoinedServers[server.id] = true
        TeleportService:TeleportToPlaceInstance(
            PlaceId,
            server.id,
            Players.LocalPlayer
        )
    else
        warn("Không tìm thấy server phù hợp!")
    end
end

--==============================
-- GỌI HÀM
--==============================
JoinLowServer()