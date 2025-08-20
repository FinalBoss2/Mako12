loadstring([[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
toggleButton.Text = "ESP OFF"
toggleButton.Parent = screenGui
toggleButton.Active = true
toggleButton.Draggable = true

local espEnabled = false
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0,255,0)
        toggleButton.Text = "ESP ON"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
        toggleButton.Text = "ESP OFF"
    end
end)

local function createESP(player)
    if player == LocalPlayer then return end
    local box = Instance.new("BillboardGui")
    box.Size = UDim2.new(0,100,0,50)
    box.StudsOffset = Vector3.new(0,3,0)
    box.AlwaysOnTop = true
    box.Parent = player:WaitForChild("Head")
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.Text = player.Name
    label.Parent = box
    return box
end

local espBoxes = {}

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if espEnabled and not espBoxes[player] then
            espBoxes[player] = createESP(player)
        elseif not espEnabled and espBoxes[player] then
            espBoxes[player]:Destroy()
            espBoxes[player] = nil
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updateESP()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player]:Destroy()
        espBoxes[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    updateESP()
end)
]])()
