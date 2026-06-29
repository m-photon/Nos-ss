-- DAN's Ultra Optimized Pilgrammed Auto Parry (Lag-Free 2026)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local ENABLED = true
local COOLDOWN = 0.12
local LAST_PARRY = 0
local RANGE = 30

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local connections = {}

local function pressParry()
    local now = tick()
    if now - LAST_PARRY < COOLDOWN then return end
    keypress(0x46)
    task.wait(0.025)
    keyrelease(0x46)
    LAST_PARRY = now
end

-- Smarter detection (only check moving parts near you)
local function checkForThreats()
    if not ENABLED or not root then return end
    
    local region = Region3.new(root.Position - Vector3.new(RANGE, RANGE, RANGE), 
                               root.Position + Vector3.new(RANGE, RANGE, RANGE))
    
    for _, part in ipairs(Workspace:FindPartsInRegion3WithIgnoreList(region, {character}, 50)) do
        local name = part.Name:lower()
        if name:find("attack") or name:find("projectile") or name:find("swing") or 
           name:find("slash") or name:find("bullet") or name:find("ball") then
            if (part.Position - root.Position).Magnitude < RANGE and part.Velocity.Magnitude > 8 then
                pressParry()
                break
            end
        end
    end
end

-- Run less often to save performance
table.insert(connections, RunService.Heartbeat:Connect(function()
    checkForThreats()
end))

-- Toggle
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ENABLED = not ENABLED
        print("DAN Auto Parry: " .. (ENABLED and "ENABLED (Lag Fixed)" or "DISABLED"))
    end
end)

-- Cleanup on death
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart")
end)

print("✅ DAN Optimized Pilgrammed Auto Parry Loaded - Much smoother now. Right Shift to toggle.")
