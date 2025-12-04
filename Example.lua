local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/hdhdbdhdrhdhrh-ai/New-flu/refs/heads/main/Main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- New Border Feature: Grey borders (thickness 0.5) can be optionally added between elements for better visual separation.
-- Set Border = true in the element config to add a grey line below that element.
-- This gives users control over which elements should have borders for improved organization.

-- Set custom accent color BEFORE creating the window
Fluent.Accent = Color3.fromRGB(0, 135, 177)

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(664, 391),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })



    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    -- Border Demo Section - Shows elements with grey borders between them
    local BorderDemoSection = Tabs.Main:AddSection({
        Title = "Border Demo",
        Open = true
    })

    BorderDemoSection:AddParagraph({
        Title = "Paragraph with Border",
        Content = "This paragraph has a grey border below it.",
        Border = true
    })

    BorderDemoSection:AddButton({
        Title = "Button with Border",
        Description = "This button has a grey border below it",
        ButtonText = "Click me!",
        Callback = function()
            Fluent:Notify({
                Title = "Button Clicked",
                Content = "You clicked the button with a border!",
                Duration = 3
            })
        end,
        Border = true
    })

    BorderDemoSection:AddToggle({
        Title = "Toggle with Border",
        Description = "This toggle has a grey border below it",
        Default = false,
        Callback = function(Value)
            print("Toggle changed:", Value)
        end,
        Border = true
    })

    BorderDemoSection:AddParagraph({
        Title = "Final Element",
        Content = "This is the last element in the section.",
        Border = false -- No border needed for the last element
    })

    -- Create a collapsible section with gradient (closed by default)
    local Section1 = Tabs.Main:AddSection({
        Title = "Comp Killer Section",
        Open = false,
        Gradient = {
            Enabled = true,
            Color1 = Color3.fromRGB(0, 150, 0),  -- Medium green
            Color2 = Color3.fromRGB(0, 255, 150), -- Light green
            Rotation = 0
        }
    })

    -- Add elements inside the section
    Section1:AddButton({
        Title = "Grey Button (Default)",
        Description = "Button with default grey border",
        ButtonText = "Click Me",
        TextColor = Color3.fromRGB(255, 255, 255),
        Filled = false, -- Border style (default grey)
        Callback = function()
            print("Grey border button clicked")
        end
    })

    Section1:AddButton({
        Title = "Accent Button",
        Description = "Button with accent color",
        ButtonText = "Accent",
        TextColor = Color3.fromRGB(255, 255, 255),
        Filled = false,
        Color = Fluent.Accent, -- Use accent color for border
        Callback = function()
            print("Accent button clicked")
        end
    })

    Section1:AddButton({
        Title = "Filled Button",
        Description = "Button with filled background",
        ButtonText = "Filled Grey",
        TextColor = Color3.fromRGB(255, 255, 255),
        Filled = true, -- Filled style (default grey)
        Callback = function()
            print("Filled grey button clicked")
        end
    })

    Section1:AddButton({
        Title = "Red Filled Button",
        Description = "Custom color filled button",
        ButtonText = "Delete",
        TextColor = Color3.fromRGB(255, 255, 255),
        Filled = true,
        Color = Color3.fromRGB(180, 60, 60), -- Red color
        Callback = function()
            Window:Dialog({
                Title = "Confirm Delete",
                Content = "Are you sure you want to delete this?",
                Buttons = {
                    {
                        Title = "Yes",
                        Filled = true,
                        Color = Color3.fromRGB(180, 60, 60), -- Red filled
                        Callback = function()
                            print("Confirmed delete")
                        end
                    },
                    {
                        Title = "Cancel",
                        Color = Color3.fromRGB(80, 80, 80), -- Grey border
                        Callback = function()
                            print("Cancelled")
                        end
                    }
                }
            })
        end
    })

    -- Create another section with same gradient (open by default)
    local Section2 = Tabs.Main:AddSection({
        Title = "Interactive Elements",
        Open = true,
        Gradient = {
            Enabled = true,
            Color1 = Color3.fromRGB(0, 150, 0),  -- Medium green
            Color2 = Color3.fromRGB(0, 255, 150), -- Light green
            Rotation = 0
        }
    })

    local Toggle = Section2:AddToggle("MyToggle", {Title = "Toggle", Default = false })

    Toggle:OnChanged(function()
        print("Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)


    
    local Slider = Section2:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)



    -- Create a third section with same gradient
    local Section3 = Tabs.Main:AddSection({
        Title = "Color Selection",
        Open = false,
        Gradient = {
            Enabled = true,
            Color1 = Color3.fromRGB(0, 150, 0),  -- Medium green
            Color2 = Color3.fromRGB(0, 255, 150), -- Light green
            Rotation = 0
        }
    })

    local Dropdown = Section3:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)


    
    local MultiDropdown = Section3:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)



    local Colorpicker = Section3:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))



    local TColorpicker = Section3:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    -- Create a fourth section with same gradient
    local Section4 = Tabs.Main:AddSection({
        Title = "Input & Controls",
        Open = true,
        Gradient = {
            Enabled = true,
            Color1 = Color3.fromRGB(0, 150, 0),  -- Medium green
            Color2 = Color3.fromRGB(0, 255, 150), -- Light green
            Rotation = 0
        }
    })

    local Keybind = Section4:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        -- Occurs when the keybind is clicked, Value is `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- Otherwise, you will have to use Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = Section4:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)

    -- Example of programmatically toggling sections
    -- task.spawn(function()
    --     task.wait(5)
    --     print("Opening Comp Killer Section...")
    --     Section1.Toggle()  -- This will open the first section
    -- end)
end

-- New Border Feature Demo Section (added after Main tab for demonstration)
local BorderDemoSection = Tabs.Main:AddSection({
    Title = "Border Feature Demo",
    Open = true
})

BorderDemoSection:AddParagraph({
    Title = "Border Feature",
    Content = "Notice the grey borders between elements and around the tab list for better visual separation."
})

BorderDemoSection:AddToggle("DemoToggle1", {Title = "First Toggle", Default = false})
BorderDemoSection:AddButton({Title = "Demo Button 1", Callback = function() print("Button 1") end})
BorderDemoSection:AddToggle("DemoToggle2", {Title = "Second Toggle", Default = true})
BorderDemoSection:AddButton({Title = "Demo Button 2", Callback = function() print("Button 2") end})
BorderDemoSection:AddToggle("DemoToggle3", {Title = "Third Toggle", Default = false})


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()