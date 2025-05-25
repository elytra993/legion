-- Note this is like start of development so everything is like really REALLY in beta so i dont really recommend using it !

repeat task.wait() until game:IsLoaded()
local ui_repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"

local function include(module)   
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/penguin-cmyk/legion/refs/heads/main/utils/"..module..".lua"))()
end 
-- Inclusions
local DhLibrary = include("dh_library")
local UiLibrary = loadstring(game:HttpGet(`{ui_repo}Library.lua`))()
local ThemeManager = loadstring(game:HttpGet(`{ui_repo}addons/ThemeManager.lua`))()



local Animations = DhLibrary:Animations()
local Services   = DhLibrary:Services()
local Sounds     = DhLibrary:Sounds()

local Modules    = {}
local States     = {}
local Tools      = {}

local MainEvent  = Services.MainEvent
local PlaceId    = game.PlaceId

local TeleportService   = game:GetService("TeleportService")
local LightingService   = game:GetService("Lighting")
local UserInputService  = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local LocalPlayer       = Services.LocalPlayer
local RunService        = Services.RunService
local Workspace         = Services.Workspace
local Players           = Services.Players 

local Skins   = ReplicatedStorage:WaitForChild("Bike").Skins
local Camera  = Workspace.CurrentCamera 

local Starting = true 

local RoadRoller = game:GetObjects("rbxassetid://85904556439762")[1]
local SonicRings = game:GetObjects("rbxassetid://107016840921635")[1]
local BlackHole  = game:GetObjects("rbxassetid://107558636253769")[1]
local Spirit     = game:GetObjects("rbxassetid://89731535148122")[1]
local Charm      = game:GetObjects("rbxassetid://139067309930404")[1]
local Thanos     = game:GetObjects("rbxassetid://129891025243944")[1]
local AfterSlash = game:GetObjects("rbxassetid://102168430997910")[1]

local TweenService = game:GetService("TweenService")
local AssetService = game:GetService("AssetService")

local Train = AssetService:CreateMeshPartAsync("rbxassetid://743576537")
local Aura = AssetService:CreateMeshPartAsync("http://www.roblox.com/asset/?id=1323306")


Aura.Color = Color3.fromRGB(4, 175, 236)
Aura.Anchored = true 
Aura.Parent = workspace
Aura.CanCollide = false 
Aura.CastShadow = false 

Train.TextureID = "rbxassetid://743576568"
Train.Anchored = true 
Train.Parent = workspace
Train.CFrame = Train.CFrame * CFrame.Angles(0,-math.rad(90),0)
------------------------------------------------------------------------------------------------------
-- Ts shake Module was NOT made by me
local ShakeModule = {}

local shakeActive = false
local shakeStartTime = 0
local shakeDuration = 0.8
local initialIntensity = 1

local noise = math.noise 

local function updateCameraShake()
    if not shakeActive then return end
    
    local elapsed = os.clock() - shakeStartTime
    if elapsed >= shakeDuration then
        shakeActive = false
        return
    end
    
    local progress = elapsed / shakeDuration
    local currentIntensity = initialIntensity * (1 - progress^2)
    
    local downwardOffset = Vector3.new(0, -0.5 * currentIntensity, 0)
    local bounceOffset = Vector3.new(0, 0.3 * currentIntensity * math.sin(progress * 10), 0)
    
    local timeFactor = os.clock() * 10
    local shakeX = noise(timeFactor, 0) * currentIntensity * 0.1
    local shakeY = noise(timeFactor, 100) * currentIntensity * 0.1
    local shakeZ = noise(timeFactor, 200) * currentIntensity * 0.1
    
    local rotX = noise(timeFactor, 300) * currentIntensity * 0.05 
    local rotY = noise(timeFactor, 400) * currentIntensity * 0.05 
    local rotZ = noise(timeFactor, 500) * currentIntensity * 0.05 
    
    local offsetPosition = downwardOffset + bounceOffset + Vector3.new(shakeX, shakeY, shakeZ)
    local offsetRotation = CFrame.Angles(rotX, rotY, rotZ)
    
    Camera.CFrame = Camera.CFrame * CFrame.new(offsetPosition) * offsetRotation
end

function ShakeModule.StartShake(intensity, duration)
    initialIntensity = intensity or 1
    shakeDuration = duration or 0.8
    shakeStartTime = os.clock()
    shakeActive = true
end

DhLibrary:AddConnection("ShakeModule", Services.RunService.Heartbeat:Connect(updateCameraShake))
------------------------------------------------------------------------------------------------------
-- Modules 
do 
    function Modules:GetChar(option: string): Instance
        return option ~= nil and LocalPlayer.Character:FindFirstChild(option) or LocalPlayer.Character
    end 

    function Modules:Void(character: Model)
        local BodyPosition = character.UpperTorso:FindFirstChild("BodyPosition")
        if BodyPosition then 
            BodyPosition:Destroy()
        end 

        for _,part in pairs(Character:GetChildren()) do 
            if part:IsA("BasePart") then 
                part.Velocity = Vector3.new(9e9,9e9,9e9)
            end 
        end 

        task.wait(.1)
        MainEvent:FireServer("Grabbing",false)
    end 

    function Modules:JoinServer(job_id: string)
        TeleportService:TeleportToPlaceInstance(PlaceId,job_id)
    end 

    function Modules:Modify(attribute: string, value: string | number)
        for _, skin in pairs(Skins:GetChildren()) do 
            if not skin:IsA("Model") then 
                continue
            end 

            local Attribute = skin:GetAttribute(attribute)
            if Attribute ~= nil then 
                skin:SetAttribute(attribute, value)
            end 
        end 
    end 

    function Modules:Delete(parent: Instance, options: { [any]: any })
        for _, instance in pairs(parent:GetDescendants()) do 
            if table.find(options,instance.Name) then 
                instance:Destroy()
            end 
        end 
    end 

    function Modules:GetForwardPosition(distance: number)
        local HumanoidRootPart = Modules:GetChar("HumanoidRootPart")
        return HumanoidRootPart.Position + ( HumanoidRootPart.CFrame.LookVector * distance )
    end 

    function Modules:CFrameSpeed(state: boolean)
        if not state or not States.CanCFrame then 
            DhLibrary:RemoveConnection("CFrameSpeed")
            return 
        end
        DhLibrary:AddConnection("CFrameSpeed",Services.RunService.Heartbeat:Connect(function()
            if not States.CanCFrame then 
                DhLibrary:RemoveConnection("CFrameSpeed")
                return 
            end 
            local Char: Model = Modules:GetChar()
            local Humanoid: Humanoid = Char:FindFirstChild("Humanoid")

            Char.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame + Humanoid.MoveDirection * States.CFrameSpeed.Speed
        end))
    end 

    function Modules:Fly()
        local HumanoidRootPart: Part = Modules:GetChar("HumanoidRootPart")
        local Humanoid: Humanoid = Modules:GetChar("Humanoid")

        if not States.CanFly or States.CurrentlyFlying then 
            DhLibrary:RemoveConnection("Fly")
            States.CurrentlyFlying = false 
            Humanoid.PlatformStand = false 
            return 
        end 

        States.CurrentlyFlying = true 
        Humanoid.PlatformStand = true 

        DhLibrary:AddConnection("Fly",RunService.Heartbeat:Connect(function()
            if not States.CanFly then 
                DhLibrary:RemoveConnection("Fly")
                States.CurrentlyFlying = false 
                Humanoid.PlatformStand = false 
                return
            end 
            
            local Speed: number = States.FlySpeed or 2
            local MoveDirection: Vector3 = Vector3.new(
                UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or ( UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0 ),
                UserInputService:IsKeyDown(Enum.KeyCode.Space) and 0.2,
                UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or ( UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0 )
            )

            HumanoidRootPart.Velocity = Vector3.zero 
            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position) * 
                Camera.CFrame.Rotation * 
                CFrame.new(
                    MoveDirection.X * Speed,
                    MoveDirection.Y * Speed,
                    MoveDirection.Z * Speed
                )
        end))
    end
    
    function Modules:VehicleFly()
        local Vehicle: Model = DhLibrary:GetCar()
        if not Vehicle or States.CurrentlyVehicleFlying then 
            States.AllowedVehicleFly = false 
            States.CurrentlyVehicleFlying = false
            task.wait(.2)
            States.AllowedVehicleFly = true 
            return 
        end 

        States.CurrentlyVehicleFlying = true 

        local BodyPosition = DhLibrary:Create("BodyPosition",{
            Parent = Vehicle,
            MaxForce = Vector3.new(9e9, 9e9, 9e9),
            Position = Vehicle.Position,
        })
        local BodyGyro = DhLibrary:Create("BodyGyro",{
            Parent = Vehicle,
            MaxTorque = Vector3.new(9e9, 9e9, 9e9),
            CFrame = Vehicle.CFrame,
        })

        DhLibrary:AddConnection("VehicleFly",RunService.Heartbeat:Connect(function()
            if not States.AllowedVehicleFly then 
                DhLibrary:RemoveConnection("VehicleFly")
                BodyPosition:Destroy()
                BodyGyro:Destroy()
                return 
            end 

            local Speed: number = States.VehicleFlySpeed or 2
            local MoveDirection: Vector3 = Vector3.new(
                UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or ( UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0 ),
                UserInputService:IsKeyDown(Enum.KeyCode.Space) and 0.2,
                UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or ( UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0 )
            )

            BodyGyro.CFrame = CFrame.new(Vehicle.Position) * Camera.CFrame.Rotation
            BodyPosition.Position = BodyPosition.Position + (BodyGyro.CFrame.LookVector * MoveDirection.Z + BodyGyro.CFrame.RightVector * MoveDirection.X + Vector3.new(0, MoveDirection.Y, 0)) * Speed 
        end))
    end 

    function Modules:AntiStomp(state: boolean)
        if not state then 
            DhLibrary:RemoveConnection("AntiStomp")
            return 
        end 

        local Character: Model = Modules:GetChar()
        local BodyEffects: Folder = Character:WaitForChild("BodyEffects")
        local Ko_Value: BoolValue = BodyEffects:FindFirstChild("K.O")

        local HumanoidRootPart: Part = Character:WaitForChild("HumanoidRootPart")

        DhLibrary:AddConnection("AntiStomp",Ko_Value:GetPropertyChangedSignal("Value"):Connect(function()
            if Ko_Value.Value then 
                Character.Humanoid:ChangeState("Dead")
            end 
        end))
    end 

    function Modules:NoClip(state: boolean)
        if not state then 
            DhLibrary:CanCollide(Modules:GetChar(),true)
            DhLibrary:RemoveConnection("NoClip")
            return 
        end 

        DhLibrary:AddConnection("NoClip",RunService.Heartbeat:Connect(function()
            local Character: Model = Modules:GetChar()
            DhLibrary:CanCollide(Character,false)
        end))
    end 

    function Modules:NoJump(state: boolean)
        local Character: Model = Modules:GetChar()
        local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

        Humanoid.UseJumpPower = not state 
    end 

    function Modules:AntiSlow(state: boolean)
        if not state then 
            DhLibrary:RemoveConnection("AntiSlow")
            return 
        end 

        DhLibrary:AddConnection("AntiSlow",RunService.Heartbeat:Connect(function()
            local BodyEffects: Folder = Modules:GetChar("BodyEffects")
            Modules:Delete(BodyEffects,{
                "NoWalkSpeed",
                "NoJumping",
                "ReduceWalk"
            })
            if BodyEffects:FindFirstChild("Reload") then 
                BodyEffects:FindFirstChild("Reload").Value = false 
            end 
        end))
    end 

    function Modules:AntiSit(state: boolean)
        for _, seat in pairs(Workspace:GetDescendants()) do 
            if seat:IsA("Seat") then 
                seat.Disabled = state 
            end 
        end 
    end 

    function Modules:NoGunCd(state: boolean)
        if not state then 
            for _, cooldown in pairs(game:GetDescendants()) do 
                if cooldown.Name == "ShootingCooldown" or cooldown.Name == "ToleranceCooldown" and cooldown:IsA("ValueBase") then 
                    cooldown.Value = 20
                end 
            end

            DhLibrary:RemoveConnection("NoGunCd")
            print("[DEUBG] Disabled Rapid fire")
            return 
        end 
        print("[DEUBG] Enabled Rapid fire")
        for _, cooldown in pairs(game:GetDescendants()) do 
            if cooldown.Name == "ShootingCooldown" or cooldown.Name == "ToleranceCooldown" and cooldown:IsA("ValueBase") then 
                cooldown.Value = 0
            end 
        end
        
        DhLibrary:AddConnection("NoGunCd",game.DescendantAdded:Connect(function(cooldown)
            if cooldown.Name == "ShootingCooldown" or cooldown.Name == "ToleranceCooldown" and cooldown:IsA("ValueBase") then 
                cooldown.Value = 0
            end
        end))
    end 
end 
-- DhLibrary playaudio fix
do 
    local FakeSound = Instance.new("Sound",Services.Workspace)

    function DhLibrary:StopAudio()
        FakeSound:Stop()
        Services.MainEvent:FireServer("BoomboxStop")
    end 
    function DhLibrary:PlayAudio(id: number)
        local BoomBox = Services.LocalPlayer.Backpack:FindFirstChild("[Boombox]")
        if Services.LocalPlayer.Backpack:FindFirstChild("[Boombox]") then 
            Services.LocalPlayer.Backpack:FindFirstChild("[Boombox]").RequiresHandle = false 
    
            Services.LocalPlayer.Backpack:FindFirstChild("[Boombox]").Parent = Services.LocalPlayer.Character
            BoomBox = Services.LocalPlayer.Character:FindFirstChild("[Boombox]")
            Services.MainEvent:FireServer("Boombox",tonumber(id))
            BoomBox.Parent = Services.LocalPlayer.Backpack
            task.wait(.2)
            Services.LocalPlayer.PlayerGui.MainScreenGui.BoomboxFrame.Visible = false 
            
            Services.LocalPlayer.Character.LowerTorso:WaitForChild("BOOMBOXSOUND")
            
            task.spawn(function()
                repeat wait() until Services.LocalPlayer.Character.LowerTorso:WaitForChild("BOOMBOXSOUND").SoundId == "rbxassetid://"..tostring(id)
                task.wait(Services.LocalPlayer.Character.LowerTorso:WaitForChild("BOOMBOXSOUND").TimeLength)
            end)
        else 
            task.spawn(function()
                    print("Sound playing")
                    FakeSound.SoundId = "rbxassetid://"..tostring(id)
                    FakeSound:Play()
                    task.wait(FakeSound.TimeLength)
            end)
        end 
        if BoomBox then 
            return Services.LocalPlayer.Character.LowerTorso:WaitForChild("BOOMBOXSOUND").TimeLength
        else 
            return FakeSound.TimeLength
        end 
    end 
 
end 

local MainWindow = UiLibrary:CreateWindow({
    Title = "Legion [GRABS]",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.3
})

local MainTab    = MainWindow:AddTab("Main")
local MiscTab    = MainWindow:AddTab("Misc")

local MainSection = MainTab:AddLeftGroupbox("Main")

-- Grab Modules
do 
    -- Was too bored to rewrite InitGrab and Grab
    function Modules:InitGrab()
        DhLibrary:RemoveConnection("Grab")
        DhLibrary:RemoveConnection("GrabMovement")
        repeat task.wait() until LocalPlayer.Character:FindFirstChild("BodyEffects") ~= nil 
        DhLibrary:AddConnection("Grab",Modules:GetChar("BodyEffects").Grabbed:GetPropertyChangedSignal("Value"):Connect(function()
            local GrabbedChar = Modules:GetChar("BodyEffects").Grabbed.Value 
            if GrabbedChar ~= nil then
                Modules:Delete(GrabbedChar,{"BodyVelocity","BodyGyro","BodyPosition"})
                Modules:Grab(GrabbedChar)
                DhLibrary:NoVelocity(GrabbedChar)
                DhLibrary:CanCollide(GrabbedChar,false)
                
                return 
            end 

            DhLibrary:StopAnimation(LocalPlayer.Character,3135389157)
        end))
    end 

    function Modules:Grab(char: Model)
        assert(char ~= nil,"Character is nil")
        if not States.Grab then 
            DhLibrary:RemoveConnection("GrabMovement")
            return 
        end 

        States.GrabbedChar = char 
        States.LastGrabbed = char
        Modules:Delete(char,{"BodyVelocity","BodyGyro","BodyPosition"})
        DhLibrary:StopAnimation(Services.LocalPlayer.Character,11075367458)
        

        repeat task.wait() until char:FindFirstChild("GRABBING_CONSTRAINT")
        local GrabbingConstraint = char:FindFirstChild("GRABBING_CONSTRAINT")
        local Character  = Modules:GetChar("")
        local UpperTorso = char:FindFirstChild("UpperTorso")
        if not GrabbingConstraint:FindFirstChild("H")  or not Character then return end 

        local BodyPosition = DhLibrary:Create("BodyPosition",{
            D = 200,
            MaxForce = Vector3.new(10000, 10000, 10000),
            Position = Character:FindFirstChild("RightHand").Position - Vector3.new(0,1,0),
            Parent = UpperTorso
        })

        local BodyGyro = DhLibrary:Create("BodyGyro",{
            D = 100,
            MaxTorque = Vector3.new(10000, 10000, 10000),
            CFrame = CFrame.new(UpperTorso.Position,Character:FindFirstChild("HumanoidRootPart").Position),
            Parent = UpperTorso
        })

        GrabbingConstraint.H.Length = 9e9 
        DhLibrary:PlayAudio(Options.CustomSound.Value or 4799902666) 

        task.spawn(function()
            task.wait(LocalPlayer.Character.LowerTorso:WaitForChild("BOOMBOXSOUND").TimeLength - 0.1)
            DhLibrary:StopAudio()
        end)

        DhLibrary:PlayAnimation(Services.LocalPlayer.Character,3135389157,0,.1)
        DhLibrary:AddConnection("GrabMovement",Services.RunService.Heartbeat:Connect(function()
            local Character = Modules:GetChar()
            local UpperTorso = char:FindFirstChild("UpperTorso")
            if not States.Grab then 
                DhLibrary:StopAnimation(Character,3135389157)
                DhLibrary:RemoveConnection("GrabMovement")
                return 
            end  
            if States.GrabbedChar ~= nil 
            and Character ~= nil
             and Character:FindFirstChild("BodyEffects") 
             and Modules:GetChar("BodyEffects").Grabbed.Value  ~= nil 
             and States.Grab and char.UpperTorso:FindFirstChild("BodyPosition") then  
                local Position = Character:FindFirstChild("RightHand").Position - Vector3.new(0,1,0) 
                if Options.grab_mode.Value == "Grab" then 
                    Position = Character:FindFirstChild("RightHand").Position - Vector3.new(0,1,0)
                    if not DhLibrary:IsAnimPlaying(Character,3135389157) then 
                        DhLibrary:PlayAnimation(Character,3135389157,0,.1)
                    end 
                elseif Options.grab_mode.Value == "Behind" then 
                    Position = Character:FindFirstChild("HumanoidRootPart").Position - Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 3
                    DhLibrary:StopAnimation(Character,3135389157)
                    DhLibrary:StopAnimation(Character,11075367458)
                elseif Options.grab_mode.Value == "Infront" then 
                    Position = Modules:GetForwardPosition(3)
                    DhLibrary:StopAnimation(Character,3135389157)
                    DhLibrary:StopAnimation(Character,11075367458)
                elseif Options.grab_mode.Value == "Custom" then 
                    Position = Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(Options.xAxis.Value,Options.yAxis.Value,Options.zAxis.Value)
                    DhLibrary:StopAnimation(Character,3135389157)
                    DhLibrary:StopAnimation(Character,11075367458)
                end 
                local Orientation = CFrame.new(UpperTorso.Position,Character:FindFirstChild("HumanoidRootPart").Position)
                
                if Options.grab_mode.Value == "Infront" then 
                    Orientation = CFrame.new(UpperTorso.Position,Character:FindFirstChild("HumanoidRootPart").Position + Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * -5)
                else 
                    Orientation = CFrame.new(UpperTorso.Position,Character:FindFirstChild("HumanoidRootPart").Position)
                end 

                BodyGyro.CFrame = Orientation
				BodyPosition.Position = Position
                
             elseif Modules:GetChar("BodyEffects"):FindFirstChild("Grabbed") and Modules:GetChar("BodyEffects").Grabbed.Value  == nil then 
                DhLibrary:StopAnimation(Character,3135389157)
                States.GrabbedChar = nil
            end 
        end))
    end 

    function Modules:DestroyTool(Text: string)
        local Tool: Tool = LocalPlayer.Backpack:FindFirstChild(Text) or LocalPlayer.Character:FindFirstChild(Text)
        if Tool then 
            Tool:Destroy()
        end 

        DhLibrary:RemoveConnection(Text.."_tool")
    end 

    function Modules:GrabTool(options: { [any]: any })
        local Character: Model = Modules:GetChar()
        local Backpack: Backpack = LocalPlayer.Backpack

        local tool_Callback: (...any) -> ...any = options.Callback 
        local name: string = options.name or options.Name 
        local description: string = options.Description
        local stopanimation: boolean = options.StopAnimations

        Tools[name] = {}

        local NewTool: Tool = DhLibrary:Create("Tool",{
            Name = name,
            RequiresHandle = false,
            ToolTip = description
        })
        DhLibrary:AddConnection(name.."_tool",NewTool.Activated:Connect(function()
            Tools[name]["State"] = true

            if not States.Grab or not States.GrabbedChar then 
                return 
            end

            States.Grab = false 

            local success,err = pcall(function()
                local Character: Model = LocalPlayer.Character
                local GrabbedChar: Model =  Character.BodyEffects:FindFirstChild("Grabbed").Value 

                if Character == nil then 
                    error("Localplayers character doesn't exist wth???")
                end 

                if GrabbedChar == nil then 
                    return 
                end 

                if stopanimation then 
                    DhLibrary:StopAnimation(Character,3135389157)
                    DhLibrary:StopAnimation(Character,11075367458)
                end 

                tool_Callback(GrabbedChar,Character)

                NewTool.Parent = LocalPlayer.Backpack
                NewTool.Parent = LocalPlayer.Character
            end)

            if not success then 
                print(err)
            end 
        end))

        MainSection:AddToggle(name, {
            Text = name,
            Default = false,
            ToolTip = description,
            Callback = function(state)
                if state then 
                    NewTool.Parent = LocalPlayer.Backpack
                else 
                    NewTool.Parent = nil 
                end 
            end 
        })
    end 
end 
local lastStompTime = 0
local STOMP_COOLDOWN = 2
local STOMP_EFFECT = "Spirit"
do 
    local function boobs(targetCharacter)
        -- all of these came from dh modded (the idea and assets)
        -- I just made my own implementation of it.
        STOMP_EFFECT = States.StompEffect or "Spirit"
        local currentTime = tick()
        if currentTime - lastStompTime < STOMP_COOLDOWN then 
            return 
        end
        
        lastStompTime = currentTime
        if STOMP_EFFECT == "RoadRoller" then 
            RoadRoller.Parent = workspace
            RoadRoller.Anchored = true 
            RoadRoller.CFrame = targetCharacter.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
            local Sound = Instance.new("Sound",workspace)
            Sound.SoundId = "rbxassetid://4877348549"
            Sound.PlayOnRemove = true 
            Sound:Destroy()    
            
            TweenService:Create(
                RoadRoller,
                TweenInfo.new(0.2), 
                { 
                    CFrame = targetCharacter.HumanoidRootPart.CFrame * 
                            CFrame.new(0, 3, 0) * 
                            CFrame.Angles(math.rad(200), -math.rad(200), math.rad(90)) 
                }
            ):Play()
    
            ShakeModule.StartShake(7, 0.5)
    
            task.wait(2)
            RoadRoller.CFrame = CFrame.new(20,2000,20)
        elseif STOMP_EFFECT == "Rings" then 
            local Sound = Instance.new("Sound",workspace)
            Sound.SoundId = "rbxassetid://7456436580"
            Sound.PlayOnRemove = true 
            Sound:Destroy()

            local FakePart = Instance.new("Part",workspace)
            FakePart.Transparency = 1
            FakePart.Position = targetCharacter.Head.Position
            FakePart.Anchored = true 
            FakePart.CanCollide = false 
    
            SonicRings.Parent = FakePart
            task.wait(0.5)
            SonicRings.Parent = workspace
            FakePart:Destroy()
        elseif STOMP_EFFECT == "BlackHole" then 
            BlackHole.Parent = workspace
            BlackHole.Position = targetCharacter:FindFirstChild("UpperTorso").Position + Vector3.new(0,1,0)
            BlackHole.open:Play()
            ShakeModule.StartShake(7, 0.5)
    
            
            for _, emitter in pairs(BlackHole:GetDescendants()) do 
                if emitter:IsA("ParticleEmitter") or emitter:IsA("Beam") then 
                    emitter.Enabled = true  
                end 
            end 
    
            task.wait(1.5)
            task.spawn(function()
                BlackHole.wind:Play()
                BlackHole.bring:Play()
    
                for _, part in pairs(targetCharacter:GetChildren()) do 
                    if not part:IsA("BasePart") then continue end 
                    TweenService:Create(part,TweenInfo.new(1.4),{
                        Position = BlackHole.Event.WorldPosition
                    }):Play()
                end 
                task.wait(1.5)
                targetCharacter:Destroy()
            end)
    
            task.wait(3)
            TweenService:Create(BlackHole.wind,TweenInfo.new(0.5),{
                Volume = 0
            }):Play()
    
            for _, emitter in pairs(BlackHole:GetDescendants()) do 
                if emitter:IsA("ParticleEmitter") or emitter:IsA("Beam") then 
                    emitter.Enabled = false 
                end 
            end 
    
            task.wait(2)
            BlackHole.Parent = Services.ReplicatedStorage
        elseif STOMP_EFFECT == "Spirit" then 
            Spirit.Stomp:Play()
            Aura.Transparency = 0
            Aura.Position = targetCharacter:FindFirstChild("UpperTorso").Position 
    
            ShakeModule.StartShake(7, 0.5)

            TweenService:Create(Aura,TweenInfo.new(2),{
                Position = targetCharacter:FindFirstChild("UpperTorso").Position + Vector3.new(0,50,0),
                Size = Vector3.new(120, 90, 120),
                Transparency = 1
            }):Play()
            local Sound = Instance.new("Sound",workspace)
            Sound.SoundId = "rbxassetid://6290067239"
            Sound.PlayOnRemove = true 
            Sound:Destroy()
    
            for _, asset in pairs(targetCharacter:GetDescendants()) do 
                if not asset:IsA("BasePart") or not asset:IsA("Decal") then continue end 
    
                TweenService:Create(asset,TweenInfo.new(0.5),{
                    Transparency = 1
                }):Play()
            end 
        elseif STOMP_EFFECT == "Charm" then 
            local Stomp = Charm.FX.Stomp 
            local Sound = Charm.SFX:FindFirstChild("Explosive Hit 5")
            local TargetPos = targetCharacter:FindFirstChild("UpperTorso").Position

            local Emitters = {}

            local PartOne = Stomp.PartOne:Clone()
            local Part    = Stomp.Part:Clone()

            Charm.Parent = workspace

            PartOne.Position = TargetPos
            PartOne.Anchored = true 
            PartOne.Parent = workspace

            Part.Position = TargetPos
            Part.Anchored = true 
            Part.Parent = workspace

            for _, emitter in pairs(PartOne:GetDescendants()) do 
                if emitter:IsA("ParticleEmitter") then 
                    table.insert(Emitters,emitter)
                end 
            end 

            for _, emitter in pairs(Part:GetDescendants()) do 
                if emitter:IsA("ParticleEmitter") then 
                    table.insert(Emitters,emitter)
                end 
            end

            for _, emitter in pairs(Emitters) do 
                emitter.Enabled = true   
            end 

            local old_color = LightingService.FogColor
            Sound:Play()
            for _, asset in pairs(targetCharacter:GetDescendants()) do 
                if not asset:IsA("BasePart") or not asset:IsA("Decal") then continue end 
    
                TweenService:Create(asset,TweenInfo.new(0.5),{
                    Transparency = 1
                }):Play()
            end 
            TweenService:Create(LightingService,TweenInfo.new(0.5),{
                FogColor = Color3.fromRGB(255, 42, 191)
            }):Play()

            task.wait(0.8)
            Part:Destroy()
            PartOne:Destroy()

            TweenService:Create(LightingService,TweenInfo.new(0.5),{
                FogColor = old_color
            }):Play()
            Charm.Parent = Services.ReplicatedStorage
        elseif STOMP_EFFECT == "Thanos" then
            local Sound = Instance.new("Sound",workspace)
            Sound.SoundId = "rbxassetid://3050376525"
            Sound:Play()

            for _, part in pairs(targetCharacter:GetDescendants()) do 
                if part:IsA("BasePart") or part:IsA("MeshPart") then 
                    local Thanos_Effect = Thanos:Clone() 
                    Thanos_Effect.Parent = part 
                    Thanos_Effect.Color =  ColorSequence.new({ ColorSequenceKeypoint.new(0, part.Color), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 33, 18)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) })

                    TweenService:Create(part,TweenInfo.new(0.5),{
                        Transparency = 1
                    }):Play()

                    task.delay(0.5,function()
                        Thanos_Effect.Enabled = false 
                    end)
                    task.wait(.1)
                end 
            end
            repeat task.wait() until Sound.TimeLength == 0
            Sound:Destroy()
        elseif STOMP_EFFECT == "Afterslash" then 
            local AfterSlashEfx = AfterSlash:Clone()
            local UpperTorso = targetCharacter:FindFirstChild("UpperTorso")
            UpperTorso.Position = (CFrame.new(UpperTorso.Position) * CFrame.new(0,35,0)).Position

            local Part = AfterSlashEfx.Part
            Part.Position = UpperTorso.Position
            Part.Parent = UpperTorso
            Part.Size = Vector3.new(5,7,5)

            for _ = 1, 25 do 
                task.wait(math.random(1,9) / 100)
                local Sound = Instance.new("Sound",Part)
                Sound.SoundId = "rbxassetid://5989945551"
                local DistortionSoundEffect = Instance.new("DistortionSoundEffect",Sound)
                Sound.PlayOnRemove = true 
                Sound:Destroy()
                Part.Position = UpperTorso.Position
            end

            UpperTorso.Position = (CFrame.new(UpperTorso.Position) * CFrame.new(0, -5, 0)).Position
            for _, emitter in pairs(Part:GetDescendants()) do
                if emitter:IsA("ParticleEmitter") then
                    emitter.Enabled = false
                end
            end

            task.wait(0.25)
            local Attachment = Instance.new("Attachment",workspace.Terrain)
            Attachment.WorldPosition = UpperTorso.Position

            local Sound = Instance.new("Sound",Part)
            Sound.SoundId = "rbxassetid://4471648128" 
            Sound.PlayOnRemove = true
            Sound:Destroy()

            for _, emitter in pairs(AfterSlashEfx.Burst:GetDescendants()) do 
                if emitter:IsA("ParticleEmitter") then 
                    emitter.Parent = Attachment
                    emitter:Emit(emitter:GetAttribute("EmitCount"))
                end 
            end 

            for _, part in pairs(targetCharacter:GetDescendants()) do
                if part:IsA("BasePart") then
                    TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                        Transparency = 1
                    }):Play()
                end
            end 
        end 
    end 
    function Modules:StompEffects(state)
        if not state then 
            DhLibrary:RemoveConnection("StompEffect")
            return 
        end 

        DhLibrary:AddConnection("StompEffect", RunService.Heartbeat:Connect(function()
            local playerCharacter = LocalPlayer.Character
            if not playerCharacter or not playerCharacter:FindFirstChild("LowerTorso") or not playerCharacter:FindFirstChild("UpperTorso") then
                return
            end
            
            local rayOrigin = playerCharacter.LowerTorso.Position
            local rayDirection = Vector3.new(0, -playerCharacter.UpperTorso.Size.y * 4.5, 0)
            
            local whitelist = {}
            for _, player in ipairs(Services.Players:GetPlayers()) do
                if player ~= Services.LocalPlayer and player.Character and not  whitelist[player.Character] then
                    table.insert(whitelist, player.Character)
                end
            end
            
            if #whitelist > 0 then
                local hitPart, hitPosition, hitNormal = workspace:FindPartOnRayWithWhitelist(
                    Ray.new(rayOrigin, rayDirection),
                    whitelist,
                    false,
                    true
                )
                
                if hitPart then
                    local stompedCharacter = hitPart:FindFirstAncestorOfClass("Model")
                    if stompedCharacter and stompedCharacter:FindFirstChild("HumanoidRootPart") and stompedCharacter:FindFirstChild("BodyEffects") and stompedCharacter.BodyEffects.SDeath.Value and DhLibrary:IsAnimPlaying(playerCharacter,2816431506) then
                        boobs(stompedCharacter)
                    end
                end
            end
        end))
    end 
end 
do 
    local Movement = MiscTab:AddLeftGroupbox("Movement")
    local Player = MiscTab:AddLeftGroupbox("Player")
    local PlayerAnimations = MiscTab:AddLeftGroupbox("PlayerAnimations")
    local Server = MiscTab:AddRightGroupbox("Server")
    local StompEffects = MiscTab:AddRightGroupbox("StompEffects")

    -- StompEffects
    StompEffects:AddToggle("StompEffects",{
        Text = "Stompeffects",
        Default = false,
        Callback = function(state)
            Modules:StompEffects(state)
        end 
    })
    StompEffects:AddDropdown("Dropdown",{
        Text = "Select stomp effect",
        Values = {
            "Spirit",
            "RoadRoller",
            "Rings",
            "BlackHole",
            "Charm",
            "Thanos",
            "Afterslash"
        },
        Default = 1,
        Multi = false,
        Callback = function(value)
            States.StompEffect = value
        end 
    })
    -- Movement
    Movement:AddToggle("VFly",{
        Text = "Toggle Vehicle Fly",
        Default = false,
        Callback = function(state)
            States.AllowedVehicleFly = state 
        end 
    }):AddKeyPicker("Vehicle Fly",{ 
        Text = "",
        Default = "X",
        Mode = "Toggle",
        SyncToggleState = false,
        Callback = function(key)
            Modules:VehicleFly()
        end
    })

    Movement:AddToggle("PFly",{
        Text = "Toggle Player Fly",
        Default = false,
        Callback = function(state)
            States.CanFly = state 
        end 
    }):AddKeyPicker("Player Fly",{ 
        Text = "",
        Default = "X",
        Mode = "Toggle",
        Callback = function(key)
            Modules:Fly()
        end
    })

    Movement:AddSlider("PSpeed",{
        Text  = "Player Fly Speed",
        Default = 2,
        Min = 1,
        Max = 20,
        Rounding = 1,
        Compact = false,
        Callback = function(value)
            States.FlySpeed = value 
        end
    })
    Movement:AddSlider("VFlySpeed",{
        Text  = "Vehicle Fly Speed",
        Default = 2,
        Min = 1,
        Max = 20,
        Rounding = 1,
        Compact = false,
        Callback = function(value)
            States.VehicleFlySpeed = value 
        end
    })
    -- Player
    Player:AddToggle("NoClip",{
        Text = "NoClip",
        Default = false,
        Callback = function(state)
            Modules:NoClip(state)
        end 
    })
    Player:AddToggle("No Jump Cooldown",{
        Text = "No Jump Cooldown",
        Default = false,
        Callback = function(state)
            if not Starting then 
                States.Jumpcooldown = state 
                Modules:NoJump(state)
            end 
        end 
    })
    Player:AddToggle("Anti sit",{
        Text = "Anti sit",
        Default = false,
        Callback = function(state)
            if not Starting then 
                Modules:AntiSit(state)
            end 
        end 
    })
    Player:AddToggle("Anti Slow",{
        Text = "Anti Slow",
        Default = false,
        Callback = function(state)
            if not Starting then 
                Modules:AntiSlow(state)
            end 
        end 
    })
    Player:AddToggle("Anti Stomp",{
        Text = "Anti Stomp",
        Default = false,
        Callback = function(state)
            if not Starting then 
                States.AntiStomp = state
                Modules:AntiStomp(state)
            end 
        end 
    })
    Player:AddToggle("Rapid Fire",{
        Text = "Rapid Fire",
        Default = false,
        Callback = function(state)
            if not Starting then 
                Modules:NoGunCd(state)
            end 
        end 
    })
    --Server
    Server:AddInput("job_id",{
        Default = "Enter J*bId",
        Finished = true,
        Numeric = false,

        Text = 'Enter j*b id',
        PlaceHolder = "Enter j*bid"
    })
    Server:AddButton({
        Text = "Join Server",
        Func = function()
            Modules:JoinServer(game.JobId or Options.job_id.Value)
        end 
    })
    Server:AddButton({
        Text = "Copy J*bId",
        Func = function()
            setclipboard(`game:GetService("TeleportService"):TeleportToPlaceInstance({PlaceId},"{game.JobId}")`)
        end 
    })
end 

do 
    function Modules:ImpactFrame()
        local Black = DhLibrary:Create("ColorCorrectionEffect",{
            TintColor = Color3.fromRGB(0,0,0),
        })
        local White = DhLibrary:Create("Highlight",{
            FillColor = Color3.fromRGB(255,255,255),
            FillTransparency = 0
        })
        task.wait(.1)
        Black.Parent = LightingService
        White.Parent = Modules:GetCharacter("")
        task.wait(.1)
        White.FillColor = Color3.fromRGB(0,0,0)
        Black.TintColor = Color3.fromRGB(255,255,255)
        Black.Brightness = 1
        task.wait(.1)
        White:Destroy()
        Black:Destroy()
    end 
    
    function Modules:CloneChar(Character)
        local LocalChar = Modules:GetChar("")
        LocalChar.Archivable = true 
        
        local ClonedChar = LocalChar:Clone() 
        ClonedChar.Parent = Services.Workspace
        ClonedChar.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
    
        ClonedChar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        if ClonedChar:FindFirstChild("ForceField") then 
            ClonedChar:FindFirstChild("ForceField"):Destroy()
        end 
    
        local Player = Services.Players:FindFirstChild(Character.Name)
        
        if not Player then 
            return 
        end 
    
        local HumanoidDescription = Services.Players:GetHumanoidDescriptionFromUserId(Player.UserId)
        ClonedChar.Humanoid:ApplyDescription(HumanoidDescription)
    
        LocalChar.Archivable = false

        ClonedChar.Humanoid.BodyWidthScale.Value = Character.Humanoid.BodyWidthScale.Value
        ClonedChar.Humanoid.BodyProportionScale.Value = Character.Humanoid.BodyProportionScale.Value
        ClonedChar.Humanoid.BodyDepthScale.Value = Character.Humanoid.BodyDepthScale.Value
        ClonedChar.Humanoid.HeadScale.Value = Character.Humanoid.HeadScale.Value

        for _, accessory in pairs(ClonedChar:GetDescendants()) do 
            if accessory:IsA("Accessory") or accessory:IsA("ShirtGraphic") or accessory:IsA("Shirt") or accessory:IsA("Pants") then
                accessory:Destroy()
            end
            if accessory:IsA("BasePart") then 
                accessory.Transparency = 1
            end 
        end

        return ClonedChar 
    end 
    
    function Modules:AlignControl(part,part1,Offset)
        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        part.Velocity = Vector3.new(0, 0, 0)
        part.CFrame = part1.CFrame * (Offset or CFrame.new())
        part.CanCollide = false
        part1.CanCollide = false
    end
end 
do 
    local Chain = DhLibrary:Create("Beam",{
        Texture = "rbxassetid://12706577665",
        Enabled = true,
        Parent  = Services.Workspace,
        Width0  = 1,
        Width1  = 1,
        TextureSpeed = 0,
        Segments = 10,
        CurveSize0 = 0,
        CurveSize1 = 0,
        TextureLength = 5,
        Transparency = NumberSequence.new(0),
        FaceCamera = true,
        Color = ColorSequence.new(Color3.fromRGB(170,170,170),Color3.fromRGB(170,170,170),Color3.fromRGB(170,170,170))
    })
    MainSection:AddToggle("Grab",{
        Text = "Grab",
        Default = false,
        Callback = function(state)
            States.Grab = state
            if state then 
                Tools["GrabReal"] = DhLibrary:Create("Tool",{
                    Parent = LocalPlayer.Backpack,
                    RequiresHandle = false,
                    ToolTip = "Enabled Grab",
                    Name = "Activate"
                })

                Tools["GrabReal"].Activated:Connect(function()
                    MainEvent:FireServer("Grabbing",true)
                    repeat task.wait() until LocalPlayer.Character:FindFirstChild("BodyEffects") and LocalPlayer.Character:FindFirstChild("BodyEffects").Grabbed.Value ~= nil 
                    local Character: Model = LocalPlayer.Character:FindFirstChild("BodyEffects").Grabbed.Value 
                    if Character:FindFirstChild("GRABBING_CONSTRAINT"):FindFirstChild("H") then 
                        Modules:Grab(Character)
                    end 
                end)
            else 
                if Tools["GrabReal"] then Tools["GrabReal"]:Destroy() end 
            end 
        end 
    })
    MainSection:AddDropdown("grab_mode",{
        Text = "Grab mode",
        Values = {
            "Grab",
            "Behind",
            "Infront",
            "Custom"
        },
        Default = 1,
        Multi = false,
    })

    MainSection:AddInput("CustomSound",{
        Default  = "Enter a sound id",
        Finished = true,
        Numeric = false,


        Text = 'Custom Sound id',
        Placeholder = "Enter sound id",
    })
    MainSection:AddSlider("xAxis",{
        Text = "x axis",
        Default = 2,
        Min = 0,
        Max = 20,
        Rounding = 1,
    })
    MainSection:AddSlider("yAxis",{
        Text = "y axis",
        Default = 2,
        Min = 0,
        Max = 20,
        Rounding = 1,
    })
    MainSection:AddSlider("zAxis",{
        Text = "z axis",
        Default = 2,
        Min = 0,
        Max = 20,
        Rounding = 1,
    })
    MainSection:AddToggle("Effects",{
        Text = "Effects",
        Default = true,
        Callback = function(state)
            States.Effects = state
        end 
    })
    Modules:GrabTool({
        Name = "Get Over Here",
        StopAnimations = true,
        Description = "Mortal combat get over here",
        Callback = function(Grabbed,Character)
            DhLibrary:PlayAudio(8643750815)
            task.wait(1.6)
            DhLibrary:StopAudio()
            DhLibrary:PlayAudio(7592607446)
            DhLibrary:PlayAnimation(Character,16768625968)
            if States.Effects then 
                Chain.Attachment0 = DhLibrary:Create("Attachment",{
                    Parent = Grabbed:FindFirstChild("UpperTorso"),
                })
                Chain.Attachment1 = DhLibrary:Create("Attachment",{
                    Parent = Character:FindFirstChild("RightHand"),
                })
            end
            task.wait(1.1)
            
            DhLibrary:Tween(
                Grabbed.UpperTorso:FindFirstChild("BodyPosition"),
                0.6,
                { Position = Character.HumanoidRootPart.Position }
            )
         
            task.wait(0.6)
            Chain.Attachment0 = nil
            Chain.Attachment1 = nil 
            DhLibrary:StopAudio()
            States.Grab = true 
        end, 
    })

    Modules:GrabTool({
        Name = "Made In Heaven",
        StopAnimation = true,
        Description = "",
        Callback = function(Grabbed,Character)
            local OldFov,OldFog,OldFogColor = Camera.FieldOfView,LightingService.FogEnd,LightingService.FogColor
            
            DhLibrary:PlayAudio(8004825017)
            DhLibrary:Chat("Made In Heaven...")
    
            Character:FindFirstChild("HumanoidRootPart").CFrame = Grabbed:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(1,0,3)
            DhLibrary:PlayAnimation(Character,11394033602)
    
            if States.Effects then 
                DhLibrary:Tween(Camera,1,{ FieldOfView = 120 })
                DhLibrary:Tween(LightingService,1, { FogEnd = 20 })
                DhLibrary:Tween(LightingService,1, { FogColor = Color3.fromRGB(255,255,255) })
            end 
            DhLibrary:Tween(Character:FindFirstChild("Humanoid"), 1,{ HipHeight = 3.6 })
            task.wait(1)
    
            DhLibrary:Chat("Heaven has arrived..")
            DhLibrary:Tween(Grabbed:FindFirstChild("UpperTorso").BodyPosition,0.5,{ Position = Modules:GetForwardPosition(10) + Vector3.new(0,10,0) })
            task.wait(7)
            DhLibrary:Void(Grabbed)
            task.wait(0.6)
            DhLibrary:StopAudio()

            DhLibrary:StopAnimation(Character,11394033602)
            States.Grab = true
    
            DhLibrary:Tween(Camera,1,{ FieldOfView = OldFov })
            DhLibrary:Tween(LightingService,1, { FogEnd = OldFog })
            DhLibrary:Tween(LightingService,1, { FogColor = OldFogColor })
    
            DhLibrary:Tween(Character:FindFirstChild("Humanoid"), 1,{ HipHeight = 2 })
        end,
    })

    Modules:GrabTool({
        Name = "Orbit",
        Description = "Orbits the players parts around you",
        StopAnimations = true,
        Callback = function(Grabbed,Character)
            local currentTime: number = 0;
            local Character: Model = Modules:GetChar()

            DhLibrary:AddConnection("Orbit",RunService.Heartbeat:Connect(function(delta)
                if Character.BodyEffects.Grabbed.Value == nil or not Tools["Orbit"]["State"] then 
                    States.Grab = true 
                    DhLibrary:RemoveConnection("Orbit")
                    return 
                end 
                currentTime = currentTime + delta
                Grabbed.UpperTorso.CFrame      = CFrame.Angles(math.pi * 0.1, 1.5 * math.pi * currentTime, 0)* CFrame.new(1, 2, 5) + Character.HumanoidRootPart.Position
                Grabbed.LowerTorso.CFrame      = CFrame.Angles(math.pi * -0.1, 1.5 * math.pi * -currentTime, 0)* CFrame.new(1, 2, 5) + Character.HumanoidRootPart.Position
                Grabbed.LeftUpperArm.CFrame    = CFrame.Angles(math.pi * .25, 3 * math.pi * currentTime, 0)* CFrame.new(1, 2, 5) + Character.HumanoidRootPart.Position
                Grabbed.RightUpperArm.CFrame   = CFrame.Angles(math.pi * -.25, 3 * math.pi * -currentTime, 0)* CFrame.new(1, 2, 5) + Character.HumanoidRootPart.Position
                Grabbed.LeftUpperLeg.CFrame    = CFrame.Angles(math.pi * .3, 2.5 * math.pi * currentTime, 0)* CFrame.new(1, 2, 5) + Character.HumanoidRootPart.Position
                Grabbed.RightUpperLeg.CFrame   = CFrame.Angles(math.pi * -.3, 2.5 * math.pi * -currentTime, 0)* CFrame.new(1, 0, 5) + Character.HumanoidRootPart.Position
                Grabbed.LeftLowerLeg.CFrame    = CFrame.Angles(math.pi * .7, 2 * math.pi * currentTime, 0)* CFrame.new(1, 2, 7) + Character.HumanoidRootPart.Position
                Grabbed.RightLowerLeg.CFrame   = CFrame.Angles(math.pi * .8, 2 * math.pi * -currentTime, 0)* CFrame.new(1, 2, 7) + Character.HumanoidRootPart.Position
                Grabbed.LeftLowerArm.CFrame    = CFrame.Angles(math.pi * .9, 2 * math.pi * currentTime, 0)* CFrame.new(1, 2, 7) + Character.HumanoidRootPart.Position
                Grabbed.RightLowerArm.CFrame   = CFrame.Angles(math.pi * 1, 2 * math.pi * -currentTime, 0)* CFrame.new(1, 2, 7) + Character.HumanoidRootPart.Position
            end))
        end
    })

    Modules:GrabTool({
        Name = "Make Player Stand",
        Description = "Turns the player into your 'stand'",
        StopAnimations = true,
        Callback = function(Grabbed,Character)
            local ClonedChar: Model = Modules:CloneChar(Grabbed)
            local Cross: boolean = false 
            Modules:Delete(Grabbed, {  "BodyGyro", "BodyPosition" })

            DhLibrary:AddConnection("Make Player Stand",RunService.Heartbeat:Connect(function()
                if Character.BodyEffects and Character.BodyEffects.Grabbed.Value == nil or not Tools["Make Player Stand"]["State"] then 
                    States.Grab = true 
                    ClonedChar:Destroy()
                    DhLibrary:RemoveConnection("Make Player Stand")
                end 

                DhLibrary:NoVelocity(ClonedChar)
                DhLibrary:NoVelocity(Grabbed)
                DhLibrary:CanCollide(Grabbed,false)

                local BodyGyro = ClonedChar:FindFirstChild("UpperTorso") and ClonedChar.UpperTorso:FindFirstChild("BodyGyro") or DhLibrary:Create("BodyGyro",{
                    Parent = ClonedChar:FindFirstChild("UpperTorso") ,
                    D = 100,
                })

                for _, _____GYAT in pairs(Grabbed:GetChildren()) do 
                    if _____GYAT:IsA("BasePart") and ClonedChar:FindFirstChild(_____GYAT.Name) then 
                        if _____GYAT.Name == "UpperTorso" then 
                            _____GYAT.CFrame = _____GYAT.CFrame * CFrame.Angles(math.rad(140),0,0)
                        end 
                        Modules:AlignControl(_____GYAT,ClonedChar:FindFirstChild(_____GYAT.Name),CFrame.new(0,0,0))
                    
                    end 
                end 


                BodyGyro.CFrame = CFrame.lookAt(ClonedChar.UpperTorso.Position, Character.HumanoidRootPart.Position)
                BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)

                DhLibrary:Tween(ClonedChar.HumanoidRootPart, 0.4, {
                    CFrame = CFrame.new(
                        Character.HumanoidRootPart.Position + 
                        Character.HumanoidRootPart.CFrame.LookVector * -3 +
                        Character.HumanoidRootPart.CFrame.RightVector * -1 +
                        Vector3.new(0, 4.2, 0)
                    )
                })
            end))

            DhLibrary:PlayAnimation(ClonedChar,3541114300)
        end 
    })




end 
do 
    Modules:InitGrab()
    DhLibrary:AddConnection("CharacterAdded",LocalPlayer.CharacterAdded:Connect(function()
        Modules:AntiStomp(States.AntiStomp)
        Modules:NoJump(States.NoJumpCooldown)
    end))
end 

Starting = false 

ThemeManager:SetLibrary(UiLibrary)
ThemeManager:ApplyTheme("Jester")
