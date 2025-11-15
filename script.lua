local VERSION = "2.0.0"
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local trackedObjects = {}
local rainbowHue = 0

local function sendNotification(title)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = "", Duration = 3})
    end)
end

local function getMainPart(obj)
    return obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
end

local function createESP(object, color, name)
    if trackedObjects[object] then return end
    local part = getMainPart(object)
    if not part then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.Parent = object
    
    local billboard = Instance.new("BillboardGui", part)
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 100)
    
    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.5
    
    trackedObjects[object] = {highlight, frame}
    sendNotification(name .. " Detected")
end

RunService.RenderStepped:Connect(function()
    rainbowHue = (rainbowHue + 1) % 360
    local color = Color3.fromHSV(rainbowHue / 360, 1, 1)
    for _, data in pairs(trackedObjects) do
        if data[2] then data[2].BackgroundColor3 = color end
    end
end)

repeat task.wait() until game:IsLoaded()
sendNotification("v" .. VERSION)

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == "PickUpBarrel" then
        createESP(obj, Color3.fromRGB(249, 226, 175), "Oil Barrel")
    elseif obj.Name == "Snake" and obj.Parent and obj.Parent.Name == "Animals" then
        createESP(obj, Color3.fromRGB(203, 166, 247), "Snake")
    elseif obj.Name == "Wendigo" or (obj.Name:lower():find("wendigo")) then
        createESP(obj, Color3.fromRGB(255, 50, 50), "Wendigo")
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "PickUpBarrel" then
        createESP(obj, Color3.fromRGB(249, 226, 175), "Oil Barrel")
    elseif obj.Name == "Snake" and obj.Parent and obj.Parent.Name == "Animals" then
        createESP(obj, Color3.fromRGB(203, 166, 247), "Snake")
    elseif obj.Name == "Wendigo" or (obj.Name:lower():find("wendigo")) then
        createESP(obj, Color3.fromRGB(255, 50, 50), "Wendigo")
    end
end)
