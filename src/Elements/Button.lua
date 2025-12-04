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

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

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
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		),
	})

	local ButtonBox = New("TextButton", {
		Size = UDim2.new(0, 0, 0, 26),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 10, 1, 5),
		BackgroundTransparency = Config.Filled and 0 or 1,
		Parent = ButtonFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.X,
		Text = "",
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

	function ButtonFrame:UpdateColor()
		if Config.Filled then
			ButtonBox.BackgroundColor3 = self.Library.Accent
		else
			ButtonStroke.Color = self.Library.Accent
		end
	end

	ButtonFrame:UpdateColor()

	Creator.AddSignal(ButtonBox.MouseButton1Click, function()
		self.Library:SafeCallback(Config.Callback)
	end)

	return ButtonFrame
end

return Element
