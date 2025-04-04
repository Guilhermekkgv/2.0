local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Font = "Montserrat",
        Accent = Color3.fromRGB(96, 205, 255),
        Background = Color3.fromRGB(33, 33, 33),
        Element = Color3.fromRGB(120, 120, 120),
        ElementBorder = Color3.fromRGB(35, 35, 35),
        InElementBorder = Color3.fromRGB(90, 90, 90),
        ElementTransparency = 0.87,
        ToggleOff = Color3.fromRGB(50, 50, 50),
        ToggleSlider = Color3.fromRGB(120, 120, 120),
        ToggleToggled = Color3.fromRGB(0, 0, 0),
        FontColor = Color3.fromRGB(255, 255, 255),
        HideKey = "LeftAlt",
        Tab = Color3.fromRGB(120, 120, 120),
        TabSelected = Color3.fromRGB(255, 255, 255),
        TabUnselected = Color3.fromRGB(40, 40, 40),
        TabSelectedText = Color3.fromRGB(0, 0, 0),
        TabUnselectedText = Color3.fromRGB(255, 255, 255),
        OptionSelected = Color3.fromRGB(200, 200, 200),
        TitleBarLine = Color3.fromRGB(75, 75, 75),
        DropdownFrame = Color3.fromRGB(160, 160, 160),
        DropdownHolder = Color3.fromRGB(45, 45, 45),
        DropdownBorder = Color3.fromRGB(35, 35, 35),
        DropdownOption = Color3.fromRGB(120, 120, 120)
    }
}

local CreateModule = {
    reg = {}
}

local function AddToReg(Instance)
    table.insert(CreateModule.reg, Instance)
end

function CreateModule.Instance(instance, properties)
    local CreatedInstance = Instance.new(instance)
    for property, value in pairs(properties) do
        CreatedInstance[property] = value
    end
    return CreatedInstance
end

function Library.Main(Name)
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "DarkSquareLib" then
            v:Destroy()
        end
    end

    local DarkSquareLib = CreateModule.Instance("ScreenGui", {
        Name = "DarkSquareLib",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    local MainFrame = CreateModule.Instance("Frame", {
        Name = "MainFrame",
        Parent = DarkSquareLib,
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        Active = true,
        Draggable = true,
        Visible = true,
        ZIndex = 3
    })

    CreateModule.Instance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })

    local TitleLabel = CreateModule.Instance("TextLabel", {
        Parent = MainFrame,
        Name = "TitleLabel",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 30),
        Font = Enum.Font[Library.Theme.Font],
        Text = Name,
        TextColor3 = Library.Theme.FontColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })

    local TitleBarLine = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "TitleBarLine",
        BackgroundColor3 = Library.Theme.TitleBarLine,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 4
    })

    local TabFrame = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "TabFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 130, 1, -40),
        ZIndex = 4
    })

    local TabContainer = CreateModule.Instance("Frame", {
        Parent = TabFrame,
        Name = "TabContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 4
    })

    local TabList = CreateModule.Instance("UIListLayout", {
        Parent = TabContainer,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 5)
    })

    local TabPadding = CreateModule.Instance("UIPadding", {
        Parent = TabContainer,
        PaddingLeft = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5)
    })

    local ContainerFrame = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "ContainerFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 130, 0, 40),
        Size = UDim2.new(1, -140, 1, -50),
        ZIndex = 3
    })

    InputService.InputBegan:Connect(function(input, IsTyping)
        if input.KeyCode == Enum.KeyCode[Library.Theme.HideKey] and not IsTyping then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local InMain = {}
    local TabModule = {
        Window = nil,
        Tabs = {},
        Containers = {},
        SelectedTab = 0,
        TabCount = 0,
    }

    function TabModule:Init(Window)
        TabModule.Window = Window
        return TabModule
    end

    function TabModule:GetCurrentTabPos()
        local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
        local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y
        return TabPos - TabHolderPos
    end

    function TabModule:New(Title, Icon)
        TabModule.TabCount = TabModule.TabCount + 1
        local TabIndex = TabModule.TabCount
        local Tab = { Selected = false, Name = Title, Type = "Tab" }

        Tab.Frame = CreateModule.Instance("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Parent = TabContainer,
            BackgroundColor3 = Library.Theme.Tab,
            AutoButtonColor = false,
            ZIndex = 4
        }, {
            CreateModule.Instance("UICorner", { CornerRadius = UDim.new(0, 6) }),
            CreateModule.Instance("TextLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 12, 0.5, 0),
                Text = Title,
                TextColor3 = Library.Theme.FontColor,
                TextTransparency = 0,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Size = UDim2.new(1, -12, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 4
            })
        })

        local ContainerLayout = CreateModule.Instance("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Tab.ContainerFrame = CreateModule.Instance("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = ContainerFrame,
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
            ScrollBarImageTransparency = 0.95,
            BorderSizePixel = 0,
            CanvasSize = UDim2.fromScale(0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ZIndex = 3
        }, {
            ContainerLayout,
            CreateModule.Instance("UIPadding", {
                PaddingRight = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 1),
                PaddingBottom = UDim.new(0, 1)
            })
        })

        ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
        end)

        Tab.Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                TabModule:SelectTab(TabIndex)
            end
        end)

        TabModule.Containers[TabIndex] = Tab.ContainerFrame
        TabModule.Tabs[TabIndex] = Tab

        Tab.Container = Tab.ContainerFrame
        Tab.ScrollFrame = Tab.Container

        if not TabModule.SelectedTab then
            TabModule:SelectTab(TabIndex)
        end

        local TabFunctions = {}

        function TabFunctions.Checkbox(config)
            local Checkbox = CreateModule.Instance("Frame", {
                Parent = Tab.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BackgroundTransparency = Library.Theme.ElementTransparency,
                BorderColor3 = Library.Theme.ElementBorder,
                BorderSizePixel = 1,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = Checkbox, CornerRadius = UDim.new(0, 6) })

            local Label = CreateModule.Instance("TextLabel", {
                Parent = Checkbox,
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })

            local ToggleFrame = CreateModule.Instance("Frame", {
                Parent = Checkbox,
                Name = "ToggleFrame",
                BackgroundColor3 = Library.Theme.ToggleOff,
                BorderColor3 = Library.Theme.InElementBorder,
                BorderSizePixel = 1,
                Position = UDim2.new(1, -60, 0.5, -10),
                Size = UDim2.new(0, 50, 0, 20),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = ToggleFrame, CornerRadius = UDim.new(1, 0) })

            local ToggleSlider = CreateModule.Instance("Frame", {
                Parent = ToggleFrame,
                Name = "ToggleSlider",
                BackgroundColor3 = Library.Theme.ToggleSlider,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                ZIndex = 4
            })

            CreateModule.Instance("UICorner", { Parent = ToggleSlider, CornerRadius = UDim.new(1, 0) })

            local IsActive = config.Default or false

            local function UpdateToggle()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if IsActive then
                    TweenService:Create(ToggleFrame, tweenInfo, {BackgroundColor3 = Library.Theme.ToggleToggled}):Play()
                    TweenService:Create(ToggleSlider, tweenInfo, {Position = UDim2.new(0.5, 0, 0, 0)}):Play()
                else
                    TweenService:Create(ToggleFrame, tweenInfo, {BackgroundColor3 = Library.Theme.ToggleOff}):Play()
                    TweenService:Create(ToggleSlider, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)}):Play()
                end
            end

            UpdateToggle()

            Checkbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    IsActive = not IsActive
                    UpdateToggle()
                    spawn(function() config.Callback(IsActive) end)
                end
            end)

            AddToReg(Checkbox)
            return Checkbox
        end

        function TabFunctions.Slider(config)
            local Slider = CreateModule.Instance("Frame", {
                Parent = Tab.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BackgroundTransparency = Library.Theme.ElementTransparency,
                BorderColor3 = Library.Theme.ElementBorder,
                BorderSizePixel = 1,
                Size = UDim2.new(1, -10, 0, 45),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = Slider, CornerRadius = UDim.new(0, 6) })

            local Label = CreateModule.Instance("TextLabel", {
                Parent = Slider,
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(0.5, 0, 0, 20),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })

            local ValueLabel = CreateModule.Instance("TextLabel", {
                Parent = Slider,
                Name = "ValueLabel",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0.8, 0, 0, 5),
                Size = UDim2.new(0.2, -10, 0, 20),
                Font = Enum.Font[Library.Theme.Font],
                Text = tostring(config.Default or 0),
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 3
            })

            local SliderBar = CreateModule.Instance("Frame", {
                Parent = Slider,
                Name = "SliderBar",
                BackgroundColor3 = Library.Theme.InElementBorder,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 6),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = SliderBar, CornerRadius = UDim.new(1, 0) })

            local SliderFill = CreateModule.Instance("Frame", {
                Parent = SliderBar,
                Name = "SliderFill",
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = SliderFill, CornerRadius = UDim.new(1, 0) })

            local SliderKnob = CreateModule.Instance("Frame", {
                Parent = SliderBar,
                Name = "SliderKnob",
                BackgroundColor3 = Library.Theme.FontColor,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                ZIndex = 4
            })

            CreateModule.Instance("UICorner", { Parent = SliderKnob, CornerRadius = UDim.new(1, 0) })

            local CurrentValue = config.Default or 0
            local MinValue = config.Min or 0
            local MaxValue = config.Max or 100

            local function UpdateSlider()
                local percentage = (CurrentValue - MinValue) / (MaxValue - MinValue)
                percentage = math.clamp(percentage, 0, 1)
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percentage, -5, 0.5, -5)
                ValueLabel.Text = tostring(math.floor(CurrentValue))
                spawn(function() config.Callback(CurrentValue) end)
            end

            UpdateSlider()

            local isDraggingSlider = false
            local lastTouchPos = nil

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    lastTouchPos = input.Position.X
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                    lastTouchPos = nil
                end
            end)

            InputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and isDraggingSlider then
                    local touchPos = input.Position.X
                    local sliderPos = SliderBar.AbsolutePosition.X
                    local sliderSize = SliderBar.AbsoluteSize.X
                    local relativePos = (touchPos - sliderPos) / sliderSize
                    relativePos = math.clamp(relativePos, 0, 1)
                    CurrentValue = MinValue + (relativePos * (MaxValue - MinValue))
                    UpdateSlider()
                    lastTouchPos = touchPos
                end
            end)

            AddToReg(Slider)
            return Slider
        end

        function TabFunctions.Dropdown(config)
            local Dropdown = CreateModule.Instance("Frame", {
                Parent = Tab.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.DropdownFrame,
                BackgroundTransparency = Library.Theme.ElementTransparency,
                BorderColor3 = Library.Theme.DropdownBorder,
                BorderSizePixel = 1,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", { Parent = Dropdown, CornerRadius = UDim.new(0, 6) })

            local Label = CreateModule.Instance("TextLabel", {
                Parent = Dropdown,
                Name = "Label",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            })

            local SelectedLabel = CreateModule.Instance("TextLabel", {
                Parent = Dropdown,
                Name = "SelectedLabel",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 3
            })

            local Arrow = CreateModule.Instance("ImageLabel", {
                Parent = Dropdown,
                Name = "Arrow",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -30, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Library.Theme.FontColor,
                ZIndex = 3
            })

            local OptionFrame = CreateModule.Instance("Frame", {
                Parent = Dropdown,
                Name = "OptionFrame",
                BackgroundColor3 = Library.Theme.DropdownHolder,
                BorderColor3 = Library.Theme.DropdownBorder,
                BorderSizePixel = 1,
                Position = UDim2.new(0, 0, 1, 5),
                Size = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 5
            })

            CreateModule.Instance("UICorner", { Parent = OptionFrame, CornerRadius = UDim.new(0, 6) })

            local OptionList = CreateModule.Instance("UIListLayout", {
                Parent = OptionFrame,
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 2)
            })

            local OptionPadding = CreateModule.Instance("UIPadding", {
                Parent = OptionFrame,
                PaddingLeft = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5)
            })

            local Options = config.Options or {}
            local Selected = config.Default or (Options[1] or "None")
            local IsOpen = false

            local function UpdateDropdownSize()
                local itemHeight = 30
                local maxHeight = math.min(#Options * itemHeight + 5, 150)
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if IsOpen then
                    TweenService:Create(OptionFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, maxHeight)}):Play()
                    TweenService:Create(Arrow, tweenInfo, {Rotation = 180}):Play()
                else
                    TweenService:Create(OptionFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    TweenService:Create(Arrow, tweenInfo, {Rotation = 0}):Play()
                end
            end

            local function PopulateOptions()
                for _, child in pairs(OptionFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for i, option in pairs(Options) do
                    local OptionButton = CreateModule.Instance("TextButton", {
                        Parent = OptionFrame,
                        Name = "Option" .. i,
                        BackgroundColor3 = Library.Theme.DropdownOption,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, -5, 0, 30),
                        Font = Enum.Font[Library.Theme.Font],
                        Text = tostring(option),
                        TextColor3 = option == Selected and Library.Theme.OptionSelected or Library.Theme.FontColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 5
                    })

                    CreateModule.Instance("UICorner", { Parent = OptionButton, CornerRadius = UDim.new(0, 4) })

                    OptionButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch then
                            Selected = option
                            SelectedLabel.Text = tostring(option)
                            for _, btn in pairs(OptionFrame:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.TextColor3 = btn.Text == tostring(option) and Library.Theme.OptionSelected or Library.Theme.FontColor
                                end
                            end
                            spawn(function() config.Callback(option) end)
                        end
                    end)
                end
            end

            if #Options > 0 then
                PopulateOptions()
            end

            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    IsOpen = not IsOpen
                    OptionFrame.Visible = IsOpen
                    UpdateDropdownSize()
                end
            end)

            MainFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and IsOpen and (input.Position.X < Dropdown.AbsolutePosition.X or input.Position.X > Dropdown.AbsolutePosition.X + Dropdown.AbsoluteSize.X or input.Position.Y < Dropdown.AbsolutePosition.Y or input.Position.Y > Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + (OptionFrame.Visible and OptionFrame.AbsoluteSize.Y or 0)) then
                    IsOpen = false
                    OptionFrame.Visible = false
                    UpdateDropdownSize()
                end
            end)

            local function UpdateOptions(newOptions)
                Options = newOptions or {}
                Selected = config.Default or (Options[1] or "None")
                SelectedLabel.Text = tostring(Selected)
                PopulateOptions()
                if IsOpen then
                    IsOpen = false
                    OptionFrame.Visible = false
                    UpdateDropdownSize()
                end
            end

            AddToReg(Dropdown)
            return {
                Instance = Dropdown,
                SetOptions = UpdateOptions,
                GetSelected = function() return Selected end
            }
        end

        return TabFunctions
    end

    function TabModule:SelectTab(Tab)
        TabModule.SelectedTab = Tab
        for _, TabObject in pairs(TabModule.Tabs) do
            TabObject.ContainerFrame.Visible = false
            TabObject.Frame.BackgroundColor3 = Library.Theme.TabUnselected
            TabObject.Frame.TextLabel.TextColor3 = Library.Theme.TabUnselectedText
            TabObject.Selected = false
        end
        TabModule.Tabs[Tab].ContainerFrame.Visible = true
        TabModule.Tabs[Tab].Frame.BackgroundColor3 = Library.Theme.TabSelected
        TabModule.Tabs[Tab].Frame.TextLabel.TextColor3 = Library.Theme.TabSelectedText
        TabModule.Tabs[Tab].Selected = true
    end

    function InMain.Tab(TabName)
        return TabModule:New(TabName, nil)
    end

    TabModule:Init(InMain)
    return InMain
end

return Library
