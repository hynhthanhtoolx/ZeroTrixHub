--=====================================================
-- AUTO FARM ALL SWORD MASTERY 600 (BLOX FRUITS)
--=====================================================

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

--================= CONFIG =================--
getgenv().AutoFarmAllSword = true
getgenv().TargetMastery = 600
getgenv().FarmDistance = 8
getgenv().AttackDelay = 0.15
--=========================================--

-- Anti AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

--================= FUNCTIONS =================--

-- Check sword
function IsSword(tool)
    return tool:IsA("Tool")
        and tool:FindFirstChild("Handle")
        and tool:FindFirstChild("Damage")
end

-- Get mastery
function GetSwordMastery(name)
    local data = Player:WaitForChild("Data")
    local mastery = data:WaitForChild("WeaponMastery")
    for _,v in pairs(mastery:GetChildren()) do
        if v.Name == name then
            return v.Value
        end
    end
    return 0
end

-- Get all swords
function GetAllSwords()
    local swords = {}

    for _,v in pairs(Player.Backpack:GetChildren()) do
        if IsSword(v) then
            table.insert(swords, v.Name)
        end
    end

    for _,v in pairs(Character:GetChildren()) do
        if IsSword(v) and not table.find(swords, v.Name) then
            table.insert(swords, v.Name)
        end
    end

    return swords
end

-- Equip sword
function EquipSword(name)
    if Player.Backpack:FindFirstChild(name) then
        Humanoid:EquipTool(Player.Backpack[name])
    end
end

-- Get current sword
function GetEquippedSword()
    for _,v in pairs(Character:GetChildren()) do
        if IsSword(v) then
            return v
        end
    end
end

-- Get nearest mob
function GetNearestMob()
    local nearest, dist = nil, math.huge
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid")
        and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health > 0 then
            local d = (mob.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = mob
            end
        end
    end
    return nearest
end

-- Attack
function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait()
    VirtualUser:Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end

--================= AUTO CHANGE SWORD =================--

task.spawn(function()
    while task.wait(1) do
        if not getgenv().AutoFarmAllSword then break end

        local swords = GetAllSwords()
        local found = false

        for _,name in ipairs(swords) do
            if GetSwordMastery(name) < getgenv().TargetMastery then
                EquipSword(name)
                found = true
                break
            end
        end

        if not found then
            warn("✅ ĐÃ FULL 600 MASTERY TOÀN BỘ KIẾM!")
            getgenv().AutoFarmAllSword = false
        end
    end
end)

--================= AUTO FARM =================--

RunService.RenderStepped:Connect(function()
    if not getgenv().AutoFarmAllSword then return end

    local sword = GetEquippedSword()
    local mob = GetNearestMob()

    if sword and mob then
        pcall(function()
            mob.HumanoidRootPart.CFrame =
                Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-getgenv().FarmDistance)

            Character.HumanoidRootPart.CFrame =
                mob.HumanoidRootPart.CFrame * CFrame.new(0,0,getgenv().FarmDistance)

            Attack()
        end)
    end
end)

print("🔥 AUTO FARM ALL SWORD MASTERY 600: ON")