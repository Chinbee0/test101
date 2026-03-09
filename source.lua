local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

--! 1. สร้างหน้าต่างหลัก (Window)
local Window = Fluent:CreateWindow({
    Title = "Retrograde", -- ชื่อสคริปต์ด้านบน
    SubTitle = "by Devlahm",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- พื้นหลังโปร่งแสง
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End -- ปุ่มปิด/เปิดเมนู
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






--! 5. เพิ่มหัวข้อในหน้า Visuals (Misc)
local MiscSection = Tabs.Misc:AddSection("Misc")

local customWordsInput = ",Example,Example2," -- เก็บคำในรูปแบบ ,คำ1,คำ2,
local isAutoTyping = false
local autoTypeToggle = nil

-- ฟังก์ชันสำหรับแยกคำจากสตริงที่คั่นด้วยคอมม่า
local function getWordsFromInput(str)
    local words = {}
    -- ค้นหาคำที่อยู่ระหว่างคอมม่า
    for word in str:gmatch("([^,]+)") do
        table.insert(words, word)
    end
    return words
end

-- ฟังก์ชันสำหรับค้นหา TextBox ตามรูปภาพ (PlaceholderText: พิมพ์คำศัพท์ของคุณที่นี่)
local function findTargetTextBox()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("TextBox") and v.PlaceholderText == "พิมพ์คำศัพท์ของคุณที่นี่" then
            return v
        end
    end
    return nil
end

-- ฟังก์ชันสำหรับพิมพ์คำลงใน TextBox โดยไม่กด Enter อัตโนมัติ
local function typeInBoxManual(textBox, text)
    textBox.Text = text
    -- โฟกัสไปที่ช่องพิมพ์เพื่อให้ผู้ใช้กด Enter ได้ทันที
    textBox:CaptureFocus()
end

local function runAutoTyper()
    local textBox = findTargetTextBox()
    
    if not textBox then
        Fluent:Notify({
            Title = "Error",
            Content = "ไม่พบช่องพิมพ์คำศัพท์ (TextBox)",
            Duration = 3
        })
        isAutoTyping = false
        if autoTypeToggle then autoTypeToggle:SetValue(false) end
        return
    end

    local wordsToType = getWordsFromInput(customWordsInput)

    for _, word in ipairs(wordsToType) do
        if not isAutoTyping then break end
        
        -- พิมพ์คำลงในช่องแชท
        print("กำลังพิมพ์คำ: " .. word)
        typeInBoxManual(textBox, word)

        -- รอจนกว่าผู้ใช้จะกด Enter ในช่อง TextBox นั้น
        local enterPressed = false
        repeat
            local _, ep = textBox.FocusLost:Wait()
            enterPressed = ep
            -- ตรวจสอบว่ายังเปิดโหมด AutoType อยู่ไหม ถ้าปิดแล้วให้หลุด Loop
            if not isAutoTyping then break end
        until enterPressed

        -- เว้นระยะ 2 วินาที ก่อนพิมพ์คำถัดไปหลังจากกด Enter
        task.wait(2)
    end
    
    isAutoTyping = false
    if autoTypeToggle then autoTypeToggle:SetValue(false) end
end

MiscSection:AddInput("CustomWords", {
    Title = "Custom Words List",
    Description = "ใส่คำที่ต้องการคั่นด้วย , เช่น ,คำ1,คำ2,",
    Default = customWordsInput,
    Placeholder = ",word1,word2,",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        customWordsInput = Value
    end
})

autoTypeToggle = MiscSection:AddToggle("AutoTypeUI", {
    Title = "Auto Type (In-Box)", 
    Description = "พิมพ์คำลงในช่องแชท/ช่องกรอกตามรูปโดยอัตโนมัติ",
    Default = false,
    Callback = function(Value)
        isAutoTyping = Value
        if isAutoTyping then
            task.spawn(runAutoTyper)
        end
    end
})




-- เลือกหน้าแรกเป็นหน้าเริ่มต้น
Window:SelectTab(1)

Fluent:Notify({
    Title = "Script Loaded",
    Content = "กด End เพื่อเปิด/ปิดเมนู",
    Duration = 5
})
