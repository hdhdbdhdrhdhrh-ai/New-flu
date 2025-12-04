local Root = script.Parent.Parent
local Components = Root.Components
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Creator)

local Paragraph = {}
Paragraph.__index = Paragraph
Paragraph.__type = "Paragraph"

function Paragraph:New(Idx, Config)
	warn("[PARAGRAPH DEBUG] Paragraph:New called with Idx:", Idx)
	warn("[PARAGRAPH DEBUG] Config.Title:", Config.Title)
	warn("[PARAGRAPH DEBUG] Config.Gradient:", Config.Gradient)

	assert(Config.Title, "Paragraph - Missing Title")
	Config.Content = Config.Content or ""

	if Config.Gradient then
		warn("[PARAGRAPH DEBUG] Gradient found! Enabled:", Config.Gradient.Enabled)
		warn("[PARAGRAPH DEBUG] Gradient Color1:", Config.Gradient.Color1)
		warn("[PARAGRAPH DEBUG] Gradient Color2:", Config.Gradient.Color2)
	else
		warn("[PARAGRAPH DEBUG] NO GRADIENT CONFIG PROVIDED!")
	end

	-- Create the paragraph element, passing gradient and border config
	local ParagraphElement = require(script.Parent.Parent.Components.Element)(
		Config.Title,
		Config.Content,
		Paragraph.Container,
		false,        -- Hover disabled for paragraphs
		Config.Border, -- Pass Border config
		Config.Gradient  -- Pass Gradient config to Element
	)

	warn("[PARAGRAPH DEBUG] ParagraphElement created successfully")
	
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