local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Linux = {
    Theme = {
        Background = Color3.fromRGB(24, 24, 24),
        Element = Color3.fromRGB(28, 28, 28),
        Accent = Color3.fromRGB(80, 120, 255),
        Text = Color3.fromRGB(220, 220, 220),
        Toggle = Color3.fromRGB(40, 40, 40),
        TabActive = Color3.fromRGB(80, 120, 255),
        TabInactive = Color3.fromRGB(28, 28, 28)
    }
}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

function Linux.Create(Name)
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "LinuxUI" then
            v:Destroy()
        end
    end

    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = "LinuxUI",
        Parent = game.CoreGui,
        ResetOnSpawn = false
    })

    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Linux.Theme.Background,
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Active = true,
        Draggable = true,
        ZIndex = 1
    })

    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 5)
    })

    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 2
    })

    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 5)
    })

    local Title = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = Name,
        TextColor3 = Linux.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2
    })

    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, 110, 1, -25),
        ZIndex = 2
    })

    local TabHolder = Linux.Instance("Frame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2
    })

    local TabLayout = Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 3),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })

    local TabPadding = Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5)
    })

    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 110, 0, 25),
        Size = UDim2.new(1, -110, 1, -25),
        ZIndex = 1
    })

    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            Main.Visible = not Main.Visible
        end
    end)

    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil

    function LinuxLib.Tab(Name)
        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Linux.Theme.TabInactive,
            Size = UDim2.new(1, -5, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = Name,
            TextColor3 = Linux.Theme.TabInactiveText or Linux.Theme.Text,
            TextSize = 14,
            ZIndex = 2
        })

        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 4)
        })

        local TabContent = Linux.Instance("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Visible = false,
            ZIndex = 1
        })

        local ContentLayout = Linux.Instance("UIListLayout", {
            Parent = TabContent,
            Padding = UDim.new(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local ContentPadding = Linux.Instance("UIPadding", {
            Parent = TabContent,
            PaddingLeft = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5)
        })

        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then
                Tabs[CurrentTab].Content.Visible = false
                Tabs[CurrentTab].Button.BackgroundColor3 = Linux.Theme.TabInactive
                Tabs[CurrentTab].Button.TextColor3 = Linux.Theme.TabInactiveText or Linux.Theme.Text
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Linux.Theme.TabActive
            TabBtn.TextColor3 = Linux.Theme.Text
            CurrentTab = Name
        end)

        Tabs[Name] = {
            Button = TabBtn,
            Content = TabContent
        }

        if not CurrentTab then
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Linux.Theme.TabActive
            TabBtn.TextColor3 = Linux.Theme.Text
            CurrentTab = Name
        end

        local TabElements = {}

        function TabElements.Button(config)
            local Btn = Linux.Instance("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                LayoutOrder = config.LayoutOrder or #TabContent:GetChildren(),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Btn,
                CornerRadius = UDim.new(0, 4)
            })

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Accent}):Play()
                spawn(function() config.Callback() end)
                wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Element}):Play()
            end)

            return Btn
        end

        function TabElements.Toggle(config)
            local Toggle = Linux.Instance("Frame", {
                Parent = TabContent,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                LayoutOrder = config.LayoutOrder or #TabContent:GetChildren(),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 4)
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ToggleBox = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 40, 0, 16),
                Position = UDim2.new(1, -45, 0.5, -8),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = ToggleBox,
                CornerRadius = UDim.new(1, 0)
            })

            local Knob = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Linux.Theme.Text,
                Size = UDim2.new(0, 12, 1, -2),
                Position = UDim2.new(0, 1, 0, 1),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            local State = config.Default or false

            local function UpdateToggle()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if State then
                    TweenService:Create(ToggleBox, tween, {BackgroundColor3 = Linux.Theme.Accent}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -13, 0, 1)}):Play()
                else
                    TweenService:Create(ToggleBox, tween, {BackgroundColor3 = Linux.Theme.Toggle}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 1, 0, 1)}):Play()
                end
            end

            UpdateToggle()

            Toggle.MouseButton1Click:Connect(function()
                State = not State
                UpdateToggle()
                spawn(function() config.Callback(State) end)
            end)

            return Toggle
        end

        function TabElements.Dropdown(config)
            local Dropdown = Linux.Instance("TextButton", {
                Parent = TabContent,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                LayoutOrder = config.LayoutOrder or #TabContent:GetChildren(),
                Font = Enum.Font.SourceSans,
                Text = "",
                TextSize = 14,
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 4)
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 1
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -20, 0.5, -7),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 1
            })

            local DropFrame = Linux.Instance("Frame", {
                Parent = LinuxUI,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, 0),
                Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 30),
                Visible = false,
                ClipsDescendants = true,
                ZIndex = 3
            })

            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 4)
            })

            local DropScroll = Linux.Instance("ScrollingFrame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -5, 1, -5),
                Position = UDim2.new(0, 5, 0, 5),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Linux.Theme.Accent,
                ZIndex = 3
            })

            local DropLayout = Linux.Instance("UIListLayout", {
                Parent = DropScroll,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            local Options = config.Options or {}
            local Current = config.Default or (Options[1] or "None")
            local IsOpen = false

            local function UpdateSize()
                local maxHeight = math.min(#Options * 27 + 5, 200)
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if IsOpen then
                    DropFrame.Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, maxHeight)
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                    DropFrame.Visible = true
                else
                    DropFrame.Size = UDim2.new(0, Dropdown.AbsoluteSize.X, 0, 0)
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                    DropFrame.Visible = false
                end
                DropFrame.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 30)
            end

            local function AdjustElementsBelow()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                local dropHeight = IsOpen and math.min(#Options * 27 + 5, 200) or 0
                for _, child in pairs(TabContent:GetChildren()) do
                    if (child:IsA("Frame") or child:IsA("TextButton")) and child.LayoutOrder > Dropdown.LayoutOrder then
                        local baseY = (child.LayoutOrder - 1) * (30 + 4)
                        local newY = baseY + (IsOpen and dropHeight + 4 or 0)
                        TweenService:Create(child, tween, {Position = UDim2.new(0, 0, 0, newY)}):Play()
                    end
                end
            end

            local function PopulateOptions()
                for _, child in pairs(DropScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for _, opt in pairs(Options) do
                    local OptBtn = Linux.Instance("TextButton", {
                        Parent = DropScroll,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -5, 0, 25),
                        Font = Enum.Font.SourceSans,
                        Text = tostring(opt),
                        TextColor3 = opt == Current and Linux.Theme.Accent or Linux.Theme.Text,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 3
                    })

                    OptBtn.MouseButton1Click:Connect(function()
                        Current = opt
                        Selected.Text = tostring(opt)
                        for _, btn in pairs(DropScroll:GetChildren()) do
                            if btn:IsA("TextButton") then
                                btn.TextColor3 = btn.Text == opt and Linux.Theme.Accent or Linux.Theme.Text
                            end
                        end
                        IsOpen = false
                        UpdateSize()
                        AdjustElementsBelow()
                        spawn(function() config.Callback(opt) end)
                    end)
                end
            end

            PopulateOptions()

            Dropdown.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                UpdateSize()
                AdjustElementsBelow()
            end)

            local BackgroundClick = Linux.Instance("TextButton", {
                Parent = LinuxUI,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = "",
                ZIndex = 2,
                Visible = false
            })

            BackgroundClick.MouseButton1Click:Connect(function()
                if IsOpen then
                    IsOpen = false
                    UpdateSize()
                    AdjustElementsBelow()
                    BackgroundClick.Visible = false
                end
            end)

            Dropdown.MouseButton1Click:Connect(function()
                BackgroundClick.Visible = IsOpen
            end)

            local function SetOptions(newOpts)
                Options = newOpts or {}
                Current = config.Default or (Options[1] or "None")
                Selected.Text = tostring(Current)
                PopulateOptions()
                if IsOpen then
                    IsOpen = false
                    UpdateSize()
                    AdjustElementsBelow()
                    BackgroundClick.Visible = false
                end
            end

            local function SetValue(val)
                if table.find(Options, val) then
                    Current = val
                    Selected.Text = tostring(val)
                    for _, btn in pairs(DropScroll:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Text == val and Linux.Theme.Accent or Linux.Theme.Text
                        end
                    end
                    spawn(function() config.Callback(val) end)
                end
            end

            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return Current end
            }
        end

        return TabElements
    end

    return LinuxLib
end

return Linux
