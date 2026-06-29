-- DAN Ultra Light Pilgrammed Auto Parry v3 (1 FPS Killer)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local ENABLED = true
local COOLDOWN = 0.13
local LAST_PARRY = 0
local RANGE = 25  -- Smaller = less lag

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local frameSkip = 0

local function pressParry()
    local now = tick()
    if now - LAST_PARRY < COOLDOWN then return end
    keypress(0x46)
    task.wait(0.02)
    keyrelease(0x46)
    LAST_PARRY = now
end

local function checkThreats()
    if not ENABLED or not root then return end
    
    local region = Region3.new(root.Position - Vector3.new(RANGE,RANGE,RANGE), root.Position + Vector3.new(RANGE,RANGE,RANGE))
    local parts = Workspace:FindPartsInRegion3WithIgnoreList(region, {character}, 30)  -- Max 30 parts
    
    for _, part in ipairs(parts) do
        local n = part.Name:lower()
        if n:find("attack") or n:find("projectile") or n:find("swing") or n:find("slash") or n:find("bullet") then
            if (part.Position - root.Position).Magnitude < RANGE and part.Velocity.Magnitude > 10 then
                pressParry()
                return
            end
        end
    end
end

-- Throttled check (runs every ~3 frames)
RunService.RenderStepped:Connect(function()
    frameSkip = frameSkip + 1
    if frameSkip % 3 == 0 then
        checkThreats()
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightShift then
        ENABLED = not ENABLED
        print("DAN Light Auto Parry: " .. (ENABLED and "ON" or "OFF"))
    end
end)

player.CharacterAdded:Connect(function(c)
    character = c
    root = c:WaitForChild("HumanoidRootPart")
end)

print("DAN Ultra Light Pilgrammed Auto Parry Loaded - Should be smooth now.")
