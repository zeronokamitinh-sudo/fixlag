-- 1. TỐI ƯU BẦU TRỜI (KHÔNG LÀM ĐEN THUI MÀN HÌNH)
local lighting = game:GetService("Lighting")

-- Xóa các hiệu ứng gây lag nhưng giữ lại ánh sáng cơ bản
for _, obj in pairs(lighting:GetDescendants()) do
    if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
        obj:Destroy()
    end
end

-- Chỉnh ánh sáng để nhìn thấy trong đêm (Không để về 0,0,0)
lighting.Ambient = Color3.fromRGB(100, 100, 100) -- Tăng độ sáng môi trường để thấy đường
lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
lighting.Brightness = 2
lighting.GlobalShadows = false -- Tắt đổ bóng để cực mượt
lighting.ClockTime = 14 -- Chỉnh về buổi trưa để đủ sáng (hoặc giữ nguyên nếu bạn muốn đêm)

-- 2. SIÊU TỐI ƯU VẬT THỂ (XÓA TEXTURE)
local function DeepClean(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj:Destroy()
    elseif obj:IsA("MeshPart") then
        obj.TextureID = ""
    end
end

for _, v in pairs(workspace:GetDescendants()) do DeepClean(v) end
workspace.DescendantAdded:Connect(DeepClean)

-- 3. FPS RAINBOW (FIX VỊ TRÍ NÉ JOYSTICK)
local pgui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
if pgui:FindFirstChild("FPS_Void") then pgui["FPS_Void"]:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "FPS_Void"
sg.ResetOnSpawn = false
sg.Parent = pgui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = sg
fpsLabel.Position = UDim2.new(0.05, 0, 0.65, 0) -- Đẩy lên cao hơn một chút để không bị ngón cái che
fpsLabel.Size = UDim2.new(0, 150, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextSize = 20
fpsLabel.Font = Enum.Font.Arcade 
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local stroke = Instance.new("UIStroke", fpsLabel)
stroke.Thickness = 2

local lastUpdate = 0
game:GetService("RunService").RenderStepped:Connect(function(dt)
    fpsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.8 then
        fpsLabel.Text = "ZERONOKAMI FPS: " .. math.floor(1/dt)
        lastUpdate = 0
    end
end)
