local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Config)
	assert(Config.Title, "Button - Missing Title")
	Config.Callback = Config.Callback or function() end

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)

	local ButtonStroke = New("UIStroke", {
		Thickness = 0.6,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	local ButtonText = New("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = Config.ButtonText or "Button",
		TextColor3 = Config.TextColor or Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
	})

	-- Create button as separate element below title/desc
	local ClickableButton = New("TextButton", {
		Size = UDim2.new(0, 0, 0, 26),
		BackgroundTransparency = Config.Filled and 0 or 1,
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Text = "",
		Parent = ButtonFrame.LabelHolder,
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 3,
		ClipsDescendants = true,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),
		ButtonStroke,
		ButtonText,
	})
	
	-- Set layout orders so button appears after title and description
	ButtonFrame.TitleLabel.LayoutOrder = 1
	ButtonFrame.DescLabel.LayoutOrder = 2
	
	-- Add spacing above button
	local ButtonSpacing = New("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		BackgroundTransparency = 1,
		LayoutOrder = 2.5,
		Parent = ButtonFrame.LabelHolder,
	})
	
	-- Button is now part of LabelHolder layout, will appear naturally below desc
	ButtonFrame.Frame.BackgroundTransparency = 1
	ButtonFrame.Frame.BorderSizePixel = 0
	ButtonFrame.Border.Transparency = 1

	function ButtonFrame:UpdateColor()
		if Config.Filled then
			ClickableButton.BackgroundColor3 = self.Library.Accent
		else
			ButtonStroke.Color = self.Library.Accent
		end
	end

	ButtonFrame:UpdateColor()

	-- Add hover effect
	Creator.AddSignal(ClickableButton.MouseEnter, function()
		ClickableButton.BackgroundTransparency = Config.Filled and 0.1 or 0.95
	end)
	
	Creator.AddSignal(ClickableButton.MouseLeave, function()
		ClickableButton.BackgroundTransparency = Config.Filled and 0 or 1
	end)
	
	-- Add smooth click effect with tweens
	local TweenService = game:GetService("TweenService")
	local clickTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	Creator.AddSignal(ClickableButton.MouseButton1Down, function()
		local clickDownTween = TweenService:Create(ClickableButton, clickTweenInfo, {
			Size = UDim2.new(0, -2, 0, 24),
			BackgroundTransparency = Config.Filled and 0.2 or 0.9
		})
		clickDownTween:Play()
	end)
	
	Creator.AddSignal(ClickableButton.MouseButton1Up, function()
		local clickUpTween = TweenService:Create(ClickableButton, clickTweenInfo, {
			Size = UDim2.new(0, 0, 0, 26),
			BackgroundTransparency = Config.Filled and 0 or 1
		})
		clickUpTween:Play()
	end)

	Creator.AddSignal(ClickableButton.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end)

	return ButtonFrame
end

return Element
