--[[
    MyCustomUI Library v1.0
    สร้างโดย: THEBEST & Gemini
    คำอธิบาย: Library สำหรับสร้าง UI ใน Roblox แบบพื้นฐานและทันสมัย
]]

local CustomUI = {}
local UserInputService = game:GetService("UserInputService")

-- สร้างหน้าต่างหลัก
function CustomUI:CreateWindow(options)
    options = options or {}
    local title = options.Title or "My UI"
    local size = options.Size or UDim2.new(0, 500, 0, 350)
    local minimizeKey = options.MinimizeKey or Enum.KeyCode.RightShift

    -- 1. สร้าง ScreenGui (ตัวครอบ UI)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUIScreen"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- 2. สร้าง Frame หลัก (หน้าต่าง)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = size
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner", MainFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(80, 80, 80)
    Stroke.Thickness = 1

    -- 3. สร้าง Title Bar
    local TitleBar = Instance.new("TextLabel")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Text = "  " .. title
    TitleBar.Font = Enum.Font.GothamSemibold
    TitleBar.TextSize = 16
    TitleBar.TextColor3 = Color3.new(1, 1, 1)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.TextXAlignment = Enum.TextXAlignment.Left
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner", TitleBar)
    TitleCorner.CornerRadius = UDim.new(0, 6)

    -- 4. ระบบลากหน้าต่าง (Draggable)
    local dragging = false
    local dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    -- 5. ระบบย่อ/ขยายหน้าต่าง
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == minimizeKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- 6. สร้าง Container สำหรับเก็บปุ่มต่างๆ
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 1, -45)
    Container.Position = UDim2.new(0, 10, 0, 40)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 4
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- 7. สร้าง API สำหรับให้สคริปต์หลักเรียกใช้
    local API = {}
    function API:AddButton(buttonText, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.Text = buttonText
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.Gotham
        Button.Parent = Container

        local BtnCorner = Instance.new("UICorner", Button)
        BtnCorner.CornerRadius = UDim.new(0, 4)

        Button.MouseButton1Click:Connect(callback)
    end

    function API:AddToggle(toggleText, callback)
        -- (คุณสามารถเพิ่มโค้ดสร้างปุ่ม Toggle ที่นี่)
    end

    return API
end

return CustomUI
