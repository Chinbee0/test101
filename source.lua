local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

--! 1. สร้างหน้าต่างหลัก (Window)
local Window = Fluent:CreateWindow({
    Title = "Retrograde", -- ชื่อสคริปต์ด้านบน
    SubTitle = "by THEBEST",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- พื้นหลังโปร่งแสง
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift -- ปุ่มปิด/เปิดเมนู
})

--! 2. สร้างแถบเมนูด้านข้าง (Tabs) ตามรูป
local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Players = Window:AddTab({ Title = "Players", Icon = "users" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "cog" })
}

--! 3. เพิ่มหัวข้อและปุ่มในหน้า Combat (ฝั่งซ้าย: Aimbot)
local AimbotSection = Tabs.Combat:AddSection("Aimbot")

AimbotSection:AddToggle("AimbotEnabled", {Title = "Enabled", Default = false})
AimbotSection:AddToggle("WallCheck", {Title = "Wall Check", Default = false})
AimbotSection:AddSlider("MaxDistance", {
    Title = "Max Distance",
    Description = "ระยะยิงไกลสุด",
    Default = 500,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value) end
})
AimbotSection:AddDropdown("Hitbox", {
    Title = "Hitbox",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Multi = false,
    Default = 1,
})

--! 4. เพิ่มหัวข้อในหน้า Combat (ฝั่งขวา: Gun Mods)
local GunModsSection = Tabs.Combat:AddSection("Gun Mods")

GunModsSection:AddToggle("InstantReload", {Title = "Instant Reload", Default = false})
GunModsSection:AddToggle("NoRecoil", {Title = "No Recoil", Default = false})
GunModsSection:AddToggle("RapidFire", {Title = "Rapid Fire", Default = false})

--! 5. เพิ่มหัวข้อในหน้า Visuals (ESP)
local VisualsSection = Tabs.Visuals:AddSection("Visuals")

VisualsSection:AddToggle("ESPEnabled", {Title = "Enabled", Default = false})
VisualsSection:AddToggle("Snaplines", {Title = "Snapline", Default = false})
VisualsSection:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 0, 255)
})

-- เลือกหน้าแรกเป็นหน้าเริ่มต้น
Window:SelectTab(1)

Fluent:Notify({
    Title = "Script Loaded",
    Content = "กด RightShift เพื่อเปิด/ปิดเมนู",
    Duration = 5
})
