local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
    Theme = {
        Font = "Montserrat",
        Accent = Color3.fromRGB(70, 100, 255),
        Background = Color3.fromRGB(33, 33, 33),
        Element = Color3.fromRGB(70, 70, 70),
        ToggleOff = Color3.fromRGB(50, 50, 50),
        FontColor = Color3.fromRGB(255, 255, 255),
        HideKey = "LeftAlt",
        TabSelected = Color3.fromRGB(255, 255, 255),
        TabUnselected = Color3.fromRGB(40, 40, 40),
        TabSelectedText = Color3.fromRGB(0, 0, 0),
        TabUnselectedText = Color3.fromRGB(255, 255, 255),
        OptionSelected = Color3.fromRGB(200, 200, 200)
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
    local Tabs = {}
    local TabOrder = {}
    local CurrentTab = nil

    local function CreateTab(TabName)
        local TabButton = CreateModule.Instance("TextButton", {
            Parent = TabContainer,
            Name = TabName,
            BackgroundColor3 = Library.Theme.TabUnselected,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 35),
            Font = Enum.Font[Library.Theme.Font],
            Text = TabName,
            TextColor3 = Library.Theme.TabUnselectedText,
            TextSize = 16,
            AutoButtonColor = false,
            ZIndex = 4
        })

        CreateModule.Instance("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 6)
        })

        local TabContent = CreateModule.Instance("ScrollingFrame", {
            Parent = ContainerFrame,
            Name = TabName .. "Container",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ScrollingEnabled = true,
            Visible = false,
            ZIndex = 3
        })

        local ElementList = CreateModule.Instance("UIListLayout", {
            Parent = TabContent,
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local ContainerPadding = CreateModule.Instance("UIPadding", {
            Parent = TabContent,
            PaddingLeft = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10)
        })

        TabButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                if CurrentTab then
                    Tabs[CurrentTab].Container.Visible = false
                    Tabs[CurrentTab].Button.BackgroundColor3 = Library.Theme.TabUnselected
                    Tabs[CurrentTab].Button.TextColor3 = Library.Theme.TabUnselectedText
                end
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Library.Theme.TabSelected
                TabButton.TextColor3 = Library.Theme.TabSelectedText
                CurrentTab = TabName
            end
        end)

        local TabData = {
            Button = TabButton,
            Container = TabContent
        }

        Tabs[TabName] = TabData
        table.insert(TabOrder, TabName)

        if not CurrentTab then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Library.Theme.TabSelected
            TabButton.TextColor3 = Library.Theme.TabSelectedText
            CurrentTab = TabName
        end

        local TabFunctions = {}

        function TabFunctions.Checkbox(config)
            local Checkbox = CreateModule.Instance("Frame", {
                Parent = TabData.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = Checkbox,
                CornerRadius = UDim.new(0, 6)
            })

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
                BorderSizePixel = 0,
                Position = UDim2.new(1, -60, 0.5, -10),
                Size = UDim2.new(0, 50, 0, 20),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(1, 0)
            })

            local ToggleKnob = CreateModule.Instance("Frame", {
                Parent = ToggleFrame,
                Name = "ToggleKnob",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(0, 16, 1, -4),
                ZIndex = 4
            })

            CreateModule.Instance("UICorner", {
                Parent = ToggleKnob,
                CornerRadius = UDim.new(1, 0)
            })

            local IsActive = config.Default or false

            local function UpdateToggle()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if IsActive then
                    TweenService:Create(ToggleFrame, tweenInfo, {BackgroundColor3 = Library.Theme.Accent}):Play()
                    TweenService:Create(ToggleKnob, tweenInfo, {Position = UDim2.new(1, -18, 0, 2)}):Play()
                else
                    TweenService:Create(ToggleFrame, tweenInfo, {BackgroundColor3 = Library.Theme.ToggleOff}):Play()
                    TweenService:Create(ToggleKnob, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)}):Play()
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
                Parent = TabData.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 45),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })

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
                BackgroundColor3 = Color3.fromRGB(90, 90, 90),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 6),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })

            local SliderFill = CreateModule.Instance("Frame", {
                Parent = SliderBar,
                Name = "SliderFill",
                BackgroundColor3 = Library.Theme.Accent,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(1, 0)
            })

            local SliderKnob = CreateModule.Instance("Frame", {
                Parent = SliderBar,
                Name = "SliderKnob",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, -5),
                Size = UDim2.new(0, 10, 0, 10),
                ZIndex = 4
            })

            CreateModule.Instance("UICorner", {
                Parent = SliderKnob,
                CornerRadius = UDim.new(1, 0)
            })

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
                Parent = TabData.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 6)
            })

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
                Image = "rbxassetid://7072706620",
                ImageColor3 = Library.Theme.FontColor,
                ZIndex = 3
            })

            local OptionFrame = CreateModule.Instance("Frame", {
                Parent = Dropdown,
                Name = "OptionFrame",
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 5),
                Size = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 5
            })

            CreateModule.Instance("UICorner", {
                Parent = OptionFrame,
                CornerRadius = UDim.new(0, 6)
            })

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
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, -5, 0, 30),
                        Font = Enum.Font[Library.Theme.Font],
                        Text = tostring(option),
                        TextColor3 = option == Selected and Library.Theme.OptionSelected or Library.Theme.FontColor,
                        TextSize = 16,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 5
                    })

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
                if input.UserInputType == Enum.UserInputType.Touch and IsOpen and input.Position.X < Dropdown.AbsolutePosition.X or input.Position.X > Dropdown.AbsolutePosition.X + Dropdown.AbsoluteSize.X or input.Position.Y < Dropdown.AbsolutePosition.Y or input.Position.Y > Dropdown.AbsolutePosition.Y + Dropdown.AbsoluteSize.Y + (OptionFrame.Visible and OptionFrame.AbsoluteSize.Y or 0) then
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

    function InMain.Tab(TabName)
        return CreateTab(TabName)
    end

    return InMain
end

return Library
