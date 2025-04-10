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
        TabSelectedText = Color3.fromRGB(0, 0, 0),
        TabUnselectedText = Color3.fromRGB(255, 255, 255)
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
        Draggable = false,
        Visible = true,
        ZIndex = 3
    })

    CreateModule.Instance("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })

    local TabFrame = CreateModule.Instance("Frame", {
        Parent = MainFrame,
        Name = "TabFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 150, 1, 0),
        ZIndex = 4
    })

    local TabContainer = CreateModule.Instance("Frame", {
        Parent = TabFrame,
        Name = "TabContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
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
        Position = UDim2.new(0, 150, 0, 10),
        Size = UDim2.new(1, -160, 1, -20),
        ZIndex = 3
    })

    local isDraggingUI = false
    local dragStartPos = nil
    local dragStartFramePos = nil

    TabFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDraggingUI = true
            dragStartPos = input.Position
            dragStartFramePos = MainFrame.Position
        end
    end)

    TabFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and isDraggingUI then
            local delta = input.Position - dragStartPos
            local newPos = UDim2.new(
                dragStartFramePos.X.Scale,
                dragStartFramePos.X.Offset + delta.X,
                dragStartFramePos.Y.Scale,
                dragStartFramePos.Y.Offset + delta.Y
            )
            MainFrame.Position = newPos
        end
    end)

    TabFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDraggingUI = false
            dragStartPos = nil
            dragStartFramePos = nil
        end
    end)

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
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -10, 0, 40),
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
                    Tabs[CurrentTab].Button.BackgroundTransparency = 1
                    Tabs[CurrentTab].Button.TextColor3 = Library.Theme.TabUnselectedText
                end
                TabContent.Visible = true
                TabButton.BackgroundTransparency = 0
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
            TabButton.BackgroundTransparency = 0
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
                Size = UDim2.new(1, -10, 0, 40),
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
                Size = UDim2.new(1, -10, 0, 50),
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

        return TabFunctions
    end

    function InMain.Tab(TabName)
        return CreateTab(TabName)
    end

    return InMain
end

return Library
