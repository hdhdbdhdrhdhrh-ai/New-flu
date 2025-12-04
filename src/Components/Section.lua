local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New

return function(Title, Parent, DefaultOpen)
	local Section = {}
	
	DefaultOpen = DefaultOpen or false
	
	-- Main section frame
	Section.Root = New("Frame", {
		Size = UDim2.new(1, -10, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Parent,
		LayoutOrder = 7,
	})
	
	-- Section header (clickable)
	Section.Header = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BackgroundTransparency = 0.1,
		Text = "",
		Parent = Section.Root,
		AutomaticSize = Enum.AutomaticSize.None,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("UIStroke", {
			Transparency = 0.7,
			Color = Color3.fromRGB(60, 60, 60),
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
	})
	
	-- Section title text
	Section.TitleLabel = New("TextLabel", {
		Size = UDim2.new(1, -40, 1, 0),
		Position = UDim2.fromOffset(15, 0),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		),
		Parent = Section.Header,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})
	
	-- Arrow icon
	Section.Arrow = New("ImageLabel", {
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.new(1, -25, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6034818372",
		ImageColor3 = Color3.fromRGB(180, 180, 180),
		Rotation = DefaultOpen and 90 or -90,
		Parent = Section.Header,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})
	
	-- Content container
	Section.Container = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.fromOffset(0, 35),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Section.Root,
		Visible = DefaultOpen,
		ClipsDescendants = false,
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 5),
		}),
	})
	
	-- Layout for container
	Section.Layout = Section.Container:FindFirstChild("UIListLayout")
	
	-- State
	Section.Open = DefaultOpen
	
	-- Toggle function
	function Section:Toggle()
		Section.Open = not Section.Open
		
		-- Animate arrow rotation
		local TweenService = game:GetService("TweenService")
		local rotationTween = TweenService:Create(
			Section.Arrow,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Rotation = Section.Open and 90 or -90 }
		)
		
		rotationTween:Play()
		
		if Section.Open then
			Section.Container.Visible = true
		else
			Section.Container.Visible = false
		end
	end
	
	-- Set title function
	function Section:SetTitle(NewTitle)
		Section.TitleLabel.Text = NewTitle
	end
	
	-- Click handler
	Creator.AddSignal(Section.Header.MouseButton1Click, function()
		Section:Toggle()
	end)
	
	-- Hover effect
	Creator.AddSignal(Section.Header.MouseEnter, function()
		Section.Header.BackgroundTransparency = 0.05
	end)
	
	Creator.AddSignal(Section.Header.MouseLeave, function()
		Section.Header.BackgroundTransparency = 0.1
	end)
	
	-- Auto-resize based on content
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
		Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 45)
	end)
	
	return Section
end
