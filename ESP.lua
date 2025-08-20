-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "ESP OFF"
toggleButton.TextScaled = true
toggleButton.Parent = screenGui
toggleButton.Active = true
toggleButton.Draggable = true

local espEnabled = false
toggleButton.Activated:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.Text = "ESP ON"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "ESP OFF"
    end
end)

-- ESP Storage
local espBoxes = {}

-- Create ESP Box
local function createESP(player)
    if player == LocalPlayer then return end
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 50, 0, 100)
    box.BorderSizePixel = 2
    box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    box.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, -30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Parent = box

    return {box = box, label = label}
end

-- Update ESP
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if espEnabled then
                if not espBoxes[player] then
                    espBoxes[player] = createESP(player)
                end
                local data = espBoxes[player]
                if onScreen then
                    local distance = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    data.box.Position = UDim2.new(0, pos.X - 25, 0, pos.Y - 50)
                    data.label.Position = UDim2.new(0, 0, 0, -30)
                    data.label.Text = player.Name .. " [" .. distance .. "m]"
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end
            elseif espBoxes[player] then
                espBoxes[player].box:Destroy()
                espBoxes[player] = nil
            end
        end
    end
end

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player].box:Destroy()
        espBoxes[player] = nil
    end
end)

-- Run ESP
RunService.RenderStepped:Connect(updateESP)
