--[[

]]


local legion_logo = "https://raw.githubusercontent.com/penguin-cmyk/legion/refs/heads/main/logo.png"
if not isfile("legion_logo.png") then 
	writefile("legion_logo.png", game:HttpGet(legion_logo))
end 

local Library = {};
do
	Library = {
		Open = true;
		Accent = Color3.fromRGB(132, 81, 219);
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {};
		Instances = {};
		Holder = nil;
		OldSize = nil;
		ScreenGUI = nil;
		DropdownOpen = false,
		OptionListOpen = false,
		Keys = {
			[Enum.KeyCode.Space] = "Space",
			[Enum.KeyCode.Return] = "Return",
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.CapsLock] = "CAPS",
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.KeypadOne] = "Num1",
			[Enum.KeyCode.KeypadTwo] = "Num2",
			[Enum.KeyCode.KeypadThree] = "Num3",
			[Enum.KeyCode.KeypadFour] = "Num4",
			[Enum.KeyCode.KeypadFive] = "Num5",
			[Enum.KeyCode.KeypadSix] = "Num6",
			[Enum.KeyCode.KeypadSeven] = "Num7",
			[Enum.KeyCode.KeypadEight] = "Num8",
			[Enum.KeyCode.KeypadNine] = "Num9",
			[Enum.KeyCode.KeypadZero] = "Num0",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Asterisk] = "*",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		FontSize = 12;
		VisValues = {};
		UIKey = Enum.KeyCode.Insert;
		Notifs = {};
	}

	-- // Ignores
	local Flags = {} -- Ignore
	local ColorHolders = {}


	-- // Extension
	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
	local LocalPlayer = game:GetService('Players').LocalPlayer;
	local Mouse = LocalPlayer:GetMouse();
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")

	-- // Misc Functions
	do
		function Library:Connection(signal, Callback)
			local Con = signal:Connect(Callback)
			return Con
		end
		--
		function Library:Disconnect(Connection)
			Connection:Disconnect()
		end
		--
		function Library:Round(Number, Float)
			return Float * math.floor(Number / Float)
		end
		--
		function Library.NextFlag()
			Library.UnNamedFlags = Library.UnNamedFlags + 1
			return string.format("%.14g", Library.UnNamedFlags)
		end
		--
		function Library:GetConfig()
			local Config = ""
			for Index, Value in pairs(self.Flags) do
				if
					Index ~= "ConfigConfig_List"
					and Index ~= "ConfigConfig_Load"
					and Index ~= "ConfigConfig_Save"
				then
					local Value2 = Value
					local Final = ""
					--
					if typeof(Value2) == "Color3" then
						local hue, sat, val = Value2:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
					elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
						local hue, sat, val = Value2.Color:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
					elseif typeof(Value2) == "table" and Value.Mode then
						local Values = Value.current
						--
						Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
					elseif Value2 ~= nil then
						if typeof(Value2) == "boolean" then
							Value2 = ("bool(%s)"):format(tostring(Value2))
						elseif typeof(Value2) == "table" then
							local New = "table("
							--
							for Index2, Value3 in pairs(Value2) do
								New = New .. Value3 .. ","
							end
							--
							if New:sub(#New) == "," then
								New = New:sub(0, #New - 1)
							end
							--
							Value2 = New .. ")"
						elseif typeof(Value2) == "string" then
							Value2 = ("string(%s)"):format(Value2)
						elseif typeof(Value2) == "number" then
							Value2 = ("number(%s)"):format(Value2)
						end
						--
						Final = Value2
					end
					--
					Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
				end
			end
			--
			return Config
		end
		--
		function Library:LoadConfig(Config)
			local Table = string.split(Config, "\n")
			local Table2 = {}
			for Index, Value in pairs(Table) do
				local Table3 = string.split(Value, ":")
				--
				if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
					local Value = Table3[2]:sub(2, #Table3[2])
					--
					if Value:sub(1, 3) == "rgb" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 3) == "key" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						if Table4[1] == "nil" and Table4[2] == "nil" then
							Table4[1] = nil
							Table4[2] = nil
						end
						--
						Value = Table4
					elseif Value:sub(1, 4) == "bool" then
						local Bool = Value:sub(6, #Value - 1)
						--
						Value = Bool == "true"
					elseif Value:sub(1, 5) == "table" then
						local Table4 = string.split(Value:sub(7, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 6) == "string" then
						local String = Value:sub(8, #Value - 1)
						--
						Value = String
					elseif Value:sub(1, 6) == "number" then
						local Number = tonumber(Value:sub(8, #Value - 1))
						--
						Value = Number
					end
					--
					Table2[Table3[1]] = Value
				end
			end
			--
			for i, v in pairs(Table2) do
				if Flags[i] then
					if typeof(Flags[i]) == "table" then
						Flags[i]:Set(v)
					else
						Flags[i](v)
					end
				end
			end
		end
		--
		function Library:SetOpen(bool)
			if typeof(bool) == 'boolean' then
				Library.Open = bool;
				if Library.Open then
					Library.Holder.Visible = true
					--game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Library.OldSize.X.Offset,0,40)}):Play()
					game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Library.OldSize.X.Offset,0,Library.OldSize.Y.Offset)}):Play()
				else
					--game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Library.OldSize.X.Offset,0,40)}):Play()
					game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0,0,20)}):Play()
					task.wait(0.25)
					Library.Holder.Visible = false
				end
			end
		end;
		--
		function Library:ChangeAccent(Color)
			Library.Accent = Color

			for obj, theme in next, Library.ThemeObjects do
				if theme:IsA("Frame") or theme:IsA("TextButton") then
					theme.BackgroundColor3 = Color
				elseif theme:IsA("TextLabel") then
					theme.TextColor3 = Color
				elseif theme:IsA("ScrollingFrame") then
					theme.ScrollBarImageColor3 = Library.Accent
				end
			end
		end
		--
		function Library:IsMouseOverFrame(Frame)
			local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

			if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
				and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

				return true;
			end;

			return false;
		end;
	end

	-- // Colorpicker Element
	do
		function Library:NewPicker(name, default, parent, count, flag, callback)
			-- // Instances
			local ColorpickerFrame = Instance.new("TextButton")
			ColorpickerFrame.Name = "Colorpicker_frame"
			ColorpickerFrame.BackgroundColor3 = default
			ColorpickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ColorpickerFrame.BorderSizePixel = 0
			if count == 1 then
				ColorpickerFrame.Position = UDim2.new(1, - (count * 20),0.5,0)
			else
				ColorpickerFrame.Position = UDim2.new(1, - (count * 20) - (count * 4),0.5,0)
			end
			ColorpickerFrame.Size = UDim2.new(0, 20, 0, 20)
			ColorpickerFrame.AnchorPoint = Vector2.new(0,0.5)
			ColorpickerFrame.Text = ""
			ColorpickerFrame.AutoButtonColor = false

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ColorpickerFrame

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Name = "UIStroke"
			UIStroke.Color = Color3.fromRGB(40, 40, 40)
			UIStroke.Parent = ColorpickerFrame

			ColorpickerFrame.Parent = parent

			local Colorpicker = Instance.new("TextButton")
			Colorpicker.Name = "Colorpicker"
			Colorpicker.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Colorpicker.BorderSizePixel = 0
			Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y - 50)
			Colorpicker.Size = UDim2.new(0, 180, 0, 180)
			Colorpicker.Parent = Library.ScreenGUI
			Colorpicker.ZIndex = 100
			Colorpicker.Visible = false
			Colorpicker.Text = ""
			Colorpicker.AutoButtonColor = false
			local H,S,V = default:ToHSV()
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Name = "ImageLabel"
			ImageLabel.Image = "rbxassetid://11970108040"
			ImageLabel.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageLabel.BorderSizePixel = 0
			ImageLabel.Position = UDim2.new(0.0556, 0, 0.026, 0)
			ImageLabel.Size = UDim2.new(0, 160, 0, 154)
			ImageLabel.Parent = Colorpicker

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Colorpicker

			local ImageButton = Instance.new("ImageButton")
			ImageButton.Name = "ImageButton"
			ImageButton.Image = "rbxassetid://14684562507"
			ImageButton.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageButton.BorderSizePixel = 0
			ImageButton.Position = UDim2.new(0.056, 0, 0.026, 0)
			ImageButton.Size = UDim2.new(0, 160, 0, 154)
			ImageButton.AutoButtonColor = false

			local SVSlider = Instance.new("Frame")
			SVSlider.Name = "SV_slider"
			SVSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SVSlider.BackgroundTransparency = 1
			SVSlider.ClipsDescendants = true
			SVSlider.Position = UDim2.new(0.855, 0, 0.0966, 0)
			SVSlider.Size = UDim2.new(0,7,0,7)
			SVSlider.ZIndex = 3

			local Val = Instance.new("ImageLabel")
			Val.Name = "Val"
			Val.Image = "http://www.roblox.com/asset/?id=14684563800"
			Val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Val.BackgroundTransparency = 1
			Val.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Val.BorderSizePixel = 0
			Val.Size = UDim2.new(1, 0, 1, 0)
			Val.Parent = ImageButton

			local UICorner1 = Instance.new("UICorner")
			UICorner1.Name = "UICorner"
			UICorner1.CornerRadius = UDim.new(0, 100)
			UICorner1.Parent = SVSlider

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Name = "UIStroke"
			UIStroke.Color = Color3.fromRGB(255, 255, 255)
			UIStroke.Parent = SVSlider

			SVSlider.Parent = ImageButton

			ImageButton.Parent = Colorpicker

			local ImageButton1 = Instance.new("ImageButton")
			ImageButton1.Name = "ImageButton"
			ImageButton1.Image = "http://www.roblox.com/asset/?id=16789872274"
			ImageButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ImageButton1.BorderSizePixel = 0
			ImageButton1.Position = UDim2.new(0.5, 0,0, 165)
			ImageButton1.Size = UDim2.new(0, 160,0, 8)
			ImageButton1.AutoButtonColor = false
			ImageButton1.AnchorPoint = Vector2.new(0.5,0)
			ImageButton1.BackgroundTransparency = 1

			local Frame = Instance.new("Frame")
			Frame.Name = "Frame"
			Frame.BackgroundColor3 = Color3.fromRGB(254, 254, 254)
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.926, 0,0.5, 0)
			Frame.Size = UDim2.new(0, 12,0, 12)
			Frame.AnchorPoint = Vector2.new(0,0.5)
			Frame.ZIndex = 45

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner"
			UICorner2.Parent = Frame
			UICorner2.CornerRadius = UDim.new(1,0)

			local UICorner3 = Instance.new("UICorner")
			UICorner3.Name = "UICorner"
			UICorner3.Parent = ImageButton1

			Frame.Parent = ImageButton1

			ImageButton1.Parent = Colorpicker

			-- // Connections
			local mouseover = false
			local hue, sat, val = default:ToHSV()
			local hsv = default:ToHSV()
			local oldcolor = hsv
			local slidingsaturation = false
			local slidinghue = false
			local slidingalpha = false

			local function update()
				local real_pos = game:GetService("UserInputService"):GetMouseLocation()
				local mouse_position = Vector2.new(real_pos.X, real_pos.Y - 30)
				local relative_palette = (mouse_position - ImageButton.AbsolutePosition)
				local relative_hue     = (mouse_position - ImageButton1.AbsolutePosition)
				--
				if slidingsaturation then
					sat = math.clamp(1 - relative_palette.X / ImageButton.AbsoluteSize.X, 0, 1)
					val = math.clamp(1 - relative_palette.Y / ImageButton.AbsoluteSize.Y, 0, 1)
				elseif slidinghue then
					hue = math.clamp(relative_hue.X / ImageButton.AbsoluteSize.X, 0, 1)
				end

				hsv = Color3.fromHSV(hue, sat, val)
				TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
				ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				ColorpickerFrame.BackgroundColor3 = hsv

				TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()

				if flag then
					Library.Flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
				end

				callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
			end

			local function set(color)
				if type(color) == "table" then
					color = Color3.fromHSV(color[1], color[2], color[3])
				end
				if type(color) == "string" then
					color = Color3.fromHex(color)
				end

				local oldcolor = hsv

				hue, sat, val = color:ToHSV()
				hsv = Color3.fromHSV(hue, sat, val)

				if hsv ~= oldcolor then
					ColorpickerFrame.BackgroundColor3 = hsv
					TweenService:Create(SVSlider, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 1 - 0.055), 0, math.clamp(1 - val, 0.000, 1 - 0.045), 0)}):Play()
					ImageButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					TweenService:Create(Frame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.982),-5,0.5,0)}):Play()

					if flag then
						Library.Flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
					end

					callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
				end
			end

			Flags[flag] = set

			set(default)

			ImageButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = true
					update()
				end
			end)

			ImageButton.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = false
					update()
				end
			end)

			ImageButton1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = true
					update()
				end
			end)

			ImageButton1.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = false
					update()
				end
			end)

			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if slidinghue then
						update()
					end

					if slidingsaturation then
						update()
					end
				end
			end)

			local colorpickertypes = {}

			function colorpickertypes:Set(color, newalpha)
				set(color, newalpha)
			end

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Colorpicker.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(Colorpicker) and not Library:IsMouseOverFrame(ColorpickerFrame) then
						Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)
						TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)}):Play()
						task.spawn(function()
							task.wait(0.1)
							Colorpicker.Visible = false
							parent.ZIndex = 1
							Library.Cooldown = false
						end)
						for _,V in next, Colorpicker:GetDescendants() do
							if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
								Library.VisValues[V] = V.BackgroundTransparency
							elseif V:IsA("TextLabel") or V:IsA("TextBox") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
								Library.VisValues[V] = V.TextTransparency
							elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play();
								Library.VisValues[V] = V.ImageTransparency
							elseif V:IsA("UIStroke") then
								TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
								Library.VisValues[V] = V.Transparency
							end
						end
					end
				end
			end)

			ColorpickerFrame.MouseButton1Down:Connect(function()
				if Colorpicker.Visible == false then
					Colorpicker.Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y)
					TweenService:Create(Colorpicker, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, ColorpickerFrame.AbsolutePosition.X - 100, 0, ColorpickerFrame.AbsolutePosition.Y + 25)}):Play()
				end
				Colorpicker.Visible = true
				parent.ZIndex = 100
				Library.Cooldown = true
				TweenService:Create(Colorpicker, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				for _,V in next, Colorpicker:GetDescendants() do
					if V:IsA("Frame") or V:IsA("TextButton") or V:IsA("ScrollingFrame") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("TextLabel") or V:IsA("TextBox") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextTransparency = Library.VisValues[V]}):Play()
					elseif V:IsA("ImageLabel") or V:IsA("ImageButton") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageTransparency = Library.VisValues[V]}):Play();
					elseif V:IsA("UIStroke") then
						TweenService:Create(V, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()
					end
				end

				if slidinghue then
					slidinghue = false
				end

				if slidingsaturation then
					slidingsaturation = false
				end
			end)

			return colorpickertypes, Colorpicker
		end
	end


	function Library:updateNotifsPositions(position)
		for i, v in pairs(Library.Notifs) do 
			local Position = Vector2.new(20, 20)
			game:GetService("TweenService"):Create(v.Container, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,Position.X,0,Position.Y + (i * 25))}):Play()
		end 
	end

	function Library:Notification(message, duration)
		local notification = {Container = nil, Objects = {}}
		--
		local Position = Vector2.new(20, 20)
		--
		local NewInd = Instance.new("Frame")
		NewInd.Name = "NewInd"
		NewInd.AutomaticSize = Enum.AutomaticSize.X
		NewInd.Position = UDim2.new(0,20,0,20)
		NewInd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		NewInd.BackgroundTransparency = 1
		NewInd.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NewInd.Size = UDim2.fromOffset(0, 20)
		NewInd.Parent = Library.ScreenGUI
		notification.Container = NewInd

		local Outline = Instance.new("Frame")
		Outline.Name = "Outline"
		Outline.AnchorPoint = Vector2.new(0, 0)
		Outline.AutomaticSize = Enum.AutomaticSize.X
		Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Outline.BorderSizePixel = 1
		Outline.Position = UDim2.new(0,0,0,0)
		Outline.Size = UDim2.fromOffset(0, 20)
		Outline.Visible = true
		Outline.ZIndex = 50
		Outline.Parent = NewInd
		Outline.BackgroundTransparency = 1

		local UICorner = Instance.new("UICorner")
		UICorner.Name = "UICorner"
		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Outline

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Name = "UIStroke"
		UIStroke.Parent = Outline
		UIStroke.Transparency = 1

		local Inline = Instance.new("Frame")
		Inline.Name = "Inline"
		Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
		Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Inline.BorderSizePixel = 0
		Inline.Position = UDim2.fromOffset(1, 1)
		Inline.Size = UDim2.new(1, -2, 1, -2)
		Inline.ZIndex = 51
		Inline.BackgroundTransparency = 1

		local UICorner2 = Instance.new("UICorner")
		UICorner2.Name = "UICorner_2"
		UICorner2.CornerRadius = UDim.new(0, 4)
		UICorner2.Parent = Inline

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
		Title.RichText = true
		Title.Text = message
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 13
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.AutomaticSize = Enum.AutomaticSize.X
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.fromOffset(5, 0)
		Title.Size = UDim2.fromScale(0, 1)
		Title.Parent = Inline
		Title.TextTransparency = 1

		local UIPadding = Instance.new("UIPadding")
		UIPadding.Name = "UIPadding"
		UIPadding.PaddingRight = UDim.new(0, 6)
		UIPadding.Parent = Inline

		Inline.Parent = Outline


		function notification:remove()
			table.remove(Library.Notifs, table.find(Library.Notifs, notification))
			Library:updateNotifsPositions(Position)
			task.wait(0.5)
			NewInd:Destroy()
		end

		task.spawn(function()
			Outline.AnchorPoint = Vector2.new(1,0)
			for i,v in next, NewInd:GetDescendants() do
				if v:IsA("Frame") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
				elseif v:IsA("UIStroke") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0}):Play()
				end
			end
			local Tween1 = game:GetService("TweenService"):Create(Outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0,0)}):Play()
			game:GetService("TweenService"):Create(Title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			task.wait(duration)
			--game:GetService("TweenService"):Create(ActualInd, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(1,0)}):Play()
			for i,v in next, NewInd:GetDescendants() do
				if v:IsA("Frame") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
				elseif v:IsA("UIStroke") then
					game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 1}):Play()
				end
			end
			game:GetService("TweenService"):Create(Title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		end)

		task.delay(duration + 0.1, function()
			notification:remove()
		end)

		table.insert(Library.Notifs, notification)
		Library:updateNotifsPositions(Position)
		NewInd.Position = UDim2.new(0,Position.X,0,Position.Y + (table.find(Library.Notifs, notification) * 25))
		return notification
	end

	-- // Main
	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;
		--
		function Library:New(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Window = {
				Size = Properties.Size or UDim2.new(0,600,0,450),
				Pages = {},
				PageAxis = 0,
				Dragging = { false, UDim2.new(0, 0, 0, 0) },
				Resized = nil,
				Elements = {},
			}
			--
			local ScreenGui = Instance.new('ScreenGui', gethui())
			local Outline = Instance.new('Frame', ScreenGui)
			local UICorner = Instance.new('UICorner', Outline)
			local UIStroke = Instance.new('UIStroke', Outline)
			local Inline = Instance.new('Frame', Outline)
			local UICorner_2 = Instance.new('UICorner', Inline)
			local Holder = Instance.new('Frame', Inline)
			local UICorner = Instance.new('UICorner', Holder)
			local Frame = Instance.new('Frame', Holder)
			local Tabs = Instance.new('Frame', Inline)
			local UIListLayout = Instance.new('UIListLayout', Tabs)
			local TextButton = Instance.new('TextButton', Inline)
			--
			ScreenGui.DisplayOrder = 100
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Library.ScreenGUI = ScreenGui
			--
			Outline.Name = "Outline"
			Outline.Position = UDim2.new(0.5,0,0.5,0)
			Outline.Size = UDim2.new(0,0,0,40)
			Outline.BackgroundColor3 = Color3.new(0.1961,0.1961,0.1961)
			Outline.BorderColor3 = Color3.new(0,0,0)
			Outline.AnchorPoint = Vector2.new(0.5,0.5)
			Outline.ZIndex = 50
			Outline.ClipsDescendants = false
			Library.Holder = Outline
			Library.OldSize = Window.Size
			--
			local Logo = Instance.new("ImageLabel")
			Logo.Name = "Logo"
			Logo.Image = Properties.Logo or getcustomasset("legion_logo.png")
			Logo.ScaleType = Enum.ScaleType.Fit
			Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Logo.BackgroundTransparency = 1
			Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Logo.BorderSizePixel = 0
			Logo.Position = UDim2.fromOffset(10, -20)
			Logo.Size = UDim2.fromOffset(90, 90)
			Logo.Parent = Holder
			--
			Inline.Name = "Inline"
			Inline.Position = UDim2.new(0,1,0,1)
			Inline.Size = UDim2.new(1,-2,1,-2)
			Inline.BackgroundColor3 = Color3.new(0.051,0.051,0.051)
			Inline.BorderSizePixel = 0
			Inline.BorderColor3 = Color3.new(0,0,0)
			Inline.ZIndex = 51
			--
			Holder.Name = "Holder"
			Holder.Position = UDim2.new(0,150,0,0)
			Holder.Size = UDim2.new(1,-150,1,0)
			Holder.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
			Holder.BorderSizePixel = 0
			Holder.BorderColor3 = Color3.new(0,0,0)
			Holder.ZIndex = 52
			--
			Frame.Size = UDim2.new(0,5,1,0)
			Frame.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
			Frame.BorderSizePixel = 0
			Frame.BorderColor3 = Color3.new(0,0,0)
			--
			Tabs.Name = "Tabs"
			Tabs.Position = UDim2.new(0,5,0,10)
			Tabs.Size = UDim2.new(0,140,1,-20)
				Tabs.BackgroundColor3 = Color3.new(1,1,1)
			Tabs.BackgroundTransparency = 1.01
			Tabs.BorderSizePixel = 0
			Tabs.BorderColor3 = Color3.new(0,0,0)
			--
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,4)
			--
			TextButton.Size = UDim2.new(1,0,0,20)
			TextButton.BackgroundColor3 = Color3.new(1,1,1)
			TextButton.BackgroundTransparency = 1
			TextButton.BorderSizePixel = 0
			TextButton.BorderColor3 = Color3.new(0,0,0)
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.new(0,0,0)
			TextButton.AutoButtonColor = false
			TextButton.Font = Enum.Font.SourceSans
			TextButton.TextSize = 14
			TextButton.ZIndex = 100

			local Line1 = Instance.new("Frame")
			Line1.Name = "Line1"
			Line1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Line1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Line1.BorderSizePixel = 0
			Line1.Position = UDim2.fromOffset(0, 50)
			Line1.Size = UDim2.new(1, 0, 0, 1)
			Line1.Parent = Holder

			local Line2 = Instance.new("Frame")
			Line2.Name = "Line2"
			Line2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Line2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Line2.BorderSizePixel = 0
			Line2.Size = UDim2.new(0, 1, 1, 0)
			Line2.Parent = Holder

			local Logo = Instance.new("ImageLabel")
			Logo.Name = "Logo"
			Logo.Image = "http://www.roblox.com/asset/?id=17669613413"
			Logo.ScaleType = Enum.ScaleType.Fit
			Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Logo.BackgroundTransparency = 1
			Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Logo.BorderSizePixel = 0
			Logo.Position = UDim2.fromOffset(10, -20)
			Logo.Size = UDim2.fromOffset(90, 90)
			Logo.Parent = Holder

			local FadeThing = Instance.new("Frame")
			FadeThing.Name = "FadeThing"
			FadeThing.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			FadeThing.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FadeThing.BorderSizePixel = 0
			FadeThing.Position = UDim2.fromOffset(9, 59)
			FadeThing.Size = UDim2.new(1, -18, 1, -63)
			FadeThing.ZIndex = 55
			FadeThing.Parent = Holder
			FadeThing.Visible = false

			-- // Elements
			Window.Elements = {
				TabHolder = Tabs,
				Holder = Holder,
				FadeThing = FadeThing
			}

			-- // Dragging
			Library:Connection(TextButton.MouseButton1Down, function()
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				Window.Dragging[1] = true
				Window.Dragging[2] =
					UDim2.new(0, Location.X - Outline.AbsolutePosition.X, 0, Location.Y - Outline.AbsolutePosition.Y)
			end)
			Library:Connection(game:GetService("UserInputService").InputEnded, function(Input, IsTyping)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Window.Dragging[1] = false
					Window.Dragging[2] = UDim2.new(0, 0, 0, 0)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(Input)
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				local ActualLocation = nil

				-- Dragging
				if Window.Dragging[1] then

					game:GetService("TweenService"):Create(Outline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,Location.X - Window.Dragging[2].X.Offset + (Outline.Size.X.Offset * Outline.AnchorPoint.X),0,Location.Y - Window.Dragging[2].Y.Offset + (Outline.Size.Y.Offset * Outline.AnchorPoint.Y))}):Play()
				end
			end)

			-- // Functions
			function Window:UpdateTabs()
				for Index, Page in pairs(Window.Pages) do
					Page:Turn(Page.Open)
				end
			end

			Library:Connection(game:GetService("UserInputService").InputBegan, function(Inp)
				if Inp.KeyCode == Library.UIKey then
					Library:SetOpen(not Library.Open)
				end
			end)

			game:GetService("TweenService"):Create(Library.Holder, TweenInfo.new(0.25, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Window.Size.X.Offset,0,Window.Size.Y.Offset)}):Play()

			-- // Returns
			Library.Holder = Outline
			return setmetatable(Window, Library)
		end
		--
		function Library:Seperator(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Page = {
				Name = Properties.Name or "Page",
				Window = self,
				Elements = {},
			}
			--
			local TextSep = Instance.new('Frame', Page.Window.Elements.TabHolder)
			local TextLabel = Instance.new('TextLabel', TextSep)
			--
			TextSep.Name = "TextSep"
			TextSep.Size = UDim2.new(1,0,0,20)
			TextSep.BackgroundColor3 = Color3.new(1,1,1)
			TextSep.BackgroundTransparency = 1
			TextSep.BorderSizePixel = 0
			TextSep.BorderColor3 = Color3.new(0,0,0)
			--
			TextLabel.Position = UDim2.new(0,8,0,0)
			TextLabel.Size = UDim2.new(1,-10,1,0)
			TextLabel.BackgroundColor3 = Color3.new(1,1,1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.BorderSizePixel = 0
			TextLabel.BorderColor3 = Color3.new(0,0,0)
			TextLabel.Text = Page.Name
			TextLabel.TextColor3 = Color3.new(0.7059,0.7059,0.7059)
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextSize = Library.FontSize
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		end
		--
		function Library:Page(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Page = {
				Name = Properties.Name or "Page",
				Icon = Properties.Icon or "http://www.roblox.com/asset/?id=6022668955",
				Window = self,
				Open = false,
				Sections = {},
				Elements = {},
			}
			--
			local TabButton = Instance.new('TextButton', Page.Window.Elements.TabHolder)
			local UICorner_3 = Instance.new('UICorner', TabButton)
			local Accent = Instance.new('Frame', TabButton)
			local UICorner = Instance.new('UICorner', Accent)
			local Title = Instance.new('TextLabel', TabButton)
			local Icon = Instance.new('ImageLabel', TabButton)
			local NewPage = Instance.new('Frame', Page.Window.Elements.Holder)
			local Left = Instance.new('Frame', NewPage)
			local LeftLayout = Instance.new('UIListLayout', Left)
			local Right = Instance.new('Frame', NewPage)
			local RightLayout = Instance.new('UIListLayout', Right)
			--
			TabButton.Name = "TabButton"
			TabButton.Size = UDim2.new(1,0,0,30)
			TabButton.BackgroundColor3 = Color3.new(0.0784,0.0784,0.0784)
			TabButton.BorderSizePixel = 0
			TabButton.BackgroundTransparency = 1
			TabButton.BorderColor3 = Color3.new(0,0,0)
			TabButton.Text = ""
			TabButton.TextColor3 = Color3.new(0,0,0)
			TabButton.AutoButtonColor = false
			TabButton.Font = Enum.Font.SourceSans
			TabButton.TextSize = 14
			TabButton.ClipsDescendants = true
			--
			Accent.Name = "Accent"
			Accent.Position = UDim2.new(0,-8,0,5)
			Accent.Size = UDim2.new(0,10,1,-10)
			Accent.BackgroundColor3 = Library.Accent
			Accent.BorderSizePixel = 0
			Accent.BorderColor3 = Color3.new(0,0,0)
			Accent.BackgroundTransparency = 0
			table.insert(Library.ThemeObjects, Accent)
			--
			Title.Name = "Title"
			Title.Position = UDim2.new(0,35,0,0)
			Title.Size = UDim2.new(1,-10,1,0)
			Title.BackgroundColor3 = Color3.new(1,1,1)
			Title.BackgroundTransparency = 1
			Title.BorderSizePixel = 0
			Title.BorderColor3 = Color3.new(0,0,0)
			Title.Text = Page.Name
			Title.TextColor3 = Color3.fromRGB(120,120,120)
			Title.Font = Enum.Font.Gotham
			Title.TextSize = Library.FontSize
			Title.TextXAlignment = Enum.TextXAlignment.Left
			--
			Icon.Name = "Icon"
			Icon.Position = UDim2.new(0,11,0,8)
			Icon.Size = UDim2.new(0,15,0,15)
			Icon.BackgroundColor3 = Color3.new(1,1,1)
			Icon.BackgroundTransparency = 1
			Icon.BorderSizePixel = 0
			Icon.BorderColor3 = Color3.new(0,0,0)
			Icon.Image = Page.Icon
			Icon.ImageColor3 = Color3.fromRGB(120,120,120)
			--
			NewPage.Name = "NewPage"
			NewPage.Position = UDim2.new(0,10,0,60)
			NewPage.Size = UDim2.new(1,-20,1,-65)
			NewPage.BackgroundColor3 = Color3.new(1,1,1)
			NewPage.BackgroundTransparency = 1
			NewPage.BorderSizePixel = 0
			NewPage.BorderColor3 = Color3.new(0,0,0)
			NewPage.ZIndex = 53
			NewPage.Visible = false
			--
			Left.Name = "Left"
			Left.Size = UDim2.new(0.5,-4,1,0)
			Left.BackgroundColor3 = Color3.new(1,1,1)
			Left.BackgroundTransparency = 1
			Left.BorderSizePixel = 0
			--// Left.ScrollBarThickness = 0.1
			Left.BorderColor3 = Color3.new(0,0,0)
			Left.ZIndex = 54
			--
			LeftLayout.Name = "LeftLayout"
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
			LeftLayout.Padding = UDim.new(0,8)
			--
			Right.Name = "Right"
			Right.Position = UDim2.new(0.5,4,0,0)
			Right.Size = UDim2.new(0.5,-4,1,0)
			--// Right.ScrollBarThickness = 0.1
			Right.BackgroundColor3 = Color3.new(1,1,1)
			Right.BackgroundTransparency = 1
			Right.BorderSizePixel = 0
			Right.BorderColor3 = Color3.new(0,0,0)
			Right.ZIndex = 53
			--
			RightLayout.Name = "RightLayout"
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			RightLayout.Padding = UDim.new(0,8)

			-- // Functions
			function Page:Turn(bool)
				Page.Open = bool
				task.spawn(function()
					Page.Window.Elements.FadeThing.Visible = true
					TweenService:Create(Page.Window.Elements.FadeThing, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
					task.wait(0.1)
					NewPage.Visible = Page.Open
					TweenService:Create(Page.Window.Elements.FadeThing, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					task.wait(0.1)
					Page.Window.Elements.FadeThing.Visible = false
				end)
				game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Page.Open and 0 or 1}):Play()
				game:GetService("TweenService"):Create(Title, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Page.Open and Color3.fromRGB(200,200,200) or Color3.fromRGB(120,120,120)}):Play()
				game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageColor3 = Page.Open and Color3.fromRGB(200,200,200) or Color3.fromRGB(120,120,120)}):Play()
				game:GetService("TweenService"):Create(Accent, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundTransparency = Page.Open and 0 or 1}):Play()
			end
			--
			Library:Connection(TabButton.MouseButton1Click, function()
				if not Page.Open then
					Page:Turn(true)
					for _, Pages in pairs(Page.Window.Pages) do
						if Pages.Open and Pages ~= Page then
							Pages:Turn(false)
						end
					end
				end
			end)
			--
			Library:Connection(TabButton.MouseEnter, function()
				if not Page.Open then
					game:GetService("TweenService"):Create(Title, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(180,180,180)}):Play()
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(180,180,180)}):Play()
				end
			end)
			--
			Library:Connection(TabButton.MouseLeave, function()
				if not Page.Open then
					game:GetService("TweenService"):Create(Title, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(120,120,120)}):Play()
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(120,120,120)}):Play()
				end
			end)

			-- // Elements
			Page.Elements = {
				Left = Left,
				Right = Right,
				TabButton = TabButton
			}

			-- // Drawings
			if #Page.Window.Pages == 0 then
				Page:Turn(true)
			end
			Page.Window.Pages[#Page.Window.Pages + 1] = Page
			Page.Window:UpdateTabs()
			return setmetatable(Page, Library.Pages)
		end
		--
		function Pages:Section(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Section = {
				Name = Properties.Name or "Section",
				Page = self,
				Side = (Properties.side or Properties.Side or "left"):lower(),
				Size = Properties.size or Properties.Size or 200,
				Elements = {},
				Content = {},
			}
			--
			local NewSection = Instance.new('Frame', Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right)
			local UIStroke = Instance.new('UIStroke', NewSection)
			local UICorner = Instance.new('UICorner', NewSection)
			local Frame = Instance.new('Frame', NewSection)
			local Title = Instance.new('TextLabel', NewSection)
			local Content = Instance.new('Frame', NewSection)
			local UIListLayout = Instance.new('UIListLayout', Content)
			--
			NewSection.Name = "NewSection"
			NewSection.Size = Section.Size == "Fill" and UDim2.new(1,0,1,0) or UDim2.new(1,0,0,Section.Size)
			NewSection.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
			NewSection.BorderSizePixel = 0
			NewSection.BorderColor3 = Color3.new(0,0,0)
			NewSection.ZIndex = 53
			--
			UIStroke.Color = Color3.new(0.137255, 0.137255, 0.137255)
			--
			Frame.Position = UDim2.new(0,0,0,20)
			Frame.Size = UDim2.new(1,0,0,1)
			Frame.BackgroundColor3 = Color3.new(0.1569,0.1569,0.1569)
			Frame.BorderSizePixel = 0
			Frame.BorderColor3 = Color3.new(0,0,0)
			--
			Title.Name = "Title"
			Title.Position = UDim2.new(0,8,0,1)
			Title.Size = UDim2.new(1,-10,0,20)
			Title.BackgroundColor3 = Color3.new(1,1,1)
			Title.BackgroundTransparency = 1
			Title.BorderSizePixel = 0
			Title.BorderColor3 = Color3.new(0,0,0)
			Title.Text = Section.Name
			Title.TextColor3 = Color3.new(0.7059,0.7059,0.7059)
			Title.Font = Enum.Font.Gotham
			Title.TextSize = Library.FontSize
			Title.TextXAlignment = Enum.TextXAlignment.Left
			--
			Content.Name = "Content"
			Content.Position = UDim2.new(0,10,0,30)
			Content.Size = UDim2.new(1,-20,1,-40)
			Content.BackgroundColor3 = Color3.new(1,1,1)
			Content.BackgroundTransparency = 1
			Content.BorderSizePixel = 0
			Content.BorderColor3 = Color3.new(0,0,0)
			Content.ZIndex = 53
			--
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,8)

			-- // Elements
			Section.Elements = {
				SectionContent = Content
			}

			-- // Returning
			Section.Page.Sections[#Section.Page.Sections + 1] = Section
			return setmetatable(Section, Library.Sections)
		end
		--
		function Sections:Toggle(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Risk = Properties.Risk or false,
				Name = Properties.Name or "Toggle",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or false
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Toggled = false,
			}
			--
			local NewToggle = Instance.new('TextButton', Toggle.Section.Elements.SectionContent)
			local ToggleTitle = Instance.new('TextLabel', NewToggle)
			local ToggleFrame = Instance.new('Frame', NewToggle)
			local UICorner_2 = Instance.new('UICorner', ToggleFrame)
			local ToggleAccent = Instance.new('Frame', ToggleFrame)
			local UICorner_3 = Instance.new('UICorner', ToggleAccent)
			local Circle = Instance.new('Frame', ToggleFrame)
			local UICorner_4 = Instance.new('UICorner', Circle)
			--
			NewToggle.Name = "NewToggle"
			NewToggle.Size = UDim2.new(1,0,0,17)
			NewToggle.BackgroundColor3 = Color3.new(1,1,1)
			NewToggle.BackgroundTransparency = 1
			NewToggle.BorderSizePixel = 0
			NewToggle.BorderColor3 = Color3.new(0,0,0)
			NewToggle.Text = ""
			NewToggle.TextColor3 = Color3.new(0,0,0)
			NewToggle.AutoButtonColor = false
			NewToggle.Font = Enum.Font.SourceSans
			NewToggle.TextSize = 14
			NewToggle.ZIndex = 53
			--
			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Size = UDim2.new(1,-10,0,17)
			ToggleTitle.BackgroundColor3 = Color3.new(1,1,1)
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.BorderColor3 = Color3.new(0,0,0)
			ToggleTitle.Text = Toggle.Name
			ToggleTitle.TextColor3 = Color3.new(0.7843,0.7843,0.7843)
			ToggleTitle.Font = Enum.Font.Gotham
			ToggleTitle.TextSize = Library.FontSize
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			--
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Position = UDim2.new(1,-40,0,0)
			ToggleFrame.Size = UDim2.new(0,40,1,0)
			ToggleFrame.BackgroundColor3 = Color3.new(0.051,0.051,0.051)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.BorderColor3 = Color3.new(0,0,0)
			ToggleFrame.ZIndex = 53
			--
			ToggleAccent.Name = "ToggleAccent"
			ToggleAccent.Position = UDim2.new(0,1,0,1)
			ToggleAccent.Size = UDim2.new(1,-2,1,-2)
			ToggleAccent.BackgroundColor3 = Library.Accent
			ToggleAccent.BackgroundTransparency = 1
			ToggleAccent.BorderSizePixel = 0
			ToggleAccent.BorderColor3 = Color3.new(0,0,0)
			ToggleAccent.ZIndex = 53
			table.insert(Library.ThemeObjects, ToggleAccent)
			--
			Circle.Name = "Circle"
			Circle.Position = UDim2.new(0,5,0.5,-5)
			Circle.Size = UDim2.new(0,10,0,10)
			Circle.BackgroundColor3 = Color3.new(1,1,1)
			Circle.BorderSizePixel = 0
			Circle.BorderColor3 = Color3.new(0,0,0)
			Circle.ZIndex = 53
			--
			UICorner_4.CornerRadius = UDim.new(1,0)

			-- // Functions
			local function SetState()
				Toggle.Toggled = not Toggle.Toggled
				if Toggle.Toggled then
					game:GetService("TweenService"):Create(ToggleAccent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
					game:GetService("TweenService"):Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1,-15,0.5,-5)}):Play()
				else
					game:GetService("TweenService"):Create(ToggleAccent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
					game:GetService("TweenService"):Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,5,0.5,-5)}):Play()
				end
				Library.Flags[Toggle.Flag] = Toggle.Toggled
				Toggle.Callback(Toggle.Toggled)
			end

			-- // Options List
			function Toggle:OptionList(Properties)
				if not Properties then
					Properties = {}
				end
				--
				local Section = {
					Elements = {},
					Content = {},
				}
				--
				local OptionButton = Instance.new('ImageButton', NewToggle)
				local OptionList = Instance.new('Frame', OptionButton)
				local UICorner = Instance.new('UICorner', OptionList)
				local UIStroke = Instance.new('UIStroke', OptionList)
				local OptionContent = Instance.new('Frame', OptionList)
				local UIListLayout = Instance.new('UIListLayout', OptionContent)
				--
				OptionButton.Name = "OptionButton"
				OptionButton.Position = UDim2.new(1,-65,0,1)
				OptionButton.Size = UDim2.new(0,15,0,15)
				OptionButton.BackgroundColor3 = Color3.new(1,1,1)
				OptionButton.BackgroundTransparency = 1
				OptionButton.BorderSizePixel = 0
				OptionButton.BorderColor3 = Color3.new(0,0,0)
				OptionButton.Image = "http://www.roblox.com/asset/?id=6031280882"
				OptionButton.ImageColor3 = Color3.new(0.7843,0.7843,0.7843)
				OptionButton.ZIndex = 54
				--
				OptionList.Name = "OptionList"
				OptionList.Position = UDim2.new(0,70,0,-10)
				OptionList.Size = UDim2.new(0,200,0,10)
				OptionList.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
				OptionList.BorderSizePixel = 0
				OptionList.BorderColor3 = Color3.new(0,0,0)
				OptionList.AutomaticSize = Enum.AutomaticSize.Y
				OptionList.Visible = false
				OptionList.ZIndex = 54
				--
				UIStroke.Color = Color3.new(0.137255, 0.137255, 0.137255)
				--
				OptionContent.Name = "OptionContent"
				OptionContent.Position = UDim2.new(0,10,0,10)
				OptionContent.Size = UDim2.new(1,-20,1,-10)
				OptionContent.BackgroundColor3 = Color3.new(1,1,1)
				OptionContent.BackgroundTransparency = 1
				OptionContent.BorderSizePixel = 0
				OptionContent.BorderColor3 = Color3.new(0,0,0)
				OptionContent.AutomaticSize = Enum.AutomaticSize.Y
				OptionContent.ZIndex = 54
				--
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0,4)
				--
				Library:Connection(OptionButton.MouseButton1Click, function()
					local State = not OptionList.Visible
					--// local Position = OptionButton.AbsolutePosition
					--// OptionList.Position = UDim2.fromOffset(Position.X, Position.Y)
					OptionList.Visible = State
					Library.OptionListOpen = State
				end)
				--
				Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
					if (Library.DropdownOpen) then return end;
					
					if OptionList.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not Library:IsMouseOverFrame(OptionList) and not Library:IsMouseOverFrame(OptionButton) then
							OptionList.Visible = false
						end
					end
				end)

				-- // Elements
				Section.Elements = {
					SectionContent = OptionContent
				}

				-- // Returning
				return setmetatable(Section, Library.Sections)
			end

			-- // Misc Functions
			function Toggle:SetState(bool)
				bool = type(bool) == "boolean" and bool or false
				if Toggle.Toggled ~= bool then
					SetState()
				end
			end


			function Toggle:SetText(string)
				ToggleTitle.Text = string
			end 

			function Toggle:SetCallback(callback)
				Toggle.Callback = callback 
			end 

			Toggle:SetState(Toggle.State)
			Library.Flags[Toggle.Flag] = Toggle.State
			Flags[Toggle.Flag] = Toggle.Set

			-- // Returning
			Library:Connection(NewToggle.MouseButton1Click, SetState)
			return Toggle
		end
		--
		function Sections:Nest(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Section = {
				Name = Properties.Name or "Section",
				RealSection = self,
				Size = Properties.size or Properties.Size or 200,
				Elements = {},
				Content = {},
			}
			--
			local ScrollHolder = Instance.new("Frame", Section.RealSection.Elements.SectionContent)
			local NewScroll = Instance.new('ScrollingFrame', ScrollHolder)
			local UICorner2 = Instance.new('UICorner', ScrollHolder)
			local UIStroke = Instance.new('UIStroke', ScrollHolder)
			local ScrollContent = Instance.new('Frame', NewScroll)
			local UIListLayout = Instance.new('UIListLayout', ScrollContent)
			--
			ScrollHolder.Name = "ScrollHolder"
			ScrollHolder.Size = UDim2.new(1,0,0,Section.Size)
			ScrollHolder.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
			ScrollHolder.BorderSizePixel = 0
			ScrollHolder.BorderColor3 = Color3.new(0,0,0)
			ScrollHolder.ClipsDescendants = true
			--
			NewScroll.Name = "NewScroll"
			NewScroll.Size = UDim2.new(1,0,1,0)
			NewScroll.BackgroundColor3 = Color3.new(0.098,0.098,0.098)
			NewScroll.BackgroundTransparency = 1
			NewScroll.BorderSizePixel = 0
			NewScroll.BorderColor3 = Color3.new(0,0,0)
			NewScroll.CanvasSize = UDim2.new(0,0,0,0)
			NewScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			NewScroll.ScrollBarThickness = 2
			NewScroll.TopImage = ""
			NewScroll.BottomImage = ""
			NewScroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always
			NewScroll.ScrollBarImageColor3 = Library.Accent
			NewScroll.ClipsDescendants = true
			table.insert(Library.ThemeObjects, NewScroll)
			--
			UIStroke.Color = Color3.new(0.137255, 0.137255, 0.137255)
			--
			ScrollContent.Name = "ScrollContent"
			ScrollContent.Position = UDim2.new(0,10,0,5)
			ScrollContent.Size = UDim2.new(1,-20,0,0)
			ScrollContent.BackgroundColor3 = Color3.new(1,1,1)
			ScrollContent.BackgroundTransparency = 1
			ScrollContent.BorderSizePixel = 0
			ScrollContent.BorderColor3 = Color3.new(0,0,0)
			ScrollContent.AutomaticSize = Enum.AutomaticSize.Y
			--
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,4)

			-- // Elements
			Section.Elements = {
				SectionContent = ScrollContent
			}

			-- // Returning
			return setmetatable(Section, Library.Sections)
		end
		--
		function Sections:Slider(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Slider",
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or 10
				),
				Max = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100),
				Sub = (
					Properties.suffix
						or Properties.Suffix
						or Properties.ending
						or Properties.Ending
						or Properties.prefix
						or Properties.Prefix
						or Properties.measurement
						or Properties.Measurement
						or ""
				),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
			}
			local TextValue = ("[value]" .. Slider.Sub)
			--
			local NewSlider = Instance.new('TextButton', Slider.Section.Elements.SectionContent)
			local SliderTitle = Instance.new('TextLabel', NewSlider)
			local ToggleFrame = Instance.new('Frame', NewSlider)
			local UICorner_2 = Instance.new('UICorner', ToggleFrame)
			local FillHold = Instance.new('Frame', ToggleFrame)
			local UICorner_3 = Instance.new('UICorner', FillHold)
			local Fill = Instance.new('TextButton', FillHold)
			local UICorner_4 = Instance.new('UICorner', Fill)
			local Circle = Instance.new('Frame', Fill)
			local UICorner_4 = Instance.new('UICorner', Circle)
			local SliderValue = Instance.new('TextLabel', NewSlider)
			--
			NewSlider.Name = "NewSlider"
			NewSlider.Size = UDim2.new(1,0,0,32)
			NewSlider.BackgroundColor3 = Color3.new(1,1,1)
			NewSlider.BackgroundTransparency = 1
			NewSlider.BorderSizePixel = 0
			NewSlider.BorderColor3 = Color3.new(0,0,0)
			NewSlider.Text = ""
			NewSlider.TextColor3 = Color3.new(0,0,0)
			NewSlider.AutoButtonColor = false
			NewSlider.Font = Enum.Font.SourceSans
			NewSlider.TextSize = 14
			NewSlider.ZIndex = 53
			--
			SliderTitle.Name = "SliderTitle"
			SliderTitle.Size = UDim2.new(1,-10,0,17)
			SliderTitle.BackgroundColor3 = Color3.new(1,1,1)
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.BorderSizePixel = 0
			SliderTitle.BorderColor3 = Color3.new(0,0,0)
			SliderTitle.Text = Slider.Name
			SliderTitle.TextColor3 = Color3.new(0.7843,0.7843,0.7843)
			SliderTitle.Font = Enum.Font.Gotham
			SliderTitle.TextSize = Library.FontSize
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			--
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Position = UDim2.new(0,0,1,-8)
			ToggleFrame.Size = UDim2.new(1,0,0,8)
			ToggleFrame.BackgroundColor3 = Color3.new(0.051,0.051,0.051)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.BorderColor3 = Color3.new(0,0,0)
			ToggleFrame.ZIndex = 53
			--
			FillHold.Name = "FillHold"
			FillHold.Position = UDim2.new(0,1,0,1)
			FillHold.Size = UDim2.new(1,-2,1,-2)
			FillHold.BackgroundColor3 = Color3.new(0.6667,0.6667,1)
			FillHold.BackgroundTransparency = 1
			FillHold.BorderSizePixel = 0
			FillHold.BorderColor3 = Color3.new(0,0,0)
			FillHold.ZIndex = 53
			--
			Fill.Name = "Fill"
			Fill.Size = UDim2.new(0,0,1,0)
			Fill.BackgroundColor3 = Library.Accent
			Fill.BorderSizePixel = 0
			Fill.BorderColor3 = Color3.new(0,0,0)
			Fill.Text = ""
			Fill.TextColor3 = Color3.new(0,0,0)
			Fill.AutoButtonColor = false
			Fill.Font = Enum.Font.SourceSans
			Fill.TextSize = 14
			Fill.ZIndex = 53
			table.insert(Library.ThemeObjects, Fill)
			--
			Circle.Name = "Circle"
			Circle.Position = UDim2.new(1,-6,0.5,-6)
			Circle.Size = UDim2.new(0,13,0,13)
			Circle.BackgroundColor3 = Color3.new(1,1,1)
			Circle.BorderSizePixel = 0
			Circle.BorderColor3 = Color3.new(0,0,0)
			Circle.ZIndex = 53
			--
			UICorner_4.CornerRadius = UDim.new(1,0)
			--
			SliderValue.Name = "SliderValue"
			SliderValue.Size = UDim2.new(1,0,0,17)
			SliderValue.BackgroundColor3 = Color3.new(1,1,1)
			SliderValue.BackgroundTransparency = 1
			SliderValue.BorderSizePixel = 0
			SliderValue.BorderColor3 = Color3.new(0,0,0)
			SliderValue.Text = ""
			SliderValue.TextColor3 = Color3.new(0.4706,0.4706,0.4706)
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.TextSize = Library.FontSize
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right

			-- // Functions
			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				--Fill.Size = UDim2.new(sizeX, 0, 1, 0)
				game:GetService("TweenService"):Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
				SliderValue.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
				Val = value

				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end				
			--
			local function Slide(input)
				local sizeX = (input.Position.X - NewSlider.AbsolutePosition.X) / NewSlider.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end
			--
			Library:Connection(NewSlider.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					Slide(input)
				end
			end)
			Library:Connection(NewSlider.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			Library:Connection(Fill.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					Slide(input)
				end
			end)
			Library:Connection(Fill.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if Sliding then
						Slide(input)
					end
				end
			end)
			--
			function Slider:SetValue(Value)
				Set(Value)
			end

			function Slider:SetCallback(callback)
				Slider.Callback = callback
			end 

			function Slider:SetText(text)
				SliderTitle.Text = text
			end

			--
			Flags[Slider.Flag] = Set
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			-- // Returning
			return Slider
		end
		--
		function Sections:List(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
					"1",
					"2",
					"3",
				}),
				Max = (Properties.Max or Properties.max or nil),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or nil
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				OptionInsts = {},
			}
			--
			local NewDropdown = Instance.new('Frame', Dropdown.Section.Elements.SectionContent)
			local DropdownTitle = Instance.new('TextLabel', NewDropdown)
			local ToggleFrame = Instance.new('TextButton', NewDropdown)
			local UICorner_2 = Instance.new('UICorner', ToggleFrame)
			local ToggleContent = Instance.new('Frame', ToggleFrame)
			local UICorner_3 = Instance.new('UICorner', ToggleContent)
			local UIListLayout = Instance.new('UIListLayout', ToggleContent)
			local DropdownTitle_2 = Instance.new('TextLabel', ToggleFrame)
			local Icon = Instance.new('ImageLabel', ToggleFrame)
			--
			NewDropdown.Name = "NewDropdown"
			NewDropdown.Size = UDim2.new(1,0,0,48)
			NewDropdown.BackgroundColor3 = Color3.new(1,1,1)
			NewDropdown.BackgroundTransparency = 1
			NewDropdown.BorderSizePixel = 0
			NewDropdown.BorderColor3 = Color3.new(0,0,0)
			NewDropdown.ZIndex = 54
			--
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.Size = UDim2.new(1,-10,0,17)
			DropdownTitle.BackgroundColor3 = Color3.new(1,1,1)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.BorderSizePixel = 0
			DropdownTitle.BorderColor3 = Color3.new(0,0,0)
			DropdownTitle.Text = Dropdown.Name
			DropdownTitle.TextColor3 = Color3.new(0.7843,0.7843,0.7843)
			DropdownTitle.Font = Enum.Font.Gotham
			DropdownTitle.TextSize = Library.FontSize
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			--
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Position = UDim2.new(0,0,1,-24)
			ToggleFrame.Size = UDim2.new(1,0,0,24)
			ToggleFrame.BackgroundColor3 = Color3.new(0.098,0.098,0.098)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.BorderColor3 = Color3.new(0,0,0)
			ToggleFrame.ZIndex = 54
			ToggleFrame.AutoButtonColor = false
			ToggleFrame.Text = ""
			--
			UICorner_2.CornerRadius = UDim.new(0,4)
			--
			ToggleContent.Name = "ToggleContent"
			ToggleContent.Position = UDim2.new(0,0,1,0)
			ToggleContent.Size = UDim2.new(1,0,0,0)
			ToggleContent.BackgroundColor3 = Color3.new(0.0706,0.0706,0.0706)
			ToggleContent.BorderSizePixel = 0
			ToggleContent.BorderColor3 = Color3.new(0,0,0)
			ToggleContent.ZIndex = 54
			ToggleContent.ClipsDescendants = true
			--
			UICorner_3.CornerRadius = UDim.new(0,4)
			--
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			--
			DropdownTitle_2.Name = "DropdownTitle"
			DropdownTitle_2.Position = UDim2.new(0,4,0,0)
			DropdownTitle_2.Size = UDim2.new(1,-10,1,0)
			DropdownTitle_2.BackgroundColor3 = Color3.new(1,1,1)
			DropdownTitle_2.BackgroundTransparency = 1
			DropdownTitle_2.BorderSizePixel = 0
			DropdownTitle_2.BorderColor3 = Color3.new(0,0,0)
			DropdownTitle_2.Text = ""
			DropdownTitle_2.TextColor3 = Color3.new(0.7843,0.7843,0.7843)
			DropdownTitle_2.Font = Enum.Font.Gotham
			DropdownTitle_2.TextSize = Library.FontSize
			DropdownTitle_2.TextXAlignment = Enum.TextXAlignment.Left
			--
			Icon.Name = "Icon"
			Icon.Position = UDim2.new(1,-25,0,5)
			Icon.Size = UDim2.new(0,20,0,15)
			Icon.BackgroundColor3 = Color3.new(1,1,1)
			Icon.BackgroundTransparency = 1
			Icon.BorderSizePixel = 0
			Icon.BorderColor3 = Color3.new(0,0,0)
			Icon.Image = "http://www.roblox.com/asset/?id=6034818372"
			Icon.ImageColor3 = Color3.new(0.4706,0.4706,0.4706)
			Icon.ZIndex = 54

			local Toggled = false
			local Count = 0

			Library:Connection(ToggleFrame.MouseButton1Click, function()
				Toggled = not Toggled
				Library.DropdownOpen = Toggled
				if Toggled then
					NewDropdown.ZIndex = 55
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(200,200,200)}):Play()
					game:GetService("TweenService"):Create(ToggleContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,Count * 22)}):Play()
				else
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
					game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(120,120,120)}):Play()
					game:GetService("TweenService"):Create(ToggleContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)}):Play()
					task.wait(0.20)
					NewDropdown.ZIndex = 54
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ToggleContent.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ToggleContent) and not Library:IsMouseOverFrame(ToggleFrame) and not Library.OptionListOpen then
						Toggled = false
						Library.DropdownOpen = false
						game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(120,120,120)}):Play()
						game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
						game:GetService("TweenService"):Create(ToggleContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0,0)}):Play()
						task.wait(0.20)
						NewDropdown.ZIndex = 54
					end
				end
			end)
			--
			local Chosen = Dropdown.Max and {} or nil
			--
			local function handleoptionclick(option, button, text, dot)
				button.MouseButton1Click:Connect(function()
					if Dropdown.Max then
						if table.find(Chosen, option) then
							table.remove(Chosen, table.find(Chosen, option))

							local textchosen = {}
							local cutobject = false

							for _, opt in next, Chosen do
								table.insert(textchosen, opt)
							end

							DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
							game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(120,120,120)}):Play()
							game:GetService("TweenService"):Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,4,0,0)}):Play()

							Library.Flags[Dropdown.Flag] = Chosen
							Dropdown.Callback(Chosen)
						else
							if #Chosen == Dropdown.Max then
								Dropdown.OptionInsts[Chosen[1]].text.Visible = false
								table.remove(Chosen, 1)
							end

							table.insert(Chosen, option)

							local textchosen = {}
							local cutobject = false

							for _, opt in next, Chosen do
								table.insert(textchosen, opt)
							end

							DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
							game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
							game:GetService("TweenService"):Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
							game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0,0)}):Play()

							Library.Flags[Dropdown.Flag] = Chosen
							Dropdown.Callback(Chosen)
						end
					else
						for opt, tbl in next, Dropdown.OptionInsts do
							if opt ~= option then
								game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(120,120,120)}):Play()
								game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,4,0,0)}):Play()
								game:GetService("TweenService"):Create(tbl.dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							end
						end
						Chosen = option
						DropdownTitle_2.Text = option
						game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
						game:GetService("TweenService"):Create(dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
						game:GetService("TweenService"):Create(text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0,0)}):Play()
						Library.Flags[Dropdown.Flag] = option
						Dropdown.Callback(option)
					end
				end)
			end
			--
			local function createoptions(tbl)
				for _, option in next, tbl do
					Dropdown.OptionInsts[option] = {}
					local TextButton = Instance.new('TextButton', ToggleContent)
					local DropdownTitle3 = Instance.new('TextLabel', TextButton)
					local AccentDot = Instance.new('Frame', TextButton)
					local OptionCorner = Instance.new('UICorner', AccentDot)
					--
					TextButton.Size = UDim2.new(1,0,0,22)
					TextButton.BackgroundColor3 = Color3.new(1,1,1)
					TextButton.BackgroundTransparency = 1
					TextButton.BorderSizePixel = 0
					TextButton.BorderColor3 = Color3.new(0,0,0)
					TextButton.Text = ""
					TextButton.TextColor3 = Color3.new(0,0,0)
					TextButton.AutoButtonColor = false
					TextButton.Font = Enum.Font.SourceSans
					TextButton.TextSize = 14
					Dropdown.OptionInsts[option].button = TextButton
					--
					DropdownTitle3.Name = "DropdownTitle"
					DropdownTitle3.Position = UDim2.new(0,20,0,0)
					DropdownTitle3.Size = UDim2.new(1,-10,1,0)
					DropdownTitle3.BackgroundColor3 = Color3.new(1,1,1)
					DropdownTitle3.BackgroundTransparency = 1
					DropdownTitle3.BorderSizePixel = 0
					DropdownTitle3.BorderColor3 = Color3.new(0,0,0)
					DropdownTitle3.Text = option
					DropdownTitle3.TextColor3 = Color3.fromRGB(120,120,120)
					DropdownTitle3.Font = Enum.Font.Gotham
					DropdownTitle3.TextSize = Library.FontSize
					DropdownTitle3.TextXAlignment = Enum.TextXAlignment.Left
					Dropdown.OptionInsts[option].text = DropdownTitle3
					--
					AccentDot.Name = "AccentDot"
					AccentDot.Position = UDim2.new(0,8,0,8)
					AccentDot.Size = UDim2.new(0,6,0,6)
					AccentDot.BackgroundColor3 = Library.Accent
					AccentDot.BorderSizePixel = 0
					AccentDot.BorderColor3 = Color3.new(0,0,0)
					table.insert(Library.ThemeObjects, AccentDot)
					Dropdown.OptionInsts[option].dot = AccentDot
					--
					OptionCorner.CornerRadius = UDim.new(1,0)
					Count += 1

					handleoptionclick(option, TextButton, DropdownTitle3, AccentDot)
				end
			end
			createoptions(Dropdown.Options)
			--
			local set
			set = function(option)
				if Dropdown.Max then
					table.clear(Chosen)
					option = type(option) == "table" and option or {}

					for opt, tbl in next, Dropdown.OptionInsts do
						if not table.find(option, opt) then
							game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(120,120,120)}):Play()
							game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,4,0,0)}):Play()
							game:GetService("TweenService"):Create(tbl.dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						end
					end

					for i, opt in next, option do
						if table.find(Dropdown.Options, opt) and #Chosen < Dropdown.Max then
							table.insert(Chosen, opt)
							game:GetService("TweenService"):Create(Dropdown.OptionInsts[opt].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
							game:GetService("TweenService"):Create(Dropdown.OptionInsts[opt].dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
							game:GetService("TweenService"):Create(Dropdown.OptionInsts[opt].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0,0)}):Play()
						end
					end

					local textchosen = {}
					local cutobject = false

					for _, opt in next, Chosen do
						table.insert(textchosen, opt)
					end

					DropdownTitle_2.Text = #Chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

					Library.Flags[Dropdown.Flag] = Chosen
					Dropdown.Callback(Chosen)
				end
			end
			--
			function Dropdown:SetOption(option)
				if Dropdown.Max then
					set(option)
				else
					for opt, tbl in next, Dropdown.OptionInsts do
						if opt ~= option then
							game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(120,120,120)}):Play()
							game:GetService("TweenService"):Create(tbl.text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,4,0,0)}):Play()
							game:GetService("TweenService"):Create(tbl.dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						end
					end
					if table.find(Dropdown.Options, option) then
						Chosen = option
						DropdownTitle_2.Text = option
						game:GetService("TweenService"):Create(Dropdown.OptionInsts[option].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
						game:GetService("TweenService"):Create(Dropdown.OptionInsts[option].dot, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
						game:GetService("TweenService"):Create(Dropdown.OptionInsts[option].text, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0,0)}):Play()
						Library.Flags[Dropdown.Flag] = Chosen
						Dropdown.Callback(Chosen)
					else
						Chosen = nil
						DropdownTitle_2.Text = ""
						Library.Flags[Dropdown.Flag] = Chosen
						Dropdown.Callback(Chosen)
					end
				end
			end
			--
			function Dropdown:Refresh(tbl)
				Count = 0
				for _, opt in next, Dropdown.OptionInsts do
					coroutine.wrap(function()
						opt.button:Destroy()
					end)()
				end
				table.clear(Dropdown.OptionInsts)

				createoptions(tbl)
				Chosen = nil

				Library.Flags[Dropdown.Flag] = Chosen
				Dropdown.Callback(Chosen)
			end

			function Dropdown:SetText(text)
				DropdownTitle.Text = text 
			end 

			function Dropdown:SetCallback(callback)
				DropdownTitle.Text = text 
			end 

			-- // Returning
			if Dropdown.Max then
				Flags[Dropdown.Flag] = set
			else
				Flags[Dropdown.Flag] = Dropdown
			end
			Dropdown:SetOption(Dropdown.State)
			return Dropdown
		end
		--
		function Sections:Colorpicker(Properties)
			local Properties = Properties or {}
			local Colorpicker = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or "Colorpicker"),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Color3.fromRGB(255, 0, 0)
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Colorpickers = 0,
			}
			--
			local NewColor = Instance.new("TextButton")
			NewColor.Name = "NewColor"
			NewColor.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewColor.Text = ""
			NewColor.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.TextSize = 14
			NewColor.AutoButtonColor = false
			NewColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewColor.BackgroundTransparency = 1
			NewColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.BorderSizePixel = 0
			NewColor.Size = UDim2.new(1, 0, 0, 17)
			NewColor.ZIndex = 54
			NewColor.Parent = Colorpicker.Section.Elements.SectionContent

			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			ToggleTitle.Text = Colorpicker.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			ToggleTitle.TextSize = 13
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
			ToggleTitle.Parent = NewColor

			-- // Functions
			Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
			local colorpickertypes = Library:NewPicker(
				Colorpicker.Name,
				Colorpicker.State,
				NewColor,
				Colorpicker.Colorpickers,
				Colorpicker.Flag,
				Colorpicker.Callback
			)

			function Colorpicker:SetColor(color)
				colorpickertypes:Set(color, false, true)
			end

			function Colorpicker:Colorpicker(Properties)
				local Properties = Properties or {}
				local NewColorpicker = {
					State = (
						Properties.state
							or Properties.State
							or Properties.def
							or Properties.Def
							or Properties.default
							or Properties.Default
							or Color3.fromRGB(255, 0, 0)
					),
					Callback = (
						Properties.callback
							or Properties.Callback
							or Properties.callBack
							or Properties.CallBack
							or function() end
					),
					Flag = (
						Properties.flag
							or Properties.Flag
							or Properties.pointer
							or Properties.Pointer
							or Library.NextFlag()
					),
				}
				-- // Functions
				Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
				local Newcolorpickertypes = Library:NewPicker(
					"",
					NewColorpicker.State,
					NewColor,
					Colorpicker.Colorpickers,
					NewColorpicker.Flag,
					NewColorpicker.Callback
				)

				function NewColorpicker:Set(color)
					Newcolorpickertypes:Set(color)
				end

				-- // Returning
				return NewColorpicker
			end

			-- // Returning
			return Colorpicker
		end
		--
		function Sections:Keybind(Properties)
			local Properties = Properties or {}
			local Keybind = {
				Section = self,
				Name = Properties.name or Properties.Name or "Keybind",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Enum.KeyCode.E
				),
				Mode = (Properties.mode or Properties.Mode or "Toggle"),
				UseKey = (Properties.UseKey or false),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Binding = nil,
			}
			local Key
			local State = false
			--
			local NewKey = Instance.new("TextButton")
			NewKey.Name = "NewKey"
			NewKey.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewKey.Text = ""
			NewKey.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewKey.TextSize = 14
			NewKey.AutoButtonColor = false
			NewKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewKey.BackgroundTransparency = 1
			NewKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewKey.BorderSizePixel = 0
			NewKey.Size = UDim2.new(1, 0, 0, 17)
			NewKey.ZIndex = 54
			NewKey.Parent = Keybind.Section.Elements.SectionContent

			local ToggleTitle = Instance.new("TextLabel")
			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			ToggleTitle.Text = Keybind.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			ToggleTitle.TextSize = 13
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -10, 0, 17)
			ToggleTitle.Parent = NewKey

			local KeyText = Instance.new("TextLabel")
			KeyText.Name = "KeyText"
			KeyText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			KeyText.Text = "None"
			KeyText.TextColor3 = Color3.fromRGB(200, 200, 200)
			KeyText.TextSize = 13
			KeyText.TextXAlignment = Enum.TextXAlignment.Right
			KeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			KeyText.BackgroundTransparency = 1
			KeyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeyText.BorderSizePixel = 0
			KeyText.Position = UDim2.new(1, -180, 0, 0)
			KeyText.Size = UDim2.new(1, -10, 0, 17)
			KeyText.Parent = NewKey

			-- // Functions
			local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = false
						end
						Keybind.Callback(false)
					end
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = "None"

						KeyText.Text = text
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))

						KeyText.Text = text
					end

					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
					if not Keybind.UseKey then
						Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
						Keybind.Mode = newkey
						if Keybind.Mode == "Always" then
							State = true
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(true)
						end
					end
				else
					State = newkey
					if Keybind.Flag then
						Library.Flags[Keybind.Flag] = newkey
					end
					Keybind.Callback(newkey)
				end
			end
			--
			set(Keybind.State)
			set(Keybind.Mode)
			NewKey.MouseButton1Click:Connect(function()
				if not Keybind.Binding then

					KeyText.Text = "..."
					TweenService:Create(KeyText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()


					Keybind.Binding = Library:Connection(
						game:GetService("UserInputService").InputBegan,
						function(input, gpe)
							if gpe then return end; 
							if input.UserInputType == Enum.UserInputType.Touch then return end;


							set(
								input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
									or input.UserInputType
							)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
							TweenService:Create(KeyText, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
						end
					)
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(inp, gpe)
				if (gpe) then return end;

				if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
					if Keybind.Mode == "Hold" then
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = true
						end
						c = Library:Connection(game:GetService("RunService").RenderStepped, function()
							if Keybind.Callback then
								Keybind.Callback(true)
							end
						end)
					elseif Keybind.Mode == "Toggle" then
						State = not State
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = State
						end
						Keybind.Callback(State)
					end
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputEnded, function(inp, gpe)
				if gpe then return end;

				if Keybind.Mode == "Hold" and not Keybind.UseKey then
					if Key ~= "" or Key ~= nil then
						if inp.KeyCode == Key or inp.UserInputType == Key then
							if c then
								c:Disconnect()
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = false
								end
								if Keybind.Callback then
									Keybind.Callback(false)
								end
							end
						end
					end
				end
			end)
			--
			Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
			Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
			Flags[Keybind.Flag] = set
			Flags[Keybind.Flag .. "_KEY"] = set
			Flags[Keybind.Flag .. "_KEY STATE"] = set
			--
			function Keybind:SetKey(key)
				set(key)
			end

			-- // Returning
			return Keybind
		end
		--
		function Sections:Textbox(Properties)
			local Properties = Properties or {}
			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Placeholder = (
					Properties.placeholder
						or Properties.Placeholder
						or Properties.holder
						or Properties.Holder
						or "Enter your text here"
				),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or ""
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				EnterPressed = Properties.EnterPressed
			}
			--
			local NewBox = Instance.new("Frame")
			NewBox.Name = "NewBox"
			NewBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewBox.BackgroundTransparency = 1
			NewBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewBox.BorderSizePixel = 0
			NewBox.Size = UDim2.new(1, 0, 0, 24)
			NewBox.ZIndex = 54
			NewBox.Parent = Textbox.Section.Elements.SectionContent

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
			ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Position = UDim2.new(0, 0, 1, -24)
			ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
			ToggleFrame.ZIndex = 55

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner_2"
			UICorner2.CornerRadius = UDim.new(0, 4)
			UICorner2.Parent = ToggleFrame

			local DropdownTitle = Instance.new("TextBox")
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			DropdownTitle.Text = Textbox.State
			DropdownTitle.PlaceholderText = Textbox.Placeholder
			DropdownTitle.PlaceholderColor3 = Color3.fromRGB(145,145,145)
			DropdownTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			DropdownTitle.TextSize = 13
			DropdownTitle.ClearTextOnFocus = false
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownTitle.BorderSizePixel = 0
			DropdownTitle.Position = UDim2.fromOffset(4, 0)
			DropdownTitle.Size = UDim2.new(1, -10, 1, 0)
			DropdownTitle.ZIndex = 10
			DropdownTitle.Parent = ToggleFrame

			ToggleFrame.Parent = NewBox
			--
			DropdownTitle.FocusLost:Connect(function(EnterPressed)
				if Textbox.EnterPressed and not EnterPressed then return end  
				Textbox.Callback(DropdownTitle.Text)
				Library.Flags[Textbox.Flag] = DropdownTitle.Text
			end)
			--
			local function set(str)
				DropdownTitle.Text = str
				Library.Flags[Textbox.Flag] = str
				Textbox.Callback(str)
			end
			-- // Return
			Flags[Textbox.Flag] = set
			Library.Flags[Textbox.Flag] = DropdownTitle.Text
			return Textbox
		end
		--
		function Sections:Button(Properties)
			local Properties = Properties or {}
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "button",
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
			}
			--
			local NewButton = Instance.new("TextButton")
			NewButton.Name = "NewButton"
			NewButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			NewButton.Text = ""
			NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewButton.TextSize = 14
			NewButton.AutoButtonColor = false
			NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewButton.BackgroundTransparency = 1
			NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewButton.BorderSizePixel = 0
			NewButton.Size = UDim2.new(1, 0, 0, 24)
			NewButton.ZIndex = 54
			NewButton.Parent = Button.Section.Elements.SectionContent

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Position = UDim2.new(0, 0, 1, -24)
			ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
			ToggleFrame.ZIndex = 55

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner_2"
			UICorner2.CornerRadius = UDim.new(0, 4)
			UICorner2.Parent = ToggleFrame

			local DropdownTitle = Instance.new("TextLabel")
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			DropdownTitle.Text = Button.Name
			DropdownTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			DropdownTitle.TextSize = 13
			DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownTitle.BorderSizePixel = 0
			DropdownTitle.Size = UDim2.fromScale(1, 1)
			DropdownTitle.ZIndex = 53
			DropdownTitle.Parent = ToggleFrame

			ToggleFrame.Parent = NewButton
			--
			Library:Connection(NewButton.MouseButton1Down, function()
				Button.Callback()
				TweenService:Create(DropdownTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
				task.spawn(function()
					task.wait(0.1)
					TweenService:Create(DropdownTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
				end)
			end)
		end
		--
		function Library:Watermark(Properties)
			local Watermark = {
				Name = (Properties.Name or Properties.name or "placeholder");
				AnimateText = nil;
			}
			--
			local Outline = Instance.new("Frame")
			Outline.Name = "Outline"
			Outline.AnchorPoint = Vector2.new(1, 0)
			Outline.AutomaticSize = Enum.AutomaticSize.X
			Outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Outline.Position = UDim2.new(1, -10, 0, 10)
			Outline.Size = UDim2.fromOffset(100, 20)
			Outline.Visible = false
			Outline.ZIndex = 50
			Outline.Parent = Library.ScreenGUI

			local UICorner = Instance.new("UICorner")
			UICorner.Name = "UICorner"
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Outline

			local UIStroke = Instance.new("UIStroke")
			UIStroke.Name = "UIStroke"
			UIStroke.Parent = Outline

			local Inline = Instance.new("Frame")
			Inline.Name = "Inline"
			Inline.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
			Inline.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inline.BorderSizePixel = 0
			Inline.Position = UDim2.fromOffset(1, 1)
			Inline.Size = UDim2.new(1, -2, 1, -2)
			Inline.ZIndex = 51

			local UICorner2 = Instance.new("UICorner")
			UICorner2.Name = "UICorner_2"
			UICorner2.CornerRadius = UDim.new(0, 4)
			UICorner2.Parent = Inline

			local Title = Instance.new("TextLabel")
			Title.Name = "Title"
			Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
			Title.RichText = true
			Title.Text = Watermark.Name
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 13
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.AutomaticSize = Enum.AutomaticSize.X
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1
			Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title.BorderSizePixel = 0
			Title.Position = UDim2.fromOffset(5, 0)
			Title.Size = UDim2.fromScale(0, 1)
			Title.Parent = Inline

			local UIPadding = Instance.new("UIPadding")
			UIPadding.Name = "UIPadding"
			UIPadding.PaddingRight = UDim.new(0, 6)
			UIPadding.Parent = Inline

			Inline.Parent = Outline


			-- // Functions
			function Watermark:UpdateText(NewText)
				Watermark.Name = NewText
				Title.Text = Watermark.AnimateText .. " " .. Watermark.Name;
			end;
			function Watermark:SetVisible(State)
				Outline.Visible = State;
			end;

			return Watermark
		end
		--
	end
end

return Library
