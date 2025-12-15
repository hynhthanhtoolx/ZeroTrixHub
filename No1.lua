-- ============================================
-- COMPLETE FARMING HUB FOR BLOX FRUITS
-- ============================================

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Local Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- ============================================
-- XÁC ĐỊNH SEA VÀ KHỞI TẠO BIẾN
-- ============================================

local PlaceId = game.PlaceId
local Sea1, Sea2, Sea3 = false, false, false

if PlaceId == 2753915549 then
    Sea1 = true
    print("Đang ở Sea 1")
elseif PlaceId == 4442272183 then
    Sea2 = true
    print("Đang ở Sea 2")
elseif PlaceId == 7449423635 then
    Sea3 = true
    print("Đang ở Sea 3")
else
    warn("Không phải Blox Fruits!")
    return
end

-- Biến toàn cục
_G.FastAttackStrix_Mode = "Super Fast Attack"
_G.Fast_Delay = 1e-9
TweenSpeed = 350
KillPercent = 20
TypeMastery = "Near Mobs"

-- Biến trạng thái
_G.AutoLevel = false
_G.AutoNear = false
_G.CastleRaid = false
_G.AutoCollectChest = false
_G.AutoBoss = false
_G.AutoMaterial = false
_G.UseSkill = false
_G.EnableHakiFortress = false
_G.Ectoplasm = false
_G.AutoBone = false
_G.AutoBoneNoQuest = false
_G.AutoRandomBone = false
_G.CakePrince = false
_G.DoughKing = false
_G.SpawnCakePrince = true
_G.TweenToKitsune = false
_G.CollectAzure = false
_G.AutoFindPrehistoric = false
_G.AutoFindMirage = false
_G.AutoFindFrozen = false
_G.AutoComeTiki = false
_G.AutoComeHydra = false
_G.AutoTerrorshark = false
_G.farmpiranya = false
_G.StopTween = false
_G.CancelTween2 = false
_G.Clip2 = false

-- Biến ESP
ESPPlayer = false
ChestESP = false
DevilFruitESP = false
FlowerESP = false
RealFruitESP = false
IslandESP = false
MobESP = false
SeaESP = false
NpcESP = false
MirageIslandESP = false
AuraESP = false
LADESP = false
GearESP = false
KitsuneIslandEsp = false

-- Biến lựa chọn
ChooseWeapon = "Melee"
SelectWeapon = ""
SelectMonster = ""
SelectBoss = ""
SelectMaterial = ""

-- ============================================
-- DANH SÁCH DỮ LIỆU
-- ============================================

local tableMon = {}
local AreaList = {}
local tableBoss = {}
local MaterialList = {}

if Sea1 then
    tableMon = {
        "Bandit", "Monkey", "Gorilla", "Pirate", "Brute",
        "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman",
        "Chief Petty Officer", "Sky Bandit", "Dark Master", "Prisoner",
        "Dangerous Prisoner", "Toga Warrior", "Gladiator", "Military Soldier",
        "Military Spy", "Fishman Warrior", "Fishman Commando", "God's Guard",
        "Shanda", "Royal Squad", "Royal Soldier", "Galley Pirate", "Galley Captain"
    }
    
    tableBoss = {
        "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral",
        "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
        "Wysper", "Thunder God", "Cyborg", "Saber Expert"
    }
    
    MaterialList = {
        "Scrap Metal", "Leather", "Angel Wings", "Magma Ore", "Fish Tail"
    }
    
elseif Sea2 then
    tableMon = {
        "Raider", "Mercenary", "Swan Pirate", "Factory Staff",
        "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire",
        "Snow Trooper", "Winter Warrior", "Lab Subordinate", "Horned Warrior",
        "Magma Ninja", "Lava Pirate", "Ship Deckhand", "Ship Engineer",
        "Ship Steward", "Ship Officer", "Arctic Warrior", "Snow Lurker",
        "Sea Soldier", "Water Fighter"
    }
    
    tableBoss = {
        "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral",
        "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"
    }
    
    MaterialList = {
        "Scrap Metal", "Leather", "Radioactive Material",
        "Mystic Droplet", "Magma Ore", "Vampire Fang"
    }
    
elseif Sea3 then
    tableMon = {
        "Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer",
        "Hydra Enforcer", "Venomous Assailant", "Marine Commodore",
        "Marine Rear Admiral", "Fishman Raider", "Fishman Captain",
        "Forest Pirate", "Mythological Pirate", "Jungle Pirate",
        "Musketeer Pirate", "Reborn Skeleton", "Living Zombie",
        "Demonic Soul", "Posessed Mummy", "Peanut Scout", "Peanut President",
        "Ice Cream Chef", "Ice Cream Commander", "Cookie Crafter",
        "Cake Guard", "Baking Staff", "Head Baker", "Cocoa Warrior",
        "Chocolate Bar Battler", "Sweet Thief", "Candy Rebel", "Candy Pirate",
        "Snow Demon", "Isle Outlaw", "Island Boy", "Sun-kissed Warrior",
        "Isle Champion", "Serpent Hunter", "Skull Slayer"
    }
    
    tableBoss = {
        "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant",
        "Beautiful Pirate", "rip_indra True Form", "Longma",
        "Soul Reaper", "Cake Queen"
    }
    
    MaterialList = {
        "Scrap Metal", "Leather", "Demonic Wisp", "Conjured Cocoa",
        "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk",
        "Hydra Enforcer", "Venomous Assailant"
    }
end

-- ============================================
-- HÀM TIỆN ÍCH
-- ============================================

function AutoHaki()
    if not Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipTool(ToolName)
    if Player.Backpack:FindFirstChild(ToolName) then
        local tool = Player.Backpack:FindFirstChild(ToolName)
        task.wait()
        Character.Humanoid:EquipTool(tool)
    end
end

function Tween(targetCFrame)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local distance = (targetCFrame.Position - Character.HumanoidRootPart.Position).Magnitude
    local speed = TweenSpeed
    if distance > 500 then speed = 500 end
    
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    if _G.StopTween then tween:Cancel() end
end

function Tween2(targetCFrame)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local distance = (targetCFrame.Position - Character.HumanoidRootPart.Position).Magnitude
    local speed = 350
    if distance > 500 then speed = 500 end
    
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    if _G.CancelTween2 then tween:Cancel() end
    _G.Clip2 = true
    task.wait(distance / speed)
    _G.Clip2 = false
end

function CancelTween()
    _G.StopTween = true
    task.wait()
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
    end
    task.wait()
    _G.StopTween = false
end

function AttackNoCoolDown()
    if not Character then return end
    
    local enemies = {}
    local playerPos = Character.HumanoidRootPart.Position
    
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local distance = (enemy.HumanoidRootPart.Position - playerPos).Magnitude
                if distance <= 50 then
                    table.insert(enemies, enemy)
                end
            end
        end
    end
    
    if #enemies > 0 then
        EquipTool(SelectWeapon)
        for _, enemy in pairs(enemies) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                break
            end
        end
    end
end

function CheckLevel()
    local level = Player.Data.Level.Value
    local Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon
    
    if Sea1 then
        if level <= 9 then
            Ms = "Bandit"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            CFrameQ = CFrame.new(1060.94, 16.46, 1547.78)
            CFrameMon = CFrame.new(1038.55, 41.30, 1576.51)
        elseif level <= 14 then
            Ms = "Monkey"
            NameQuest = "JungleQuest"
            QuestLv = 1
            CFrameQ = CFrame.new(-1601.66, 36.85, 153.39)
            CFrameMon = CFrame.new(-1448.14, 50.85, 63.61)
        -- Thêm các level khác...
        end
    end
    
    return Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon
end

-- ============================================
-- TẢI FLUENT UI
-- ============================================

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not success then
    warn("Không thể tải Fluent UI!")
    return
end

-- Tạo cửa sổ
local Window = Fluent:CreateWindow({
    Title = "Farming Hub - Blox Fruits",
    SubTitle = "Premium Version",
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 400),
    MinimizeKey = Enum.KeyCode.End
})

-- Tạo các tab
local Tabs = {
    Main = Window:AddTab({ Title = "🏠 Main" }),
    Boss = Window:AddTab({ Title = "👑 Boss" }),
    Material = Window:AddTab({ Title = "📦 Material" }),
    Sea = Sea3 and Window:AddTab({ Title = "🌊 Sea 3" }) or nil,
    Settings = Window:AddTab({ Title = "⚙️ Settings" }),
    Visual = Window:AddTab({ Title = "👁️ Visual" })
}

local Options = Fluent.Options

-- ============================================
-- TAB MAIN FARMING
-- ============================================

Tabs.Main:AddSection("Weapon")

local WeaponDropdown = Tabs.Main:AddDropdown("WeaponDropdown", {
    Title = "Select Weapon",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Default = "Melee"
})

WeaponDropdown:OnChanged(function(value)
    ChooseWeapon = value
end)

Tabs.Main:AddSection("Auto Farming")

local AutoLevelToggle = Tabs.Main:AddToggle("AutoLevelToggle", {
    Title = "Auto Farm Level",
    Default = false
})

AutoLevelToggle:OnChanged(function(value)
    _G.AutoLevel = value
    if not value then CancelTween() end
end)

local AutoNearToggle = Tabs.Main:AddToggle("AutoNearToggle", {
    Title = "Auto Farm Nearest",
    Default = false
})

AutoNearToggle:OnChanged(function(value)
    _G.AutoNear = value
    if not value then CancelTween() end
end)

local CastleRaidToggle = Tabs.Main:AddToggle("CastleRaidToggle", {
    Title = "Auto Farm Pirates",
    Default = false
})

CastleRaidToggle:OnChanged(function(value)
    _G.CastleRaid = value
end)

Tabs.Main:AddSection("Mastery")

local MasteryToggle = Tabs.Main:AddToggle("MasteryToggle", {
    Title = "Auto Mastery Fruit",
    Default = false
})

MasteryToggle:OnChanged(function(value)
    AutoFarmMasDevilFruit = value
end)

local HPSlider = Tabs.Main:AddSlider("HPSlider", {
    Title = "Mob HP % for Skill",
    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1
})

HPSlider:OnChanged(function(value)
    KillPercent = value
end)

-- ============================================
-- TAB BOSS FARMING
-- ============================================

Tabs.Boss:AddSection("Select Boss")

local BossDropdown = Tabs.Boss:AddDropdown("BossDropdown", {
    Title = "Choose Boss",
    Values = tableBoss,
    Default = tableBoss[1]
})

BossDropdown:OnChanged(function(value)
    SelectBoss = value
end)

local BossToggle = Tabs.Boss:AddToggle("BossToggle", {
    Title = "Auto Farm Boss",
    Default = false
})

BossToggle:OnChanged(function(value)
    _G.AutoBoss = value
end)

if Sea3 then
    Tabs.Boss:AddSection("Sea 3 Bosses")
    
    local CakeToggle = Tabs.Boss:AddToggle("CakeToggle", {
        Title = "Auto Cake Prince",
        Default = false
    })
    
    CakeToggle:OnChanged(function(value)
        _G.CakePrince = value
    end)
    
    local DoughToggle = Tabs.Boss:AddToggle("DoughToggle", {
        Title = "Auto Dough King",
        Default = false
    })
    
    DoughToggle:OnChanged(function(value)
        _G.DoughKing = value
    end)
end

-- ============================================
-- TAB MATERIAL FARMING
-- ============================================

Tabs.Material:AddSection("Select Material")

local MaterialDropdown = Tabs.Material:AddDropdown("MaterialDropdown", {
    Title = "Choose Material",
    Values = MaterialList,
    Default = MaterialList[1]
})

MaterialDropdown:OnChanged(function(value)
    SelectMaterial = value
end)

local MaterialToggle = Tabs.Material:AddToggle("MaterialToggle", {
    Title = "Auto Farm Material",
    Default = false
})

MaterialToggle:OnChanged(function(value)
    _G.AutoMaterial = value
    if not value then CancelTween() end
end)

if Sea2 then
    Tabs.Material:AddSection("Sea 2 Materials")
    
    local EctoplasmToggle = Tabs.Material:AddToggle("EctoplasmToggle", {
        Title = "Auto Ectoplasm",
        Default = false
    })
    
    EctoplasmToggle:OnChanged(function(value)
        _G.Ectoplasm = value
    end)
end

if Sea3 then
    Tabs.Material:AddSection("Sea 3 Materials")
    
    local BoneToggle = Tabs.Material:AddToggle("BoneToggle", {
        Title = "Auto Farm Bone",
        Default = false
    })
    
    BoneToggle:OnChanged(function(value)
        _G.AutoBone = value
    end)
end

-- ============================================
-- TAB SEA 3 (Nếu có)
-- ============================================

if Sea3 and Tabs.Sea then
    Tabs.Sea:AddSection("Island Finding")
    
    local PrehistoricToggle = Tabs.Sea:AddToggle("PrehistoricToggle", {
        Title = "Find Prehistoric Island",
        Default = false
    })
    
    PrehistoricToggle:OnChanged(function(value)
        _G.AutoFindPrehistoric = value
    end)
    
    local MirageToggle = Tabs.Sea:AddToggle("MirageToggle", {
        Title = "Find Mirage Island",
        Default = false
    })
    
    MirageToggle:OnChanged(function(value)
        _G.AutoFindMirage = value
    end)
    
    Tabs.Sea:AddSection("Sea Monsters")
    
    local TerrorsharkToggle = Tabs.Sea:AddToggle("TerrorsharkToggle", {
        Title = "Attack Terrorshark",
        Default = false
    })
    
    TerrorsharkToggle:OnChanged(function(value)
        _G.AutoTerrorshark = value
    end)
end

-- ============================================
-- TAB SETTINGS
-- ============================================

Tabs.Settings:AddSection("Attack Settings")

local FastAttackDropdown = Tabs.Settings:AddDropdown("FastAttackDropdown", {
    Title = "Fast Attack Mode",
    Values = {"Super Fast Attack", "Fast Attack", "Normal"},
    Default = "Super Fast Attack"
})

FastAttackDropdown:OnChanged(function(value)
    _G.FastAttackStrix_Mode = value
end)

local TweenSpeedSlider = Tabs.Settings:AddSlider("TweenSpeedSlider", {
    Title = "Tween Speed",
    Default = 350,
    Min = 100,
    Max = 500,
    Rounding = 1
})

TweenSpeedSlider:OnChanged(function(value)
    TweenSpeed = value
end)

Tabs.Settings:AddSection("Auto Features")

local AutoHakiToggle = Tabs.Settings:AddToggle("AutoHakiToggle", {
    Title = "Auto Haki",
    Default = true
})

AutoHakiToggle:OnChanged(function(value)
    _G.AutoHakiEnabled = value
end)

Tabs.Settings:AddButton({
    Title = "🛑 Stop All Farming",
    Description = "Stop all farming functions",
    Callback = function()
        _G.AutoLevel = false
        _G.AutoNear = false
        _G.AutoBoss = false
        _G.AutoMaterial = false
        _G.CakePrince = false
        _G.DoughKing = false
        
        Options.AutoLevelToggle:SetValue(false)
        Options.AutoNearToggle:SetValue(false)
        Options.BossToggle:SetValue(false)
        Options.MaterialToggle:SetValue(false)
        Options.CakeToggle:SetValue(false)
        Options.DoughToggle:SetValue(false)
        
        CancelTween()
        
        Fluent:Notify({
            Title = "Farming Hub",
            Content = "All farming stopped!",
            Duration = 3
        })
    end
})

-- ============================================
-- TAB VISUAL ESP
-- ============================================

Tabs.Visual:AddSection("Player ESP")

local PlayerESPToggle = Tabs.Visual:AddToggle("PlayerESPToggle", {
    Title = "Player ESP",
    Default = false
})

PlayerESPToggle:OnChanged(function(value)
    ESPPlayer = value
end)

Tabs.Visual:AddSection("Object ESP")

local ChestESPToggle = Tabs.Visual:AddToggle("ChestESPToggle", {
    Title = "Chest ESP",
    Default = false
})

ChestESPToggle:OnChanged(function(value)
    ChestESP = value
end)

local MobESPToggle = Tabs.Visual:AddToggle("MobESPToggle", {
    Title = "Mob ESP",
    Default = false
})

MobESPToggle:OnChanged(function(value)
    MobESP = value
end)

-- ============================================
-- FLOATING TOGGLE BUTTON
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmingHubUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.02, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Draggable = true
ToggleButton.Image = "http://www.roblox.com/asset/?id=6031075938"

local UICorner = Instance.new("UICorner")
UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(1, 0)

local toggled = true

ToggleButton.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.End, false, game)
    
    if toggled then
        ToggleButton.BackgroundTransparency = 0.2
        toggled = false
    else
        ToggleButton.BackgroundTransparency = 0.5
        toggled = true
    end
end)

-- ============================================
-- LOOP CHÍNH CHO AUTO FARM
-- ============================================

task.spawn(function()
    while task.wait(0.1) do
        if not Character or not Character:FindFirstChild("Humanoid") then
            Character = Player.Character or Player.CharacterAdded:Wait()
        end
        
        -- Auto Farm Level
        if _G.AutoLevel then
            pcall(function()
                local Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon = CheckLevel()
                
                if Ms then
                    local quest = Player.PlayerGui.Main.Quest
                    
                    if not quest.Visible or not string.find(quest.Container.QuestTitle.Title.Text, NameMon) then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        task.wait(0.5)
                        Tween(CFrameQ)
                        
                        if (CFrameQ.Position - Character.HumanoidRootPart.Position).Magnitude < 10 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        end
                    else
                        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                            if enemy.Name == Ms and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                AutoHaki()
                                EquipTool(SelectWeapon)
                                Tween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                                AttackNoCoolDown()
                                break
                            end
                        end
                    end
                end
            end)
        end
        
        -- Auto Farm Nearest
        if _G.AutoNear then
            pcall(function()
                local closestEnemy = nil
                local closestDistance = math.huge
                
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                        if enemy.Humanoid.Health > 0 then
                            local distance = (enemy.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance and distance < 500 then
                                closestDistance = distance
                                closestEnemy = enemy
                            end
                        end
                    end
                end
                
                if closestEnemy then
                    AutoHaki()
                    EquipTool(SelectWeapon)
                    Tween(closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    AttackNoCoolDown()
                end
            end)
        end
        
        -- Auto Farm Boss
        if _G.AutoBoss and SelectBoss ~= "" then
            pcall(function()
                local boss = nil
                
                -- Kiểm tra trong Workspace
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == SelectBoss and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        boss = enemy
                        break
                    end
                end
                
                -- Kiểm tra trong ReplicatedStorage
                if not boss then
                    local repBoss = ReplicatedStorage:FindFirstChild(SelectBoss)
                    if repBoss then
                        Tween(repBoss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        return
                    end
                end
                
                if boss then
                    AutoHaki()
                    EquipTool(SelectWeapon)
                    Tween(boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                    AttackNoCoolDown()
                end
            end)
        end
        
        -- Auto Cake Prince (Sea 3)
        if Sea3 and _G.CakePrince then
            pcall(function()
                local cakePrince = nil
                
                for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                    if enemy.Name == "Cake Prince" and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        cakePrince = enemy
                        break
                    end
                end
                
                if not cakePrince then
                    cakePrince = ReplicatedStorage:FindFirstChild("Cake Prince")
                    if cakePrince then
                        Tween(cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        return
                    end
                end
                
                if cakePrince then
                    AutoHaki()
                    EquipTool(SelectWeapon)
                    Tween(cakePrince.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                    AttackNoCoolDown()
                end
            end)
        end
    end
end)

-- ============================================
-- ANTI-AFK
-- ============================================

task.spawn(function()
    while task.wait(30) do
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
    end
end)

-- ============================================
-- NO CLIP KHI FARMING
-- ============================================

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoLevel or _G.AutoNear or _G.AutoBoss or _G.CakePrince then
                if Character and Character:FindFirstChild("Humanoid") then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================
-- THÔNG BÁO KHI LOAD XONG
-- ============================================

task.wait(2)
Fluent:Notify({
    Title = "Farming Hub",
    Content = "Script loaded successfully!\nPress END to toggle menu",
    Duration = 5
})

print("====================================")
print("FARMING HUB LOADED SUCCESSFULLY!")
print("Current Sea: " .. (Sea1 and "1" or Sea2 and "2" or Sea3 and "3"))
print("Press END to open/close menu")
print("Click the circle button to toggle")
print("====================================")

-- ============================================
-- XÓA HIỆU ỨNG CHẾT/MẶC ĐỊNH
-- ============================================

task.spawn(function()
    if ReplicatedStorage.Effect.Container:FindFirstChild("Death") then
        ReplicatedStorage.Effect.Container.Death:Destroy()
    end
    if ReplicatedStorage.Effect.Container:FindFirstChild("Respawn") then
        ReplicatedStorage.Effect.Container.Respawn:Destroy()
    end
end)