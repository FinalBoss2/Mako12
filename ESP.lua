-- Executor-Ready LocalScript
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera     = workspace.CurrentCamera
local localPlayer= Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name   = "ESP_Toggle_GUI"
gui.Parent = localPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size              = UDim2.new(0, 200, 0, 60)
button.Position          = UDim2.new(0, 100, 0, 100)
button.Text              = "ESP OFF"
button.BackgroundColor3  = Color3.fromRGB(255, 0, 0)
button.TextColor3        = Color3.new(1, 1, 1)
button.Font              = Enum.Font.SourceSansBold
button.TextSize          = 24
button.Active            = true
button.Draggable         = true
button.Parent            = gui

-- ESP state
local espEnabled = false
local espObjects = {}

-- Toggle logic
button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        button.Text = "ESP ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        button.Text = "ESP OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Create/Remove ESP visual for a player
local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled     = false
    box.Color      = Color3.fromRGB(0, 255, 0)

    local nameTag = Drawing.new("Text")
    nameTag.Size    = 16
    nameTag.Center  = true
    nameTag.Outline = true
    nameTag.Color   = Color3.new(1, 1, 1)

    espObjects[player] = { box = box, nameTag = nameTag }
end

local function removeESP(player)
    local obj = espObjects[player]
    if obj then
        obj.box:Remove()
        obj.nameTag:Remove()
        espObjects[player] = nil
    end
end

-- Track players joining/leaving
Players.PlayerAdded:Connect(function(plr)
    if plr ~= localPlayer then
        createESP(plr)
    end
end)

Players.PlayerRemoving:Connect(removeESP)

-- Initialize existing players
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= localPlayer then
        createESP(plr)
    end
end

-- Update loop
RunService.RenderStepped:Connect(function()
    for player, obj in pairs(espObjects) do
        local char = player.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if espEnabled and hrp then
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = math.floor((hrp.Position - camera.CFrame.Position).Magnitude)

                obj.box.Size     = Vector2.new(60, 80)
                obj.box.Position = Vector2.new(pos.X - 30, pos.Y - 40)
                obj.box.Visible  = true

                obj.nameTag.Text     = player.Name .. " [" .. dist .. "m]"
                obj.nameTag.Position = Vector2.new(pos.X, pos.Y - 50)
                obj.nameTag.Visible  = true
            else
                obj.box.Visible     = false
                obj.nameTag.Visible = false
            end
        else
            obj.box.Visible     = false
            obj.nameTag.Visible = false
        end
    end
end)
