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


--! 6. เพิ่มหัวข้อในหน้า Misc (Auto Typer)
local MiscSection = Tabs.Misc:AddSection("Auto Typer")

-- ข้อมูลสำหรับ Auto Typer
local wordsToType = {"รถ", "รถไฟ", "รถบรรทุก", "รถถัง", "รถกระบะ"}
local targetWord = "คำที่ถูกต้อง"
local isTyping = false
local autoTypeToggle = nil
local usedWords = {} -- เก็บคำที่คนอื่นพิมพ์ไปแล้ว

-- ฟังก์ชันตรวจสอบแชทเพื่อเก็บคำที่ถูกใช้ไปแล้ว
local function monitorChat()
    local textChatService = game:GetService("TextChatService")
    
    -- แก้ไข: ใช้ MessageReceived (Event) แทน OnIncomingMessage (Callback) เพื่อป้องกันการ Crash
    if textChatService then
        textChatService.MessageReceived:Connect(function(textChatMessage)
            if textChatMessage.Text then
                usedWords[textChatMessage.Text] = true
            end
        end)
    end
    
    -- สำหรับระบบแชทเก่า
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents and chatEvents:FindFirstChild("OnMessageDoneFiltering") then
        chatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
            if data and data.Message then
                usedWords[data.Message] = true
            end
        end)
    end
end

-- เริ่มตรวจจับแชททันที
task.spawn(monitorChat)

-- เก็บ Cache ของ TextBox เพื่อไม่ต้องค้นหาใหม่ทุกครั้ง (ลดการใช้ CPU)
local cachedInputBox = nil
local function findInputBox()
    -- ถ้าเคยหาเจอแล้ว และมันยังใช้งานได้อยู่ ให้ใช้ตัวเดิม
    if cachedInputBox and cachedInputBox:IsDescendantOf(game) then
        return cachedInputBox
    end

    -- ถ้ายังไม่เจอ ให้ค้นหาใหม่
    for _, v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("TextBox") and (v.PlaceholderText == "พิมพ์คำศัพท์ของคุณที่นี่" or v.Name == "Input") then
            cachedInputBox = v
            return v
        end
    end
    return nil
end

-- ฟังก์ชันส่งข้อความ
local function sendToUI(message)
    local targetInput = findInputBox()
    if targetInput then
        targetInput:CaptureFocus()
        targetInput.Text = message
        task.wait(0.1)
        targetInput:ReleaseFocus(true)
        print("ส่งคำว่า: " .. message)
    end
end

-- ฟังก์ชันหลัก
local function startAutoTyper()
    for _, word in ipairs(wordsToType) do
        if not isTyping then break end
        
        -- ตรวจสอบว่าคำนี้ถูกคนอื่นพิมพ์ไปหรือยัง
        if usedWords[word] then
            print("ข้ามคำว่า: " .. word .. " (มีคนพิมพ์ไปแล้ว)")
            continue -- ข้ามไปคำต่อไปทันที
        end
        
        if word == targetWord then
            isTyping = false
            if autoTypeToggle then autoTypeToggle:SetValue(false) end
            break 
        else
            sendToUI(word)
            task.wait(1.2) -- ปรับความเร็วได้
        end
    end
    isTyping = false
    if autoTypeToggle then autoTypeToggle:SetValue(false) end
end

-- สร้าง Toggle
autoTypeToggle = MiscSection:AddToggle("Auto Type", {
    Title = "Enabled", 
    Default = false,
    Callback = function(Value)
        isTyping = Value
        if isTyping then
            task.spawn(startAutoTyper)
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
