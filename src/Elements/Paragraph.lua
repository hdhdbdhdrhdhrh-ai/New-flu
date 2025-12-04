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

	-- Create the paragraph element, passing gradient config
	local ParagraphElement = require(script.Parent.Parent.Components.Element)(
		Config.Title, 
		Config.Content, 
		Paragraph.Container, 
		false, 
		Config.Border, 
		Config.Gradient  -- Pass gradient to Element
	)
	
	ParagraphElement.Frame.BackgroundTransparency = 1
	ParagraphElement.Border.Transparency = 1

	-- Expose SetGradient method on the Paragraph object
	function ParagraphElement:SetGradient(gradientOptions)
		if ParagraphElement.SetTitleGradient then
			ParagraphElement:SetTitleGradient(gradientOptions)
		end
	end

	-- Return the element with proper metatable
	return setmetatable(ParagraphElement, Paragraph)
end

return Paragraph