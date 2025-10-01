-- FE Explode Script v.1.3
-- Credits to gerdroid 

local cat_name = 'muffy'-- so you can change cat name       
local explode_cat_method = 'serverkill' -- default or destroyhead or takedamage or serverkill
local explode_method = 'keybind' -- tool or touch or keybind or button
local netless_method = 'shp' -- default or shp or ssr or setscriptable or setreadonly
local script_method = 'bombvest' -- bombvest or bring or control or dig
local cathair = 'hair1' -- disabled or hair1 or hair2

local highlight = true -- highlights the cat
local chatcmds = true -- commands: !stop - stopping script, !rejoin - rejoining
local notifyes = true -- enabling notificationd
local receiveageprint = false -- if enabled this can be laggy
local remove_tools = false -- removing tools for explode tool method
local netless = true -- enabling netless
local checkcatisseating = true -- if network owner killed
local funmode = true -- lmao

local speed = 0.25 -- speed for control the cat
local jump = 50 -- jump for control the cat
local speed_explode = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed
local radius = 1e308 -- you can change to math.huge if you want
local radius2 = 1/0 -- this too
local sine = 0 -- coming soon

local loopbring = false
local controling = false
local diggind = false

local uis = game:GetService('UserInputService')
local rs = game:GetService('RunService')
local ws = game:GetService('Workspace')
local pl = game:GetService('Players')
local ts = game:GetService('TeleportService')
local cg = (cloneref and cloneref(game:GetService('CoreGui'))) or game:GetService('CoreGui')
local sg = game:GetService('StarterGui')

local fpdh = ws['FallenPartsDestroyHeight']
local cam = ws['CurrentCamera']
local dress = ws['dress']
local fc = dress['face changers']
local face1,face2,face3 = nil,nil,nil

for _,face in ipairs(fc:GetDescendants()) do
  if face:IsA('Part') then
    if face['Decal'].Texture=='rbxassetid://3631726063' then
      face1 = face
    elseif face['Decal'].Texture=='http://www.roblox.com/asset/?id=3045704917' then
      face2 = face
    elseif face['Decal'].Texture=='rbxassetid://3631666432' then
      face3 = face
    end
  end
end

local lp = pl['LocalPlayer'] -- not WaitForChild becuz on most exploits it incompatible with infinity yeild
local char = lp['Character'] or lp.CharacterAdded:Wait()
local hum = char and char:FindFirstChildWhichIsA('Humanoid')
local hrp = char and char['HumanoidRootPart']
local bp = lp:WaitForChild('Backpack')
local pg = lp:WaitForChild('PlayerGui')

local skeleton = ws['                                                 ']
local skeleton_torso = skeleton['Torso']

local cat = ws:WaitForChild(cat_name)
local cat_torso = cat:WaitForChild('Torso')
local cat_head = cat:WaitForChild('Head')
local cat_hum = cat:FindFirstChildOfClass('Humanoid')

local offset = CFrame.new(0, 0, 1.1)*CFrame.Angles(math.rad(90), 0, 0)
local offset1 = CFrame.new(0, 1.1, 0)*CFrame.Angles(0, 0, 0)
local random_offset = CFrame.Angles(math.random(-360,360), math.random(-360,360), math.random(-360,360))
local fling_power = Vector3.one*1500
local fling_power2 = Vector3.one*150000
local digpos = nil

local firetouchinterest = firetouchinterest
local sethiddenproperty = sethiddenproperty 
local setsimulationradius = setsimulationradius
local isreadonly = isreadonly
local setreadonly = setreadonly
local isscriptable = isscriptable
local setscriptable = setscriptable
local isnetworkowner = isnetworkowner or function(part) 
  if isreadonly(part.ReceiveAge) then
    setreadonly(part.ReceiveAge, false)
  end
  part.ReceiveAge = 0 
  return
end
local cansignalreplicate = cansignalreplicate
local replicatesignal = replicatesignal or function(signal)
  if not cansignalreplicate(signal) then
    error(signal)
  end
  return
end
local function sendnotify(text)
  sg:SetCore('SendNotification', {
    Title = 'Script Notify',
    Text = text,
    Duration = 5.50,
  })
end
local function explode_cat()
  pcall(function()
    if explode_cat_method=='default' then
      if isnetworkowner(cat_torso) then
        cat_hum.Health = 0
      end
    elseif explode_cat_method=='destroyhead' then
      if isnetworkowner(cat_head) then
        cat_head:Destroy()
      end
    elseif explode_cat_method=='takedamage' then
      if isnetworkowner(cat_torso) then
        cat_hum:TakeDamage(100)
      end
    elseif explode_cat_method=='serverkill' then
      for _,kp in ipairs(skeleton:GetDescendants()) do
        if kp:IsA('BasePart') then
          firetouchinterest(cat_torso, kp, 1)
          firetouchinterest(cat_torso, kp, 0)
        end
      end
    end
  end)
end
if (speed_explode) then
  hum['WalkSpeed'] = speed_explode
end
if netless==true then
  pcall(function()
    lp['ReplicationFocus'] = ws
    sethiddenproperty(lp,'ReplicationFocus',ws)
    sethiddenproperty(ws,'InterpolationThrottling',Enum.InterpolationThrottlingMode.Disabled)
    sethiddenproperty(ws,'Retargeting','Disabled')
    sethiddenproperty(hum, "InternalBodyScale", CFrame.new(Vector3.new(9e9, 9e9, 9e9)))
    sethiddenproperty(ws, "SignalBehavior", "Immediate")
    settings()["Physics"]['PhysicsEnvironmentalThrottle'] = Enum.EnviromentalPhysicsThrottle.Disabled
    settings()["Physics"]['AllowSleep'] = false
    settings()["Physics"]['ThrottleAdjustTime'] = math.huge
  end)
end
rs['Heartbeat']:Connect(function()
  task.spawn(function()
    if (netless_method=='default') and lp.SimulationRadius then
      lp.SimulationRadius = radius
      lp.MaximumSimulationRadius = radius2
    elseif (netless_method=='shp') and sethiddenproperty then
      sethiddenproperty(lp, 'SimulationRadius', radius)
      sethiddenproperty(lp, 'MaximumSimulationRadius', radius2)
    elseif (netless_method=='ssr') and setsimulationradius then
      setsimulationradius(radius, radius2)
    elseif (netless_method=='setscriptable') and setscriptable then
      if not isscriptable(lp.SimulationRadius) or not isscriptable(lp.MaximumSimulationRadius) then
        setscriptable(lp, 'SimulationRadius', true)
        setscriptable(lp, 'MaximumSimulationRadius', true)
      end
      lp.SimulationRadius = radius
      lp.MaximumSimulationRadius = radius2
    elseif (netless_method=='setreadonly') and setreadonly then
      if isreadonly(lp.SimulationRadius) or isreadonly(lp.MaximumSimulationRadius) then
        setreadonly(lp.SimulationRadius, false)
        setreadonly(lp.MaximumSimulationRadius, false)
      end
      lp.SimulationRadius = radius
      lp.MaximumSimulationRadius = radius2
    else
      if notifyes==true then
        sendnotify('Exploit doesnt supports netless.')
      end
    end
  end)
end)
task.spawn(function()
  if script_method=='bombvest' then
    loopbring = true
    if checkcatisseating==true then
      if cat_hum.Sit==true then
        loopbring = false
        if notifyes then
          sendnotify('Cat is disabled to use, try on another cat or another server.')
        end
      end
    end
    if highlight==true then
      local highlight = Instance.new('Highlight')
      highlight['Parent'] = cat
      highlight['Adornee'] = cat
      highlight['FillTransparency'] = 0.85
      highlight['FillColor'] = Color3.fromRGB(255, 0, 0)
    end
    task.spawn(function()
      while task.wait() and loopbring do
        task.spawn(function()
          if cat and cat_torso then
            if isnetworkowner(cat_torso) then
              cat_torso.CFrame = hrp.CFrame*offset
            else
              hrp.CFrame = cat_torso.CFrame
              if receiveageprint==true then
                print(cat_torso.ReceiveAge)
              end
            end
          end
          for _,cbp in ipairs(cat:GetDescendants()) do
            if cbp:IsA('BasePart') or cbp:IsA('MeshPart') then
              cbp.CanCollide = false
              cbp.Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
            end
          end
          sine=sine+1
        end)
      end
    end)
  elseif script_method=='bring' then
    loopbring = true
    if checkcatisseating==true then
      if cat_hum.Sit==true then
        loopbring = false
        if notifyes then
          sendnotify('Cat is disabled to use, try on another cat or another server.')
        end
      end
    end
    if highlight==true then
      local highlight = Instance.new('Highlight')
      highlight['Parent'] = cat
      highlight['Adornee'] = cat
      highlight['FillTransparency'] = 0.85
      highlight['FillColor'] = Color3.fromRGB(255, 0, 0)
    end
    task.spawn(function()
      while task.wait() and loopbring do
        task.spawn(function()
          if cat and cat_torso then
            if isnetworkowner(cat_torso) then
              cat_torso.CFrame = hrp.CFrame*offset1
            else
              hrp.CFrame = cat_torso.CFrame
              if receiveageprint==true then
                print(cat_torso.ReceiveAge)
              end
            end
          end
          for _,cbp in ipairs(cat:GetDescendants()) do
            if cbp:IsA('BasePart') or cbp:IsA('MeshPart') then
              cbp.CanCollide = false
              cbp.Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
            end
          end
          sine=sine+1
        end)
      end
    end)
  elseif script_method=='dig' then
    digging=true
    digpos = hrp.CFrame*CFrame.new(0,-6.2,0)
    if checkcatisseating==true then
      if cat_hum.Sit==true then
        digging = false
        if notifyes then
          sendnotify('Cat is disabled to use, try on another cat or another server.')
        end
      end
    end
    if highlight==true then
      local highlight = Instance.new('Highlight')
      highlight['Parent'] = cat
      highlight['Adornee'] = cat
      highlight['FillTransparency'] = 0.85
      highlight['FillColor'] = Color3.fromRGB(255, 0, 0)
    end
    task.spawn(function()
      while task.wait() and digging do
        task.spawn(function()
          if cat and cat_torso then
            if isnetworkowner(cat_torso) then
              cat_torso.CFrame = hrp.CFrame*offset1
            else
              hrp.CFrame = cat_torso.CFrame
              if receiveageprint==true then
                print(cat_torso.ReceiveAge)
              end
            end
          end
          for _,cbp in ipairs(cat:GetDescendants()) do
            if cbp:IsA('BasePart') or cbp:IsA('MeshPart') then
              cbp.CanCollide = false
              cbp.Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
            end
          end
          sine=sine+1
        end)
      end
    end)
    task.wait()
    task.spawn(function()
      while digging do
        hrp.CFrame = digpos
        hrp.Velocity = Vector3.new(0,1,0)
        hrp.RotVelocity = Vector3.zero
        rs['Heartbeat']:wait()
      end
    end)
    hrp.CFrame = digpos
    task.wait()
    hrp.CFrame = digpos
    explode_cat()
    
  elseif script_method=='control' then
    controling = true
    if checkcatisseating==true then
      if cat_hum.Sit==true then
        loopbring = false
        if notifyes then
          sendnotify('Cat is disabled to use, try on another cat or another server.')
        end
      end
    end
    if highlight==true then
      local highlight = Instance.new('Highlight')
      highlight['Parent'] = cat
      highlight['Adornee'] = cat
      highlight['FillTransparency'] = 0.85
      highlight['FillColor'] = Color3.fromRGB(255, 0, 0)
    end
    task.spawn(function()
      while controling do
        hrp.CFrame = cat_torso.CFrame*CFrame.new(0,-3.5,0)*CFrame.Angles(math.rad(-90),0,0)
        hrp.Velocity = Vector3.new(0,1,0)
        hrp.RotVelocity = Vector3.zero
        rs['Heartbeat']:wait()
      end
    end)
    cam['CameraSubject'] = cat_hum
    rs['RenderStepped']:Connect(function(dt)
      local movdir = hum['MoveDirection']
      task.spawn(function()
        if movdir.Magnitude>0 then
          local move = movdir.Unit * speed * dt * 60
          local targcf = CFrame.lookAt(cat_torso.Position, cat_torso.Position + movdir)
          local smooth = cat_torso.CFrame:Lerp(targcf, 0.2)
          if isnetworkowner(cat_torso) then
            cat_torso.CFrame = smooth+move
          end
        end
      end)
    end)
  end
end)
if remove_tools==true then
  for _,rem in ipairs(bp:GetChildren()) do
    if not rem.Name=='Explode' then
      rem:Destroy()
    end
  end
end
if explode_method=='tool' then
  if notifyes then
    sendnotify('For explode the cat activate tool.')
  end
  local exp = Instance.new('Tool')
  exp['Parent'] = bp
  exp['Name'] = 'Explode'
  exp['RequiresHandle'] = false
  exp['CanBeDropped'] = false
  exp['Activated']:Connect(function()
    explode_cat()
    exp:Destroy()
  end)
elseif explode_method=='touch' then
  if notifyes then
    sendnotify('For explode the cat touch ppl.')
  end
  cat_torso.Touched:Connect(function(p)
    if p.Parent:IsA('Model') and p.Parent:FindFirstChildOfClass('Humanoid') then
      if not p.Parent:FindFirstChildOfClass('Humanoid')==hum then
        explode_cat()
      end
    end
  end)
elseif explode_method=='keybind' then
  if notifyes then
    sendnotify("For explode the cat click to key 'r'.")
  end
  uis['InputBegan']:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
      explode_cat()
    end
  end)
elseif explode_method=='button' then
  if notifyes then
    sendnotify("For explode the cat click to button.")
  end
  local maingui = Instance.new("ScreenGui")
  maingui.Name = "ExplodeGui"
  maingui.Parent = pg
  
  local button = Instance.new("TextButton")
  button.Name = "ExplodeButton"
  button.Size = UDim2.new(0, 120, 0, 40)
  button.Position = UDim2.new(1, -140, 0.5, -20)
  button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
  button.Text = "EXPLODE"
  button.TextColor3 = Color3.fromRGB(255, 255, 255)
  button.TextScaled = true
  button.Font = Enum.Font.GothamBold
  button.Parent = maingui
  
  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(0, 10)
  corner.Parent = button
  
  button.MouseButton1Click:Connect(function()
    explode_cat()
  end)
end
if (chatcmds==true) then
  lp['Chatted']:Connect(function(msg)
    if msg=='!stop' then
      task.spawn(function()
        if loopbring==true then
          loopbring = false
        end
        if maingui then
          maingui:Destroy()
        end
        if exp then
          exp:Destroy()
        end
        if cat_torso:FindFirstChildOfClass('TouchInterest') then
          cat_torso['TouchInterest']:Destroy()
        end
        if receiveageprint==true then
          receiveageprint = false
        end
        if remove_tools==true then
          ws['Chest_Invisibility_Cloak']['LidToggle']:FireServer()
          ws['Chest_Acceleration_Coil']['LidToggle']:FireServer()
          ws['Chest_Gravity_Coil']['LidToggle']:FireServer()
          ws['Chest_Cyclotron']['LidToggle']:FireServer()
          ws['Chest_Teleport']['LidToggle']:FireServer()
          ws['Chest_Lantern']['LidToggle']:FireServer()
        end
        if notifyes then
          sendnotify("Script succesfully stopped.")
        end
      end)
    elseif msg=='!rejoin' or msg=='!rj' then
      ts:TeleportToPlaceInstance(game.PlaceId,game.JobId,lp)
      if notifyes then
        sendnotify("trying to rejoin...")
      end
    elseif msg=='!explode' or msg=='!exp' then
      explode_cat()
    end
  end)
end
if cathair=='hair1' then
  if dress:FindFirstChild('Honey Hair') then
    firetouchinterest(cat_head,dress['Honey Hair']:WaitForChild('Handle'),1)
    firetouchinterest(cat_head,dress['Honey Hair']:WaitForChild('Handle'),0)
  else
    if notifyes then
      sendnotify("Honey Hair not found try to use another hair.")
    end
  end 
elseif cathair=='hair2' then
  if dress:FindFirstChild('LongGirlHair') then
    firetouchinterest(cat_head,dress['LongGirlHair']:WaitForChild('Handle'),1)
    firetouchinterest(cat_head,dress['LongGirlHair']:WaitForChild('Handle'),0)
  else
    if notifyes then
      sendnotify("LongGirlHair not found try to use another hair.")
    end      
  end
end
if funmode==true then
  while cat_head do
    firetouchinterest(cat_head,face1,1)
    firetouchinterest(cat_head,face1,0)
    task.wait()
    firetouchinterest(cat_head,face2,1)
    firetouchinterest(cat_head,face2,0)
    task.wait()
    firetouchinterest(cat_head,face3,1)
    firetouchinterest(cat_head,face3,0)
    task.wait()
  end
end
if game.PlaceId~='574746640' then
  if notifyes then
    sendnotify("Using this script not in original 4nn1's place can be buggy.")
  end
end
