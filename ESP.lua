local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI Setup
local gui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
gui.Name = "ESP_Toggle"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0, 100, 0, 100)
button.Text = "ESP OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Active = true
button.Draggable = true

local espEnabled = false
local espObjects = {}

-- Toggle ESP
button.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    button.Text = espEnabled and "ESP ON" or "ESP OFF"
    button.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- ESP Creation
local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Color = Color3.new(1, 1, 1)

    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.new(1, 1, 1)

    espObjects[player] = {
        box = box,
        nameTag = nameTag
    }
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player].box:Remove()
        espObjects[player].nameTag:Remove()
        espObjects[player] = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(removeESP)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createESP(player)
    end
end

-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    for player, obj in pairs(espObjects) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if espEnabled and onScreen then
                local distance = math.floor((hrp.Position - camera.CFrame.Position).Magnitude)

                obj.box.Size = Vector2.new(60, 80)
                obj.box.Position = Vector2.new(pos.X - 30, pos.Y - 40)
                obj.box.Visible = true

                obj.nameTag.Text = player.Name .. " [" .. distance .. "m]"
                obj.nameTag.Position = Vector2.new(pos.X, pos.Y - 50)
                obj.nameTag.Visible = true
            else
                obj.box.Visible = false
                obj.nameTag.Visible = false
            end
        else
            obj.box.Visible = false
            obj.nameTag.Visible = false
        end
    end
end)
