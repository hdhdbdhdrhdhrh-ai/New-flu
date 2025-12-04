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

	local Paragraph = require(script.Parent.Parent.Components.Element)(Config.Title, Config.Content, Paragraph.Container, false, Config.Border, Config.Gradient)
	Paragraph.Frame.BackgroundTransparency = 1
	Paragraph.Border.Transparency = 1

	-- Always support SetGradient for paragraph title
	function Paragraph:SetGradient(gradientOptions)
		if Paragraph and Paragraph.SetTitleGradient then
			Paragraph:SetTitleGradient(gradientOptions)
		end
	end

	-- If Gradient is provided in config, apply it immediately
	if Config.Gradient then
		Paragraph:SetGradient(Config.Gradient)
	end

	return Paragraph
end

return Paragraph
