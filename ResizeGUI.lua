-- Simple Resize GUI Tool
-- Creates a resizable frame that shows its size and has a copy button

-- Create the main frame
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(300, 200)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Size display label
local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(1, -20, 0, 30)
SizeLabel.Position = UDim2.fromOffset(10, 10)
SizeLabel.BackgroundTransparency = 1
SizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeLabel.Font = Enum.Font.SourceSansBold
SizeLabel.TextSize = 16
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.Parent = MainFrame

-- Copy button
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -20, 0, 40)
CopyButton.Position = UDim2.new(0, 10, 1, -50)
CopyButton.AnchorPoint = Vector2.new(0, 1)
CopyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 14
CopyButton.Text = "Copy Size"
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

-- Resize handle
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.fromOffset(20, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
ResizeHandle.BorderSizePixel = 1
ResizeHandle.Parent = MainFrame

-- Make the frame draggable
local Dragging = false
local DragInput
local DragStart
local StartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not Resizing then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

-- Resizing logic
local Resizing = false
local ResizeStart
local StartSize

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Resizing = true
        ResizeStart = input.Position
        StartSize = MainFrame.Size

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Resizing = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and Resizing then
        local Delta = input.Position - ResizeStart
        local NewWidth = math.max(150, StartSize.X.Offset + Delta.X)
        local NewHeight = math.max(100, StartSize.Y.Offset + Delta.Y)
        MainFrame.Size = UDim2.fromOffset(NewWidth, NewHeight)
    end
end)

-- Update size label
local function UpdateSizeLabel()
    SizeLabel.Text = string.format("Size: UDim2.fromOffset(%d, %d)", MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
end

MainFrame:GetPropertyChangedSignal("Size"):Connect(UpdateSizeLabel)
UpdateSizeLabel()

-- Copy button functionality
CopyButton.MouseButton1Click:Connect(function()
    local sizeStr = string.format("UDim2.fromOffset(%d, %d)", MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
    if setclipboard then
        setclipboard(sizeStr)
        CopyButton.Text = "Copied!"
        wait(1)
        CopyButton.Text = "Copy Size"
    else
        CopyButton.Text = "No clipboard"
        wait(1)
        CopyButton.Text = "Copy Size"
    end
end)

print("Resize GUI Tool loaded! Drag the frame to move, drag the corner to resize, and click Copy Size.")