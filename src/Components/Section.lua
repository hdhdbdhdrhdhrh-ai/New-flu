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
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.3,
		Text = "",
		Parent = Section.Root,
		AutomaticSize = Enum.AutomaticSize.None,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("UIStroke", {
			Transparency = 0,
			Color = Color3.fromRGB(0, 235, 0),
			Thickness = 1.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
	})
	
	-- Optional gradient overlay
	Section.GradientFrame = nil
	
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
		Rotation = DefaultOpen and 0 or 90,
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
		ClipsDescendants = true,
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 3),
		}),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 3),
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
			Section.Root.Size = UDim2.new(1, -10, 0, contentHeight + 35)
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
			Section.Root.Size = UDim2.new(1, -10, 0, 35)
		end
	end
	
	-- Set title function
	function Section:SetTitle(NewTitle)
		Section.TitleLabel.Text = NewTitle
	end
	
	-- Set gradient function
	function Section:SetGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient if any
			if Section.GradientFrame then
				Section.GradientFrame:Destroy()
			end
			
			-- Create gradient frame
			Section.GradientFrame = New("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = gradientOptions.Transparency or 0.7,
				Parent = Section.Header,
				ZIndex = 2,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				New("UIGradient", {
					Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 235, 0)),
						ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 150, 255))
					},
					Rotation = gradientOptions.Rotation or 45,
				}),
			})
			
			-- Ensure title is above gradient
			Section.TitleLabel.ZIndex = 3
			Section.Arrow.ZIndex = 3
		else
			-- Remove gradient if disabled
			if Section.GradientFrame then
				Section.GradientFrame:Destroy()
				Section.GradientFrame = nil
			end
		end
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
	
	-- Auto-resize based on content (only when section is open)
	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Section.Open then
			local contentHeight = Section.Layout.AbsoluteContentSize.Y + 13  -- padding
			Section.Container.Size = UDim2.new(1, 0, 0, contentHeight)
			Section.Root.Size = UDim2.new(1, -10, 0, contentHeight + 35)
		else
			Section.Root.Size = UDim2.new(1, -10, 0, 35)
		end
	end)
	
	return Section
end
