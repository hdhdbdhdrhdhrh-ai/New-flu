local Root = script.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Flipper.Spring.new

return function(Title, Desc, Parent, Hover, Border, Gradient)
	local Element = {}

	Element.TitleLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Text = Title,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

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
		Element.Border,
		Element.LabelHolder,
		Element.BottomLine,
	})

	-- Honor Border config: if false, hide border stroke and bottom line
	if Border == false then
		Element.Border.Transparency = 1
		Element.BottomLine.BackgroundTransparency = 1
	end

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

	-- Set title gradient: takes a table { Enabled = boolean, Color1 = Color3, Color2 = Color3, Rotation = number }
	function Element:SetTitleGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient if any
			local existingGradient = Element.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			-- Ensure base text color is white
			Element.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			-- Create the UIGradient
			New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = Element.TitleLabel,
			})
		else
			local existingGradient = Element.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Element.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		end
	end

	-- Set description gradient (same behavior as title gradient)
	function Element:SetDescGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			local existingGradient = Element.DescLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Element.DescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = Element.DescLabel,
			})
		else
			local existingGradient = Element.DescLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Element.DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end

	-- If Gradient param is provided on creation, apply it to title and desc accordingly
	if Gradient then
		if type(Gradient) == "table" then
			-- Apply to title (if present)
			Element:SetTitleGradient(Gradient)
			-- If gradient specifies Desc = true, apply to desc as well
			if Gradient.Desc then
				Element:SetDescGradient(Gradient)
			end
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
