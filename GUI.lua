local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- 🎨 สร้าง GUI เครื่องมือ "งัด UI (UI Hacker)"
-- ==========================================
local UI_Name = "UIHackerGridGUI"
local parentUI = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer.PlayerGui
if parentUI:FindFirstChild(UI_Name) then parentUI[UI_Name]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_Name
ScreenGui.Parent = parentUI

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 450) 
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 30) -- สีโทนม่วง Hacker
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 25, 45)
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 8) TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👁️ UI Hacker: บังคับเปิดหน้าต่างที่ซ่อนอยู่"
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 24)
CloseBtn.Position = UDim2.new(1, -45, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar
local CloseCorner = Instance.new("UICorner") CloseCorner.CornerRadius = UDim.new(0, 6) CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -40)
ContentArea.Position = UDim2.new(0, 0, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -40, 0, 40)
RefreshBtn.Position = UDim2.new(0, 20, 0, 15)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
RefreshBtn.Text = "🔄 สแกนหา UI ที่ซ่อนอยู่ทั้งหมด (Refresh)"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 14
RefreshBtn.Parent = ContentArea
local RCorner = Instance.new("UICorner") RCorner.CornerRadius = UDim.new(0, 6) RCorner.Parent = RefreshBtn

local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, -40, 1, -80)
ListFrame.Position = UDim2.new(0, 20, 0, 65)
ListFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 40)
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 8
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListFrame.Parent = ContentArea

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 212, 0, 40) 
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8) 
GridLayout.SortOrder = Enum.SortOrder.Name
GridLayout.Parent = ListFrame

-- ==========================================
-- 🧠 ระบบงัด UI (Force Open)
-- ==========================================
local function populateList()
    -- ล้างของเก่า
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    -- สแกนหา ScreenGui ทั้งหมดในจอเรา
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            local Btn = Instance.new("TextButton")
            Btn.Name = gui.Name
            
            -- ทำสีแยก: ถ้าถูกเปิดอยู่ให้เป็นสีเขียว ถ้าถูกซ่อนอยู่ให้เป็นสีเทา
            if gui.Enabled then
                Btn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
                Btn.Text = "👀 " .. gui.Name
            else
                Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Btn.Text = "🔒 " .. gui.Name
            end
            
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextTruncate = Enum.TextTruncate.AtEnd
            Btn.Parent = ListFrame
            local BCorner = Instance.new("UICorner") BCorner.CornerRadius = UDim.new(0, 6) BCorner.Parent = Btn
            
            -- เมื่อกดปุ่ม จะทำการงัด UI นั้นให้แสดงผลทันที!
            Btn.MouseButton1Click:Connect(function()
                -- บังคับเปิด ScreenGui
                gui.Enabled = not gui.Enabled
                
                -- ถ้าเปิด ให้มุดเข้าไปบังคับโชว์ Frame ข้างในด้วย (เพราะบางที ScreenGui เปิดแล้ว แต่ Frame ข้างในซ่อนอยู่)
                if gui.Enabled then
                    for _, child in ipairs(gui:GetChildren()) do
                        if child:IsA("Frame") or child:IsA("ScrollingFrame") or child:IsA("ImageLabel") then
                            child.Visible = true
                        end
                    end
                    Btn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
                    Btn.Text = "👀 " .. gui.Name
                else
                    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    Btn.Text = "🔒 " .. gui.Name
                end
            end)
        end
    end
end

populateList()
RefreshBtn.MouseButton1Click:Connect(populateList)
