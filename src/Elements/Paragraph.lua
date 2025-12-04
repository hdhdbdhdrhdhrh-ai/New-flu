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

	-- Create the paragraph element, passing gradient and border config
	local ParagraphElement = require(script.Parent.Parent.Components.Element)(
		Config.Title, 
		Config.Content, 
		Paragraph.Container, 
		false,        -- Hover disabled for paragraphs
		Config.Border, -- Pass Border config
		Config.Gradient  -- Pass Gradient config to Element
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

	-- Gradient can be controlled via Element's own SetGradient/SetTitleGradient; no override needed here

	return ParagraphElement
end

return Paragraph