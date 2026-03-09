-- โค้ดใน GitHub (source.lua)
local Library = {}

function Library:CreateWindow(titleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "CustomUI_" .. math.random(100, 999)

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 450, 0, 320)
    Main.Position = UDim2.new(0.5, -225, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true -- ทำให้ลากได้
    Main.Parent = ScreenGui

    -- ทำให้มุมโค้งมน
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "  " .. titleText
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1
    Title.Parent = Main

    local ButtonContainer = Instance.new("ScrollingFrame")
    ButtonContainer.Size = UDim2.new(1, -20, 1, -50)
    ButtonContainer.Position = UDim2.new(0, 10, 0, 45)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.ScrollBarThickness = 2
    ButtonContainer.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = ButtonContainer

    local API = {}
    function API:AddButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Btn.Text = text
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.Parent = ButtonContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 5)
        BtnCorner.Parent = Btn

        Btn.MouseButton1Click:Connect(callback)
    end

    return API
end

return Library
