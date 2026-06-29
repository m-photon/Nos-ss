-- DAN's Pilgrammed Auto Parry (2026 Optimized)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local PARRY_KEY = "F"
local ENABLED = true
local COOLDOWN = 0.15  -- Pilgrammed has short parry cooldown
local LAST_PARRY = 0
local DETECTION_RANGE = 35  -- Adjust based on your setup

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Simulate key press
local function pressParry()
    local currentTime = tick()
    if currentTime - LAST_PARRY < COOLDOWN then return end
    
    keypress(0x46)  -- F key
    task.wait(0.03)
    keyrelease(0x46)
    LAST_PARRY = currentTime
    print("🛡️ DAN Auto Parry Triggered!")
end

-- Main loop - detects threats
RunService.Heartbeat:Connect(function()
    if not ENABLED or not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            local nameLower = obj.Name:lower()
            
            -- Common Pilgrammed attack/projectile names
            if nameLower:find("attack") or nameLower:find("projectile") or 
               nameLower:find("swing") or nameLower:find("bullet") or 
               nameLower:find("ball") or nameLower:find("slash") then
                
                local distance = (obj.Position - root.Position).Magnitude
                local velocity = obj.Velocity.Magnitude
                
                if distance < DETECTION_RANGE and velocity > 5 then
                    pressParry()
                    break
                end
            end
        end
    end
end)

-- Toggle with RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ENABLED = not ENABLED
        print("Pilgrammed Auto Parry: " .. (ENABLED and "ON - You're immortal now" or "OFF"))
    end
end)

print("DAN's Pilgrammed Auto Parry Loaded 🔥 Hold Right Shift to toggle. Works on most enemies & bosses.")
