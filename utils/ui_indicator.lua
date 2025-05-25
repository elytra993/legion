local tween_s = game:GetService("TweenService")

local indicator = {gui = Instance.new("ScreenGui")}
indicator.gui.Parent = if game:GetService("RunService"):IsStudio() then game.StarterGui else game:GetService("CoreGui")

indicator.holder = Instance.new("Frame")
indicator.holder.Size = UDim2.new(0, 150, 0, 0)
indicator.holder.Position = UDim2.new(0.5, 0, 0.85, 0)
indicator.holder.AnchorPoint = Vector2.new(0.5, 0)
indicator.holder.BackgroundTransparency = 1
indicator.holder.Parent = indicator.gui

local list = Instance.new("UIListLayout")
list.Padding =  UDim.new(0, 6)
list.VerticalAlignment = Enum.VerticalAlignment.Bottom
list.HorizontalAlignment = Enum.HorizontalAlignment.Right
list.Parent = indicator.holder

local alignment_positions = {
    [Enum.TextXAlignment.Left] = UDim2.new(0, 0, 0, 0),
    [Enum.TextXAlignment.Right] = UDim2.new(1, 0, 0, 0),
    [Enum.TextXAlignment.Center] = UDim2.new(0.5, 0, 0, 0),
}

local function glowing_label(text, glow_transparency, radius, text_alignment, is_glow)
    local label = Instance.new("TextLabel")
    label.FontFace = Font.new("rbxassetid://12187365977", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    label.TextColor3 = Color3.fromRGB(240, 240, 240)
    label.Text = text
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.TextXAlignment = text_alignment
    label.TextTransparency = if is_glow then 1 else 0
    label.Size = if is_glow then UDim2.new(0, 0, 1, 0) else UDim2.new(0, 0, 0, 0)
    label.Position = if is_glow then alignment_positions[text_alignment] else UDim2.new(0, 0, 0, 0)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = glow_transparency or 0.935
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = label

    if not is_glow then
        local glows = {}

        for i = 1, radius or 2 do
            local glow = glowing_label(label.ContentText, glow_transparency, nil, text_alignment, true)
            glow.stroke.Thickness = i + 1
            glow.label.Parent = if i == 1 then label else glows[i - 1].label
            
            glows[i] = glow
        end

        return {label = label, stroke = stroke, glows = glows}
    end

    return {label = label, stroke = stroke}
end

local function tween(object, time, properties)
    tween_s:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quint), properties):Play()
end

function indicator:prompt(properties: { text1: string, text2: string, duration1: number, duration2: number })
    local label1 = glowing_label(properties.text1, 1, 2, Enum.TextXAlignment.Right)
    label1.label.Size = UDim2.new(0, 0, 0, 16)
    label1.label.ClipsDescendants = true
    label1.label.TextTransparency = 1

    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 3)
    padding.Parent = label1.label

    local label2 = glowing_label(properties.text2, 1, 2, Enum.TextXAlignment.Left)
    label2.label.ClipsDescendants = true
    label2.label.TextTransparency = 1

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 3)
    padding.Parent = label2.label

    local notification = Instance.new("Frame")
    notification.BackgroundTransparency = 1
    notification.BorderSizePixel = 0
    notification.Parent = self.holder
    notification.Size = UDim2.new(0, 0, 0, 0)

    label1.label.Parent = notification
    label2.label.Parent = notification

    label1.label.Position = UDim2.new(0, (label1.label.TextBounds.X + 6), 0, 0)

    label2.label.Position = UDim2.new(0, -((label2.label.TextBounds.X + 6) - (label1.label.TextBounds.X + 6)), 0, 0)
    label2.label.Size = UDim2.new(0, ((label2.label.TextBounds.X + 6) - (label1.label.TextBounds.X + 6)), 0, 16)

    local box = Instance.new("ImageLabel")
    box.Image = "rbxassetid://19003810748"
    box.BackgroundTransparency = 1
    box.Position = UDim2.new(1, -16, 0, -10)
    box.Size = UDim2.new(0, 30, 0, 38)
    box.ImageTransparency = 1
    box.Parent = notification

    coroutine.wrap(function()
        tween(notification, 0.6, {Size = UDim2.new(0, label1.label.TextBounds.X, 0, 16)})
        task.wait(0.2)

        tween(box, 0.8, {ImageTransparency = 0.3})
        task.wait(0.38)
        tween(box, 0.8, {ImageTransparency = 1})
        task.wait(0.38)
        
        tween(label1.label, 0.8, {TextTransparency = 0.2})

        tween(label1.stroke, 0.8, {Transparency = 0.935})
        for _, glow in label1.glows do
            tween(glow.stroke, 0.8, {Transparency = 0.935})
        end

        tween(box, 0.6, {Position = UDim2.new(0, -19, 0, -10)})
        tween(label1.label, 0.6, {Size = UDim2.new(0, label1.label.TextBounds.X + 6, 0, 16), Position = UDim2.new(0, 0, 0, 0)})

        tween(box, 0.8, {ImageTransparency = 0.3})

        for i = 1, properties.duration1 // 0.76 do
            task.wait(0.38)
            tween(box, 0.8, {ImageTransparency = 1})

            task.wait(0.38)
            tween(box, 0.8, {ImageTransparency = 0.3})
        end

        task.wait(0.38)
        tween(box, 0.8, {ImageTransparency = 1})
        tween(label1.label, 0.6, {TextTransparency = 1})

        tween(label1.stroke, 0.8, {Transparency = 1})
        for _, glow in label1.glows do
            tween(glow.stroke, 0.8, {Transparency = 1})
        end

        task.wait(0.1)

        tween(box, 0.8, {ImageTransparency = 0.3})
        tween(label2.label, 0.8, {TextTransparency = 0.2})

        tween(label2.stroke, 0.8, {Transparency = 0.935})
        for _, glow in label2.glows do
            tween(glow.stroke, 0.8, {Transparency = 0.935})
        end

        tween(box, 0.8, {Position = UDim2.new(1, -5, 0, -10)})
        tween(label2.label, 0.8, {Size = UDim2.new(0, label2.label.TextBounds.X + 6, 0, 16)})

        for i = 1, properties.duration2 // 0.76 do
            task.wait(0.38)
            tween(box, 0.8, {ImageTransparency = 1})

            task.wait(0.38)
            tween(box, 0.8, {ImageTransparency = 0.3})
        end

        task.wait(0.38)

        tween(box, 0.8, {ImageTransparency = 1})
        tween(label2.label, 0.6, {TextTransparency = 1})

        tween(label2.stroke, 0.8, {Transparency = 1})
        for _, glow in label2.glows do
            tween(glow.stroke, 0.8, {Transparency = 1})
        end

        tween(box, 0.8, {Position = UDim2.new(0, -19 - (label2.label.TextBounds.X - label1.label.TextBounds.X), 0, -10)})
        tween(label2.label, 0.8, {Size = UDim2.new(0, 0, 0, 16)})

        task.wait(0.6)

        tween(notification, 0.6, {Size = UDim2.new(0, notification.AbsoluteSize.X, 0, -6)})

        task.wait(0.6)

        notification:Destroy()
    end)()
end

--indicator:prompt{text1 =   "ENEMY KILLED", text2 = "Test", duration1 = 3, duration2 = 3}

return indicator
