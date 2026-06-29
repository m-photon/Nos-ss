-- DAN Ultimate Xeno Pilgrammed Auto Parry (Best One)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local on = true
local VirtualInputManager = game:GetService("VirtualInputManager")

local function parry()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.018)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not on then return end
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char and v:FindFirstChild("HumanoidRootPart") then
            if (v.HumanoidRootPart.Position - root.Position).Magnitude < 40 then
                parry()
                task.wait(0.045)
            end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightShift then
        on = not on
        print("DAN Auto Parry = " .. (on and "ON - GOATED" or "OFF"))
    end
end)

print("DAN Ultimate Xeno Auto Parry Ready. Right Shift to toggle. Get in their face.")
