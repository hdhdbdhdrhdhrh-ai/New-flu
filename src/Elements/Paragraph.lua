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

	return Paragraph
end

return Paragraph
