-- [[ ZERONOKAMI BLOX FRUIT - INSANE FPS BOOSTER ]]

local lighting = game:GetService("Lighting")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- 1. TRIỆT TIÊU HIỆU ỨNG MÔI TRƯỜNG & SÓNG BIỂN
pcall(function()
    -- Cấu hình Lighting ở mức tối giản nhất
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
    lighting.Brightness = 2
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Xóa các hiệu ứng hậu kỳ
    for _, obj in pairs(lighting:GetChildren()) do
        if obj:IsA("PostProcessEffect") or obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("SunRaysEffect") then
            obj.Parent = nil
        end
    end

    -- TỐI ƯU NƯỚC (WATER): Tắt sóng và phản chiếu
    if workspace:FindFirstChildOfClass("Terrain") then
        local terrain = workspace.Terrain
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end
end)

-- 2. HÀM DỌN DẸP CHIÊU THỨC (SKILL) & ĐỒ HỌA NẶNG
local function UltraClean(obj)
    pcall(function()
        -- Xóa hiệu ứng Skill (Blox Fruit thường dùng Particle và Highlight)
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj.Enabled = false
            obj.Lifetime = NumberRange.new(0)
        end
        
        -- Xóa viền phát sáng (Highlight) - nguyên nhân gây lag cực lớn trong combat
        if obj:IsA("Highlight") then
            obj:Destroy() 
        end

        -- Tối ưu vật thể
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("MeshPart") then
            obj.TextureID = ""
            obj.MeshId = obj.MeshId
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            -- Xóa các texture sóng biển dán trên mặt nước (nếu có)
            obj.Transparency = 1
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        end
    end)
end

-- 3. QUẢN LÝ VẬT THỂ SINH RA (COMBAT OPTIMIZATION)
-- Blox Fruit liên tục tạo ra vật thể khi dùng Skill, cần quét liên tục
workspace.DescendantAdded:Connect(function(v)
    -- Giới hạn quét để tránh quá tải CPU
    if v:IsA("BasePart") or v:IsA("ParticleEmitter") or v:IsA("Highlight") or v:IsA("MeshPart") then
        task.wait() -- Chờ load 1 chút rồi xóa
        UltraClean(v)
    end
end)

-- Quét toàn bộ map lúc bắt đầu
for _, v in pairs(workspace:GetDescendants()) do 
    UltraClean(v) 
end

-- 4. FPS RAINBOW & PING (FIX CỐ ĐỊNH)
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("FPS_Void") then pgui["FPS_Void"]:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "FPS_Void"
sg.ResetOnSpawn = false

local fpsLabel = Instance.new("TextLabel", sg)
fpsLabel.Position = UDim2.new(0.02, 0, 0.9, 0) -- Đưa xuống góc dưới bên trái cho gọn
fpsLabel.Size = UDim2.new(0, 300, 0, 30)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextSize = 18
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local stroke = Instance.new("UIStroke", fpsLabel)
stroke.Thickness = 1.2

local lastUpdate = 0
runService.RenderStepped:Connect(function(dt)
    fpsLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
    lastUpdate = lastUpdate + dt
    if lastUpdate >= 0.5 then
        local currentFps = math.floor(1/dt)
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():split(" ")[1]
        fpsLabel.Text = "ZERONOKAMI | FPS: " .. currentFps .. " | PING: " .. math.floor(ping) .. "ms"
        lastUpdate = 0
    end
end)

print("--- BLOX FRUIT INSANE OPTIMIZER READY ---")
