local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 🎨 สร้าง GUI ปุ่มล็อคตำแหน่ง (Position Locker)
-- ==========================================
local UI_Name = "PositionLockerGUI"
local parentUI = pcall(function() return CoreGui.Name end) and CoreGui or LocalPlayer.PlayerGui
if parentUI:FindFirstChild(UI_Name) then parentUI[UI_Name]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_Name
ScreenGui.Parent = parentUI

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 50)
MainFrame.Position = UDim2.new(0.5, 0, 0, 20) -- โผล่ตรงกลางจอด้านบน
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ใช้เมาส์ลากย้ายที่ได้
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -10, 1, -10)
ToggleBtn.Position = UDim2.new(0, 5, 0, 5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "🔓 ล็อคตำแหน่ง: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame
local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 6) BtnCorner.Parent = ToggleBtn

-- ==========================================
-- 🧠 ระบบลอจิกดึงตัวกลับ (Absolute Anchor)
-- ==========================================
local isLocked = false
local savedCFrame = nil
local lockConnection = nil

ToggleBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    
    if isLocked then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- 1. บันทึกจุดที่ยืนอยู่ปัจจุบันเป๊ะๆ
            savedCFrame = hrp.CFrame
            
            -- 2. เปลี่ยนสีปุ่มเป็นสีเขียว
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
            ToggleBtn.Text = "🔒 ล็อคตำแหน่ง: ON"
            
            -- 3. เริ่มกระบวนการกระชากตัวกลับทุกเฟรมเรนเดอร์
            lockConnection = RunService.Heartbeat:Connect(function()
                local currentChar = LocalPlayer.Character
                local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar and currentChar:FindFirstChild("Humanoid")
                
                if currentHrp and currentHum and currentHum.Health > 0 and savedCFrame then
                    -- หยุดแรงเหวี่ยง/การพุ่งของสกิล
                    currentHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    currentHrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    -- บังคับวางที่พิกัดเดิมทันที
                    currentHrp.CFrame = savedCFrame
                end
            end)
        else
            -- กรณีหาตัวละครไม่เจอ (เช่น กำลังตาย)
            isLocked = false
            ToggleBtn.Text = "❌ รอตัวละครเกิด..."
            task.wait(1)
            ToggleBtn.Text = "🔓 ล็อคตำแหน่ง: OFF"
        end
    else
        -- ปิดการทำงาน ยกเลิกการดึงตัว
        if lockConnection then
            lockConnection:Disconnect()
            lockConnection = nil
        end
        savedCFrame = nil
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = "🔓 ล็อคตำแหน่ง: OFF"
    end
end)
