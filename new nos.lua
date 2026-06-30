-- DAN Debug Auto Parry - Toggle on P key
local player = game.Players.LocalPlayer
local ENABLED = false

print("DAN Script Loaded - Press P to toggle Auto Parry")

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        ENABLED = not ENABLED
        print("=== AUTO PARRY " .. (ENABLED and "ENABLED 🔥" or "DISABLED") .. " ===")
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if not ENABLED then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj ~= char then
            local dist = (obj.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist < 35 then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.02)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                print("PARRIED on enemy at " .. math.floor(dist) .. " studs")
                task.wait(0.08)
                break
            end
        end
    end
end)

print("Press P to toggle. Stand close to enemies and watch for PARRIED messages.")
