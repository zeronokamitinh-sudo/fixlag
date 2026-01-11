-- 1. XÓA BẦU TRỜI TUYỆT ĐỐI (VOID MODE)
local lighting = game:GetService("Lighting")

-- Xóa các hiệu ứng bầu trời trong Lighting
for _, obj in pairs(lighting:GetDescendants()) do
    if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
        obj:Destroy()
    end
end

-- Ép màu môi trường về tối hoàn toàn
lighting.Ambient = Color3.fromRGB(0, 0, 0)
lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
lighting.ClockTime = 0 
lighting.Brightness = 0
lighting.GlobalShadows = false

-- 2. SIÊU TỐI ƯU VẬT THỂ (GIỮ NGUYÊN LOGIC NHƯNG TĂNG TỐC)
local function DeepClean(obj)
    pcall(function() -- Dùng pcall để tránh lỗi khi gặp vật thể bị khóa
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            if obj.Size.Magnitude > 1000 then 
                obj.Transparency = 1 
                obj.CanCollide = false
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion") then
            obj:Destroy()
        elseif obj:IsA("MeshPart") then
            obj.TextureID = ""
            obj.MeshId = "" -- Xóa cả Mesh để cực nhẹ nếu cần (tùy chọn)
        end
    end)
end

-- Quét workspace một cách an toàn
for _, v in pairs(workspace:GetDescendants()) do 
    DeepClean(v)
end
workspace.DescendantAdded:Connect(DeepClean)

-- 3. FPS RAINBOW (FIX VỊ TRÍ & HIỆU SUẤT)
local lp = game:GetService("Players").LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
if pgui:FindFirstChild("FPS_Void") then pgui["FPS_Void"]:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "FPS_Void"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true -- Tránh bị lệch do thanh trạng thái điện thoại
sg.Parent = pgui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = sg
-- Vị trí 0.72 như bạn chọn để né Joystick bên trái
fpsLabel.Position = UDim2.new(0.05, 0, 0.72, 0) 
fpsLabel.Size = UDim2.new(0, 150, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextSize = 24
fpsLabel.Font = Enum.Font.Arcade 
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local stroke = Instance.new("UIStroke", fpsLabel)
stroke.Thickness = 1.5

local RunService = game:GetService("RunService")
local lastUpdate = 0
local count = 0

RunService.RenderStepped:Connect(function(dt)
    -- Hiệu ứng Rainbow
    fpsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    
    count = count + 1
    lastUpdate = lastUpdate + dt
    
    if lastUpdate >= 0.5 then
        local fps = math.floor(count / lastUpdate)
        fpsLabel.Text = "FPS: " .. fps
        count = 0
        lastUpdate = 0
    end
end)
