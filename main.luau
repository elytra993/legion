


repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer.Character

local success, err = pcall(function()
    local fake_connections = {}
    local character = game.Players.LocalPlayer.Character
    local previous_connections = #getconnections(character.ChildAdded)

    local random_connections = math.random(1, 10)

    for i = 1, random_connections do
        fake_connections[i] = character.ChildAdded:Connect(function() end)
    end

    if #fake_connections + previous_connections ~= #getconnections(character.ChildAdded) then
        error("Executor is trying to fake getconnections (did not return the right amount of connections) ")
        return
    end


    for i = 1, random_connections do
        fake_connections[i]:Disconnect()
    end
end)

if not success then
    game.Players.LocalPlayer:Kick("Exc is not supported vro (getconnections)\n"..err)
    return
end

local success, err = pcall(function()

    new_return = function() end

    local hooked_function = function()
        return print
    end

    hookfunction(hooked_function, function()
        return new_return
    end)

    local result = hooked_function()
    if result ~= new_return then
        error("Exec doesn't support hookfunction (did not return the right value) ")
        return
    end
end)

if not success then
    game.Players.LocalPlayer:Kick("Exc is not supported vro (hookfunction)\n"..err)
    return
end

local success, err = pcall(function()
    local fake_mt = setmetatable({}, {
        __index = function()
            return "real"
        end
    })
    local old_index;
    old_index = hookmetamethod(fake_mt, "__index", function()
        return "bye"
    end)

    local index = fake_mt.__
    if index ~= "bye" then
        error("Didn't return the right value")
        return
    end

    hookmetamethod(fake_mt, "__index", old_index)
end)

if not success then
    game.Players.LocalPlayer:Kick("Exc is not supported vro (hookmetamethod)\n"..err)
    return
end



local LogService = game:GetService("LogService")
local MessageOut = LogService.MessageOut
local CurrentConnections = {}
local openac_func;

local function intercepted(...)
    warn(`Intercepted: {...}`)
    return {}
end
--        local ignored_functions = { 3, 12, 1, 11, 15, 8, 20, 18, 22 }

local function modify_connection(connection: RBXScriptConnection)
    local success, err = pcall(function()
        local upvalues = getupvalues(connection.Function)[9]
        openac_func = upvalues[1]

        --14 - wrap
        debug.setupvalue(openac_func, 14, function(...)
            return function(...)
                local args = { ... }
                local first_arg = args[1]

                if typeof(first_arg) == "table" and first_arg[1] then
                    pcall(function()
                        if typeof(first_arg[1]) == "userdata" then
                            for i = 1, 4 do
                                first_arg[i]:Disconnect()
                            end
                        end
                    end)
                end
            end
        end)

        debug.setupvalue(openac_func, 1, function(...)
            task.wait(9e9)
        end)

        hookfunction(openac_func, intercepted)
    end)
end

game:GetService("RunService").RenderStepped:Connect(function()
    local openac_connections = getconnections(MessageOut)
    for i = 1, #openac_connections do
        local connection = openac_connections[i]
        if CurrentConnections[connection] ~= "hi" then
            CurrentConnections[connection] = "hi"
            modify_connection(connection)
        end
    end
end)

local gc = getgc()
local protected_call = (function(func)
    return (function(...)
        local success, err = pcall(func, ...)
        if err == "C stack overflow" then
            return "cannot resume dead coroutine"
        end

        return func(...)
    end)
end)

for i = 1, #gc do
    local func = gc[i]
    if typeof(func) ~= "function" or isexecutorclosure(func) then continue end

    if func == coroutine.wrap then
        gc[i] = protected_call(coroutine.wrap)
        break
    end

end


local old_namecall;
local lower = string.lower
local find = string.find

local blacklisted = { "BreathingHAMON",
                      "OneMoreTime",
                      "TeleportDetect",
                      "GUI_CHECK",
                      "checkingSPEED",
                      "BANREMOTE",
                      "PERMAIDBAN",
                      "KICKREMOTE",
                      "BR_KICKPC",
                      "BR_KICKMOBILE",
                      "UpdateMousePosI",
                      "UpdateMousePos"
                    }


local modules = {
    disable_kill = function() end, -- if the user tries to call it while kill is not killing
    closest_player = function() end
}



local new_namecall = newcclosure(function(...)
    local args = { ... }
    local method = getnamecallmethod()
    local self = args[1]

    local arg = args[2]

    if method == "FireServer" and arg and find(lower(arg),"checker") or table.find(blacklisted, arg) then
        intercepted(arg)
        return
    end

    return old_namecall(...)
end)

old_namecall = hookmetamethod(game, "__namecall", new_namecall)
repeat task.wait() until openac_func
--------------------------------------------------------------------------------------------------------

local Options = {
    ChangeAnimations = true,
    ChangeEmotes = true,
    Buying = false,

    CSync = false,
    CSyncPosition = CFrame.new(0,0,0),
    CSyncPart = nil,

    TeleportMode = "CSync",
    KillMode = "Orbit",
    Stomp = false,
    Bring = false,
    Killing = false,

    CustomX = 0,
    CustomY = -30,
    CustomZ = 0,

    OrbitHeight = 5,
    OrbitRadius = 10,
    OrbitSpeed = 2,

    Notifactions = true,
    OldPosition = CFrame.new(0,0,0),

    Grabs = {},
    Grab = false,
    GrabbedChar = nil,
    LastGrabbed = nil,
    Effects = true,
}

local kill_button;

local function check_folder(folder_name)
    if not isfolder(folder_name) then
        makefolder(folder_name)
    end
end
check_folder("Legion")
check_folder("Legion/Assets")


local asset_url = "https://raw.githubusercontent.com/penguin-cmyk/legion/refs/heads/main/Assets"
local assets = { "user-cog.png",
                 "square-mouse-pointer.png",
                 "help.png",
                 "dice.png",
                 "maximize.png",
                 "package-check(1).png",
                 "activity.png",
                 "pipette.png",
                 "store.png",
                
                 "gamesense.mp3",
                 "bat_hit.mp3",
                 "tf2.mp3",
                 "minecraft.mp3",
                 "yes-king-you-hitting-that-spot.mp3",

                 "mappp.rbxm",
                 "dust1.rbxm",
                 "dragrace.rbxm"
               }

for _, asset in assets do
    if not isfile(`Legion/Assets/{asset}`) then
        writefile(`Legion/Assets/{asset}`, game:HttpGet(`{asset_url}/{asset}`))
    end
end

local function getobject(path)
    return game:GetObjects(getcustomasset(`Legion/Assets/{path}.rbxm`))[1]
end 

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/penguin-cmyk/legion/refs/heads/main/utils/uiiiiiiii.luau"))()
local StompModule, DhLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/penguin-cmyk/legion/refs/heads/main/utils/stomp_effects.luau"))()
local Flags;
local Connections: { [string]: RBXScriptConnection } = {}


-- Autoarmor doesn't work yet I have to fix ts
local Armors = {
    ["High"] = "[High-Medium Armor] - $2513",
    ["Medium"] = "[Medium Armor] - $1093",
    ["Fire"] = "[Fire Armor] - $2623"
}

local Crossroads = getobject("mappp")
local Dragrace = getobject("dragrace")
local Dust1 = getobject("dust1")

Dragrace:FindFirstChild("SpawnPart").Anchored = true 
Dragrace:FindFirstChild("SpawnPart").Transparency = 1 
Dragrace:FindFirstChild("LavaParts"):Destroy()
Dragrace.MapDetails.StartLights:Destroy()

local RecentlyShot: boolean = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Camera = Workspace.CurrentCamera
local Ignored = Workspace:FindFirstChild("Ignored")
local Bullets = Ignored:FindFirstChild("Siren").Radius

local shop_children =  Ignored:FindFirstChild("Shop"):GetChildren() -- only need to ts once since the shop doesn't really change which also optimizes this script
local MainEvent = ReplicatedStorage.MainEvent
local SayMessageRequest = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local LocalPlayer = Players.LocalPlayer
local Heartbeat = RunService.Heartbeat

local random = math.random
local find = table.find

local Flags = {}

modules.new_connection = function(connection_name: string, connection: RBXScriptConnection?)
    assert(typeof(connection)=="RBXScriptConnection","Connection must be RBXScriptConnection")

    if Connections[connection_name] then
        Connections[connection_name]:Disconnect()
    end

    Connections[connection_name] = connection
    return connection
end

modules.remove_connection = function(connection_name: string)
    if Connections[connection_name] then
        Connections[connection_name]:Disconnect()
        Connections[connection_name] = nil
    end
end


modules.grab = function(character: Instance)
    if character == nil then return end

    if not Options.Grab then
        modules.remove_connection("grab_movement")
        return
    end

    Options.GrabbedChar = character
    Options.LastGrabbed = character

    local body_properties = modules.find(character, { "BodyGyro", "BodyVelocity", "BodyPosition" })
    for i = 1, #body_properties do
        body_properties[i]:Destroy()
    end

    modules.stop_animation(LocalPlayer.Character, 11075367458)
    repeat task.wait() until character:FindFirstChild("GRABBING_CONSTRAINT")

    local grabbing_constraint = character:FindFirstChild("GRABBING_CONSTRAINT")
    local target_uppertorso = character:FindFirstChild("UpperTorso")
    local local_character = LocalPlayer.Character

    if not grabbing_constraint:FindFirstChild("H") or not local_character then return end

    local body_position =  modules.create("BodyPosition",{
        D = 200,
        MaxForce = Vector3.new(10000, 10000, 10000),
        Position = local_character:FindFirstChild("RightHand").Position - Vector3.new(0,1,0),
        Parent = target_uppertorso
    })

    local body_gyro = modules.create("BodyGyro",{
        D = 100,
        MaxTorque = Vector3.new(10000, 10000, 10000),
        CFrame = CFrame.new(
            target_uppertorso.Position,
            local_character:FindFirstChild("HumanoidRootPart").Position
        ),
        Parent = target_uppertorso
    })

    grabbing_constraint.H.Length = 9e9
    modules.play_animation(local_character, 3135389157, 0, .1)
    modules.new_connection("grab_movement", Heartbeat:Connect(function()
        local local_character = LocalPlayer.Character
        local target_uppertorso = character:FindFirstChild("UpperTorso")

        if not Options.Grab then
            modules.stop_animation(local_character, 3135389157)
            modules.remove_connection("grab_movement")
            return
        end

        if Options.GrabbedChar ~= nil
        and local_character ~= nil
        and local_character:FindFirstChild("BodyEffects")
        and local_character:FindFirstChild("BodyEffects").Grabbed.Value ~= nil
        and Options.Grab and target_uppertorso:FindFirstChild("BodyPosition") then
            local position = local_character:FindFirstChild("RightHand").Position - Vector3.new(0, 1, 0)
            local orientation = CFrame.new(target_uppertorso.Position, local_character:FindFirstChild("HumanoidRootPart").Position)

            body_gyro.CFrame = orientation
            body_position.Position = position
        elseif local_character ~= nil
        and local_character:FindFirstChild("BodyEffects")
        and local_character:FindFirstChild("BodyEffects").Grabbed.Value == nil then
          modules.stop_animation(local_character, 3135389157)
          Options.GrabbedChar = nil
        end
    end))
end

modules.grab_tool = function(options: { [any]: any })

    local Backpack: Backpack = LocalPlayer.Backpack

    local tool_callback: (...any) -> ...any = options.Callback
    local name: string = options.name or options.Name
    local description: string = options.Description
    local stop_animation: boolean = options.StopAnimations

    Options.Grabs[name] = {}

    local grab_tool: Tool = modules.create("Tool", {
        Name = name,
        RequiresHandle = false,
        ToolTip = description
    })

    modules.new_connection(name.."_tool", grab_tool.Activated:Connect(function()
        Options.Grabs[name]["State"] = true

        if not Options.Grab or not Options.GrabbedChar then
            return
        end

        Options.Grab = false

        local success,err = pcall(function()
            local character: Model = LocalPlayer.character
            local grabbed: Model =  character.BodyEffects:FindFirstChild("Grabbed").Value

            if character == nil then
                error("Localplayers character doesn't exist wth???")
            end

            if grabbed == nil then
                return
            end

            if stopanimation then
                DhLibrary:StopAnimation(character,3135389157)
                DhLibrary:StopAnimation(character,11075367458)
            end

            tool_Callback(grabbed,character)

            grab_tool.Parent = LocalPlayer.Backpack
            grab_tool.Parent = LocalPlayer.character
        end)

        if not success then
            print(err)
        end
    end))
end


modules.get_emotes = function(humanoid: Humanoid)
    local Description: HumanoidDescription = humanoid:FindFirstChild("HumanoidDescription")
    local LocalDescription: HumanoidDescription = LocalPlayer.Character.Humanoid:FindFirstChild("HumanoidDescription")

    if not Description or not LocalDescription then return warn("Humanoid Descriptions not found") end

    local Emotes: { [string]: number } = {}
    local Names:  { [number]: string } = {}

    for name, emote in pairs(Description:GetEmotes()) do
        if #emote == 0 then continue end

        Emotes[name] = emote
        table.insert(Names,name)
    end

    LocalDescription:SetEmotes(Emotes)
    LocalDescription:SetEquippedEmotes(Names)
end

modules.disguise = function(userid: number)
    local RequestedCharacter: Model = Players:CreateHumanoidModelFromUserId(userid)
    local Character: Model = LocalPlayer.Character

    if Options.ChangeEmotes then
        modules.get_emotes(RequestedCharacter:FindFirstChild("Humanoid"))
    end

    local ClonedAnimations: { [string]: Animation } = {}

    local RequestedDescendants: { [number]: Instance } = RequestedCharacter:GetDescendants()
    local LocalDescendants: { [number]: Instance } = Character:GetDescendants()


    for i = 1, #RequestedDescendants do
        local item = RequestedDescendants[i]
        if item.ClassName ~= "Animation" then continue end

        ClonedAnimations[item.Name] = item.AnimationId
    end

    for i = 1, #LocalDescendants do
        local object = LocalDescendants[i]
        if object:IsA("BodyColors") or object:IsA("Accessory") or object:IsA("CharacterMesh") or object:IsA("Shirt") or object:IsA("Pants") or object:IsA("Decal") then
            object:Destroy()
        end

        if Options.ChangeAnimations and object:IsA("Animation") and ClonedAnimations[object.Name] then
            object.AnimationId = ClonedAnimations[object.Name]
        end
    end

    local Appearance: Model = Players:GetCharacterAppearanceAsync(userid)
    local AppearanceChildren: { [number]: Instance } = Appearance:GetChildren()

    print(Appearance.Name)

    for i = 1, #AppearanceChildren do
        local asset = AppearanceChildren[i]

        if asset:IsA("Shirt") or asset:IsA("BodyColors") or asset:IsA("Pants") then
            asset.Parent = Character
        elseif asset:IsA("Accessory") then
            Character.Humanoid:AddAccessory(asset)
        elseif asset.Name:match("face") then
            asset.Parent = Character.Head
        elseif asset:FindFirstChildOfClass("CharacterMesh") then
            asset:FindFirstChildOfClass("CharacterMesh").Parent = Character
        end
    end

    if RequestedCharacter.Head:IsA("MeshPart") and RequestedCharacter.Head.MeshId == "rbxassetid://6686307858" then
        Character.Head.Transparency = 1
        if Character.Head:FindFirstChild("face") then
            Character.Head.face:Destroy()
        end
    end

    if Options.ChangeAnimations then
        Character.Animate.idle.Animation1.AnimationId = RequestedCharacter.Animate.idle.Animation1.AnimationId
        Character.Animate.idle.Animation2.AnimationId = RequestedCharacter.Animate.idle.Animation2.AnimationId

        Character.Animate.Disabled = true
        Character.Animate.Disabled = false
    end

    Character.Parent = nil
    Character.Parent = Workspace:FindFirstChild("Players")

    local ForceField = Character:FindFirstChildOfClass("ForceField")
    if ForceField then
        ForceField:Destroy()
    end

    RequestedCharacter:Destroy()
end

modules.change = function(parent: Instance, type: string, property: string, value: any)
    local Descendants = parent:GetDescendants()
    for i = 1, #Descendants do
        local object = Descendants[i]
        if object.ClassName ~= type then continue end

        object[property] = value
    end
end

modules.get_player = function(name: string)
    local players = Players:GetPlayers()
    local found_player;

    for i = 1, #players do
        local player = players[i]
        if player == LocalPlayer then continue end
        local found = string.find(player.Name:lower(),name:lower()) or string.find(player.DisplayName:lower(),name:lower())
        if not found then continue end

        found_player = player.Name
        break
    end

    return found_player
end

modules.create = function(type: string, properties: { [string]: any })
    local object = Instance.new(type)
    for property, value in pairs(properties) do
        object[property] = value
    end
    return object
end

modules.clone_char = function(character: Model)
    local new_character: Model = Instance.new("Model")
    local char_children: { [number]: Instance } = character:GetChildren()

    for i = 1, #char_children do
        local object = char_children[i]:Clone()
        object.Parent = new_character
    end

    local new_descendants: { [number]: Instance } = new_character:GetDescendants()
    for i = 1, #new_descendants do
        local object = new_descendants[i]
        if object.ClassName ~= "Weld" and object.ClassName ~= "WeldConstraint" then continue end

        object:Destroy()
    end

    new_character.Parent = Workspace
    return new_character
end

modules.find = function(parent: Instance, options: { [any]: any })
    local descendants: { [number]: Instance } = parent:GetDescendants()
    local objects: { [number]: Instance } = {}

    for i = 1, #descendants do
        local object = descendants[i]

        local found = find(options,object.Name) or find(options,object.ClassName)
        if not found then continue end

        if find(objects,found) then continue end

        table.insert(objects,found)
    end

    return #objects > 0 and objects or {}
end


modules.closest_player = function(distance: number, start_position: Vector3?, check_ko: boolean?)
    local found_player;
    local players: { [number]: Player } = Players:GetPlayers()

    for i = 1, #players do
        local player: Player = players[i]
        if player == LocalPlayer or not player.Character then continue end

        local Hrp: MeshPart = player.Character:FindFirstChild("HumanoidRootPart")

        if Hrp or not check_ko and modules.is_ko(player.Character) then continue end

        -- start_position -> beam, local humanoidrootpart, etc...
        local Magnitude = (Hrp.Position - start_position).magnitude
        if Magnitude < distance then
            found_player  = player.Character
            break
        end

    end

    return found_player
end

modules.play_sound = function(sound: string, volume: number)
    local Sound = Instance.new("Sound",Workspace)
    Sound.SoundId = sound
    Sound.Volume = volume
    Sound.PlayOnRemove = true

    Sound:Destroy()
end

modules.get_gun = function(backpack: boolean?)
    local local_children = backpack and LocalPlayer.Backpack:GetChildren() or LocalPlayer.Character:GetChildren()
    local found_tool;

    for i = 1, #local_children do
        local tool = local_children[i]
        if not tool:FindFirstChild("GunScript") then continue end

        found_tool = tool
        break
    end

    return found_tool
end

modules.is_ko = function(target: Model)
    if not target or not target:FindFirstChild("BodyEffects") or not target.BodyEffects:FindFirstChild("K.O") then return end

    return target:FindFirstChild("BodyEffects")["K.O"].Value or target:FindFirstChild("GRABBING_CONSTRAINT")
end

modules.is_stomped = function(target: Model)
    if not target or not target:FindFirstChild("BodyEffects") or not target.BodyEffects:FindFirstChild("SDeath") then return end

    return target:FindFirstChild("BodyEffects")["SDeath"].Value
end

modules.get_target = function(target: String)
    return Players:FindFirstChild(target) and Players[target].Character
end

modules.shoot = function(target: Model, gun: Tool)
    if not target or not gun then return end
    MainEvent:FireServer(
        "ShootGun",
        gun.Handle,
        target.HumanoidRootPart.Position,
        target.HumanoidRootPart.Position,
        target.Head,
        Vector3.new(0,0,-1)
    )
end

modules.car_fly = function()
    local car = DhLibrary:GetCar()

    if Options.car_fly then
        Options.car_fly = false
        return
    end

    if not car then return end

    Options.car_fly = true

    local BodyPosition = modules.create("BodyPosition",{
        Parent = car,
        MaxForce = Vector3.new(9e9, 9e9, 9e9),
        Position = car.Position,
    })
    local BodyGyro = modules.create("BodyGyro",{
        Parent = car,
        MaxTorque = Vector3.new(9e9, 9e9, 9e9),
        CFrame = car.CFrame,
    })

    modules.new_connection("vehicle_fly", Heartbeat:Connect(function()
        if not Options.car_fly then
            modules.remove_connection("vehicle_fly")
            BodyPosition:Destroy()
            BodyGyro:Destroy()
            return
        end

        local speed = Flags["car_speed"]
        local move_direction = Vector3.new(
            UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0),
            UserInputService:IsKeyDown(Enum.KeyCode.Space) and 0.2,
            UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )

        BodyGyro.CFrame = CFrame.new(car.Position) * Camera.CFrame.Rotation
        BodyPosition.Position = BodyPosition.Position + (BodyGyro.CFrame.LookVector * move_direction.Z + BodyGyro.CFrame.RightVector * move_direction.X + Vector3.new(0, move_direction.Y, 0)) * speed
    end))
end

modules.fly = function()
    if Options.flying then
        Options.flying = false
        return
    end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp, hum = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    Options.flying = true

    modules.new_connection("fly", Heartbeat:Connect(function()
        if not Options.flying then
            modules.remove_connection("fly")
            hum.PlatformStand = false
            return
        end

        hum.PlatformStand = true

        local speed = Flags["fly_speed"]
        local move_direction = Vector3.new(
            UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0),
            UserInputService:IsKeyDown(Enum.KeyCode.Space) and 0.2,
            UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0)
        )



        hrp.Velocity = Vector3.zero
        hrp.CFrame = CFrame.new(hrp.Position) *
            Camera.CFrame.Rotation *
            CFrame.new(
                move_direction.X * speed,
                move_direction.Y * speed,
                move_direction.Z * speed
            )
    end))
end

modules.remove_patters = function(name: string)
    local first = name:split("[")
    local second = first[2]:split("]")

    return second[1]
end

modules.get_ammo = function(name: string)
    local found_ammo;
    local name = modules.remove_patters(name)
    for i = 1, #shop_children do
        local item = shop_children[i]
        local ammo_count, price = item.Name:match(`(%d+) %[{name} Ammo%] %- %$(%d+)`)

        if not ammo_count or not price then continue end

        found_ammo = item
        break
    end

    return found_ammo
end

modules.set_visible = function(settings, state)
    for i = 1, #settings do
        local toggle = settings[i]
        toggle:SetVisible(state)
    end
end

modules.get_money = function()
    return LocalPlayer.PlayerGui.MainScreenGui.MoneyText.Text
end

modules.reload = function(tool: Tool)
    MainEvent:FireServer("Reload",tool)
end

modules.disable_grip_check = function(tool)
    local connections = getconnections(tool:GetPropertyChangedSignal("Grip"))
    for i = 1, #connections do
        local connection = connections[i]
        connection:Disable()
    end
end

modules.gun_cd = function(tool: Tool, value: number)
    if not tool then return end

    local cooldown = tool:FindFirstChild("ShootingCooldown") or tool:FindFirstChild("ToleranceCooldown")
    if not cooldown then return end

    local connections = getconnections(tool.Activated)
    if #connections == 0 then return end

    local gun_function = connections[1].Function
    local gun_upvalues = debug.getupvalues(gun_function)

    for i = 1, #gun_upvalues do
        local up_value = gun_upvalues[i]
        if up_value ~= cooldown.Value then continue end

        debug.setupvalue(gun_function, i, value)
    end

    return cooldown.Value
end

local old_func;

modules.no_knockback = function(tool: Tool, state: boolean?)
    if tool.Name ~= "[Flintlock]" then return end
    local connections = getconnections(tool.Activated)

    print(tool)

    for i = 1, #connections do
        local connection = connections[i]
        local upvalues = getupvalues(connection.Function)

        for i = 1, #upvalues do
            local func = upvalues[i]
            if typeof(func) ~= "function" then continue end
            -- only func in here is the knockback func
            if not old_func then old_func = clonefunction(func) end
            hookfunction(func, state and function() end or old_func)
        end
    end
end

modules.get_guns = function()
    task.wait(1)
    local local_children = LocalPlayer.Backpack:GetChildren()
    local found_tools = {};

    for i = 1, #local_children do
        local tool = local_children[i]
        if not tool:FindFirstChild("GunScript") then continue end

        table.insert(found_tools, tool.Name)
    end

    return found_tools
end


modules.get_asset = function(url: string)
    local split_name = url:split("/")
    if #split_name < 1 then return end
    local file_name = `{split_name[#split_name-1]}.{split_name[#split_name]}`
    if isfile(file_name) then return getcustomasset(file_name) end

    writefile(file_name,game:HttpGet(url))
    return getcustomasset(file_name)
end

modules.csync = function(custom)
    if Options.CSync then
        if not Options.Buying then 
            library:Notification("Disabling csync",4)
        end 
        modules.remove_connection("CSync")
        Options.CSync = false
        return
    end
    if not Options.Buying then 
        library:Notification(custom ~= nil and custom or "Enabling csync",4)
    end 

    Options.CSync = true


    Options.CSyncPart = Options.CSyncPart or Instance.new("Part",Workspace)
    Options.CSyncPart.CanCollide = false
    Options.CSyncPart.Anchored = true
    Options.CSyncPart.Transparency = 1

    modules.new_connection("CSync", Heartbeat:Connect(function()
        if not Options.CSync then
            if not Options.Buying then 
                library:Notification("Disabling csync",4)
            end 

            modules.remove_connection("CSync")
            return
        end

        local character: Model = LocalPlayer.Character
        if not character then return end

        local humanoidrootpart: MeshPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidrootpart then return end

        if not character:FindFirstChild("Humanoid") then return end

        local return_cframe: CFrame = humanoidrootpart.CFrame
        Options.return_cframe = return_cframe
        local is_viewing = Flags["view"]
        if not is_viewing then
            Camera.CameraSubject = Options.CSyncPart
        end
        humanoidrootpart.CFrame = Options.CSyncPosition
        Options.CSyncPart.Position = return_cframe.Position + Vector3.new(0, 2, 0)

        RunService.RenderStepped:Wait()

        humanoidrootpart.CFrame = return_cframe
        if not is_viewing then
            Camera.CameraSubject = character.Humanoid
        end
    end))
end

modules.buy = function(item_name: string)
    if Options.Buying then return end


    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")

    local index = find(shop_children,item_name)
    local item =  shop_children[index] or typeof(item_name) == "Instance" and item_name

    print(index)

    if not item then
        if Options.Killing then
            modules.disable_kill("Item (ammo) was not found in shop")
        end
        return
    end

    local starting_option = Options.CSync
    local starting_money  = modules.get_money()


    if tool then
        tool.Parent = LocalPlayer.Backpack
    end

    Options.Buying = true

    if not starting_option then
        modules.csync()
    end

    local click_detector = item:FindFirstChildOfClass("ClickDetector")
    if not click_detector then
        warn("Clickdetector not found")
        Options.Buying = false
        return "Clickdetector not found"
    end

    task.delay(3,function()
        if Options.Buying then
            if not starting_option then Options.CSync = false end
            Options.Buying = false

            library:Notification("Time out reached",4)
            return "Time out reached"
        end
    end)

    local head = item:FindFirstChildOfClass("Part") or item:FindFirstChildOfClass("BasePart") or item:FindFirstChild("Head")
    if not head then
        head = { CFrame = item:GetPivot() }
        return "Head not found"
    end

    library:Notification(`Purchasing: {item_name}`,2)

    Options.CSyncPosition = head.CFrame - Vector3.new(0,7,0)

    repeat task.wait()
        fireclickdetector(click_detector)
    until modules.get_money() ~= starting_money or not  Options.Buying

    if tool then
        tool.Parent = LocalPlayer.Character
    end
    Options.Buying = false

    if not starting_option then
        Options.CSync = false -- disable csync if the player didn't use it before!
    end

    modules.reload(tool)

end

modules.teleport = function(pos: CFrame, csync: boolean?)
    if csync then
        Options.CSyncPosition = pos
    else
        LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    end
end

modules.view = function(target: Instance)
    if target == nil then return end

    Camera.CameraSubject = target:FindFirstChild("Humanoid")
end

modules.check_ammo = function()
    local gun = modules.get_gun()
    if not gun then return end

    local ammo_frame = LocalPlayer.PlayerGui.MainScreenGui:FindFirstChild("AmmoFrame")
    if not ammo_frame then return end

    local ammo_text = ammo_frame:FindFirstChild("AmmoText")
    if not ammo_text then return end

    if gun:FindFirstChild("Ammo") then
        return gun.Ammo.Value, ammo_text.ContentText, gun
    end
end

-- Kill mode: Csync, Normal
-- Kill target mode: Orbit, Random, Custom

modules.get_dead_players = function()
    local players = Players:GetPlayers()
    local dead_players = {}
    for i = 1, #players do
        local player = players[i]
        if player == LocalPlayer then continue end
        if not modules.is_ko(player.Character) or modules.is_stomped(player.Character) then continue end
        if player.Character:FindFirstChild("GRABBING_CONSTRAINT") then continue end 

        table.insert(dead_players,player.Character)
    end
    return dead_players;
end

local is_set_call = false


modules.kill = function(target_name)
    if Options.Killing then
        modules.remove_connection("kill")
        is_set_call = true
        kill_button:SetState(false)
        Options.Killing = false
        task.wait(.1)
        is_set_call = false
        return
    end

    if target_name == nil then return end

    local StartCsync = Options.CSync
    local csync_teleport = Options.TeleportMode == "CSync"

    if csync_teleport and not StartCsync then
        modules.csync()
    end

    local target = modules.get_target(target_name)
    if not target then
        local is_set_call = true
        if Options.Notifactions then
            library:Notification("Target doesn't exist",4)
        end
        kill_button:SetState(false)
        warn("Target doesn't exist")
        task.wait(.1)
        is_set_call = false
        return
     end

    modules.disable_kill = function(reason)
        Options.CSync = StartCsync
        warn(reason)
        Options.Killing = false

        is_set_call = true
        kill_button:SetState(false)

        if Options.Notifactions then
            library:Notification(reason,4)
        end

        modules.remove_connection("kill")

        if not StartCsync then
            modules.teleport(Options.OldPosition,false)
        end

        task.wait(.1)
        is_set_call = false
        return reason
    end

    Options.Killing = true

    Options.OldPosition = LocalPlayer.Character.HumanoidRootPart.CFrame

    local current_time = 0;
    local up_position = CFrame.new(0, 20000000000000, 0)
    modules.new_connection("kill",Heartbeat:Connect(function(time)
        target = modules.get_target(target_name)
        current_time = current_time + time
        if not Options.Killing then
            Options.CSync = StartCsync
            modules.remove_connection("kill")
            return
        end


        if Options.Gun and not Options.Buying then
            local gun = typeof(Options.Gun) == "Instance" and Options.Gun.Name or Options.Gun
            Options.Gun = LocalPlayer.Backpack:FindFirstChild(gun) or LocalPlayer.Character:FindFirstChild(gun)
            Options.Gun.Parent = LocalPlayer.Character
        end

        if Options.Buying then return end
        local is_ko = modules.is_ko(LocalPlayer.Character)
        local auto_disable = Flags["auto_disable"]

        if is_ko and auto_disable then
            modules.disable_kill("You are dead, disabling kill")
        elseif is_ko
            and not auto_disable
            and LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head:Destroy()
            return
        end

        local is_ko = modules.is_ko(target)
        local is_stomped = modules.is_stomped(target)

        if is_stomped and auto_disable then
            modules.disable_kill("Player stomped disabling kill")
            return
        elseif is_stomped and not auto_disable then
            modules.teleport(up_position, csync_teleport)
            return
        end

        if target == nil then
            modules.disable_kill("Player left / doesn't exist")
            return
        end

        if not target:FindFirstChild("FULLY_LOADED_CHAR")  or target:FindFirstChildOfClass("ForceField") then
            modules.teleport(up_position, csync_teleport)
            return
        end

        local stomp = Options.Stomp
        local bring = Options.Bring
        if is_ko and not Options.Buying then
            local upper_torso = target:FindFirstChild("UpperTorso")
            -- maybe remove ts for auto kill

            if not upper_torso and auto_disable then
                modules.disable_kill("UpperTorso not found in the target")
                return
            elseif not upper_torso and not auto_disable then
                modules.teleport(up_position, csync_teleport)
                return
            end

            if
            not stomp
            and not bring
            and auto_disable then
                modules.disable_kill("Player is dead disabling kill")
                return
            elseif
            not stomp
            and not bring
            and not auto_disable then
                modules.teleport(up_position, csync_teleport)
                return
            end

            if stomp and not bring then
                modules.teleport(CFrame.new(upper_torso.CFrame.X, upper_torso.CFrame.Y+2, upper_torso.CFrame.Z), csync_teleport)
                MainEvent:FireServer("Stomp")
                return
            end

            if bring and not stomp then
                local Grabbed = LocalPlayer.Character.BodyEffects:FindFirstChild("Grabbed") and LocalPlayer.Character.BodyEffects.Grabbed.Value
                if not Grabbed then
                    modules.teleport(CFrame.new(upper_torso.CFrame.X, upper_torso.CFrame.Y+2, upper_torso.CFrame.Z), csync_teleport)
                    MainEvent:FireServer("Grabbing",false)
                elseif Grabbed ~= nil and target:FindFirstChild("GRABBING_CONSTRAINT") then
                    modules.disable_kill("Player is grabbed disabling kill")
                    return
                end
            end

            if bring and stomp and auto_disable then
                modules.disable_kill("Bring & Stomp Enabled please only choose one of the options")
                return
            elseif bring and stomp and not auto_disable then
                modules.teleport(up_position, csync_teleport)
                return
            end

            return
        end

        if is_ko or is_stomped and not auto_disable then
            return
        end

        local ammo, ammo_text, gun = modules.check_ammo()

        if tonumber(ammo_text) == 0 and not Options.Buying then
            local ammo_item = modules.get_ammo(gun.Name)
            modules.buy((ammo_item))
            return
        elseif tonumber(ammo_text) ~= 0 and tonumber(ammo) == 0 then
            modules.reload(gun)
        end

        if not gun and not Options.Buying and auto_disable then
            modules.disable_kill("gun not found")
            return
        elseif not gun and not Options.Buying and not auto_disable then

        end
        local mode = Options.KillMode
        local humanoid_rootpart = target:FindFirstChild("HumanoidRootPart")
        local expected = humanoid_rootpart.CFrame -- fail safe if the user provides a invalid Mode ig?

        if mode == "Custom" then
            expected = humanoid_rootpart.CFrame + Vector3.new(Options.CustomX, Options.CustomY, Options.CustomZ)
        elseif mode == "Random" then
            expected = humanoid_rootpart.CFrame + Vector3.new(random(1,100), random(1,50) > 20 and -random(10,100) or random(10,100), random(1,100))
        elseif mode == "Orbit" then
            expected = humanoid_rootpart.CFrame * CFrame.new(math.cos(current_time * Options.OrbitSpeed) * Options.OrbitRadius, Options.OrbitHeight, math.sin(current_time * Options.OrbitSpeed) * Options.OrbitRadius)
        elseif mode == "Void" then
            expected = humanoid_rootpart.CFrame -- not impleted yet
        end

        if LocalPlayer.Character and  LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not Options.Buying then
            modules.teleport(expected, csync_teleport)
            modules.shoot(target,gun)
        end

    end))
end

modules.stomp_toggle = function(state) StompModule:Toggle(state) end  -- modules.stomp_toggle
modules.add_stomp_effect = function(options) StompModule:AddStompEffect(options) end
modules.current_effects = StompModule.CurrentEffects
modules.stomp_effect = StompModule.StompEffect
modules.start_shake = StompModule.StartShake

modules.stop_animation = function(character: Instance, id: number) DhLibrary:StopAnimation(character, id) end
modules.is_anim_playing = function(character: Instance, id: number) DhLibrary:IsAnimPlaying(character, id) end
modules.play_animation = function(character: Instance, id: number, speed: number, time: number, smoothing: number) DhLibrary:PlayAnimation(character, id, speed, time, smoothing) end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




Flags = library.Flags
library.ForceCheckbox = false

local window = library:New({
    Size = UDim2.new(0, 555, 0, 450)
})

local seperator = window:Seperator({Name = "Player"});

local movement_tab = window:Page({ Name = "Movement", Icon = getcustomasset("Legion/Assets/activity.png") })
local player_tab = window:Page({ Name = "Player", Icon = getcustomasset("Legion/Assets/user-cog.png") })
local shop_tab = window:Page({ Name = "Shop", Icon = getcustomasset("Legion/Assets/store.png") })

local movement = movement_tab:Section({ Name = "Movement", Side = "Left", Size = 270 })
local player = player_tab:Section({ Name = "Player", Side = "Left", Size = 250 })

local seperator = window:Seperator({Name = "Combat"});
local target_tab = window:Page({ Name = "Target", Icon = getcustomasset("Legion/Assets/square-mouse-pointer.png") })
local misc_combat = window:Page({ Name = "Others", Icon = getcustomasset("Legion/Assets/package-check(1).png") })

local main_target = target_tab:Section({ Name = "Target", Side = "Left", Size = 250 })
local other_target = misc_combat:Section({ Name = "Misc", Side = "Left", Size = 250 })

local seperator = window:Seperator({Name = "Misc"});
local visuals_tab = window:Page({ Name = "Visuals", Icon = getcustomasset("Legion/Assets/pipette.png") })
local misc_tab = window:Page({ Name = "Misc", Icon = getcustomasset("Legion/Assets/maximize.png") })

local visuals_section = visuals_tab:Section( { Name = "Misc", Side = "Left", Size = 250 })

local misc_section = misc_tab:Section( { Name = "Misc", Side = "Left", Size = 250 })
local useful_tool = misc_tab:Section( { Name = "Useful tools", Side = "Right", Size = 250 })


local crossroads_loaded = false
local dragrace_loaded = false
local dust_loaded = false


do 
    -- // visuals 
    visuals_section:Toggle({
        Name = "Anti pepperspray",
        Flag = "anti_pepperspray",
        Default = false,
    })

    visuals_section:Toggle({
        Name = "Anti flashbang",
        Flag = "anti_flashbang",
        Default = false,
    })
end 

do
    -- // normal misc section

    misc_section:Button({
        Name = "Crossroads map",
        Callback = function()
            if crossroads_loaded then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 20000, -2000)
                return
            end
            crossroads_loaded = true
            Crossroads.Parent = workspace
            Crossroads:PivotTo(CFrame.new(2000, 20000, -2000))
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 20000, -2000)

        end
    })

    misc_section:Button({
        Name = "Dust map",
        Callback = function()
            if dust_loaded then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1950, 20000, -2000)
                return
            end
            dust_loaded = true
            Dust1.Parent = workspace
            Dust1:PivotTo(CFrame.new(-2000, 20000, -2000))
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1950, 20000, -2000)

        end
    })

    misc_section:Button({
        Name = "Dragrace map",
        Callback = function()
            if dragrace_loaded then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Dragrace:FindFirstChild("SpawnPart").CFrame + Vector3.new(20, 20, 0) 
                return
            end
            dragrace_loaded = true
            Dragrace.Parent = workspace
            Dragrace:PivotTo(CFrame.new(-2000, 30000, -2000))
            LocalPlayer.Character.HumanoidRootPart.CFrame = Dragrace:FindFirstChild("SpawnPart").CFrame + Vector3.new(20, 20, 0)

        end
    })

    -- // useful tools
    useful_tool:Button({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
        end
    })

    useful_tool:Button({
        Name = "Dex Explorer",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end
    })

    useful_tool:Button({
        Name = "Simple Spy",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
        end
    })

    useful_tool:Button({
        Name = "Hydroxide",
        Callback = function()
            local owner = "Upbolt"
            local branch = "revision"

            local function webImport(file)
                return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
            end

            webImport("init")
            webImport("ui/main")
        end
    })

end


local gun_option
do
    main_target:Textbox({
        Name = "Target",
        Flag = "target_name",

        Placeholder = "",
        Default = "",

        EnterPressed = true,
        Callback = function(target)
            local target = modules.get_player(target)
            if not target then
                library:Notification("Target is not found", 2)
                return
            end

            local player = Players:FindFirstChild(target)
            library:Notification(`Target is now set to {target} ({player.DisplayName})`, 2)

            Options.Target = target
        end
    })

    kill_button = main_target:Toggle({
        Name = "Kill",
        Flag = "kill",
        Default = false,

        Callback = function(state)
            if is_set_call then return end
            if not state then
                modules.disable_kill("Disabled kill using toggle")
                return
            end

            if not Options.Gun then
                library:Notification("Please select a gun", 2)
                return
            end
            local gun = typeof(Options.Gun) == "Instance" and Options.Gun.Name or Options.Gun
            Options.Gun = LocalPlayer.Backpack:FindFirstChild(gun) or LocalPlayer.Character:FindFirstChild(gun)
            if state then
                Options.Gun.Parent = LocalPlayer.Character
            end

            local ammo_item = modules.get_ammo(gun)
            if not ammo_item then return end
            if not ammo_item:FindFirstChild("Head") then
                shop_children[ammo_item] = nil
            end

            modules.kill(Options.Target)
        end
    })

    main_target:Toggle({
        Name = "Auto disable",
        Flag = "auto_disable",
        Default = true,
    })

    main_target:Toggle({
        Name = "Bring",
        Flag = "bring",

        Default = false,
        Callback = function(state)
            Options.Bring = state
        end
    })

    main_target:Toggle({
        Name = "Stomp",
        Flag = "stomp",

        Default = false,
        Callback = function(state)
            Options.Stomp = state
        end
    })

    main_target:Toggle({
        Name = "View",
        Flag = "view",
        Default = false,
    })

    main_target:Button({
        Name = "Teleport",
        Callback = function()
            if not Options.Target then return end
            local target = modules.get_target(Options.Target)
            LocalPlayer.Character.HumanoidRootPart.CFrame =  target:FindFirstChild("HumanoidRootPart").CFrame
        end
    })
    do
        local kill_options = kill_button:OptionList({})
        kill_options:List({
            Name = "Kill mode",
            Flag = "kill_mode",

            Options = { "Orbit", "Random", "Custom" },
            Default = "Orbit",

            Callback = function(item)
                Options.KillMode = item
            end
        })

        kill_options:List({
            Name = "Teleport mode",
            Flag = "teleport_mode",

            Options = { "CSync", "Normal" },
            Default = "CSync",

            Callback = function(item)
                Options.TeleportMode = item
            end
        })

        gun_option = kill_options:List({
            Name = "Gun",
            Flag = "gun_option",

            Options = {},
            Default = "",

            Callback = function(item)
                Options.Gun = item
            end
        })

        kill_options:Slider({
            Name = "Orbit Radius",
            Flag = "orbit",

            Default = 5,
            Min = 0,
            Max = 30,

            Decimals = 1,

            Suffix = "", -- e.g %, h, ...
            Callback = function(value)
                Options.OrbitRadius = tonumber(value)
            end,
        })

        kill_options:Slider({
            Name = "Orbit Height",
            Flag = "orbit",

            Default = 5,
            Min = 0,
            Max = 30,

            Decimals = 1,

            Suffix = "", -- e.g %, h, ...
            Callback = function(value)
                Options.OrbitHeight = tonumber(value)
            end,
        })

        kill_options:Slider({
            Name = "Custom x",
            Flag = "x_k",

            Default = 0,
            Min = -150,
            Max = 150,

            Decimals = 1,

            Suffix = "", -- e.g %, h, ...
            Callback = function(value)
                Options.CustomX = tonumber(value)
            end,
        })

        kill_options:Slider({
            Name = "Custom y",
            Flag = "y_k",

            Default = 0,
            Min = -50,
            Max = 150,

            Decimals = 1,

            Suffix = "", -- e.g %, h, ...
            Callback = function(value)
                Options.CustomY = tonumber(value)
            end,
        })

        kill_options:Slider({
            Name = "Custom y",
            Flag = "z_k",

            Default = 0,
            Min = -150,
            Max = 150,

            Decimals = 1,

            Suffix = "", -- e.g %, h, ...
            Callback = function(value)
                Options.CustomZ = tonumber(value)
            end,
        })

        gun_option:Refresh(modules.get_guns())
    end

    -- OtherTarget

    local expander = other_target:Toggle({
        Name = "Hitbox expander",
        Flag = "hitbox_expander"
    })
    local killaura = other_target:Toggle({
        Name = "Kill aura",
        Flag = "killaura"
    })

    other_target:Toggle({
        Name = "Flint knockback",
        Flag = "noflint_knockback",
        Default = true 
    })

    other_target:Toggle({
        Name = "Velocity resolver",
        Flag = "velocity_resolver"
    })

    other_target:Toggle({
        Name = "Autofarm stomp",
        Flag = "auto_farm_stomps"
    })

    other_target:Toggle({
        Name = "Auto stomp",
        Flag = "autostomp_state"
    })

    other_target:Toggle({
        Name = "Rapidfire",
        Flag = "rapidfire_state"
    })

    do
        local expander_list = expander:OptionList({})
        local killaura_list = killaura:OptionList({})

        expander_list:Slider({
            Name = "Size",
            Flag = "hitbox_size",

            Default = 5,
            Max = 30,
            Min = 5,

            Decimals = 1
        })

        killaura_list:Slider({
            Name = "Range",
            Flag = "killaura_distance",
            Default = 50,
            Min = 10,
            Max = 200,

            Decimals = 1
        })
    end
end

do
    --// movement
    local cframe_speed = movement:Toggle({
        Name = "CFrame Speed",
        Flag = "cframe_speed",
        Default = false,
    })


    local player_fly = movement:Toggle({
        Name = "Player Fly",
        Flag = "fly",
        Default = false,
    })


    local car_fly = movement:Toggle({
        Name = "Car Fly",
        Flag = "car_fly",
        Default = false,
    })

    local csync = movement:Toggle({
        Name = "CSync",
        Flag = "csync",
        Default = false,
    })

    local car_modifier = movement:Toggle({
        Name = "Car modifier",
        Flag = "car_modifier",
        Default = false
    })

    movement:Toggle({
        Name = "No Jumpcooldown",
        Flag = "no_jump",
        Default = false,
    })

    movement:Toggle({
        Name = "No slow",
        Flag = "no_slow",
        Default = false,
    })

    movement:Toggle({
        Name = "No clip",
        Flag = "no_clip",
        Default = false
    })

    movement:Toggle({
        Name = "No sit",
        Flag = "no_sit",
        Default = false
    })

    --// player


    local auto_armor = player:Toggle({
        Name = "Auto armor",
        Flag = "auto_armor",
        Default = false,
    })

    local antistomp = player:Toggle({
        Name = "Antistomp",
        Flag = "antistomp_state",
        Default = false,
    })

    local disguise = player:Toggle({
        Name = "Disguise",
        Flag = "disguise",
        Default = false,
        Callback = function(state)
            modules.disguise(
                state and Flags["user_id"]
                or LocalPlayer.UserId
            )
        end
    })

    player:Toggle({
        Name = "Auto reload",
        Flag = "auto_reload",
        Default = false,
    })

    player:Toggle({
        Name = "Auto ammo",
        Flag = "auto_ammo",
        Default = false,
    })
    do
        local autoarmor_options = auto_armor:OptionList({})
        local playerfly_options = player_fly:OptionList({})
        local cframe_options = cframe_speed:OptionList({})

        local antistomp_option = antistomp:OptionList({})
        local carfly_options = car_fly:OptionList({})
        local csync_options = csync:OptionList({})

        local car_modifier_options = car_modifier:OptionList({})
        local disguise_options = disguise:OptionList({})
        -- // diguise
        disguise_options:Textbox({
            Name = "User id",
            Flag = "user_id",

            Placeholder = "User id",
            Default = "",

            EnterPressed = true,
        })

        disguise_options:Toggle({
            Name = "Change Animations",
            Default = true,
            Callback = function(state)
                Options.ChangeAnimations = state
            end
        })

        disguise_options:Toggle({
            Name = "Change Emotes",
            Default = true,
            Callback = function(state)
                Options.ChangeEmotes = state
            end
        })

        -- // car modifier
        car_modifier_options:Textbox({
            Name = "Jumppower",
            Flag = "car_jumppower",

            Placeholder = "Jumppower",
            Default = "",

            EnterPressed = false,
        })

        car_modifier_options:Textbox({
            Name = "Torque",
            Flag = "car_torque",

            Placeholder = "Torque",
            Default = "",

            EnterPressed = false,
        })

        car_modifier_options:Textbox({
            Name = "Speed",
            Flag = "car_speed_r",

            Placeholder = "Speed",
            Default = "",

            EnterPressed = false,
        })

        -- // auto armor
        autoarmor_options:List({
            Options = { "High", "Medium" },
            Default = "High",

            Name = "Armor",
            Flag = "select_armor"
        })


        autoarmor_options:Toggle({
            Default = false,

            Flag = "fire_armor",
            Name = "Fire armor"
        })

        -- // Player fly
        playerfly_options:Keybind({
            Name = "Toggle",
            Flag = "car_fly_key",
            Mode = "Toggle",
            Default = "",

            Callback = function()
                if not Flags["fly"] then return end

                modules.fly()
            end
        })

        playerfly_options:Slider({
            Name = "Speed",
            Flag = "fly_speed",
            Default = 1,
            Min = 0,
            Max = 20,

            Decimals = 1
        })

        -- // car fly
        carfly_options:Keybind({
            Name = "Toggle",
            Flag = "car_fly_key",
            Mode = "Toggle",
            Default = "",

            Callback = function()
                if not Flags["car_fly"] then return end

                modules.car_fly()
            end
        })

        carfly_options:Slider({
            Name = "Speed",
            Flag = "car_speed",
            Default = 1,
            Min = 0,
            Max = 20,

            Decimals = 1
        })

        -- // cframe speed
        cframe_options:Keybind({
            Name = "Toggle",
            Flag = "cframe_speed_key",
            Mode = "Toggle",
            Default = "",

            Callback = function()
                if not Flags["cframe_speed"] then return end

                if Options.cframe_speed == nil then Options.cframe_speed = false end
                Options.cframe_speed = not Options.cframe_speed
            end
        })

        cframe_options:Slider({
            Name = "Speed",
            Flag = "cframe_speeed",
            Default = 1,
            Min = 0,
            Max = 20,

            Decimals = 1
        })

        -- // antistomp
        antistomp_option:List({
            Options = { "Velocity", "Normal" },
            Default = "Velocity",

            Flag = "antistomp_mode",
            Name = "Mode",

            Callback = function(item)
                Options.antistomp_mode = item
            end
        })

        -- // csync
        csync_options:List({
            Options = { "Void", "Random", "Custom", "Angles" },
            Default = "Void",

            Flag = "csync_mode",
            Name = "Mode",
        })

        csync_options:Keybind({
            Name = "Toggle",
            Flag = "csync_key",
            Mode = "Toggle",
            Default = "",

            Callback = function()
                if Flags["csync"] then
                    modules.csync()
                end
            end
        })

        csync_options:Textbox({
            Name = "Custom X",
            Flag = "x",

            Placeholder = "500",
            Default = "",

            EnterPressed = false,
        })

        csync_options:Textbox({
            Name = "Custom Y",
            Flag = "y",

            Placeholder = "500",
            Default = "",

            EnterPressed = false,
        })

        csync_options:Textbox({
            Name = "Custom Z",
            Flag = "z",

            Placeholder = "500",
            Default = "",

            EnterPressed = false,
        })
    end
end

do
    local Velocity;


    -- Anti grenade (rpg)
    -- Auto buy

    -- Custom Animations ( Animation pack )

    -- Detect staff
    -- Redeem codes

    -- Player part modifier
    -- Stomp effects

    -- Visuals (esp, box, name , line, ...)

    

    modules.new_connection("backpack_added", LocalPlayer.Backpack.ChildAdded:Connect(function()
        local guns = modules.get_guns()
        gun_option:Refresh(guns)
        gun_option:SetOption(tostring(Options.Gun))
    end))

    modules.new_connection("backpack_removed", LocalPlayer.Backpack.ChildRemoved:Connect(function()
        local guns = modules.get_guns()
        gun_option:Refresh(guns)
        gun_option:SetOption(tostring(Options.Gun))
    end))


    modules.new_connection("character_added", LocalPlayer.CharacterAdded:Connect(function()
        local guns = modules.get_guns() -- to refresh guns
        gun_option:Refresh(guns)
        gun_option:SetOption("")

        if Flags["disguise"] then
            modules.disguise( Flags["user_id"])
        end

        modules.new_connection("child_added", LocalPlayer.Character.ChildAdded:Connect(function(object)
            local is_gun = object.ClassName == "Tool" and object:FindFirstChild("GunScript")
            local noflint_knockback = Flags["noflint_knockback"]

            if is_gun and Flags["rapidfire_state"] then
                modules.gun_cd(object, 0)
            end

            modules.no_knockback(object, noflint_knockback)
        end))
    end))


    modules.new_connection("child_added", LocalPlayer.Character.ChildAdded:Connect(function(object)
        local is_gun = object.ClassName == "Tool" and object:FindFirstChild("GunScript")
        if is_gun then
            local rapid_fire = Flags["rapidfire_state"]
            local noflint_knockback = Flags["noflint_knockback"]

            if rapid_fire then
                modules.gun_cd(object, 0)
            end

            modules.no_knockback(object, noflint_knockback)
        end
    end))

    modules.new_connection("main_heartbeat", Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local main_ui = LocalPlayer.PlayerGui:FindFirstChild("MainScreenGui")

        if not char or not main_ui then return end

        -- character releated
        local head = char:FindFirstChild("Head")
        local humanoid = char:FindFirstChild("Humanoid")
        local humanoid_rootpart = char:FindFirstChild("HumanoidRootPart")
        if not humanoid_rootpart then return end

        local body_effects = char:FindFirstChild("BodyEffects")
        if not body_effects then return end

        local fire_armor = body_effects:FindFirstChild("FireArmor")
        local armor = body_effects:FindFirstChild("Armor")
        local ko = body_effects:FindFirstChild("K.O")

        local character_children = char:GetChildren()

        -- States
        local buying = Options.Buying

        -- Flags
        local view = Flags["view"]
        local killing = Flags["kill"]
        local no_sit = Flags["no_sit"]
        local no_clip = Flags["no_clip"]
        local killaura = Flags["killaura"]
        local auto_ammo = Flags["auto_ammo"]
        local auto_reload = Flags["auto_reload"]
        local anti_flashbang = Flags["anti_flashbang"]
        local hitbox_expander = Flags["hitbox_expander"]
        local anti_pepperspray = Flags["anti_pepperspray"]
        local auto_farm_stomps = Flags["auto_farm_stomps"]
         

        -- select_armor
        -- fire_armor
        -- auto_armor

        local selected_armor = Flags["select_armor"]
        local use_firearmor = Flags["fire_armor"]
        local auto_armor = Flags["auto_armor"]

        if auto_armor and not Options.Buying then 
            if use_firearmor and tonumber(fire_armor.Value) == 0 then 
                modules.buy(Armors["Fire"])
            end 

            if tonumber(armor.Value) == 0 then 
                modules.buy(Armors[selected_armor])
            end 
        end 


        if anti_flashbang and main_ui:FindFirstChild("WhiteScreen") then
            main_ui.WhiteScreen:Destroy()
        end


        if anti_pepperspray and head:FindFirstChild("GOT_PEPPER_SPRAY") then
            head.GOT_PEPPER_SPRAY:Destroy()
        end

        local ammo, ammo_text, gun = modules.check_ammo()
        if auto_ammo and gun and tonumber(ammo_text) == 0 and tonumber(ammo) == 0 and not Options.Buying then
            local ammo = modules.get_ammo(gun.Name)
            if not ammo then return end

            modules.buy(ammo)
        end


        if auto_reload and gun and tonumber(ammo) == 0 and tonumber(ammo_text) ~= 0 then
            modules.reload(gun);
        end



        -- Modules
        if Options.CSync then
            local csync_mode = Flags["csync_mode"]
            local x,y,z = math.random(10000,200000), math.random(10, 50) > 30 and -math.random(10000,200000) or math.random(10000,200000), math.random(10000,200000)
            local csync_position = csync_mode == "Void" and CFrame.new(x,math.random(10, 50) > 30 and -12e15 or 12e15 , z)
                                or csync_mode == "Random" and CFrame.new(x,y,z)
                                or csync_mode == "Custom" and CFrame.new(Flags["x"], Flags["y"], Flags["z"])
                                or csync_mode == "Angles" and (Options.return_cframe * CFrame.Angles(
                                    0,
                                    0,
                                    math.rad(180)
                                ))

            if Options.Buying or killing then return end
            Options.CSyncPosition = csync_position
        end

        if Options.cframe_speed then
            if not humanoid then return end

            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + humanoid.MoveDirection * Flags["cframe_speeed"]
        end

        if Flags["no_slow"] then
            if not body_effects then return end

            body_effects.Movement:ClearAllChildren()
            if body_effects:FindFirstChild("Reload") then
                body_effects:FindFirstChild("Reload").Value = false
            end
        end

        if Flags["antistomp_state"] then
            local mode = Flags["antistomp_mode"]
            if mode == "Normal" and ko and ko.Value then
                char:FindFirstChild("Head"):Destroy()
            elseif mode == "Velocity" then
                Velocity = humanoid_rootpart.Velocity

                humanoid_rootpart.Velocity = Vector3.new(0, -9e9, 0)
                RunService.RenderStepped:Wait()
                humanoid_rootpart.Velocity = Velocity
            end
        end

        if view and Options.Target ~= nil then
            modules.view(modules.get_target(Options.Target))
        elseif
            not view
            and humanoid
            and not Options.CSync
            and not Options.Killing then
                modules.view(char)
        elseif
            not view
            and humanoid
            and Options.CSync
            and not Options.Killing then
                modules.view(Options.CSyncPart)
        end

        if humanoid then
            humanoid.UseJumpPower = not Flags["no_jump"]
            if no_sit then 
                humanoid.Sit = false 
            end 
        end

        if Flags["autostomp_state"] then
            MainEvent:FireServer("Stomp")
        end

        if hitbox_expander or velocity_resolver then
            local size = Flags["hitbox_size"]
            local players = Players:GetPlayers()
            for i = 1, #players do
                local player = players[i]
                if player == LocalPlayer or player.Character == nil then continue end

                local humanoid_rootpart = player.Character:FindFirstChild("HumanoidRootPart")
                if not humanoid_rootpart then continue end

                if modules.is_ko(player.Character) or modules.is_stomped(player.Character) then return end

                if hitbox_expander then
                    humanoid_rootpart.CanCollide = false
                    humanoid_rootpart.Size = Vector3.new( size, size, size )
                end

                if velocity_resolver then
                    humanoid_rootpart.Velocity = Vector3.zero
                end
            end
        end

        if killaura and not killing then
            local max_distance = Flags["killaura_distance"]
            local closest_player = modules.closest_player(max_distance, humanoid_rootpart.Position, true)
            if not closest_player then return end

            local gun = modules.get_gun(false)
            if not gun then return end

            modules.shoot(closest_player, gun)
        end

        if auto_farm_stomps and not killing and not buying then
            local dead_players = modules.get_dead_players()

            for i = 1, #dead_players do
                local player = dead_players[i]
                local upper_torso = player.UpperTorso.CFrame
                -- using ts in csync will break
                modules.teleport(CFrame.new(upper_torso.X, upper_torso.Y + 2, upper_torso.Z), Options.CSync)
                MainEvent:FireServer("Stomp")
            end
        end

        for i = 1, #character_children do 
            local part = character_children[i]
            if not part:IsA("BasePart") then continue end 

            part.CanCollide = not no_clip
        end 

    end))
end
local bot = loadstring(game:HttpGet("https://raw.githubusercontent.com/penguin-cmyk/discord-bot-luau/refs/heads/main/discordbot/init.lua"))()
getgenv().modules = modules
getgenv().bot = bot
