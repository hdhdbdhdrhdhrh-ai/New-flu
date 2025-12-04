local Root = script.Parent.Parent
local Components = Root.Components
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Config)
	assert(Config.Title, "Paragraph - Missing Title")
	Config.Content = Config.Content or ""

	local Paragraph = require(Components.Element)(Config.Title, Config.Content, Paragraph.Container, false, Config.Border)
	
	-- Remove grey background and border for cleaner look
	Paragraph.Frame.BackgroundTransparency = 1
	Paragraph.Border.Transparency = 1

	-- Add gradient support for title
	local function SetGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient if any
			local existingGradient = Paragraph.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			
			-- Ensure base text color is white for gradient
			Paragraph.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			
			-- Create text gradient
			Creator.New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(0, 150, 0)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(0, 255, 150))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = Paragraph.TitleLabel,
			})
		else
			-- Remove gradient if disabled and reset to default color
			local existingGradient = Paragraph.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			Paragraph.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		end
	end
	
	-- Apply gradient if provided in config
	if Config.Gradient then
		SetGradient(Config.Gradient)
	end

	return Paragraph
end

return Paragraph
