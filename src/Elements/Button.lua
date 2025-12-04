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

	-- Make the button right under the title
	ButtonFrame.Frame.Size = UDim2.new(1, -20, 0, 26)
	ButtonFrame.Frame.AutomaticSize = Enum.AutomaticSize.None
	ButtonFrame.Frame.Position = UDim2.new(0, 10, 0, 19)
	ButtonFrame.Frame.BackgroundTransparency = 1
	ButtonFrame.Frame.BorderSizePixel = 0
	ButtonFrame.Border.Transparency = 1
	
	-- Convert Frame to TextButton
	local ClickableButton = New("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = Config.Filled and 0 or 1,
		Position = UDim2.fromOffset(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Text = "",
		Parent = ButtonFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.None,
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
	
	-- Remove the old frame
	ButtonFrame.Frame:Destroy()
	ButtonFrame.Frame = ClickableButton

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
