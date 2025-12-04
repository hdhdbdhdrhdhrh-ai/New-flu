local Root = script.Parent.Parent
local Components = Root.Components
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)

local New = Creator.New

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Idx, Config)
	assert(Config.Title, "Paragraph - Missing Title")
	Config.Content = Config.Content or ""

	-- Create the paragraph element, no gradient passed to Element
	local ParagraphElement = require(script.Parent.Parent.Components.Element)(
		Config.Title,
		Config.Content,
		Paragraph.Container,
		false,        -- Hover disabled for paragraphs
		Config.Border, -- Pass Border config
		nil  -- Don't pass gradient to Element
	)

	-- Style paragraph as transparent with optional border
	ParagraphElement.Frame.BackgroundTransparency = 1

	-- Handle border visibility
	if Config.Border == false then
		ParagraphElement.Border.Transparency = 1
		if ParagraphElement.BottomLine then
			ParagraphElement.BottomLine.BackgroundTransparency = 1
		end
	else
		ParagraphElement.Border.Transparency = 0.6
	end

	-- Apply gradient to title if provided (same way as Section does it)
	if Config.Gradient and Config.Gradient.Enabled then
		-- Remove existing gradient if any
		local existingGradient = ParagraphElement.TitleLabel:FindFirstChild("UIGradient")
		if existingGradient then
			existingGradient:Destroy()
		end

		-- Set text color to white for gradient
		ParagraphElement.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

		-- Create gradient
		New("UIGradient", {
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Config.Gradient.Color1 or Color3.fromRGB(255, 100, 150)),
				ColorSequenceKeypoint.new(1, Config.Gradient.Color2 or Color3.fromRGB(100, 150, 255))
			},
			Rotation = Config.Gradient.Rotation or 0,
			Parent = ParagraphElement.TitleLabel,
		})
	end

	-- SetGradient function for runtime updates
	function ParagraphElement:SetGradient(gradientOptions)
		if gradientOptions and gradientOptions.Enabled then
			-- Remove existing gradient
			local existingGradient = ParagraphElement.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end

			-- Set text color to white
			ParagraphElement.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

			-- Create new gradient
			New("UIGradient", {
				Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, gradientOptions.Color1 or Color3.fromRGB(255, 100, 150)),
					ColorSequenceKeypoint.new(1, gradientOptions.Color2 or Color3.fromRGB(100, 150, 255))
				},
				Rotation = gradientOptions.Rotation or 0,
				Parent = ParagraphElement.TitleLabel,
			})
		else
			-- Remove gradient
			local existingGradient = ParagraphElement.TitleLabel:FindFirstChild("UIGradient")
			if existingGradient then
				existingGradient:Destroy()
			end
			ParagraphElement.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		end
	end

	return ParagraphElement
end

return Paragraph