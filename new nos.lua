-- DAN Full GUI Auto Parry for Pilgrammed (Xeno)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLibV3/main/Library.lua"))()
local Window = Library:CreateWindow({Title = "DAN Pilgrammed Auto Parry", Center = true, AutoShow = true})

local Tab = Window:AddTab("Main")
local AutoParry = Tab:AddLeftGroupbox("Auto Parry")

local enabled = false
local range = 40

AutoParry:AddToggle("AutoParryToggle", {Text = "Enable Auto Parry", Default = false, Callback = function(v) enabled = v end})
AutoParry:AddSlider("RangeSlider", {Text = "Detection Range", Default = 40, Min = 10, Max = 80, Rounding = 0, Callback = function(v) range = v end})

local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

RunService.Heartbeat:Connect(function()
    if not enabled then return end
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart.Position
    
    for _, enemy in ipairs(workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy ~= char then
            if (enemy.HumanoidRootPart.Position - root).Magnitude < range then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.015)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                task.wait(0.04)
            end
        end
    end
end)

print("DAN Full GUI Auto Parry Loaded - Open with RightCtrl or click the window")
