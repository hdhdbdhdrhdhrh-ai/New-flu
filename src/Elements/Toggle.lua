local TweenService = game:GetService("TweenService")
local Root = script.Parent.Parent
local Creator = require(Root.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Toggle"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Toggle - Missing Title")

	local Toggle = {
		Value = Config.Default or false,
		Callback = Config.Callback or function(Value) end,
		Type = "Toggle",
	}

	local ToggleFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)

	Toggle.SetTitle = ToggleFrame.SetTitle
	Toggle.SetDesc = ToggleFrame.SetDesc

	local ToggleBorder = New("UIStroke", {
		Thickness = 0.8,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	local ToggleSquare = New("TextButton", {
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Parent = ToggleFrame.Frame,
		BackgroundTransparency = 1,
		Text = "",
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		ToggleBorder,
	})

	local CheckIcon = New("ImageLabel", {
		Size = UDim2.fromOffset(10, 10),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "rbxassetid://10709790644",
		BackgroundTransparency = 1,
		Visible = false,
		Parent = ToggleSquare,
	})

	function Toggle:UpdateVisuals()
		if Toggle.Value then
			ToggleSquare.BackgroundColor3 = Library.Accent
			ToggleSquare.BackgroundTransparency = 0
			ToggleBorder.Transparency = 1
			CheckIcon.Visible = true
			CheckIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
		else
			ToggleSquare.BackgroundTransparency = 1
			ToggleBorder.Color = Library.Accent
			ToggleBorder.Transparency = 0
			CheckIcon.Visible = false
		end
	end

	function Toggle:OnChanged(Func)
		Toggle.Changed = Func
		Func(Toggle.Value)
	end

	function Toggle:SetValue(Value)
		Value = not not Value
		Toggle.Value = Value
		Toggle:UpdateVisuals()
		Library:SafeCallback(Toggle.Callback, Toggle.Value)
		Library:SafeCallback(Toggle.Changed, Toggle.Value)
	end

	function Toggle:Destroy()
		ToggleFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(ToggleSquare.MouseButton1Click, function()
		Toggle:SetValue(not Toggle.Value)
	end)

	Toggle:SetValue(Toggle.Value)

	Library.Options[Idx] = Toggle
	return Toggle
end

return Element
