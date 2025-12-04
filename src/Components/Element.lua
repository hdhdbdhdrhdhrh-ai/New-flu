local Root = script.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Flipper.Spring.new

return function(Title, Desc, Parent, Hover, Border, GradientOptions)
	local Element = {}

	local titleLabelChildren = {}

	if GradientOptions and GradientOptions.Enabled then
		table.insert(titleLabelChildren, New("UIGradient", {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, GradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
				ColorSequenceKeypoint.new(1, GradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
			},
			Rotation = GradientOptions.Rotation or 0,
		}))
	end

	Element.TitleLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Text = Title,
		TextColor3 = (GradientOptions and GradientOptions.Enabled) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = (GradientOptions and GradientOptions.Enabled) and nil or "Text",
		},
	}, titleLabelChildren)

	Element.DescLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = Desc,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 14),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	Element.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -20, 0, 0),
		LayoutOrder = 1,
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 13),
			PaddingTop = UDim.new(0, 13),
		}),
		Element.TitleLabel,
		Element.DescLabel,
	})

	Element.Border = New("UIStroke", {
		Transparency = 0.3,
		Thickness = 0.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(100, 100, 100),
	})

	Element.BottomLine = New("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 3,
	}, {
		New("UIStroke", {
			Thickness = 0.5,
			Color = Color3.fromRGB(100, 100, 100),
			Transparency = 0.3,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
	})

	Element.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(130, 130, 130),
		Parent = Parent,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 7,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		}),
		Element.LabelHolder,
		Element.BottomLine,
	})

	function Element:SetTitle(Set)
		Element.TitleLabel.Text = Set
	end

	function Element:SetDesc(Set)
		if Set == nil then
			Set = ""
		end
		if Set == "" then
			Element.DescLabel.Visible = false
		else
			Element.DescLabel.Visible = true
		end
		Element.DescLabel.Text = Set
	end

	function Element:SetGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient if any
			local existingGradient = Element.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			
			-- Ensure base text color is white
			Element.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			Element.TitleLabel.ThemeTag = nil
			
			-- Create text gradient
			New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = Element.TitleLabel,
			})
		else
			-- Remove gradient if disabled and reset to default color
			local existingGradient = Element.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Element.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
			Element.TitleLabel.ThemeTag = { TextColor3 = "Text" }
		end
	end

	function Element:Destroy()
		Element.Frame:Destroy()
	end

	Element:SetTitle(Title)
	Element:SetDesc(Desc)

	if Hover then
		local Themes = Root.Themes
		local Motor, SetTransparency = Creator.SpringMotor(
			Creator.GetThemeProperty("ElementTransparency"),
			Element.Frame,
			"BackgroundTransparency",
			false,
			true
		)

		Creator.AddSignal(Element.Frame.MouseEnter, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseLeave, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Down, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Up, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
	end

	return Element
end
