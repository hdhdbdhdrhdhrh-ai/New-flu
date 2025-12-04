local Root = script.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)
local New = Creator.New

local Spring = Flipper.Spring.new

-- Util: normalize various gradient input shapes into a ColorSequence and other UIGradient props
local function normalizeGradientOptions(options)
	if typeof(options) ~= "table" then
		return nil
	end
	if options.Enabled ~= true then
		return { enabled = false }
	end
	-- Build ColorSequence
	local sequence
	if options.Sequence and typeof(options.Sequence) == "ColorSequence" then
		sequence = options.Sequence
	elseif options.Colors and typeof(options.Colors) == "table" and #options.Colors >= 2 then
		local keypoints = {}
		local n = #options.Colors
		for i, c in ipairs(options.Colors) do
			local t = (i - 1) / (n - 1)
			keypoints[#keypoints + 1] = ColorSequenceKeypoint.new(t, c)
		end
		sequence = ColorSequence.new(keypoints)
	else
		-- Fallback to Color1/Color2 (backwards compatible)
		local c1 = options.Color1 or Color3.fromRGB(0, 150, 0)
		local c2 = options.Color2 or Color3.fromRGB(0, 255, 150)
		sequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, c1),
			ColorSequenceKeypoint.new(1, c2),
		})
	end
	local rotation = options.Rotation or 0
	local offset = options.Offset
	if offset and typeof(offset) == "table" then
		-- allow {x, y}
		offset = Vector2.new(offset[1] or 0, offset[2] or 0)
	end
	if offset and typeof(offset) ~= "Vector2" then
		offset = nil
	end
	local transparency = options.Transparency -- optional NumberSequence
	return {
		enabled = true,
		sequence = sequence,
		rotation = rotation,
		offset = offset,
		transparency = transparency,
	}
end

local function removeGradientFrom(label)
	local g = label:FindFirstChildOfClass("UIGradient")
	if g then g:Destroy() end
end

local function applyGradientToLabel(label, themeResetColor,
	options)
	warn("[ELEMENT DEBUG] applyGradientToLabel called")
	warn("[ELEMENT DEBUG] label name:", label.Name or "unnamed")
	warn("[ELEMENT DEBUG] options type:", typeof(options))

	local info = normalizeGradientOptions(options)
	warn("[ELEMENT DEBUG] normalizeGradientOptions returned info.enabled:", info and info.enabled or "nil")

	if not info or info.enabled == false then
		warn("[ELEMENT DEBUG] Gradient disabled or invalid, removing gradient")
		removeGradientFrom(label)
		label.TextColor3 = themeResetColor
		return
	end

	warn("[ELEMENT DEBUG] Applying gradient NOW!")
	removeGradientFrom(label)

	-- Remove from theme registry to prevent theme system from overriding the gradient color
	if Creator.Registry and Creator.Registry[label] then
		local registryData = Creator.Registry[label]
		warn("[ELEMENT DEBUG] Found label in theme registry")
		if registryData and registryData.Properties then
			warn("[ELEMENT DEBUG] Removing TextColor3 from theme properties")
			registryData.Properties.TextColor3 = nil
		end
	else
		warn("[ELEMENT DEBUG] Label NOT found in theme registry")
	end

	-- Ensure white base so gradient is vivid
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	warn("[ELEMENT DEBUG] Set label TextColor3 to white")

	local props = {
		Color = info.sequence,
		Rotation = info.rotation,
		Parent = label,
	}
	if info.offset then props.Offset = info.offset end
	if info.transparency and typeof(info.transparency) == "NumberSequence" then
		props.Transparency = info.transparency
	end

	New("UIGradient", props)
	warn("[ELEMENT DEBUG] UIGradient created successfully!")
end

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

	-- Rewritten gradient API: robust and flexible
	function Element:SetTitleGradient(options)
		applyGradientToLabel(Element.TitleLabel, Color3.fromRGB(240, 240, 240), options)
	end

	function Element:SetDescGradient(options)
		applyGradientToLabel(Element.DescLabel, Color3.fromRGB(200, 200, 200), options)
	end

	-- Convenience: set gradients by target: "Title" (default), "Desc", or "Both"
	function Element:SetGradient(options)
		local target = options and options.Target or "Title"
		if target == "Both" then
			self:SetTitleGradient(options)
			self:SetDescGradient(options)
		elseif target == "Desc" then
			self:SetDescGradient(options)
		else
			self:SetTitleGradient(options)
		end
	end

	-- If Gradient param is provided on creation, apply it
	warn("[ELEMENT DEBUG] Element creation - Gradient param type:", typeof(Gradient))
	if Gradient and type(Gradient) == "table" then
		warn("[ELEMENT DEBUG] Gradient is a table, applying...")
		-- Backwards-compatible: a single table applies to title; apply to desc if Desc = true
		if Gradient.Title then
			warn("[ELEMENT DEBUG] Applying gradient to title from Gradient.Title")
			Element:SetTitleGradient(Gradient.Title)
		else
			warn("[ELEMENT DEBUG] Applying gradient to title from Gradient directly")
			Element:SetTitleGradient(Gradient)
		end
		if Gradient.Desc == true then
			warn("[ELEMENT DEBUG] Applying gradient to desc (Desc=true)")
			Element:SetDescGradient(Gradient)
		elseif type(Gradient.Desc) == "table" then
			warn("[ELEMENT DEBUG] Applying gradient to desc from Gradient.Desc table")
			Element:SetDescGradient(Gradient.Desc)
		end
	else
		warn("[ELEMENT DEBUG] No gradient provided or invalid type")
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
