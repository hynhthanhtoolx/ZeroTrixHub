--==============================
-- AUTO JOIN SERVER DƯỚI 5 NGƯỜI
--==============================
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local JobId = game.JobId

-- LƯU SERVER ĐÃ VÀO (TRÁNH VÀO LẠI)
getgenv().JoinedServers = getgenv().JoinedServers or {}

-- GIỚI HẠN NGƯỜI
local MAX_PLAYER = 4 -- dưới 5 người

local function GetLowPlayerServer()
    local cursor = ""
    local selectedServer = nil
    local lowestCount = math.huge

    repeat
        local url =
            "https://games.roblox.com/v1/games/"..PlaceId..
            "/servers/Public?sortOrder=Asc&limit=100"

        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local data = HttpService:JSONDecode(game:HttpGet(url))

        for _,server in pairs(data.data) do
            -- 🔥 CHỈ NHẬN SERVER < 5 NGƯỜI
            if server.playing <= MAX_PLAYER
            and server.id ~= JobId
            and not getgenv().JoinedServers[server.id] then

                -- ưu tiên server ít người nhất
                if server.playing < lowestCount then
                    lowestCount = server.playing
                    selectedServer = server
                end
            end
        end

        cursor = data.nextPageCursor
    until not cursor or lowestCount <= 1

    return selectedServer
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
        warn("❌ Không tìm thấy server dưới 5 người!")
    end
end

--==============================
-- RUN
--==============================
JoinLowServer()