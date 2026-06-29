-- DAN Pilgrammed Auto Parry v5 - Animation Based (Actually Works)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local ENABLED = true
local PARRY_COOLDOWN = 0.08

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local lastParry = 0

local function parry()
    if tick() - lastParry < PARRY_COOLDOWN then return end
    keypress(0x46)
    task.wait(0.015)
    keyrelease(0x46)
    lastParry = tick()
end

-- Main loop - check nearby enemies for attack animations
RunService.Heartbeat:Connect(function()
    if not ENABLED then return end
    
    for _, enemy in ipairs(workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy ~= character then
            local dist = (enemy.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            if dist < 35 then  -- Close enemy
                local animTrack = enemy.Humanoid:FindFirstChildOfClass("Animator")
                if animTrack then
                    -- If enemy is playing any animation (attacking), parry
                    for _, track in ipairs(animTrack:GetPlayingAnimationTracks()) do
                        if track.IsPlaying and track.Animation then
                            parry()
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Toggle + Manual
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ENABLED = not ENABLED
        print("DAN Auto Parry: " .. (ENABLED and "ON 🔥" or "OFF"))
    elseif input.KeyCode == Enum.KeyCode.P then
        parry()  -- Manual test
    end
end)

print("DAN v5 Pilgrammed Auto Parry Loaded - Uses enemy animations. Press P to test. RightShift toggle.")
