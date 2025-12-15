-- ============================================
-- PHẦN UI MENU CHO FARMING HUB
-- ============================================

-- Tải thư viện Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Tạo cửa sổ chính
local Window = Fluent:CreateWindow({
    Title = "Farming Hub - Blox Fruits",
    SubTitle = "By Huỳnh Thanh Ý",
    TabWidth = 160,
    Theme = "Dark",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 380),
    MinimizeKey = Enum.KeyCode.End
})

-- Tạo các tab
local Tabs = {
    Main = Window:AddTab({ Title = "🏠 Main Farming" }),
    Boss = Window:AddTab({ Title = "👑 Boss Farming" }),
    Material = Window:AddTab({ Title = "📦 Material Farm" }),
    Sea = Window:AddTab({ Title = "🌊 Sea Events" }),
    Settings = Window:AddTab({ Title = "⚙️ Settings" }),
    Visual = Window:AddTab({ Title = "👁️ Visual ESP" })
}

local Options = Fluent.Options

-- ============================================
-- TAB 1: MAIN FARMING
-- ============================================

Tabs.Main:AddSection("Weapon Selection")

-- Dropdown chọn vũ khí
local WeaponDropdown = Tabs.Main:AddDropdown("WeaponSelect", {
    Title = "Select Weapon Type",
    Description = "Choose your weapon for farming",
    Values = { "Melee", "Sword", "Blox Fruit" },
    Multi = false,
    Default = "Melee"
})

WeaponDropdown:OnChanged(function(value)
    ChooseWeapon = value
end)
WeaponDropdown:SetValue("Melee")

Tabs.Main:AddSection("Auto Farming")

-- Auto Farm Level
local AutoLevelToggle = Tabs.Main:AddToggle("AutoLevelToggle", {
    Title = "Auto Farm Level",
    Description = "Automatically farm monsters based on your level",
    Default = false
})

AutoLevelToggle:OnChanged(function(value)
    _G.AutoLevel = value
    if value == false then
        CancelTween()
    end
end)

-- Auto Farm Nearest
local AutoNearToggle = Tabs.Main:AddToggle("AutoNearToggle", {
    Title = "Auto Farm Nearest",
    Description = "Farm the closest monsters",
    Default = false
})

AutoNearToggle:OnChanged(function(value)
    _G.AutoNear = value
    if value == false then
        CancelTween()
    end
end)

-- Auto Farm Pirates Castle
local CastleRaidToggle = Tabs.Main:AddToggle("CastleRaidToggle", {
    Title = "Auto Farm Pirates",
    Description = "Farm pirates in the castle",
    Default = false
})

CastleRaidToggle:OnChanged(function(value)
    _G.CastleRaid = value
end)

-- Auto Collect Chest
local ChestToggle = Tabs.Main:AddToggle("ChestToggle", {
    Title = "Auto Collect Chest",
    Description = "Automatically collect chests",
    Default = false
})

ChestToggle:OnChanged(function(value)
    _G.AutoCollectChest = value
end)

Tabs.Main:AddSection("Mastery Farming")

-- Mastery Type
local MasteryDropdown = Tabs.Main:AddDropdown("MasteryType", {
    Title = "Mastery Farm Type",
    Description = "Select mastery farming method",
    Values = { "Near Mobs" },
    Multi = false,
    Default = "Near Mobs"
})

MasteryDropdown:OnChanged(function(value)
    TypeMastery = value
end)
MasteryDropdown:SetValue("Near Mobs")

-- Auto Mastery Fruit
local MasteryToggle = Tabs.Main:AddToggle("MasteryToggle", {
    Title = "Auto Mastery Fruit",
    Description = "Farm mastery for your devil fruit",
    Default = false
})

MasteryToggle:OnChanged(function(value)
    AutoFarmMasDevilFruit = value
end)

-- HP Percent Slider
local HPSlider = Tabs.Main:AddSlider("HPSlider", {
    Title = "Mob HP Percent for Skill",
    Description = "Use skills when mob HP is below this percent",
    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(value)
        KillPercent = value
    end
})
HPSlider:SetValue(20)

-- ============================================
-- TAB 2: BOSS FARMING
-- ============================================

Tabs.Boss:AddSection("Boss Selection")

-- Dropdown chọn boss
local BossDropdown = Tabs.Boss:AddDropdown("BossSelect", {
    Title = "Select Boss",
    Description = "Choose which boss to farm",
    Values = tableBoss,
    Multi = false,
    Default = 1
})

BossDropdown:OnChanged(function(value)
    _G.SelectBoss = value
end)
BossDropdown:SetValue(tableBoss[1])

-- Auto Farm Boss
local BossToggle = Tabs.Boss:AddToggle("BossToggle", {
    Title = "Auto Farm Boss",
    Description = "Automatically farm selected boss",
    Default = false
})

BossToggle:OnChanged(function(value)
    _G.AutoBoss = value
end)

-- Section cho Sea 3 bosses
if Sea3 then
    Tabs.Boss:AddSection("Sea 3 Special Bosses")
    
    -- Auto Cake Prince
    local CakeToggle = Tabs.Boss:AddToggle("CakeToggle", {
        Title = "Auto Cake Prince",
        Description = "Farm Cake Prince",
        Default = false
    })
    
    CakeToggle:OnChanged(function(value)
        _G.CakePrince = value
        if value == false then
            CancelTween()
        end
    end)
    
    -- Auto Dough King
    local DoughToggle = Tabs.Boss:AddToggle("DoughToggle", {
        Title = "Auto Dough King",
        Description = "Farm Dough King",
        Default = false
    })
    
    DoughToggle:OnChanged(function(value)
        _G.DoughKing = value
        if value == false then
            CancelTween()
        end
    end)
    
    -- Spawn Cake Prince
    local SpawnCakeToggle = Tabs.Boss:AddToggle("SpawnCakeToggle", {
        Title = "Spawn Cake Prince",
        Description = "Auto spawn Cake Prince",
        Default = true
    })
    
    SpawnCakeToggle:OnChanged(function(value)
        _G.SpawnCakePrince = value
    end)
    SpawnCakeToggle:SetValue(true)
end

-- Section cho Sea 2 bosses
if Sea2 then
    Tabs.Boss:AddSection("Sea 2 Special Bosses")
    
    -- Auto Don Swan
    local DonSwanToggle = Tabs.Boss:AddToggle("DonSwanToggle", {
        Title = "Auto Don Swan",
        Description = "Farm Don Swan",
        Default = false
    })
    
    DonSwanToggle:OnChanged(function(value)
        _G.AutoDonSwan = value
    end)
end

-- ============================================
-- TAB 3: MATERIAL FARMING
-- ============================================

Tabs.Material:AddSection("Material Selection")

-- Dropdown chọn vật liệu
local MaterialDropdown = Tabs.Material:AddDropdown("MaterialSelect", {
    Title = "Select Material",
    Description = "Choose which material to farm",
    Values = MaterialList,
    Multi = false,
    Default = 1
})

MaterialDropdown:OnChanged(function(value)
    SelectMaterial = value
end)
MaterialDropdown:SetValue(MaterialList[1])

-- Auto Farm Material
local MaterialToggle = Tabs.Material:AddToggle("MaterialToggle", {
    Title = "Auto Farm Material",
    Description = "Automatically farm selected material",
    Default = false
})

MaterialToggle:OnChanged(function(value)
    _G.AutoMaterial = value
    if value == false then
        CancelTween()
    end
end)

-- Section đặc biệt cho Sea 2
if Sea2 then
    Tabs.Material:AddSection("Sea 2 Materials")
    
    -- Auto Ectoplasm
    local EctoplasmToggle = Tabs.Material:AddToggle("EctoplasmToggle", {
        Title = "Auto Farm Ectoplasm",
        Description = "Farm Ectoplasm on ships",
        Default = false
    })
    
    EctoplasmToggle:OnChanged(function(value)
        _G.Ectoplasm = value
    end)
end

-- Section đặc biệt cho Sea 3
if Sea3 then
    Tabs.Material:AddSection("Sea 3 Materials")
    
    -- Auto Bone
    local BoneToggle = Tabs.Material:AddToggle("BoneToggle", {
        Title = "Auto Farm Bone",
        Description = "Farm bones in Haunted Castle",
        Default = false
    })
    
    BoneToggle:OnChanged(function(value)
        _G.AutoBone = value
        if value == false then
            CancelTween()
        end
    end)
    
    -- Auto Bone No Quest
    local BoneNoQuestToggle = Tabs.Material:AddToggle("BoneNoQuestToggle", {
        Title = "Auto Bone (No Quest)",
        Description = "Farm bones without quest",
        Default = false
    })
    
    BoneNoQuestToggle:OnChanged(function(value)
        _G.AutoBoneNoQuest = value
        if value == false then
            CancelTween()
        end
    end)
    
    -- Random Bones
    local RandomBoneToggle = Tabs.Material:AddToggle("RandomBoneToggle", {
        Title = "Random Bones",
        Description = "Buy random bones",
        Default = false
    })
    
    RandomBoneToggle:OnChanged(function(value)
        _G.AutoRandomBone = value
    end)
end

-- ============================================
-- TAB 4: SEA EVENTS (SEA 3 ONLY)
-- ============================================

if Sea3 then
    Tabs.Sea:AddSection("Island Finding")
    
    -- Auto Find Prehistoric Island
    local PrehistoricToggle = Tabs.Sea:AddToggle("PrehistoricToggle", {
        Title = "Auto Find Prehistoric Island",
        Description = "Automatically search for Prehistoric Island",
        Default = false
    })
    
    PrehistoricToggle:OnChanged(function(value)
        _G.AutoFindPrehistoric = value
    end)
    
    -- Auto Find Mirage Island
    local MirageToggle = Tabs.Sea:AddToggle("MirageToggle", {
        Title = "Auto Find Mirage Island",
        Description = "Automatically search for Mirage Island",
        Default = false
    })
    
    MirageToggle:OnChanged(function(value)
        _G.AutoFindMirage = value
    end)
    
    -- Auto Find Frozen Dimension
    local FrozenToggle = Tabs.Sea:AddToggle("FrozenToggle", {
        Title = "Auto Find Leviathan Island",
        Description = "Automatically search for Frozen Dimension",
        Default = false
    })
    
    FrozenToggle:OnChanged(function(value)
        _G.AutoFindFrozen = value
    end)
    
    Tabs.Sea:AddSection("Kitsune Island")
    
    -- Tween to Kitsune
    local TPKitsuneToggle = Tabs.Sea:AddToggle("TPKitsuneToggle", {
        Title = "Fly to Kitsune Island",
        Description = "Teleport to Kitsune Island",
        Default = false
    })
    
    TPKitsuneToggle:OnChanged(function(value)
        _G.TweenToKitsune = value
    end)
    
    -- Collect Azure Ember
    local AzureToggle = Tabs.Sea:AddToggle("AzureToggle", {
        Title = "Auto Collect Azure Ember",
        Description = "Collect Azure Embers in Kitsune Island",
        Default = false
    })
    
    AzureToggle:OnChanged(function(value)
        _G.CollectAzure = value
    end)
    
    Tabs.Sea:AddSection("Sea Monsters")
    
    -- Auto Terrorshark
    local TerrorsharkToggle = Tabs.Sea:AddToggle("TerrorsharkToggle", {
        Title = "Attack Terrorshark",
        Description = "Auto attack Terrorshark",
        Default = false
    })
    
    TerrorsharkToggle:OnChanged(function(value)
        _G.AutoTerrorshark = value
    end)
    
    -- Auto Piranha
    local PiranhaToggle = Tabs.Sea:AddToggle("PiranhaToggle", {
        Title = "Attack Piranha",
        Description = "Auto attack Piranha",
        Default = false
    })
    
    PiranhaToggle:OnChanged(function(value)
        _G.farmpiranya = value
    end)
    
    Tabs.Sea:AddSection("Boat Control")
    
    -- Boat Speed Slider
    local BoatSpeedSlider = Tabs.Sea:AddSlider("BoatSpeed", {
        Title = "Boat Speed",
        Description = "Set your boat speed",
        Default = 350,
        Min = 0,
        Max = 350,
        Rounding = 1,
        Callback = function(value)
            v508 = value -- Boat speed variable
        end
    })
    BoatSpeedSlider:SetValue(350)
    
    -- Go back to Tiki
    local TikiToggle = Tabs.Sea:AddToggle("TikiToggle", {
        Title = "Go Back to Tiki Outpost",
        Description = "Return to Tiki Outpost",
        Default = false
    })
    
    TikiToggle:OnChanged(function(value)
        _G.AutoComeTiki = value
    end)
    
    -- Go back to Hydra
    local HydraToggle = Tabs.Sea:AddToggle("HydraToggle", {
        Title = "Go Back to Hydra Island",
        Description = "Return to Hydra Island",
        Default = false
    })
    
    HydraToggle:OnChanged(function(value)
        _G.AutoComeHydra = value
    end)
    
    -- Boat Selection
    local BoatList = {
        "Beast Hunter", "Sleigh", "Miracle", "The Sentinel", "Guardian",
        "Lantern", "Dinghy", "PirateSloop", "PirateBrigade", "PirateGrandBrigade",
        "MarineGrandBrigade", "MarineBrigade", "MarineSloop"
    }
    
    local BoatDropdown = Tabs.Sea:AddDropdown("BoatSelect", {
        Title = "Select Boat",
        Description = "Choose which boat to use",
        Values = BoatList,
        Multi = false,
        Default = 1
    })
    
    local selectedBoat = BoatList[1]
    BoatDropdown:OnChanged(function(value)
        selectedBoat = value
    end)
    
    -- Buy Boat Button
    Tabs.Sea:AddButton({
        Title = "Buy Selected Boat",
        Description = "Purchase the selected boat",
        Callback = function()
            local args = {[1] = "BuyBoat", [2] = selectedBoat}
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end
    })
    
    -- Fly to Boat Button
    Tabs.Sea:AddButton({
        Title = "Fly to My Boat",
        Description = "Teleport to your boat",
        Callback = function()
            -- Logic to find and teleport to boat
            for _, boat in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                if boat:FindFirstChild("VehicleSeat") then
                    Tween2(boat.VehicleSeat.CFrame)
                    break
                end
            end
        end
    })
end

-- ============================================
-- TAB 5: SETTINGS
-- ============================================

Tabs.Settings:AddSection("Attack Settings")

-- Fast Attack Mode
local FastAttackDropdown = Tabs.Settings:AddDropdown("FastAttackMode", {
    Title = "Fast Attack Mode",
    Description = "Select attack speed mode",
    Values = { "Super Fast Attack", "Fast Attack", "Normal" },
    Multi = false,
    Default = "Super Fast Attack"
})

FastAttackDropdown:OnChanged(function(value)
    _G.FastAttackStrix_Mode = value
end)
FastAttackDropdown:SetValue("Super Fast Attack")

-- Tween Speed Slider
local TweenSpeedSlider = Tabs.Settings:AddSlider("TweenSpeed", {
    Title = "Tween Speed",
    Description = "Speed of teleportation movement",
    Default = 350,
    Min = 100,
    Max = 500,
    Rounding = 1,
    Callback = function(value)
        TweenSpeed = value
    end
})
TweenSpeedSlider:SetValue(350)

Tabs.Settings:AddSection("Auto Features")

-- Auto Haki
local AutoHakiToggle = Tabs.Settings:AddToggle("AutoHakiToggle", {
    Title = "Auto Haki",
    Description = "Automatically activate Haki",
    Default = true
})

AutoHakiToggle:OnChanged(function(value)
    _G.AutoHakiEnabled = value
end)
AutoHakiToggle:SetValue(true)

-- Anti AFK
local AntiAFKToggle = Tabs.Settings:AddToggle("AntiAFKToggle", {
    Title = "Anti AFK",
    Description = "Prevent being kicked for AFK",
    Default = true
})

AntiAFKToggle:OnChanged(function(value)
    _G.AntiAFK = value
end)
AntiAFKToggle:SetValue(true)

-- No Clip
local NoClipToggle = Tabs.Settings:AddToggle("NoClipToggle", {
    Title = "No Clip (When Farming)",
    Description = "Walk through objects while farming",
    Default = true
})

NoClipToggle:OnChanged(function(value)
    _G.NoClipEnabled = value
end)
NoClipToggle:SetValue(true)

Tabs.Settings:AddSection("Miscellaneous")

-- Enable Haki Fortress
local HakiFortressToggle = Tabs.Settings:AddToggle("HakiFortressToggle", {
    Title = "Activate Color Haki (Fortress)",
    Description = "Automatically get all Haki colors in Fortress",
    Default = false
})

HakiFortressToggle:OnChanged(function(value)
    _G.EnableHakiFortress = value
end)

-- Stop All Farming Button
Tabs.Settings:AddButton({
    Title = "🛑 Stop All Farming",
    Description = "Stop all active farming functions",
    Callback = function()
        _G.AutoLevel = false
        _G.AutoNear = false
        _G.AutoBoss = false
        _G.AutoMaterial = false
        _G.CakePrince = false
        _G.DoughKing = false
        _G.Ectoplasm = false
        _G.AutoBone = false
        _G.AutoBoneNoQuest = false
        
        Options.AutoLevelToggle:SetValue(false)
        Options.AutoNearToggle:SetValue(false)
        Options.BossToggle:SetValue(false)
        Options.MaterialToggle:SetValue(false)
        Options.CakeToggle:SetValue(false)
        Options.DoughToggle:SetValue(false)
        Options.EctoplasmToggle:SetValue(false)
        Options.BoneToggle:SetValue(false)
        Options.BoneNoQuestToggle:SetValue(false)
        
        CancelTween()
        Fluent:Notify({
            Title = "Farming Hub",
            Content = "All farming functions stopped",
            Duration = 3
        })
    end
})

-- ============================================
-- TAB 6: VISUAL ESP
-- ============================================

Tabs.Visual:AddSection("Player ESP")

-- Player ESP
local PlayerESPToggle = Tabs.Visual:AddToggle("PlayerESPToggle", {
    Title = "Player ESP",
    Description = "Show player information and distance",
    Default = false
})

PlayerESPToggle:OnChanged(function(value)
    ESPPlayer = value
end)

Tabs.Visual:AddSection("Object ESP")

-- Chest ESP
local ChestESPToggle = Tabs.Visual:AddToggle("ChestESPToggle", {
    Title = "Chest ESP",
    Description = "Show chest locations",
    Default = false
})

ChestESPToggle:OnChanged(function(value)
    ChestESP = value
end)

-- Devil Fruit ESP
local FruitESPToggle = Tabs.Visual:AddToggle("FruitESPToggle", {
    Title = "Devil Fruit ESP",
    Description = "Show devil fruit locations",
    Default = false
})

FruitESPToggle:OnChanged(function(value)
    DevilFruitESP = value
end)

-- Real Fruit ESP
local RealFruitESPToggle = Tabs.Visual:AddToggle("RealFruitESPToggle", {
    Title = "Real Fruit ESP",
    Description = "Show real fruit spawns",
    Default = false
})

RealFruitESPToggle:OnChanged(function(value)
    RealFruitESP = value
end)

Tabs.Visual:AddSection("Mob ESP")

-- Mob ESP
local MobESPToggle = Tabs.Visual:AddToggle("MobESPToggle", {
    Title = "Mob ESP",
    Description = "Show monster information",
    Default = false
})

MobESPToggle:OnChanged(function(value)
    MobESP = value
end)

-- NPC ESP
local NPCESPToggle = Tabs.Visual:AddToggle("NPCESPToggle", {
    Title = "NPC ESP",
    Description = "Show NPC information",
    Default = false
})

NPCESPToggle:OnChanged(function(value)
    NpcESP = value
end)

Tabs.Visual:AddSection("Island ESP")

-- Island ESP
local IslandESPToggle = Tabs.Visual:AddToggle("IslandESPToggle", {
    Title = "Island ESP",
    Description = "Show island locations",
    Default = false
})

IslandESPToggle:OnChanged(function(value)
    IslandESP = value
end)

-- Mirage Island ESP
if Sea3 then
    local MirageESPToggle = Tabs.Visual:AddToggle("MirageESPToggle", {
        Title = "Mirage Island ESP",
        Description = "Show Mirage Island location",
        Default = false
    })
    
    MirageESPToggle:OnChanged(function(value)
        MirageIslandESP = value
    end)
    
    -- Kitsune Island ESP
    local KitsuneESPToggle = Tabs.Visual:AddToggle("KitsuneESPToggle", {
        Title = "Kitsune Island ESP",
        Description = "Show Kitsune Island location",
        Default = false
    })
    
    KitsuneESPToggle:OnChanged(function(value)
        KitsuneIslandEsp = value
    end)
end

-- ============================================
-- FLOATING TOGGLE BUTTON
-- ============================================

-- Tạo nút toggle floating
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ParticleEmitter = Instance.new("ParticleEmitter")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.12, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Draggable = true
ToggleButton.Image = "http://www.roblox.com/asset/?id=130947856929902"

UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(1, 0)

ParticleEmitter.Parent = ToggleButton
ParticleEmitter.LightEmission = 1
ParticleEmitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 0)
})
ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
ParticleEmitter.Rate = 0
ParticleEmitter.Speed = NumberRange.new(5, 10)
ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 85, 255), Color3.fromRGB(85, 255, 255))

local TweenService = game:GetService("TweenService")
local rotationTween = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0})

local toggled = true

ToggleButton.MouseButton1Down:Connect(function()
    ParticleEmitter.Rate = 100
    task.delay(1, function()
        ParticleEmitter.Rate = 0
    end)
    
    rotationTween:Play()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game)
    
    rotationTween.Completed:Connect(function()
        ToggleButton.Rotation = 0
    end)
    
    if not toggled then
        toggled = true
        ToggleButton.BackgroundTransparency = 0
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local enlargeTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 60, 0, 60)
        })
        enlargeTween:Play()
    else
        toggled = false
        ToggleButton.BackgroundTransparency = 0.5
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local shrinkTween = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        })
        shrinkTween:Play()
    end
end)

-- ============================================
-- NOTIFICATION KHI BẮT ĐẦU
-- ============================================

-- Thông báo khi load script
task.wait(1)
Fluent:Notify({
    Title = "Farming Hub Loaded",
    Content = "Press END to toggle menu\nUse floating button to show/hide",
    Duration = 5
})

print("Farming Hub UI đã được tải thành công!")