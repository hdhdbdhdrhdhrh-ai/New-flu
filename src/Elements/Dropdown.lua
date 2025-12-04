local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
local TextService = game:GetService("TextService")

local Root = script.Parent.Parent
local Creator = require(Root.Creator)
local Flipper = require(Root.Packages.Flipper)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Dropdown"

function Element:New(Idx, Config)
	local Library = self.Library

	local Dropdown = {
		Values = Config.Values,
		Value = Config.Default or {},
		Multi = Config.Multi,
		SelectedTags = {},
		SearchText = "",
		FilteredValues = Config.Values,
		Opened = false,
		Type = "Dropdown",
		Callback = Config.Callback or function() end,
	}

	local DropdownFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)
	
	Dropdown.SetTitle = DropdownFrame.SetTitle
	Dropdown.SetDesc = DropdownFrame.SetDesc

	-- Search box container with grey border
	local SearchBoxContainer = New("Frame", {
		Size = UDim2.new(1, -20, 0, 35),
		Position = UDim2.new(0, 10, 1, 5),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = DropdownFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("UIStroke", {
			Color = Color3.fromRGB(80, 80, 80),
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
		}),
	})

	-- Tags and search input layout
	local TagsLayout = New("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 5),
		Wraps = true,
		Parent = SearchBoxContainer,
	})

	-- Search input box
	local SearchInput = New("TextBox", {
		Size = UDim2.new(0, 100, 0, 25),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search...",
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		ClearTextOnFocus = false,
		Parent = SearchBoxContainer,
		LayoutOrder = 999999, -- Always at the end
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	-- Dropdown icon
	local DropdownIco = New("ImageLabel", {
		Image = "rbxassetid://10709790948",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = SearchBoxContainer,
		ZIndex = 10,
		ThemeTag = {
			ImageColor3 = "SubText",
		},
	})

	-- Dropdown list
	local DropdownListLayout = New("UIListLayout", {
		Padding = UDim.new(0, 3),
	})

	local DropdownScrollFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, -5, 1, -10),
		Position = UDim2.fromOffset(5, 5),
		BackgroundTransparency = 1,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.95,
		ScrollBarThickness = 4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
	}, {
		DropdownListLayout,
	})

	local DropdownHolderFrame = New("Frame", {
		Size = UDim2.fromScale(1, 0.6),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
	}, {
		DropdownScrollFrame,
		New("UICorner", {
			CornerRadius = UDim.new(0, 7),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "DropdownBorder",
			},
		}),
		New("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=5554236805",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(23, 23, 277, 277),
			Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
			Position = UDim2.fromOffset(-15, -15),
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.1,
		}),
	})

	local DropdownHolderCanvas = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(SearchBoxContainer.AbsoluteSize.X, 300),
		Parent = self.Library.GUI,
		Visible = false,
	}, {
		DropdownHolderFrame,
		New("UISizeConstraint", {
			MinSize = Vector2.new(170, 0),
		}),
	})
	table.insert(Library.OpenFrames, DropdownHolderCanvas)

	-- Create a tag/chip for a selected item
	function Dropdown:CreateTag(value)
		if Dropdown.SelectedTags[value] then
			return -- Tag already exists
		end

		local TagFrame = New("Frame", {
			Size = UDim2.new(0, 0, 0, 25),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			BorderSizePixel = 0,
			Parent = SearchBoxContainer,
			LayoutOrder = #Dropdown.SelectedTags,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 3),
				PaddingBottom = UDim.new(0, 3),
			}),
		})

		local TagLayout = New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 5),
			Parent = TagFrame,
		})

		local TagLabel = New("TextLabel", {
			Text = value,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 12,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Parent = TagFrame,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local XButton = New("TextButton", {
			Text = "×",
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 16,
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(16, 16),
			Parent = TagFrame,
		})

		Creator.AddSignal(XButton.MouseButton1Click, function()
			Dropdown:RemoveTag(value)
		end)

		Dropdown.SelectedTags[value] = TagFrame
	end

	-- Remove a tag
	function Dropdown:RemoveTag(value)
		if Dropdown.SelectedTags[value] then
			Dropdown.SelectedTags[value]:Destroy()
			Dropdown.SelectedTags[value] = nil

			if Dropdown.Multi then
				Dropdown.Value[value] = nil
			else
				Dropdown.Value = nil
			end

			Dropdown:BuildDropdownList()
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end
	end

	-- Filter dropdown values based on search text
	function Dropdown:FilterValues()
		local search = SearchInput.Text:lower()
		Dropdown.SearchText = search
		
		if search == "" then
			Dropdown.FilteredValues = Dropdown.Values
		else
			Dropdown.FilteredValues = {}
			for _, value in ipairs(Dropdown.Values) do
				if value:lower():find(search, 1, true) then
					table.insert(Dropdown.FilteredValues, value)
				end
			end
		end
		
		Dropdown:BuildDropdownList()
	end

	-- Build dropdown list
	function Dropdown:BuildDropdownList()
		for _, child in ipairs(DropdownScrollFrame:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		for _, value in ipairs(Dropdown.FilteredValues) do
			local isSelected = false
			if Dropdown.Multi then
				isSelected = Dropdown.Value[value] == true
			else
				isSelected = Dropdown.Value == value
			end

			local OptionLabel = New("TextLabel", {
				Text = value,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(10, 0),
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local SelectIndicator = New("Frame", {
				Size = UDim2.fromOffset(4, 14),
				BackgroundColor3 = Color3.fromRGB(0, 235, 0),
				BackgroundTransparency = isSelected and 0 or 1,
				Position = UDim2.fromOffset(-1, 16),
				AnchorPoint = Vector2.new(0, 0.5),
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 2),
				}),
			})

			local OptionButton = New("TextButton", {
				Size = UDim2.new(1, -5, 0, 32),
				BackgroundTransparency = isSelected and 0.89 or 1,
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Text = "",
				Parent = DropdownScrollFrame,
				ThemeTag = {
					BackgroundColor3 = "DropdownOption",
				},
			}, {
				SelectIndicator,
				OptionLabel,
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			})

			-- Hover effects
			Creator.AddSignal(OptionButton.MouseEnter, function()
				TweenService:Create(OptionButton, TweenInfo.new(0.1), {
					BackgroundTransparency = isSelected and 0.85 or 0.92
				}):Play()
			end)

			Creator.AddSignal(OptionButton.MouseLeave, function()
				TweenService:Create(OptionButton, TweenInfo.new(0.1), {
					BackgroundTransparency = isSelected and 0.89 or 1
				}):Play()
			end)

			-- Click handler
			Creator.AddSignal(OptionButton.MouseButton1Click, function()
				if Dropdown.Multi then
					if Dropdown.Value[value] then
						-- Deselect
						Dropdown.Value[value] = nil
						Dropdown:RemoveTag(value)
					else
						-- Select
						Dropdown.Value[value] = true
						Dropdown:CreateTag(value)
					end
				else
					-- Single select
					for existingValue in pairs(Dropdown.SelectedTags) do
						Dropdown:RemoveTag(existingValue)
					end
					
					if Dropdown.Value ~= value then
						Dropdown.Value = value
						Dropdown:CreateTag(value)
					else
						Dropdown.Value = nil
					end
				end

				Dropdown:BuildDropdownList()
				Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
				Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
			end)
		end

		-- Update canvas size
		DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
		
		-- Update dropdown holder size
		local maxHeight = 392
		local contentHeight = DropdownListLayout.AbsoluteContentSize.Y + 10
		DropdownHolderCanvas.Size = UDim2.fromOffset(
			SearchBoxContainer.AbsoluteSize.X,
			math.min(contentHeight, maxHeight)
		)
	end

	-- Position dropdown list
	local function RecalculateListPosition()
		local Add = 0
		local searchBoxBottom = SearchBoxContainer.AbsolutePosition.Y + SearchBoxContainer.AbsoluteSize.Y
		if Camera.ViewportSize.Y - searchBoxBottom < DropdownHolderCanvas.AbsoluteSize.Y + 5 then
			Add = DropdownHolderCanvas.AbsoluteSize.Y - (Camera.ViewportSize.Y - searchBoxBottom) + 10
		end
		DropdownHolderCanvas.Position = UDim2.fromOffset(
			SearchBoxContainer.AbsolutePosition.X,
			searchBoxBottom + 5 - Add
		)
	end

	-- Open dropdown
	function Dropdown:Open()
		Dropdown.Opened = true
		self.ScrollFrame.ScrollingEnabled = false
		DropdownHolderCanvas.Visible = true
		RecalculateListPosition()
		TweenService:Create(DropdownHolderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(1, 1)
		}):Play()
	end

	-- Close dropdown
	function Dropdown:Close()
		Dropdown.Opened = false
		self.ScrollFrame.ScrollingEnabled = true
		DropdownHolderFrame.Size = UDim2.fromScale(1, 0.6)
		DropdownHolderCanvas.Visible = false
	end

	-- Search input events
	Creator.AddSignal(SearchInput:GetPropertyChangedSignal("Text"), function()
		Dropdown:FilterValues()
	end)

	Creator.AddSignal(SearchInput.Focused, function()
		Dropdown:Open()
	end)

	Creator.AddSignal(SearchBoxContainer:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
	Creator.AddSignal(SearchBoxContainer:GetPropertyChangedSignal("AbsoluteSize"), RecalculateListPosition)

	-- Click outside to close
	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
			local SearchPos, SearchSize = SearchBoxContainer.AbsolutePosition, SearchBoxContainer.AbsoluteSize
			
			local inDropdown = Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and
							   Mouse.Y >= AbsPos.Y - 20 and Mouse.Y <= AbsPos.Y + AbsSize.Y
			local inSearch = Mouse.X >= SearchPos.X and Mouse.X <= SearchPos.X + SearchSize.X and
							 Mouse.Y >= SearchPos.Y and Mouse.Y <= SearchPos.Y + SearchSize.Y
			
			if not inDropdown and not inSearch then
				Dropdown:Close()
			end
		end
	end)

	-- Public methods
	function Dropdown:SetValues(newValues)
		Dropdown.Values = newValues or Dropdown.Values
		Dropdown:FilterValues()
	end

	function Dropdown:OnChanged(callback)
		Dropdown.Changed = callback
		callback(Dropdown.Value)
	end

	function Dropdown:SetValue(value)
		-- Clear existing tags
		for existingValue in pairs(Dropdown.SelectedTags) do
			Dropdown:RemoveTag(existingValue)
		end

		if Dropdown.Multi then
			Dropdown.Value = {}
			for key, val in pairs(value) do
				if table.find(Dropdown.Values, key) then
					Dropdown.Value[key] = true
					Dropdown:CreateTag(key)
				end
			end
		else
			if value and table.find(Dropdown.Values, value) then
				Dropdown.Value = value
				Dropdown:CreateTag(value)
			else
				Dropdown.Value = nil
			end
		end

		Dropdown:BuildDropdownList()
		Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
		Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
	end

	function Dropdown:Destroy()
		DropdownFrame:Destroy()
		Library.Options[Idx] = nil
	end

	-- Initialize
	Dropdown:BuildDropdownList()

	-- Set default values
	if Config.Default then
		if type(Config.Default) == "table" then
			for _, value in ipairs(Config.Default) do
				if Dropdown.Multi and table.find(Dropdown.Values, value) then
					Dropdown.Value[value] = true
					Dropdown:CreateTag(value)
				end
			end
		elseif type(Config.Default) == "string" and table.find(Dropdown.Values, Config.Default) then
			if Dropdown.Multi then
				Dropdown.Value[Config.Default] = true
			else
				Dropdown.Value = Config.Default
			end
			Dropdown:CreateTag(Config.Default)
		end
		Dropdown:BuildDropdownList()
	end

	Library.Options[Idx] = Dropdown
	return Dropdown
end

return Element
