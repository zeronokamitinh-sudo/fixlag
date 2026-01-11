-- 1. XÓA BẦU TRỜI TUYỆT ĐỐI (VOID MODE)
local lighting = game:GetService("Lighting")

-- Xóa các hiệu ứng bầu trời chuẩn
lighting:ClearAllChildren()
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
        obj:Destroy()
    end
end

-- Ép màu môi trường về tối để triệt tiêu màu bầu trời cũ
lighting.Ambient = Color3.fromRGB(0, 0, 0)
lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
lighting.ClockTime = 0 -- Chuyển sang ban đêm để bầu trời đen thui

-- 2. SIÊU TỐI ƯU VẬT THỂ (Xóa Texture & Mesh)
local function DeepClean(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
        -- Xóa các khối Part khổng lồ dùng làm bầu trời giả
        if obj.Size.Magnitude > 1000 then 
            obj.Transparency = 1 
            obj.CanCollide = false
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj:Destroy()
    elseif obj:IsA("MeshPart") then
        obj.TextureID = ""
    end
end

for _, v in pairs(workspace:GetDescendants()) do DeepClean(v) end
workspace.DescendantAdded:Connect(DeepClean)

-- 3. FPS RAINBOW (GÓC TRÁI DƯỚI - NÉ JOYSTICK)
local pgui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("FPS_Void") then pgui["FPS_Void"]:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "FPS_Void"
sg.ResetOnSpawn = false
sg.DisplayOrder = 9999
sg.Parent = pgui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = sg
fpsLabel.Position = UDim2.new(0.05, 0, 0.72, 0) -- Vị trí tối ưu trên điện thoại
fpsLabel.Size = UDim2.new(0, 150, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextSize = 26
fpsLabel.Font = Enum.Font.Arcade 
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local stroke = Instance.new("UIStroke", fpsLabel)
stroke.Thickness = 2

local lastUpdate = 0
game:GetService("RunService").RenderStepped:Connect(function(dt)
    fpsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        fpsLabel.Text = "FPS: " .. math.floor(1/dt)
        lastUpdate = 0
    end
end)
