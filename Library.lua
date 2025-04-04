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
        OptionSelected = Color3.fromRGB(200, 200, 200),
        TitleBarLine = Color3.fromRGB(75, 75, 75)
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
            local Dropdown = {
                Values = config.Values or {},
                Value = config.Default,
                Multi = config.Multi or false,
                Buttons = {},
                Opened = false,
                Callback = config.Callback or function() end
            }

            local DropdownFrame = CreateModule.Instance("Frame", {
                Parent = TabData.Container,
                Name = config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 35),
                ZIndex = 3
            })

            CreateModule.Instance("UICorner", {
                Parent = DropdownFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local DropdownDisplay = CreateModule.Instance("TextLabel", {
                Parent = DropdownFrame,
                Name = "DropdownDisplay",
                Font = Enum.Font[Library.Theme.Font],
                Text = config.Name,
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 3
            })

            local ValueDisplay = CreateModule.Instance("TextLabel", {
                Parent = DropdownFrame,
                Name = "ValueDisplay",
                Font = Enum.Font[Library.Theme.Font],
                Text = "",
                TextColor3 = Library.Theme.FontColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Right,
                Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 3
            })

            local DropdownIco = CreateModule.Instance("ImageLabel", {
                Parent = DropdownFrame,
                Name = "DropdownIco",
                Image = "rbxassetid://10709767827",
                Size = UDim2.fromOffset(16, 16),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                BackgroundTransparency = 1,
                ImageColor3 = Library.Theme.FontColor,
                ZIndex = 3
            })

            local DropdownHolder = CreateModule.Instance("Frame", {
                Parent = DarkSquareLib,
                Name = "DropdownHolder_" .. config.Name,
                BackgroundColor3 = Library.Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 170, 0, 0),
                Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + 35),
                Visible = false,
                ZIndex = 5
            })

            CreateModule.Instance("UICorner", {
                Parent = DropdownHolder,
                CornerRadius = UDim.new(0, 6)
            })

            local DropdownScrollFrame = CreateModule.Instance("ScrollingFrame", {
                Parent = DropdownHolder,
                Size = UDim2.new(1, -5, 1, -10),
                Position = UDim2.fromOffset(5, 5),
                BackgroundTransparency = 1,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
                ScrollBarImageTransparency = 0.95,
                BorderSizePixel = 0,
                CanvasSize = UDim2.fromScale(0, 0),
                ZIndex = 5
            })

            local DropdownListLayout = CreateModule.Instance("UIListLayout", {
                Parent = DropdownScrollFrame,
                Padding = UDim.new(0, 3),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top
            })

            local function RecalculateListPosition()
                local posY = DropdownFrame.AbsolutePosition.Y + 35
                if game.Workspace.CurrentCamera.ViewportSize.Y - posY < DropdownHolder.Size.Y.Offset then
                    posY = DropdownFrame.AbsolutePosition.Y - DropdownHolder.Size.Y.Offset - 5
                end
                DropdownHolder.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, posY)
            end

            local function RecalculateListSize()
                if #Dropdown.Values > 10 then
                    DropdownHolder.Size = UDim2.new(0, 170, 0, 300)
                else
                    DropdownHolder.Size = UDim2.new(0, 170, 0, DropdownListLayout.AbsoluteContentSize.Y + 10)
                end
            end

            local function RecalculateCanvasSize()
                DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
            end

            local function DisplayValue()
                local str = ""
                if Dropdown.Multi then
                    for value, selected in pairs(Dropdown.Value or {}) do
                        if selected then
                            str = str .. value .. ", "
                        end
                    end
                    str = str:sub(1, #str - 2)
                else
                    str = Dropdown.Value or ""
                end
                ValueDisplay.Text = str == "" and "--" or str
            end

            local function BuildDropdownList()
                for _, child in pairs(DropdownScrollFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                Dropdown.Buttons = {}

                for _, value in pairs(Dropdown.Values) do
                    local Button = CreateModule.Instance("TextButton", {
                        Parent = DropdownScrollFrame,
                        Size = UDim2.new(1, -5, 0, 32),
                        BackgroundColor3 = Library.Theme.Element,
                        BorderSizePixel = 0,
                        Text = "",
                        ZIndex = 5
                    })

                    CreateModule.Instance("UICorner", {
                        Parent = Button,
                        CornerRadius = UDim.new(0, 6)
                    })

                    local ButtonLabel = CreateModule.Instance("TextLabel", {
                        Parent = Button,
                        Font = Enum.Font[Library.Theme.Font],
                        Text = tostring(value),
                        TextColor3 = Library.Theme.FontColor,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -10, 1, 0),
                        Position = UDim2.fromOffset(10, 0),
                        ZIndex = 5
                    })

                    local Selected = Dropdown.Multi and (Dropdown.Value and Dropdown.Value[value]) or (Dropdown.Value == value)

                    local function UpdateButton()
                        if Dropdown.Multi then
                            Selected = Dropdown.Value and Dropdown.Value[value]
                        else
                            Selected = Dropdown.Value == value
                        end
                        ButtonLabel.TextColor3 = Selected and Library.Theme.OptionSelected or Library.Theme.FontColor
                    end

                    Button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch then
                            if Dropdown.Multi then
                                Dropdown.Value = Dropdown.Value or {}
                                Dropdown.Value[value] = not Dropdown.Value[value]
                            else
                                if Dropdown.Value == value and not config.AllowNull then
                                    return
                                end
                                Dropdown.Value = Dropdown.Value == value and nil or value
                                for _, btn in pairs(Dropdown.Buttons) do
                                    btn.Update()
                                end
                            end
                            UpdateButton()
                            DisplayValue()
                            spawn(function() Dropdown.Callback(Dropdown.Value) end)
                        end
                    end)

                    Dropdown.Buttons[Button] = { Update = UpdateButton }
                    UpdateButton()
                end

                RecalculateCanvasSize()
                RecalculateListSize()
                RecalculateListPosition()
            end

            DropdownFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    Dropdown.Opened = not Dropdown.Opened
                    DropdownHolder.Visible = Dropdown.Opened
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    TweenService:Create(DropdownHolder, tweenInfo, {Size = Dropdown.Opened and DropdownHolder.Size or UDim2.new(0, 170, 0, 0)}):Play()
                    TweenService:Create(DropdownIco, tweenInfo, {Rotation = Dropdown.Opened and 180 or 0}):Play()
                end
            end)

            MainFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and Dropdown.Opened then
                    local absPos = DropdownHolder.AbsolutePosition
                    local absSize = DropdownHolder.AbsoluteSize
                    if input.Position.X < absPos.X or input.Position.X > absPos.X + absSize.X or input.Position.Y < absPos.Y or input.Position.Y > absPos.Y + absSize.Y then
                        Dropdown.Opened = false
                        DropdownHolder.Visible = false
                        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        TweenService:Create(DropdownHolder, tweenInfo, {Size = UDim2.new(0, 170, 0, 0)}):Play()
                        TweenService:Create(DropdownIco, tweenInfo, {Rotation = 0}):Play()
                    end
                end
            end)

            function Dropdown:SetValues(newValues)
                if newValues then
                    Dropdown.Values = newValues
                end
                BuildDropdownList()
            end

            function Dropdown:SetValue(val)
                if Dropdown.Multi then
                    Dropdown.Value = {}
                    for _, v in pairs(val or {}) do
                        if table.find(Dropdown.Values, v) then
                            Dropdown.Value[v] = true
                        end
                    end
                else
                    Dropdown.Value = table.find(Dropdown.Values, val) and val or nil
                end
                BuildDropdownList()
                DisplayValue()
                spawn(function() Dropdown.Callback(Dropdown.Value) end)
            end

            BuildDropdownList()
            DisplayValue()

            if Dropdown.Multi and type(config.Default) == "table" then
                Dropdown.Value = {}
                for _, v in pairs(config.Default) do
                    if table.find(Dropdown.Values, v) then
                        Dropdown.Value[v] = true
                    end
                end
                BuildDropdownList()
                DisplayValue()
            end

            AddToReg(DropdownFrame)
            return {
                Instance = DropdownFrame,
                SetValues = Dropdown.SetValues,
                SetValue = Dropdown.SetValue,
                GetSelected = function() return Dropdown.Value end
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
