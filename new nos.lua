-- DAN Pilgrammed Auto Parry v4 - Actually Works Edition
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local ENABLED = true
local COOLDOWN = 0.1
local LAST_PARRY = 0
local RANGE = 28

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local frameSkip = 0

local function pressParry()
    if tick() - LAST_PARRY < COOLDOWN then return end
    keypress(0x46)   -- F
    task.wait(0.025)
    keyrelease(0x46)
    LAST_PARRY = tick()
    print("🛡️ DAN PARRIED")
end

local function isThreat(part)
    local n = part.Name:lower()
    local vel = part.Velocity.Magnitude
    return (n:find("attack") or n:find("projectile") or n:find("swing") or 
            n:find("slash") or n:find("hitbox") or n:find("bullet") or 
            n:find("orb") or vel > 15)  -- Broad + velocity check
end

local function checkForAttacks()
    if not ENABLED or not root then return end
    
    local region = Region3.new(root.Position - Vector3.new(RANGE, RANGE*1.5, RANGE), 
                               root.Position + Vector3.new(RANGE, RANGE*1.5, RANGE))
    
    local parts = Workspace:FindPartsInRegion3WithIgnoreList(region, {character}, 40)
    
    for _, part in ipairs(parts) do
        if isThreat(part) then
            local dist = (part.Position - root.Position).Magnitude
            if dist < RANGE then
                pressParry()
                return
            end
        end
    end
end

-- Throttled but responsive
RunService.RenderStepped:Connect(function()
    frameSkip += 1
    if frameSkip % 2 == 0 then  -- Every other frame
        checkForAttacks()
    end
end)

-- Manual test parry on P key
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        pressParry()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        ENABLED = not ENABLED
        print("Auto Parry ".. (ENABLED and "ENABLED" or "DISABLED"))
    end
end)

player.CharacterAdded:Connect(function(new)
    character = new
    root = new:WaitForChild("HumanoidRootPart")
end)

print("DAN Pilgrammed Auto Parry v4 Loaded! Press P to test manual parry. RightShift to toggle auto.")
