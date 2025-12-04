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
		Position = UDim2.new(0, 15, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Text = "",
		Parent = ButtonFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = 2,
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
	
	-- Update element frame to use UIListLayout so button appears after title/desc
	local ListLayout = New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 8),
	})
	
	-- Add padding to prevent button from clipping window edge and bottom elements
	local FramePadding = New("UIPadding", {
		PaddingRight = UDim.new(0, 15),
		PaddingBottom = UDim.new(0, 10),
	})
	
	ButtonFrame.LabelHolder.LayoutOrder = 1
	ListLayout.Parent = ButtonFrame.Frame
	FramePadding.Parent = ButtonFrame.Frame
	
	-- Remove old frame references
	ButtonFrame.Frame.Size = UDim2.new(1, 0, 0, 0)
	ButtonFrame.Frame.AutomaticSize = Enum.AutomaticSize.Y
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

	Creator.AddSignal(ClickableButton.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end)

	return ButtonFrame
end

return Element
