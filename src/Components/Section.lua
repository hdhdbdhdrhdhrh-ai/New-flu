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
	
	-- Top separator line
	Section.TopLine = New("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = Section.Root,
	})
	
	-- Section header (clickable, transparent)
	Section.Header = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,
		Text = "",
		Parent = Section.Root,
	})
	
	-- Section title text with gradient support
	Section.TitleLabel = New("TextLabel", {
		Size = UDim2.new(1, -30, 1, 0),
		Position = UDim2.fromOffset(5, 0),
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
	})
	
	-- Bottom separator line
	Section.BottomLine = New("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 35),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = Section.Root,
	})
	
	-- Arrow icon
	Section.Arrow = New("ImageLabel", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(1, -20, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6034818372",
		ImageColor3 = Color3.fromRGB(150, 150, 150),
		Rotation = DefaultOpen and 0 or 90,
		Parent = Section.Header,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})
	
	-- Content container
	Section.Container = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.fromOffset(0, 36),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = Section.Root,
		Visible = DefaultOpen,
		ClipsDescendants = true,
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 8),
		}),
	})
	
	-- Layout for container
	Section.Layout = Section.Container:FindFirstChild("UIListLayout")
	
	-- State
	Section.Open = DefaultOpen
	
	-- Toggle function
	function Section:Toggle()
		Section.Open = not Section.Open
		
		local TweenService = game:GetService("TweenService")
		
		-- Animate arrow rotation (90 = closed pointing right, 0 = open pointing down)
		local rotationTween = TweenService:Create(
			Section.Arrow,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Rotation = Section.Open and 0 or 90 }
		)
		rotationTween:Play()
		
		if Section.Open then
			-- Opening animation
			Section.Container.Visible = true
			Section.Container.Size = UDim2.new(1, 0, 0, 0)
			
			local contentHeight = Section.Layout.AbsoluteContentSize.Y + 13  -- padding
			
			-- Animate container expansion
			local expandTween = TweenService:Create(
				Section.Container,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.new(1, 0, 0, contentHeight) }
			)
			expandTween:Play()
			
				-- Update root size
			Section.Root.Size = UDim2.new(1, -10, 0, contentHeight + 36)
		else
			-- Closing animation
			local collapseTween = TweenService:Create(
				Section.Container,
				TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.new(1, 0, 0, 0) }
			)
			collapseTween:Play()
			
			-- Hide container after animation
			collapseTween.Completed:Connect(function()
				Section.Container.Visible = false
			end)
			
			-- Update root size
			Section.Root.Size = UDim2.new(1, -10, 0, 36)
		end
	end	-- Set title function
	function Section:SetTitle(NewTitle)
		Section.TitleLabel.Text = NewTitle
	end
	
	-- Set gradient function (applies to text)
	function Section:SetGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient if any
			local existingGradient = Section.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			
			-- Ensure base text color is white
			Section.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			
			-- Create text gradient
			New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = Section.TitleLabel,
			})
		else
			-- Remove gradient if disabled and reset to default color
			local existingGradient = Section.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Section.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		end
	end
	
	-- Click handler
	Creator.AddSignal(Section.Header.MouseButton1Click, function()
		Section:Toggle()
	end)
	
	-- No hover effects to keep transparent background
	
	-- Auto-resize based on content (only when section is open)
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Section.Open then
			local contentHeight = Section.Layout.AbsoluteContentSize.Y + 16  -- padding
			Section.Container.Size = UDim2.new(1, 0, 0, contentHeight)
			Section.Root.Size = UDim2.new(1, -10, 0, contentHeight + 36)
		else
			Section.Root.Size = UDim2.new(1, -10, 0, 36)
		end
	end)
	
	return Section
end
