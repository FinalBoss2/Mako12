loadstring([[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- GUI Setup
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

local espEnabled = false
toggleButton.Activated:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0,255,0)
        toggleButton.Text = "ESP ON"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
        toggleButton.Text = "ESP OFF"
    end
end)

-- ESP Box Creation
local espBoxes = {}
local function createESP(player)
    if player == LocalPlayer then return end
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 50, 0, 100)
    box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    box.BorderSizePixel = 2
    box.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,20)
    label.Position = UDim2.new(0,0,0,-20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextScaled = true
    label.Text = player.Name
    label.Parent = box

    return {box=box, label=label}
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
            if espEnabled then
                if not espBoxes[player] then
                    espBoxes[player] = createESP(player)
                end
                local boxData = espBoxes[player]
                if onScreen then
                    boxData.box.Position = UDim2.new(0, pos.X-25, 0, pos.Y-50)
                    boxData.label.Position = UDim2.new(0,0,0,-20)
                    boxData.box.Visible = true
                else
                    boxData.box.Visible = false
                end
            elseif espBoxes[player] then
                espBoxes[player].box:Destroy()
                espBoxes[player] = nil
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player] then
        espBoxes[player].box:Destroy()
        espBoxes[player] = nil
    end
end)

RunService.RenderStepped:Connect(updateESP)
]])()
