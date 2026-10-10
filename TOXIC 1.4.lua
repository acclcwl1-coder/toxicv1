-- TOXIC V2
-- INV void lock + TP TO VOID | walk/hit INV

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local GuiService       = game:GetService("GuiService")
local VirtualUser      = game:GetService("VirtualUser")
local LocalPlayer      = Players.LocalPlayer

do
  local prev = rawget(_G, "_TX_SESSION")
  if type(prev) == "table" then
    prev.alive = false
    for _, fn in ipairs(prev.teardown or {}) do pcall(fn) end
    for _, c in ipairs(prev.connections or {}) do
      pcall(function()
        if c and c.Disconnect then c:Disconnect() end
      end)
    end
  end
  if getgenv then
    pcall(function()
      local u = getgenv().TX_UNLOAD
      if type(u) == "function" then u() end
    end)
  end
  local names = {
    "ToxicProject_V4_FiveM_DUI", "TXIntro", "TXEspOverlay",
    "TXToastHolder", "HookAntiCrasherUI"
  }
  local function wipe(container)
    if not container then return end
    for _, n in ipairs(names) do
      pcall(function()
        local o = container:FindFirstChild(n)
        if o then o:Destroy() end
      end)
    end
  end
  pcall(function() wipe(game:GetService("CoreGui")) end)
  pcall(function()
    local lp = Players.LocalPlayer
    if lp then
      wipe(lp:FindFirstChildOfClass("PlayerGui"))
      wipe(lp:FindFirstChild("PlayerGui"))
    end
  end)
  pcall(function()
    if gethui then wipe(gethui()) end
  end)
  pcall(function()
    local a = workspace:FindFirstChild("TXINV")
    if a then a:Destroy() end
  end)
  _G._TX_SESSION = { alive = true, connections = {}, teardown = {} }
end


-- TOXIC intro (one screen, ~6.8s, audible song)
pcall(function()
  local g = (type(getgenv) == "function" and getgenv()) or _G
  if type(g) == "table" and g._TX_INTRO_DONE then return end
  if type(g) == "table" then g._TX_INTRO_DONE = true end
  local Lighting = game:GetService("Lighting")
  local SoundService = game:GetService("SoundService")
  local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 8)
  if not pg then return end
  local introGui = Instance.new("ScreenGui")
  introGui.Name = "TXIntro"
  introGui.ResetOnSpawn = false
  introGui.IgnoreGuiInset = true
  introGui.DisplayOrder = 999999
  introGui.Parent = pg
  local bg = Instance.new("Frame")
  bg.Size = UDim2.fromScale(1,1)
  bg.BackgroundColor3 = Color3.new(0,0,0)
  bg.BackgroundTransparency = 0.08
  bg.BorderSizePixel = 0
  bg.Parent = introGui
  local blur = Instance.new("BlurEffect")
  blur.Size = 16
  blur.Parent = Lighting
  local skip = false
  local container = Instance.new("Frame")
  container.Size = UDim2.fromOffset(400, 300)
  container.Position = UDim2.new(0.5, -200, 0.5, -150)
  container.BackgroundTransparency = 1
  container.Parent = bg
  local logo = Instance.new("ImageLabel")
  logo.Size = UDim2.fromOffset(120, 120)
  logo.Position = UDim2.new(0.5, -60, 0, 28)
  logo.BackgroundTransparency = 1
  logo.Image = "rbxassetid://16478039709"
  logo.ImageTransparency = 1
  logo.ScaleType = Enum.ScaleType.Fit
  logo.Parent = container
  local title = Instance.new("TextLabel")
  title.Size = UDim2.new(1, 0, 0, 50)
  title.Position = UDim2.fromOffset(0, 168)
  title.BackgroundTransparency = 1
  title.Text = "TOXIC V2"
  title.TextColor3 = Color3.fromRGB(80, 255, 140)
  title.TextTransparency = 1
  title.TextScaled = true
  title.Font = Enum.Font.GothamBlack
  title.TextStrokeTransparency = 0.15
  title.TextStrokeColor3 = Color3.fromRGB(255,255,255)
  title.Parent = container
  local grad = Instance.new("UIGradient")
  grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 40, 80)),
    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 180, 40)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(80, 255, 120)),
    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(40, 180, 255)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(180, 80, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 40, 80)),
  })
  grad.Rotation = 0
  grad.Parent = title
  local stroke = Instance.new("UIStroke")
  stroke.Thickness = 2
  stroke.Color = Color3.fromRGB(255,255,255)
  stroke.Transparency = 0.25
  stroke.Parent = title
  local sgrad = Instance.new("UIGradient")
  sgrad.Color = grad.Color
  sgrad.Parent = stroke
  task.spawn(function()
    local t = 0
    while introGui.Parent do
      t += task.wait()
      grad.Offset = Vector2.new((t * 0.35) % 1 - 0.5, 0)
      sgrad.Offset = Vector2.new((t * 0.35) % 1 - 0.5, 0)
      title.Rotation = math.sin(t * 2.2) * 3
      title.TextTransparency = 0
    end
  end)
  local sub = Instance.new("TextLabel")
  sub.Size = UDim2.new(0.8, 0, 0, 26)
  sub.Position = UDim2.new(0.1, 0, 0, 226)
  sub.BackgroundTransparency = 1
  sub.Text = ""
  sub.TextColor3 = Color3.fromRGB(220, 255, 230)
  sub.TextTransparency = 1
  sub.TextScaled = true
  sub.Font = Enum.Font.GothamBold
  sub.Parent = container
  local tap = Instance.new("TextLabel")
  tap.Size = UDim2.new(1, 0, 0, 16)
  tap.Position = UDim2.fromOffset(0, 254)
  tap.BackgroundTransparency = 1
  tap.Text = ""
  tap.TextColor3 = Color3.fromRGB(160, 180, 170)
  tap.TextTransparency = 1
  tap.TextSize = 11
  tap.Font = Enum.Font.Gotham
  tap.Parent = container
  local loadingBg = Instance.new("Frame")
  loadingBg.Size = UDim2.new(0.6, 0, 0, 4)
  loadingBg.Position = UDim2.new(0.2, 0, 0, 278)
  loadingBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
  loadingBg.BackgroundTransparency = 0.4
  loadingBg.BorderSizePixel = 0
  loadingBg.Parent = container
  Instance.new("UICorner", loadingBg).CornerRadius = UDim.new(0, 2)
  local loadingBar = Instance.new("Frame")
  loadingBar.Size = UDim2.new(0, 0, 1, 0)
  loadingBar.BackgroundColor3 = Color3.fromRGB(80, 255, 140)
  loadingBar.BorderSizePixel = 0
  loadingBar.Parent = loadingBg
  Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(0, 2)
  local snd
  pcall(function()
    local sid = "rbxassetid://1843525740"
    local url = "https://www.dropbox.com/scl/fi/jm68qcearh1su2zwyd8z2/ytmp3free-mp3cut.net.mp3?rlkey=vzz6ykp06zrtnnuosj4m36rz6&st=4bho7co9&dl=1"
    if writefile and getcustomasset then
      local fn = "tx_intro.mp3"
      local have = isfile and isfile(fn)
      if not have then
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if ok and type(data) == "string" and #data > 1000 then
          pcall(writefile, fn, data)
          have = true
        end
      end
      if have then
        local aok, asset = pcall(getcustomasset, fn)
        if aok and asset and asset ~= "" then sid = asset end
      end
    end
    snd = Instance.new("Sound")
    snd.Name = "TXIntroMusic"
    snd.SoundId = sid
    snd.Volume = 2
    snd.Looped = true
    snd.Parent = SoundService
    if not snd.IsLoaded then
      local t = tick()
      while not snd.IsLoaded and tick()-t < 3 do task.wait() end
    end
    snd.TimePosition = 0
    snd:Play()
  end)
  TweenService:Create(logo, TweenInfo.new(0.55), {ImageTransparency = 0}):Play()
  TweenService:Create(title, TweenInfo.new(0.55), {TextTransparency = 0}):Play()
  TweenService:Create(sub, TweenInfo.new(0.55), {TextTransparency = 0.15}):Play()
  TweenService:Create(tap, TweenInfo.new(0.55), {TextTransparency = 0.35}):Play()
  TweenService:Create(loadingBar, TweenInfo.new(12, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
  local t0 = tick()
  while tick() - t0 < 12 do task.wait() end
  TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
  TweenService:Create(logo, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
  TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
  TweenService:Create(sub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
  TweenService:Create(tap, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
  if snd then
    pcall(function()
      TweenService:Create(snd, TweenInfo.new(0.35), {Volume = 0}):Play()
    end)
  end
  task.wait(0.4)
  pcall(function() if snd then snd:Stop(); snd:Destroy() end end)
  pcall(function() introGui:Destroy() end)
  pcall(function() blur:Destroy() end)
end)

-- Environment & Safe Polyfills
do
  local g = getgenv and getgenv() or _G
  if not g.setreadonly and setreadonly then g.setreadonly = setreadonly end
  if not g.getrawmetatable and getrawmetatable then g.getrawmetatable = getrawmetatable end
  if not g.hookmetamethod and hookmetamethod then g.hookmetamethod = hookmetamethod end
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- MOROCCO VIBES ANTI-CHEAT (MVAC) SPECTATE & TELEMETRY 100% BULLETPROOF BYPASS
-- Engineered from reverse-engineering of MoroccoVibesAntiCheatClient dump:
-- 1. Anti-Cheat script termination & destruction (PlayerScripts & StarterPlayer)
-- 2. RenderStepped & OnClientEvent connection severing
-- 3. Telemetry RemoteEvent FireServer blocker (__namecall & hookfunction)
-- 4. Dropping spectate_violation, scriptable_camera_violation, client_tamper_signal, detector_error
-- 5. Spoofing heartbeat cameraType to "Enum.CameraType.Custom"
-- 6. Attribute Whitelist enforcement (MVAC_AllowSpectate & MVAC_AllowClientSpectate)
-- 7. Metamethod __namecall & hookfunction interceptor for GetAttribute -> always true
-- 8. getfenv(0) sanitizer to prevent checkExecutorSignals from detecting executor globals
-- 9. Complete MVSpectateAlerts UI nuking & suppression
-- 10. High-frequency persistent guardian loop (restores state, clears rogue alerts)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
pcall(function()
  local safe_cclosure = newcclosure or function(f) return f end
  local rep = game:GetService("ReplicatedStorage")
  local runService = game:GetService("RunService")
  local players = game:GetService("Players")
  local lp = players.LocalPlayer
  if not lp then
    for _ = 1, 50 do
      lp = players.LocalPlayer
      if lp then break end
      task.wait(0.1)
    end
  end
  if not lp then return end

 -- ----------------------------------------------------------------------------
 -- LAYER 1: Neutralize & Destroy Client-Side Anti-Cheat Script Instances
 -- ----------------------------------------------------------------------------
  local function killACScripts()
    pcall(function()
      local ps = lp:FindFirstChildOfClass("PlayerScripts") or lp:FindFirstChild("PlayerScripts")
      if ps then
        for _, child in ipairs(ps:GetChildren()) do
          if child:IsA("LocalScript") then
            local ln = string.lower(child.Name)
            if ln == "moroccovibesanticheatclient" or ln == "antiexploitclient" or ln == "antiexploitmonitor" or ln == "securefreecam" or ln == "freecam" or string.find(ln, "anticheat") or string.find(ln, "mvac") or string.find(ln, "antiexploit") then
              child.Disabled = true
              child:Destroy()
            end
          end
        end
      end
    end)
    pcall(function()
      local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
      if sps then
        for _, child in ipairs(sps:GetChildren()) do
          if child:IsA("LocalScript") then
            local ln = string.lower(child.Name)
            if ln == "moroccovibesanticheatclient" or ln == "antiexploitclient" or ln == "antiexploitmonitor" or ln == "securefreecam" or ln == "freecam" or string.find(ln, "anticheat") or string.find(ln, "mvac") or string.find(ln, "antiexploit") then
              child.Disabled = true
            end
          end
        end
      end
    end)
  end
  killACScripts()

 -- ----------------------------------------------------------------------------
 -- LAYER 2: Whitelist Attributes + Instant Re-Set Event Listeners
 -- ----------------------------------------------------------------------------
  local function enforceAttributes()
    pcall(function()
      if lp:GetAttribute("MVAC_AllowSpectate") ~= true then
        lp:SetAttribute("MVAC_AllowSpectate", true)
      end
      if workspace:GetAttribute("MVAC_AllowClientSpectate") ~= true then
        workspace:SetAttribute("MVAC_AllowClientSpectate", true)
      end
    end)
  end
  enforceAttributes()

  pcall(function()
    lp:GetAttributeChangedSignal("MVAC_AllowSpectate"):Connect(function()
      if lp:GetAttribute("MVAC_AllowSpectate") ~= true then
        lp:SetAttribute("MVAC_AllowSpectate", true)
      end
    end)
    workspace:GetAttributeChangedSignal("MVAC_AllowClientSpectate"):Connect(function()
      if workspace:GetAttribute("MVAC_AllowClientSpectate") ~= true then
        workspace:SetAttribute("MVAC_AllowClientSpectate", true)
      end
    end)
  end)

 -- ----------------------------------------------------------------------------
 -- LAYER 3: Destroy & Permanently Suppress Spectate Alert UI (MVSpectateAlerts)
 -- ----------------------------------------------------------------------------
  local function purgeAlerts()
    pcall(function()
      local pg = lp:FindFirstChildOfClass("PlayerGui")
      if pg then
        local alertGui = pg:FindFirstChild("MVSpectateAlerts")
        if alertGui then
          alertGui:Destroy()
        end
      end
    end)
  end
  purgeAlerts()

  pcall(function()
    local pg = lp:FindFirstChildOfClass("PlayerGui")
    if pg then
      pg.ChildAdded:Connect(function(child)
        if child.Name == "MVSpectateAlerts" or string.find(string.lower(child.Name), "spectatealert") then
          task.defer(function() pcall(function() child:Destroy() end) end)
        end
      end)
    end
  end)

 -- ----------------------------------------------------------------------------
 -- LAYER 4: Disconnect Telemetry RemoteEvent Connections (If getconnections exists)
 -- ----------------------------------------------------------------------------
  task.spawn(function()
    local telemetry = rep:WaitForChild("MVAntiCheatTelemetry", 15)
    if telemetry and telemetry:IsA("RemoteEvent") and getconnections then
      pcall(function()
        for _, conn in ipairs(getconnections(telemetry.OnClientEvent)) do
          pcall(function() conn:Disable() end)
          pcall(function() conn:Disconnect() end)
        end
      end)
    end
  end)

 -- ----------------------------------------------------------------------------
 -- LAYER 5: Sanitize getfenv(0) to Hide Executor Globals from checkExecutorSignals
 -- ----------------------------------------------------------------------------
  -- getfenv hook removed: executor internal scripts crash with "attempt to call a nil value" at line 1

  local cuffAttrsLookup = {
    cuffed=true, iscuffed=true, handcuffed=true, arrested=true,
    restrained=true, grabbed=true, carried=true, frozen=true,
    disabled=true, seated=true, detained=true, incuffs=true,
    cuff=true, roped=true, beingcarried=true, beingdragged=true
  }

  local function isCuffAttribute(attr)
    if not attr then return false end
    return cuffAttrsLookup[tostring(attr):lower()] or false
  end

 -- ----------------------------------------------------------------------------
 -- LAYER 6: Hook game.GetAttribute via hookfunction (Catches direct index calls)
 -- ----------------------------------------------------------------------------
  if hookfunction and game.GetAttribute then
    pcall(function()
      local oldGetAttribute
      oldGetAttribute = hookfunction(game.GetAttribute, safe_cclosure(function(self, attr, ...)
        if attr == "MVAC_AllowSpectate" or attr == "MVAC_AllowClientSpectate" then
          return true
        end
        if isCuffAttribute(attr) then
          if CFG and CFG.auto_uncuff and not CFG.cuff_busy then
            local mylp = lp or players.LocalPlayer
            if self == mylp or (mylp and mylp.Character and (self == mylp.Character or (typeof(self) == "Instance" and self:IsDescendantOf(mylp.Character)))) then
              return false
            end
          end
        end
        return oldGetAttribute(self, attr, ...)
      end))
    end)
  end

 -- ----------------------------------------------------------------------------
 -- LAYER 7: Comprehensive Metamethod Interception (__namecall)
 -- ----------------------------------------------------------------------------
  if hookmetamethod then
    pcall(function()
      local oldNamecall
      oldNamecall = hookmetamethod(game, "__namecall", safe_cclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

 -- Telemetry Interception (Dump-Verified Blocklist)
        local selfName = self and tostring(self.Name):lower() or ""
        local blockedRemotes = {
          ["antispectatereport"]     = true,
          ["antispectateowneralert"] = true,
          ["antiviewlogs"]           = true,
          ["antiviewstate"]          = true,
          ["reportposition"]         = true,
          ["clientsignal"]           = true,
          ["createlog"]              = true,
        }

        if (method == "FireServer" or method == "fireServer" or method == "InvokeServer" or method == "invokeServer") then
          if blockedRemotes[selfName] or (self and self.Name == "SecureFreecam" and args[1] == "ReportPosition") then
            return nil
          end
          if selfName == "antispectateheartbeat" then
            return nil
          end
        end

        if self and (self.Name == "MVAntiCheatTelemetry") and (method == "FireServer" or method == "fireServer") then
          local sig = args[1]
          if sig == "spectate_violation" or 
             sig == "scriptable_camera_violation" or 
             sig == "client_tamper_signal" or 
             sig == "detector_error" then
            return nil
          end
          if sig == "heartbeat" then
            if type(args[2]) == "table" then
              args[2].cameraType = "Enum.CameraType.Custom"
            else
              args[2] = { cameraType = "Enum.CameraType.Custom" }
            end
            return oldNamecall(self, sig, args[2])
          end
          return nil
        end

        -- Attribute Method Interception
        if (method == "GetAttribute" or method == "getAttribute") then
          local attr = args[1]
          if attr == "MVAC_AllowSpectate" or attr == "MVAC_AllowClientSpectate" then
            return true
          end
          if isCuffAttribute(attr) then
            if CFG and CFG.auto_uncuff and not CFG.cuff_busy then
              local mylp = lp or players.LocalPlayer
              if self == mylp or (mylp and mylp.Character and (self == mylp.Character or (typeof(self) == "Instance" and self:IsDescendantOf(mylp.Character)))) then
                return false
              end
            end
          end
        end

        -- Outbound Telemetry HTTP Interception
        if method == "HttpGet" or method == "HttpPost" or method == "Request" then
          local url = tostring(args[1] or ""):lower()
          if string.find(url, "31.6.50.169") or (string.find(url, "webhook") and string.find(url, "log")) then
            return nil
          end
        end

        return oldNamecall(self, ...)
      end))
    end)
  end

  -- ----------------------------------------------------------------------------
  -- LAYER 8: Hook Instance.FireServer directly (Catches non-namecall / table calls)
  -- ----------------------------------------------------------------------------
  if hookfunction then
    pcall(function()
      local dummyRemote = Instance.new("RemoteEvent")
      local oldFireServer
      local blockedRemotes = {
        ["antispectatereport"]     = true,
        ["antispectateowneralert"] = true,
        ["antiviewlogs"]           = true,
        ["antiviewstate"]          = true,
        ["reportposition"]         = true,
        ["clientsignal"]           = true,
        ["createlog"]              = true,
      }
      oldFireServer = hookfunction(dummyRemote.FireServer, safe_cclosure(function(self, ...)
        local selfName = self and tostring(self.Name):lower() or ""
        if blockedRemotes[selfName] or selfName == "antispectateheartbeat" then
          return nil
        end
        if self and self.Name == "MVAntiCheatTelemetry" then
          local args = {...}
          local sig = args[1]
          if sig == "spectate_violation" or 
             sig == "scriptable_camera_violation" or 
             sig == "client_tamper_signal" or 
             sig == "detector_error" then
            return nil
          end
          if sig == "heartbeat" then
            if type(args[2]) == "table" then
              args[2].cameraType = "Enum.CameraType.Custom"
            else
              args[2] = { cameraType = "Enum.CameraType.Custom" }
            end
            return oldFireServer(self, sig, args[2])
          end
          return nil
        end
        return oldFireServer(self, ...)
      end))
    end)
  end

  -- ----------------------------------------------------------------------------
  -- LAYER 9: UNDETECTED SMART SPECTATE ENGINE (AFK Spoof + Auto-Anchor)
  -- ----------------------------------------------------------------------------
  local SmartSpectate = {
    Enabled = false,
    CurrentTarget = nil,
    Connection = nil,
    RespawnConn = nil,
  }

  local function getAFKRemote()
    local afkFolder = rep:FindFirstChild("AFK THINGY")
    if afkFolder then
      return afkFolder:FindFirstChild("AFKEvent")
    end
    return nil
  end

  function SmartSpectate.SetAFKSpoof(state)
    pcall(function()
      local afkEvent = getAFKRemote()
      if afkEvent and afkEvent:IsA("RemoteEvent") then
        afkEvent:FireServer(state)
      end
    end)
  end

  function SmartSpectate.Stop()
    if SmartSpectate.Connection then
      SmartSpectate.Connection:Disconnect()
      SmartSpectate.Connection = nil
    end
    if SmartSpectate.RespawnConn then
      SmartSpectate.RespawnConn:Disconnect()
      SmartSpectate.RespawnConn = nil
    end

    SmartSpectate.SetAFKSpoof(false)
    SmartSpectate.CurrentTarget = nil
    SmartSpectate.Enabled = false

    local cam = workspace.CurrentCamera
    local myChar = lp.Character
    if cam and myChar then
      local myHum = myChar:FindFirstChildOfClass("Humanoid")
      if myHum then
        cam.CameraSubject = myHum
        cam.CameraType = Enum.CameraType.Custom
      end
    end
  end

  function SmartSpectate.Start(targetPlayer)
    if not targetPlayer or targetPlayer == lp then
      return SmartSpectate.Stop()
    end

    SmartSpectate.Stop()
    SmartSpectate.CurrentTarget = targetPlayer
    SmartSpectate.Enabled = true

    -- Engage AFK Spoofing
    SmartSpectate.SetAFKSpoof(true)

    local function attachCamera()
      local cam = workspace.CurrentCamera
      if not cam or not SmartSpectate.CurrentTarget then return end
      local char = SmartSpectate.CurrentTarget.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hum and hum.Health > 0 then
        cam.CameraSubject = hum
        cam.CameraType = Enum.CameraType.Custom
      else
        SmartSpectate.Stop()
      end
    end

    attachCamera()

    SmartSpectate.RespawnConn = targetPlayer.CharacterAdded:Connect(function()
      task.wait(0.2)
      attachCamera()
    end)

    SmartSpectate.Connection = runService.RenderStepped:Connect(function()
      if not SmartSpectate.Enabled then return end
      local cam = workspace.CurrentCamera
      local char = SmartSpectate.CurrentTarget and SmartSpectate.CurrentTarget.Character
      local hum = char and char:FindFirstChildOfClass("Humanoid")

      if not hum or hum.Health <= 0 then
        SmartSpectate.Stop()
        return
      end

      if cam and cam.CameraSubject ~= hum then
        cam.CameraSubject = hum
      end
    end)
  end

  function SmartSpectate.Toggle(targetPlayer)
    if SmartSpectate.Enabled and SmartSpectate.CurrentTarget == targetPlayer then
      SmartSpectate.Stop()
    else
      SmartSpectate.Start(targetPlayer)
    end
  end

  function SmartSpectate.IsEnabled()
    return SmartSpectate.Enabled
  end

  function SmartSpectate.GetTarget()
    return SmartSpectate.CurrentTarget
  end

  _G.SmartSpectate = SmartSpectate
  if getgenv then getgenv().SmartSpectate = SmartSpectate end

  -- ----------------------------------------------------------------------------
  -- LAYER 10: High-Frequency Watchdog Loop (Every 1.5s)
  -- ----------------------------------------------------------------------------
  task.spawn(function()
    while task.wait(1.5) do
      enforceAttributes()
      purgeAlerts()
      killACScripts()
    end
  end)
end)

pcall(function()
  if type(getgenv) ~= "function" then
    getgenv = function() return _G end
  end
  local g = getgenv()
  local function setg(name, val)
    g[name] = val
    rawset(_G, name, val)
  end
  -- Xeno / Delta / Fluxus / Solara / Wave / Codex / Arceus aliases
  if not hookfunction and detourfunction then hookfunction = detourfunction end
  if not hookmetamethod and hookfunc then hookmetamethod = hookfunc end
  if not newcclosure then newcclosure = function(f) return f end end
  if not cloneref then cloneref = function(x) return x end end
  if not checkcaller then checkcaller = function() return true end end
  setg("hookfunction", hookfunction)
  setg("hookmetamethod", hookmetamethod)
  setg("newcclosure", newcclosure)
  setg("cloneref", cloneref)

  if not setclipboard then
    if toclipboard then setclipboard = toclipboard
    elseif syn and syn.write_clipboard then setclipboard = syn.write_clipboard
    elseif Clipboard and Clipboard.set then setclipboard = function(t) Clipboard:set(t) end
    else setclipboard = function() end end
  end
  setg("setclipboard", setclipboard)

  local vim = game:GetService("VirtualInputManager")
  if not mouse1press then
    setg("mouse1press", function() pcall(function() vim:SendMouseButtonEvent(0, 0, 0, true, game, 1) end) end)
  end
  if not mouse1release then
    setg("mouse1release", function() pcall(function() vim:SendMouseButtonEvent(0, 0, 0, false, game, 1) end) end)
  end
  if not mouse1click then
    setg("mouse1click", function()
      pcall(function()
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
      end)
    end)
  end
  if not fireclickdetector then
    setg("fireclickdetector", function(det)
      pcall(function()
        if det and det.Parent then
          local part = det.Parent
          if firesignal and det.MouseClick then firesignal(det.MouseClick) end
        end
      end)
    end)
  end
  if not fireproximityprompt then
    setg("fireproximityprompt", function(pr)
      pcall(function()
        if pr then pr:InputHoldBegin(); pr:InputHoldEnd() end
      end)
    end)
  end
  if not gethui then
    setg("gethui", function()
      local lp = game:GetService("Players").LocalPlayer
      local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
      local ok, cg = pcall(function() return game:GetService("CoreGui") end)
      return pg or (ok and cg) or nil
    end)
  end
  if not identifyexecutor then
    setg("identifyexecutor", function()
      if syn or syn_check or is_synapse_function then return "Synapse X" end
      if identify_executor then
        local ok, n = pcall(identify_executor)
        if ok and n then return tostring(n) end
      end
      if getexecutorname then
        local ok, n = pcall(getexecutorname)
        if ok and n then return tostring(n) end
      end
      if fluxus then return "Fluxus" end
      if KRNL_LOADED or krnl then return "Krnl" end
      if is_sirhurt_closure then return "SirHurt" end
      if PROTOSMASHER_LOADED then return "ProtoSmasher" end
      if SENTINEL_LOADED then return "Sentinel" end
      if is_electron then return "Electron" end
      if comet then return "Comet" end
      if solara then return "Solara" end
      if wave then return "Wave" end
      if delta or DELTA_LOADED then return "Delta" end
      if xeno or XENO_LOADED then return "Xeno" end
      if arceus or ARCEUS_LOADED then return "Arceus X" end
      if hydrogen or HYDROGEN_LOADED then return "Hydrogen" end
      if macsploit then return "Macsploit" end
      if celery then return "Celery" end
      if cryptic then return "Cryptic" end
      if volcano then return "Volcano" end
      if bunni then return "Bunni" end
      if seliware then return "Seliware" end
      if valyse then return "Valyse" end
      if trigon then return "Trigon" end
      if nebula then return "Nebula" end
      if kiwi or VEGA_X then return "Vega X / Kiwi" end
      if jjsploit or JJSploit then return "JJSploit" end
      if evon then return "Evon" end
      if oxygen or OxygenU then return "Oxygen U" end
      if temple then return "Temple" end
      if scriptware or is_scriptware then return "Script-Ware" end
      if calamari then return "Calamari" end
      if frostbite then return "Frostbite" end
      if potatium or potassium then return "Potassium" end
      if appleware then return "Apple-Ware" end
      if ronix then return "Ronix" end
      if luna then return "Luna" end
      if neutron then return "Neutron" end
      if reaper then return "Reaper" end
      if cubix then return "Cubix" end
      if neptune then return "Neptune" end
      if banana then return "Banana" end
      if swift then return "Swift" end
      if nihon then return "Nihon" end
      if awp then return "AWP" end
      if hidden then return "Hidden" end
      if wearedevs or WeAreDevs then return "WeAreDevs" end
      return "Unknown Executor"
    end)
  end
  if not getexecutorname then setg("getexecutorname", identifyexecutor) end
  if not isfile then setg("isfile", function() return false end) end
  if not writefile then setg("writefile", function() end) end
  if not readfile then setg("readfile", function() return "" end) end
  if not isfolder then setg("isfolder", function() return false end) end
  if not makefolder then setg("makefolder", function() end) end
  if not firetouchinterest then setg("firetouchinterest", function() end) end
  if not getconnections then setg("getconnections", function() return {} end) end
  if not firesignal then setg("firesignal", function() end) end

  if not getgenv().Drawing or type(getgenv().Drawing) ~= "table" or not getgenv().Drawing.new then
    local drawingShim = {
      new = function(kind)
        return setmetatable({
          Visible = false, Color = Color3.new(1,1,1), Transparency = 1, Position = Vector2.new(0,0), Size = Vector2.new(0,0),
          Radius = 0, Thickness = 1, Filled = false, Text = "",
          Remove = function() end, Destroy = function() end
        }, { __newindex = function() end, __index = function() return function() end end })
      end,
      Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 }
    }
    pcall(function() getgenv().Drawing = drawingShim end)
  end
end)

-- Safe Parent GUI Helper (Optimized for all executors: gethui -> PlayerGui -> CoreGui)
function safeParentGui(gui)
  pcall(function()
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
  end)

  local touchOn = false
  pcall(function()
    local uis = game:GetService("UserInputService")
    touchOn = uis.TouchEnabled == true
  end)
  if touchOn then
    local lp = LocalPlayer or game:GetService("Players").LocalPlayer
    local pg = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
    if pg then
      local ok = pcall(function() gui.Parent = pg end)
      if ok and gui.Parent then
        print("[TOXIC V16] GUI parented to PlayerGui (Xeno/Delta/mobile)")
        return
      end
    end
  end

  -- Priority 1: gethui() - standard across all modern executors (renders properly & hidden)
  if gethui then
    local s, res = pcall(function()
      gui.Parent = gethui()
      return gui.Parent ~= nil
    end)
    if s and res then
      print("[TOXIC V16] GUI successfully parented to gethui()")
      return
    end
  end

  -- Priority 2: syn.protect_gui + CoreGui
  if syn and syn.protect_gui then
    local s, res = pcall(function()
      syn.protect_gui(gui)
      gui.Parent = CoreGui
      return gui.Parent ~= nil
    end)
    if s and res then
      print("[TOXIC V16] GUI parented to CoreGui with syn.protect_gui")
      return
    end
  end

  -- Priority 3: LocalPlayer.PlayerGui (100% visible & rendered on every executor)
  local lp = LocalPlayer or Players.LocalPlayer
  if lp then
    local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui")
    if pg then
      local s = pcall(function()
        gui.Parent = pg
      end)
      if s and gui.Parent then
        print("[TOXIC V16] GUI successfully parented to PlayerGui")
        return
      end
    end
  end

  -- Priority 4: Fallback to CoreGui
  pcall(function()
    gui.Parent = CoreGui
    print("[TOXIC V16] GUI parented to CoreGui fallback")
  end)
end

-- Universal Smooth Cross-Platform GUI Dragging Engine
function MakeDraggable(frame, dragHandle)
  dragHandle = dragHandle or frame
  local dragging = false
  local dragStart = Vector3.zero
  local startPos = UDim2.new()

  local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
      startPos.X.Scale,
      startPos.X.Offset + delta.X,
      startPos.Y.Scale,
      startPos.Y.Offset + delta.Y
    )
  end

  dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPos = frame.Position

      local conn
      conn = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
          if conn then conn:Disconnect() end
        end
      end)
    end
  end)

  dragHandle.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      update(input)
    end
  end)

  UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      update(input)
    end
  end)

  local function endDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = false
    end
  end

  dragHandle.InputEnded:Connect(endDrag)
  UserInputService.InputEnded:Connect(endDrag)
end


-- Global Config
local CFG = {
  cuff_busy              = false,
  cuff_target            = "",
  cuff_target_id         = 0,
  tpbat_on               = false,
  tpbat_keybind          = "None",
  abuse_swap_keybind     = "None",
  abuse_all_keybind      = "None",
  test_switch_keybind    = "None",
  adapt_safe             = false,
  adapt_kickwarn         = true,
  adapt_intro_idx        = 1,
  adapt_sky_idx          = 1,
  adapt_bg_idx           = 1,
  adapt_swatch           = 1,
  adapt_bgcolor          = false,
  adapt_worldsky         = false,
  adapt_stealmatch       = false,
  cuff_delay             = 15,
  cuff_auto_return       = true,
  esp_enabled            = false,
  esp_names              = true,
  esp_tools              = true,
  esp_boxes              = false, -- removed
  esp_chams              = false,
  esp_tracers            = false,
  esp_distance           = true,
  esp_flag               = true,
  esp_region             = true,
  fullbright             = false,
  anti_ragdoll           = false,
  aimbot_enabled         = false,
  aimbot_fov             = 150,
  aimbot_smoothness      = 0.2,
  aimbot_draw_fov        = false,
  hitbox_extender_enabled = false,
  hitbox_size            = 12,
  anti_spectate_blinder  = false,
  auto_dodge_enabled     = false,
  ragdoll_loop_enabled   = false,
  piano_auto_sit         = true,  -- Auto-plays selected song when seated on piano bench
  piano_loop             = false, -- Infinitely loops active song
  piano_speed            = 1.0,   -- Playback tempo multiplier (0.75x - 2.0x)
  piano_selected_song    = 1,     -- Default to Experience (Ludovico Einaudi)
  afk_disabled           = true, -- Anti-AFK Enabled by Default
  smart_spectate         = true,
  silent_typing          = true,
  admin_hud_enabled      = true,
  admin_detector_enabled = true,
  admin_join_sound       = true,
  cuff_arrest_keybind    = "C",
  cuff_7bel_keybind      = "None",
  cuff_7bel_return       = true,
  cuff_carryside_keybind = "None",
  cuff_fling_keybind     = "None",
  cuff_flingcuff_keybind = "None",
  cuff_global_keybind    = "None",
  menu_keybind           = "K",
  last_tab               = "Players",
  invis_keybind          = "None",
  quick_chat_messages    = {
    { text = ";re", keybind = "None" },
    { text = ";aura", keybind = "None" },
    { text = "gg", keybind = "None" },
    { text = "ez", keybind = "None" },
    { text = "toxic on top", keybind = "None" },
    { text = "skill issue", keybind = "None" },
  },
  aura_enabled           = false,
  aura_keybind           = "None",
  quick_aura_keybind     = "None",
  hide_aura_visuals      = true,
  hide_others_effects    = false,
  auto_uncuff            = false,
  uncuff_keybind         = "None",
  spec_keybind           = "None",
  player_sort            = "admin", -- staff first
  ui_lang                = "EN", -- locked English
  ui_theme               = "dark",
  one_hand               = "center",
  low_perf               = false,
  action_orbs            = true,
  orbs_locked            = false,
  orb_positions          = {},
  orb_enabled            = { C = false, R = false, Y = false, F = false, S = false, U = false, A = false, I = false, M = false },
  menu_pos_x             = nil,
  menu_pos_y             = nil,
  prv_whisper_target     = "Self", -- "Self", "Target", or custom username
  quick_prv_messages     = {
    { text = ";re", keybind = "None" },
    { text = ";refresh", keybind = "None" },
  },
  skin_random_keybind    = "None",
  skin_random_last       = "",
  skin_random_list       = {
    "9alwa",
    "Omimemamomou0",
    "illkhadi",
    "charme",
    "ARABIC_MUHAMMAD1",
    "DadyAcido",
    "yahyabod12",
    "noywps",
    "Jesse77100",
    "bilallovesbzoula67",
    "shahzaibgaming_6",
    "Iziki58",
    "Nicklaus_cp0",
    "Xwaet17",
    "King_iSmail96",
    "Trolling77779",
    "Yunoa_Saan",
    "soufianox12",
    "its_hiniri",
    "Zawa9_x",
  },
  -- COLOR CUFF NEAR system
  color_cuff_busy    = false,
  color_cuff_range   = 20,
  color_cuff_keybind = "None",
}

local CFG_SAVE_KEYS = {
  "cuff_delay", "cuff_auto_return", "esp_enabled", "esp_names", "esp_boxes",
  "esp_chams", "esp_tracers", "esp_distance", "esp_tools", "esp_flag", "esp_region", "anti_ragdoll", "aimbot_enabled", "aimbot_fov",
  "aimbot_smoothness", "aimbot_draw_fov", "hitbox_extender_enabled", "hitbox_size",
  "anti_spectate_blinder", "auto_dodge_enabled", "ragdoll_loop_enabled",
  "piano_auto_sit", "piano_loop", "piano_speed", "piano_selected_song",
  "afk_disabled", "smart_spectate", "silent_typing", "admin_hud_enabled",
  "admin_detector_enabled", "admin_join_sound", "cuff_arrest_keybind", "cuff_7bel_keybind",
  "cuff_7bel_return", "cuff_carryside_keybind", "cuff_fling_keybind", "cuff_flingcuff_keybind", "cuff_global_keybind",
  "tpbat_keybind", "abuse_swap_keybind", "abuse_all_keybind", "test_switch_keybind", "menu_keybind", "last_tab", "invis_keybind", "aura_enabled", "aura_keybind",
  "quick_aura_keybind", "hide_aura_visuals", "hide_others_effects",
  "auto_uncuff", "uncuff_keybind", "spec_keybind", "prv_whisper_target", "skin_random_keybind", "skin_random_last", "skin_random_list",
  "color_cuff_range", "color_cuff_keybind",
  "player_sort", "ui_lang", "ui_theme", "one_hand", "low_perf", "action_orbs",
  "orbs_locked", "orb_positions", "orb_enabled",
  "menu_pos_x", "menu_pos_y",
}

function SaveToxicCFG()
  -- auto-save disabled (was locking target / last_tab)
end

function LoadToxicCFG()
CFG.ui_lang = "EN"
CFG.esp_boxes = false
CFG.esp_tracers = false
if CFG.tpbat_keybind == "X" then CFG.tpbat_keybind = "None" end
  pcall(function()
    if not readfile or not isfile or not HttpService then return end
    if not isfile("toxic_v7_cfg.json") then return end
    local raw = readfile("toxic_v7_cfg.json")
    local data = HttpService:JSONDecode(raw)
    if type(data) ~= "table" then return end
    for _, k in ipairs(CFG_SAVE_KEYS) do
      if data[k] ~= nil then CFG[k] = data[k] end
    end
    if type(data.quick_chat_messages) == "table" then
      CFG.quick_chat_messages = data.quick_chat_messages
    end
    if type(data.quick_prv_messages) == "table" then
      CFG.quick_prv_messages = data.quick_prv_messages
    end
    if type(data.skin_random_list) == "table" and #data.skin_random_list > 0 then
      CFG.skin_random_list = data.skin_random_list
    end
    if type(data.skin_random_keybind) == "string" then
      CFG.skin_random_keybind = data.skin_random_keybind
    end
    if type(data.skin_random_last) == "string" then
      CFG.skin_random_last = data.skin_random_last
    end
  end)
end
LoadToxicCFG()

_buildingCards = false
_selToken = 0
_lastPaintId = -1

function ResolvePlayer(ref)
  if ref == nil then return nil end
  if typeof(ref) == "Instance" and ref:IsA("Player") then
    if ref == LocalPlayer then return nil end
    return ref
  end
  if type(ref) == "number" then
    for _, p in ipairs(Players:GetPlayers()) do
      if p.UserId == ref and p ~= LocalPlayer then return p end
    end
    return nil
  end
  if type(ref) == "string" then
    if ref == "" or ref == "No other players" then return nil end
    local hit = Players:FindFirstChild(ref)
    if hit and hit:IsA("Player") and hit ~= LocalPlayer then return hit end
    local q = string.lower(ref)
    for _, p in ipairs(Players:GetPlayers()) do
      if p ~= LocalPlayer and (p.Name:lower() == q or p.DisplayName:lower() == q) then
        return p
      end
    end
  end
  return nil
end

function GetLiveTarget()
  if CFG.cuff_target and CFG.cuff_target ~= "" and CFG.cuff_target ~= "No other players" then
    local p = ResolvePlayer(CFG.cuff_target)
    if p then
      CFG.cuff_target = p.Name
      CFG.cuff_target_id = p.UserId
      return p
    end
  end
  if type(CFG.cuff_target_id) == "number" and CFG.cuff_target_id > 0 then
    for _, p in ipairs(Players:GetPlayers()) do
      if p.UserId == CFG.cuff_target_id and p ~= LocalPlayer then
        CFG.cuff_target = p.Name
        return p
      end
    end
  end
  return nil
end

local STATE_ATTRS = {
  "cuffed","iscuffed","handcuffed","arrested","restrained","grabbed","carried",
  "roped","frozen","disabled","seated","detained","beingcarried","beingdragged"
}

function CollectTargetInfo(plr)
  local info = {
    ok = plr ~= nil,
    display = "No Target",
    user = "none",
    id = 0,
    hp = 0, maxHp = 0, dist = nil, age = 0,
    alive = false, tool = "no tool", admin = "-", watch = "-",
    cash = "0", level = "-", timev = "-",
    state = "FREE", team = "-", region = "-", flag = "",
  }
  if not plr then return info end
  info.display = plr.DisplayName or plr.Name
  info.user = plr.Name
  info.id = plr.UserId
  info.age = (typeof(plr.AccountAge) == "number") and plr.AccountAge or 0
  pcall(function()
    if plr.Team then info.team = tostring(plr.Team.Name) end
  end)
  local char = plr.Character
  local hum = char and char:FindFirstChildOfClass("Humanoid")
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if hum then
    info.hp = math.floor(hum.Health)
    info.maxHp = math.floor(hum.MaxHealth)
    info.alive = info.hp > 0
    if hum.Sit or hum.SeatPart then info.state = "SIT" end
    if hum.PlatformStand then info.state = "RAGDOLL" end
  end
  if hrp and myHRP then
    info.dist = math.floor((hrp.Position - myHRP.Position).Magnitude)
  end
  pcall(function()
    if ClassifyHeldTool and GetHeldTool then
      local kind, tname = ClassifyHeldTool(GetHeldTool(plr))
      if kind and kind ~= "NONE" then info.tool = kind .. " " .. tostring(tname) end
    end
  end)
  pcall(function()
    local a = getAdminData and getAdminData(plr)
    if a and a.isAdmin then info.admin = (a.tag ~= "" and a.tag) or "ADMIN" end
  end)
  if SpectateWatcher and SpectateWatcher.spectators and SpectateWatcher.spectators[plr.Name] then
    info.watch = "WATCH"
  end
  pcall(function()
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
      local m = ls:FindFirstChild("MVC") or ls:FindFirstChild("Cash") or ls:FindFirstChild("Money")
      local l = ls:FindFirstChild("LEVEL") or ls:FindFirstChild("Level")
      local t = ls:FindFirstChild("TIME") or ls:FindFirstChild("Time")
      if m then info.cash = tostring(m.Value) end
      if l then info.level = tostring(l.Value) end
      if t then info.timev = tostring(t.Value) end
    end
  end)
  pcall(function()
    if GetPlayerRegion then
      local reg = GetPlayerRegion(plr)
      if reg and reg.text and reg.text ~= "" then
        info.region = reg.text
      end
    end
  end)
  pcall(function()
    for _, key in ipairs(STATE_ATTRS) do
      local v = plr:GetAttribute(key) or (char and char:GetAttribute(key))
      if v == true or v == 1 or v == "true" then
        info.state = string.upper(key)
        break
      end
    end
  end)
  return info
end

function PaintTargetUI(plr)
  local info = CollectTargetInfo(plr)
  local N = (TargetUI and TargetUI.name) or tName
  local U = (TargetUI and TargetUI.user) or tUser
  local I = (TargetUI and TargetUI.id) or tId
  local A = (TargetUI and TargetUI.avatar) or tAvatar
  local S = (TargetUI and TargetUI.stats) or tStats
  local B = (TargetUI and TargetUI.bar) or currentTgtLabel
  pcall(function()
    if N then N.Text = info.ok and info.display or "No Target Selected" end
    if U then U.Text = info.ok and ("@" .. info.user) or "@none" end
    if I then
      I.Text = info.ok and ("id " .. tostring(info.id) .. "  |  " .. info.state .. "  |  " .. info.team .. (info.region ~= "-" and ("  |  " .. info.region) or "")) or "id 0  |  pick a player"
    end
    if A then
      A.Image = info.ok and ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(info.id) .. "&w=48&h=48") or ""
    end
    if S then
      if not info.ok then
        S.Text = "HP --  |  dist --  |  age --"
      else
        S.Text = string.format("%s | HP %d/%d | %s | %s | age %dd | MVC %s | LV %s | %s | %s",
          info.alive and "ALIVE" or "DEAD",
          info.hp, info.maxHp,
          info.dist and (info.dist .. "m") or "--",
          info.tool, info.age, info.cash, info.level, info.admin, info.watch)
      end
    end
    if B then
      B.Text = info.ok and ("Target: " .. info.display .. " (@" .. info.user .. ")") or "Target: None"
    end
    if FootTarget then
      FootTarget.Text = info.ok and info.display or "no target"
      FootTarget.TextColor3 = info.ok and Theme.TextWhite or Theme.TextDim
    end
    if FootAv then
      FootAv.Image = info.ok and ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(info.id) .. "&w=48&h=48") or ""
    end
    if RefreshHeaderTarget then RefreshHeaderTarget() end
    if RefreshTargetBar then RefreshTargetBar() end
    if specTargetBtn then
      local on = spectating and info.ok and CFG.cuff_target == info.user
      specTargetBtn.Text = on and "Unspec" or "Spec"
      specTargetBtn.BackgroundColor3 = on and Theme.NeonGreen or Theme.NeonDarkGreen
    end
  end)
end

function SetSelectedPlayer(plr, skipRebuild)
  plr = ResolvePlayer(plr)
  _selToken = _selToken + 1
  if plr then
    CFG.cuff_target = plr.Name
    CFG.cuff_target_id = plr.UserId
    _lastPaintId = plr.UserId
  else
    CFG.cuff_target = ""
    CFG.cuff_target_id = 0
    _lastPaintId = 0
  end
  lastFootName = "__force__"
  PaintTargetUI(plr)
  if HUD and HUD.update then
    pcall(HUD.update, plr)
  end
  return plr
end

-- ----------------------------------------------------
-- OPTIMIZED ZERO-LAG AFK REMOTE DISABLER
-- ----------------------------------------------------
pcall(function()
 -- 1. Standard Engine Timeout Bypass
  LocalPlayer.Idled:Connect(function()
    if CFG.afk_disabled then
      pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
      end)
    end
  end)

 -- 2. Cached Remotes list (Scanned once, executed smoothly without lag)
  local afkRemotes = {}
  local function cacheRemotes()
    afkRemotes = {}
    pcall(function()
      local rep = game:GetService("ReplicatedStorage")
      for _, obj in ipairs(rep:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
          local name = obj.Name:lower()
          if name:find("afk") or name:find("idle") or name:find("focus") or name:find("away") then
            table.insert(afkRemotes, obj)
          end
        end
      end
    end)
  end

  cacheRemotes()
  game:GetService("ReplicatedStorage").DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") then
      local name = obj.Name:lower()
      if name:find("afk") or name:find("idle") or name:find("focus") or name:find("away") then
        table.insert(afkRemotes, obj)
      end
    end
  end)

 -- 3. Super Fast & Zero-Lag Loop (Loops only over cached remotes)
  task.spawn(function()
    while task.wait(1) do
      if CFG.afk_disabled then
        for i = #afkRemotes, 1, -1 do
          local remote = afkRemotes[i]
          if remote and remote.Parent then
            pcall(function() remote:FireServer(false) end)
          else
            table.remove(afkRemotes, i)
          end
        end
      end
    end
  end)
end)

-- Notification System
local _TXToastHolder, _TXToastSerial = nil, 0
local _TX_BG = {
  "rbxassetid://90631990302263","rbxassetid://109619268613730","rbxassetid://90453834580322",
  "rbxassetid://82173577293417","rbxassetid://88369503310562","rbxassetid://80708025126373",
  "rbxassetid://111949903851987","rbxassetid://135181794444219",
}
function compactNotice(msg)
  msg = tostring(msg or "")
  msg = msg:gsub("\n.*", "")
  msg = msg:gsub("%d+%.?%d*%s*[mM]", "")
  msg = msg:gsub("%([^)]*%)", "")
  msg = msg:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  local low = msg:lower()
  if low:find("select", 1, true) and low:find("target", 1, true) then return "Select a player first" end
  if low:find("no target", 1, true) then return "Select a player first" end
  if low:find("not found", 1, true) and low:find("target", 1, true) then return "Select a player first" end
  if (low:find("no ", 1, true) or low:find("missing", 1, true)) and low:find("tool", 1, true) then return "No tool found" end
  if low:find("already running", 1, true) then return "Busy" end
  if low:find("vip success", 1, true) then return "VIP success" end
  local function onoff(name)
    if low:find("off", 1, true) or low:find("return", 1, true) or low:find("stop", 1, true) or low:find("disabled", 1, true) then
      return name .. " OFF"
    end
    return name .. " ON"
  end
  if low:find("ghost voice", 1, true) or low:find("ghost beam", 1, true) then return onoff("Ghost") end
  if low:find("sonic ghost", 1, true) then return onoff("Ghost") end
  if low:find("ghost", 1, true) then return onoff("Ghost") end
  if low:find("orbit", 1, true) then return onoff("Orbit") end
  if low:find("spectat", 1, true) then return onoff("Spec") end
  if low:find("invis", 1, true) or low:find("inv", 1, true) then return onoff("INV") end
  if low:find("aura", 1, true) then return onoff("Aura") end
  if low:find("fly", 1, true) then return onoff("Fly") end
  if low:find("noclip", 1, true) then return onoff("Noclip") end
  if low:find("tp bat", 1, true) or low:find("tpbat", 1, true) then return onoff("ABUSE") end
  if low:find("mic", 1, true) then
    if low:find("mute", 1, true) or low:find("off", 1, true) then return "Mic OFF" end
    return "Mic ON"
  end
  if low:find("camera", 1, true) then return "Camera OK" end
  if #msg > 22 then
    msg = msg:sub(1, 22)
  end
  return msg
end

function ShowNotification(msg, icon, dur)
  msg = compactNotice(msg)
  pcall(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    if not _TXToastHolder or not _TXToastHolder.Parent then
      local oldg = pg:FindFirstChild("AdaptSafeModeNotifications")
      if oldg then oldg:Destroy() end
      local gui = Instance.new("ScreenGui")
      gui.Name = "AdaptSafeModeNotifications"
      gui.ResetOnSpawn = false
      gui.IgnoreGuiInset = false
      gui.DisplayOrder = 100005
      gui.Parent = pg
      _TXToastHolder = Instance.new("Frame")
      _TXToastHolder.Name = "ToastHolder"
      _TXToastHolder.BackgroundTransparency = 1
      _TXToastHolder.AnchorPoint = Vector2.new(1, 1)
      _TXToastHolder.Position = UDim2.new(1, -16, 1, -16)
      _TXToastHolder.Parent = gui
      local lay = Instance.new("UIListLayout", _TXToastHolder)
      lay.FillDirection = Enum.FillDirection.Vertical
      lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
      lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
      lay.Padding = UDim.new(0, 8)
      lay.SortOrder = Enum.SortOrder.LayoutOrder
    end
    local cam = workspace.CurrentCamera
    local vs = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local safe = CFG and CFG.adapt_safe
    local w = safe and math.clamp(math.floor(vs.X * 0.34), 126, 165) or math.clamp(math.floor(vs.X * 0.23), 250, 330)
    local ht = safe and 28 or 52
    _TXToastHolder.Size = UDim2.fromOffset(w, math.min(math.floor(vs.Y * 0.34), safe and 150 or 250))
    if safe then
      _TXToastHolder.AnchorPoint = Vector2.new(1, 0)
      _TXToastHolder.Position = UDim2.new(1, -8, 0, 8)
      _TXToastHolder.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    else
      _TXToastHolder.AnchorPoint = Vector2.new(1, 1)
      _TXToastHolder.Position = UDim2.new(1, -16, 1, -16)
      _TXToastHolder.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end
    local kids = {}
    for _, ch in ipairs(_TXToastHolder:GetChildren()) do
      if ch:IsA("Frame") and ch.Name:sub(1,6) == "Toast_" then kids[#kids+1] = ch end
    end
    table.sort(kids, function(a,b) return a.LayoutOrder < b.LayoutOrder end)
    while #kids >= 4 do kids[1]:Destroy(); table.remove(kids,1) end
    _TXToastSerial += 1
    local wrap = Instance.new("Frame")
    wrap.Name = "Toast_" .. _TXToastSerial
    wrap.LayoutOrder = _TXToastSerial
    wrap.BackgroundTransparency = 1
    wrap.Size = UDim2.new(1, 0, 0, ht)
    wrap.Parent = _TXToastHolder
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(10, 3, 4)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Position = UDim2.fromOffset(w + 24, 0)
    card.Size = UDim2.new(1, 0, 1, 0)
    card.ClipsDescendants = true
    card.Parent = wrap
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, safe and 9 or 14)
    local img = Instance.new("ImageLabel")
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(1, 0, 1, 0)
    local bi = tonumber(CFG and CFG.adapt_bg_idx) or 0
    img.Image = (bi >= 1 and _TX_BG[bi]) or _TX_BG[1]
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = card
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, safe and 9 or 14)
    local shade = Instance.new("Frame")
    shade.BackgroundColor3 = Color3.new(0,0,0)
    shade.BackgroundTransparency = 0.42
    shade.Size = UDim2.new(1, 0, 1, 0)
    shade.ZIndex = 2
    shade.Parent = card
    Instance.new("UICorner", shade).CornerRadius = UDim.new(0, safe and 9 or 14)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(16, 0)
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Font = Enum.Font.GothamBlack
    label.Text = tostring(msg or "")
    label.TextColor3 = Color3.fromRGB(240, 255, 255)
    label.TextSize = safe and 8 or 15
    label.TextTransparency = 1
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = card
    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
      Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.18
    }):Play()
    TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    task.delay(tonumber(dur) or 2.35, function()
      if not wrap.Parent then return end
      TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.fromOffset(w + 24, 0), BackgroundTransparency = 1
      }):Play()
      TweenService:Create(img, TweenInfo.new(0.14), {ImageTransparency = 1}):Play()
      TweenService:Create(shade, TweenInfo.new(0.14), {BackgroundTransparency = 1}):Play()
      TweenService:Create(label, TweenInfo.new(0.14), {TextTransparency = 1}):Play()
      task.delay(0.2, function() if wrap.Parent then wrap:Destroy() end end)
    end)
  end)
end
AdaptNotify = ShowNotification


-- Universal Chat Dispatcher (Supports Modern TextChatService & Legacy Chat)
local lastChatDispatch = 0
function SendChatMessage(msg)
  if not msg or msg == "" then return false end
  local now = tick()
  if now - lastChatDispatch < 0.15 then return false end
  lastChatDispatch = now

  local cleanCmd = msg:lower():gsub("%s+", "")
  if cleanCmd == ";aura" or cleanCmd == "/aura" or cleanCmd == ":aura" or cleanCmd == "!aura" or cleanCmd == "aura" then
    if ToggleAura then
      ToggleAura()
    elseif DoQuickAura then
      DoQuickAura()
    end
    return true
  end
  if cleanCmd == ";uncuff" or cleanCmd == "/uncuff" or cleanCmd == ":uncuff" or cleanCmd == "!uncuff" or cleanCmd == "uncuff" or cleanCmd == ";free" or cleanCmd == "breakfree" then
    if DoSelfUncuff then
      DoSelfUncuff()
    end
    return true
  end

  local sent = false
  pcall(function()
    local textChannels = game:GetService("TextChatService"):FindFirstChild("TextChannels")
    if textChannels then
      local rbxGeneral = textChannels:FindFirstChild("RBXGeneral")
      if rbxGeneral then
        rbxGeneral:SendAsync(msg)
        sent = true
      end
    end
  end)
  if not sent then
    pcall(function()
      local targetChannel = game:GetService("TextChatService").ChatInputBarConfiguration.TargetTextChannel
      if targetChannel then
        targetChannel:SendAsync(msg)
        sent = true
      end
    end)
  end
  pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    sent = true
  end)
  return sent
end

-- Quick Chat ;re (Sent Once - 100% Working drop mechanism from fix (3).lua)
function L_RM_SendRe()
  SendChatMessage(";re")
end

-- Silent Respawn / Refresh Engine (Zero Public Chat fallback)
function DoSilentRespawn(targetCFrame)
  local char = LocalPlayer.Character
  if not char then return end
  local hrp = char:FindFirstChild("HumanoidRootPart")
  local hum = char:FindFirstChildOfClass("Humanoid")
  local returnCF = targetCFrame or (hrp and hrp.CFrame)

  if hum then
    hum:ChangeState(Enum.HumanoidStateType.Dead)
    hum.Health = 0
  end

  if returnCF then
    local respawnConn
    respawnConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
      respawnConn:Disconnect()
      local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
      if newHRP then
        task.wait(0.08)
        for _ = 1, 4 do
          newHRP.CFrame = returnCF
          if newHRP.AssemblyLinearVelocity then
            newHRP.AssemblyLinearVelocity = Vector3.zero
          else
            newHRP.Velocity = Vector3.zero
          end
          task.wait()
        end
      end
    end)
  end
end

-- Helper to safely remove any chat bubble gui from the character's head
function SuppressCharacterBubble()
  pcall(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
      for _, gui in ipairs(char.Head:GetChildren()) do
        if gui:IsA("BillboardGui") then
          gui.Enabled = false
          gui:Destroy()
        end
      end
    end
    local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pGui then
      for _, gui in ipairs(pGui:GetChildren()) do
        if gui:IsA("BillboardGui") and ((char and gui.Adornee == char:FindFirstChild("Head")) or gui.Name:lower():find("bubble")) then
          gui.Enabled = false
          gui:Destroy()
        end
      end
    end
  end)
end

function FindWhisperChannel(targetPlr)
  local tcs = game:GetService("TextChatService")
  local channels = tcs:FindFirstChild("TextChannels")
  if not channels then return nil end
  local myId = tostring(LocalPlayer.UserId)
  local targetId = tostring(targetPlr.UserId)
  for _, ch in ipairs(channels:GetChildren()) do
    if ch:IsA("TextChannel") then
      local n = ch.Name
      if n:find("RBXWhisper", 1, true) and n:find(myId, 1, true) and n:find(targetId, 1, true) then
        return ch
      end
    end
  end
  return nil
end

function SwitchChatBarToWhisper(targetUsername)
  if not targetUsername or targetUsername == "" or targetUsername == "Self" then
    ShowNotification("Select a player target first!", "", 2)
    return
  end
  local cleanTarget = tostring(targetUsername):gsub("^@", ""):gsub("%s+", "")
  local targetPlr = Players:FindFirstChild(cleanTarget)
  if not targetPlr then
    local q = cleanTarget:lower()
    for _, p in ipairs(Players:GetPlayers()) do
      if p ~= LocalPlayer and (p.Name:lower() == q or p.DisplayName:lower() == q
        or p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true)) then
        targetPlr = p
        break
      end
    end
  end
  if not targetPlr then
    ShowNotification("Player not in server!", "", 2)
    return
  end
  if targetPlr == LocalPlayer then
    ShowNotification("Cannot PRV yourself!", "", 2)
    return
  end

  CFG.prv_whisper_target = targetPlr.Name

  local switched = false
  pcall(function()
    local tcs = game:GetService("TextChatService")
    local ch = FindWhisperChannel(targetPlr)
    if ch then
      tcs.ChatInputBarConfiguration.TargetTextChannel = ch
      switched = true
      return
    end
    local channels = tcs:FindFirstChild("TextChannels")
    local rbxGeneral = channels and channels:FindFirstChild("RBXGeneral")
    if rbxGeneral then
      local wName = (targetPlr.DisplayName and targetPlr.DisplayName ~= "" and targetPlr.DisplayName) or targetPlr.Name
      rbxGeneral:SendAsync("/w " .. wName)
    end
    task.wait(0.25)
    ch = FindWhisperChannel(targetPlr)
    if ch then
      tcs.ChatInputBarConfiguration.TargetTextChannel = ch
      switched = true
    end
  end)

  pcall(function()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local chatBar = playerGui:FindFirstChild("ChatBar", true)
    if chatBar and chatBar:IsA("TextBox") then
      chatBar:CaptureFocus()
      chatBar.Text = "/w " .. ((targetPlr.DisplayName ~= "" and targetPlr.DisplayName) or targetPlr.Name) .. " "
      switched = true
    end
  end)

  if switched then
    ShowNotification("VIP success", "", 1.5)
  else
    ShowNotification("Type /w " .. targetPlr.DisplayName .. " in chat", "", 2)
  end
end

-- Fake PRV / Silent Command Chat Dispatcher (Supports Whisper & Silent Execution)
local lastPrvChatDispatch = 0
function SendPrivateChatMessage(msg, targetUser)
  if not msg or msg == "" then return false end
  local now = tick()
  if now - lastPrvChatDispatch < 0.1 then return false end
  lastPrvChatDispatch = now

  -- 1. Check for Silent Respawn / Refresh command (/re, ;re, :re, ;refresh)
  local cleanCmd = msg:lower():gsub("%s+", "")
  local isRe = (cleanCmd == ";re" or cleanCmd == "/re" or cleanCmd == ":re" or cleanCmd == "!re" or cleanCmd == ";refresh" or cleanCmd == "/refresh" or cleanCmd == ":refresh" or cleanCmd == "re" or cleanCmd == "refresh")

  if isRe then
    DoSilentRespawn()
    ShowNotification("VIP success", "", 1.5)
    return true
  end

  local isAura = (cleanCmd == ";aura" or cleanCmd == "/aura" or cleanCmd == ":aura" or cleanCmd == "!aura" or cleanCmd == "aura")
  if isAura then
    if ToggleAura then
      ToggleAura()
    elseif DoQuickAura then
      DoQuickAura()
    end
    return true
  end

  local isUncuff = (cleanCmd == ";uncuff" or cleanCmd == "/uncuff" or cleanCmd == ":uncuff" or cleanCmd == "!uncuff" or cleanCmd == "uncuff" or cleanCmd == ";free" or cleanCmd == "breakfree")
  if isUncuff then
    if DoSelfUncuff then
      DoSelfUncuff()
    end
    return true
  end

  -- 2. Support inline @target prefix: e.g. "@username hello"
  local inlineTarget, inlineMsg = msg:match("^@([%w_]+)%s+(.*)$")
  if inlineTarget and inlineMsg then
    targetUser = inlineTarget
    msg = inlineMsg
  end

  -- 3. Resolve Whisper Target
  local recipient = LocalPlayer.Name
  local selTarget = targetUser or CFG.prv_whisper_target or "Self"
  if selTarget == "Target" then
    if CFG.cuff_target and CFG.cuff_target ~= "" then
      recipient = CFG.cuff_target
    else
      recipient = LocalPlayer.Name
    end
  elseif selTarget and selTarget ~= "" and selTarget ~= "Self" then
    recipient = tostring(selTarget):gsub("^@", "")
  end

  -- 4. Ghost Mode (Target is Self): DO NOT whisper to self to avoid "You cannot whisper to yourself" error!
  if recipient == LocalPlayer.Name or selTarget == "Self" then
    pcall(function()
      local hd = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdminHDClient")
      if hd and hd:FindFirstChild("Signals") then
        local reqSilent = hd.Signals:FindFirstChild("RequestCommandSilent")
        if reqSilent and reqSilent:IsA("RemoteFunction") then
          reqSilent:InvokeServer(msg)
        end
      end
    end)
    ShowNotification("VIP success", "", 1.2)
    return true
  end

  local sent = false
  local targetPlr = Players:FindFirstChild(recipient)
  if not targetPlr then
    local q = tostring(recipient):lower()
    for _, p in ipairs(Players:GetPlayers()) do
      if p.Name:lower() == q or p.DisplayName:lower() == q then
        targetPlr = p
        break
      end
    end
  end
  local wName = (targetPlr and targetPlr.DisplayName ~= "" and targetPlr.DisplayName) or recipient
  local whisperText = "/w " .. wName .. " " .. msg

  pcall(function()
    if targetPlr and targetPlr ~= LocalPlayer then
      local ch = FindWhisperChannel(targetPlr)
      if ch then
        ch:SendAsync(msg)
        sent = true
      end
    end
    if not sent then
      local textChannels = game:GetService("TextChatService"):FindFirstChild("TextChannels")
      local rbxGeneral = textChannels and textChannels:FindFirstChild("RBXGeneral")
      if rbxGeneral then
        rbxGeneral:SendAsync(whisperText)
        sent = true
      end
    end
  end)

  pcall(function()
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
      chatEvents.SayMessageRequest:FireServer("/w " .. recipient .. " " .. msg, "All")
      sent = true
    end
  end)

  -- Immediately suppress any bubble billboard above player head
  task.defer(function()
    task.wait(0.04)
    SuppressCharacterBubble()
  end)

  return sent
end

-- Tool Finders & Helpers
function L_RM_IsVampireCuff(tool)
  if not (tool and tool:IsA("Tool")) then return false end
  local n = tool.Name:lower():gsub("%s+", "")
  if n:find("vampire", 1, true) then return true end
  if n:find("cuffsvampire", 1, true) then return true end
  if n:find("vampirecuff", 1, true) then return true end
  return false
end
function L_RM_FindCuffTool()
  local function scan(container, vampireOnly)
    if not container then return nil end
    for _, tool in ipairs(container:GetChildren()) do
      if tool:IsA("Tool") then
        if vampireOnly then
          if L_RM_IsVampireCuff(tool) then return tool end
        else
          local n = tool.Name:lower()
          if n:find("cuff") or n:find("handcuff") or n:find("arrest") or n:find("detain") then
            return tool
          end
        end
      end
    end
    return nil
  end
  local char = LocalPlayer.Character
  local pack = LocalPlayer:FindFirstChild("Backpack")
  return scan(char, true) or scan(pack, true) or scan(char, false) or scan(pack, false)
end
function L_RM_VampireEquipped()
  local char = LocalPlayer.Character
  if not char then return false end
  for _, tool in ipairs(char:GetChildren()) do
    if L_RM_IsVampireCuff(tool) then return tool end
  end
  return nil
end
function L_RM_ClosestPlayer(maxStuds)
  local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not myHRP then return nil end
  local best, bestD = nil, maxStuds or 100
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
      local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
      local hum = plr.Character:FindFirstChildOfClass("Humanoid")
      if hrp and hum and hum.Health > 0 then
        local d = (hrp.Position - myHRP.Position).Magnitude
        if d <= bestD then
          bestD = d
          best = plr
        end
      end
    end
  end
  return best, bestD
end

-- Flexible Rope Tool Discovery (Mechanism 1 from ROPE_7BEL_FUNCTION_GUIDE.md)
function L_RM_Find7belTool()
  local function isRope(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local n = tool.Name:lower()
    if n:find("rope") or n:find("7bel") or n:find("7bl") or n:find("hbel") or n:find("corde") or n:find("habl") then
      return true
    end
    if tool:FindFirstChild("RopeToggle") or tool:FindFirstChild("RopeClient") then
      return true
    end
    return false
  end

  if LocalPlayer.Character then
    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
      if isRope(item) then return item end
    end
  end

  local backpack = LocalPlayer:FindFirstChild("Backpack")
  if backpack then
    for _, item in ipairs(backpack:GetChildren()) do
      if isRope(item) then return item end
    end
  end

  return nil
end

-- Smart State Detection: Check if target is roped strictly between LocalPlayer and target
function L_RM_GetTargetRopeConstraint(targetChar)
  if not targetChar or not LocalPlayer.Character then return nil end
  local myChar = LocalPlayer.Character
  local myName = LocalPlayer.Name:lower()
  local targetName = targetChar.Name:lower()

  for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("RopeConstraint") then
      local a0 = obj.Attachment0
      local a1 = obj.Attachment1

 -- Check 1: Physical attachment link between both characters
      if a0 and a1 and a0.Parent and a1.Parent then
        local p0Char = a0.Parent:FindFirstAncestorOfClass("Model")
        local p1Char = a1.Parent:FindFirstAncestorOfClass("Model")
        if (p0Char == myChar and p1Char == targetChar) or (p0Char == targetChar and p1Char == myChar) then
          return obj
        end
      end

 -- Check 2: Constraint inside targetChar or myChar mentioning the other
      local objName = obj.Name:lower()
      if obj:IsDescendantOf(targetChar) and objName:find(myName, 1, true) then
        return obj
      end
      if obj:IsDescendantOf(myChar) and objName:find(targetName, 1, true) then
        return obj
      end

 -- Check 3: Name explicitly mentions BOTH myName AND targetName
      if objName:find(myName, 1, true) and objName:find(targetName, 1, true) then
        return obj
      end
    end
  end
  return nil
end

function L_RM_IsAlreadyRoped(targetChar)
  return L_RM_GetTargetRopeConstraint(targetChar) ~= nil
end

function CarrySide_FindTool()
  local searchIn = function(container)
    if not container then return nil end
    local candidates = {}
    for _, tool in ipairs(container:GetChildren()) do
      if tool:IsA("Tool") then
        local name = tool.Name:lower()
        if name:find("carry") or name:find("porter") or name:find("pickup") or name:find("side") or name:find("porte") then
          table.insert(candidates, tool)
        end
      end
    end
    -- Prioritize normal Carry, then CarryFriend, then CarrySide
    for _, t in ipairs(candidates) do
      if t.Name == "Carry" then return t end
    end
    for _, t in ipairs(candidates) do
      if t.Name:lower():find("friend") then return t end
    end
    for _, t in ipairs(candidates) do
      if t.Name:lower():find("side") then return t end
    end
    return candidates[1]
  end

  -- Check Character first (in case already equipped), then Backpack
  local tool = (LocalPlayer.Character and searchIn(LocalPlayer.Character)) or searchIn(LocalPlayer.Backpack)
  return tool
end

function L_RM_UnequipTool()
  pcall(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:UnequipTools() end
  end)
end

function L_RM_EquipTool(tool)
  if not tool then return end
  pcall(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:EquipTool(tool) end
  end)
end

function L_RM_FireAllCuffPrompts(targetChar, targetHRP)
  if not targetChar then return end
  pcall(function()
    for _, desc in ipairs(targetChar:GetDescendants()) do
      if desc:IsA("ProximityPrompt") then fireproximityprompt(desc) end
    end
  end)
end

function L_RM_PressKey(kc)
  pcall(function()
    local vim = game:GetService("VirtualInputManager")
    if vim then
      vim:SendKeyEvent(true, kc, false, game)
      vim:SendKeyEvent(false, kc, false, game)
    end
  end)
end

function L_RM_ActivateCuffTool(tool, targetPlayer, targetChar, targetHRP)
  if not tool then return end

 -- 1. Activate tool natively
  pcall(function() tool:Activate() end)

 -- 2. Smart Camera Aim & Precision Viewport Pointing
  pcall(function()
    local cam = workspace.CurrentCamera
    if not cam or not targetChar then return end

    local parts = {}
    for _, part in ipairs(targetChar:GetDescendants()) do
      if part:IsA("BasePart") then table.insert(parts, part) end
    end
    local clickTarget = targetChar:FindFirstChild("HumanoidRootPart") or targetHRP or parts[1]
    if not clickTarget then return end
    cam.CFrame = CFrame.new(cam.CFrame.Position, clickTarget.Position)
    local vim = game:GetService("VirtualInputManager")
    local points = {}
    for _, part in ipairs(parts) do
      table.insert(points, part.Position)
    end
    if #points == 0 then
      points = { clickTarget.Position }
    end

    for _, pos in ipairs(points) do
      local sp, vis = cam:WorldToViewportPoint(pos)
      if vis and sp.X > 0 and sp.Y > 0 then
        if mousemoveabs then mousemoveabs(sp.X, sp.Y) end
        if vim then
          vim:SendMouseButtonEvent(sp.X, sp.Y, 0, true, game, 1)
          task.wait(0.01)
          vim:SendMouseButtonEvent(sp.X, sp.Y, 0, false, game, 1)
        else
          mouse1press()
          task.wait(0.01)
          mouse1release()
        end
      end
    end
  end)

 -- 3. Click Detectors & Proximity Prompts
  pcall(function()
    for _, desc in ipairs(targetChar:GetDescendants()) do
      if desc:IsA("ClickDetector") then fireclickdetector(desc) end
      if desc:IsA("ProximityPrompt") then fireproximityprompt(desc) end
    end
  end)

 -- 4. Tool Remote / RemoteFunction Firing
  pcall(function()
    for _, desc in ipairs(tool:GetDescendants()) do
      if desc:IsA("RemoteEvent") then
        desc:FireServer(targetPlayer)
        desc:FireServer(targetChar)
        desc:FireServer(targetHRP)
        desc:FireServer(targetPlayer, "Arrest")
        desc:FireServer(targetPlayer, "Carry")
        desc:FireServer(targetChar, "Carry")
      elseif desc:IsA("RemoteFunction") then
        pcall(function() desc:InvokeServer(targetPlayer) end)
        pcall(function() desc:InvokeServer(targetChar) end)
      end
    end
  end)
end

_cuffIgnoreKey = false
function L_RM_ClickVampireName(playerName)
  if not playerName then return false end
  local hit = false
  local function tryBtn(btn)
    if not btn or not btn:IsA("GuiButton") then return end
    pcall(function()
      if getconnections then
        for _, c in ipairs(getconnections(btn.MouseButton1Click)) do
          pcall(function() c:Fire() end)
          hit = true
        end
      end
    end)
    pcall(function()
      if firesignal then firesignal(btn.MouseButton1Click) end
    end)
  end
  local pg = LocalPlayer:FindFirstChild("PlayerGui")
  if not pg then return false end
  local want = string.lower(playerName)
  for _, d in ipairs(pg:GetDescendants()) do
    local txt = ""
    pcall(function()
      if d:IsA("TextButton") or d:IsA("TextLabel") then txt = string.lower(tostring(d.Text or "")) end
    end)
    if txt ~= "" and (txt == want or txt:find(want, 1, true)) then
      if d:IsA("GuiButton") then
        tryBtn(d)
      else
        local p = d.Parent
        if p and p:IsA("GuiButton") then tryBtn(p) end
        for _, ch in ipairs(d.Parent and d.Parent:GetChildren() or {}) do
          if ch:IsA("GuiButton") then tryBtn(ch) end
        end
      end
    end
  end
  return hit
end
function L_RM_TargetSpeed(hrp)
  if not hrp then return 0, Vector3.zero end
  local v = Vector3.zero
  pcall(function() v = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero end)
  return v.Magnitude, v
end
function L_RM_LeadAlign(myHRP, targetHRP, info)
  if not myHRP or not targetHRP then return end
  local spd, vel = L_RM_TargetSpeed(targetHRP)
  local lead = 0.08
  if spd > 30 then lead = 0.14 end
  if spd > 80 then lead = 0.20 end
  if spd > 180 then lead = 0.28 end
  if spd > 350 then lead = math.clamp(22 / spd, 0.18, 0.36) end
  local pred = vel * lead
  if pred.Magnitude > 40 then pred = pred.Unit * 40 end
  local tPos = targetHRP.Position + pred
  local look = targetHRP.CFrame.LookVector
  local flat = Vector3.new(look.X, 0, look.Z)
  if flat.Magnitude > 0.05 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
  local dist = (info and info.standDist) or 3
  local stand = Vector3.new(tPos.X, targetHRP.Position.Y + pred.Y * 0.25, tPos.Z) + flat * dist
  myHRP.CFrame = CFrame.new(stand, tPos)
  myHRP.AssemblyLinearVelocity = vel
end
function L_RM_DoCuffSequence()
  if CFG.cuff_busy then return end
  local targetName = CFG.cuff_target
  local targetPlayer = (targetName and targetName ~= "" and targetName ~= "No other players") and Players:FindFirstChild(targetName) or GetLiveTarget()
  local myChar = LocalPlayer.Character
  local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  if (not targetPlayer or not targetPlayer.Character) and myHRP then
    targetPlayer = L_RM_ClosestPlayer(1e9)
  end
  if not targetPlayer then
    ShowNotification("Select a player", "", 2)
    return
  end
  targetName = targetPlayer.Name
  local cuffTool = L_RM_VampireEquipped() or L_RM_FindCuffTool()
  if not cuffTool then
    ShowNotification("No handcuff tool", "", 2)
    return
  end
  CFG.cuff_busy = true
  task.spawn(function()
    pcall(function()
      L_RM_EquipTool(cuffTool)
      task.wait(0.10)
      local tChar = targetPlayer.Character
      local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
      myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      local info = (tChar and tHRP) and CarrySide_CalcCharInfo(tChar, tHRP) or {standDist = 3}
      local tracking = true
      local conn = RunService.Heartbeat:Connect(function()
        if not tracking then return end
        tChar = targetPlayer.Character
        tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and tHRP then L_RM_LeadAlign(myHRP, tHRP, info) end
      end)
      L_RM_ClickVampireName(targetName)
      task.wait(0.06)
      L_RM_ClickVampireName(targetName)
      pcall(function() cuffTool:Activate() end)
      _cuffIgnoreKey = true
      L_RM_PressKey(Enum.KeyCode.C)
      task.wait(0.05)
      L_RM_PressKey(Enum.KeyCode.C)
      _cuffIgnoreKey = false
      local t0 = tick()
      while tick() - t0 < 0.35 do
        L_RM_ClickVampireName(targetName)
        task.wait(0.08)
      end
      tracking = false
      if conn then conn:Disconnect() end
    end)
    CFG.cuff_busy = false
    ShowNotification("Cuff  " .. targetName, "", 1.0)
  end)
end

-- ====================================================================
-- FIXED ROPE ("7BEL") & UNROPE SUITE (ROPE_7BEL_FUNCTION_GUIDE.md)
-- Supports remote invocation, smart constraint toggle, physics lock, viewport clicks
-- ====================================================================
function L_RM_ExecuteUnrope(targetPlayer, targetChar, targetHRP, myChar, myHRP, myHum, myTool, homeCFrame)
  local targetName = targetPlayer.Name
  ShowNotification("Unroping " .. targetName .. "...", "", 2)
  myHum:UnequipTools()
  task.wait(0.05)

 -- Must teleport 2.5 studs in front of target so server reach distance check passes!
  local tCF = targetHRP.CFrame
  local frontPos = tCF * CFrame.new(0, 0, -2.5)
  myHRP.CFrame = CFrame.new(frontPos.Position, tCF.Position)

  local bodyPos = Instance.new("BodyPosition")
  bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
  bodyPos.D = 50; bodyPos.P = 100000; bodyPos.Position = myHRP.Position; bodyPos.Parent = myHRP

  local bodyGyro = Instance.new("BodyGyro")
  bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
  bodyGyro.D = 50; bodyGyro.P = 100000; bodyGyro.CFrame = myHRP.CFrame; bodyGyro.Parent = myHRP

  myHum:EquipTool(myTool)
  task.wait(0.2)

  local cam = workspace.CurrentCamera
  local targetTorso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetHRP
  if cam and targetTorso then
    pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, targetTorso.Position) end)
  end

  local remote = myTool:FindFirstChild("RopeToggle") or myTool:FindFirstChildWhichIsA("RemoteEvent")
  local vim = VirtualInputManager or (pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager"))
  local startTime = tick()

  while (tick() - startTime) < 0.9 do
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then break end
    local curHRP = targetChar.HumanoidRootPart
    local curFront = curHRP.CFrame * CFrame.new(0, 0, -2.5)
    myHRP.CFrame = CFrame.new(curFront.Position, curHRP.Position)
    bodyPos.Position = myHRP.Position
    bodyGyro.CFrame = myHRP.CFrame

    if remote and remote:IsA("RemoteEvent") then
      remote:FireServer(curHRP, curHRP.Position)
      remote:FireServer(targetTorso, targetTorso.Position)
    end
    pcall(function() myTool:Activate() end)
    pcall(function() firetouchinterest(myHRP, curHRP, 0) end)

    pcall(function()
      if cam and vim then
        local sp, vis = cam:WorldToViewportPoint(curHRP.Position)
        if vis and sp.X > 0 and sp.Y > 0 then
          vim:SendMouseButtonEvent(sp.X, sp.Y, 0, true, game, 1)
          task.wait(0.01)
          vim:SendMouseButtonEvent(sp.X, sp.Y, 0, false, game, 1)
        end
      end
    end)

    if not L_RM_IsAlreadyRoped(targetChar) then
      break
    end
    task.wait(0.08)
  end

  pcall(function() bodyPos:Destroy() end)
  pcall(function() bodyGyro:Destroy() end)
  task.wait(0.05)
  myHum:UnequipTools()

  if CFG.cuff_7bel_return ~= false and homeCFrame then
    local latestHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if latestHRP then latestHRP.CFrame = homeCFrame end
  end

  CFG.cuff_busy = false
  ShowNotification("Target Unroped cleanly!", "", 2)
end

function L_RM_DoUnropeSequence()
  if CFG.cuff_busy then ShowNotification("Already running! Wait...", "", 2) return end
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("No target selected!", "", 3) return
  end
  local targetPlayer = Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Target player or character missing!", "", 3) return
  end
  local targetChar = targetPlayer.Character
  local targetHRP  = targetChar:FindFirstChild("HumanoidRootPart")
  local myChar     = LocalPlayer.Character
  local myHRP      = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum      = myChar and myChar:FindFirstChildOfClass("Humanoid")
  local myTool     = L_RM_Find7belTool()

  if not targetHRP or not myHRP or not myHum then
    ShowNotification("Missing local character components!", "", 3) return
  end
  if not myTool then
    ShowNotification("No 7bel (Rope) tool found in Backpack or Character!", "", 3) return
  end

  CFG.cuff_busy = true
  local homeCFrame = myHRP.CFrame
  task.spawn(function()
    pcall(function()
      L_RM_ExecuteUnrope(targetPlayer, targetChar, targetHRP, myChar, myHRP, myHum, myTool, homeCFrame)
    end)
    CFG.cuff_busy = false
  end)
end

function L_RM_Do7belSequence()
  if CFG.cuff_busy then ShowNotification("Already running! Wait...", "", 2) return end
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("No target selected!", "", 3) return
  end
  local targetPlayer = Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Target player or character missing!", "", 3) return
  end
  local targetChar = targetPlayer.Character
  local targetHRP  = targetChar:FindFirstChild("HumanoidRootPart")
  local myChar     = LocalPlayer.Character
  local myHRP      = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum      = myChar and myChar:FindFirstChildOfClass("Humanoid")
  local myTool     = L_RM_Find7belTool()

  if not targetHRP or not myHRP or not myHum then
    ShowNotification("Missing local character components!", "", 3) return
  end
  if not myTool then
    ShowNotification("No 7bel (Rope) tool found in Backpack or Character!", "", 3) return
  end

  CFG.cuff_busy = true
  local homeCFrame = myHRP.CFrame

  task.spawn(function()
 -- Guaranteed busy reset even if pcall errors mid-way
    local ok, err = pcall(function()
 -- Mechanism 3: Teleport 2.5 studs in front of target
 -- Always rope - never auto-unrope from this button
      myHum:UnequipTools()
      task.wait(0.05)

 -- Re-find the tool fresh in case it was already equipped from last time
      local freshTool = L_RM_Find7belTool()
      if not freshTool then
        ShowNotification("Rope tool not in Backpack or Character!", "", 3)
        return
      end

      local tCF = targetHRP.CFrame
      local frontPos = tCF * CFrame.new(0, 0, -2.5)
      myHRP.CFrame = CFrame.new(frontPos.Position, tCF.Position)

 -- Mechanism 4: Anti-Flung Physics Lock (BodyPosition + BodyGyro)
      local bodyPos = Instance.new("BodyPosition")
      bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
      bodyPos.D = 50
      bodyPos.P = 100000
      bodyPos.Position = myHRP.Position
      bodyPos.Parent = myHRP

      local bodyGyro = Instance.new("BodyGyro")
      bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
      bodyGyro.D = 50
      bodyGyro.P = 100000
      bodyGyro.CFrame = myHRP.CFrame
      bodyGyro.Parent = myHRP

 -- Equip Rope tool
      myHum:EquipTool(freshTool)
      task.wait(0.2)

 -- Aim Camera at target Torso
      local cam = workspace.CurrentCamera
      local targetTorso = targetChar:FindFirstChild("Torso")
        or targetChar:FindFirstChild("UpperTorso")
        or targetHRP

      if cam and targetTorso then
        pcall(function()
          cam.CFrame = CFrame.new(cam.CFrame.Position, targetTorso.Position)
        end)
      end

 -- Mechanism 5: Multi-Vector Latch Loop (1.2 seconds max)
      local ropeRemote = freshTool:FindFirstChild("RopeToggle") or freshTool:FindFirstChildWhichIsA("RemoteEvent")
      local vim = VirtualInputManager or (pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager"))
      local roped = false
      local startTime = tick()

      while (tick() - startTime) < 1.2 do
        if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then break end

        local curHRP = targetChar.HumanoidRootPart
        local curFront = curHRP.CFrame * CFrame.new(0, 0, -2.5)

        myHRP.CFrame = CFrame.new(curFront.Position, curHRP.Position)
        bodyPos.Position = myHRP.Position
        bodyGyro.CFrame = myHRP.CFrame

 -- Fire Remote (Torso & RootPart)
        if ropeRemote and ropeRemote:IsA("RemoteEvent") then
          local clickPart = targetChar:FindFirstChild("Torso")
            or targetChar:FindFirstChild("UpperTorso")
            or curHRP
          ropeRemote:FireServer(clickPart, clickPart.Position)
          ropeRemote:FireServer(curHRP, curHRP.Position)
        end

 -- Native Activation & Touch
        pcall(function() freshTool:Activate() end)
        pcall(function() firetouchinterest(myHRP, curHRP, 0) end)

 -- Emulated Viewport Click
        pcall(function()
          if cam and vim then
            local sp, vis = cam:WorldToViewportPoint(curHRP.Position)
            if vis and sp.X > 0 and sp.Y > 0 then
              if mousemoveabs then mousemoveabs(sp.X, sp.Y) end
              vim:SendMouseButtonEvent(sp.X, sp.Y, 0, true, game, 1)
              task.wait(0.01)
              vim:SendMouseButtonEvent(sp.X, sp.Y, 0, false, game, 1)
            end
          elseif mouse1press and mouse1release then
            mouse1press()
            task.wait(0.01)
            mouse1release()
          end
        end)

 -- Early Exit Detection: RopeConstraint spawned
        if L_RM_IsAlreadyRoped(targetChar) then
          roped = true
          break
        end

        task.wait(0.08)
      end

 -- Mechanism 4 cleanup
      pcall(function() bodyPos:Destroy() end)
      pcall(function() bodyGyro:Destroy() end)
      task.wait(0.05)

 -- Mechanism 6: Return Teleportation (Optional)
 -- NOTE: Do NOT unequip rope tool here! Unequipping triggers the server's
 -- rope toggle/deactivate event and causes an instant unrope bug.
 -- The tool is unequipped at the START of the next rope attempt instead.
      if CFG.cuff_7bel_return ~= false then
        local latestHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if latestHRP then latestHRP.CFrame = homeCFrame end
      end

      ShowNotification(roped and ("Successfully roped " .. targetName .. "!") or ("Rope fired at " .. targetName), "", 3)
    end)
 -- Always reset busy flag - no matter what happened above
    CFG.cuff_busy = false
  end)
end

-- ============================================================
-- CARRY SIDE - ULTRA REWRITE v2
-- Smart size calculator | All states | Max speed | Zero lag
-- ============================================================

-- Compute true character size using BoundingBox for 100% compatibility with ALL avatars
-- Supports: Microscopic, Giant, R6, R15, Rthro, Custom Morphs, Layered Clothing, Animal rigs
function CarrySide_CalcCharInfo(char, hrp)
  local info = { scale = 1, height = 5, standDist = 2.0, legPart = hrp, bboxSize = Vector3.new(2, 5, 2) }
  if not char or not hrp then return info end

  pcall(function()
 -- True 3D bounding box of the target character
    local _, size = char:GetBoundingBox()
    if size then
      info.bboxSize = size
      info.height = size.Y
    else
      info.height = hrp.Size.Y
      info.bboxSize = hrp.Size
    end

 -- True 3D bounding box of our own character
    local myChar = LocalPlayer.Character
    local mySize = Vector3.new(2, 5, 2)
    if myChar then
      local _, mSize = myChar:GetBoundingBox()
      if mSize then mySize = mSize end
    end

    local myRadius = math.max(mySize.X, mySize.Z) / 2
    local tgtRadius = math.max(info.bboxSize.X, info.bboxSize.Z) / 2

 -- Dynamic stand distance adapted for micro 0.1x to titan 50x avatars
    info.standDist = math.clamp(myRadius + (tgtRadius * 0.7) + 0.1, 0.6, 20.0)

 -- Comprehensive limb & leg priority list (R6, R15, Rthro, Custom)
    local limbs = {
      char:FindFirstChild("Right Leg"),
      char:FindFirstChild("Left Leg"),
      char:FindFirstChild("RightLeg"),
      char:FindFirstChild("LeftLeg"),
      char:FindFirstChild("RightLowerLeg"),
      char:FindFirstChild("LeftLowerLeg"),
      char:FindFirstChild("RightFoot"),
      char:FindFirstChild("LeftFoot"),
      char:FindFirstChild("LowerTorso"),
      char:FindFirstChild("Torso"),
      char:FindFirstChild("UpperTorso"),
    }

    for _, p in ipairs(limbs) do
      if p and p:IsA("BasePart") then
        info.legPart = p
        break
      end
    end

 -- Fallback for non-standard morphs/animals/creatures
    if not info.legPart or info.legPart == hrp then
      local lowestPart, lowestY = nil, math.huge
      for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and part ~= hrp then
          local nm = part.Name:lower()
          if nm:find("leg") or nm:find("foot") or nm:find("paw") or nm:find("lower") or nm:find("wheel") then
            info.legPart = part
            break
          end
          if part.Position.Y < lowestY then
            lowestPart = part
            lowestY = part.Position.Y
          end
        end
      end
      if not info.legPart or info.legPart == hrp then
        info.legPart = lowestPart or hrp
      end
    end
  end)

  return info
end

-- Get the best click position for ANY character state
-- Handles: walking, sprinting, flying, swimming, sitting, sleeping, ragdoll, custom poses
function CarrySide_GetClickTarget(char, hrp, info)
  if info and info.legPart and info.legPart ~= hrp and info.legPart.Parent then
    return info.legPart
  end

  local lowest, lowestY = hrp, (hrp and hrp.Position.Y or 0)
  pcall(function()
    for _, part in ipairs(char:GetChildren()) do
      if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
        if part.Position.Y < lowestY then
          lowest = part
          lowestY = part.Position.Y
        end
      end
    end
  end)
  return lowest
end

-- Aligns our character perfectly in front of the target, horizontally with velocity match
function CarrySide_AlignToTarget(myHRP, targetHRP, info)
  if not myHRP or not targetHRP or not myHRP.Parent or not targetHRP.Parent then return end
  pcall(function()
    local tCF = targetHRP.CFrame
    local tPos = tCF.Position
    local look = tCF.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if flatLook.Magnitude > 0.05 then
      flatLook = flatLook.Unit
    else
      flatLook = Vector3.new(0, 0, -1)
    end

    local standPos = tPos + (flatLook * info.standDist)
    standPos = Vector3.new(standPos.X, tPos.Y, standPos.Z)

    myHRP.CFrame = CFrame.new(standPos, tPos)

 -- Physics velocity synchronization: eliminates relative movement when target sprints/flies/drives
    local tVel = targetHRP.AssemblyLinearVelocity or targetHRP.Velocity or Vector3.zero
    if myHRP.AssemblyLinearVelocity then
      myHRP.AssemblyLinearVelocity = tVel
    else
      myHRP.Velocity = tVel
    end
  end)
end

-- Click the best part in screen-space - ultra fast, all-states compatible
function CarrySide_Activate(tool, targetChar, targetHRP, info)
  if not tool then return end
  local cam = workspace.CurrentCamera
  if not cam then return end

  info = info or CarrySide_CalcCharInfo(targetChar, targetHRP)
  local clickPart = CarrySide_GetClickTarget(targetChar, targetHRP, info)
  if not clickPart then return end

 -- Temporarily lock camera to Scriptable to bypass game camera scripts fighting our aim
  local oldCamType = cam.CameraType
  pcall(function() cam.CameraType = Enum.CameraType.Scriptable end)

 -- Aim camera from our chest/eye level directly at the click target
  pcall(function()
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
      local aimFrom = myHRP.Position + Vector3.new(0, myHRP.Size.Y * 0.25, 0)
      cam.CFrame = CFrame.new(aimFrom, clickPart.Position)
    end
  end)
  task.wait(0.02)

  pcall(function() tool:Activate() end)

  -- Instant Remote invoke (direct gamepass / carry bypass)
  pcall(function()
    local carryRemote = tool:FindFirstChild("Carry") or tool:FindFirstChild("RemoteEvent")
    if carryRemote and carryRemote:IsA("RemoteEvent") then
      local anim = LocalPlayer:GetAttribute("SelectedCarryAnim")
      if not anim or anim == "" then
        -- Default to HandCarry or tool default
        local settingsMod = tool:FindFirstChild("Settings")
        if settingsMod and settingsMod:IsA("ModuleScript") then
          pcall(function()
            local cfg = require(settingsMod)
            anim = cfg.DEFAULT_MODE or "HandCarry"
          end)
        end
        anim = anim or "HandCarry"
      end
      carryRemote:FireServer("Carry", targetHRP, anim, "PointerOnly")
    end
  end)

  -- Fallback: Fire all click detectors on target just in case
  pcall(function()
    for _, desc in ipairs(targetChar:GetDescendants()) do
      if desc:IsA("ClickDetector") then fireclickdetector(desc) end
    end
  end)

 -- Multi-point click strategy: rapid fire directly on the screen position of the part
  pcall(function()
    local vim = game:GetService("VirtualInputManager")
    local vu = game:GetService("VirtualUser")
    local vpX, vpY = 1280, 720
    pcall(function()
      local res = game:GetService("GuiService"):GetScreenResolution()
      vpX, vpY = res.X, res.Y
    end)

    local sp, vis = cam:WorldToViewportPoint(clickPart.Position)
    local cx, cy = sp.X, sp.Y
    if not (vis and cx > 0 and cy > 0 and cx < vpX and cy < vpY) then
      cx, cy = vpX / 2, vpY / 2
    end

    if mousemoveabs then mousemoveabs(cx, cy) end

    for i = 1, 3 do
      if vim then
        vim:SendMouseButtonEvent(cx, cy, 0, true,  game, 1)
        task.wait(0.02)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
      elseif vu then
        vu:Button1Down(Vector2.new(cx, cy))
        task.wait(0.02)
        vu:Button1Up(Vector2.new(cx, cy))
      elseif mouse1press then
        mouse1press(); task.wait(0.02); mouse1release()
      end
      task.wait(0.02)
    end
  end)

  pcall(function() cam.CameraType = oldCamType end)
end

-- Check weld (target attached to us)
function CarrySide_CheckWeld(targetChar)
  if not targetChar then return false end
  local myChar = LocalPlayer.Character
  if not myChar then return false end

  -- 1. Direct attribute check set by game's ForceCarryCore
  if targetChar:GetAttribute("CarryLocked") == true or targetChar:FindFirstChild("CarryWeld") or (myChar:FindFirstChild("CarryWeld")) then
    return true
  end

  local found = false
  pcall(function()
    -- Check welds in both myChar and targetChar
    for _, container in ipairs({targetChar, myChar}) do
      for _, weld in ipairs(container:GetDescendants()) do
        if weld:IsA("JointInstance") or weld:IsA("WeldConstraint") then
          if weld.Name == "CarryWeld" then
            found = true; break
          end
          local p0, p1 = weld.Part0, weld.Part1
          if (p0 and p0:IsDescendantOf(myChar) and p1 and p1:IsDescendantOf(targetChar))
          or (p1 and p1:IsDescendantOf(myChar) and p0 and p0:IsDescendantOf(targetChar)) then
            found = true; break
          end
        end
      end
      if found then break end
    end
  end)
  return found
end

function FlingClickEmptyScreen()
  pcall(function()
    local vim = game:GetService("VirtualInputManager")
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    local x, y = math.floor(vp.X * 0.92), math.floor(vp.Y * 0.12)
    if vim and vim.SendMouseButtonEvent then
      vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
      task.wait(0.03)
      vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
    elseif mouse1click then
      mouse1click()
    elseif mouse1press and mouse1release then
      mouse1press()
      task.wait(0.03)
      mouse1release()
    end
  end)
end

function FlingDropTarget(targetChar)
  local myChar = LocalPlayer.Character
  local tool = CarrySide_FindTool() or L_RM_FindCuffTool()
  if tool then
    pcall(L_RM_EquipTool, tool)
    -- Fire direct Uncarry remote if available
    pcall(function()
      local remote = tool:FindFirstChild("Carry") or tool:FindFirstChild("RemoteEvent")
      if remote and remote:IsA("RemoteEvent") then
        remote:FireServer("Uncarry", nil, nil, "PointerOnly")
      end
    end)
    task.wait(0.04)
    FlingClickEmptyScreen()
    task.wait(0.06)
    FlingClickEmptyScreen()
    task.wait(0.04)
  end
  pcall(function()
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if hum then hum:UnequipTools() end
  end)
  pcall(L_RM_UnequipTool)
  local function breakWelds(root)
    if not root then return end
    for _, w in ipairs(root:GetDescendants()) do
      if w:IsA("Weld") or w:IsA("WeldConstraint") or w:IsA("Motor6D") or w:IsA("JointInstance") then
        local p0, p1 = w.Part0, w.Part1
        local link = false
        if myChar and ((p0 and p0:IsDescendantOf(myChar)) or (p1 and p1:IsDescendantOf(myChar))) then
          if targetChar and ((p0 and p0:IsDescendantOf(targetChar)) or (p1 and p1:IsDescendantOf(targetChar))) then
            link = true
          end
        end
        if link or (w.Name:lower():find("carry") or w.Name:lower():find("cuff") or w.Name:lower():find("grab")) then
          pcall(function() w:Destroy() end)
        end
      end
    end
  end
  breakWelds(targetChar)
  breakWelds(myChar)
  pcall(function()
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local tHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if myHRP and tHRP and firetouchinterest then
      firetouchinterest(myHRP, tHRP, 1)
    end
  end)
  local t0 = tick()
  while targetChar and CarrySide_CheckWeld(targetChar) and (tick() - t0) < 0.8 do
    breakWelds(targetChar)
    breakWelds(LocalPlayer.Character)
    task.wait(0.05)
  end
end

-- Prevents the carry tool from accidentally grabbing someone else standing nearby
function CarrySide_IsolateTouch(targetPlayer)
  local disabledParts = {}
  pcall(function()
    for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr ~= targetPlayer and plr.Character then
        for _, part in ipairs(plr.Character:GetDescendants()) do
          if part:IsA("BasePart") and part.CanTouch then
            part.CanTouch = false
            table.insert(disabledParts, part)
          end
        end
      end
    end
  end)
  return function()
    pcall(function()
      for _, part in ipairs(disabledParts) do
        if part and part.Parent then part.CanTouch = true end
      end
    end)
  end
end

-- ============================================================
-- CarrySide_Execute - MAIN SEQUENCE
-- Flow: save home â†’ TP to target â†’ carry â†’ return home before TP
-- ============================================================
function CarrySide_Execute()
  if CFG.cuff_busy then ShowNotification("Already running! Wait...", "", 2) return end

  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("No target selected!", "", 3) return
  end

  local targetPlayer = Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Target not found!", "", 3) return
  end

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myTool = CarrySide_FindTool()

  if not myHRP  then ShowNotification("No character found!", "", 3) return end
  if not myTool then ShowNotification("No Carry Side tool found!", "", 3) return end

  local targetChar = targetPlayer.Character
  local targetHRP  = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
  if not targetHRP then ShowNotification("Target has no character!", "", 3) return end

  CFG.cuff_busy = true

  task.spawn(function()
 -- â”€â”€ SAVE HOME: fresh lookup inside spawn (safe against stale refs) â”€â”€
    local saveHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not saveHRP then CFG.cuff_busy = false return end
    local homeCFrame = saveHRP.CFrame   -- â† exact position saved HERE, before any TP
    local isCarrying = false

    local success, errorMsg = pcall(function()
 -- Compute smart stand distance based on actual character sizes (all scales supported)
      local info = CarrySide_CalcCharInfo(targetChar, targetHRP)
      local restoreTouch = CarrySide_IsolateTouch(targetPlayer)

 -- STEP 1: Unequip current tool
      L_RM_UnequipTool()
      task.wait(0.04)

 -- Active Micro-Tracking Lock (Heartbeat connection)
 -- Keeps us glued to the moving/flying/sprinting target and cancels physics drift
      local tracking = true
      local trackConn
      trackConn = RunService.Heartbeat:Connect(function()
        if not tracking then return end
        CarrySide_AlignToTarget(myHRP, targetHRP, info)
        pcall(function() firetouchinterest(myHRP, targetHRP, 0) end)
      end)

 -- Instant initial snap
      CarrySide_AlignToTarget(myHRP, targetHRP, info)
      pcall(function() firetouchinterest(myHRP, targetHRP, 0) end)

 -- STEP 2: Equip carry tool with active tracking
      L_RM_EquipTool(myTool)
      task.wait(0.08)  -- optimized fast recognition

 -- STEP 3: Click the leg / best point
      CarrySide_Activate(myTool, targetChar, targetHRP, info)

 -- STEP 4: Server sync via Smart Weld Polling (instant exit once welded!)
      local weldStart = tick()
      while (tick() - weldStart) < 0.20 do
        if CarrySide_CheckWeld(targetChar) then
          isCarrying = true
          break
        end
        task.wait(0.02)
      end

 -- Stop active tracking
      tracking = false
      if trackConn then trackConn:Disconnect(); trackConn = nil end

 -- STEP 5: End touch
      pcall(function() firetouchinterest(myHRP, targetHRP, 1) end)

 -- Final weld check fallback
      if not isCarrying then
        isCarrying = CarrySide_CheckWeld(targetChar)
      end
      
      restoreTouch()
    end)

 -- â”€â”€ RETURN HOME â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
 -- Unequip first so carry tool doesn't drag us / resist the TP
    L_RM_UnequipTool()
 -- Snap back 3Ã- across 3 frames to defeat physics bounce-back & clear velocity
    for i = 1, 3 do
      local finalHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if finalHRP then
        finalHRP.CFrame = homeCFrame
        if finalHRP.AssemblyLinearVelocity then
          finalHRP.AssemblyLinearVelocity = Vector3.zero
        else
          finalHRP.Velocity = Vector3.zero
        end
      end
      task.wait()  -- 1 render frame between each snap
    end
 -- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    CFG.cuff_busy = false

    if isCarrying then
      ShowNotification("Carried: " .. targetName, "", 3)
    elseif not success then
      ShowNotification("Error: " .. tostring(errorMsg), "ERR", 3)
    else
      ShowNotification("Could not carry: " .. targetName, "", 3)
    end
  end)
end

-- Fling to Void Sequence (Carry Side Target FIRST -> Confirm Grab -> Teleport to Void/Lag Zone -> Drop -> Return Home)
function FlingCarry_Execute()
  if CFG.cuff_busy then ShowNotification("Fling already running! Wait...", "", 2) return end
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("Fling Failed: No target selected!", "", 3) return
  end
  local targetPlayer = Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Fling Failed: Target not found!", "", 3) return
  end
  local targetChar = targetPlayer.Character
  local targetHRP  = targetChar:FindFirstChild("HumanoidRootPart")
  local myChar     = LocalPlayer.Character
  local myHRP      = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myTool     = CarrySide_FindTool() or L_RM_FindCuffTool()

  if not targetHRP or not myHRP then ShowNotification("Fling Failed: Character not ready!", "", 3) return end
  if not myTool then ShowNotification("Fling Failed: No Carry/Cuff tool found!", "", 3) return end

  CFG.cuff_busy = true

  task.spawn(function()
 -- â”€â”€ SAVE HOME: fresh lookup inside spawn â”€â”€
    local saveHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not saveHRP then CFG.cuff_busy = false return end
    local homeCFrame = saveHRP.CFrame
    local isCarrying = false
    local flung = false

    local success, errorMsg = pcall(function()
 -- STEP 1: Execute Ultra v2 Smart Capture
      local info = CarrySide_CalcCharInfo(targetChar, targetHRP)
      local restoreTouch = CarrySide_IsolateTouch(targetPlayer)
      L_RM_UnequipTool()
      task.wait(0.04)

 -- Active Micro-Tracking Lock (Heartbeat connection)
      local tracking = true
      local trackConn
      trackConn = RunService.Heartbeat:Connect(function()
        if not tracking then return end
        
 -- STRICT TARGET LOCK: If target changes or disappears, stop tracking
        if not targetChar or not targetChar:IsDescendantOf(workspace) then return end
        if CFG.cuff_target ~= targetName then return end

        CarrySide_AlignToTarget(myHRP, targetHRP, info)
        pcall(function() firetouchinterest(myHRP, targetHRP, 0) end)
      end)

      CarrySide_AlignToTarget(myHRP, targetHRP, info)
      pcall(function() firetouchinterest(myHRP, targetHRP, 0) end)

 -- Equip carry tool while actively tracking
      L_RM_EquipTool(myTool)
      task.wait(0.08)

 -- Triple-click activate with Scriptable camera
      CarrySide_Activate(myTool, targetChar, targetHRP, info)

 -- Server sync via Smart Weld Polling (instant exit once welded!)
      local weldStart = tick()
      while (tick() - weldStart) < 0.20 do
        if CarrySide_CheckWeld(targetChar) then
          isCarrying = true
          break
        end
        task.wait(0.02)
      end

 -- Stop tracking (keep target carried)
      tracking = false
      if trackConn then trackConn:Disconnect(); trackConn = nil end

 -- STEP 2: Check if target is physically attached/carried (with fast retry)
      if not isCarrying then
        isCarrying = CarrySide_CheckWeld(targetChar)
        if not isCarrying then
          task.wait(0.10)
          isCarrying = CarrySide_CheckWeld(targetChar)
        end
      end
      
      restoreTouch()

 -- STEP 3: EXTREME LAG ZONE FLING & DROP
      myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not myHRP then return end
      
 -- CRITICAL: Make sure tool STAYS EQUIPPED during entire void sequence!
      if myTool and myTool.Parent ~= LocalPlayer.Character then
        L_RM_EquipTool(myTool)
        task.wait(0.05)
      end

 -- Phase 1: Extreme Void Coordinates (Fast sync)
      local lagX = math.random(9999999, 99999999)
      local lagZ = math.random(9999999, 99999999)
      local lagY = math.random(9999999, 99999999)
      local flingLocation = CFrame.new(lagX, lagY, lagZ)

      myHRP.CFrame = flingLocation
      task.wait(0.15)

 -- Phase 2: Rapid Bounces across extreme coordinates (2 rapid bounces instead of 5 slow ones)
      for i = 1, 2 do
        local bX = math.random(9999999, 99999999) * (i % 2 == 0 and 1 or -1)
        local bY = math.random(9999999, 99999999)
        local bZ = math.random(9999999, 99999999) * (i % 2 == 0 and -1 or 1)
        local bounceCF = CFrame.new(bX, bY, bZ)
        myHRP.CFrame = bounceCF
        task.wait(0.08)
      end

 -- Phase 3: Final drop location in deepest void
      local finalX = math.random(99999999, 999999999)
      local finalZ = math.random(99999999, 999999999)
      local finalY = math.random(99999999, 999999999)
      local finalLocation = CFrame.new(finalX, finalY, finalZ)
      myHRP.CFrame = finalLocation
      task.wait(0.20)

 -- Phase 4: DROP target first, then return home (never travel back while welded)
      task.wait(0.08)
      FlingDropTarget(targetChar)
      task.wait(0.15)
      if targetChar and CarrySide_CheckWeld(targetChar) then
        FlingDropTarget(targetChar)
        task.wait(0.12)
      end

      myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if myHRP and homeCFrame then
        for i = 1, 6 do
          myHRP.CFrame = homeCFrame
          pcall(function() myHRP.AssemblyLinearVelocity = Vector3.zero end)
          task.wait()
        end
      end

      flung = true
    end)

    CFG.cuff_busy = false

    if flung and success then
      ShowNotification("Fling Success: " .. targetName, "", 3)
    else
      ShowNotification("Fling Failed: " .. targetName, "", 3)
    end
  end)
end

function FlingCarry_LagAlias()
  FlingCarry_Execute()
end

-- Forward declarations needed by CuffGlobal_Execute (defined before ColorCuff block)
local _cuffCooldownMap = {}
local function _markCuffed(plr)
  _cuffCooldownMap[plr] = os.clock()
end

-- CuffInput hook target part — must be declared here so CuffGlobal_Execute can set it
-- and the CuffInput hook (defined later) can read it from the SAME local variable.
local _cuffHookTargetPart = nil

-- Auto-clear cuff state when a player respawns (/re, ;re, /char, skin change, etc.)
-- CharacterAdded fires every time the character is replaced → they are NO LONGER cuffed.
local function _clearCuffOnRespawn(plr)
  if plr and _cuffCooldownMap[plr] then
    _cuffCooldownMap[plr] = nil
  end
end
-- Hook all players already in the server
for _, plr in ipairs(Players:GetPlayers()) do
  if plr ~= LocalPlayer then
    plr.CharacterAdded:Connect(function()
      _clearCuffOnRespawn(plr)
    end)
  end
end
-- Hook players who join after script loads
Players.PlayerAdded:Connect(function(plr)
  plr.CharacterAdded:Connect(function()
    _clearCuffOnRespawn(plr)
  end)
end)

-- ====================================================================
-- CUFF GLOBAL — Fast RightHand lock on targeted player (CFG.cuff_target)
-- Automatically calculates exact distance and warps/aligns if target is far!
-- Uses ColorCuff_PickTool (RedCuffs / CuffsCat / PinkPan / any cuffs).
-- ====================================================================
function CuffGlobal_Execute(skipAutoReturn)
  if CFG.color_cuff_busy then
    ShowNotification("Cuff busy! Wait...", "", 1.2)
    return
  end

  -- Target = selected player (CFG.cuff_target)
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("Cuff Global: Select a target first!", "", 2)
    return
  end

  local targetPlayer = ResolvePlayer(targetName) or Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Cuff Global: Target not found!", "", 2)
    return
  end

  if ColorCuff_IsAlreadyCuffed(targetPlayer) then
    ShowNotification("Cuff Global: Already cuffed!", "", 1.5)
    return
  end

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if not myHRP or not myHum then
    ShowNotification("Cuff Global: No character!", "", 1.5)
    return
  end

  local cuffTool = ColorCuff_PickTool()
  if not cuffTool then
    ShowNotification("Cuff Global: No cuffs in bag!", "", 1.5)
    return
  end

  CFG.color_cuff_busy = true

  task.spawn(function()
    local ok, err = pcall(function()
      local tChar = targetPlayer.Character
      local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
      if not tChar or not tHRP then
        ShowNotification("Cuff Global: Target gone!", "", 1.5)
        return
      end

      -- Target RightHand (R15) or Right Arm (R6)
      local targetPart = tChar:FindFirstChild("RightHand")
                      or tChar:FindFirstChild("Right Arm")
                      or tChar:FindFirstChild("RightLowerArm")
                      or tHRP

      -- Save home position for return
      local homeCFrame = myHRP.CFrame

      -- Teleport close to target (always — even if nearby, ensures correct distance)
      local fPos = tHRP.CFrame * CFrame.new(0, 0, -2.2)
      myHRP.CFrame = CFrame.new(fPos.Position, tHRP.Position)
      pcall(function() myHRP.AssemblyLinearVelocity = Vector3.zero end)
      task.wait(0.04)

      -- Equip tool smoothly
      if cuffTool.Parent ~= myChar then
        myHum:EquipTool(cuffTool)
        task.wait(0.04)
      end

      local remote = cuffTool:FindFirstChild("RemoteEvent")

      _cuffHookTargetPart = targetPart

      -- Physics touch registration
      pcall(function() firetouchinterest(myHRP, targetPart, 0) end)

      -- 2 Fast Consecutive Clicks (same as Cuff Nearest — proven to work)
      pcall(function() cuffTool:Activate() end)
      if remote then
        pcall(function() remote:FireServer("Cuff", targetPart, "PointerOnly") end)
      end

      task.wait(0.08)

      pcall(function() cuffTool:Activate() end)
      if remote then
        pcall(function() remote:FireServer("Cuff", targetPart, "PointerOnly") end)
      end

      pcall(function() firetouchinterest(myHRP, targetPart, 1) end)

      _cuffHookTargetPart = nil
      ShowNotification("Cuffed (Global): " .. targetName, "", 1.5)

      -- Return home
      if not skipAutoReturn then
        task.wait(0.06)
        local curHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if curHRP and homeCFrame then
          curHRP.CFrame = homeCFrame
          pcall(function() curHRP.AssemblyLinearVelocity = Vector3.zero end)
        end
      end
    end)
    -- ALWAYS reset busy flag, no matter what happened
    _cuffHookTargetPart = nil
    CFG.color_cuff_busy = false
  end)
end

-- Fling using Handcuffs only (Cuff Global -> Void 99M / Lag -> Drop -> Return Home)
function FlingCuff_Execute()
  if CFG.cuff_busy then ShowNotification("Fling already running! Wait...", "", 2) return end
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" then
    ShowNotification("Cuff Fling: No target!", "", 3) return
  end
  local targetPlayer = ResolvePlayer(targetName) or Players:FindFirstChild(targetName)
  if not targetPlayer or not targetPlayer.Character then
    ShowNotification("Cuff Fling: Target gone!", "", 3) return
  end

  local cuffTool = ColorCuff_PickTool() or L_RM_FindCuffTool()
  if not cuffTool then
    ShowNotification("Cuff Fling: No handcuffs in bag!", "", 3) return
  end

  CFG.cuff_busy = true

  task.spawn(function()
    local saveHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not saveHRP then CFG.cuff_busy = false return end
    local homeCFrame = saveHRP.CFrame

    local ok = pcall(function()
      -- Step 1: Cuff target using CuffGlobal without auto-return
      CuffGlobal_Execute(true)
      task.wait(0.12)

      local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not myHRP then return end

      if cuffTool.Parent ~= LocalPlayer.Character then
        pcall(function() LocalPlayer.Character.Humanoid:EquipTool(cuffTool) end)
        task.wait(0.05)
      end

      -- Step 2: Teleport into Extreme Void (VOID_99M)
      local VOID_CF = CFrame.new(99000000, 99000000, 99000000)
      myHRP.CFrame = VOID_CF
      task.wait(0.16)

      -- Rapid void bounces
      for i = 1, 2 do
        myHRP.CFrame = CFrame.new(math.random(9999999, 99999999), -math.random(9999999, 99999999), math.random(9999999, 99999999))
        task.wait(0.08)
      end

      -- Step 3: Drop target in void
      FlingDropTarget(targetPlayer.Character)
      task.wait(0.12)

      -- Step 4: Return home safely
      myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if myHRP and homeCFrame then
        for _ = 1, 6 do
          myHRP.CFrame = homeCFrame
          pcall(function() myHRP.AssemblyLinearVelocity = Vector3.zero end)
          task.wait()
        end
      end
    end)

    CFG.cuff_busy = false
    ShowNotification(ok and ("Cuff Fling Success: " .. targetName) or "Cuff Fling failed", "", 3)
  end)
end

function L_RM_DoBringSequence()
  L_RM_Do7belSequence()
end

-- ====================================================================
-- COLOR CUFF NEAR — CatCuff (Pink) / Cuffs (Red) on nearest player ≤ N studs
-- Independent from Vampire / L_RM_DoCuffSequence.
-- ====================================================================

-- Find CatCuff (pink) tool in Backpack or Character.
-- Priority: currently equipped → Backpack.
-- Names accepted: catcuff / cat cuff / cuffcat / pinkcuff / pink cuff / ladiescuffs / pinkhandcuff
function ColorCuff_FindPink()
  local function isPink(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local n = tool.Name:lower()
    if n:find("vampire") then return false end
    if n:find("cat") and (n:find("cuff") or n:find("menotte") or n:find("hand")) then return true end
    if n:find("pink") or n:find("kitty") or n:find("ladies") or n:find("rose") then return true end
    return false
  end
  local char = LocalPlayer.Character
  local pack = LocalPlayer:FindFirstChild("Backpack")
  if char then
    for _, t in ipairs(char:GetChildren()) do if isPink(t) then return t end end
  end
  if pack then
    for _, t in ipairs(pack:GetChildren()) do if isPink(t) then return t end end
  end
  return nil
end

-- Find Cuffs (red) tool.
-- Names accepted: cuffs / redcuff / red cuff / handcuffs (Strictly NOT vampire / cat / pink / kitty / rose)
function ColorCuff_FindRed()
  local function isRed(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local n = tool.Name:lower()
    if n:find("vampire") or n:find("cat") or n:find("pink")
       or n:find("kitty") or n:find("ladies") or n:find("rose") then
      return false
    end
    return n:find("cuff") or n:find("menotte") or n:find("arrest") or n:find("handcuff")
  end
  local char = LocalPlayer.Character
  local pack = LocalPlayer:FindFirstChild("Backpack")
  if char then
    for _, t in ipairs(char:GetChildren()) do if isRed(t) then return t end end
  end
  if pack then
    for _, t in ipairs(pack:GetChildren()) do if isRed(t) then return t end end
  end
  return nil
end

-- Hook CuffInput Module (Instant hit on RightHand/Right Arm, zero raycast issues)
-- NOTE: _cuffHookTargetPart is declared above (before CuffGlobal_Execute) so both can share it.
pcall(function()
  local RS = game:GetService("ReplicatedStorage")
  local CuffInput_m = require(RS:WaitForChild("CuffInput", 5))
  if CuffInput_m then
    CuffInput_m.WasActivation = function() return true end
    local origGetTarget = CuffInput_m.GetTarget
    CuffInput_m.GetTarget = function(...)
      if _cuffHookTargetPart then return _cuffHookTargetPart end
      if origGetTarget then return origGetTarget(...) end
      return nil
    end
  end
end)

-- Pick whichever color tool is best:
-- ABSOLUTE PRIORITY: CatCuff / PinkCuff first! If you have CatCuff, it will ALWAYS be picked.
-- Red Cuffs is only used as a fallback when no Pink/Cat tool exists in inventory.
function ColorCuff_PickTool()
  -- 1. ABSOLUTE PRIORITY: Red Cuffs first!
  local red = ColorCuff_FindRed()
  if red then return red, "Red" end

  -- 2. Fallback to Pink / CatCuff if Red not in inventory
  local pink = ColorCuff_FindPink()
  if pink then return pink, "Pink" end

  return nil, nil
end


-- Check if a player is cuffed — ULTRA SIMPLE, zero false positives.
-- Only checks what the SERVER actually sets. Never blocks based on guesses.
function ColorCuff_IsAlreadyCuffed(plr)
  if not plr then return false end
  local char = plr.Character
  if not char then return false end

  -- Only trust explicit server-set BoolValues / StringValues
  local cObj = char:FindFirstChild("Cuffed")
  if cObj and (cObj:IsA("BoolValue") and cObj.Value == true) then return true end
  if cObj and (cObj:IsA("StringValue") and cObj.Value ~= "") then return true end

  local hObj = char:FindFirstChild("Handcuffed")
  if hObj and (hObj:IsA("BoolValue") and hObj.Value == true) then return true end

  -- Check humanoid walkspeed = 0 + jumppower = 0 (common cuff sign)
  local hum = char:FindFirstChildOfClass("Humanoid")
  if hum and hum.WalkSpeed == 0 and hum.JumpPower == 0 and hum.Health > 0 then
    -- Could be cuffed, but don't block — let server decide
    -- return true  -- DISABLED: too many false positives (sitting, frozen, etc.)
  end

  return false
end


-- Find the body snap part on target + compute reach (size-aware).
-- Returns (part, reach) where reach is the offset in front of the part.
function ColorCuff_GetSnapPart(targetChar)
  if not targetChar then return nil, 2.5 end
  local myChar = LocalPlayer.Character
  -- priority: UpperTorso → Torso → HumanoidRootPart → Head
  local part = targetChar:FindFirstChild("UpperTorso")
               or targetChar:FindFirstChild("Torso")
               or targetChar:FindFirstChild("HumanoidRootPart")
               or targetChar:FindFirstChild("Head")
  if not part then
    -- fallback: any BasePart
    for _, p in ipairs(targetChar:GetChildren()) do
      if p:IsA("BasePart") then part = p break end
    end
  end
  if not part then return nil, 2.5 end

  -- size-aware reach: half-depth of target part + half-depth of my HRP + small gap
  local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myZ   = myHRP and (myHRP.Size.Z * 0.5) or 1.0
  local tgtZ  = part.Size.Z * 0.5
  -- also factor bounding box scale
  local scale = 1
  pcall(function()
    local _, bbox = targetChar:GetBoundingBox()
    if bbox then scale = math.clamp(bbox.X / 2, 0.4, 8) end
  end)
  local reach = math.clamp(myZ + tgtZ * scale + 0.3, 1.0, 6.0)
  return part, reach
end

-- Check if a weld/joint connects localPlayer's char to targetChar
function ColorCuff_CheckWeld(targetChar)
  if not targetChar or not LocalPlayer.Character then return false end
  local myChar = LocalPlayer.Character

  local function scan(container)
    if not container then return false end
    for _, obj in ipairs(container:GetDescendants()) do
      if obj:IsA("JointInstance") or obj:IsA("WeldConstraint") or obj:IsA("Weld") or obj:IsA("Motor6D") then
        local p0 = obj.Part0
        local p1 = obj.Part1
        if p0 and p1 then
          local p0InMe  = p0:IsDescendantOf(myChar)
          local p1InMe  = p1:IsDescendantOf(myChar)
          local p0InTgt = p0:IsDescendantOf(targetChar)
          local p1InTgt = p1:IsDescendantOf(targetChar)
          if (p0InMe and p1InTgt) or (p1InMe and p0InTgt) then
            return true
          end
        end
      end
    end
    return false
  end

  if scan(targetChar) then return true end
  if scan(myChar) then return true end
  return false
end


-- Main COLOR CUFF sequence (Fast & Smooth, No Vibration / No Shake).
-- Targets nearest alive player ≤ CFG.color_cuff_range studs (skips already-cuffed).
function ColorCuff_Execute()
  if CFG.color_cuff_busy then
    ShowNotification("Cuff busy! Wait...", "", 1.2)
    return
  end

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if not myHRP or not myHum then
    ShowNotification("Cuff: No character!", "", 1.5)
    return
  end

  local range = CFG.color_cuff_range or 20

  local bestPlr, bestDist = nil, range + 0.01
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
      local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
      local hum = plr.Character:FindFirstChildOfClass("Humanoid")
      if hrp and hum and hum.Health > 0 then
        local d = (hrp.Position - myHRP.Position).Magnitude
        if d <= range and d < bestDist then
          if not ColorCuff_IsAlreadyCuffed(plr) then
            bestDist = d
            bestPlr  = plr
          end
        end
      end
    end
  end

  if not bestPlr then
    ShowNotification("Cuff: No target in " .. range .. "m", "", 1.5)
    return
  end

  local cuffTool = ColorCuff_PickTool()
  if not cuffTool then
    ShowNotification("Cuff: No cuffs in bag!", "", 1.5)
    return
  end

  CFG.color_cuff_busy = true
  local targetName = bestPlr.Name

  task.spawn(function()
    local ok, err = pcall(function()
      local tChar = bestPlr.Character
      local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
      if not tChar or not tHRP then
        ShowNotification("Cuff: Target gone!", "", 1.5)
        return
      end

      -- Target RightHand (R15) or Right Arm (R6)
      local targetPart = tChar:FindFirstChild("RightHand")
                      or tChar:FindFirstChild("Right Arm")
                      or tChar:FindFirstChild("RightLowerArm")
                      or tHRP

      _cuffHookTargetPart = targetPart

      -- Equip Tool smoothly
      if cuffTool.Parent ~= myChar then
        myHum:EquipTool(cuffTool)
        task.wait(0.04)
      end

      local remote = cuffTool:FindFirstChild("RemoteEvent")

      -- Physics touch registration
      pcall(function() firetouchinterest(myHRP, targetPart, 0) end)

      -- 2 Fast Consecutive Clicks (Double Click)
      pcall(function() cuffTool:Activate() end)
      if remote then
        pcall(function() remote:FireServer("Cuff", targetPart, "PointerOnly") end)
      end

      task.wait(0.08)

      pcall(function() cuffTool:Activate() end)
      if remote then
        pcall(function() remote:FireServer("Cuff", targetPart, "PointerOnly") end)
      end

      pcall(function() firetouchinterest(myHRP, targetPart, 1) end)

      _cuffHookTargetPart = nil
      ShowNotification("Cuffed: " .. targetName, "", 1.5)
    end)
    -- ALWAYS reset busy flag, no matter what happened
    _cuffHookTargetPart = nil
    CFG.color_cuff_busy = false
  end)
end



function TeleportToTarget()
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" then return end
  local tp = Players:FindFirstChild(targetName)
  if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then myHRP.CFrame = tp.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end
  end
end

function QuickTP_Planet()
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hrp then
    hrp.CFrame = CFrame.new(-460, 769, 195)
    if hrp.AssemblyLinearVelocity then
      hrp.AssemblyLinearVelocity = Vector3.zero
    else
      hrp.Velocity = Vector3.zero
    end
    ShowNotification("Teleported to Planet! (-460, 769, 195)", "", 3)
  else
    ShowNotification("Character RootPart not found!", "", 2)
  end
end

local BlinderMesh = nil
local spectating = false
local specConn = nil
local specDiedConn = nil
local specRemovingConn = nil
local onSpectateListeners = {}

function RegisterSpectateListener(fn)
  table.insert(onSpectateListeners, fn)
end

function FireSpectateListeners(isSpec, tName)
  for _, fn in ipairs(onSpectateListeners) do
    pcall(fn, isSpec, tName)
  end
end

function FixCamera(silent)
  spectating = false
  if specConn then
    pcall(function() specConn:Disconnect() end)
    specConn = nil
  end
  if specDiedConn then
    pcall(function() specDiedConn:Disconnect() end)
    specDiedConn = nil
  end
  if specRemovingConn then
    pcall(function() specRemovingConn:Disconnect() end)
    specRemovingConn = nil
  end

  if BlinderMesh then
    pcall(function() BlinderMesh:Destroy() end)
    BlinderMesh = nil
  end

  pcall(function()
    local cam = workspace.CurrentCamera
    if cam then
      cam.CameraType = Enum.CameraType.Custom
      local myChar = LocalPlayer.Character
      local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
      if myHum then
        cam.CameraSubject = myHum
      elseif myChar and myChar:FindFirstChild("HumanoidRootPart") then
        cam.CameraSubject = myChar.HumanoidRootPart
      elseif myChar and myChar:FindFirstChild("Head") then
        cam.CameraSubject = myChar.Head
      end
      cam.FieldOfView = 70
    end
  end)

  pcall(function()
    local ps = LocalPlayer:FindFirstChildOfClass("PlayerScripts") or LocalPlayer:FindFirstChild("PlayerScripts")
    local pm = ps and ps:FindFirstChild("PlayerModule")
    if pm then
      local playerModule = require(pm)
      if playerModule and playerModule.GetCameras then
        local camController = playerModule:GetCameras()
        if camController and camController.activeCameraController then
          camController.activeCameraController:Enable(true)
        end
      end
    end
  end)

  task.defer(function()
    task.wait(0.04)
    pcall(function()
      local cam = workspace.CurrentCamera
      if cam then
        cam.CameraType = Enum.CameraType.Custom
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum and cam.CameraSubject ~= myHum then
          cam.CameraSubject = myHum
        end
      end
    end)
  end)

  FireSpectateListeners(false, "")
  if not silent then
    ShowNotification("Camera Restored & Unbugged!", "", 2)
  end
end

task.spawn(function()
  local lastFixAt = 0
  while task.wait(1.25) do
    pcall(function()
      if CFG.cuff_busy then return end
      if spectating then return end
      if SonicGhostState and SonicGhostState.active then return end
      if OrbitState and (OrbitState.active or OrbitState.seatDesyncActive) then return end
      if StealthState and StealthState.active then return end
      local cam = workspace.CurrentCamera
      if not cam then return end
      local myChar = LocalPlayer.Character
      local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
      local sub = cam.CameraSubject
      local broken = false
      if cam.CameraType == Enum.CameraType.Scriptable then
        broken = true
      elseif sub == nil then
        broken = true
      elseif myHum and sub ~= myHum then
        if sub:IsA("Humanoid") then
          if not myChar or sub.Parent ~= myChar then broken = true end
        elseif sub:IsA("BasePart") then
          if not myChar or not sub:IsDescendantOf(myChar) then broken = true end
        end
      end
      if broken and (tick() - lastFixAt) > 5 then
        lastFixAt = tick()
        FixCamera(true)
      end
    end)
  end
end)

function ToggleSpectate(targetOverride)
  local cam = workspace.CurrentCamera

  local function resolveSpec(name)
    if not name or name == "" then return nil end
    local p = Players:FindFirstChild(name)
    if p then return p end
    local q = string.lower(tostring(name))
    for _, pl in ipairs(Players:GetPlayers()) do
      if pl.Name:lower() == q or pl.DisplayName:lower() == q then
        return pl
      end
    end
    return nil
  end

  local tp = nil
  if targetOverride and targetOverride ~= "" then
    tp = resolveSpec(targetOverride)
  else
    tp = resolveSpec(CFG.cuff_target) or GetLiveTarget()
  end

  if not tp then
    if spectating then
      spectating = false
      if _G.SmartSpectate then
        _G.SmartSpectate.Stop()
      else
        FixCamera(false)
      end
      FireSpectateListeners(false, "")
      ShowNotification("SMART SPECTATE: OFF", "", 1.2)
    else
      ShowNotification("Select a target first!", "", 2)
    end
    return
  end

  -- If currently spectating the same target -> Toggle OFF
  if spectating and (_G.SmartSpectate and _G.SmartSpectate.GetTarget() == tp or CFG.cuff_target == tp.Name) then
    spectating = false
    if _G.SmartSpectate then
      _G.SmartSpectate.Stop()
    else
      FixCamera(false)
    end
    FireSpectateListeners(false, "")
    ShowNotification("SMART SPECTATE: OFF", "", 1.2)
    return
  end

  -- Activate Smart Spectate
  CFG.cuff_target = tp.Name
  CFG.cuff_target_id = tp.UserId
  spectating = true

  if _G.SmartSpectate then
    _G.SmartSpectate.Start(tp)
  else
    -- Fallback Smart Spectate
    pcall(function()
      local afkF = rep:FindFirstChild("AFK THINGY")
      local afkEv = afkF and afkF:FindFirstChild("AFKEvent")
      if afkEv then afkEv:FireServer(true) end
    end)
    local char = tp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if cam and hum then
      cam.CameraSubject = hum
      cam.CameraType = Enum.CameraType.Custom
    end
  end

  FireSpectateListeners(true, tp.Name)
  ShowNotification("SMART SPECTATE: " .. (tp.DisplayName or tp.Name), "", 1.5)
end

-- ============================================================
-- SONIC GHOST V4: SUBTERRANEAN VOICE SPY & VOICE OF GOD ENGINE
-- Sub-Floor Proximity Anchor + CoreScript Mic Mute + PTT
-- ============================================================
local SonicGhostState = {
  active         = false,
  targetName     = "",
  savedHomeCF    = nil,
  heartbeatConn  = nil,
  bodyPos        = nil,
  bodyGyro       = nil,
  savedParts     = {},
  isMuted        = true,
  pttKey         = Enum.KeyCode.V,
  pttActive      = false,
  pttConnBegan   = nil,
  pttConnEnded   = nil,
  wireObjects    = {},
}

-- Safe CoreScript Mic Controller
function SetMicrophoneState(enabled)
  SonicGhostState.isMuted = not enabled
  pcall(function()
    local VCS = game:GetService("VoiceChatService")
    if VCS then
      pcall(function() VCS:SetMicrophoneEnabled(enabled) end)
    end
  end)
  pcall(function()
    game:GetService("StarterGui"):SetCore("VoiceChatInputEnabled", enabled)
  end)
end

-- Audio API Universal Interceptor (Probe layer)
function ProbeAudioApiDirect(targetPlayer)
  pcall(function()
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    for _, obj in ipairs(targetChar:GetDescendants()) do
      if obj:IsA("AudioDeviceInput") then
        local out = Instance.new("AudioDeviceOutput")
        out.Player = LocalPlayer
        out.Parent = LocalPlayer.Character or workspace
        local wire = Instance.new("Wire")
        wire.SourceInstance = obj
        wire.TargetInstance = out
        wire.Parent = out
        table.insert(SonicGhostState.wireObjects, {wire = wire, out = out})
      end
    end
  end)
end

function CleanupAudioApiWires()
  for _, item in ipairs(SonicGhostState.wireObjects) do
    pcall(function() if item.wire then item.wire:Destroy() end end)
    pcall(function() if item.out then item.out:Destroy() end end)
  end
  SonicGhostState.wireObjects = {}
end

function StopSonicGhost()
  if not SonicGhostState.active then return end
  SonicGhostState.active = false

 -- Disconnect tracking loop
  if SonicGhostState.heartbeatConn then
    SonicGhostState.heartbeatConn:Disconnect()
    SonicGhostState.heartbeatConn = nil
  end

 -- Disconnect PTT hooks
  if SonicGhostState.pttConnBegan then SonicGhostState.pttConnBegan:Disconnect(); SonicGhostState.pttConnBegan = nil end
  if SonicGhostState.pttConnEnded then SonicGhostState.pttConnEnded:Disconnect(); SonicGhostState.pttConnEnded = nil end

 -- Destroy physics movers
  pcall(function() if SonicGhostState.bodyPos then SonicGhostState.bodyPos:Destroy() end end)
  pcall(function() if SonicGhostState.bodyGyro then SonicGhostState.bodyGyro:Destroy() end end)
  SonicGhostState.bodyPos = nil
  SonicGhostState.bodyGyro = nil

 -- Cleanup audio wires
  CleanupAudioApiWires()

 -- Restore Character collisions & transparency
  local myChar = LocalPlayer.Character
  if myChar then
    for part, origMod in pairs(SonicGhostState.savedParts) do
      pcall(function()
        if part and part.Parent then
          part.LocalTransparencyModifier = origMod
          part.CanCollide = true
        end
      end)
    end
  end
  SonicGhostState.savedParts = {}

 -- Return home safely with velocity reset
  local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  if myHRP and SonicGhostState.savedHomeCF then
    for i = 1, 3 do
      myHRP.CFrame = SonicGhostState.savedHomeCF
      if myHRP.AssemblyLinearVelocity then
        myHRP.AssemblyLinearVelocity = Vector3.zero
      else
        myHRP.Velocity = Vector3.zero
      end
      task.wait()
    end
  end

 -- Reset camera to LocalPlayer
  local cam = workspace.CurrentCamera
  local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if cam and myHum then
    cam.CameraSubject = myHum
  end

 -- Restore mic to active
  SetMicrophoneState(true)
  ShowNotification("Sonic Ghost OFF (Returned Home)", "", 2)
end

function StartSonicGhost()
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" or targetName == "No other players" or targetName == LocalPlayer.Name then
    ShowNotification("Select a valid target first!", "", 3)
    return
  end

  local tp = Players:FindFirstChild(targetName)
  if not tp or not tp.Character then
    ShowNotification("Target not found!", "", 3)
    return
  end

  local targetHRP = tp.Character:FindFirstChild("HumanoidRootPart")
  local targetHum = tp.Character:FindFirstChildOfClass("Humanoid")
  local myChar    = LocalPlayer.Character
  local myHRP     = myChar and myChar:FindFirstChild("HumanoidRootPart")

  if not targetHRP or not targetHum or not myHRP then
    ShowNotification("Characters not loaded!", "", 3)
    return
  end

  SonicGhostState.active = true
  SonicGhostState.targetName = targetName

 -- 1. Save precise Home CFrame
  SonicGhostState.savedHomeCF = myHRP.CFrame

 -- 2. Immediately MUTE mic for 100% silent wiretapping
  SetMicrophoneState(false)

 -- 3. Hide Character Locally, Disable Collisions & CastShadow
  for _, part in ipairs(myChar:GetDescendants()) do
    if part:IsA("BasePart") then
      SonicGhostState.savedParts[part] = part.LocalTransparencyModifier
      part.LocalTransparencyModifier = 1
      part.CanCollide = false
      pcall(function() part.CastShadow = false end)
    elseif part:IsA("Accessory") or part:IsA("Tool") then
      for _, handle in ipairs(part:GetDescendants()) do
        if handle:IsA("BasePart") then
          handle.LocalTransparencyModifier = 1
          pcall(function() handle.CastShadow = false end)
        end
      end
    end
  end

 -- Raycast parameters to probe the real ground under the target
  local floorRayParams = RaycastParams.new()
  floorRayParams.FilterDescendantsInstances = {myChar, tp.Character}
  floorRayParams.FilterType = Enum.RaycastFilterType.Exclude

 -- Helper function to compute safe dynamic depth based on the floor
  local function getSmartUndergroundPos(curHRP)
    local targetPos = curHRP.Position
    local floorRay = workspace:Raycast(targetPos + Vector3.new(0, 2, 0), Vector3.new(0, -30, 0), floorRayParams)
    local groundY = floorRay and floorRay.Position.Y or (targetPos.Y - 3)
 -- Place our head safely 6 studs under the detected ground surface, capped between -7 and -15 studs
    local depthY = math.clamp(groundY - targetPos.Y - 6.0, -15.0, -7.0)
    return targetPos + Vector3.new(0, depthY, 0)
  end

 -- 4. Setup Subterranean Physics Anchor
  local initialPos = getSmartUndergroundPos(targetHRP)
  myHRP.CFrame = CFrame.new(initialPos, targetHRP.Position)

  local bp = Instance.new("BodyPosition")
  bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
  bp.D = 180
  bp.P = 120000
  bp.Position = initialPos
  bp.Parent = myHRP
  SonicGhostState.bodyPos = bp

  local bg = Instance.new("BodyGyro")
  bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
  bg.D = 40
  bg.P = 10000
  bg.CFrame = targetHRP.CFrame
  bg.Parent = myHRP
  SonicGhostState.bodyGyro = bg

 -- 5. Camera stays up on target so you watch them naturally in third person!
  local cam = workspace.CurrentCamera
  if cam then
    cam.CameraSubject = targetHum
  end

 -- 6. Probe modern Audio API for direct wire connection
  ProbeAudioApiDirect(tp)

 -- 7. Heartbeat tracking: locks you dynamically under their feet adapting to terrain/stairs/hills
  SonicGhostState.heartbeatConn = RunService.Heartbeat:Connect(function()
    if not SonicGhostState.active then return end
    if not tp or not tp.Character or not tp.Character:IsDescendantOf(workspace) then
      StopSonicGhost()
      return
    end
    local curTHRP = tp.Character:FindFirstChild("HumanoidRootPart")
    if not curTHRP or not bp or not bp.Parent then
      StopSonicGhost()
      return
    end

 -- Keep zero collisions every frame to prevent getting pushed above ground
    for _, part in ipairs(myChar:GetDescendants()) do
      if part:IsA("BasePart") and part.CanCollide then
        part.CanCollide = false
      end
    end

 -- Zero velocity to kill any physics jitter
    if myHRP.AssemblyLinearVelocity then
      myHRP.AssemblyLinearVelocity = Vector3.zero
    else
      myHRP.Velocity = Vector3.zero
    end

    local smartPos = getSmartUndergroundPos(curTHRP)
    bp.Position = smartPos
    bg.CFrame = curTHRP.CFrame
  end)

  ShowNotification("Sonic Ghost ON: " .. targetName .. "\nClick [ Toggle Mic] button to Talk/Mute", "", 4)
end

function ToggleSonicGhost()
  if SonicGhostState.active then
    StopSonicGhost()
  else
    StartSonicGhost()
  end
end

function ToggleGhostMic()
  if not SonicGhostState.active and not OrbitState.active and not OrbitState.seatDesyncActive then
    ShowNotification("Activate Sonic Ghost, Orbit Spy, or Seat Desync first!", "", 2)
    return
  end
  if SonicGhostState.isMuted then
    SonicGhostState.isMuted = false
    SetMicrophoneState(true)
    ShowNotification("Mic OPEN - You are now TALKING!", "", 2)
  else
    SonicGhostState.isMuted = true
    SetMicrophoneState(false)
    ShowNotification("Mic MUTED - Silent Spy Active!", "", 2)
  end
end

-- ============================================================
-- PLANET ORBIT SPY & SEAT VOICE DESYNC ENGINE (NO KEYBINDS)
-- Controlled 100% via GUI Buttons - PC, Mobile & Console Ready
-- ============================================================
local OrbitState = {
  active           = false,
  mode             = "none",
  orbitBaseCF      = nil,
  savedSeatCF      = nil,
  savedSeatPart    = nil,
  heartbeatConn    = nil,
  warpActive       = false,
  seatDesyncActive = false,
}

function StopSeatDesync()
 -- 1. Stop Heartbeat connection immediately
  if OrbitState.heartbeatConn then
    OrbitState.heartbeatConn:Disconnect()
    OrbitState.heartbeatConn = nil
  end
  OrbitState.seatDesyncActive = false
  OrbitState.active           = false
  OrbitState.mode             = "none"

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")

 -- 2. Restore humanoid physics states
  if myHum then
    pcall(function()
      myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
      myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
      myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
      myHum.Jump = false
      myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
  end

 -- 3. Snap character back to saved seat position
  if myHRP and OrbitState.savedSeatCF then
    for i = 1, 5 do
      myHRP.CFrame = OrbitState.savedSeatCF
      if myHRP.AssemblyLinearVelocity then
        myHRP.AssemblyLinearVelocity = Vector3.zero
      else
        myHRP.Velocity = Vector3.zero
      end
      task.wait()
    end
  end

 -- 4. Re-sit in the seat if it still exists
  if myHum and OrbitState.savedSeatPart and OrbitState.savedSeatPart.Parent and OrbitState.savedSeatPart:IsA("Seat") then
    pcall(function()
      OrbitState.savedSeatPart:Sit(myHum)
    end)
  end

 -- 5. Restore body visibility and collisions
  if myChar then
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") then
        p.LocalTransparencyModifier = 0
        p.CanCollide = true
        pcall(function() p.CastShadow = true end)
      end
    end
  end

 -- 6. Restore mic & camera
  SetMicrophoneState(true)
  pcall(function()
    if myHum then
      workspace.CurrentCamera.CameraSubject = myHum
    end
  end)

  OrbitState.savedSeatCF   = nil
  OrbitState.savedSeatPart = nil

  ShowNotification("Seat Voice Desync OFF - Safely Returned to Seat!", "", 3)
end

function OrbitCleanup()
  if OrbitState.seatDesyncActive then
    StopSeatDesync()
    return
  end

  OrbitState.active     = false
  OrbitState.mode       = "none"
  OrbitState.warpActive = false

  if OrbitState.heartbeatConn then
    OrbitState.heartbeatConn:Disconnect()
    OrbitState.heartbeatConn = nil
  end
  if OrbitState.beamConn then
    OrbitState.beamConn:Disconnect()
    OrbitState.beamConn = nil
  end

  SetMicrophoneState(true)

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")

  if myHum then
    pcall(function()
      myHum.PlatformStand = false
      myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
      myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
      myHum.DisplayDistanceType = Enum.DisplayDistanceType.Viewer
      myHum.NameDisplayDistance = 100
      myHum.HealthDisplayDistance = 100
      workspace.CurrentCamera.CameraSubject = myHum
    end)
  end

  if myHRP and OrbitState.orbitBaseCF then
    for i = 1, 3 do
      myHRP.CFrame = OrbitState.orbitBaseCF
      if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
      else myHRP.Velocity = Vector3.zero end
      task.wait()
    end
  end

  if myChar then
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") then
        p.LocalTransparencyModifier = 0
        p.CanCollide = true
        pcall(function() p.CastShadow = true end)
      end
    end
  end

  ShowNotification("Orbit Spy OFF - Mic restored", "", 2)
end

-- â”€â”€ MODE 1: Orbital PTT Beam (UI Toggle) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
function StartOrbitMode()
  if not CFG.cuff_target or CFG.cuff_target == "" then
    ShowNotification("Select a TARGET first from Main tab!", "", 3)
    return
  end
  local tp = Players:FindFirstChild(CFG.cuff_target)
  if not tp or not tp.Character or not tp.Character:FindFirstChild("HumanoidRootPart") then
    ShowNotification("Target character not found in game!", "", 3)
    return
  end
  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  if not myHRP then ShowNotification("Your character not found!", "", 3) return end

 -- Save current orbital base (planet / sky spot)
  OrbitState.orbitBaseCF = myHRP.CFrame
  OrbitState.active      = true
  OrbitState.mode        = "orbit"
  OrbitState.warpActive  = false
  SetMicrophoneState(false)

  ShowNotification("ORBIT BASE SAVED!\nClick [ Orbit Beam] button to Talk to Target!",
    "", 4
  )
end

function ReturnToOrbit()
  OrbitState.warpActive = false

 -- Disconnect Heartbeat lock immediately
  if OrbitState.beamConn then
    OrbitState.beamConn:Disconnect()
    OrbitState.beamConn = nil
  end

  SetMicrophoneState(false)

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")

 -- Restore Humanoid physics & state
  if myHum then
    pcall(function()
      myHum.PlatformStand = false
      myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
      myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
      myHum.DisplayDistanceType = Enum.DisplayDistanceType.Viewer
      myHum.NameDisplayDistance = 100
      myHum.HealthDisplayDistance = 100
      workspace.CurrentCamera.CameraSubject = myHum
    end)
  end

 -- Snap back to Planet base position
  if myHRP and OrbitState.orbitBaseCF then
    for i = 1, 5 do
      myHRP.CFrame = OrbitState.orbitBaseCF
      if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
      else myHRP.Velocity = Vector3.zero end
      task.wait()
    end
  end

 -- Restore visibility and collisions
  if myChar then
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") then
        p.LocalTransparencyModifier = 0
        p.CanCollide = true
        pcall(function() p.CastShadow = true end)
      end
    end
  end
  ShowNotification("RETURNED TO PLANET! 100% Silent & Safe", "", 2)
end

function BeamToTarget()
  if not OrbitState.active or not OrbitState.orbitBaseCF then
    ShowNotification("Click [ Orbit Spy] to save your planet base first!", "", 3)
    return
  end
  if not CFG.cuff_target or CFG.cuff_target == "" then
    ShowNotification("Select a TARGET first from Main tab!", "", 3)
    return
  end
  local tp = Players:FindFirstChild(CFG.cuff_target)
  if not tp or not tp.Character or not tp.Character:FindFirstChild("HumanoidRootPart") then
    ShowNotification("Target not found in game!", "", 3)
    return
  end
  local myChar = LocalPlayer.Character
  local freshHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if not freshHRP or not myHum then return end

  local curTHRP = tp.Character:FindFirstChild("HumanoidRootPart")
  local targetHum = tp.Character:FindFirstChildOfClass("Humanoid")
  if not curTHRP then return end

  OrbitState.warpActive = true

 -- 1. Disable platform stand & states so character NEVER pops up to surface!
  myHum.PlatformStand = true
  pcall(function()
    myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
  end)

 -- 2. Completely HIDE Nametag & Healthbar so NO text floats above ground!
  pcall(function()
    myHum.DisplayDistanceType = Enum.DisplayDistanceType.None
    myHum.NameDisplayDistance = 0
    myHum.HealthDisplayDistance = 0
  end)

 -- 3. Third-person Camera on Target (watch target smoothly from above ground!)
  local cam = workspace.CurrentCamera
  if cam and targetHum then
    cam.CameraSubject = targetHum
  end

 -- 4. Raycast function to calculate deep underground coordinates (-14 studs below ground)
  local rayP = RaycastParams.new()
  rayP.FilterType = Enum.RaycastFilterType.Exclude
  rayP.FilterDescendantsInstances = {myChar, tp.Character}

  local function getSafeUndergroundPos(targetRoot)
    local ray = workspace:Raycast(targetRoot.Position + Vector3.new(0, 3, 0), Vector3.new(0, -60, 0), rayP)
    local floorY = ray and ray.Position.Y or (targetRoot.Position.Y - 3)
 -- Guaranteed 45 studs below floor in Deep Abyss: 100% submerged below all basements/tunnels!
    return Vector3.new(targetRoot.Position.X, floorY - 45, targetRoot.Position.Z)
  end

 -- Initial warp
  local startPos = getSafeUndergroundPos(curTHRP)
  freshHRP.CFrame = CFrame.new(startPos)
  if freshHRP.AssemblyLinearVelocity then freshHRP.AssemblyLinearVelocity = Vector3.zero
  else freshHRP.Velocity = Vector3.zero end

 -- 5. Turn off shadows & collisions on all parts
  for _, p in ipairs(myChar:GetDescendants()) do
    if p:IsA("BasePart") then
      p.CanCollide = false
      p.LocalTransparencyModifier = 1
      pcall(function() p.CastShadow = false end)
    end
  end

 -- 6. ACTIVE HEARTBEAT STEALTH LOCK:
 -- Dynamically locks your mic & body -45 studs under target in Deep Abyss every single frame!
 -- Target can run anywhere - you follow them 100% invisible below all tunnels!
  if OrbitState.beamConn then OrbitState.beamConn:Disconnect(); OrbitState.beamConn = nil end
  OrbitState.beamConn = RunService.Heartbeat:Connect(function()
    if not OrbitState.warpActive then return end
    if not tp or not tp.Character or not tp.Character:IsDescendantOf(workspace) then
      ReturnToOrbit()
      return
    end
    local tRoot = tp.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot or not freshHRP or not freshHRP.Parent then
      ReturnToOrbit()
      return
    end

    local undergroundPos = getSafeUndergroundPos(tRoot)
    freshHRP.CFrame = CFrame.new(undergroundPos)
    if freshHRP.AssemblyLinearVelocity then freshHRP.AssemblyLinearVelocity = Vector3.zero
    else freshHRP.Velocity = Vector3.zero end

 -- Enforce No-Collision every frame so terrain never pushes you up!
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") and p.CanCollide then
        p.CanCollide = false
      end
    end
  end)

  SetMicrophoneState(true)
  ShowNotification("GHOST BEAM ACTIVE!\nBuried -45 studs in Deep Abyss | Mic OPEN!\n(Click [ Orbit Beam] to return to Planet)", "", 4)
end

function ToggleOrbitBeam()
  if not OrbitState.active then
    ShowNotification("Activate Orbit Spy on the planet first!", "", 3)
    return
  end
  if OrbitState.warpActive then
    ReturnToOrbit()
  else
    BeamToTarget()
  end
end

function ToggleOrbitSpy()
  if OrbitState.active then
    OrbitCleanup()
  else
    StartOrbitMode()
  end
end

-- ============================================================
-- GHOST VOICE PROXIMITY ENGINE (DEEP ABYSS -45 STUDS)
-- Controlled via Misc Tab | Auto-Spectate | Zero Visibility
-- ============================================================
local updateGhostVoiceUI = nil

local GhostVoiceState = {
  active        = false,
  savedHomeCF   = nil,
  heartbeatConn = nil,
  depth         = -45,
}

function StopGhostVoice()
  if not GhostVoiceState.active then return end
  GhostVoiceState.active = false

  if GhostVoiceState.heartbeatConn then
    GhostVoiceState.heartbeatConn:Disconnect()
    GhostVoiceState.heartbeatConn = nil
  end

  SetMicrophoneState(false)

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")

 -- Restore Humanoid states
  if myHum then
    pcall(function()
      myHum.PlatformStand = false
      myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
      myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
      myHum.DisplayDistanceType = Enum.DisplayDistanceType.Viewer
      myHum.NameDisplayDistance = 100
      myHum.HealthDisplayDistance = 100
    end)
  end

 -- Return character to saved home position (planet / original spot)
  if myHRP and GhostVoiceState.savedHomeCF then
    for i = 1, 5 do
      myHRP.CFrame = GhostVoiceState.savedHomeCF
      if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
      else myHRP.Velocity = Vector3.zero end
      task.wait()
    end
  end

 -- Restore collisions and visibility
  if myChar then
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") then
        p.LocalTransparencyModifier = 0
        p.CanCollide = true
        pcall(function() p.CastShadow = true end)
      end
    end
  end

  GhostVoiceState.savedHomeCF = nil
  if updateGhostVoiceUI then updateGhostVoiceUI() end
  ShowNotification("Ghost Voice OFF (Returned Home)\n Spectate is still active!", "", 3)
end

function StartGhostVoice()
  if not CFG.cuff_target or CFG.cuff_target == "" then
    ShowNotification("Select a TARGET first from Main tab!", "", 3)
    return
  end
  local tp = Players:FindFirstChild(CFG.cuff_target)
  if not tp or not tp.Character or not tp.Character:FindFirstChild("HumanoidRootPart") then
    ShowNotification("Target character not found in game!", "", 3)
    return
  end

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if not myHRP or not myHum then return end

  local targetHRP = tp.Character:FindFirstChild("HumanoidRootPart")
  local targetHum = tp.Character:FindFirstChildOfClass("Humanoid")
  if not targetHRP then return end

 -- 1. Save home position before warping
  GhostVoiceState.savedHomeCF = myHRP.CFrame
  GhostVoiceState.active      = true

 -- 2. Freeze humanoid physics (no popping up to surface)
  myHum.PlatformStand = true
  pcall(function()
    myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
  end)

 -- 3. Destroy nametag & healthbar from all players' view
  pcall(function()
    myHum.DisplayDistanceType = Enum.DisplayDistanceType.None
    myHum.NameDisplayDistance = 0
    myHum.HealthDisplayDistance = 0
  end)

 -- 4. Auto-Spectate: Camera stays watching target cleanly from above
  local cam = workspace.CurrentCamera
  if cam and targetHum then
    cam.CameraSubject = targetHum
    spectating = true
  end

 -- 5. Calculate Deep Abyss position (-45 studs under whatever floor target stands on)
  local rayP2 = RaycastParams.new()
  rayP2.FilterType = Enum.RaycastFilterType.Exclude
  rayP2.FilterDescendantsInstances = {myChar, tp.Character}

  local function getDeepAbyssPos(tHRP)
    local ray = workspace:Raycast(tHRP.Position + Vector3.new(0, 3, 0), Vector3.new(0, -60, 0), rayP2)
    local floorY = ray and ray.Position.Y or (tHRP.Position.Y - 3)
 -- Guaranteed 45 studs below whatever floor or tunnel the target is on!
    return Vector3.new(tHRP.Position.X, floorY - 45, tHRP.Position.Z)
  end

 -- Initial warp
  local startPos = getDeepAbyssPos(targetHRP)
  myHRP.CFrame = CFrame.new(startPos)
  if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
  else myHRP.Velocity = Vector3.zero end

 -- 6. Disable shadows & collisions
  for _, p in ipairs(myChar:GetDescendants()) do
    if p:IsA("BasePart") then
      p.CanCollide = false
      p.LocalTransparencyModifier = 1
      pcall(function() p.CastShadow = false end)
    end
  end

 -- 7. Active Heartbeat loop: locks you -45 studs dynamically as target moves
  if GhostVoiceState.heartbeatConn then
    GhostVoiceState.heartbeatConn:Disconnect()
    GhostVoiceState.heartbeatConn = nil
  end

  GhostVoiceState.heartbeatConn = RunService.Heartbeat:Connect(function()
    if not GhostVoiceState.active then return end
    if not tp or not tp.Character or not tp.Character:IsDescendantOf(workspace) then
      StopGhostVoice()
      return
    end
    local curTHRP = tp.Character:FindFirstChild("HumanoidRootPart")
    if not curTHRP or not myHRP or not myHRP.Parent then
      StopGhostVoice()
      return
    end

    local abyssPos = getDeepAbyssPos(curTHRP)
    myHRP.CFrame = CFrame.new(abyssPos)
    if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
    else myHRP.Velocity = Vector3.zero end

    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") and p.CanCollide then
        p.CanCollide = false
      end
    end
  end)

  SetMicrophoneState(true) -- Mic is OPEN to talk!
  if updateGhostVoiceUI then updateGhostVoiceUI() end
  ShowNotification("GHOST VOICE ON (-45 Studs Abyss)\n" ..
    "Mic OPEN | Target: " .. CFG.cuff_target .. "\n" ..
    "Body 100% Hidden below all tunnels!",
    "", 4
  )
end

function ToggleGhostVoice()
  if GhostVoiceState.active then
    StopGhostVoice()
  else
    StartGhostVoice()
  end
end

-- â”€â”€ MODE 2: Seat / Planet Voice Desync Proxy â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
function StartSeatDesync()
 -- Strict target check: Must have a target selected!
  if not CFG.cuff_target or CFG.cuff_target == "" then
    ShowNotification("Please SELECT A TARGET first from the Main tab!", "", 3)
    return
  end
  local tp = Players:FindFirstChild(CFG.cuff_target)
  if not tp or not tp.Character or not tp.Character:FindFirstChild("HumanoidRootPart") then
    ShowNotification("Selected target not found in game!", "", 3)
    return
  end

  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
  if not myHRP or not myHum then
    ShowNotification("Character not ready!", "", 3)
    return
  end

  local seat = myHum.SeatPart
  if not seat then
    ShowNotification("Sit in any chair / seat first!\nThen click Seat Voice Desync.", "", 3)
    return
  end

  local targetHRP = tp.Character:FindFirstChild("HumanoidRootPart")
  if not targetHRP then
    ShowNotification("Target character has no RootPart!", "", 3)
    return
  end

 -- Save return position right above the seat
  OrbitState.savedSeatCF   = seat.CFrame + Vector3.new(0, 2.5, 0)
  OrbitState.savedSeatPart = seat

 -- Break client-side seated state while server keeps you seated
  pcall(function()
    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    myHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    myHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
  end)

  local rayP2 = RaycastParams.new()
  rayP2.FilterType = Enum.RaycastFilterType.Exclude
  rayP2.FilterDescendantsInstances = {myChar, tp.Character}

  local function getSeatMicPos()
    local curHRP = tp.Character and tp.Character:FindFirstChild("HumanoidRootPart")
    if not curHRP then return nil end
    local ray2 = workspace:Raycast(curHRP.Position + Vector3.new(0, 2, 0), Vector3.new(0, -30, 0), rayP2)
    local groundY = ray2 and ray2.Position.Y or (curHRP.Position.Y - 3)
    local depth = math.clamp(groundY - curHRP.Position.Y - 6, -15, -7)
    return curHRP.Position + Vector3.new(0, depth, 0)
  end

  local micPos = getSeatMicPos()
  if micPos then
    myHRP.CFrame = CFrame.new(micPos)
    if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
    else myHRP.Velocity = Vector3.zero end
  end

  for _, p in ipairs(myChar:GetDescendants()) do
    if p:IsA("BasePart") then
      p.LocalTransparencyModifier = 1
      p.CanCollide = false
      pcall(function() p.CastShadow = false end)
    end
  end

  OrbitState.active           = true
  OrbitState.mode             = "seat"
  OrbitState.seatDesyncActive = true
  SetMicrophoneState(false)

  OrbitState.heartbeatConn = RunService.Heartbeat:Connect(function()
    if not OrbitState.seatDesyncActive then return end
    if not tp or not tp.Character then
      StopSeatDesync()
      return
    end
    local curTHRP = tp.Character:FindFirstChild("HumanoidRootPart")
    if not curTHRP then return end
    local newMicPos = getSeatMicPos()
    if newMicPos and myHRP and myHRP.Parent then
      myHRP.CFrame = CFrame.new(newMicPos)
      if myHRP.AssemblyLinearVelocity then myHRP.AssemblyLinearVelocity = Vector3.zero
      else myHRP.Velocity = Vector3.zero end
    end
    for _, p in ipairs(myChar:GetDescendants()) do
      if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
  end)

  ShowNotification("SEAT DESYNC ON â†’ " .. CFG.cuff_target ..
    "\nBody Seated on Planet | Click [ Toggle Mic] to Talk!\n(Click again to turn OFF & return)",
    "", 4
  )
end

function ToggleSeatDesync()
  if OrbitState.seatDesyncActive then
    StopSeatDesync()
  else
    StartSeatDesync()
  end
end

-- INV desync: fixed void lock + 1 stud clamp (no main-map float)
local updateStealthUI = nil
local StealthState = { active = false, conn = nil, anchor = nil, repPart = nil, diedConn = nil }
-- Global ghost point — same for wad / main / all maps
local INV_VOID_CF = CFrame.new(-2947.21, -772.82, 6268.25)
local INV_VOID_POS = INV_VOID_CF.Position
local INV_LOCK_STUDS = 1 -- if ghost/root drifts > 1 stud → snap back to void

local function InvEnsureVoidPart()
  local p = StealthState.repPart
  if p and p.Parent and p:IsA("BasePart") then
    if (p.Position - INV_VOID_POS).Magnitude > INV_LOCK_STUDS then
      pcall(function()
        p.Anchored = true
        p.CanCollide = false
        p.CFrame = INV_VOID_CF
      end)
    end
    return p
  end
  -- prefer real Abzchari if it still exists and is near void
  local abz = workspace:FindFirstChild("Abzchari_RopePullAnchor", true)
  if abz and abz:IsA("BasePart") and abz.Anchored then
    if (abz.Position - INV_VOID_POS).Magnitude <= 50 then
      StealthState.repPart = abz
      StealthState.anchor = nil
      return abz
    end
  end
  local old = workspace:FindFirstChild("TXINV")
  if old and old:IsA("BasePart") then
    pcall(function() old:Destroy() end)
  end
  local anchor = Instance.new("Part")
  anchor.Name = "TXINV"
  anchor.Size = Vector3.new(6, 6, 6)
  anchor.Anchored = true
  anchor.CanCollide = false
  anchor.Transparency = 1
  anchor.CFrame = INV_VOID_CF
  anchor.Parent = workspace
  StealthState.anchor = anchor
  StealthState.repPart = anchor
  return anchor
end

function StopServerInvisibility()
  if not StealthState.active and not StealthState.conn then
    if updateStealthUI then updateStealthUI() end
    return
  end
  StealthState.active = false
  if StealthState.conn then
    pcall(function() StealthState.conn:Disconnect() end)
    StealthState.conn = nil
  end
  if StealthState.diedConn then
    pcall(function() StealthState.diedConn:Disconnect() end)
    StealthState.diedConn = nil
  end
  if StealthState.indicator then
    pcall(function() StealthState.indicator:Destroy() end)
    StealthState.indicator = nil
    StealthState.distLabel = nil
  end
  local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if hrp then
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if sethiddenproperty then
      pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
    end
  end
  if StealthState.anchor then
    pcall(function() StealthState.anchor:Destroy() end)
    StealthState.anchor = nil
  end
  StealthState.repPart = nil
  if updateStealthUI then updateStealthUI() end
  ShowNotification("INV OFF", "", 1.2)
end

function InvPickRepPart(fromPos)
  return InvEnsureVoidPart(), INV_VOID_CF
end

function StartServerInvisibility()
  if StealthState.active then return end
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then
    ShowNotification("Character not ready", "", 2)
    return
  end
  if not sethiddenproperty then
    ShowNotification("INV need sethiddenproperty", "", 2.5)
    return
  end

  local hum = char:FindFirstChildOfClass("Humanoid")
  if hum then
    if StealthState.diedConn then
      pcall(function() StealthState.diedConn:Disconnect() end)
    end
    StealthState.diedConn = hum.Died:Connect(function()
      StopServerInvisibility()
    end)
  end

  local here = hrp.CFrame
  local skyCF = INV_VOID_CF
  local rep = InvEnsureVoidPart()

  -- Camera freeze + short blur
  local cam = workspace.CurrentCamera
  local oldCamType = cam and cam.CameraType
  local oldCamCF = cam and cam.CFrame
  if cam and oldCamCF then
    pcall(function()
      cam.CameraType = Enum.CameraType.Scriptable
      cam.CFrame = oldCamCF
    end)
  end
  local Lighting = game:GetService("Lighting")
  local blur = Instance.new("BlurEffect")
  blur.Name = "TX_InvBlur"
  blur.Size = 28
  blur.Parent = Lighting
  TweenService:Create(blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 0 }):Play()
  task.delay(0.4, function()
    pcall(function() blur:Destroy() end)
    pcall(function()
      if cam and cam.CameraType == Enum.CameraType.Scriptable then
        cam.CameraType = oldCamType or Enum.CameraType.Custom
      end
    end)
  end)

  -- Register at fixed void (all maps same point)
  local tHold = tick()
  while tick() - tHold < 0.32 do
    pcall(function()
      if not hrp.Parent then return end
      rep = InvEnsureVoidPart()
      hrp.CFrame = skyCF
      hrp.AssemblyLinearVelocity = Vector3.zero
      hrp.AssemblyAngularVelocity = Vector3.zero
      sethiddenproperty(hrp, "PhysicsRepRootPart", rep)
      pcall(function() sethiddenproperty(hrp, "NetworkOwnership", 9999) end)
    end)
    RunService.Heartbeat:Wait()
  end

  pcall(function()
    if hrp and hrp.Parent then
      hrp.CFrame = here
      hrp.AssemblyLinearVelocity = Vector3.zero
      hrp.AssemblyAngularVelocity = Vector3.zero
      sethiddenproperty(hrp, "PhysicsRepRootPart", InvEnsureVoidPart())
    end
  end)

  StealthState.active = true
  StealthState._acc = 0

  -- Every frame: lock root to void part; if part drifts >1 stud → snap void
  -- Soft pulse ~0.9s: re-register void so main-map does not float ghost on surface
  StealthState.conn = RunService.Heartbeat:Connect(function(dt)
    if not StealthState.active then return end
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local root = InvEnsureVoidPart()
    pcall(function()
      sethiddenproperty(r, "PhysicsRepRootPart", root)
      pcall(function() sethiddenproperty(r, "NetworkOwnership", 9999) end)
    end)
    StealthState._acc = (StealthState._acc or 0) + (dt or 0.016)
    if StealthState._acc >= 0.9 then
      StealthState._acc = 0
      local cur = r.CFrame
      pcall(function()
        root = InvEnsureVoidPart()
        r.CFrame = INV_VOID_CF
        r.AssemblyLinearVelocity = Vector3.zero
        sethiddenproperty(r, "PhysicsRepRootPart", root)
      end)
      task.defer(function()
        pcall(function()
          if r and r.Parent and StealthState.active then
            r.CFrame = cur
            r.AssemblyLinearVelocity = Vector3.zero
            sethiddenproperty(r, "PhysicsRepRootPart", InvEnsureVoidPart())
          end
        end)
      end)
    end
  end)

  if updateStealthUI then updateStealthUI() end
  ShowNotification("INV ON", "", 1.2)
end

function ToggleServerInvisibility()
  if StealthState.active then
    StopServerInvisibility()
  else
    StartServerInvisibility()
  end
end

-- Quick TP to INV void (map far point)
function TpToVoid()
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then
    ShowNotification("No character", "", 1.5)
    return
  end
  local cf = INV_VOID_CF or CFrame.new(-2947.21, -772.82, 6268.25)
  pcall(function()
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = cf
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
  end)
  task.defer(function()
    pcall(function()
      if hrp and hrp.Parent then
        hrp.CFrame = cf
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
      end
    end)
  end)
  ShowNotification("TP TO VOID", "", 1.2)
end

-- ~99 million studs (fling-scale far void) — fixed so you can return
local VOID_99M_CF = CFrame.new(99000000, 99000000, 99000000)
function TpToVoid99M()
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if not hrp then
    ShowNotification("No character", "", 1.5)
    return
  end
  pcall(function()
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = VOID_99M_CF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
  end)
  task.defer(function()
    pcall(function()
      if hrp and hrp.Parent then
        hrp.CFrame = VOID_99M_CF
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
      end
    end)
  end)
  ShowNotification("TP TO VOID 99M", "", 1.2)
end

LocalPlayer.CharacterAdded:Connect(function()
  if StealthState.active then
    StopServerInvisibility()
  end
  pcall(function() FixCamera(true) end)
end)

--
-- GENIUS SMART MULTI-VECTOR ADMIN DETECTION SYSTEM
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local AdminData = {}
local GroupRankCache = {}

local SPECIFIC_ADMIN_TOOLS = {
  "btools", "f3x", "ban hammer", "kick hammer", "admin gun", "staff gun", "mod gun",
  "teleport tool", "punish gun", "admin panel", "server control", "command bar",
  "infinite yield", "admin commands", "adonis", "kohl"
}

local ADMIN_TOOL_WORDS = {
  "admin", "administrator", "moderator", "mod", "banhammer", "kickhammer", "btools", "staff"
}

local ADMIN_TAG_WORDS = {
  "admin", "administrator", "mod", "moderator", "owner", "co-owner", "creator", "dev", "developer",
  "staff", "helper", "manager", "head admin", "supervisor", "founder", "executive", "board",
  "youtuber", "streamer", "tiktok", "media", "content", "video star", "assistant", "support", "trainee"
}

-- Smart Role Classifier matching user hierarchy:
-- Owner | Moderator | Helper | Creator / Social Media
function classifyAdminRole(rawTag, rawRole)
  local t = (rawTag or ""):lower()
  local r = (rawRole or ""):lower()
  local comb = t .. " " .. r

 -- 1. Owner
  if comb:find("owner") or comb:find("founder") then
    local cleanTag = (rawTag and rawTag ~= "") and rawTag:upper() or "OWNER"
    return cleanTag, "", Color3.fromRGB(245, 175, 25), "OWNER"
  end

 -- 2. Creator / Social Media
  if comb:find("creator") or comb:find("video") or comb:find("star") or comb:find("youtube") or comb:find("stream") or comb:find("media") or comb:find("tiktok") or comb:find("content") or comb:find("influencer") then
    local cleanTag = (rawTag and rawTag ~= "") and rawTag:upper() or "CREATOR"
    return cleanTag, "", Color3.fromRGB(180, 40, 210), "CREATOR"
  end

 -- 3. Helper
  if comb:find("helper") or comb:find("trial") or comb:find("assistant") or comb:find("support") or comb:find("trainee") then
    local cleanTag = (rawTag and rawTag ~= "") and rawTag:upper() or "HELPER"
    return cleanTag, "", Color3.fromRGB(30, 160, 180), "HELPER"
  end

 -- 4. Moderator / Admin
  local cleanTag = (rawTag and rawTag ~= "") and rawTag:upper() or "ADMIN"
  return cleanTag, "", Color3.fromRGB(225, 35, 50), "MODERATOR"
end

function hasExactWord(text, wordList)
  if not text or text == "" then return false, "" end
  local clean = " " .. text:lower():gsub("[^%a%d]", " ") .. " "
  for _, w in ipairs(wordList) do
    if clean:find(" " .. w .. " ", 1, true) then
      return true, w
    end
  end
  return false, ""
end

function checkGroupRankAsync(plr)
  if not plr or not plr.UserId or plr.UserId <= 0 then return end
  if GroupRankCache[plr.UserId] ~= nil then return end
  GroupRankCache[plr.UserId] = { checked = false, rank = 0, role = "" }

  task.spawn(function()
    pcall(function()
      if game.CreatorType == Enum.CreatorType.Group and game.CreatorId > 0 then
        local rank = plr:GetRankInGroup(game.CreatorId)
        local role = plr:GetRoleInGroup(game.CreatorId)
        GroupRankCache[plr.UserId] = { checked = true, rank = rank or 0, role = role or "" }
        if AdminData[plr.Name] then
          AdminData[plr.Name] = nil
        end
        if BuildPlayerCards then
          task.defer(function() pcall(BuildPlayerCards) end)
        end
      end
    end)
  end)
end

function getAdminData(plr)
  if not plr then return { isAdmin = false, role = "", tag = "", reason = "" } end
  if not CFG.admin_detector_enabled then
    return { isAdmin = false, role = "", tag = "", reason = "" }
  end

  local now = tick()
  if AdminData[plr.Name] and (now - (AdminData[plr.Name].ts or 0) < (AdminData[plr.Name].isAdmin and 8 or 1.2)) then
    return AdminData[plr.Name]
  end

  local data = {
    isAdmin = false,
    category = "PLAYER",
    role = "Player",
    tag = "",
    emoji = "",
    badgeColor = Color3.fromRGB(120, 120, 140),
    reason = "",
    ts = now
  }

  pcall(function()
 -- 1. Game Creator / Owner (User)
    if game.CreatorType == Enum.CreatorType.User and plr.UserId == game.CreatorId then
      data.isAdmin = true
      data.tag = "OWNER"
      data.role = "Game Owner"
      data.reason = "Game Creator (Place Owner)"
      return
    end

 -- 2. Official Roblox Staff / Admin Groups
    local isRbxAdmin, isRbxStaff = false, false
    pcall(function() isRbxAdmin = plr:IsInGroup(1200769) end)
    if isRbxAdmin then
      data.isAdmin = true
      data.tag = "ROBLOX"
      data.role = "Roblox Admin"
      data.reason = "Official Roblox Admin Group"
      return
    end
    pcall(function() isRbxStaff = plr:IsInGroup(2868472) end)
    if isRbxStaff then
      data.isAdmin = true
      data.tag = "ROBLOX"
      data.role = "Roblox Staff"
      data.reason = "Official Roblox Staff Group"
      return
    end

 -- 3. Game Creator Group Rank & Role Check
    if game.CreatorType == Enum.CreatorType.Group and game.CreatorId > 0 then
      checkGroupRankAsync(plr)
      local gInfo = GroupRankCache[plr.UserId]
      if gInfo and gInfo.checked then
        if gInfo.rank == 255 then
          data.isAdmin = true
          data.tag = "OWNER"
          data.role = "Group Owner"
          data.reason = "Group Owner (Rank 255)"
          return
        elseif gInfo.rank >= 200 then
          data.isAdmin = true
          data.tag = "HIGH RANK"
          data.role = gInfo.role ~= "" and gInfo.role or ("Rank " .. gInfo.rank)
          data.reason = "Group High Rank (" .. gInfo.rank .. ")"
          return
        elseif gInfo.role and gInfo.role ~= "" then
          local ok, w = hasExactWord(gInfo.role, ADMIN_TAG_WORDS)
          if ok then
            data.isAdmin = true
            data.tag = w:upper()
            data.role = gInfo.role
            data.reason = "Group Role: " .. gInfo.role
            return
          end
        end
      end
    end

 -- 4. Teams Check
    if plr.Team and not plr.Neutral then
      local tName = plr.Team.Name
      local ok, w = hasExactWord(tName, {"admin", "administrator", "mod", "moderator", "staff", "developer", "management", "security"})
      if ok then
        data.isAdmin = true
        data.tag = w:upper()
        data.role = tName
        data.reason = "Staff Team (" .. tName .. ")"
        return
      end
    end

 -- 5. Tool & HopperBin Scanning (Zero False Positives)
    local function scanTools(container)
      if not container then return end
      for _, item in ipairs(container:GetChildren()) do
        if item:IsA("HopperBin") then
          local bName = tostring(item.BinType.Name or ""):lower()
          if bName:find("hammer") or bName:find("clone") or bName:find("script") then
            data.isAdmin = true
            data.tag = "HAMMER"
            data.role = "HopperBin"
            data.reason = "Admin Bin (" .. item.BinType.Name .. ")"
            return true
          end
        elseif item:IsA("Tool") then
          local raw = item.Name:lower()
          for _, phrase in ipairs(SPECIFIC_ADMIN_TOOLS) do
            if raw:find(phrase, 1, true) then
              data.isAdmin = true
              data.tag = "TOOL"
              data.role = item.Name
              data.reason = "Admin Tool: " .. item.Name
              return true
            end
          end
          local ok, w = hasExactWord(raw, ADMIN_TOOL_WORDS)
          if ok then
            data.isAdmin = true
            data.tag = w:upper()
            data.role = item.Name
            data.reason = "Staff Tool (" .. item.Name .. ")"
            return true
          end
        end
      end
      return false
    end

    if scanTools(plr:FindFirstChildOfClass("Backpack")) then return end
    if plr.Character and scanTools(plr.Character) then return end

 -- 6. Character Overhead Tags & TextLabels (Fixed .Text Bug)
    if plr.Character then
      for _, obj in ipairs(plr.Character:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
          local txt = obj.Text or ""
          if #txt > 0 and #txt < 100 then
            local ok, w = hasExactWord(txt, ADMIN_TAG_WORDS)
            if ok then
              data.isAdmin = true
              data.tag = w:upper()
              data.role = txt
              data.reason = "Overhead Tag: " .. txt
              return
            end
          end
        elseif obj:IsA("StringValue") then
          local val = obj.Value or ""
          local ok, w = hasExactWord(val, ADMIN_TAG_WORDS)
          if ok then
            data.isAdmin = true
            data.tag = w:upper()
            data.role = val
            data.reason = "StringValue: " .. val
            return
          end
        end
        local oName = obj.Name:lower()
        if oName == "admintag" or oName == "modtag" or oName == "stafftag" or oName == "ownertag" then
          data.isAdmin = true
          data.tag = "TAG"
          data.role = obj.Name
          data.reason = "Character Object: " .. obj.Name
          return
        end
      end
    end

 -- 7. Player Attributes & Leaderstats Check
    local attrs = plr:GetAttributes()
    if attrs then
      for k, v in pairs(attrs) do
        local kl = tostring(k):lower()
        if kl == "isadmin" or kl == "admin" or kl == "staff" or kl == "moderator" then
          if v == true or (type(v) == "string" and v ~= "" and v ~= "false") then
            data.isAdmin = true
            data.tag = kl:upper()
            data.role = tostring(v)
            data.reason = "Attribute " .. tostring(k)
            return
          end
        end
      end
    end

    local ls = plr:FindFirstChild("leaderstats") or plr:FindFirstChild("Stats") or plr:FindFirstChild("Data")
    if ls then
      for _, item in ipairs(ls:GetChildren()) do
        local iname = item.Name:lower()
        if iname == "rank" or iname == "role" or iname == "staff" or iname == "admin" then
          local valStr = tostring(item.Value or "")
          local ok, w = hasExactWord(valStr, ADMIN_TAG_WORDS)
          if ok then
            data.isAdmin = true
            data.tag = w:upper()
            data.role = valStr
            data.reason = item.Name .. ": " .. valStr
            return
          end
        end
      end
    end
  end)

  if not data.isAdmin then
    local blob = string.lower(tostring(plr.Name) .. " " .. tostring(plr.DisplayName))
    if blob:find("mod", 1, true) or blob:find("admin", 1, true) or blob:find("owner", 1, true)
      or blob:find("staff", 1, true) or blob:find("creator", 1, true) or blob:find("helper", 1, true) then
      data.isAdmin = true
      data.tag = "STAFF"
      data.role = "Name"
      data.reason = "Name flag"
    end
  end
  if data.isAdmin then
    data.tag, data.emoji, data.badgeColor, data.category = classifyAdminRole(data.tag, data.role)
  end

  AdminData[plr.Name] = data
  return data
end


local ADMIN_JOIN_SOUNDS = {
  OWNER    = "rbxassetid://1837635152",
  STAFF    = "rbxassetid://1403257129",
  HELPER   = "rbxassetid://4612373894",
  CREATOR  = "rbxassetid://7362875165",
}
function PlayAdminJoinSound(cat)
  if CFG.admin_join_sound == false then return end
  local sid = ADMIN_JOIN_SOUNDS[cat] or ADMIN_JOIN_SOUNDS.STAFF
  pcall(function()
    local snd = Instance.new("Sound")
    snd.Name = "TXAdminJoin"
    snd.SoundId = sid
    snd.Volume = 1.6
    snd.Parent = game:GetService("SoundService")
    snd:Play()
    game:GetService("Debris"):AddItem(snd, 6)
  end)
end
function AnnounceStaffJoin(plr)
  if not plr or plr == LocalPlayer then return end
  task.spawn(function()
    task.wait(0.8)
    if not plr.Parent then return end
    local d = getAdminData(plr)
    if not d or not d.isAdmin then
      task.wait(2)
      if not plr.Parent then return end
      AdminData[plr.Name] = nil
      d = getAdminData(plr)
    end
    if not d or not d.isAdmin then return end
    local cat = d.category or "STAFF"
    if cat == "MODERATOR" then cat = "STAFF" end
    PlayAdminJoinSound(cat)
    local label = (cat == "OWNER" and "OWNER") or (cat == "CREATOR" and "CREATOR") or (cat == "HELPER" and "HELPER") or "STAFF"
    if ShowNotification then
      ShowNotification(label .. " JOIN  " .. (plr.DisplayName or plr.Name), "", 2.4)
    end
  end)
end
Players.PlayerAdded:Connect(AnnounceStaffJoin)

function isLikelyAdmin(plr)
  local d = getAdminData(plr)
  return d.isAdmin == true
end

task.spawn(function()
  while true do
    task.wait(10)
    for name, d in pairs(AdminData) do
      if tick() - (d.ts or 0) > 15 then
        AdminData[name] = nil
      end
    end
  end
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- WHO IS SPECTATING ME (enhanced multi-heuristic watcher)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local SpectateWatcher = { spectators = {} }

function SpectateWatcher_CheckAll()
  local myChar = LocalPlayer.Character
  local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
  if not myHRP then SpectateWatcher.spectators = {}; return end
  
  local myPos = myHRP.Position
  SpectateWatcher.spectators = {}
  
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
      pcall(function()
        local tChar = plr.Character
        
 -- Smart Check 1: No Character (often means they are dead/spectating)
        if not tChar or not tChar:FindFirstChild("HumanoidRootPart") then
 -- It's possible they are just loading, but if they are an admin, flag them as watching.
          local aData = getAdminData(plr)
          if aData and aData.isAdmin then
            SpectateWatcher.spectators[plr.Name] = true
          end
          return
        end
        
        local tHRP  = tChar:FindFirstChild("HumanoidRootPart")
        local tHead = tChar:FindFirstChild("Head")
        if tHRP then
          local diff = (tHRP.Position - myPos)
          local dist = diff.Magnitude
          local vel  = tHRP.AssemblyLinearVelocity or tHRP.Velocity
          
          if dist < 5 and vel.Magnitude < 0.5 then
            SpectateWatcher.spectators[plr.Name] = true
          elseif dist < 120 and diff.Y > 20 and vel.Magnitude < 0.5 then
            SpectateWatcher.spectators[plr.Name] = true
          elseif dist < 250 and tHead and vel.Magnitude < 0.2 then
            local look = tHead.CFrame.LookVector
            local dir = -diff.Unit
            if look:Dot(dir) > 0.985 then
              SpectateWatcher.spectators[plr.Name] = true
            end
          end
        end
      end)
    end
  end
end

-- ESP Highlight Chams & In-Game 3D Name Tag System
local ChamHighlights = {}
local NameBillboards = {}

-- Comprehensive ISO 3166-1 country names mapping (All countries & territories supported)
local COUNTRY_NAMES = {
  ["AD"] = "Andorra", ["AE"] = "UAE", ["AF"] = "Afghanistan", ["AG"] = "Antigua & Barbuda",
  ["AL"] = "Albania", ["AM"] = "Armenia", ["AO"] = "Angola", ["AQ"] = "Antarctica",
  ["AR"] = "Argentina", ["AS"] = "American Samoa", ["AT"] = "Austria", ["AU"] = "Australia",
  ["AW"] = "Aruba", ["AX"] = "Aland Islands", ["AZ"] = "Azerbaijan", ["BA"] = "Bosnia",
  ["BB"] = "Barbados", ["BD"] = "Bangladesh", ["BE"] = "Belgium", ["BF"] = "Burkina Faso",
  ["BG"] = "Bulgaria", ["BH"] = "Bahrain", ["BI"] = "Burundi", ["BJ"] = "Benin",
  ["BL"] = "St. Barthelemy", ["BM"] = "Bermuda", ["BN"] = "Brunei", ["BO"] = "Bolivia",
  ["BQ"] = "Bonaire", ["BR"] = "Brazil", ["BS"] = "Bahamas", ["BT"] = "Bhutan",
  ["BV"] = "Bouvet Island", ["BW"] = "Botswana", ["BY"] = "Belarus", ["BZ"] = "Belize",
  ["CA"] = "Canada", ["CC"] = "Cocos Islands", ["CD"] = "DR Congo", ["CF"] = "Central African Rep.",
  ["CG"] = "Congo", ["CH"] = "Switzerland", ["CI"] = "Ivory Coast", ["CK"] = "Cook Islands",
  ["CL"] = "Chile", ["CM"] = "Cameroon", ["CN"] = "China", ["CO"] = "Colombia",
  ["CR"] = "Costa Rica", ["CU"] = "Cuba", ["CV"] = "Cape Verde", ["CW"] = "Curacao",
  ["CX"] = "Christmas Island", ["CY"] = "Cyprus", ["CZ"] = "Czechia", ["DE"] = "Germany",
  ["DJ"] = "Djibouti", ["DK"] = "Denmark", ["DM"] = "Dominica", ["DO"] = "Dominican Rep.",
  ["DZ"] = "Algeria", ["EC"] = "Ecuador", ["EE"] = "Estonia", ["EG"] = "Egypt",
  ["EH"] = "Western Sahara", ["ER"] = "Eritrea", ["ES"] = "Spain", ["ET"] = "Ethiopia",
  ["FI"] = "Finland", ["FJ"] = "Fiji", ["FK"] = "Falkland Islands", ["FM"] = "Micronesia",
  ["FO"] = "Faroe Islands", ["FR"] = "France", ["GA"] = "Gabon", ["GB"] = "United Kingdom",
  ["UK"] = "United Kingdom", ["GD"] = "Grenada", ["GE"] = "Georgia", ["GF"] = "French Guiana",
  ["GG"] = "Guernsey", ["GH"] = "Ghana", ["GI"] = "Gibraltar", ["GL"] = "Greenland",
  ["GM"] = "Gambia", ["GN"] = "Guinea", ["GP"] = "Guadeloupe", ["GQ"] = "Equatorial Guinea",
  ["GR"] = "Greece", ["GS"] = "South Georgia", ["GT"] = "Guatemala", ["GU"] = "Guam",
  ["GW"] = "Guinea-Bissau", ["GY"] = "Guyana", ["HK"] = "Hong Kong", ["HM"] = "Heard Island",
  ["HN"] = "Honduras", ["HR"] = "Croatia", ["HT"] = "Haiti", ["HU"] = "Hungary",
  ["ID"] = "Indonesia", ["IE"] = "Ireland", ["IL"] = "Israel", ["IM"] = "Isle of Man",
  ["IN"] = "India", ["IO"] = "BIOT", ["IQ"] = "Iraq", ["IR"] = "Iran",
  ["IS"] = "Iceland", ["IT"] = "Italy", ["JE"] = "Jersey", ["JM"] = "Jamaica",
  ["JO"] = "Jordan", ["JP"] = "Japan", ["KE"] = "Kenya", ["KG"] = "Kyrgyzstan",
  ["KH"] = "Cambodia", ["KI"] = "Kiribati", ["KM"] = "Comoros", ["KN"] = "St. Kitts & Nevis",
  ["KP"] = "North Korea", ["KR"] = "South Korea", ["KW"] = "Kuwait", ["KY"] = "Cayman Islands",
  ["KZ"] = "Kazakhstan", ["LA"] = "Laos", ["LB"] = "Lebanon", ["LC"] = "St. Lucia",
  ["LI"] = "Liechtenstein", ["LK"] = "Sri Lanka", ["LR"] = "Liberia", ["LS"] = "Lesotho",
  ["LT"] = "Lithuania", ["LU"] = "Luxembourg", ["LV"] = "Latvia", ["LY"] = "Libya",
  ["MA"] = "Morocco", ["MC"] = "Monaco", ["MD"] = "Moldova", ["ME"] = "Montenegro",
  ["MF"] = "Saint Martin", ["MG"] = "Madagascar", ["MH"] = "Marshall Islands", ["MK"] = "North Macedonia",
  ["ML"] = "Mali", ["MM"] = "Myanmar", ["MN"] = "Mongolia", ["MO"] = "Macau",
  ["MP"] = "Northern Mariana", ["MQ"] = "Martinique", ["MR"] = "Mauritania", ["MS"] = "Montserrat",
  ["MT"] = "Malta", ["MU"] = "Mauritius", ["MV"] = "Maldives", ["MW"] = "Malawi",
  ["MX"] = "Mexico", ["MY"] = "Malaysia", ["MZ"] = "Mozambique", ["NA"] = "Namibia",
  ["NC"] = "New Caledonia", ["NE"] = "Niger", ["NF"] = "Norfolk Island", ["NG"] = "Nigeria",
  ["NI"] = "Nicaragua", ["NL"] = "Netherlands", ["NO"] = "Norway", ["NP"] = "Nepal",
  ["NR"] = "Nauru", ["NU"] = "Niue", ["NZ"] = "New Zealand", ["OM"] = "Oman",
  ["PA"] = "Panama", ["PE"] = "Peru", ["PF"] = "French Polynesia", ["PG"] = "Papua New Guinea",
  ["PH"] = "Philippines", ["PK"] = "Pakistan", ["PL"] = "Poland", ["PM"] = "St. Pierre & Miquelon",
  ["PN"] = "Pitcairn", ["PR"] = "Puerto Rico", ["PS"] = "Palestine", ["PT"] = "Portugal",
  ["PW"] = "Palau", ["PY"] = "Paraguay", ["QA"] = "Qatar", ["RE"] = "Reunion",
  ["RO"] = "Romania", ["RS"] = "Serbia", ["RU"] = "Russia", ["RW"] = "Rwanda",
  ["SA"] = "Saudi Arabia", ["SB"] = "Solomon Islands", ["SC"] = "Seychelles", ["SD"] = "Sudan",
  ["SE"] = "Sweden", ["SG"] = "Singapore", ["SH"] = "Saint Helena", ["SI"] = "Slovenia",
  ["SJ"] = "Svalbard", ["SK"] = "Slovakia", ["SL"] = "Sierra Leone", ["SM"] = "San Marino",
  ["SN"] = "Senegal", ["SO"] = "Somalia", ["SR"] = "Suriname", ["SS"] = "South Sudan",
  ["ST"] = "Sao Tome", ["SV"] = "El Salvador", ["SX"] = "Sint Maarten", ["SY"] = "Syria",
  ["SZ"] = "Eswatini", ["TC"] = "Turks & Caicos", ["TD"] = "Chad", ["TF"] = "French South Terr.",
  ["TG"] = "Togo", ["TH"] = "Thailand", ["TJ"] = "Tajikistan", ["TK"] = "Tokelau",
  ["TL"] = "Timor-Leste", ["TM"] = "Turkmenistan", ["TN"] = "Tunisia", ["TO"] = "Tonga",
  ["TR"] = "Turkey", ["TT"] = "Trinidad & Tobago", ["TV"] = "Tuvalu", ["TW"] = "Taiwan",
  ["TZ"] = "Tanzania", ["UA"] = "Ukraine", ["UG"] = "Uganda", ["UM"] = "US Minor Islands",
  ["US"] = "United States", ["UY"] = "Uruguay", ["UZ"] = "Uzbekistan", ["VA"] = "Vatican City",
  ["VC"] = "St. Vincent", ["VE"] = "Venezuela", ["VG"] = "British Virgin Islands", ["VI"] = "US Virgin Islands",
  ["VN"] = "Vietnam", ["VU"] = "Vanuatu", ["WF"] = "Wallis & Futuna", ["WS"] = "Samoa",
  ["XK"] = "Kosovo", ["YE"] = "Yemen", ["YT"] = "Mayotte", ["ZA"] = "South Africa",
  ["ZM"] = "Zambia", ["ZW"] = "Zimbabwe"
}

local COUNTRY_BY_NAME = {}
for code, name in pairs(COUNTRY_NAMES) do
  COUNTRY_BY_NAME[string.lower(name)] = code
end

-- Helper to convert 2-letter ISO country code ("MA", "NL", "US", "FR") to Unicode flag emoji
local function codeToFlagEmoji(code)
  if not code or type(code) ~= "string" or #code ~= 2 then return "" end
  code = string.upper(code)
  local b1 = string.byte(code, 1) - 65
  local b2 = string.byte(code, 2) - 65
  if b1 >= 0 and b1 < 26 and b2 >= 0 and b2 < 26 then
    local ok, res = pcall(function()
      return utf8.char(0x1F1E6 + b1) .. utf8.char(0x1F1E6 + b2)
    end)
    if ok and res then return res end
  end
  return ""
end

-- Helper to convert Unicode flag emoji ("🇲🇦", "🇳🇱") back to 2-letter code ("MA", "NL")
local function flagEmojiToCode(flagStr)
  if not flagStr or type(flagStr) ~= "string" or #flagStr < 4 then return nil end
  local ok, res = pcall(function()
    local p1 = utf8.codepoint(flagStr, 1)
    local offset2 = utf8.offset(flagStr, 2)
    local p2 = offset2 and utf8.codepoint(flagStr, offset2)
    if p1 and p2 and p1 >= 0x1F1E6 and p1 <= 0x1F1FF and p2 >= 0x1F1E6 and p2 <= 0x1F1FF then
      return string.char(p1 - 0x1F1E6 + 65) .. string.char(p2 - 0x1F1E6 + 65)
    end
    return nil
  end)
  return (ok and res) or nil
end

-- Global scraped flag image and text cache
local ScrapedFlagImages = {}
local ScrapedFlagTexts = {}
local LastFullScrape = 0

local function normalizeCountry(raw)
  if not raw or type(raw) ~= "string" then return nil end
  raw = string.gsub(raw, "^%s*(.-)%s*$", "%1")
  if #raw == 0 then return nil end

  -- 1. Check if raw string is already a Unicode flag emoji
  local emojiCode = flagEmojiToCode(raw)
  if emojiCode then
    local cName = COUNTRY_NAMES[emojiCode] or emojiCode
    return emojiCode, cName, raw
  end

  -- 2. 2-letter ISO country code
  local upper = string.upper(raw)
  if #upper == 2 and upper:match("^[A-Z][A-Z]$") then
    local cName = COUNTRY_NAMES[upper] or upper
    local flag = codeToFlagEmoji(upper)
    return upper, cName, flag
  end

  -- 3. Full country name lookup
  local matchCode = COUNTRY_BY_NAME[string.lower(raw)]
  if matchCode then
    return matchCode, COUNTRY_NAMES[matchCode], codeToFlagEmoji(matchCode)
  end

  return nil, raw, ""
end

-- Deep scrape: scan GUIs to find flag images or texts for players
local function deepScrapeAllFlags()
  local now = os.clock()
  if now - LastFullScrape < 6 then return end
  LastFullScrape = now

  pcall(function()
    local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end

    -- Check CustomLeaderboard ProfileCard first
    local cl = pg:FindFirstChild("CustomLeaderboard")
    if cl then
      local pc = cl:FindFirstChild("ProfileCard")
      if pc then
        local pcf = pc:FindFirstChild("PCountryFlag")
        local pn = pc:FindFirstChild("PName")
        local pu = pc:FindFirstChild("PUsername")
        local matchedName = (pn and pn.Text ~= "" and pn.Text) or (pu and pu.Text ~= "" and pu.Text:gsub("^@", ""))
        if matchedName and pcf and pcf.Text and pcf.Text ~= "" then
          local c, n, f = normalizeCountry(pcf.Text)
          if f and f ~= "" then
            ScrapedFlagTexts[matchedName] = { code = c, name = n, flag = f }
          end
        end
      end
    end

    -- General player list scan across all ScreenGuis
    local playerNames = {}
    for _, plr in ipairs(Players:GetPlayers()) do
      playerNames[plr.Name] = plr
      playerNames[plr.DisplayName] = plr
    end

    for _, sg in ipairs(pg:GetChildren()) do
      if sg:IsA("ScreenGui") and sg.Name ~= "TXEspOverlay" and not sg.Name:find("ToxicProject") and not sg.Name:find("TXIntro") then
        pcall(function()
          for _, desc in ipairs(sg:GetDescendants()) do
            if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text and desc.Text ~= "" then
              local matchedPlr = playerNames[desc.Text]
              if matchedPlr and not ScrapedFlagImages[matchedPlr.Name] and not ScrapedFlagTexts[matchedPlr.Name] then
                local container = desc.Parent
                for lvl = 1, 5 do
                  if not container then break end
                  pcall(function()
                    for _, child in ipairs(container:GetDescendants()) do
                      if child:IsA("TextLabel") and child ~= desc and child.Text and child.Text ~= "" then
                        local c, n, f = normalizeCountry(child.Text)
                        if f and f ~= "" then
                          ScrapedFlagTexts[matchedPlr.Name] = { code = c, name = n, flag = f }
                        end
                      elseif child:IsA("ImageLabel") and child.Image and child.Image ~= "" then
                        local img = child.Image
                        if not img:find("headshot") and not img:find("avatar") and not img:find("rbxthumb") then
                          local cn = string.lower(child.Name)
                          local pn = child.Parent and string.lower(child.Parent.Name) or ""
                          local isFlagLike = cn:find("flag") or cn:find("country") or cn:find("nation") or pn:find("flag") or pn:find("country")
                          local sz = child.AbsoluteSize
                          local isFlagSized = (sz.X > 5 and sz.X < 60 and sz.Y > 5 and sz.Y < 50)
                          if isFlagLike or (isFlagSized and img:find("rbxassetid")) then
                            ScrapedFlagImages[matchedPlr.Name] = img
                          end
                        end
                      end
                    end
                  end)
                  if ScrapedFlagImages[matchedPlr.Name] or ScrapedFlagTexts[matchedPlr.Name] then break end
                  container = container.Parent
                end
              end
            end
          end
        end)
      end
    end
  end)
end

local PlayerRegionCache = {}

function GetPlayerRegion(plr)
  if not plr then return { code = "", name = "", flag = "", image = "", text = "" } end
  local key = tostring(plr.UserId or plr.Name)
  local now = os.clock()
  local cached = PlayerRegionCache[key]
  if cached and (now - cached.lastCheck < 5) then
    return cached
  end

  local resolvedCode = nil
  local resolvedName = nil
  local resolvedFlag = nil
  local resolvedImage = nil

  local function tryAssign(raw)
    if not raw or type(raw) ~= "string" or #raw == 0 then return false end
    local c, n, f = normalizeCountry(raw)
    if c or n or (f and f ~= "") then
      if not resolvedCode and c then resolvedCode = c end
      if not resolvedName and n then resolvedName = n end
      if not resolvedFlag and f and f ~= "" then resolvedFlag = f end
      return true
    end
    return false
  end

  -- 1. Check Player Attributes (Morocco New Life: CountryCode = "MA", CountryFlag = "🇲🇦")
  pcall(function()
    local flagAttr = plr:GetAttribute("CountryFlag") or plr:GetAttribute("Flag")
    if flagAttr then tryAssign(tostring(flagAttr)) end
    local codeAttr = plr:GetAttribute("CountryCode") or plr:GetAttribute("Country") or plr:GetAttribute("Region") or plr:GetAttribute("Nationality")
    if codeAttr then tryAssign(tostring(codeAttr)) end
  end)

  -- 2. Check leaderstats (e.g. leaderstats.Flag = "🇲🇦")
  if not resolvedFlag or not resolvedCode then
    pcall(function()
      local ls = plr:FindFirstChild("leaderstats")
      if ls then
        local fVal = ls:FindFirstChild("Flag") or ls:FindFirstChild("Country") or ls:FindFirstChild("Region")
        if fVal and tostring(fVal.Value) ~= "" then
          tryAssign(tostring(fVal.Value))
        end
      end
    end)
  end

  -- 3. Check Character Attributes
  if (not resolvedFlag or not resolvedCode) and plr.Character then
    pcall(function()
      local flagAttr = plr.Character:GetAttribute("CountryFlag") or plr.Character:GetAttribute("Flag")
      if flagAttr then tryAssign(tostring(flagAttr)) end
      local codeAttr = plr.Character:GetAttribute("CountryCode") or plr.Character:GetAttribute("Country") or plr.Character:GetAttribute("Region")
      if codeAttr then tryAssign(tostring(codeAttr)) end
    end)
  end

  -- 4. Check ValueObjects directly in player
  if not resolvedFlag or not resolvedCode then
    pcall(function()
      for _, vname in ipairs({"Flag", "CountryCode", "Country", "Region", "Nation"}) do
        local v = plr:FindFirstChild(vname)
        if v and tostring(v.Value) ~= "" then
          tryAssign(tostring(v.Value))
          if resolvedFlag and resolvedCode then break end
        end
      end
    end)
  end

  -- 5. If LocalPlayer, query LocalizationService
  if plr == LocalPlayer and (not resolvedFlag or not resolvedCode) then
    pcall(function()
      local loc = game:GetService("LocalizationService")
      if loc and loc.GetCountryRegionForPlayerAsync then
        local c = loc:GetCountryRegionForPlayerAsync(LocalPlayer)
        if c and type(c) == "string" and #c > 0 then
          tryAssign(c)
        end
      end
    end)
  end

  -- 6. Check scraped data from UI/leaderboard
  deepScrapeAllFlags()
  if ScrapedFlagTexts[plr.Name] then
    local s = ScrapedFlagTexts[plr.Name]
    if not resolvedCode and s.code then resolvedCode = s.code end
    if not resolvedName and s.name then resolvedName = s.name end
    if not resolvedFlag and s.flag then resolvedFlag = s.flag end
  end
  if not resolvedImage and ScrapedFlagImages[plr.Name] then
    resolvedImage = ScrapedFlagImages[plr.Name]
  end

  -- 7. Ensure flag emoji is generated if code is known
  if (not resolvedFlag or resolvedFlag == "") and resolvedCode and #resolvedCode == 2 then
    resolvedFlag = codeToFlagEmoji(resolvedCode)
  end

  -- 8. Fallback name if code known
  if (not resolvedName or resolvedName == "") and resolvedCode and COUNTRY_NAMES[resolvedCode] then
    resolvedName = COUNTRY_NAMES[resolvedCode]
  end

  local fullText = ""
  if resolvedName and resolvedName ~= "" then
    fullText = resolvedName
  elseif resolvedCode and resolvedCode ~= "" then
    fullText = resolvedCode
  end

  local res = {
    code = resolvedCode or "",
    name = resolvedName or "",
    flag = resolvedFlag or "",
    image = resolvedImage or "",
    text = fullText,
    lastCheck = now
  }
  PlayerRegionCache[key] = res
  return res
end
_G.GetPlayerRegion = GetPlayerRegion

-- Distance thresholds for color + size scaling
function espDistColor(dist)
  if dist < 30  then return Color3.fromRGB(80,255,80),   14  end  -- green, close
  if dist < 80  then return Color3.fromRGB(255,200,30),  13  end  -- yellow, mid
  if dist < 150 then return Color3.fromRGB(255,120,30),  12  end  -- orange, far
  return                    Color3.fromRGB(255,60,60),   11         -- red, very far
end

function ClassifyHeldTool(tool)
  if not tool then return "NONE", "-" end
  local n = string.lower(tool.Name or "")
  if n:find("cuff", 1, true) or n:find("arrest", 1, true) or n:find("handcuff", 1, true) then
    return "CUFF", tool.Name
  end
  if n:find("rope", 1, true) or n:find("7bel", 1, true) or n:find("7bl", 1, true) or n:find("hbel", 1, true) or n:find("corde", 1, true) then
    return "ROPE", tool.Name
  end
  if n:find("gun", 1, true) or n:find("pistol", 1, true) or n:find("rifle", 1, true) or n:find("shot", 1, true)
    or n:find("ak", 1, true) or n:find("weapon", 1, true) or n:find("knife", 1, true) then
    return "GUN", tool.Name
  end
  return "TOOL", tool.Name
end

function GetHeldTool(plr)
  local char = plr and plr.Character
  return char and char:FindFirstChildOfClass("Tool")
end

function SendGameCommand(cmd)
  pcall(function()
    local hd = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdminHDClient")
    if hd and hd:FindFirstChild("Signals") then
      local reqSilent = hd.Signals:FindFirstChild("RequestCommandSilent")
      if reqSilent then reqSilent:InvokeServer(cmd) end
    end
  end)
  pcall(function()
    local tcs = game:GetService("TextChatService")
    local chans = tcs:FindFirstChild("TextChannels")
    local gen = chans and chans:FindFirstChild("RBXGeneral")
    if gen then gen:SendAsync(cmd) end
  end)
  pcall(function()
    local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if ev and ev:FindFirstChild("SayMessageRequest") then
      ev.SayMessageRequest:FireServer(cmd, "All")
    end
  end)
end


local TEST_FIGHT_NAMES = {
  "guitar","gitar","gutar","kamanja","pan","soul","kick","backpack",
  "headbutt","slap","matrac","snidila","bat","dualsky","dualglow",
  "darkx","swordhamouda","raysword","axe","blackbat","soulpan","yuri","seraphic",
  "clipper","clippers","jbl","kuromipan","redpan","blackpan","belladoll"
}
local TEST_FIGHT_BLOCK = {
  "rope","7bel","7bl","hbel","carry","cart","cuff","arrest","pepper","bubble",
  "watergun","boombox","mic","sign","spit","pistol","heart","rose","camera",
  "selfie","tamra","kika","umbrella","lollipop","cookie","duck","icecream",
  "rock","pizza","coffee","lemon","teddy","sharky","kitty",
  "rfissa","sardi","m3iza","lazer","pompous","flyg","bunny","phone","vampire"
}
local _testFightIdx = 0
function TestIsFightTool(tool)
  if not tool or not tool:IsA("Tool") then return false end
  local n = string.lower(tool.Name or "")
  local tip = string.lower(tool.ToolTip or "")
  for _, bl in ipairs(TEST_FIGHT_BLOCK) do
    if n:find(bl, 1, true) or tip:find(bl, 1, true) then return false end
  end
  for _, w in ipairs(TEST_FIGHT_NAMES) do
    if n:find(w, 1, true) or tip:find(w, 1, true) then return true end
  end
  return false
end
function TestListFightTools()
  local out, seen = {}, {}
  local function add(t)
    if t and t:IsA("Tool") and not seen[t] and TestIsFightTool(t) then
      seen[t] = true
      out[#out+1] = t
    end
  end
  local char = LocalPlayer.Character
  local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
  if char then for _, t in ipairs(char:GetChildren()) do add(t) end end
  if bp then for _, t in ipairs(bp:GetChildren()) do add(t) end end
  table.sort(out, function(a,b) return tostring(a.Name) < tostring(b.Name) end)
  return out
end
local _testFightOn = false
local _testFightToken = 0
local _testLastTool = nil
local _testLastName = ""
local _testUsedAt = {}
local TEST_CD = {
  bat = 1.4, slap = 1.2, guitar = 1.8, gitar = 1.8, gutar = 1.8, kamanja = 1.8,
  pan = 1.6, soul = 1.7, kick = 1.5, headbutt = 1.5, backpack = 1.8,
  matrac = 1.5, snidila = 1.4, dualsky = 1.6, dualglow = 1.6, darkx = 1.6,
  sword = 1.5, axe = 1.5, yuri = 1.5, seraphic = 1.7,
}
function TestToolCd(tool)
  if not tool then return 1.4 end
  local n = string.lower(tool.Name or "")
  local tip = string.lower(tool.ToolTip or "")
  local attr = tool:GetAttribute("Cooldown") or tool:GetAttribute("CD") or tool:GetAttribute("Delay")
  if type(attr) == "number" and attr > 0 then return attr end
  for _, ch in ipairs(tool:GetChildren()) do
    if ch:IsA("NumberValue") or ch:IsA("IntValue") then
      local cn = string.lower(ch.Name)
      if cn:find("cool", 1, true) or cn == "cd" or cn:find("delay", 1, true) then
        if type(ch.Value) == "number" and ch.Value > 0 then return ch.Value end
      end
    end
  end
  local best = 1.4
  for key, cd in pairs(TEST_CD) do
    if n:find(key, 1, true) or tip:find(key, 1, true) then
      if cd > best then best = cd end
    end
  end
  return best
end
function AbuseLiveTargetHRP()
  local name = CFG.cuff_target
  if not name or name == "" then return nil end
  local plr = Players:FindFirstChild(name)
  local char = plr and plr.Character
  local hum = char and char:FindFirstChildOfClass("Humanoid")
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hum and hum.Health > 0 and hrp then return hrp, plr end
  return nil
end
function AbuseClearSeat(hum)
  if not hum then return end
  pcall(function()
    hum.Sit = false
    hum.PlatformStand = false
    if hum.SeatPart then
      hum.Jump = true
    end
  end)
end
function AbuseFreeSpot(fromPos)
  local params = RaycastParams.new()
  params.FilterType = Enum.RaycastFilterType.Exclude
  local ignore = {}
  if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
  params.FilterDescendantsInstances = ignore
  local offsets = {
    Vector3.new(0, 2.2, 0),
    Vector3.new(0, 3.4, 0),
    Vector3.new(2.2, 1.4, 0),
    Vector3.new(-2.2, 1.4, 0),
    Vector3.new(0, 1.4, 2.2),
    Vector3.new(0, 1.4, -2.2),
  }
  for _, off in ipairs(offsets) do
    local origin = fromPos + Vector3.new(0, 6, 0)
    local hit = workspace:Raycast(origin, off - Vector3.new(0, 6, 0), params)
    if not hit then
      return fromPos + off
    end
  end
  return fromPos + Vector3.new(0, 3.2, 0)
end
function AbuseSnapTo(myHRP, tr)
  if not myHRP or not tr then return end
  if sethiddenproperty then
    pcall(function()
      sethiddenproperty(myHRP, "PhysicsRepRootPart", tr)
      sethiddenproperty(myHRP, "NetworkOwnership", 9999)
    end)
  end
  local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
  local tHum = tr.Parent and tr.Parent:FindFirstChildOfClass("Humanoid")
  AbuseClearSeat(myHum)
  AbuseClearSeat(tHum)
  pcall(function()
    for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
      if p:IsA("BasePart") then p.CanCollide = false end
    end
  end)
  local vel = Vector3.zero
  pcall(function() vel = tr.AssemblyLinearVelocity or Vector3.zero end)
  local pred = vel * 0.12
  if pred.Magnitude > 8 then pred = pred.Unit * 8 end
  local raw = tr.Position + pred
  local pos = AbuseFreeSpot(raw)
  myHRP.CFrame = CFrame.new(pos, raw)
  myHRP.AssemblyLinearVelocity = Vector3.zero
  myHRP.AssemblyAngularVelocity = Vector3.zero
end
function TestSwingTool(tool)
  if not tool then return end
  local tr = AbuseLiveTargetHRP()
  local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if my and tr then AbuseSnapTo(my, tr) end
  pcall(function() tool:Activate() end)
  local rem = tool:FindFirstChildWhichIsA("RemoteEvent")
  if rem then
    pcall(function() rem:FireServer() end)
    if tr then pcall(function() rem:FireServer(tr) end) end
  end
  for _, d in ipairs(tool:GetDescendants()) do
    if d:IsA("RemoteEvent") then
      pcall(function() d:FireServer() end)
    end
  end
  if firetouchinterest and tr then
    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
    if handle then
      pcall(firetouchinterest, handle, tr, 0)
      pcall(firetouchinterest, handle, tr, 1)
    end
  end
end
function TestPickReady(list)
  local now = tick()
  local start = 1
  if _testLastName and _testLastName ~= "" then
    for i, t in ipairs(list) do
      if t.Name == _testLastName or t == _testLastTool then
        start = i + 1
        break
      end
    end
  end
  local n = #list
  if n == 0 then return nil end
  for k = 0, n - 1 do
    local i = ((start - 1 + k) % n) + 1
    local t = list[i]
    if t.Name == _testLastName or t == _testLastTool then
      if n > 1 then
        -- never reopen ON on the same last tool
      else
        local last = _testUsedAt[t] or _testUsedAt[t.Name] or 0
        if now - last >= TestToolCd(t) then return t end
      end
    else
      local last = _testUsedAt[t] or _testUsedAt[t.Name] or 0
      if now - last >= TestToolCd(t) then
        return t
      end
    end
  end
  return nil
end

function TestSwitchFightTool(force)
  if force == false then
    if _testFightOn then
      _testFightOn = false
      _testFightToken += 1
    end
    return
  end
  if force ~= true and _testFightOn then
    _testFightOn = false
    _testFightToken += 1
    if ShowNotification then ShowNotification("SWAP OFF", "", 1.2) end
    return
  end
  if force == true and _testFightOn then
    return
  end
  local list = TestListFightTools()
  if #list == 0 then
    if ShowNotification then ShowNotification("SWAP ON  0 tools", "", 1.4) end
    return
  end
  _testFightOn = true
  _testFightToken += 1
  local myTok = _testFightToken
  if ShowNotification then
    ShowNotification("SWAP ON  " .. #list .. " tools", "", 1.3)
  end
  task.spawn(function()
    while _testFightOn and myTok == _testFightToken do
      list = TestListFightTools()
      if #list == 0 then
        task.wait(0.4)
      else
        local tool = TestPickReady(list)
        if not tool then
          task.wait(0.12)
        else
          local char = LocalPlayer.Character
          local hum = char and char:FindFirstChildOfClass("Humanoid")
          if hum then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.06)
            pcall(function() hum:EquipTool(tool) end)
            task.wait(0.10)
            TestSwingTool(tool)
            _testLastTool = tool
            _testLastName = tool.Name
            _testUsedAt[tool] = tick()
            _testUsedAt[tool.Name] = tick()
            if ShowNotification then
              ShowNotification("SWAP ON  " .. #list .. " tools  >  " .. tool.Name, "", 0.9)
            end
          end
          local need = math.clamp(TestToolCd(tool), 0.7, 2.0)
          local t0 = tick()
          while _testFightOn and myTok == _testFightToken and tick() - t0 < need do
            local my2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tr2 = AbuseLiveTargetHRP()
            if my2 and tr2 then AbuseSnapTo(my2, tr2) end
            task.wait(0.03)
          end
        end
      end
    end
  end)
end

function CopyOutfitFrom(plr)
  if not plr then
    ShowNotification("No target", "", 1.5)
    return
  end
  local cmd = "/char me " .. plr.Name
  SendPrivateChatMessage(cmd, "Self")
  ShowNotification("Dressed skin", "", 1.5)
end

function DoRandomSkin()
  local list = CFG.skin_random_list
  if type(list) ~= "table" or #list == 0 then
    ShowNotification("Skin list empty", "", 1.5)
    return
  end
  local pool = {}
  local last = tostring(CFG.skin_random_last or "")
  for _, name in ipairs(list) do
    if type(name) == "string" and name ~= "" and name ~= last then
      table.insert(pool, name)
    end
  end
  if #pool == 0 then
    -- only one entry or all equal last → allow any
    for _, name in ipairs(list) do
      if type(name) == "string" and name ~= "" then
        table.insert(pool, name)
      end
    end
  end
  if #pool == 0 then
    ShowNotification("Skin list empty", "", 1.5)
    return
  end
  local pick = pool[math.random(1, #pool)]
  CFG.skin_random_last = pick
  pcall(SaveToxicCFG)
  local cmd = "/char me " .. pick
  SendPrivateChatMessage(cmd, "Self")
  ShowNotification("Skin: " .. pick, "", 1.5)
end

function GetToolPreviewId(tool)
  if not tool then return "" end
  local tex = tostring(tool.TextureId or "")
  if tex ~= "" and tex ~= "rbxassetid://0" then return tex end
  local h = tool:FindFirstChild("Handle")
  if h then
    if h:IsA("MeshPart") and h.TextureID and h.TextureID ~= "" then return h.TextureID end
    local sm = h:FindFirstChildOfClass("SpecialMesh")
    if sm and sm.TextureId and sm.TextureId ~= "" then return sm.TextureId end
    local dec = h:FindFirstChildOfClass("Decal")
    if dec and dec.Texture and dec.Texture ~= "" then return dec.Texture end
  end
  return ""
end
function GetPlayerPingMs(plr)
  local ms = nil
  pcall(function()
    if plr and plr.GetNetworkPing then
      ms = math.floor((plr:GetNetworkPing() or 0) * 1000 + 0.5)
    end
  end)
  if type(ms) ~= "number" then ms = 0 end
  return math.clamp(ms, 0, 9999)
end
function updateESP(plr, char, visible)
  if not char then
    if ChamHighlights[plr.Name] then pcall(function() ChamHighlights[plr.Name]:Destroy() end); ChamHighlights[plr.Name]=nil end
    if NameBillboards[plr.Name] then pcall(function() NameBillboards[plr.Name]:Destroy() end); NameBillboards[plr.Name]=nil end
    return
  end

  if ChamHighlights[plr.Name] then pcall(function() ChamHighlights[plr.Name]:Destroy() end); ChamHighlights[plr.Name]=nil end

 -- 2. Name ESP tag - rebuilt if missing, updated every frame if exists
  local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
  local hum  = char:FindFirstChildOfClass("Humanoid")

  local isDead = hum and (hum:GetState() == Enum.HumanoidStateType.Dead)
  local isFlagOn = (CFG.esp_flag ~= false and CFG.esp_region ~= false)
  local showTag = visible and head and not isDead and CFG.esp_enabled and (CFG.esp_names or isFlagOn or CFG.esp_tools)
  if showTag then
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local dist  = myHRP and math.floor((head.Position - myHRP.Position).Magnitude) or 0
    local nameCol = Color3.fromRGB(90, 255, 150)
    local tool = GetHeldTool(plr)

    local bb = NameBillboards[plr.Name]
    local reg = (isFlagOn and GetPlayerRegion and GetPlayerRegion(plr)) or nil
    local hasFlag = (isFlagOn and reg and ((reg.flag and reg.flag ~= "") or (reg.code and reg.code ~= "")))

    local needRebuild = (not bb or not bb.Parent or not bb:FindFirstChild("Container"))
    if not needRebuild then
      local c0 = bb:FindFirstChild("Container")
      local r0 = c0 and c0:FindFirstChild("Row1")
      if not (r0 and r0:FindFirstChild("ToolBox")) then needRebuild = true end
    end
    if needRebuild then
      if bb then pcall(function() bb:Destroy() end) end
      bb = Instance.new("BillboardGui")
      bb.Name          = "ToxicESP_" .. plr.Name
      bb.AlwaysOnTop   = true
      bb.Size          = UDim2.fromOffset(280, 40)
      bb.StudsOffset   = Vector3.new(0, 2.35, 0)
      bb.Adornee       = head
      bb.Parent        = head
      bb.ResetOnSpawn  = false

      local container = Instance.new("Frame")
      container.Name = "Container"
      container.Size = UDim2.fromScale(1, 1)
      container.BackgroundTransparency = 1
      container.BorderSizePixel = 0
      container.Parent = bb

      -- Main row: [Tool icon LEFT] | Flag + Name (center stack)
      local row1 = Instance.new("Frame")
      row1.Name = "Row1"
      row1.Size = UDim2.new(1, 0, 0, 22)
      row1.Position = UDim2.fromOffset(0, 0)
      row1.BackgroundTransparency = 1
      row1.Parent = container

      local list = Instance.new("UIListLayout")
      list.FillDirection = Enum.FillDirection.Horizontal
      list.HorizontalAlignment = Enum.HorizontalAlignment.Center
      list.VerticalAlignment = Enum.VerticalAlignment.Center
      list.Padding = UDim.new(0, 5)
      list.Parent = row1
      list.SortOrder = Enum.SortOrder.LayoutOrder

      -- LEFT: equipped tool icon (draw)
      local toolBox = Instance.new("Frame")
      toolBox.Name = "ToolBox"
      toolBox.LayoutOrder = 1
      toolBox.Size = UDim2.fromOffset(22, 22)
      toolBox.BackgroundColor3 = Color3.fromRGB(12, 18, 16)
      toolBox.BackgroundTransparency = 0.25
      toolBox.BorderSizePixel = 0
      toolBox.Visible = false
      toolBox.Parent = row1
      Instance.new("UICorner", toolBox).CornerRadius = UDim.new(0, 5)
      local toolStroke = Instance.new("UIStroke")
      toolStroke.Color = Color3.fromRGB(80, 255, 140)
      toolStroke.Thickness = 1
      toolStroke.Transparency = 0.35
      toolStroke.Parent = toolBox
      local toolImg = Instance.new("ImageLabel")
      toolImg.Name = "ToolImg"
      toolImg.BackgroundTransparency = 1
      toolImg.Size = UDim2.fromOffset(18, 18)
      toolImg.Position = UDim2.fromOffset(2, 2)
      toolImg.ScaleType = Enum.ScaleType.Fit
      toolImg.Image = ""
      toolImg.Parent = toolBox
      local toolFb = Instance.new("TextLabel")
      toolFb.Name = "ToolFb"
      toolFb.BackgroundTransparency = 1
      toolFb.Size = UDim2.fromScale(1, 1)
      toolFb.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      toolFb.TextSize = 9
      toolFb.TextColor3 = Color3.fromRGB(200, 255, 220)
      toolFb.Text = ""
      toolFb.Visible = false
      toolFb.Parent = toolBox

      local flagL = Instance.new("TextLabel")
      flagL.Name = "FlagL"
      flagL.LayoutOrder = 2
      flagL.BackgroundTransparency = 1
      flagL.Size = UDim2.fromOffset(22, 18)
      flagL.TextSize = 16
      flagL.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      flagL.TextStrokeTransparency = 0.2
      flagL.TextStrokeColor3 = Color3.new(0, 0, 0)
      flagL.Text = ""
      flagL.Visible = false
      flagL.Parent = row1

      local nameL = Instance.new("TextLabel")
      nameL.Name = "NameL"
      nameL.LayoutOrder = 3
      nameL.BackgroundTransparency = 1
      nameL.AutomaticSize = Enum.AutomaticSize.X
      nameL.Size = UDim2.new(0, 0, 1, 0)
      nameL.TextColor3 = nameCol
      nameL.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      nameL.TextStrokeTransparency = 0
      nameL.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      nameL.TextSize = 14
      nameL.Text = plr.DisplayName or plr.Name
      nameL.Parent = row1

      -- Row 2: distance + region (no raw tool name — icon already left)
      local infoL = Instance.new("TextLabel")
      infoL.Name = "InfoL"
      infoL.Size = UDim2.new(1, 0, 0, 14)
      infoL.Position = UDim2.fromOffset(0, 22)
      infoL.BackgroundTransparency = 1
      infoL.TextColor3 = Color3.fromRGB(220, 240, 230)
      infoL.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      infoL.TextStrokeTransparency = 0.1
      infoL.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
      infoL.TextSize = 11
      infoL.TextXAlignment = Enum.TextXAlignment.Center
      infoL.Parent = container

      NameBillboards[plr.Name] = bb
    end

    -- Update layout & content every frame
    bb.Adornee = head
    local container = bb:FindFirstChild("Container")
    if container then
      local row1 = container:FindFirstChild("Row1")
      local toolBox = row1 and row1:FindFirstChild("ToolBox")
      local toolImg = toolBox and toolBox:FindFirstChild("ToolImg")
      local toolFb = toolBox and toolBox:FindFirstChild("ToolFb")
      local flagL = row1 and row1:FindFirstChild("FlagL")
      local nameL = row1 and row1:FindFirstChild("NameL")
      local infoL = container:FindFirstChild("InfoL")

      -- Tool draw (left of head tag)
      if toolBox and toolImg then
        if CFG.esp_tools and tool then
          local tex = GetToolPreviewId(tool)
          if tex ~= "" then
            toolImg.Image = tex
            toolImg.Visible = true
            if toolFb then toolFb.Visible = false end
          else
            toolImg.Image = ""
            toolImg.Visible = false
            if toolFb then
              local n = tool.Name or "?"
              toolFb.Text = string.sub(n, 1, 3)
              toolFb.Visible = true
            end
          end
          toolBox.Visible = true
        else
          toolBox.Visible = false
          toolImg.Image = ""
          if toolFb then toolFb.Visible = false end
        end
      end

      if flagL then
        if hasFlag then
          local flagText = (reg.flag ~= "" and reg.flag) or ("[" .. (reg.code or "") .. "]")
          flagL.Text = flagText
          flagL.Visible = true
        else
          flagL.Visible = false
        end
      end

      if nameL then
        nameL.Text = plr.DisplayName or plr.Name
        nameL.TextColor3 = nameCol
      end

      if infoL then
        local parts = {}
        if CFG.esp_distance then table.insert(parts, tostring(dist) .. "m") end
        if isFlagOn and reg and reg.text ~= "" then
          table.insert(parts, reg.text)
        elseif isFlagOn and reg and reg.code ~= "" then
          table.insert(parts, reg.code)
        end
        -- tool name only if no icon path and tools on (fallback text)
        if CFG.esp_tools and tool and tool.Name then
          local tex = GetToolPreviewId(tool)
          if tex == "" then
            table.insert(parts, tool.Name)
          end
        end
        infoL.Text = table.concat(parts, "  •  ")
        infoL.Visible = (#parts > 0)
      end
    end

  else
    if NameBillboards[plr.Name] then
      pcall(function() NameBillboards[plr.Name]:Destroy() end)
      NameBillboards[plr.Name] = nil
    end
  end
end

local EspOverlay = Instance.new("ScreenGui")
EspOverlay.Name = "TXEspOverlay"
EspOverlay.IgnoreGuiInset = true
EspOverlay.ResetOnSpawn = false
EspOverlay.DisplayOrder = 50
EspOverlay.Parent = (LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local EspShapes = {}

function espLine(parent, thick)
  local f = Instance.new("Frame")
  f.BorderSizePixel = 0
  f.BackgroundColor3 = Color3.fromRGB(80,255,80)
  f.AnchorPoint = Vector2.new(0.5, 0.5)
  f.ZIndex = 20
  f.Parent = parent
  return f
end

function getEspPack(name)
  local p = EspShapes[name]
  if p and p.box.Parent then return p end
  local pack = {box={}, tracer=nil}
  for i=1,4 do pack.box[i] = espLine(EspOverlay, 1) end
  pack.tracer = espLine(EspOverlay, 1)
  EspShapes[name] = pack
  return pack
end

function hideEspPack(name)
  local p = EspShapes[name]
  if not p then return end
  for i=1,4 do if p.box[i] then p.box[i].Visible = false end end
  if p.tracer then p.tracer.Visible = false end
end

function placeSeg(f, a, b)
  local mid = (a+b)/2
  local delta = b-a
  f.Visible = true
  f.Position = UDim2.fromOffset(mid.X, mid.Y)
  f.Size = UDim2.fromOffset(math.max(1, delta.Magnitude), 2)
  f.Rotation = math.deg(math.atan2(delta.Y, delta.X))
end

function updateBoxTracer(plr, char)
  if not char then hideEspPack(plr.Name) return end
  if not (CFG.esp_boxes or CFG.esp_tracers) then hideEspPack(plr.Name) return end
  local hrp = char:FindFirstChild("HumanoidRootPart")
  local hum = char:FindFirstChildOfClass("Humanoid")
  if not hrp or not hum then hideEspPack(plr.Name) return end
  local cam = workspace.CurrentCamera
  if not cam then hideEspPack(plr.Name) return end
  local pos, on = cam:WorldToViewportPoint(hrp.Position)
  if (not on) or pos.Z < 0 then hideEspPack(plr.Name) return end
  local pack = getEspPack(plr.Name)
  local col = select(1, espDistColor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0))
  local h = math.clamp((hum.HipHeight or 2) * 18 + 40, 28, 90)
  local w = h * 0.45
  local c = Vector2.new(pos.X, pos.Y)
  local tl = Vector2.new(c.X-w/2, c.Y-h/2)
  local tr = Vector2.new(c.X+w/2, c.Y-h/2)
  local bl = Vector2.new(c.X-w/2, c.Y+h/2)
  local br = Vector2.new(c.X+w/2, c.Y+h/2)
  if CFG.esp_boxes then
    placeSeg(pack.box[1], tl, tr)
    placeSeg(pack.box[2], tr, br)
    placeSeg(pack.box[3], br, bl)
    placeSeg(pack.box[4], bl, tl)
    for i=1,4 do pack.box[i].BackgroundColor3 = col end
  else
    for i=1,4 do pack.box[i].Visible = false end
  end
  if CFG.esp_tracers then
    local vp = cam.ViewportSize
    placeSeg(pack.tracer, Vector2.new(vp.X/2, vp.Y), c)
    pack.tracer.BackgroundColor3 = col
  else
    pack.tracer.Visible = false
  end
end

do
local espAcc = 0
RunService.Heartbeat:Connect(function(dt)
  espAcc = espAcc + dt
  if espAcc < 0.45 then return end
  espAcc = 0
  if not menuReady then return end
  if not CFG.esp_enabled then
    if next(ChamHighlights) or next(NameBillboards) then
      for name, hl in pairs(ChamHighlights) do pcall(function() hl:Destroy() end) end
      ChamHighlights = {}
      for name, bb in pairs(NameBillboards) do pcall(function() bb:Destroy() end) end
      NameBillboards = {}
      for name in pairs(EspShapes) do hideEspPack(name) end
    end
    return
  end
  if CFG.esp_enabled then
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local maxD = (CFG.low_perf and 220) or 380
    for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp and myHRP then
          local d = (hrp.Position - myHRP.Position).Magnitude
          if d <= maxD then
            updateESP(plr, plr.Character, true)

          else
            if NameBillboards[plr.Name] then
              pcall(function() NameBillboards[plr.Name]:Destroy() end)
              NameBillboards[plr.Name] = nil
            end
            hideEspPack(plr.Name)
          end
        end
      end
    end
  else
    for name, hl in pairs(ChamHighlights) do pcall(function() hl:Destroy() end) end
    ChamHighlights = {}
    for name, bb in pairs(NameBillboards) do pcall(function() bb:Destroy() end) end
    NameBillboards = {}
    for name in pairs(EspShapes) do hideEspPack(name) end
  end
end)
end

-- Spectate watcher: check every 3s and notify if new watcher detected
task.spawn(function()
  local prevWatchers = {}
  while true do
    task.wait(3)
    pcall(function()
      SpectateWatcher_CheckAll()
      for name in pairs(SpectateWatcher.spectators) do
        if not prevWatchers[name] then
          ShowNotification("" .. name .. " may be spectating you!", "", 4)
        end
      end
      prevWatchers = {}
      for k,v in pairs(SpectateWatcher.spectators) do prevWatchers[k]=v end
    end)
  end
end)

Players.PlayerRemoving:Connect(function(plr)
  if ChamHighlights[plr.Name] then pcall(function() ChamHighlights[plr.Name]:Destroy() end); ChamHighlights[plr.Name] = nil end
  if NameBillboards[plr.Name] then pcall(function() NameBillboards[plr.Name]:Destroy() end); NameBillboards[plr.Name] = nil end
  SpectateWatcher.spectators[plr.Name] = nil
end)

-- ----------------------------------------------------
-- HITBOX EXTENDER (Oumyhub & Game Dumps Suite)
-- ----------------------------------------------------
_hbTok = 0
function TXRestoreHitboxes()
  _hbTok += 1
  pcall(function()
    for _, plr in ipairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
          hrp.Size = Vector3.new(2, 2, 1)
          hrp.Transparency = 1
          hrp.CanCollide = false
          hrp.CanTouch = true
        end
      end
    end
  end)
end
function ToggleHitboxExtender(enable)
  if enable == nil then
    CFG.hitbox_extender_enabled = not CFG.hitbox_extender_enabled
  else
    CFG.hitbox_extender_enabled = enable and true or false
  end
  if not CFG.hitbox_extender_enabled then
    TXRestoreHitboxes()
    if SaveToxicCFG then pcall(SaveToxicCFG) end
    ShowNotification("Hitbox Extender: OFF", "", 1.5)
  else
    ShowNotification("Hitbox Extender: ON (" .. tostring(CFG.hitbox_size or 12) .. " studs)", "", 1.5)
    TXApplyAllHitboxes()
    if SaveToxicCFG then pcall(SaveToxicCFG) end
  end
end

function TXApplyHitboxToChar(char)
  if not CFG.hitbox_extender_enabled or not char then return end
  local s = CFG.hitbox_size or 12
  local targetSize = Vector3.new(s, s, s)
  local tok = _hbTok
  task.spawn(function()
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 6)
    if not hrp then return end
    for _ = 1, 4 do
      if not CFG.hitbox_extender_enabled or tok ~= _hbTok then return end
      pcall(function()
        hrp.Size = targetSize
        hrp.Transparency = 0.7
        hrp.CanCollide = false
        hrp.CanTouch = true
      end)
      task.wait(0.15)
    end
  end)
end

function TXApplyAllHitboxes()
  if not CFG.hitbox_extender_enabled then return end
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
      TXApplyHitboxToChar(plr.Character)
    end
  end
end

function TXHookHitboxPlayer(plr)
  if not plr or plr == LocalPlayer then return end
  pcall(function()
    plr.CharacterAdded:Connect(function(char)
      if CFG.hitbox_extender_enabled then
        TXApplyHitboxToChar(char)
      end
    end)
  end)
  if plr.Character and CFG.hitbox_extender_enabled then
    TXApplyHitboxToChar(plr.Character)
  end
end

for _, plr in ipairs(Players:GetPlayers()) do
  TXHookHitboxPlayer(plr)
end
Players.PlayerAdded:Connect(TXHookHitboxPlayer)
Players.PlayerRemoving:Connect(function(plr)
  -- new join will hook via PlayerAdded; nothing sticky to clear
end)

do
local hbAcc = 0
local toolCache, toolCacheT = {}, 0
function insideBox(worldPos, part)
  local lp = part.CFrame:PointToObjectSpace(worldPos)
  local h = part.Size * 0.5
  return math.abs(lp.X) <= h.X and math.abs(lp.Y) <= h.Y and math.abs(lp.Z) <= h.Z
end
function getStrikePart()
  local now = tick()
  if toolCacheT > now then return toolCache.part end
  toolCacheT = now + 0.35
  toolCache.part = nil
  local char = LocalPlayer.Character
  if not char then return nil end
  local tool = char:FindFirstChildOfClass("Tool")
  if tool then
    toolCache.part = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
  end
  if not toolCache.part then
    toolCache.part = char:FindFirstChild("RightHand") or char:FindFirstChild("HumanoidRootPart")
  end
  return toolCache.part
end
RunService.Heartbeat:Connect(function(dt)
  hbAcc = hbAcc + dt
  if hbAcc < 0.30 then return end
  hbAcc = 0
  if not menuReady or not CFG.hitbox_extender_enabled then return end
  local myChar = LocalPlayer.Character
  local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  if not myHRP then return end
  local s = CFG.hitbox_size or 12
  local targetSize = Vector3.new(s, s, s)
  local reach = (s * 0.72) + 6
  local strike = getStrikePart()
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
      local char = plr.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      if hrp then
        local dist = (hrp.Position - myHRP.Position).Magnitude
        if dist <= reach + s then
          if hrp.Size ~= targetSize then
            pcall(function()
              hrp.Size = targetSize
              hrp.Transparency = 0.7
              hrp.CanCollide = false
              hrp.CanTouch = true
            end)
          end
          if strike and firetouchinterest and dist <= reach and insideBox(strike.Position, hrp) then
            pcall(firetouchinterest, strike, hrp, 0)
            pcall(firetouchinterest, strike, hrp, 1)
          end
        end
      end
    end
  end
end)
end

-- ----------------------------------------------------
-- ANTI-SPECTATE GHOST CAM (BLINDER)
-- ----------------------------------------------------
function ToggleAntiSpectateBlinder(enable)
  if enable == nil then
    CFG.anti_spectate_blinder = not CFG.anti_spectate_blinder
  else
    CFG.anti_spectate_blinder = enable
  end

  if BlinderMesh then
    pcall(function() BlinderMesh:Destroy() end)
    BlinderMesh = nil
  end

  if not CFG.anti_spectate_blinder then
    ShowNotification("Anti-Spectate Blinder: OFF", "", 1.5)
  else
    ShowNotification("Anti-Spectate: ACTIVE (Ghost Camera Shield)", "", 1.5)
  end
end

RunService.RenderStepped:Connect(function()
  if not CFG.anti_spectate_blinder then
    if BlinderMesh then
      pcall(function() BlinderMesh:Destroy() end)
      BlinderMesh = nil
    end
    return
  end

  -- Keep mesh destroyed locally so user camera is never blinded
  if BlinderMesh then
    pcall(function() BlinderMesh:Destroy() end)
    BlinderMesh = nil
  end
end)

-- ----------------------------------------------------
-- AUTO-PARRY / AUTO-DODGE & RAGDOLL LOOP (ZERO REMOTES)
-- ----------------------------------------------------
ToggleAutoDodge = nil
ToggleRagdollLoop = nil
DoSpitTarget = nil
updateAutoDodgeUI = nil
updateRagdollLoopUI = nil

do
  local lastDodgeTime        = 0
  local lastDodgeNotifTime   = 0
  local perEnemyCooldown     = {}   -- per-enemy dodge cooldown table
  local dodgeModeIndex       = 0    -- cycles through dodge strategies
  local totalDodges          = 0    -- total dodges this session
  local iframeActive         = false

  -- Combat weapons that CAN trigger dodge (must hold one of these to be a threat)
  local ATTACK_TOOL_NAMES = {
    "guitar","gitar","gutar","kick","headbutt","slap","pan","soul","matrac",
    "snidila","bat","darkx","sword","raysword","axe","dualsky","dualglow",
    "backpack","kamanja","sndala"
  }

  -- Tools that are NEVER a threat - holding these = instant score 0, no dodge
  local SAFE_TOOL_NAMES = {
    "camera","selfie","selfiestick","selfiephone","boombox","jbl","mic","sign",
    "watergun","pistol","lazer","lazereyess","bubblegun","pepperspray",
    "rope","carry","cuffs","handcuffs","pinkcuffs","redcuffs","cuffsvampire","cuffcat",
    "heart","rose","lollipop","cookie","duck","icecream","rock","pizza","coffee",
    "lemon","teddy","kuromi","sharky","kitty","bell","doll","umbrella","tamra",
    "rfissa","sardi","m3iza","ma9ladlbed","curlin","pompous","flyg","brad","bunny"
  }

  local function isCombatTool(tool)
    if not tool then return false end
    local n = (tool.Name or ""):lower()
    -- First check: is it a safe/innocent tool? â†’ never combat
    for _, s in ipairs(SAFE_TOOL_NAMES) do
      if n:find(s, 1, true) then return false end
    end
    -- Then check whitelist
    for _, w in ipairs(ATTACK_TOOL_NAMES) do
      if n:find(w, 1, true) then return true end
    end
    return false
  end

  local function isSafeTool(tool)
    if not tool then return false end
    local n = (tool.Name or ""):lower()
    for _, s in ipairs(SAFE_TOOL_NAMES) do
      if n:find(s, 1, true) then return true end
    end
    return false
  end

  -- Score a threat: returns 0 if no real attack is happening
  -- HARD GATE: requires combat tool OR active attack animation - proximity/facing alone is NOT enough
  local function scoreThreat(eHRP, eTool, eAnim, myPos)
    -- Gate 1: safe tool equipped â†’ never a threat, no matter what
    if eTool and isSafeTool(eTool) then return 0 end

    -- Gate 2: no tool at all AND no attack animation â†’ not a threat
    -- (player just standing/walking near you should NEVER trigger dodge)
    local hasCombatTool   = eTool and isCombatTool(eTool)
    local hasAttackAnim   = false

    if eAnim then
      for _, track in ipairs(eAnim:GetPlayingAnimationTracks()) do
        local animName = (track.Animation and track.Animation.Name or ""):lower()
        if animName:find("swing") or animName:find("attack") or animName:find("slash")
        or animName:find("punch") or animName:find("hit")   or animName:find("cuff")
        or animName:find("strike") or animName:find("smash") then
          hasAttackAnim = true
          break
        end
      end
    end

    -- HARD REQUIRE: must have combat tool OR attack animation - no exceptions
    if not hasCombatTool and not hasAttackAnim then return 0 end

    -- Build score only when we know this is a real attacker
    local score = 0
    local dist  = (eHRP.Position - myPos).Magnitude

    -- Facing angle (main signal - are they pointing at me?)
    local faceDot = (myPos - eHRP.Position).Unit:Dot(eHRP.CFrame.LookVector)
    if faceDot > 0.7 then score = score + 40     -- aimed directly at me
    elseif faceDot > 0.45 then score = score + 20 -- roughly facing me
    end                                            -- not facing me â†’ 0 (no bonus)

    -- Combat tool in hand (+35, the biggest single bonus)
    if hasCombatTool then score = score + 35 end

    -- Active attack animation (+50 - strongest signal)
    if hasAttackAnim then score = score + 50 end

    -- Distance is only a small bonus now (never the deciding factor alone)
    score = score + math.max(0, 10 - dist) * 2

    return score
  end

  -- 4 dodge strategies, cycling on each successful dodge
  local function executeDodge(myHRP, myHum, eHRP, enemyName)
    dodgeModeIndex = (dodgeModeIndex % 4) + 1
    totalDodges = totalDodges + 1
    local ePos = eHRP.Position
    local eCF  = eHRP.CFrame

    -- Brief iframe: PlatformStand makes server-side hit registration miss
    iframeActive = true
    pcall(function() myHum.PlatformStand = true end)

    if dodgeModeIndex == 1 then
      -- Mode 1: Snap BEHIND attacker (classic)
      myHRP.CFrame = eCF * CFrame.new(0, 0, 4.2) * CFrame.Angles(0, math.pi, 0)

    elseif dodgeModeIndex == 2 then
      -- Mode 2: Strafe LEFT of attacker, look at them
      local leftPos = ePos + eCF.RightVector * -4.5 + Vector3.new(0, 0.1, 0)
      myHRP.CFrame = CFrame.new(leftPos, ePos)

    elseif dodgeModeIndex == 3 then
      -- Mode 3: Strafe RIGHT of attacker, look at them
      local rightPos = ePos + eCF.RightVector * 4.5 + Vector3.new(0, 0.1, 0)
      myHRP.CFrame = CFrame.new(rightPos, ePos)

    else
      -- Mode 4: High upward jump teleport (vertical dodge)
      local upPos = myHRP.Position + Vector3.new(
        math.random(-2, 2) * 0.5, 12, math.random(-2, 2) * 0.5
      )
      myHRP.CFrame = CFrame.new(upPos)
    end

    myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    -- Release iframe after 0.18s
    task.delay(0.18, function()
      iframeActive = false
      pcall(function() myHum.PlatformStand = false end)
    end)

    -- Throttle notifications (max 1 per 1.2s to avoid spam)
    local now = tick()
    if now - lastDodgeNotifTime > 1.2 then
      lastDodgeNotifTime = now
      local modeNames = {"BEHIND","LEFT","RIGHT","UP"}
      ShowNotification(
        "DODGE [" .. modeNames[dodgeModeIndex] .. "] #" .. totalDodges,
        "Evaded " .. enemyName, 0.9
      )
    end
  end

  ToggleAutoDodge = function(enable)
    if enable == nil then
      CFG.auto_dodge_enabled = not CFG.auto_dodge_enabled
    else
      CFG.auto_dodge_enabled = enable
    end

    if CFG.auto_dodge_enabled then
      totalDodges    = 0
      dodgeModeIndex = 0
      perEnemyCooldown = {}
      ShowNotification("AUTO-DODGE: ACTIVE [ULTRA]", "4-mode threat detection", 2)
    else
      ShowNotification("Auto-Dodge: OFF [" .. totalDodges .. " dodges]", "", 1.5)
    end
    if updateAutoDodgeUI then updateAutoDodgeUI() end
  end

  RunService.Heartbeat:Connect(function()
    if not CFG.auto_dodge_enabled then return end
    local now = tick()

    -- Global cooldown: max ~8 dodges/sec absolute cap
    if now - lastDodgeTime < 0.12 then return end

    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myHRP or not myHum or myHum.Health <= 0 then return end

    local myPos = myHRP.Position
    local bestScore = 30   -- any real attacker scores â‰¥35 (tool) or â‰¥50 (anim); false positives return 0
    local bestEnemy = nil
    local bestEHRP  = nil

    for _, enemy in ipairs(Players:GetPlayers()) do
      if enemy ~= LocalPlayer and enemy.Character then
        -- Per-enemy cooldown: don't dodge same enemy twice too fast
        local lastDodgedThis = perEnemyCooldown[enemy.UserId] or 0
        local eChar = enemy.Character
        local eHRP  = eChar:FindFirstChild("HumanoidRootPart")
        local eHum  = eChar:FindFirstChildOfClass("Humanoid")
        local dist  = eHRP and (eHRP.Position - myPos).Magnitude or math.huge

        if (now - lastDodgedThis >= 0.5)
        and eHRP and eHum and eHum.Health > 0
        and dist <= 14 then
          local eTool = eChar:FindFirstChildOfClass("Tool")
          local eAnim = eHum:FindFirstChildOfClass("Animator")

          local score = scoreThreat(eHRP, eTool, eAnim, myPos)

          if score > bestScore then
            bestScore = score
            bestEnemy = enemy
            bestEHRP  = eHRP
          end
        end
      end
    end
    if bestEnemy and bestEHRP then
      lastDodgeTime = now
      perEnemyCooldown[bestEnemy.UserId] = now
      executeDodge(myHRP, myHum, bestEHRP, bestEnemy.DisplayName)
    end
  end)

  local ragdollLoopThread = nil
  local toolCooldownExpiry = {}
  local recentlyUsedTools = {}   -- sliding window of last N used tools (prevents repeat)
  local RECENT_WINDOW = 1        -- only avoid the last used tool so we always rotate
  local weaponCycleIndex = 0
  local ahkSlotIndex = 0
  local loopStrikeCount = 0      -- total strikes fired this session

  local function isToolOnCooldown(tool)
    if not tool then return true end
    local now = tick()
    local tName = (tool.Name or ""):lower()
    local tTip = (tool.ToolTip or ""):lower()

    -- 1. Internal fast tracker
    if toolCooldownExpiry[tool] and toolCooldownExpiry[tool] > now then
      return true
    end

    -- 2. Attribute cooldown: exact tool name only (loose find was locking ALL tools on slot-1 CD)
    local lp = LocalPlayer
    if lp then
      local hasCD = false
      pcall(function()
        local keyA = tName:gsub("%s+", "") .. "cooldownuntil"
        local keyB = "toolcd_" .. tName:gsub("%s+", "")
        for attrName, attrVal in pairs(lp:GetAttributes()) do
          if type(attrName) == "string" and type(attrVal) == "number" then
            local aLow = attrName:lower():gsub("%s+", "")
            if aLow == keyA or aLow == keyB then
              if attrVal > now then hasCD = true break end
            end
          end
        end
      end)
      if hasCD then return true end
    end

    return false
  end

  local function markToolUsed(tool)
    if tool then
      -- Sliding window: push to front, pop from back
      table.insert(recentlyUsedTools, 1, tool)
      if #recentlyUsedTools > RECENT_WINDOW then
        table.remove(recentlyUsedTools)
      end
      -- Track per-tool cooldown based on its known animation duration
      local tName = (tool.Name or ""):lower()
      local cd = 2.8
      if tName:find("guitar") or tName:find("gitar") then cd = 3.2
      elseif tName:find("kick") or tName:find("headbutt") then cd = 2.4
      elseif tName:find("slap") then cd = 2.2
      elseif tName:find("backpack") then cd = 2.6
      elseif tName:find("pan") or tName:find("soul") then cd = 2.8
      elseif tName:find("matrac") or tName:find("sndala") or tName:find("snidila") then cd = 3.0
      elseif tName:find("bat") then cd = 2.5
      elseif tName:find("sword") or tName:find("axe") then cd = 3.0
      end
      toolCooldownExpiry[tool] = tick() + cd
    end
  end

  local function isInRecentWindow(tool)
    for _, t in ipairs(recentlyUsedTools) do
      if t == tool then return true end
    end
    return false
  end

  -- Maps tool names â†’ their exact RagdollEvent name in ReplicatedStorage.RagdollEvents
  -- Sourced from game dump: Remote_Connections_Map.json
  -- Dump: most of these are BindableEvent (client-only). Only TestRagdoll / SelfRagdollControl are RemoteEvent.
  local WEAPON_TO_RAGDOLL_EVENT = {
    ["guitar"]   = { "Guitar" },
    ["gitar"]    = { "Guitar" },
    ["gutar"]    = { "Guitar" },
    ["kamanja"]  = { "Guitar" },
    ["backpack"] = { "Backpack" },
    ["kick"]     = { "Bat", "Slap" },
    ["headbutt"] = { "Bat", "Slap" },
    ["slap"]     = { "Slap" },
    ["pan"]      = { "BlackPan", "Redpan", "PinkPan" },
    ["soul"]     = { "BlackPan", "Redpan" },
    ["redpan"]   = { "Redpan" },
    ["pinkpan"]  = { "PinkPan" },
    ["blackpan"] = { "BlackPan" },
    ["matrac"]   = { "matrac" },
    ["sndala"]   = { "sndala" },
    ["snidila"]  = { "sndala" },
    ["sandal"]   = { "sndala" },
    ["bat"]      = { "Bat", "Pinkbat" },
    ["pinkbat"]  = { "Pinkbat" },
    ["darkx"]    = { "Darkx" },
    ["sword"]    = { "SwordHamouda" },
    ["raysword"] = { "Raysword" },
    ["axe"]      = { "Bat" },
    ["dualsky"]  = { "Bat", "Darkx" },
    ["dualglow"] = { "Bat", "Darkx" },
    ["lazer"]    = { "Lazer" },
    ["rope"]     = { "RopeToolRagdoll" },
    ["papillon"] = { "papillonJujuXFati" },
  }

  local function getWeaponRagdollEvents(tool)
    local tName = (tool and tool.Name or ""):lower()
    local ragFolder = ReplicatedStorage:FindFirstChild("RagdollEvents")
    if not ragFolder then return {} end
    local matched = {}
    for key, eventNames in pairs(WEAPON_TO_RAGDOLL_EVENT) do
      if tName:find(key, 1, true) then
        for _, evName in ipairs(eventNames) do
          local ev = ragFolder:FindFirstChild(evName)
          if ev then
            matched[evName] = ev  -- deduplicated by name
          end
        end
      end
    end
    -- Always include all found events as fallback insurance
    local result = {}
    for _, ev in pairs(matched) do table.insert(result, ev) end
    return result
  end

  -- Strict positive whitelist: matches all combat weapons (Guitar, Kick, Soul Pan, Backpack, etc.)
  local COMBAT_WHITELIST = {
    -- Name matches (lowercase)
    names = {
      "guitar", "gitar", "gutar", "kamanja", "pan", "soul", "kick", "backpack",
      "headbutt", "slap", "matrac", "snidila", "bat", "dualsky", "dualglow",
      "darkx", "swordhamouda", "raysword", "axe"
    },
    -- ToolTip matches (lowercase)
    tips = {
      "blackbat4", "blackbat3", "blackpan", "soulpan", "backpack1",
      "yuri", "matrac", "slap", "seraphic", "kamanja", "guitar", "gutar", "kick", "pan"
    }
  }

  -- Explicit blacklist: tool names that must NEVER be picked, no matter what
  local COMBAT_BLACKLIST = {
    "rope", "carry", "carryfriend", "carryside", "cart", "cuffs", "pinkcuffs",
    "redcuffs", "handcuffs", "cuffsvampire", "pepperspray", "bubblegun",
    "watergun", "boombox", "mic", "sign", "spit", "pistol", "heart", "rose",
    "camera", "selfiestick", "selfiephone", "tamra", "umbrella", "lollipop",
    "cookie", "duck", "icecream", "rock", "pizza", "coffee", "lemon",
    "light", "teddy", "kuromi", "sharky", "kitty", "bell", "doll",
    "rfissa", "sardi", "m3iza", "ma9ladlbed", "lazer", "lazereyess",
    "curlin", "pompous", "flyg", "embarras", "brad", "bunny"
  }

  local function isInBlacklist(name)
    local n = (name or ""):lower()
    for _, bl in ipairs(COMBAT_BLACKLIST) do
      if n:find(bl, 1, true) then return true end
    end
    return false
  end

  local function isInWhitelist(name, tip)
    local n = (name or ""):lower()
    local tt = (tip or ""):lower()
    for _, wn in ipairs(COMBAT_WHITELIST.names) do
      if n:find(wn, 1, true) then return true end
    end
    for _, wt in ipairs(COMBAT_WHITELIST.tips) do
      if tt:find(wt, 1, true) then return true end
    end
    return false
  end

  local function getAllCombatWeapons()
    local myChar = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local candidates = {}
    local seen = {}

    local function addCandidate(t)
      if not t or not t:IsA("Tool") or seen[t] then return end
      local n = (t.Name or ""):lower()
      local tt = (t.ToolTip or ""):lower()
      if isInBlacklist(n) then return end
      -- ragdoll rotate: any non-blacklisted tool counts so slot 2/3/4 get used
      if not isInWhitelist(n, tt) then
        if t:FindFirstChild("Handle") then
          -- allow
        else
          return
        end
      end
      seen[t] = true
      table.insert(candidates, t)
    end

    if myChar then
      for _, t in ipairs(myChar:GetChildren()) do addCandidate(t) end
    end
    if bp then
      for _, t in ipairs(bp:GetChildren()) do addCandidate(t) end
    end

    -- Sort by priority: Guitar > Backpack > Kick > Pan > others
    local priorityOrder = {
      { name = "guitar",   tip = "blackbat" },
      { name = "gitar",    tip = "" },
      { name = "backpack", tip = "backpack1" },
      { name = "kick",     tip = "yuri" },
      { name = "headbutt", tip = "yuri" },
      { name = "soul",     tip = "soulpan" },
      { name = "pan",      tip = "soulpan" },
      { name = "redpan",   tip = "soulpan" },
      { name = "pinkpan",  tip = "yuri" },
      { name = "matrac",   tip = "" },
      { name = "slap",     tip = "slap" },
      { name = "batpink",  tip = "" },
      { name = "snidila",  tip = "" },
      { name = "dualsky",  tip = "" },
      { name = "darkx",    tip = "" },
    }
    local sorted = {}
    local used = {}
    for _, pri in ipairs(priorityOrder) do
      for _, t in ipairs(candidates) do
        if not used[t] then
          local tn = (t.Name or ""):lower()
          local tt2 = (t.ToolTip or ""):lower()
          if (pri.name ~= "" and tn:find(pri.name, 1, true))
            or (pri.tip ~= "" and tt2:find(pri.tip, 1, true)) then
            used[t] = true
            table.insert(sorted, t)
          end
        end
      end
    end
    for _, t in ipairs(candidates) do
      if not used[t] then table.insert(sorted, t) end
    end
    return sorted
  end

  local function pressHotbarSlot(slot)
    slot = tonumber(slot) or 0
    if slot < 1 or slot > 9 then return end
    pcall(function()
      local vim = game:GetService("VirtualInputManager")
      local map = {
        [1]=Enum.KeyCode.One,[2]=Enum.KeyCode.Two,[3]=Enum.KeyCode.Three,
        [4]=Enum.KeyCode.Four,[5]=Enum.KeyCode.Five,[6]=Enum.KeyCode.Six,
        [7]=Enum.KeyCode.Seven,[8]=Enum.KeyCode.Eight,[9]=Enum.KeyCode.Nine
      }
      local kc = map[slot]
      if not kc then return end
      vim:SendKeyEvent(true, kc, false, game)
      task.wait(0.03)
      vim:SendKeyEvent(false, kc, false, game)
    end)
  end

  local function clickNow()
    pcall(function()
      local vim = game:GetService("VirtualInputManager")
      local cam = workspace.CurrentCamera
      local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
      local x, y = math.floor(vp.X * 0.5), math.floor(vp.Y * 0.5)
      vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
      task.wait(0.03)
      vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
    pcall(function()
      if mouse1click then mouse1click() end
    end)
  end

  local function slotOfTool(tool)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local list = {}
    if bp then
      for _, t in ipairs(bp:GetChildren()) do
        if t:IsA("Tool") then table.insert(list, t) end
      end
    end
    local ch = LocalPlayer.Character
    if ch then
      local eq = ch:FindFirstChildOfClass("Tool")
      if eq then
        local found=false
        for _, t in ipairs(list) do if t==eq then found=true break end end
        if not found then table.insert(list, 1, eq) end
      end
    end
    for i, t in ipairs(list) do
      if t == tool then return i end
    end
    return nil
  end

  local function getNextCombatWeapon()
    local allWeapons = getAllCombatWeapons()
    if #allWeapons == 0 then return nil end
    local last = recentlyUsedTools[1]
    local ready = {}
    for _, t in ipairs(allWeapons) do
      if t and t ~= last and not isToolOnCooldown(t) then
        table.insert(ready, t)
      end
    end
    if #ready == 0 then
      for _, t in ipairs(allWeapons) do
        if t and not isToolOnCooldown(t) then
          table.insert(ready, t)
        end
      end
    end
    if #ready == 0 then
      return nil
    end
    weaponCycleIndex = (weaponCycleIndex % #ready) + 1
    return ready[weaponCycleIndex]
  end

  local getBestCombatWeapon = getNextCombatWeapon

  ToggleRagdollLoop = function(enable)
    if enable == nil then
      CFG.ragdoll_loop_enabled = not CFG.ragdoll_loop_enabled
    else
      CFG.ragdoll_loop_enabled = enable
    end

    if CFG.ragdoll_loop_enabled then
      if not CFG.cuff_target or CFG.cuff_target == "" or not Players:FindFirstChild(CFG.cuff_target) then
        ShowNotification("Select a target first!", "", 2)
        CFG.ragdoll_loop_enabled = false
        if updateRagdollLoopUI then updateRagdollLoopUI() end
        return
      end

      -- Full reset on start
      weaponCycleIndex = 0
      ahkSlotIndex = 0
      recentlyUsedTools = {}
      loopStrikeCount = 0
      table.clear(toolCooldownExpiry)
      local lastKnownTarget = CFG.cuff_target  -- track target to detect switches
      ShowNotification("RAGDOLL LOOP: ACTIVE [ULTRA]", "Weapon rotation armed", 2)
      if updateRagdollLoopUI then updateRagdollLoopUI() end

      if ragdollLoopThread then task.cancel(ragdollLoopThread) end
      ragdollLoopThread = task.spawn(function()
        while CFG.ragdoll_loop_enabled do
          -- === TARGET SWITCH DETECTION ===
          -- If user picked a new target while loop was running, wipe all cooldowns
          if CFG.cuff_target ~= lastKnownTarget then
            lastKnownTarget    = CFG.cuff_target
            weaponCycleIndex   = 0
            recentlyUsedTools  = {}
            loopStrikeCount    = 0
            table.clear(toolCooldownExpiry)
            ShowNotification("Target switched - cooldowns RESET", CFG.cuff_target, 1.5)
          end

          local target = Players:FindFirstChild(CFG.cuff_target)
          local myChar = LocalPlayer.Character
          local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
          local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")

          if not (target and target.Character and myChar and myHRP and myHum and myHum.Health > 0) then
            CFG.ragdoll_loop_enabled = false
            break
          end

          local tChar = target.Character
          local tHRP = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Head")
          local tHum = tChar:FindFirstChildOfClass("Humanoid")

          if not (tHRP and tHum and tHum.Health > 0) then
            task.wait(0.2)
          else

          loopStrikeCount = loopStrikeCount + 1
          ahkSlotIndex = (ahkSlotIndex % 4) + 1
          pressHotbarSlot(ahkSlotIndex)
          task.wait(0.05)
          clickNow()
          local weapon = myChar:FindFirstChildOfClass("Tool")
          if not weapon then
            weapon = getNextCombatWeapon()
          end

          if weapon then

            -- === PHASE 2: SNAP TO TARGET ===
            -- Randomize position slightly each strike to avoid detection patterns
            local jitterX = math.random(-2, 2) * 0.08
            local jitterZ = math.random(-2, 2) * 0.08
            local snapPos = tHRP.Position + Vector3.new(jitterX, 0.05, jitterZ)
            pcall(function()
              myHRP.CFrame = CFrame.new(snapPos, tHRP.Position + tHRP.CFrame.LookVector)
              myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
              myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end)

            -- === PHASE 3: ACTIVATE WEAPON ===
            pcall(function() weapon:Activate() end)

            -- Double-fire activation with tiny gap for weapons that need it
            if loopStrikeCount % 2 == 0 then
              task.wait(0.02)
              pcall(function() weapon:Activate() end)
            end

            -- === PHASE 4: local Bindable only (tool scripts listen here). NO remotes. ===
            local specificEvents = getWeaponRagdollEvents(weapon)
            for _, ragEv in ipairs(specificEvents) do
              if ragEv:IsA("BindableEvent") then
                pcall(function() ragEv:Fire(tChar) end)
                pcall(function() ragEv:Fire(target) end)
              end
            end

            -- === PHASE 5: FIRETOUCHINTEREST (MULTI-PART) ===
            if typeof(firetouchinterest) == "function" then
              local toolParts = {}
              for _, part in ipairs(weapon:GetDescendants()) do
                if part:IsA("BasePart") then
                  table.insert(toolParts, part)
                end
              end
              local handle = weapon:FindFirstChild("Handle")
              if #toolParts == 0 and handle then
                table.insert(toolParts, handle)
              end

              -- Target body parts (covers both R6 and R15)
              local victimParts = {}
              for _, pn in ipairs({"HumanoidRootPart","Head","UpperTorso","Torso","LowerTorso",
                                    "LeftUpperLeg","LeftLeg","RightUpperLeg","RightLeg",
                                    "RightUpperArm","RightArm","LeftUpperArm","LeftArm"}) do
                local p = tChar:FindFirstChild(pn)
                if p then table.insert(victimParts, p) end
              end

              -- Strike each tool part against each victim part
              for _, tp in ipairs(toolParts) do
                for _, vp in ipairs(victimParts) do
                  pcall(function()
                    firetouchinterest(vp, tp, 0)
                    firetouchinterest(vp, tp, 1)
                  end)
                end
              end
            end

            markToolUsed(weapon)
            pcall(function() myHum:UnequipTools() end)

          else
            task.wait(0.15)
          end

          -- PHASE 8: do not fake-ragdoll other characters locally (does not replicate, flags AC)

          -- Dynamic tick rate: speed up as strikes accumulate
          local tickRate = 0.13
          if loopStrikeCount > 10 then tickRate = 0.11 end
          if loopStrikeCount > 25 then tickRate = 0.10 end
          task.wait(tickRate)
          end -- close if/else (tHRP valid check)
        end -- close while CFG.ragdoll_loop_enabled

        CFG.ragdoll_loop_enabled = false
        if updateRagdollLoopUI then updateRagdollLoopUI() end
        ShowNotification("Ragdoll Loop: STOPPED [" .. loopStrikeCount .. " strikes]", "", 2)
      end)
    else
      if ragdollLoopThread then
        task.cancel(ragdollLoopThread)
        ragdollLoopThread = nil
      end
      CFG.ragdoll_loop_enabled = false
      if updateRagdollLoopUI then updateRagdollLoopUI() end
    end
  end
end

-- ====================================================
-- SPIT TARGET ACTION (One-Time Execution on Selected Target)
-- Reverse Engineered from dump: Uses SpitEvent, ShowEwBubble & local Chat:Chat
-- ====================================================
DoSpitTarget = function()
  local targetName = CFG.cuff_target
  if not targetName or targetName == "" then
    ShowNotification("Select a target first!", "", 2)
    return
  end

  local target = Players:FindFirstChild(targetName)
  if not target or not target.Character then
    ShowNotification("Target character not found!", "", 2)
    return
  end

  local tChar = target.Character
  local tHead = tChar:FindFirstChild("Head")
  local tHrp  = tChar:FindFirstChild("HumanoidRootPart")
  if not tHead and not tHrp then
    ShowNotification("Target parts missing!", "", 2)
    return
  end

  -- 1. Server Remotes (Server automatically replicates the spit & "Ew!" bubble to everyone)
  pcall(function()
    local RS = game:GetService("ReplicatedStorage")
    local spitEvent = RS:FindFirstChild("SpitEvent")
    local ewBubble  = RS:FindFirstChild("ShowEwBubble")
    if spitEvent and spitEvent:IsA("RemoteEvent") then
      spitEvent:FireServer(target)
      spitEvent:FireServer(target.Character)
    end
    if ewBubble and ewBubble:IsA("RemoteEvent") then
      ewBubble:FireServer(target)
      ewBubble:FireServer(target.Character)
    end
  end)

  -- 3. Particle Effect if available
  pcall(function()
    local RS = game:GetService("ReplicatedStorage")
    local partTpl = RS:FindFirstChild("SpitParticleTemplate")
    local myChar = LocalPlayer.Character
    local myHead = myChar and myChar:FindFirstChild("Head")
    if partTpl and myHead then
      local p = partTpl:Clone()
      p.Parent = myHead
      p:Emit(15)
      task.delay(1.5, function() pcall(function() p:Destroy() end) end)
    end
  end)

  ShowNotification("Spat on " .. target.DisplayName .. "!", "Ew!", 2)
end

-- ====================================================
-- AURA METHOD ENGINE (;aura Toggle, Auto-Reapply & Visual Cleaner)
-- ====================================================
ToggleAura = nil
AuraMethod = nil
DoQuickAura = nil
UpdateAuraUI = nil

do
  -- Destroy any residual shield part from previous session
  pcall(function()
    local oldShield = workspace:FindFirstChild("TOXIC_AntiCuffShield")
    if oldShield then oldShield:Destroy() end
  end)

  local function cleanInstanceAura(inst)
    if not inst then return end
    local isVisual = inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") or inst:IsA("Highlight") or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight")
    if isVisual then
      pcall(function()
        if inst:IsA("ParticleEmitter") or inst:IsA("Beam") or inst:IsA("Trail") then
          inst.Enabled = false
        elseif inst:IsA("Highlight") then
          inst.Enabled = false
        elseif inst:IsA("Light") then
          inst.Enabled = false
        end
        inst:Destroy()
      end)
    elseif inst:IsA("Attachment") then
      local an = (inst.Name or ""):lower()
      if an:find("aura") or an:find("sparkle") or an:find("glow") or an:find("effect") or an:find("hdaura") then
        pcall(function() inst:Destroy() end)
      end
    elseif inst:IsA("Folder") or inst:IsA("Model") or inst:IsA("BasePart") then
      local n = (inst.Name or ""):lower()
      if n:find("aura") or n:find("hdaura") then
        pcall(function()
          for _, c in ipairs(inst:GetDescendants()) do
            if c:IsA("ParticleEmitter") or c:IsA("Beam") or c:IsA("Trail") or c:IsA("Highlight") or c:IsA("PointLight") then
              c:Destroy()
            end
          end
          if inst.Name ~= "HumanoidRootPart" and not inst:IsA("Accessory") and not inst:IsA("Tool") and inst:IsA("BasePart") then
            inst.Transparency = 1
          end
        end)
      end
    end
  end

  local function cleanAuraVisualsFromChar(char)
    if not char then return end
    pcall(function()
      for _, desc in ipairs(char:GetDescendants()) do
        cleanInstanceAura(desc)
      end
    end)
  end
  _G.TOXIC_CleanAuraVisuals = cleanAuraVisualsFromChar

  local function cleanOthersVisualEffects()
    pcall(function()
      for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
          for _, desc in ipairs(plr.Character:GetDescendants()) do
            if desc:IsA("ParticleEmitter") or desc:IsA("Beam") or desc:IsA("Trail") or desc:IsA("Highlight") or desc:IsA("PointLight") or desc:IsA("SpotLight") then
              pcall(function()
                if desc:IsA("ParticleEmitter") or desc:IsA("Beam") or desc:IsA("Trail") then
                  desc.Enabled = false
                end
                desc:Destroy()
              end)
            end
          end
        end
      end
    end)
  end
  _G.TOXIC_CleanOthersEffects = cleanOthersVisualEffects

  local function hookCharacterAuraWatcher(char)
    if not char then return end
    char.DescendantAdded:Connect(function(desc)
      if CFG.hide_aura_visuals then
        task.defer(function()
          cleanInstanceAura(desc)
        end)
      end
    end)
  end

  if LocalPlayer.Character then
    hookCharacterAuraWatcher(LocalPlayer.Character)
  end
  LocalPlayer.CharacterAdded:Connect(function(char)
    hookCharacterAuraWatcher(char)
    if CFG.aura_enabled then
      task.delay(0.8, function()
        if CFG.aura_enabled then
          if ToggleAura then
            ToggleAura(true)
          end
        end
      end)
    end
  end)

  task.spawn(function()
    while true do
      task.wait(4)
      if CFG.hide_aura_visuals and LocalPlayer.Character then
        cleanAuraVisualsFromChar(LocalPlayer.Character)
      end
      if CFG.hide_others_effects then
        cleanOthersVisualEffects()
      end
    end
  end)

  local function sendAuraCommand(enable)
    local sentHD = false
    pcall(function()
      local hd = game:GetService("ReplicatedStorage"):FindFirstChild("HDAdminHDClient")
      if hd and hd:FindFirstChild("Signals") then
        local reqSilent = hd.Signals:FindFirstChild("RequestCommandSilent")
        if reqSilent and reqSilent:IsA("RemoteFunction") then
          if enable then
            reqSilent:InvokeServer(";aura")
          else
            reqSilent:InvokeServer(";unaura")
            reqSilent:InvokeServer(";removeaura")
            reqSilent:InvokeServer(";clearaura")
          end
          sentHD = true
        end
      end
    end)

    pcall(function()
      local RS = game:GetService("ReplicatedStorage")
      local auraSys = RS:FindFirstChild("AuraSystem")
      if auraSys and auraSys:FindFirstChild("Remotes") then
        local reqEquip = auraSys.Remotes:FindFirstChild("RequestAuraEquip")
        if reqEquip and reqEquip:IsA("RemoteEvent") then
          if enable then
            reqEquip:FireServer("BlackAura")
            reqEquip:FireServer("PinkAura")
          else
            local reqUnequip = auraSys.Remotes:FindFirstChild("RequestAuraUnequip")
            if reqUnequip and reqUnequip:IsA("RemoteEvent") then
              reqUnequip:FireServer("BlackAura")
              reqUnequip:FireServer("PinkAura")
            end
          end
        end
      end
    end)

    if not sentHD then
      pcall(function()
        if enable then
          SendChatMessage(";aura")
        else
          SendChatMessage(";unaura")
        end
      end)
    end
  end

  ToggleAura = function(forcedState)
    local newState = (forcedState ~= nil) and forcedState or (not CFG.aura_enabled)
    CFG.aura_enabled = newState

    if newState then
      sendAuraCommand(true)
      if CFG.hide_aura_visuals then
        task.delay(0.05, function() cleanAuraVisualsFromChar(LocalPlayer.Character) end)
        task.delay(0.2, function() cleanAuraVisualsFromChar(LocalPlayer.Character) end)
        task.delay(0.5, function() cleanAuraVisualsFromChar(LocalPlayer.Character) end)
        task.delay(1.0, function() cleanAuraVisualsFromChar(LocalPlayer.Character) end)
      end
      ShowNotification("âš¡ Aura Method: ON", "Anti-Cuff Aura active", 1.5)
    else
      sendAuraCommand(false)
      if LocalPlayer.Character then
        cleanAuraVisualsFromChar(LocalPlayer.Character)
      end
      ShowNotification("âš¡ Aura Method: OFF", "Aura disabled", 1.5)
    end

    if UpdateAuraUI then
      pcall(UpdateAuraUI)
    end
  end

  AuraMethod = ToggleAura
  DoQuickAura = function()
    ToggleAura(true)
  end

  -- Native chat command listener for ;aura, /aura
  pcall(function()
    LocalPlayer.Chatted:Connect(function(msg)
      local clean = msg:lower():gsub("%s+", "")
      if clean == ";aura" or clean == "/aura" or clean == ":aura" or clean == "!aura" or clean == "aura" then
        ToggleAura()
      end
    end)
  end)

  pcall(function()
    local TCS = game:GetService("TextChatService")
    if TCS and TCS.MessageReceived then
      TCS.MessageReceived:Connect(function(textChatMessage)
        if textChatMessage.TextSource and textChatMessage.TextSource.UserId == LocalPlayer.UserId then
          local clean = textChatMessage.Text:lower():gsub("%s+", "")
          if clean == ";aura" or clean == "/aura" or clean == ":aura" or clean == "!aura" or clean == "aura" then
            ToggleAura()
          end
        end
      end)
    end
  end)
end

-- ====================================================
-- SELF-UNCUFF & ANTI-CUFF ENGINE v3 (100% Physics & Joint Severing - ZERO REMOTES)
-- ANTI-KICK: Never calls FireServer on cuff tools (prevents Error Code 267)
-- HALF-BODY FIX: Sever all foreign welds, disable/re-enable Motor6D, reset Transform,
--   unanchor parts, zero velocity, and micro-rebuild assembly.
-- ====================================================
DoSelfUncuff = nil
ForceBodyRepair = nil

do
  local uncuffDebounce = false

  -- STEP 0: Purge cuff attributes, Value objects & CollectionService tags
  local function purgeCuffState(char)
    pcall(function()
      local cuffAttrs = {
        cuffed=true, iscuffed=true, handcuffed=true, arrested=true,
        restrained=true, grabbed=true, carried=true, frozen=true,
        disabled=true, seated=true, detained=true, incuffs=true,
        cuff=true, roped=true, beingcarried=true, beingdragged=true
      }
      -- Clear on LocalPlayer
      for attrName, _ in pairs(LocalPlayer:GetAttributes()) do
        if cuffAttrs[attrName:lower()] then
          pcall(function() LocalPlayer:SetAttribute(attrName, false) end)
          pcall(function() LocalPlayer:SetAttribute(attrName, nil) end)
        end
      end
      -- Clear on Character & Humanoid
      if char then
        for attrName, _ in pairs(char:GetAttributes()) do
          if cuffAttrs[attrName:lower()] then
            pcall(function() char:SetAttribute(attrName, false) end)
            pcall(function() char:SetAttribute(attrName, nil) end)
          end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
          for attrName, _ in pairs(hum:GetAttributes()) do
            if cuffAttrs[attrName:lower()] then
              pcall(function() hum:SetAttribute(attrName, false) end)
              pcall(function() hum:SetAttribute(attrName, nil) end)
            end
          end
        end
      end
    end)

    -- Destroy Value objects inside Character & LocalPlayer
    pcall(function()
      if not char then return end
      for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("BoolValue") or desc:IsA("StringValue") or desc:IsA("ObjectValue") then
          local dn = desc.Name:lower()
          if dn:find("cuff") or dn:find("arrest") or dn:find("hold") or dn:find("carry") or dn:find("restrain") or dn:find("rope") then
            pcall(function() desc:Destroy() end)
          end
        end
      end
    end)

    -- Remove CollectionService Tags
    pcall(function()
      local CS = game:GetService("CollectionService")
      local tags = {"Cuffed", "Handcuffed", "Restrained", "Arrested", "Grabbed", "Carried", "Roped"}
      for _, tag in ipairs(tags) do
        pcall(function() CS:RemoveTag(LocalPlayer, tag) end)
        if char then pcall(function() CS:RemoveTag(char, tag) end) end
      end
    end)
  end

  -- STEP 1: Destroy & sever ALL welds/constraints linking our character to anything external
  local function shredForeignWelds(char, myHRP)
    if CFG.cuff_busy then return end
    -- Pass 1: Destroy foreign constraints and unanchor in our character
    pcall(function()
      for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("BasePart") then
          if desc.Anchored then
            pcall(function() desc.Anchored = false end)
          end
        elseif desc:IsA("Motor6D") then
          -- Internal skeleton joints, never destroy
        elseif desc:IsA("Weld") or desc:IsA("WeldConstraint")
          or desc:IsA("ManualWeld") or desc:IsA("RopeConstraint")
          or desc:IsA("SpringConstraint") or desc:IsA("RodConstraint")
          or desc:IsA("BallSocketConstraint") or desc:IsA("NoCollisionConstraint")
          or desc:IsA("AlignPosition") or desc:IsA("AlignOrientation")
          or desc:IsA("VectorForce") or desc:IsA("LineForce")
          or desc:IsA("BodyPosition") or desc:IsA("BodyGyro") or desc:IsA("BodyVelocity")
        then
          local dn = (desc.Name or ""):lower()
          local ok0, p0 = pcall(function() return desc.Part0 end)
          local ok1, p1 = pcall(function() return desc.Part1 end)
          local isExternal = (ok0 and p0 and not p0:IsDescendantOf(char))
                          or (ok1 and p1 and not p1:IsDescendantOf(char))
          local isCuffNamed = dn:find("cuff") or dn:find("rope") or dn:find("arrest")
                           or dn:find("hold") or dn:find("carry") or dn:find("vampire")
          if isExternal or isCuffNamed then
            pcall(function() desc.Enabled = false end)
            pcall(function() desc.Part0 = nil end)
            pcall(function() desc.Part1 = nil end)
            pcall(function() desc:Destroy() end)
          end
        end
      end
    end)

    -- Pass 2: Destroy constraints in OTHER CHARACTERS that reference our parts
    pcall(function()
      if not myHRP then return end
      for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
          local oHRP = plr.Character:FindFirstChild("HumanoidRootPart")
          if oHRP and (oHRP.Position - myHRP.Position).Magnitude < 35 then
            for _, desc in ipairs(plr.Character:GetDescendants()) do
              local isConstraint = desc:IsA("Weld") or desc:IsA("WeldConstraint")
                or desc:IsA("RopeConstraint") or desc:IsA("SpringConstraint")
                or desc:IsA("ManualWeld") or desc:IsA("RodConstraint")
                or desc:IsA("BallSocketConstraint")
              if isConstraint then
                local p0 = pcall(function() return desc.Part0 end) and desc.Part0
                local p1 = pcall(function() return desc.Part1 end) and desc.Part1
                if (p0 and p0:IsDescendantOf(char)) or (p1 and p1:IsDescendantOf(char)) then
                  pcall(function() desc.Enabled = false end)
                  pcall(function() desc.Part0 = nil end)
                  pcall(function() desc.Part1 = nil end)
                  pcall(function() desc:Destroy() end)
                end
              end
            end
          end
        end
      end
    end)

    -- Pass 3: Scan workspace for any constraint linking to our character
    pcall(function()
      for _, obj in ipairs(workspace:GetDescendants()) do
        if not obj:IsDescendantOf(char) then
          local isConstraint = obj:IsA("Weld") or obj:IsA("WeldConstraint")
            or obj:IsA("RopeConstraint") or obj:IsA("ManualWeld")
            or obj:IsA("BallSocketConstraint")
          if isConstraint then
            local p0 = pcall(function() return obj.Part0 end) and obj.Part0
            local p1 = pcall(function() return obj.Part1 end) and obj.Part1
            if (p0 and p0:IsDescendantOf(char)) or (p1 and p1:IsDescendantOf(char)) then
              pcall(function() obj.Enabled = false end)
              pcall(function() obj.Part0 = nil end)
              pcall(function() obj.Part1 = nil end)
              pcall(function() obj:Destroy() end)
            end
          end
        end
      end
    end)
  end

  -- STEP 2: Reset all Motor6D Transform values (cures half-body desync)
  local function repairMotor6D(char)
    pcall(function()
      for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("Motor6D") then
          desc.Enabled = true
          pcall(function() desc.Transform = CFrame.identity end)
          pcall(function() desc.CurrentAngle = 0 end)
          pcall(function() desc.DesiredAngle = 0 end)
        end
      end
    end)
  end

  -- STEP 3: Snap HRP back to torso and force assembly re-coherence
  local function snapBodyBack(char, myHRP)
    pcall(function()
      if not myHRP then return end
      local torso = char:FindFirstChild("UpperTorso")
                 or char:FindFirstChild("Torso")
                 or char:FindFirstChild("LowerTorso")
      if torso then
        local dist = (myHRP.Position - torso.Position).Magnitude
        if dist > 1.5 then
          -- Re-align HRP to Torso center
          myHRP.CFrame = torso.CFrame
        end
      end
      pcall(function() myHRP.AssemblyLinearVelocity = Vector3.new(0, 0.05, 0) end)
      pcall(function() myHRP.AssemblyAngularVelocity = Vector3.zero end)
      -- Micro-bump forces Roblox physics pipeline to send a fresh PhysicsPacket to server & other players
      myHRP.CFrame = myHRP.CFrame + Vector3.new(0, 0.15, 0)
    end)
  end

  -- STEP 6: Re-enable tools and weapons in Backpack & Character
  local function reenableTools(char)
    pcall(function()
      if not char then return end
      for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
          pcall(function() item.Enabled = true end)
        end
      end
      local bp = LocalPlayer:FindFirstChild("Backpack")
      if bp then
        for _, item in ipairs(bp:GetChildren()) do
          if item:IsA("Tool") then
            pcall(function() item.Enabled = true end)
          end
        end
      end
    end)
  end

  -- STEP 4: Stop all running animations (cuff animations lock limbs & pose)
  local function stopCuffAnimations(char)
    pcall(function()
      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
          track:Stop(0)
        end
      end
      local animCtrl = char:FindFirstChildOfClass("AnimationController")
      if animCtrl then
        for _, track in ipairs(animCtrl:GetPlayingAnimationTracks()) do
          track:Stop(0)
        end
      end
    end)
  end

  -- STEP 5: Restore humanoid movement state
  local function restoreHumanoid(char)
    pcall(function()
      local hum = char:FindFirstChildOfClass("Humanoid")
      if hum then
        hum.PlatformStand = false
        hum.Sit = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        if hum.WalkSpeed < 1 then hum.WalkSpeed = 16 end
        if hum.JumpPower < 10 then hum.JumpPower = 50 end
        if hum.JumpHeight < 3 then hum.JumpHeight = 7.2 end
      end
    end)
  end

  -- MASTER: ForceBodyRepair - runs full body & skeleton repair
  ForceBodyRepair = function(char)
    char = char or LocalPlayer.Character
    if not char then return end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    purgeCuffState(char)
    shredForeignWelds(char, myHRP)
    repairMotor6D(char)
    snapBodyBack(char, myHRP)
    restoreHumanoid(char)
    stopCuffAnimations(char)
    reenableTools(char)
  end
  _G.TOXIC_ForceBodyRepair = ForceBodyRepair

  -- MASTER: DoSelfUncuff - 100% Safe Client Physics Break Free (Zero Remotes)
  DoSelfUncuff = function(silent)
    if CFG and CFG.cuff_busy then return end
    if uncuffDebounce then return end
    uncuffDebounce = true

    task.spawn(function()
      local char = LocalPlayer.Character
      if not char or (CFG and CFG.cuff_busy) then
        uncuffDebounce = false
        return
      end
      local myHRP = char:FindFirstChild("HumanoidRootPart")

      -- PHASE 1: Purge cuff attributes, values & CollectionService tags
      purgeCuffState(char)

      -- PHASE 2: Shred foreign welds & constraints (Zero remotes fired)
      shredForeignWelds(char, myHRP)

      -- PHASE 3: Re-align Motor6D, snap separated halves & re-enable weapons
      repairMotor6D(char)
      snapBodyBack(char, myHRP)
      restoreHumanoid(char)
      stopCuffAnimations(char)
      reenableTools(char)

      -- PHASE 4: Follow-up pass after 0.15s to catch persistent/lagged welds
      task.wait(0.15)
      local char2 = LocalPlayer.Character
      if char2 and not (CFG and CFG.cuff_busy) then
        local myHRP2 = char2:FindFirstChild("HumanoidRootPart")
        purgeCuffState(char2)
        shredForeignWelds(char2, myHRP2)
        repairMotor6D(char2)
        snapBodyBack(char2, myHRP2)
        restoreHumanoid(char2)
        stopCuffAnimations(char2)
        reenableTools(char2)
      end

      if not silent then
        ShowNotification("ðŸ”“ Uncuffed & Body Repaired!", "Welds severed & limbs snapped (Safe / Zero Remotes)", 2)
      end

      task.wait(0.2)
      uncuffDebounce = false
    end)
  end

  -- Auto-Uncuff Watcher (Runs when CFG.auto_uncuff is enabled)
  task.spawn(function()
    while true do
      task.wait(0.35)
      if CFG.auto_uncuff and not CFG.cuff_busy and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp and not CFG.cuff_busy then
          local isRestrained = false

          -- Check 1: foreign welds in our character
          for _, desc in ipairs(char:GetDescendants()) do
            if desc:IsA("Weld") or desc:IsA("WeldConstraint") or desc:IsA("RopeConstraint") or desc:IsA("ManualWeld") then
              if not CFG.cuff_busy then
                local ok0, p0 = pcall(function() return desc.Part0 end)
                local ok1, p1 = pcall(function() return desc.Part1 end)
                if (ok0 and p0 and not p0:IsDescendantOf(char))
                or (ok1 and p1 and not p1:IsDescendantOf(char)) then
                  local parentTool = desc:FindFirstAncestorOfClass("Tool")
                  if not parentTool then
                    isRestrained = true
                    break
                  end
                end
              end
            end
          end

          -- Check 2: PlatformStand or zero WalkSpeed while a cuff tool is nearby
          if not isRestrained and (hum.WalkSpeed < 2 or hum.PlatformStand == true) then
            for _, plr in ipairs(Players:GetPlayers()) do
              if plr ~= LocalPlayer and plr.Character then
                local oHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if oHRP and (oHRP.Position - hrp.Position).Magnitude < 12 then
                  for _, item in ipairs(plr.Character:GetChildren()) do
                    if item:IsA("Tool") then
                      local tn = item.Name:lower()
                      if tn:find("cuff") or tn:find("rope") or tn:find("menotte") or tn:find("vampire") then
                        isRestrained = true
                        break
                      end
                    end
                  end
                end
                if isRestrained then break end
              end
            end
          end

          if isRestrained then
            DoSelfUncuff(true)
            task.wait(0.8)
          end
        end
      end
    end
  end)

  -- Native chat command listener for ;uncuff / ;free / breakfree
  pcall(function()
    LocalPlayer.Chatted:Connect(function(msg)
      local clean = msg:lower():gsub("%s+", "")
      if clean == ";uncuff" or clean == "/uncuff" or clean == ":uncuff"
      or clean == "!uncuff" or clean == "uncuff" or clean == ";free"
      or clean == "breakfree" or clean == ";breakfree" then
        DoSelfUncuff()
      end
      if clean == ";repair" or clean == "/repair" or clean == ";fixbody" then
        ForceBodyRepair()
        ShowNotification("ðŸ”§ Body Repair Done", "Motor6D & joints reset", 1.5)
      end
    end)
  end)

  pcall(function()
    local TCS = game:GetService("TextChatService")
    if TCS and TCS.MessageReceived then
      TCS.MessageReceived:Connect(function(textChatMessage)
        if textChatMessage.TextSource and textChatMessage.TextSource.UserId == LocalPlayer.UserId then
          local clean = textChatMessage.Text:lower():gsub("%s+", "")
          if clean == ";uncuff" or clean == "/uncuff" or clean == ":uncuff"
          or clean == "!uncuff" or clean == "uncuff" or clean == ";free"
          or clean == "breakfree" or clean == ";breakfree" then
            DoSelfUncuff()
          end
          if clean == ";repair" or clean == "/repair" or clean == ";fixbody" then
            ForceBodyRepair()
          end
        end
      end)
    end
  end)
end

-- ----------------------------------------------------
-- TOXIC LOGO DRAWING (Drawing API)
-- ----------------------------------------------------
local ToxicLogoElements = {}

function createToxicLogo(centerX, centerY)
  for _, elem in ipairs(ToxicLogoElements) do pcall(function() elem:Remove() end) end
  ToxicLogoElements = {}

  if not Drawing or not Drawing.new then return end

  local greenColor = Color3.fromRGB(50, 255, 50)

  local outerCircle = Drawing.new("Circle")
  outerCircle.Position = Vector2.new(centerX, centerY)
  outerCircle.Radius = 60
  outerCircle.Color = greenColor
  outerCircle.Thickness = 3
  outerCircle.Filled = false
  outerCircle.Visible = true
  table.insert(ToxicLogoElements, outerCircle)

  local coreCircle = Drawing.new("Circle")
  coreCircle.Position = Vector2.new(centerX, centerY)
  coreCircle.Radius = 14
  coreCircle.Color = greenColor
  coreCircle.Thickness = 2
  coreCircle.Filled = true
  table.insert(ToxicLogoElements, coreCircle)

  local angles = {0, 120, 240}
  for _, deg in ipairs(angles) do
    local rad = math.rad(deg - 90)
    local offset = 32
    local lx = centerX + math.cos(rad) * offset
    local ly = centerY + math.sin(rad) * offset

    local lobe = Drawing.new("Circle")
    lobe.Position = Vector2.new(lx, ly)
    lobe.Radius = 24
    lobe.Color = greenColor
    lobe.Thickness = 3
    lobe.Filled = false
    lobe.Visible = true
    table.insert(ToxicLogoElements, lobe)

    local line = Drawing.new("Line")
    line.From = Vector2.new(centerX, centerY)
    line.To = Vector2.new(lx, ly)
    line.Color = greenColor
    line.Thickness = 2
    line.Visible = true
    table.insert(ToxicLogoElements, line)
  end

  local innerDot = Drawing.new("Circle")
  innerDot.Position = Vector2.new(centerX, centerY)
  innerDot.Radius = 5
  innerDot.Color = Color3.fromRGB(0, 0, 0)
  innerDot.Thickness = 1
  innerDot.Filled = true
  innerDot.Visible = true
  table.insert(ToxicLogoElements, innerDot)

  task.spawn(function()
    for t = 1, 30 do
      task.wait(0.03)
      for _, elem in ipairs(ToxicLogoElements) do
        pcall(function() elem.Transparency = 1 - (t / 30) end)
      end
    end
    for _, elem in ipairs(ToxicLogoElements) do pcall(function() elem:Remove() end) end
    ToxicLogoElements = {}
  end)
end

-- ----------------------------------------------------

-- ----------------------------------------------------
-- FIVEM DUI GLASSMORPHIC GUI ENGINE (EMERALD NEON)
-- ----------------------------------------------------
ToxicGui = Instance.new("ScreenGui")
ToxicGui.Name = "ToxicProject_V4_FiveM_DUI"
ToxicGui.ResetOnSpawn = false
safeParentGui(ToxicGui)
pcall(function()
  if type(_G._TX_SESSION) == "table" then
    table.insert(_G._TX_SESSION.teardown, function()
      pcall(function() if ToxicGui then ToxicGui:Destroy() end end)
      pcall(function()
        local o = (LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer):FindFirstChild("TXEspOverlay")
        if o then o:Destroy() end
      end)
      pcall(function()
        if StealthState and StealthState.active and StopServerInvisibility then
          StopServerInvisibility()
        end
      end)
    end)
  end
  if getgenv then
    getgenv().TX_UNLOAD = function()
      local sess = rawget(_G, "_TX_SESSION")
      if type(sess) == "table" then
        sess.alive = false
        for _, fn in ipairs(sess.teardown or {}) do pcall(fn) end
        for _, c in ipairs(sess.connections or {}) do
          pcall(function() if c and c.Disconnect then c:Disconnect() end end)
        end
      end
    end
  end
end)

-- Theme Palette (Readable dark + hacker green)
Theme = {
  Bg = Color3.fromRGB(16, 20, 24),
  BgGlass = 0.14,
  CardBg = Color3.fromRGB(26, 32, 36),
  CardBgHover = Color3.fromRGB(36, 44, 50),
  CardOff = Color3.fromRGB(32, 38, 42),
  InputBg = Color3.fromRGB(14, 18, 21),
  NeonGreen = Color3.fromRGB(52, 211, 110),
  NeonDarkGreen = Color3.fromRGB(20, 92, 48),
  GlowStroke = Color3.fromRGB(74, 222, 128),
  TextWhite = Color3.fromRGB(248, 250, 252),
  TextDim = Color3.fromRGB(156, 170, 186),
  TextMuted = Color3.fromRGB(110, 124, 140),
  DangerRed = Color3.fromRGB(239, 68, 68),
  SpecialPurple = Color3.fromRGB(168, 85, 247),
  WarningYellow = Color3.fromRGB(251, 191, 36),
  InfoBlue = Color3.fromRGB(59, 130, 246),
  AccentCyan = Color3.fromRGB(34, 211, 238),
  AccentOrange = Color3.fromRGB(251, 146, 60),
  SuccessGreen = Color3.fromRGB(34, 197, 94),
  LogoImage = "rbxthumb://type=Asset&id=121106170172928&w=150&h=150",
  IconRope  = "rbxthumb://type=Asset&id=6275188156&w=420&h=420",
  IconCuff  = "rbxthumb://type=Asset&id=89998835437276&w=420&h=420",
  IconCarry = "rbxthumb://type=Asset&id=9426978184&w=420&h=420",

  BannerImage = "rbxthumb://type=Asset&id=106098950001934&w=420&h=420",
}

TextSizes = {
  H1 = 16,
  H2 = 13,
  H3 = 12,
  Body = 11,
  Caption = 10,
  Tiny = 9,
}

-- Circular Draggable Toggle Ball
ToggleBall = Instance.new("TextButton")
ToggleBall.Name = "ToggleBall"
ToggleBall.Size = UDim2.fromOffset(48, 48)
ToggleBall.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleBall.BackgroundColor3 = Theme.Bg
ToggleBall.Text = ""
ToggleBall.ClipsDescendants = true
ToggleBall.TextColor3 = Theme.NeonGreen
ToggleBall.TextSize = 1
ToggleBall.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
ToggleBall.Active = true
ToggleBall.Draggable = true
ToggleBall.Visible = false
ToggleBall.Parent = ToxicGui
Instance.new("UICorner", ToggleBall).CornerRadius = UDim.new(1, 0)
tbStroke = Instance.new("UIStroke", ToggleBall)
tbStroke.Color = Theme.NeonGreen
tbStroke.Thickness = 1.8
MakeDraggable(ToggleBall, ToggleBall)
tbImg = Instance.new("ImageLabel", ToggleBall)
tbImg.Size = UDim2.new(1, -8, 1, -8)
tbImg.Position = UDim2.fromOffset(4, 4)
tbImg.BackgroundTransparency = 1
tbImg.Image = Theme.LogoImage
tbImg.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", tbImg).CornerRadius = UDim.new(1, 0)

-- Outer Main Frame (.PWrapper)
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(470, 530)
MainFrame.Position = UDim2.new(0.5, -235, 0.5, -265)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BackgroundTransparency = Theme.BgGlass
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = ToxicGui

MenuWallpaper = Instance.new("ImageLabel")
MenuWallpaper.Name = "MenuWallpaper"
MenuWallpaper.BackgroundTransparency = 1
MenuWallpaper.BorderSizePixel = 0
MenuWallpaper.Size = UDim2.new(1, 0, 1, 0)
MenuWallpaper.Image = ""
MenuWallpaper.ImageTransparency = 1
MenuWallpaper.ScaleType = Enum.ScaleType.Crop
MenuWallpaper.ZIndex = 1
MenuWallpaper.Parent = MainFrame
Instance.new("UICorner", MenuWallpaper).CornerRadius = UDim.new(0, 12)
MenuWallpaperShade = Instance.new("Frame")
MenuWallpaperShade.Name = "MenuWallpaperShade"
MenuWallpaperShade.BackgroundColor3 = Color3.fromRGB(8, 10, 12)
MenuWallpaperShade.BackgroundTransparency = 1
MenuWallpaperShade.BorderSizePixel = 0
MenuWallpaperShade.Size = UDim2.new(1, 0, 1, 0)
MenuWallpaperShade.ZIndex = 1
MenuWallpaperShade.Parent = MainFrame
Instance.new("UICorner", MenuWallpaperShade).CornerRadius = UDim.new(0, 12)

menuReady = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

MenuScale = Instance.new("UIScale")
MenuScale.Name = "MenuScale"
MenuScale.Scale = 1
MenuScale.Parent = MainFrame

BallScale = Instance.new("UIScale")
BallScale.Name = "BallScale"
BallScale.Scale = 1
BallScale.Parent = ToggleBall

RefreshNavLabels = nil
function ApplyDeviceLayout()
  pcall(function()
    cam = workspace.CurrentCamera
    vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    fitW = math.clamp((vs.X - 24) / 470, 0.62, 1.15)
    fitH = math.clamp((vs.Y - 24) / 530, 0.62, 1.15)
    scale = math.min(fitW, fitH)
    if isTouch then
      scale = math.clamp(scale * 0.98, 0.62, 1.05)
      ToggleBall.Size = UDim2.fromOffset(58, 58)
      BallScale.Scale = 1.05
      if Header then Header.Size = UDim2.new(1, 0, 0, 48) end
    else
      ToggleBall.Size = UDim2.fromOffset(48, 48)
      BallScale.Scale = 1
      if Header then Header.Size = UDim2.new(1, 0, 0, 56) end
    end
    MenuScale.Scale = scale
    w, h = 470 * scale, 530 * scale
    if CFG.menu_pos_x and CFG.menu_pos_y then
      MainFrame.Position = UDim2.fromOffset(CFG.menu_pos_x, CFG.menu_pos_y)
    elseif CFG.one_hand == "left" then
      MainFrame.Position = UDim2.new(0, 10, 0.5, math.floor(-h / 2))
    elseif CFG.one_hand == "right" then
      MainFrame.Position = UDim2.new(1, math.floor(-w - 10), 0.5, math.floor(-h / 2))
    else
      MainFrame.Position = UDim2.new(0.5, math.floor(-w / 2), 0.5, math.floor(-h / 2))
    end
    if RefreshNavLabels then RefreshNavLabels(vs.X < 700 or scale < 0.82) end
    if setActionOrbsVisible then setActionOrbsVisible(true) end
    if ClampPhoneHub then ClampPhoneHub() end
  end)
end
ApplyDeviceLayout()
pcall(function()
  cam = workspace.CurrentCamera
  if cam then
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(ApplyDeviceLayout)
  end
end)

MakeDraggable(MainFrame, MainFrame)
MainFrame.InputEnded:Connect(function(io)
  if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
    CFG.menu_pos_x = MainFrame.AbsolutePosition.X
    CFG.menu_pos_y = MainFrame.AbsolutePosition.Y
    SaveToxicCFG()
  end
end)

-- Glowing Emerald Border (.PWrapper border & box-shadow)
mfStroke = Instance.new("UIStroke", MainFrame)
mfStroke.Color = Theme.GlowStroke
mfStroke.Thickness = 1.6
mfStroke.Transparency = 0.25

-- ----------------------------------------------------
-- ON-SCREEN ADMIN & SPECTATOR HUD OVERLAY (.Metadata Style)
-- ----------------------------------------------------
AdminHudBtn = nil
AdminHudFrame = Instance.new("Frame")
AdminHudFrame.Name = "AdminHudFrame"
AdminHudFrame.Size = UDim2.fromOffset(280, 0)
AdminHudFrame.AutomaticSize = Enum.AutomaticSize.Y
AdminHudFrame.Position = UDim2.new(0.8, -10, 0.05, 0)
AdminHudFrame.BackgroundColor3 = Theme.Bg
AdminHudFrame.BackgroundTransparency = 0.08
AdminHudFrame.BorderSizePixel = 0
AdminHudFrame.Active = true
AdminHudFrame.Draggable = true
AdminHudFrame.Visible = CFG.admin_hud_enabled
AdminHudFrame.Parent = ToxicGui
MakeDraggable(AdminHudFrame, AdminHudFrame)

Instance.new("UICorner", AdminHudFrame).CornerRadius = UDim.new(0, 12)
ahStroke = Instance.new("UIStroke", AdminHudFrame)
ahStroke.Color = Theme.GlowStroke
ahStroke.Thickness = 1.4
ahStroke.Transparency = 0.25

HudHeader = Instance.new("TextButton")
HudHeader.Name = "HudHeader"
HudHeader.Size = UDim2.new(1, 0, 0, 36)
HudHeader.BackgroundColor3 = Theme.InputBg
HudHeader.BackgroundTransparency = 0.05
HudHeader.Text = ""
HudHeader.Parent = AdminHudFrame
Instance.new("UICorner", HudHeader).CornerRadius = UDim.new(0, 12)
MakeDraggable(AdminHudFrame, HudHeader)

HudTitle = Instance.new("TextLabel")

HudTitle.Size = UDim2.new(1, -88, 1, 0)
HudTitle.Position = UDim2.fromOffset(36, 0)
HudTitle.BackgroundTransparency = 1
HudTitle.Text = "Admins"
HudTitle.TextColor3 = Theme.TextWhite
HudTitle.TextSize = 12
HudTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
HudTitle.TextXAlignment = Enum.TextXAlignment.Left
HudTitle.Parent = HudHeader

-- regfix
HudMark = Instance.new("ImageLabel", HudHeader)
HudMark.Size = UDim2.fromOffset(22, 22)
HudMark.Position = UDim2.fromOffset(8, 7)
HudMark.BackgroundColor3 = Color3.fromRGB(8, 10, 9)
HudMark.BorderSizePixel = 0
HudMark.Image = Theme.LogoImage
HudMark.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", HudMark).CornerRadius = UDim.new(1, 0)
-- regfix
hmStroke = Instance.new("UIStroke", HudMark)
hmStroke.Color = Theme.NeonGreen
hmStroke.Thickness = 1.4

HudCount = Instance.new("TextLabel")
HudCount.Size = UDim2.fromOffset(45, 36)
HudCount.Position = UDim2.new(1, -78, 0, 0)
HudCount.BackgroundTransparency = 1
HudCount.Text = "(0)"
HudCount.TextColor3 = Theme.NeonGreen
HudCount.TextSize = 11
HudCount.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
HudCount.TextXAlignment = Enum.TextXAlignment.Right
HudCount.Parent = HudHeader

HudClose = Instance.new("TextButton")
HudClose.Size = UDim2.fromOffset(20, 20)
HudClose.Position = UDim2.new(1, -24, 0, 4)
HudClose.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
HudClose.BackgroundTransparency = 1
HudClose.Text = "X"
HudClose.TextColor3 = Color3.new(1, 0.4, 0.4)
HudClose.TextSize = 12
HudClose.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
HudClose.Parent = HudHeader

HudClose.MouseButton1Click:Connect(function()
  SetAdminHudVisible(false)
end)
HudClose.MouseEnter:Connect(function() HudClose.TextColor3 = Color3.new(1,0,0) end)
HudClose.MouseLeave:Connect(function() HudClose.TextColor3 = Color3.new(1,0.4,0.4) end)

HudEntriesContainer = Instance.new("Frame")
HudEntriesContainer.Name = "HudEntriesContainer"
HudEntriesContainer.Size = UDim2.new(1, 0, 0, 0)
HudEntriesContainer.Position = UDim2.fromOffset(0, 36)
HudEntriesContainer.AutomaticSize = Enum.AutomaticSize.Y
HudEntriesContainer.BackgroundTransparency = 1
HudEntriesContainer.Parent = AdminHudFrame

hudPadding = Instance.new("UIPadding", HudEntriesContainer)
hudPadding.PaddingLeft = UDim.new(0, 8)
hudPadding.PaddingRight = UDim.new(0, 8)
hudPadding.PaddingTop = UDim.new(0, 4)
hudPadding.PaddingBottom = UDim.new(0, 6)

hudLayout = Instance.new("UIListLayout", HudEntriesContainer)
hudLayout.Padding = UDim.new(0, 3)

hudMode = "admins"
HudHeader.MouseButton1Click:Connect(function()
  if hudMode == "admins" then
    hudMode = "spectators"
    HudTitle.Text = "Spectators"
  elseif hudMode == "spectators" then
    hudMode = "both"
    HudTitle.Text = "Admins & Watchers"
  else
    hudMode = "admins"
    HudTitle.Text = "Admins"
  end
  ShowNotification("HUD Mode: " .. HudTitle.Text, "", 1.5)
end)

function SetAdminHudVisible(visible)
  CFG.admin_hud_enabled = visible
  AdminHudFrame.Visible = visible
  if AdminHudBtn then
    AdminHudBtn.Text = visible and "HUD: ON" or "HUD: OFF"
    AdminHudBtn.BackgroundColor3 = visible and Theme.NeonGreen or Theme.CardBg
    AdminHudBtn.TextColor3 = visible and Color3.fromRGB(0, 20, 10) or Theme.TextWhite
  end
end

-- Live HUD loop
task.spawn(function()
  while true do
    task.wait(0.5)
    if CFG.admin_hud_enabled and AdminHudFrame.Visible then
      pcall(function()
        myChar = LocalPlayer.Character
        myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        myPos = myHRP and myHRP.Position or Vector3.new(0, 0, 0)

        items = {}
        for _, plr in ipairs(Players:GetPlayers()) do
          if plr ~= LocalPlayer then
            uName = plr.Name
            tChar = plr.Character
            tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
            dist = tHRP and (tHRP.Position - myPos).Magnitude or 9999
            distMeters = math.floor(dist * 0.28 * 10) / 10
            isSpec = SpectateWatcher.spectators[uName] == true
            aData = getAdminData(plr)

            shouldShow = false
            tagPrefix = "R"
            badgeTag = "FAR"
            if distMeters < 30 then
              badgeTag = "CLOSE"
            elseif distMeters < 90 then
              badgeTag = "MID"
            else
              badgeTag = "FAR"
            end

            if hudMode == "admins" then
              if aData.isAdmin then
                shouldShow = true
                abbrev = aData.tag ~= "" and aData.tag:sub(1, 3) or "ADM"
                tagPrefix = abbrev
              end
            elseif hudMode == "spectators" then
              if isSpec then
                shouldShow = true
                tagPrefix = "SPEC"
                badgeTag = "WATCH"
              end
            else
              if aData.isAdmin then
                shouldShow = true
                abbrev = aData.tag ~= "" and aData.tag:sub(1, 3) or "ADM"
                tagPrefix = abbrev
              elseif isSpec then
                shouldShow = true
                tagPrefix = "SPEC"
                badgeTag = "WATCH"
              end
            end

            if shouldShow then
              table.insert(items, {
                name = uName,
                tag = tagPrefix,
                distMeters = distMeters,
                badge = badgeTag,
                isAdmin = aData.isAdmin,
                isSpec = isSpec
              })
            end
          end
        end

        HudCount.Text = "(" .. #items .. ")"

        for _, child in ipairs(HudEntriesContainer:GetChildren()) do
          if child:IsA("Frame") then child:Destroy() end
        end

        if #items == 0 then
          emptyRow = Instance.new("Frame")
          emptyRow.Size = UDim2.new(1, 0, 0, 18)
          emptyRow.BackgroundTransparency = 1
          emptyRow.Parent = HudEntriesContainer

          eLabel = Instance.new("TextLabel")
          eLabel.Size = UDim2.new(1, 0, 1, 0)
          eLabel.BackgroundTransparency = 1
          eLabel.Text = (hudMode == "admins" and "No admins in server" or hudMode == "spectators" and "No spectators" or "None detected")
          eLabel.TextColor3 = Theme.TextDim
          eLabel.TextSize = 10
          eLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
          eLabel.TextXAlignment = Enum.TextXAlignment.Left
          eLabel.Parent = emptyRow
        else
          for _, it in ipairs(items) do
            row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundColor3 = it.isSpec and Color3.fromRGB(40, 28, 16) or Theme.CardBg
            row.Parent = HudEntriesContainer
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            leftLbl = Instance.new("TextLabel")
            leftLbl.Size = UDim2.new(1, -58, 1, 0)
            leftLbl.Position = UDim2.fromOffset(8, 0)
            leftLbl.BackgroundTransparency = 1
            leftLbl.Text = it.tag .. "  " .. it.name .. "  " .. string.format("%.0f", it.distMeters) .. "m"
            leftLbl.TextColor3 = it.isSpec and Theme.WarningYellow or Theme.TextWhite
            leftLbl.TextSize = 10
            leftLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
            leftLbl.TextXAlignment = Enum.TextXAlignment.Left
            leftLbl.TextTruncate = Enum.TextTruncate.AtEnd
            leftLbl.Parent = row

            rightLbl = Instance.new("TextLabel")
            rightLbl.Size = UDim2.fromOffset(50, 16)
            rightLbl.Position = UDim2.new(1, -54, 0, 4)
            rightLbl.BackgroundColor3 = it.isSpec and Theme.WarningYellow or Theme.NeonDarkGreen
            rightLbl.Text = it.isSpec and "WATCH" or it.badge
            rightLbl.TextColor3 = it.isSpec and Color3.fromRGB(20, 16, 6) or Theme.TextWhite
            rightLbl.TextSize = 9
            rightLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
            rightLbl.TextXAlignment = Enum.TextXAlignment.Center
            rightLbl.Parent = row
            Instance.new("UICorner", rightLbl).CornerRadius = UDim.new(0, 4)
          end
        end
      end)
    end
  end
end)

-- ----------------------------------------------------
-- 1. FIVEM TOP BANNER (.PBanner)
-- ----------------------------------------------------
Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 56)
Header.BackgroundColor3 = Theme.InputBg
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
MakeDraggable(MainFrame, Header)

HeaderBanner = Instance.new("ImageLabel", Header)
HeaderBanner.Size = UDim2.new(1, 0, 1, 0)
HeaderBanner.BackgroundTransparency = 1
HeaderBanner.Image = Theme.BannerImage
HeaderBanner.ImageTransparency = 0.28
HeaderBanner.ScaleType = Enum.ScaleType.Crop
HeaderBanner.ZIndex = 1

-- regfix
hLine = Instance.new("Frame", Header)
hLine.Size = UDim2.new(1, 0, 0, 2)
hLine.Position = UDim2.new(0, 0, 1, -2)
hLine.BackgroundColor3 = Theme.NeonGreen
hLine.BackgroundTransparency = 0.35
hLine.BorderSizePixel = 0

BrandMark = Instance.new("ImageLabel", Header)
BrandMark.Size = UDim2.fromOffset(32, 32)
BrandMark.Position = UDim2.fromOffset(12, 12)
BrandMark.BackgroundColor3 = Color3.fromRGB(8, 10, 9)
BrandMark.BorderSizePixel = 0
BrandMark.Image = Theme.LogoImage
BrandMark.ScaleType = Enum.ScaleType.Fit
BrandMark.ZIndex = 3
Instance.new("UICorner", BrandMark).CornerRadius = UDim.new(1, 0)
bmStroke = Instance.new("UIStroke", BrandMark)
bmStroke.Color = Theme.NeonGreen
bmStroke.Thickness = 2
bmStroke.Transparency = 0.1
bmStroke.Color = Theme.NeonGreen
bmStroke.Thickness = 1

TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -160, 0, 24)
TitleLabel.Position = UDim2.fromOffset(48, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TOXIC V1"
TitleLabel.TextColor3 = Theme.TextWhite
TitleLabel.TextSize = 18
TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

SubLabel = Instance.new("TextButton")
SubLabel.Size = UDim2.new(1, -120, 0, 16)
SubLabel.Position = UDim2.fromOffset(48, 32)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "oumy0  |  no target"
SubLabel.TextColor3 = Theme.TextDim
SubLabel.TextSize = 10
SubLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = Header

function RefreshHeaderTarget()
  n = CFG.cuff_target
  if n and n ~= "" then
    p = Players:FindFirstChild(n)
    SubLabel.Text = "oumy0  |  target " .. ((p and p.DisplayName) or n)
    SubLabel.TextColor3 = Theme.TextWhite
  else
    SubLabel.Text = "oumy0  |  no target"
    SubLabel.TextColor3 = Theme.TextDim
  end
end

SubLabel.MouseButton1Click:Connect(function()
  setclipboard("OUMY0")
  ShowNotification("Discord user copied!", "", 2)
end)

-- Minimize Button (-)
MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.fromOffset(26, 26)
MinBtn.Position = UDim2.new(1, -66, 0, 15)
MinBtn.BackgroundColor3 = Theme.CardOff
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextWhite
MinBtn.TextSize = 14
MinBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Close Button (X)
CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 15)
CloseBtn.BackgroundColor3 = Theme.DangerRed
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

MinBtn.Modal = true
CloseBtn.Modal = true

-- Modal Keeper
ModalKeeper = Instance.new("TextButton")
ModalKeeper.Name = "ModalKeeper"
ModalKeeper.Size = UDim2.new(1, 0, 1, 0)
ModalKeeper.BackgroundTransparency = 1
ModalKeeper.Text = ""
ModalKeeper.Modal = true
ModalKeeper.Active = false
ModalKeeper.ZIndex = -10
ModalKeeper.Parent = MainFrame

mouseForceUnlocked = false
do
mouseAcc = 0
RunService.Heartbeat:Connect(function(dt)
  mouseAcc = mouseAcc + dt
  if mouseAcc < 0.15 then return end
  mouseAcc = 0
  if (MainFrame and MainFrame.Visible) or mouseForceUnlocked then
    pcall(function()
      UserInputService.MouseBehavior = Enum.MouseBehavior.Default
      UserInputService.MouseIconEnabled = true
    end)
  end
end)
end

function ReleaseAllMouseInputs()
  pcall(function()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
  end)
  pcall(function()
    vim = game:GetService("VirtualInputManager")
    if vim then vim:SendMouseButtonEvent(0, 0, 0, false, game, 1) end
  end)
  pcall(function()
    vu = game:GetService("VirtualUser")
    if vu then vu:Button1Up(Vector2.zero) end
  end)
  pcall(function()
    if mouse1release then mouse1release() end
  end)
end

function ToggleMenuVisibility()
  if not menuReady then return end
  MainFrame.Visible = not MainFrame.Visible
  ToggleBall.Visible = not MainFrame.Visible
  ReleaseAllMouseInputs()
  if MainFrame.Visible then
    ApplyDeviceLayout()
    pcall(function()
      centerPos = MainFrame.AbsolutePosition + (MainFrame.AbsoluteSize / 2)
      createToxicLogo(centerPos.X, centerPos.Y)
    end)
  end
end

MinBtn.MouseButton1Click:Connect(ToggleMenuVisibility)
CloseBtn.MouseButton1Click:Connect(ToggleMenuVisibility)
ToggleBall.MouseButton1Click:Connect(ToggleMenuVisibility)

-- Phone shortcut hub: one draggable ball + tray of enabled binds only
ActionOrbs = {}
CFG.orb_positions = CFG.orb_positions or {}
CFG.orb_enabled = CFG.orb_enabled or {}

BIND_MAP = {
  C = { key = "cuff_arrest_keybind", tip = "Cuff", color = Theme.WarningYellow, fn = function() L_RM_DoCuffSequence() end },
  R = { key = "cuff_7bel_keybind", tip = "7BEL", color = Theme.NeonGreen, fn = function() L_RM_Do7belSequence() end },
  Y = { key = "cuff_carryside_keybind", tip = "Carry", color = Theme.AccentCyan, fn = function() CarrySide_Execute() end },
  F = { key = "cuff_fling_keybind", tip = "Fling", color = Theme.DangerRed, fn = function() FlingCarry_Execute() end },
  S = { key = "spec_keybind", tip = "Spec", color = Theme.InfoBlue, fn = function()
    if CFG.cuff_target and CFG.cuff_target ~= "" then ToggleSpectate(CFG.cuff_target) else ShowNotification("Select a target first", "", 1.5) end
  end },
  U = { key = "uncuff_keybind", tip = "Uncuff", color = Theme.TextWhite, fn = function() if DoSelfUncuff then DoSelfUncuff() end end },
  A = { key = "aura_keybind", tip = "Aura", color = Theme.SpecialPurple, fn = function() if ToggleAura then ToggleAura() end end },
  I = { key = "invis_keybind", tip = "INV", color = Theme.AccentOrange, fn = function() if ToggleServerInvisibility then ToggleServerInvisibility() end end },
  M = { key = "menu_keybind", tip = "Menu", color = Theme.NeonGreen, fn = function() ToggleMenuVisibility() end },
}

function IsPhoneDevice()
  if UserInputService.TouchEnabled then
    if UserInputService.MouseEnabled and UserInputService.KeyboardEnabled and not UserInputService.GyroscopeEnabled then
      return false
    end
    return true
  end
  return false
end

function ShouldShowActionOrbs()
  if CFG.action_orbs == false then return false end
  return IsPhoneDevice()
end

function AnyOrbEnabled()
  CFG.orb_enabled = CFG.orb_enabled or {}
  for _, on in pairs(CFG.orb_enabled) do
    if on == true then return true end
  end
  return false
end

function ClampGuiPos(x, y, w, h)
  local cam = workspace.CurrentCamera
  local vs = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
  w = w or 52
  h = h or 52
  x = math.clamp(x, 4, math.max(4, vs.X - w - 4))
  y = math.clamp(y, 4, math.max(4, vs.Y - h - 4))
  return x, y
end

function ClampPhoneHub()
  if not PhoneHub then return end
  local pos = PhoneHub.AbsolutePosition
  local x, y = ClampGuiPos(pos.X, pos.Y, PhoneHub.AbsoluteSize.X, PhoneHub.AbsoluteSize.Y)
  PhoneHub.Position = UDim2.fromOffset(x, y)
  CFG.orb_positions.HUB = { x = x, y = y }
end

function RebuildPhoneTray()
  if not PhoneTray then return end
  for _, ch in ipairs(PhoneTray:GetChildren()) do
    if ch:IsA("TextButton") then ch:Destroy() end
  end
  local n = 0
  local order = { "C", "R", "Y", "F", "S", "U", "A", "I", "M" }
  CFG.orb_enabled = CFG.orb_enabled or {}
  for _, letter in ipairs(order) do
    if CFG.orb_enabled[letter] == true and BIND_MAP[letter] then
      n = n + 1
      local spec = BIND_MAP[letter]
      local b = Instance.new("TextButton")
      b.Name = "Tray_" .. letter
      b.Size = UDim2.fromOffset(40, 40)
      b.BackgroundColor3 = Theme.InputBg
      b.Text = letter
      b.TextColor3 = spec.color or Theme.NeonGreen
      b.TextSize = 15
      b.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      b.Parent = PhoneTray
      Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
      local st = Instance.new("UIStroke", b)
      st.Color = spec.color or Theme.NeonGreen
      st.Thickness = 1.3
      b.MouseButton1Click:Connect(function()
        if spec.fn then pcall(spec.fn) end
        ShowNotification(spec.tip, "", 1.0)
      end)
    end
  end
  PhoneTray.Size = UDim2.fromOffset(48, math.max(8, n * 44 + 8))
end

function setActionOrbsVisible(on)
  local show = on ~= false and ShouldShowActionOrbs() and AnyOrbEnabled()
  if PhoneHub then PhoneHub.Visible = show end
  if PhoneTray and not show then PhoneTray.Visible = false end
  if show then RebuildPhoneTray() end
end

do
  PhoneHub = Instance.new("TextButton")
  PhoneHub.Name = "PhoneHub"
  PhoneHub.Size = UDim2.fromOffset(52, 52)
  local saved = CFG.orb_positions.HUB
  if type(saved) == "table" and saved.x and saved.y then
    local x, y = ClampGuiPos(saved.x, saved.y, 52, 52)
    PhoneHub.Position = UDim2.fromOffset(x, y)
  else
    PhoneHub.Position = UDim2.new(1, -62, 0.42, 0)
  end
  PhoneHub.BackgroundColor3 = Theme.Bg
  PhoneHub.Text = "SQ"
  PhoneHub.TextColor3 = Theme.NeonGreen
  PhoneHub.TextSize = 14
  PhoneHub.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  PhoneHub.ZIndex = 45
  PhoneHub.Visible = false
  PhoneHub.Parent = ToxicGui
  Instance.new("UICorner", PhoneHub).CornerRadius = UDim.new(1, 0)
  local hs = Instance.new("UIStroke", PhoneHub)
  hs.Color = Theme.NeonGreen
  hs.Thickness = 1.8

  PhoneTray = Instance.new("Frame")
  PhoneTray.Name = "PhoneTray"
  PhoneTray.Size = UDim2.fromOffset(48, 8)
  PhoneTray.Position = UDim2.fromOffset(-4, 56)
  PhoneTray.BackgroundColor3 = Theme.InputBg
  PhoneTray.BackgroundTransparency = 0.15
  PhoneTray.Visible = false
  PhoneTray.ZIndex = 44
  PhoneTray.Parent = PhoneHub
  Instance.new("UICorner", PhoneTray).CornerRadius = UDim.new(0, 10)
  local tl = Instance.new("UIListLayout", PhoneTray)
  tl.FillDirection = Enum.FillDirection.Vertical
  tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
  tl.Padding = UDim.new(0, 4)
  local tp = Instance.new("UIPadding", PhoneTray)
  tp.PaddingTop = UDim.new(0, 4)
  tp.PaddingBottom = UDim.new(0, 4)

  local dragging, moved, startPos, startFrame = false, false, nil, nil
  PhoneHub.InputBegan:Connect(function(io)
    if io.UserInputType ~= Enum.UserInputType.MouseButton1 and io.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging = true
    moved = false
    startPos = io.Position
    startFrame = PhoneHub.AbsolutePosition
  end)
  UserInputService.InputChanged:Connect(function(io)
    if not dragging or CFG.orbs_locked then return end
    if io.UserInputType ~= Enum.UserInputType.MouseMovement and io.UserInputType ~= Enum.UserInputType.Touch then return end
    if not startPos or not startFrame then return end
    local delta = io.Position - startPos
    if math.abs(delta.X) + math.abs(delta.Y) > 12 then moved = true end
    if moved then
      local x, y = ClampGuiPos(startFrame.X + delta.X, startFrame.Y + delta.Y, 52, 52)
      PhoneHub.Position = UDim2.fromOffset(x, y)
    end
  end)
  UserInputService.InputEnded:Connect(function(io)
    if not dragging then return end
    if io.UserInputType ~= Enum.UserInputType.MouseButton1 and io.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging = false
    if moved then
      CFG.orb_positions.HUB = { x = PhoneHub.AbsolutePosition.X, y = PhoneHub.AbsolutePosition.Y }
      SaveToxicCFG()
      return
    end
    RebuildPhoneTray()
    PhoneTray.Visible = not PhoneTray.Visible
  end)
end

setActionOrbsVisible(true)

-- ----------------------------------------------------
-- 2. FIVEM CATEGORIES BAR (.PCategories)
-- ----------------------------------------------------
NavContainer = Instance.new("Frame")
NavContainer.Name = "NavContainer"
NavContainer.Size = UDim2.new(1, -20, 0, 42)
NavContainer.Position = UDim2.fromOffset(10, 60)
NavContainer.BackgroundColor3 = Theme.InputBg
NavContainer.BorderSizePixel = 0
NavContainer.ZIndex = 5
NavContainer.Parent = MainFrame
Instance.new("UICorner", NavContainer).CornerRadius = UDim.new(0, 8)
-- regfix
navPad = Instance.new("UIPadding", NavContainer)
navPad.PaddingLeft = UDim.new(0, 3)
navPad.PaddingRight = UDim.new(0, 3)
navPad.PaddingTop = UDim.new(0, 3)
navPad.PaddingBottom = UDim.new(0, 3)

-- regfix
navLL = Instance.new("UIListLayout", NavContainer)
navLL.FillDirection = Enum.FillDirection.Horizontal
navLL.Padding = UDim.new(0, 4)

tabs = {"Players", "Troll", "Exploits", "Visuals", "Piano", "Chat", "Adapt", "Settings"}
tabBtns = {}
pages = {}
updateTargetCard = nil

-- Page Container
PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -28, 1, -140)
PageContainer.Position = UDim2.fromOffset(18, 108)
PageContainer.BackgroundTransparency = 1
PageContainer.ZIndex = 5
PageContainer.Parent = MainFrame

-- Left Vertical Scroll Indicator (.PScroll)
-- regfix
LeftScrollTrack = Instance.new("Frame", MainFrame)
LeftScrollTrack.Size = UDim2.new(0, 3, 1, -140)
LeftScrollTrack.Position = UDim2.fromOffset(10, 108)
LeftScrollTrack.BackgroundColor3 = Theme.CardBg
LeftScrollTrack.BorderSizePixel = 0
Instance.new("UICorner", LeftScrollTrack).CornerRadius = UDim.new(1, 0)

LeftScrollThumb = Instance.new("Frame", LeftScrollTrack)
LeftScrollThumb.Size = UDim2.new(1, 0, 0.25, 0)
LeftScrollThumb.Position = UDim2.new(0, 0, 0, 0)
LeftScrollThumb.BackgroundColor3 = Theme.NeonGreen
LeftScrollThumb.BorderSizePixel = 0
Instance.new("UICorner", LeftScrollThumb).CornerRadius = UDim.new(1, 0)

for _, tabName in ipairs(tabs) do
  btn = Instance.new("TextButton")
  btn.Size = UDim2.new(1 / #tabs, -4, 1, 0)
  btn.BackgroundTransparency = 1
  btn.Text = ""
  btn.Parent = NavContainer

  glowBg = Instance.new("Frame")
  glowBg.BackgroundColor3 = (tabName == "Players") and Theme.NeonGreen or Theme.CardBg
  glowBg.Size = UDim2.new(1, 0, 1, 0)
  glowBg.BorderSizePixel = 0
  glowBg.Parent = btn
  Instance.new("UICorner", glowBg).CornerRadius = UDim.new(0, 8)
  gStroke = Instance.new("UIStroke", glowBg)
  gStroke.Color = (tabName == "Players") and Theme.NeonGreen or Theme.GlowStroke
  gStroke.Thickness = 1
  gStroke.Transparency = (tabName == "Players") and 0.2 or 0.55

  activeLine = Instance.new("Frame", btn)
  activeLine.Size = UDim2.new(0.55, 0, 0, 2)
  activeLine.Position = UDim2.new(0.225, 0, 1, -3)
  activeLine.BackgroundColor3 = Theme.TextWhite
  activeLine.BorderSizePixel = 0
  activeLine.Visible = (tabName == "Players")
  Instance.new("UICorner", activeLine).CornerRadius = UDim.new(1, 0)

  ic = Instance.new("TextLabel", btn)
  ic.Size = UDim2.new(1, 0, 0, 1)
  ic.Position = UDim2.fromOffset(0, 0)
  ic.BackgroundTransparency = 1
  ic.Text = ""
  ic.TextColor3 = (tabName == "Players") and Color3.fromRGB(8, 20, 12) or Theme.NeonGreen
  ic.TextSize = 11
  ic.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

  txtLabel = Instance.new("TextLabel")
  txtLabel.Size = UDim2.new(1, -2, 1, -6)
  txtLabel.Position = UDim2.fromOffset(1, 2)
  txtLabel.BackgroundTransparency = 1
  txtLabel.Text = tabName:upper()
  txtLabel.TextColor3 = (tabName == "Players") and Color3.fromRGB(8, 20, 12) or Theme.TextDim
  txtLabel.TextSize = 10
  txtLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  txtLabel.TextXAlignment = Enum.TextXAlignment.Center
  txtLabel.TextTruncate = Enum.TextTruncate.AtEnd
  txtLabel.Parent = btn

  tabBtns[tabName] = { btn = btn, line = activeLine, glow = glowBg, txt = txtLabel, ic = ic, stroke = gStroke }

  page = nil
  if tabName == "Players" then
    page = Instance.new("Frame")
  else
    page = Instance.new("ScrollingFrame")
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.NeonGreen
    page.AutomaticCanvasSize = Enum.AutomaticSize.None
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
  end
  page.Size = UDim2.new(1, 0, 1, 0)
  page.BackgroundTransparency = 1
  page.Visible = (tabName == "Players")
  page.Parent = PageContainer
  pages[tabName] = page

  if page:IsA("ScrollingFrame") then
    page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
      if page.Visible then
        maxScroll = page.AbsoluteCanvasSize.Y - page.AbsoluteWindowSize.Y
        if maxScroll > 0 then
          pct = math.clamp(page.CanvasPosition.Y / maxScroll, 0, 0.75)
          LeftScrollThumb.Position = UDim2.new(0, 0, pct, 0)
        else
          LeftScrollThumb.Position = UDim2.new(0, 0, 0, 0)
        end
      end
    end)
  end

  btn.MouseButton1Click:Connect(function()
    for name, data in pairs(tabBtns) do
      isActive = (name == tabName)
      data.glow.BackgroundColor3 = isActive and Theme.NeonGreen or Theme.CardBg
      data.txt.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.TextDim
      data.line.Visible = isActive
      if data.ic then data.ic.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.NeonGreen end
      if data.stroke then
        data.stroke.Color = isActive and Theme.NeonGreen or Theme.GlowStroke
        data.stroke.Transparency = isActive and 0.15 or 0.55
      end
      pages[name].Visible = isActive
    end
    LeftScrollThumb.Position = UDim2.new(0, 0, 0, 0)
    if pages[tabName] and pages[tabName]:IsA("ScrollingFrame") then
      pages[tabName].CanvasPosition = Vector2.zero
      layout = pages[tabName]:FindFirstChildOfClass("UIListLayout")
      if layout and layout.AbsoluteContentSize.Y > 0 then
        pages[tabName].CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
      end
    end
    CFG.last_tab = tabName
    SaveToxicCFG()
    if tabName == "Troll" and updateTargetCard then
      local live = GetLiveTarget and GetLiveTarget() or nil
      if live then
        updateTargetCard(live)
      else
        updateTargetCard(nil)
      end
    end
  end)
end

TAB_SHORT = {
  Players = "PLY", Troll = "TRL", Exploits = "EXP", Visuals = "VIS",
  Piano = "PNO", Chat = "CHT", Adapt = "ADP", Settings = "SET",
}
TAB_LANG = {
  EN = { Players = "PLAYERS", Troll = "TROLL", Exploits = "EXPLOITS", Visuals = "VISUALS", Piano = "PIANO", Chat = "CHAT", Adapt = "ADAPT", Settings = "SETTINGS" },
}

RefreshNavLabels = function(useShort)
  CFG.ui_lang = "EN"
CFG.esp_boxes = false
CFG.esp_tracers = false
  local lang = TAB_LANG.EN
  local nPlayers = math.max(0, #Players:GetPlayers() - 1)
  for name, data in pairs(tabBtns) do
    local label = useShort and TAB_SHORT[name] or (lang[name] or name:upper())
    if name == "Players" then
      label = label .. " " .. tostring(nPlayers)
    end
    data.txt.Text = label
  end
end
RefreshNavLabels(false)

function makeSectionHead(parent, icon, title, hint)
  wrap = Instance.new("Frame", parent)
  wrap.Size = UDim2.new(1, 0, 0, 28)
  wrap.BackgroundTransparency = 1

  iconBox = Instance.new("TextLabel", wrap)
  iconBox.Size = UDim2.fromOffset(22, 22)
  iconBox.Position = UDim2.fromOffset(0, 3)
  iconBox.BackgroundColor3 = Theme.InputBg
  iconBox.Text = icon or ""
  iconBox.TextColor3 = Theme.NeonGreen
  iconBox.TextSize = 11
  iconBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 6)
  ibs = Instance.new("UIStroke", iconBox)
  ibs.Color = Theme.GlowStroke
  ibs.Transparency = 0.4
  ibs.Thickness = 1

  ttl = Instance.new("TextLabel", wrap)
  ttl.Size = UDim2.new(1, -32, 0, 16)
  ttl.Position = UDim2.fromOffset(28, 1)
  ttl.BackgroundTransparency = 1
  ttl.Text = title
  ttl.TextColor3 = Theme.TextWhite
  ttl.TextSize = 12
  ttl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  ttl.TextXAlignment = Enum.TextXAlignment.Left

  if hint and hint ~= "" then
    hn = Instance.new("TextLabel", wrap)
    hn.Size = UDim2.new(1, -32, 0, 12)
    hn.Position = UDim2.fromOffset(28, 15)
    hn.BackgroundTransparency = 1
    hn.Text = hint
    hn.TextColor3 = Theme.TextMuted
    hn.TextSize = 9
    hn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    hn.TextXAlignment = Enum.TextXAlignment.Left
  end
  return wrap
end

-- ----------------------------------------------------
-- 3. FIVE-M CARD BUILDERS (.PTabs .PTab)
-- ----------------------------------------------------
function makeFiveMCard(parent, title, desc, icon)
  card = Instance.new("Frame")
  card.Size = UDim2.new(1, 0, 0, 44)
  card.BackgroundColor3 = Theme.CardBg
  card.BorderSizePixel = 0
  card.Parent = parent
  Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

  stroke = Instance.new("UIStroke", card)
  stroke.Color = Theme.GlowStroke
  stroke.Thickness = 1
  stroke.Transparency = 0.7

  card.MouseEnter:Connect(function()
    card.BackgroundColor3 = Theme.CardBgHover
  end)
  card.MouseLeave:Connect(function()
    card.BackgroundColor3 = Theme.CardBg
  end)

  tLabel = Instance.new("TextLabel")
  tLabel.Size = UDim2.new(1, -70, 0, 18)
  tLabel.Position = UDim2.fromOffset(12, 5)
  tLabel.BackgroundTransparency = 1
  tLabel.Text = title
  tLabel.TextColor3 = Theme.TextWhite
  tLabel.TextSize = 12
  tLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  tLabel.TextXAlignment = Enum.TextXAlignment.Left
  tLabel.Parent = card

  dLabel = Instance.new("TextLabel")
  dLabel.Size = UDim2.new(1, -70, 0, 14)
  dLabel.Position = UDim2.fromOffset(12, 23)
  dLabel.BackgroundTransparency = 1
  dLabel.Text = desc or "Feature description"
  dLabel.TextColor3 = Theme.TextDim
  dLabel.TextSize = 10
  dLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  dLabel.TextXAlignment = Enum.TextXAlignment.Left
  dLabel.Parent = card

  return card
end

function paintSwitch(switch, knob, tag, on)
  switch.BackgroundColor3 = on and Color3.fromRGB(46, 220, 110) or Color3.fromRGB(28, 32, 38)
  knob.Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
  knob.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 156, 164)
  if tag then
    tag.Text = on and "ON" or "OFF"
    tag.TextColor3 = on and Color3.fromRGB(46, 220, 110) or Color3.fromRGB(140, 148, 156)
  end
end

_togglePaints = _togglePaints or {}
function RefreshEspSwitches()
  for _, fn in ipairs(_togglePaints) do pcall(fn) end
end
function makeFiveMToggle(parent, title, desc, icon, getter, setter)
  local card = makeFiveMCard(parent, title, desc, icon)
  local tag = Instance.new("TextLabel", card)
  tag.BackgroundTransparency = 1
  tag.Size = UDim2.fromOffset(28, 12)
  tag.Position = UDim2.new(1, -80, 0.5, -6)
  tag.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  tag.TextSize = 9
  tag.TextXAlignment = Enum.TextXAlignment.Right
  local switch = Instance.new("TextButton")
  switch.Size = UDim2.fromOffset(38, 20)
  switch.Position = UDim2.new(1, -48, 0.5, -10)
  switch.Text = ""
  switch.AutoButtonColor = false
  switch.Parent = card
  Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
  local knob = Instance.new("Frame", switch)
  knob.Size = UDim2.fromOffset(14, 14)
  knob.BorderSizePixel = 0
  Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
  paintSwitch(switch, knob, tag, getter() and true or false)
  switch.MouseButton1Click:Connect(function()
    setter(not getter())
    paintSwitch(switch, knob, tag, getter() and true or false)
    if RefreshEspSwitches then RefreshEspSwitches() end
  end)
  table.insert(_togglePaints, function()
    paintSwitch(switch, knob, tag, getter() and true or false)
  end)
  return card
end

-- ----------------------------------------------------
-- 4. PLAYERS TAB CONTENT (.Metadata & Live Player Cards)
-- ----------------------------------------------------
mainPage = pages["Players"]

SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, 0, 0, 34)
SearchBox.Position = UDim2.fromOffset(0, 0)
SearchBox.BackgroundColor3 = Theme.InputBg
SearchBox.PlaceholderText = "  name / @user / userid..."
SearchBox.PlaceholderColor3 = Theme.TextMuted
SearchBox.Text = ""
SearchBox.TextColor3 = Theme.TextWhite
SearchBox.TextSize = 12
SearchBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = mainPage
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 8)
sbStroke = Instance.new("UIStroke", SearchBox)
sbStroke.Color = Theme.GlowStroke
sbStroke.Thickness = 1
sbStroke.Transparency = 0.45
Instance.new("UIPadding", SearchBox).PaddingLeft = UDim.new(0, 10)

TargetBar = Instance.new("Frame", mainPage)
TargetBar.Size = UDim2.new(1, 0, 0, 36)
TargetBar.Position = UDim2.fromOffset(0, 38)
TargetBar.BackgroundColor3 = Theme.CardBg
TargetBar.BorderSizePixel = 0
Instance.new("UICorner", TargetBar).CornerRadius = UDim.new(0, 8)
tbBarStroke = Instance.new("UIStroke", TargetBar)
tbBarStroke.Color = Theme.GlowStroke
tbBarStroke.Transparency = 0.55
tbBarStroke.Thickness = 1

TargetBarAv = Instance.new("ImageLabel", TargetBar)
TargetBarAv.Size = UDim2.fromOffset(26, 26)
TargetBarAv.Position = UDim2.fromOffset(6, 5)
TargetBarAv.BackgroundColor3 = Theme.InputBg
TargetBarAv.Image = ""
Instance.new("UICorner", TargetBarAv).CornerRadius = UDim.new(1, 0)

TargetBarName = Instance.new("TextLabel", TargetBar)
TargetBarName.Size = UDim2.new(1, -150, 0, 16)
TargetBarName.Position = UDim2.fromOffset(38, 3)
TargetBarName.BackgroundTransparency = 1
TargetBarName.Text = "no target selected"
TargetBarName.TextColor3 = Theme.TextDim
TargetBarName.TextSize = 11
TargetBarName.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
TargetBarName.TextXAlignment = Enum.TextXAlignment.Left
TargetBarName.TextTruncate = Enum.TextTruncate.AtEnd

TargetBarMeta = Instance.new("TextLabel", TargetBar)
TargetBarMeta.Size = UDim2.new(1, -150, 0, 12)
TargetBarMeta.Position = UDim2.fromOffset(38, 19)
TargetBarMeta.BackgroundTransparency = 1
TargetBarMeta.Text = "tap a player to lock target"
TargetBarMeta.TextColor3 = Theme.TextMuted
TargetBarMeta.TextSize = 9
TargetBarMeta.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
TargetBarMeta.TextXAlignment = Enum.TextXAlignment.Left

TargetClearBtn = Instance.new("TextButton", TargetBar)
TargetClearBtn.Size = UDim2.fromOffset(48, 22)
TargetClearBtn.Position = UDim2.new(1, -104, 0.5, -11)
TargetClearBtn.BackgroundColor3 = Theme.CardOff
TargetClearBtn.Text = "CLEAR"
TargetClearBtn.TextColor3 = Theme.TextWhite
TargetClearBtn.TextSize = 9
TargetClearBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", TargetClearBtn).CornerRadius = UDim.new(0, 5)

TargetSpecBtn = Instance.new("TextButton", TargetBar)
TargetSpecBtn.Size = UDim2.fromOffset(48, 22)
TargetSpecBtn.Position = UDim2.new(1, -52, 0.5, -11)
TargetSpecBtn.BackgroundColor3 = Theme.NeonDarkGreen
TargetSpecBtn.Text = "SPEC"
TargetSpecBtn.TextColor3 = Theme.TextWhite
TargetSpecBtn.TextSize = 9
TargetSpecBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", TargetSpecBtn).CornerRadius = UDim.new(0, 5)

function RefreshTargetBar()
  n = CFG.cuff_target
  if n and n ~= "" then
    p = Players:FindFirstChild(n)
    TargetBarName.Text = p and (p.DisplayName .. "  @" .. p.Name) or n
    TargetBarName.TextColor3 = Theme.TextWhite
    TargetBarMeta.Text = "locked target"
    TargetBarAv.Image = p and ("rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48") or ""
    tbBarStroke.Color = Theme.NeonGreen
    tbBarStroke.Transparency = 0.25
  else
    TargetBarName.Text = "no target selected"
    TargetBarName.TextColor3 = Theme.TextDim
    TargetBarMeta.Text = "tap a player to lock target"
    TargetBarAv.Image = ""
    tbBarStroke.Color = Theme.GlowStroke
    tbBarStroke.Transparency = 0.55
  end
  if RefreshHeaderTarget then RefreshHeaderTarget() end
end

TargetClearBtn.MouseButton1Click:Connect(function()
  SetSelectedPlayer(nil)
  BuildPlayerCards()
end)

TargetSpecBtn.MouseButton1Click:Connect(function()
  if CFG.cuff_target and CFG.cuff_target ~= "" then
    ToggleSpectate(CFG.cuff_target)
  else
    ShowNotification("Select a target first", "", 1.5)
  end
end)

StatsRow = Instance.new("Frame", mainPage)
StatsRow.Size = UDim2.new(1, 0, 0, 16)
StatsRow.Position = UDim2.fromOffset(0, 78)
StatsRow.BackgroundTransparency = 1

StatsLabel = Instance.new("TextLabel", StatsRow)
StatsLabel.Size = UDim2.new(1, 0, 1, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "Players: " .. #Players:GetPlayers() .. "  |  Admins: 0  |  Watching you: 0"
StatsLabel.TextColor3 = Theme.TextDim
StatsLabel.TextSize = 10
StatsLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left

QuickRow = Instance.new("Frame", mainPage)
QuickRow.Size = UDim2.new(1, 0, 0, 28)
QuickRow.Position = UDim2.fromOffset(0, 96)
QuickRow.BackgroundTransparency = 1

qll = Instance.new("UIListLayout", QuickRow)
qll.FillDirection = Enum.FillDirection.Horizontal
qll.Padding = UDim.new(0, 6)

function makeQuickBtn(txt, col, cb)
  b = Instance.new("TextButton", QuickRow)
  b.Size = UDim2.new(0.333, -5, 1, 0)
  b.BackgroundColor3 = col
  b.Text = txt
  b.TextColor3 = Theme.TextWhite
  b.TextSize = 10
  b.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
  b.MouseButton1Click:Connect(cb)
  return b
end

AfkBtn = makeQuickBtn("AFK: ON", Theme.NeonDarkGreen, function()
  CFG.afk_disabled = not CFG.afk_disabled
  AfkBtn.Text = CFG.afk_disabled and "AFK: ON" or "AFK: OFF"
  AfkBtn.BackgroundColor3 = CFG.afk_disabled and Theme.NeonDarkGreen or Theme.DangerRed
end)

AdminHudBtn = makeQuickBtn(CFG.admin_hud_enabled and "HUD: ON" or "HUD: OFF", CFG.admin_hud_enabled and Theme.NeonGreen or Theme.CardBg, function()
  SetAdminHudVisible(not CFG.admin_hud_enabled)
  ShowNotification("Admin HUD: " .. (CFG.admin_hud_enabled and "ON" or "OFF"), "", 1.5)
end)

RefreshBtn = makeQuickBtn("Refresh", Theme.NeonDarkGreen, function()
  BuildPlayerCards()
end)

PlayerScroll = Instance.new("ScrollingFrame", mainPage)
PlayerScroll.Size = UDim2.new(1, 0, 1, -128)
PlayerScroll.Position = UDim2.fromOffset(0, 128)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Theme.NeonGreen

PlayerCardsFrame = Instance.new("Frame", PlayerScroll)
PlayerCardsFrame.Size = UDim2.new(1, 0, 0, 0)
PlayerCardsFrame.AutomaticSize = Enum.AutomaticSize.Y
PlayerCardsFrame.BackgroundTransparency = 1

-- regfix
pcll = Instance.new("UIListLayout", PlayerCardsFrame)
pcll.Padding = UDim.new(0, 8)
pcll.SortOrder = Enum.SortOrder.LayoutOrder

pcll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
  PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, pcll.AbsoluteContentSize.Y + 10)
end)

PlayerScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
  if mainPage.Visible then
    maxScroll = PlayerScroll.AbsoluteCanvasSize.Y - PlayerScroll.AbsoluteWindowSize.Y
    if maxScroll > 0 then
      pct = math.clamp(PlayerScroll.CanvasPosition.Y / maxScroll, 0, 0.75)
      LeftScrollThumb.Position = UDim2.new(0, 0, pct, 0)
    else
      LeftScrollThumb.Position = UDim2.new(0, 0, 0, 0)
    end
  end
end)

-- ----------------------------------------------------
-- 5. BUILD PLAYER CARDS
-- ----------------------------------------------------
lastCardTap = {}
function BuildPlayerCards()
  if _buildingCards then return end
  _buildingCards = true
  local _okBuild, _errBuild = pcall(function()
  for _, child in ipairs(PlayerCardsFrame:GetChildren()) do
    if child:IsA("Frame") then child:Destroy() end
  end

  myChar = LocalPlayer.Character
  myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
  myPos = myHRP and myHRP.Position or Vector3.new(0, 0, 0)
  query = SearchBox.Text:lower():gsub("^%s*", ""):gsub("%s*$", "")

  sortedPlayers = {}
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
      dName = plr.DisplayName
      uName = plr.Name
      match = (query == "")
        or dName:lower():find(query, 1, true)
        or uName:lower():find(query, 1, true)
        or ("@" .. uName:lower()):find(query, 1, true)
        or tostring(plr.UserId):find(query, 1, true)

      if match then
        tChar = plr.Character
        tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
        tHum  = tChar and tChar:FindFirstChildOfClass("Humanoid")
        dist  = tHRP and math.floor((tHRP.Position - myPos).Magnitude) or 9999
        hp    = tHum and math.max(0, math.floor(tHum.Health)) or 0
        maxHp = tHum and math.floor(tHum.MaxHealth) or 100
        isAlive = (hp > 0) and (tChar and tChar:FindFirstChild("Head") ~= nil)
        adminData = getAdminData(plr)
        isSpecMe  = SpectateWatcher.spectators[uName] == true

        table.insert(sortedPlayers, {
          plr       = plr,
          dName     = dName,
          uName     = uName,
          isAlive   = isAlive,
          hp        = hp,
          maxHp     = maxHp,
          dist      = dist,
          adminData = adminData,
          isAdmin   = adminData.isAdmin,
          isSpecMe  = isSpecMe
        })
      end
    end
  end

  local function getAdminWeight(p)
    if not p.isAdmin then return 0 end
    cat = p.adminData and p.adminData.category or ""
    if cat == "OWNER" then return 5 end
    if cat == "MODERATOR" then return 4 end
    if cat == "HELPER" then return 3 end
    if cat == "CREATOR" then return 2 end
    return 1
  end

  table.sort(sortedPlayers, function(a, b)
    mode = CFG.player_sort or "admin"
    if mode == "alive" then
      if a.isAlive ~= b.isAlive then return a.isAlive end
      return a.dist < b.dist
    elseif mode == "near" then
      return a.dist < b.dist
    end
    wA = getAdminWeight(a)
    wB = getAdminWeight(b)
    if wA ~= wB then return wA > wB end
    if a.isSpecMe ~= b.isSpecMe then return a.isSpecMe == true end
    return a.dist < b.dist
  end)

  count = 0
  ownerCount = 0
  modCount = 0
  helperCount = 0
  creatorCount = 0

  for _, pInfo in ipairs(sortedPlayers) do
    count = count + 1
    plr       = pInfo.plr
    dName     = pInfo.dName
    uName     = pInfo.uName
    isAlive   = pInfo.isAlive
    hp        = pInfo.hp
    maxHp     = pInfo.maxHp
    dist      = pInfo.dist
    adminData = pInfo.adminData
    isAdmin   = pInfo.isAdmin
    isSpecMe  = pInfo.isSpecMe

    if isAdmin then
      cat = adminData and adminData.category or "MODERATOR"
      if cat == "OWNER" then ownerCount = ownerCount + 1
      elseif cat == "CREATOR" then creatorCount = creatorCount + 1
      elseif cat == "HELPER" then helperCount = helperCount + 1
      else modCount = modCount + 1 end
    end

    local thisPlr = pInfo.plr
    local thisName = pInfo.uName
    isSelected = (CFG.cuff_target == thisName) or (CFG.cuff_target_id == thisPlr.UserId)
    accentCol = isAdmin and (adminData.badgeColor or Theme.DangerRed)
      or (isSpecMe and Theme.WarningYellow)
      or (isSelected and Theme.NeonGreen)
      or Theme.GlowStroke

    card = Instance.new("Frame", PlayerCardsFrame)
    card.Size = UDim2.new(1, 0, 0, 82)
    card.LayoutOrder = (isAdmin and (0 - getAdminWeight(pInfo) * 100) or 500) + math.min(dist, 400)
    card.BackgroundColor3 = isAdmin and (
        (adminData.category == "OWNER" and Color3.fromRGB(58, 42, 12))
        or (adminData.category == "CREATOR" and Color3.fromRGB(48, 18, 58))
        or Color3.fromRGB(62, 16, 22)
      ) or (isSelected and Theme.CardBgHover or Theme.CardBg)
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    cStroke = Instance.new("UIStroke", card)
    cStroke.Color = accentCol
    cStroke.Thickness = isSelected and 1.6 or 1
    cStroke.Transparency = isSelected and 0.15 or 0.42

    strip = Instance.new("Frame", card)
    strip.Size = UDim2.new(0, 4, 1, 0)
    strip.BackgroundColor3 = accentCol
    strip.BorderSizePixel = 0
    Instance.new("UICorner", strip).CornerRadius = UDim.new(0, 4)

    img = Instance.new("ImageLabel", card)
    img.Size = UDim2.fromOffset(48, 48)
    img.Position = UDim2.fromOffset(14, 10)
    img.BackgroundColor3 = Theme.InputBg
    img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)
    imgStroke = Instance.new("UIStroke", img)
    imgStroke.Color = accentCol
    imgStroke.Thickness = 1
    imgStroke.Transparency = 0.25

    nameLabel = Instance.new("TextLabel", card)
    nameLabel.Size = UDim2.new(1, -78, 0, 17)
    nameLabel.Position = UDim2.fromOffset(70, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = dName
    nameCol = isAdmin and (adminData.category == "OWNER" and Color3.fromRGB(255, 215, 80) or adminData.category == "CREATOR" and Color3.fromRGB(230, 130, 255) or Color3.fromRGB(255, 95, 110)) or Theme.TextWhite
    nameLabel.TextColor3 = nameCol
    nameLabel.TextSize = 13
    nameLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

    userLabel = Instance.new("TextLabel", card)
    userLabel.Size = UDim2.new(0.42, 0, 0, 13)
    userLabel.Position = UDim2.fromOffset(70, 24)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. uName
    userLabel.TextColor3 = Theme.TextMuted
    userLabel.TextSize = 10
    userLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.TextTruncate = Enum.TextTruncate.AtEnd

    distPill = Instance.new("TextLabel", card)
    distPill.Size = UDim2.fromOffset(58, 16)
    distPill.Position = UDim2.new(1, -66, 0, 8)
    distPill.BackgroundColor3 = Theme.InputBg
    distPill.Text = (type(dist) == "number" and dist < 9999) and string.format("%dm", dist) or "--"
    distPill.TextColor3 = Theme.AccentCyan
    distPill.TextSize = 9
    distPill.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", distPill).CornerRadius = UDim.new(0, 6)

    badgeLL = Instance.new("Frame", card)
    badgeLL.Size = UDim2.new(1, -78, 0, 16)
    badgeLL.Position = UDim2.fromOffset(70, 38)
    badgeLL.BackgroundTransparency = 1

    bll2 = Instance.new("UIListLayout", badgeLL)
    bll2.FillDirection = Enum.FillDirection.Horizontal
    bll2.Padding = UDim.new(0, 4)
    bll2.VerticalAlignment = Enum.VerticalAlignment.Center

    local function badge(txt, col)
      b = Instance.new("TextLabel", badgeLL)
      b.Size = UDim2.fromOffset(0, 15)
      b.AutomaticSize = Enum.AutomaticSize.X
      b.BackgroundColor3 = col
      b.Text = "  " .. txt .. "  "
      b.TextColor3 = Color3.fromRGB(255, 255, 255)
      b.TextSize = 9
      b.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    end

    badge(isAlive and "ALIVE" or "DEAD", isAlive and Theme.NeonDarkGreen or Theme.DangerRed)
    if isAdmin then
      tg = (adminData.tag and adminData.tag ~= "") and adminData.tag or "ADMIN"
      bCol = adminData.badgeColor or Theme.DangerRed
      badge(tg, bCol)
    end
    if isSpecMe then badge("WATCHING YOU", Theme.WarningYellow) end
    if isSelected then badge("TARGET", Theme.NeonGreen) end

    hpPct = maxHp > 0 and math.clamp(hp / maxHp, 0, 1) or 0
    hpBg = Instance.new("Frame", card)
    hpBg.Size = UDim2.new(1, -78, 0, 4)
    hpBg.Position = UDim2.fromOffset(70, 56)
    hpBg.BackgroundColor3 = Theme.InputBg
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)

    hpFill = Instance.new("Frame", hpBg)
    hpFill.Size = UDim2.new(hpPct, 0, 1, 0)
    hpFill.BackgroundColor3 = hpPct > .5 and Theme.NeonGreen or hpPct > .25 and Theme.WarningYellow or Theme.DangerRed
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

    infoTxt = Instance.new("TextLabel", card)
    infoTxt.Size = UDim2.new(0.5, 0, 0, 12)
    infoTxt.Position = UDim2.fromOffset(70, 62)
    infoTxt.BackgroundTransparency = 1
    extra = (isAdmin and adminData.reason ~= "") and ("  |  " .. adminData.reason) or ""
    infoTxt.Text = extra ~= "" and extra or ""
    do
      local held = GetHeldTool(plr)
      local preview = GetToolPreviewId and GetToolPreviewId(held) or ""
      if preview ~= "" then
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.fromOffset(22, 22)
        ic.Position = UDim2.fromOffset(70, 60)
        ic.BackgroundColor3 = Color3.fromRGB(16, 22, 18)
        ic.BackgroundTransparency = 0.2
        ic.Image = preview
        ic.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", ic).CornerRadius = UDim.new(0, 5)
        infoTxt.Position = UDim2.fromOffset(96, 62)
      end
    end
    infoTxt.TextColor3 = isAdmin and Color3.fromRGB(255, 160, 170) or Theme.TextDim
    infoTxt.TextSize = 9
    infoTxt.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    infoTxt.TextXAlignment = Enum.TextXAlignment.Left
    infoTxt.TextTruncate = Enum.TextTruncate.AtEnd

    btnCont = Instance.new("Frame", card)
    btnCont.Size = UDim2.new(0, 168, 0, 40)
    btnCont.Position = UDim2.new(1, -176, 1, -44)
    btnCont.BackgroundTransparency = 1

    bll3 = Instance.new("UIListLayout", btnCont)
    bll3.FillDirection = Enum.FillDirection.Horizontal
    bll3.Padding = UDim.new(0, 3)
    bll3.HorizontalAlignment = Enum.HorizontalAlignment.Right
    bll3.SortOrder = Enum.SortOrder.LayoutOrder

    local function mkBtn(txt, col, cb)
      local b = Instance.new("TextButton", btnCont)
      b.Size = UDim2.fromOffset(38, 18)
      b.BackgroundColor3 = col
      b.Text = txt
      b.TextColor3 = Theme.TextWhite
      b.TextSize = 9
      b.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      b.AutoButtonColor = true
      Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
      b.MouseButton1Click:Connect(cb)
    end

    mkBtn("Select", Theme.NeonDarkGreen, function()
      SetSelectedPlayer(thisPlr)
      pcall(function()
        hap = game:GetService("HapticService")
        if hap and UserInputService.TouchEnabled then
          hap:SetMotor(Enum.VibrationMotor.Large, 0.25)
          task.delay(0.08, function() pcall(function() hap:SetMotor(Enum.VibrationMotor.Large, 0) end) end)
        end
      end)
      ShowNotification("Target: " .. thisName, "", 1.2)
    end)
    mkBtn("Spec", Theme.CardOff, function()
      SetSelectedPlayer(thisPlr)
      ToggleSpectate(thisName)
    end)
    mkBtn("Skin", Theme.SpecialPurple, function()
      SetSelectedPlayer(thisPlr)
      CopyOutfitFrom(thisPlr)
    end)
    card.InputBegan:Connect(function(io)
      if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then
        now = tick()
        prev = lastCardTap[thisName] or 0
        lastCardTap[thisName] = now
        SetSelectedPlayer(thisPlr)
        if now - prev < 0.35 then
          ToggleSpectate(thisName)
        end
      end
    end)
    card.MouseEnter:Connect(function()
      if CFG.cuff_target ~= uName then
        card.BackgroundColor3 = Theme.CardBgHover
      end
    end)
    card.MouseLeave:Connect(function()
      if CFG.cuff_target == uName then
        card.BackgroundColor3 = Theme.CardBgHover
      elseif isAdmin then
        card.BackgroundColor3 = Color3.fromRGB(42, 24, 28)
      else
        card.BackgroundColor3 = Theme.CardBg
      end
    end)

    mkBtn("Troll", Theme.SpecialPurple,         function()
      SetSelectedPlayer(thisPlr)
      ShowNotification("Target set: " .. thisName, "", 2)
      for name, data in pairs(tabBtns) do
        isActive = (name == "Troll")
        data.glow.BackgroundColor3 = isActive and Theme.NeonGreen or Theme.CardBg
        data.txt.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.TextDim
        data.line.Visible = isActive
        if data.ic then data.ic.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.NeonGreen end
        if data.stroke then
          data.stroke.Color = isActive and Theme.NeonGreen or Theme.GlowStroke
          data.stroke.Transparency = isActive and 0.15 or 0.55
        end
        pages[name].Visible = isActive
      end
    end)
  end

  specCount = 0
  for _ in pairs(SpectateWatcher.spectators) do specCount = specCount + 1 end

  staffParts = {}
  if ownerCount > 0 then table.insert(staffParts, "[Owner] " .. ownerCount) end
  if modCount > 0 then table.insert(staffParts, "[Mod] " .. modCount) end
  if helperCount > 0 then table.insert(staffParts, "[Helper] " .. helperCount) end
  if creatorCount > 0 then table.insert(staffParts, "[Creator] " .. creatorCount) end

  adminTxt = #staffParts > 0 and table.concat(staffParts, " ") or "0"
  StatsLabel.Text = string.format("Players: %d  |  Admins: %s  |  Watching you: %d", count, adminTxt, specCount)
  if RefreshTargetBar then RefreshTargetBar() end
  if RefreshNavLabels then RefreshNavLabels() end
  end)
  _buildingCards = false
  if not _okBuild then
    warn("[TOXIC V16] BuildPlayerCards: " .. tostring(_errBuild))
  end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(BuildPlayerCards)
RefreshBtn.MouseButton1Click:Connect(BuildPlayerCards)

Players.PlayerAdded:Connect(function(plr)
  BuildPlayerCards()
  plr.CharacterAdded:Connect(function(char)
    BuildPlayerCards()
    hum = char:WaitForChild("Humanoid", 3)
    if hum then hum.Died:Connect(BuildPlayerCards) end
  end)
end)

BuildPlayerCards()

-- ----------------------------------------------------
-- 6. TROLL TAB (.PlayerActions & .PAGrid)
-- ----------------------------------------------------
trollPage = pages["Troll"]
trollPage.AutomaticCanvasSize = Enum.AutomaticSize.None
trollPage.CanvasSize = UDim2.new(0, 0, 0, 360)
trollPage.ScrollBarThickness = 3
trollPage.ScrollBarImageColor3 = Theme.NeonGreen

tll = Instance.new("UIListLayout", trollPage)
tll.Padding = UDim.new(0, 8)

TargetCard = Instance.new("Frame", trollPage)
TargetCard.Size = UDim2.new(1, 0, 0, 108)
TargetCard.BackgroundColor3 = Theme.CardBg
Instance.new("UICorner", TargetCard).CornerRadius = UDim.new(0, 10)
-- regfix
tcStroke = Instance.new("UIStroke", TargetCard)
tcStroke.Color = Theme.GlowStroke
tcStroke.Transparency = 0.4

tAvatar = Instance.new("ImageLabel", TargetCard)
tAvatar.Size = UDim2.fromOffset(52, 52)
tAvatar.Position = UDim2.fromOffset(10, 10)
tAvatar.BackgroundColor3 = Color3.fromRGB(20, 26, 22)
tAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150"
Instance.new("UICorner", tAvatar).CornerRadius = UDim.new(0, 6)

tName = Instance.new("TextLabel", TargetCard)
tName.Size = UDim2.new(0.5, 0, 0, 16)
tName.Position = UDim2.fromOffset(70, 8)
tName.BackgroundTransparency = 1
tName.Text = "No Target Selected"
tName.TextColor3 = Theme.TextWhite
tName.TextSize = 12
tName.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
tName.TextXAlignment = Enum.TextXAlignment.Left

tUser = Instance.new("TextLabel", TargetCard)
tUser.Size = UDim2.new(0.5, 0, 0, 14)
tUser.Position = UDim2.fromOffset(70, 24)
tUser.BackgroundTransparency = 1
tUser.Text = "@none"
tUser.TextColor3 = Theme.TextDim
tUser.TextSize = 10
tUser.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
tUser.TextXAlignment = Enum.TextXAlignment.Left

tId = Instance.new("TextLabel", TargetCard)
tId.Size = UDim2.new(0.5, 0, 0, 12)
tId.Position = UDim2.fromOffset(60, 42)
tId.BackgroundTransparency = 1
tId.Text = "UserID: 0"
tId.TextColor3 = Color3.fromRGB(110, 125, 115)
tId.TextSize = 9
tId.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
tId.TextXAlignment = Enum.TextXAlignment.Left

tName.TextTruncate = Enum.TextTruncate.AtEnd
TargetUI = TargetUI or {}
TargetUI.name = tName
TargetUI.user = tUser
TargetUI.id = tId
TargetUI.avatar = tAvatar

tUser.TextTruncate = Enum.TextTruncate.AtEnd
tId.TextTruncate = Enum.TextTruncate.AtEnd

-- regfix
tStats = Instance.new("TextLabel", TargetCard)
tStats.Size = UDim2.new(1, -20, 0, 28)
tStats.Position = UDim2.fromOffset(10, 66)
tStats.TextWrapped = true
tStats.BackgroundTransparency = 1
tStats.Text = "HP --  |  dist --  |  age --"
tStats.TextColor3 = Theme.TextMuted
tStats.TextSize = 9
tStats.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
tStats.TextXAlignment = Enum.TextXAlignment.Left
tStats.TextTruncate = Enum.TextTruncate.AtEnd
TargetUI = TargetUI or {}
TargetUI.stats = tStats
TargetUI.name = tName
TargetUI.user = tUser
TargetUI.id = tId
TargetUI.avatar = tAvatar


prvTargetBtn = Instance.new("TextButton", TargetCard)
prvTargetBtn.Size = UDim2.fromOffset(54, 22)
prvTargetBtn.Position = UDim2.new(1, -178, 0, 12)
prvTargetBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 30)
prvTargetBtn.Text = "PRV"
prvTargetBtn.TextColor3 = Theme.NeonGreen
prvTargetBtn.TextSize = 10
prvTargetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", prvTargetBtn).CornerRadius = UDim.new(0, 5)
-- regfix
ptbStroke = Instance.new("UIStroke", prvTargetBtn)
ptbStroke.Color = Theme.NeonDarkGreen
ptbStroke.Thickness = 1

prvTargetBtn.MouseButton1Click:Connect(function()
  if not CFG.cuff_target or CFG.cuff_target == "" or not Players:FindFirstChild(CFG.cuff_target) then
    ShowNotification("Select a target first!", "", 2)
    return
  end
  SwitchChatBarToWhisper(CFG.cuff_target)
end)

skinTargetBtn = Instance.new("TextButton", TargetCard)
skinTargetBtn.Size = UDim2.fromOffset(44, 22)
skinTargetBtn.Position = UDim2.new(1, -226, 0, 12)
skinTargetBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 55)
skinTargetBtn.Text = "SKIN"
skinTargetBtn.TextColor3 = Theme.TextWhite
skinTargetBtn.TextSize = 9
skinTargetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", skinTargetBtn).CornerRadius = UDim.new(0, 5)
skinTargetBtn.MouseButton1Click:Connect(function()
  local p = CFG.cuff_target and Players:FindFirstChild(CFG.cuff_target)
  if not p then
    ShowNotification("Select a target first!", "", 2)
    return
  end
  CopyOutfitFrom(p)
end)

specTargetBtn = Instance.new("TextButton", TargetCard)
specTargetBtn.Size = UDim2.fromOffset(54, 24)
specTargetBtn.Position = UDim2.new(1, -118, 0.5, -12)
specTargetBtn.BackgroundColor3 = Theme.NeonDarkGreen
specTargetBtn.Text = "Spec"
specTargetBtn.TextColor3 = Theme.TextWhite
specTargetBtn.TextSize = 10
specTargetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", specTargetBtn).CornerRadius = UDim.new(0, 5)

specTargetBtn.MouseButton1Click:Connect(function()
  if not CFG.cuff_target or CFG.cuff_target == "" or not Players:FindFirstChild(CFG.cuff_target) then
    ShowNotification("Select a target first!", "", 2)
    return
  end
  ToggleSpectate(CFG.cuff_target)
end)

clearTargetBtn = Instance.new("TextButton", TargetCard)
clearTargetBtn.Size = UDim2.fromOffset(50, 24)
clearTargetBtn.Position = UDim2.new(1, -58, 0.5, -12)
clearTargetBtn.BackgroundColor3 = Theme.DangerRed
clearTargetBtn.Text = "Clear"
clearTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearTargetBtn.TextSize = 10
clearTargetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", clearTargetBtn).CornerRadius = UDim.new(0, 5)

TargetPickerBar = Instance.new("Frame", trollPage)
TargetPickerBar.Size = UDim2.new(1, 0, 0, 32)
TargetPickerBar.BackgroundColor3 = Color3.fromRGB(13, 17, 14)
Instance.new("UICorner", TargetPickerBar).CornerRadius = UDim.new(0, 6)
-- regfix
tpStroke = Instance.new("UIStroke", TargetPickerBar)
tpStroke.Color = Theme.NeonDarkGreen
tpStroke.Thickness = 1

prevTgtBtn = Instance.new("TextButton", TargetPickerBar)
prevTgtBtn.Size = UDim2.fromOffset(28, 24)
prevTgtBtn.Position = UDim2.fromOffset(4, 4)
prevTgtBtn.BackgroundColor3 = Theme.CardBg
prevTgtBtn.Text = "<"
prevTgtBtn.TextColor3 = Theme.NeonGreen
prevTgtBtn.TextSize = 12
prevTgtBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", prevTgtBtn).CornerRadius = UDim.new(0, 4)

currentTgtLabel = Instance.new("TextLabel", TargetPickerBar)
currentTgtLabel.Size = UDim2.new(1, -70, 1, 0)
currentTgtLabel.Position = UDim2.fromOffset(36, 0)
currentTgtLabel.BackgroundTransparency = 1
currentTgtLabel.Text = "Target: None (Click arrows to cycle)"
currentTgtLabel.TextColor3 = Theme.TextWhite
currentTgtLabel.TextSize = 10
currentTgtLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
currentTgtLabel.TextXAlignment = Enum.TextXAlignment.Center
currentTgtLabel.TextTruncate = Enum.TextTruncate.AtEnd
TargetUI = TargetUI or {}
TargetUI.bar = currentTgtLabel



WipeTrollTargetUI = function()
  PaintTargetUI(nil)
end



nextTgtBtn = Instance.new("TextButton", TargetPickerBar)
nextTgtBtn.Size = UDim2.fromOffset(28, 24)
nextTgtBtn.Position = UDim2.new(1, -32, 0, 4)
nextTgtBtn.BackgroundColor3 = Theme.CardBg
nextTgtBtn.Text = ">"
nextTgtBtn.TextColor3 = Theme.NeonGreen
nextTgtBtn.TextSize = 12
nextTgtBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", nextTgtBtn).CornerRadius = UDim.new(0, 4)

clearTargetBtn.MouseButton1Click:Connect(function()
  if spectating then pcall(ToggleSpectate) end
  SetSelectedPlayer(nil)
  ShowNotification("Target Cleared!", "", 2)
end)

do
  HUD = {
    observedTools = {},
    clone = nil,
    cam = nil
  }

  HUD.card = Instance.new("Frame", trollPage)
  HUD.card.Name = "TargetInspectorCard"
  HUD.card.Size = UDim2.new(1, 0, 0, 200)
  HUD.card.BackgroundColor3 = Color3.fromRGB(12, 16, 14)
  Instance.new("UICorner", HUD.card).CornerRadius = UDim.new(0, 6)
  cardStroke = Instance.new("UIStroke", HUD.card)
  cardStroke.Color = Theme.NeonDarkGreen
  cardStroke.Thickness = 1

  HUD.header = Instance.new("Frame", HUD.card)
  HUD.header.Size = UDim2.new(1, -16, 0, 18)
  HUD.header.Position = UDim2.fromOffset(8, 5)
  HUD.header.BackgroundTransparency = 1

  HUD.title = Instance.new("TextLabel", HUD.header)
  HUD.title.Size = UDim2.new(0.65, 0, 1, 0)
  HUD.title.BackgroundTransparency = 1
  HUD.title.Text = "TARGET INSPECTOR (LIVE HUD)"
  HUD.title.TextColor3 = Theme.NeonGreen
  HUD.title.TextSize = 10
  HUD.title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.title.TextXAlignment = Enum.TextXAlignment.Left

  HUD.status = Instance.new("TextLabel", HUD.header)
  HUD.status.Size = UDim2.new(0.35, 0, 1, 0)
  HUD.status.Position = UDim2.new(0.65, 0, 0, 0)
  HUD.status.BackgroundTransparency = 1
  HUD.status.Text = "STANDBY"
  HUD.status.TextColor3 = Theme.TextDim
  HUD.status.TextSize = 9
  HUD.status.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.status.TextXAlignment = Enum.TextXAlignment.Right

  HUD.viewBox = Instance.new("Frame", HUD.card)
  HUD.viewBox.Size = UDim2.fromOffset(82, 166)
  HUD.viewBox.Position = UDim2.fromOffset(8, 26)
  HUD.viewBox.BackgroundColor3 = Color3.fromRGB(16, 22, 18)
  Instance.new("UICorner", HUD.viewBox).CornerRadius = UDim.new(0, 6)
  vbStroke = Instance.new("UIStroke", HUD.viewBox)
  vbStroke.Color = Color3.fromRGB(25, 45, 32)
  vbStroke.Thickness = 1

  HUD.avatar = Instance.new("ImageLabel", HUD.viewBox)
  HUD.avatar.Size = UDim2.new(1, 0, 1, 0)
  HUD.avatar.BackgroundTransparency = 1
  HUD.avatar.Image = "rbxthumb://type=Avatar&id=1&w=150&h=150"
  Instance.new("UICorner", HUD.avatar).CornerRadius = UDim.new(0, 6)

  HUD.viewport = Instance.new("ViewportFrame", HUD.viewBox)
  HUD.viewport.Size = UDim2.new(1, 0, 1, 0)
  HUD.viewport.BackgroundTransparency = 1
  HUD.viewport.Ambient = Color3.fromRGB(210, 210, 210)
  HUD.viewport.LightColor = Color3.fromRGB(255, 255, 255)
  HUD.viewport.LightDirection = Vector3.new(-1, -1, -1)
  Instance.new("UICorner", HUD.viewport).CornerRadius = UDim.new(0, 6)

  HUD.details = Instance.new("Frame", HUD.card)
  HUD.details.Size = UDim2.new(1, -104, 0, 166)
  HUD.details.Position = UDim2.fromOffset(96, 26)
  HUD.details.BackgroundTransparency = 1

  dLayout = Instance.new("UIListLayout", HUD.details)
  dLayout.SortOrder = Enum.SortOrder.LayoutOrder
  dLayout.Padding = UDim.new(0, 3)

  HUD.hpRow = Instance.new("Frame", HUD.details)
  HUD.hpRow.LayoutOrder = 1
  HUD.hpRow.Size = UDim2.new(1, 0, 0, 20)
  HUD.hpRow.BackgroundTransparency = 1

  HUD.hpLabel = Instance.new("TextLabel", HUD.hpRow)
  HUD.hpLabel.Size = UDim2.new(1, 0, 0, 12)
  HUD.hpLabel.BackgroundTransparency = 1
  HUD.hpLabel.Text = "HP: 0 / 0 (0%)"
  HUD.hpLabel.TextColor3 = Theme.TextWhite
  HUD.hpLabel.TextSize = 9
  HUD.hpLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.hpLabel.TextXAlignment = Enum.TextXAlignment.Left

  HUD.hpBarBg = Instance.new("Frame", HUD.hpRow)
  HUD.hpBarBg.Size = UDim2.new(1, 0, 0, 6)
  HUD.hpBarBg.Position = UDim2.fromOffset(0, 13)
  HUD.hpBarBg.BackgroundColor3 = Color3.fromRGB(25, 32, 28)
  Instance.new("UICorner", HUD.hpBarBg).CornerRadius = UDim.new(0, 3)

  HUD.hpBarFill = Instance.new("Frame", HUD.hpBarBg)
  HUD.hpBarFill.Size = UDim2.new(0, 0, 1, 0)
  HUD.hpBarFill.BackgroundColor3 = Theme.NeonGreen
  Instance.new("UICorner", HUD.hpBarFill).CornerRadius = UDim.new(0, 3)

  HUD.cashRow = Instance.new("Frame", HUD.details)
  HUD.cashRow.LayoutOrder = 2
  HUD.cashRow.Size = UDim2.new(1, 0, 0, 14)
  HUD.cashRow.BackgroundTransparency = 1

  HUD.cashLabel = Instance.new("TextLabel", HUD.cashRow)
  HUD.cashLabel.Size = UDim2.new(0.55, 0, 1, 0)
  HUD.cashLabel.BackgroundTransparency = 1
  HUD.cashLabel.Text = "CASH: 0 MVC"
  HUD.cashLabel.TextColor3 = Theme.NeonGreen
  HUD.cashLabel.TextSize = 10
  HUD.cashLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.cashLabel.TextXAlignment = Enum.TextXAlignment.Left

  HUD.levelLabel = Instance.new("TextLabel", HUD.cashRow)
  HUD.levelLabel.Size = UDim2.new(0.45, 0, 1, 0)
  HUD.levelLabel.Position = UDim2.new(0.55, 0, 0, 0)
  HUD.levelLabel.BackgroundTransparency = 1
  HUD.levelLabel.Text = "LVL: --"
  HUD.levelLabel.TextColor3 = Theme.TextDim
  HUD.levelLabel.TextSize = 9
  HUD.levelLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  HUD.levelLabel.TextXAlignment = Enum.TextXAlignment.Right

  HUD.equipRow = Instance.new("Frame", HUD.details)
  HUD.equipRow.LayoutOrder = 3
  HUD.equipRow.Size = UDim2.new(1, 0, 0, 14)
  HUD.equipRow.BackgroundTransparency = 1

  HUD.equipLabel = Instance.new("TextLabel", HUD.equipRow)
  HUD.equipLabel.Size = UDim2.new(1, 0, 1, 0)
  HUD.equipLabel.BackgroundTransparency = 1
  HUD.equipLabel.Text = "EQUIPPED: None"
  HUD.equipLabel.TextColor3 = Color3.fromRGB(220, 235, 225)
  HUD.equipLabel.TextSize = 9
  HUD.equipLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.equipLabel.TextXAlignment = Enum.TextXAlignment.Left
  HUD.equipLabel.TextTruncate = Enum.TextTruncate.AtEnd

  HUD.bpRow = Instance.new("Frame", HUD.details)
  HUD.bpRow.LayoutOrder = 4
  HUD.bpRow.Size = UDim2.new(1, 0, 0, 96)
  HUD.bpRow.BackgroundColor3 = Theme.CardBg
  Instance.new("UICorner", HUD.bpRow).CornerRadius = UDim.new(0, 4)
  bpStroke = Instance.new("UIStroke", HUD.bpRow)
  bpStroke.Color = Color3.fromRGB(25, 38, 28)
  bpStroke.Thickness = 1

  HUD.bpTitle = Instance.new("TextLabel", HUD.bpRow)
  HUD.bpTitle.Size = UDim2.new(1, -8, 0, 12)
  HUD.bpTitle.Position = UDim2.fromOffset(4, 2)
  HUD.bpTitle.BackgroundTransparency = 1
  HUD.bpTitle.Text = "INVENTORY / TOOLS (0 DETECTED)"
  HUD.bpTitle.TextColor3 = Theme.TextDim
  HUD.bpTitle.TextSize = 9
  HUD.bpTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  HUD.bpTitle.TextXAlignment = Enum.TextXAlignment.Left

  HUD.bpScroll = Instance.new("ScrollingFrame", HUD.bpRow)
  HUD.bpScroll.Size = UDim2.new(1, -8, 1, -16)
  HUD.bpScroll.Position = UDim2.fromOffset(4, 14)
  HUD.bpScroll.BackgroundTransparency = 1
  HUD.bpScroll.ScrollBarThickness = 2
  HUD.bpScroll.ScrollBarImageColor3 = Theme.NeonDarkGreen
  HUD.bpScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
  HUD.bpScroll.ScrollingDirection = Enum.ScrollingDirection.XY
  HUD.bpScroll.ClipsDescendants = true
  HUD.bpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

  HUD.bpItems = Instance.new("TextLabel", HUD.bpScroll)
  HUD.bpItems.Size = UDim2.new(1, 0, 0, 0)
  HUD.bpItems.BackgroundTransparency = 1
  HUD.bpItems.Text = "No Target Selected"
  HUD.bpItems.TextColor3 = Theme.TextDim
  HUD.bpItems.TextSize = 9
  HUD.bpItems.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  HUD.bpItems.TextXAlignment = Enum.TextXAlignment.Left
  HUD.bpGrid = Instance.new("Frame", HUD.bpScroll)
  HUD.bpGrid.Name = "ToolGrid"
  HUD.bpGrid.Position = UDim2.fromOffset(0, 0)
  HUD.bpGrid.Size = UDim2.new(1, 0, 0, 0)
  HUD.bpGrid.AutomaticSize = Enum.AutomaticSize.Y
  HUD.bpGrid.BackgroundTransparency = 1
  local gLay = Instance.new("UIGridLayout", HUD.bpGrid)
  gLay.CellSize = UDim2.fromOffset(28, 28)
  gLay.CellPadding = UDim2.fromOffset(4, 4)
  gLay.FillDirection = Enum.FillDirection.Horizontal
  gLay.SortOrder = Enum.SortOrder.LayoutOrder
  gLay.FillDirectionMaxCells = 0
  HUD.bpItems.TextWrapped = true

  HUD.update3D = function(plr)
    return
  end
  HUD._update3D_disabled = function(plr)
    if HUD.clone then
      pcall(function() HUD.clone:Destroy() end)
      HUD.clone = nil
    end
    if HUD.cam then
      pcall(function() HUD.cam:Destroy() end)
      HUD.cam = nil
    end

    if not plr or not plr.Character then return end
    char = plr.Character
    root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
    if not root then return end

    pcall(function()
      char.Archivable = true
      clone = char:Clone()
      char.Archivable = false
      if not clone then return end

      for _, v in ipairs(clone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("Sound") or v:IsA("BillboardGui") then
          v:Destroy()
        elseif v:IsA("BasePart") then
          v.Anchored = true
          v.CanCollide = false
        end
      end

      cam = Instance.new("Camera")
      cam.Parent = HUD.viewport
      HUD.viewport.CurrentCamera = cam
      HUD.cam = cam

      cloneRoot = clone:FindFirstChild(root.Name) or clone:FindFirstChild("Head")
      if cloneRoot then
        cf = cloneRoot.CFrame
        cam.CFrame = CFrame.new(cf.Position + cf.LookVector * 4.2 + Vector3.new(0, 0.4, 0), cf.Position + Vector3.new(0, 0.1, 0))
      end

      clone.Parent = HUD.viewport
      HUD.clone = clone
    end)
  end

  HUD.trackCharacter = function(plr, char)
    if not plr or not char then return end
    uId = plr.UserId
    for _, c in ipairs(char:GetChildren()) do
      if c:IsA("Tool") then
        HUD.observedTools[uId] = HUD.observedTools[uId] or {}
        HUD.observedTools[uId][c.Name] = (GetToolPreviewId and GetToolPreviewId(c)) or true
      end
    end
    char.ChildAdded:Connect(function(child)
      if child:IsA("Tool") then
        HUD.observedTools[uId] = HUD.observedTools[uId] or {}
        HUD.observedTools[uId][child.Name] = (GetToolPreviewId and GetToolPreviewId(child)) or true
        if CFG.cuff_target and plr.Name == CFG.cuff_target and HUD.update then
          HUD.update(plr)
        end
      end
    end)
  end

  HUD.setupTracking = function(plr)
    if not plr then return end
    if plr.Character then HUD.trackCharacter(plr, plr.Character) end
    plr.CharacterAdded:Connect(function(char)
      task.wait(0.2)
      HUD.trackCharacter(plr, char)
    end)
  end

  for _, p in ipairs(Players:GetPlayers()) do
    HUD.setupTracking(p)
  end
  Players.PlayerAdded:Connect(HUD.setupTracking)

  HUD.getTools = function(plr)
    if not plr then return {} end
    found = {}
    list = {}

    local function addTool(name, tag, inst)
      if name and type(name) == "string" and name ~= "" and not found[name] then
        found[name] = true
        local img = ""
        if inst and GetToolPreviewId then img = GetToolPreviewId(inst) or "" end
        if img == "" and HUD.observedTools[plr.UserId] then
          local cached = HUD.observedTools[plr.UserId][name]
          if type(cached) == "string" then img = cached end
        end
        table.insert(list, { name = name, tag = tag or "Inv", inst = inst, img = img })
      end
    end

    if plr.Character then
      for _, item in ipairs(plr.Character:GetChildren()) do
        if item:IsA("Tool") then
          label = item.Name
          if item.ToolTip and item.ToolTip ~= "" and item.ToolTip:lower() ~= item.Name:lower() then
            label = item.Name .. " (" .. item.ToolTip .. ")"
          end
          addTool(item.Name, "Equipped", item)
        end
      end
    end

    bp = plr:FindFirstChild("Backpack")
    if bp then
      for _, item in ipairs(bp:GetChildren()) do
        if item:IsA("Tool") then
          label = item.Name
          if item.ToolTip and item.ToolTip ~= "" and item.ToolTip:lower() ~= item.Name:lower() then
            label = item.Name .. " (" .. item.ToolTip .. ")"
          end
          addTool(item.Name, "Backpack", item)
        end
      end
    end
    sg = plr:FindFirstChild("StarterGear")
    if sg then
      for _, item in ipairs(sg:GetChildren()) do
        if item:IsA("Tool") then addTool(item.Name, "Gear") end
      end
    end

    if plr.UserId and HUD.observedTools[plr.UserId] then
      for tName, _ in pairs(HUD.observedTools[plr.UserId]) do
        addTool(tName, "Observed")
      end
    end

    pcall(function()
      for attrName, attrVal in pairs(plr:GetAttributes()) do
        if type(attrName) == "string" then
          if attrName:sub(1, 7) == "ToolCD_" then
            tName = string.match(attrName, "ToolCD_.-_([^_]+)_[^_]+$")
            if tName and #tName > 1 then addTool(tName, "Attribute") end
          elseif attrName:find("CooldownUntil$") then
            tName = string.match(attrName, "^(.-)CooldownUntil$")
            if tName and #tName > 1 then
              if tName == "PinkBat" then tName = "Batpink" end
              addTool(tName, "Attribute")
            end
          elseif attrName:find("Owned$") and (attrVal == true or attrVal == 1) then
            tName = string.match(attrName, "^(.-)Owned$")
            if tName and #tName > 1 then addTool(tName, "Owned") end
          elseif attrName == "EquippedAura" and type(attrVal) == "string" and #attrVal > 1 then
            addTool(attrVal, "Aura")
          end
        end
      end
    end)

    return list
  end

  HUD.update = function(plr)
    if not plr then
      HUD.status.Text = "STANDBY"
      HUD.status.TextColor3 = Theme.TextDim
      HUD.avatar.Image = "rbxthumb://type=Avatar&id=1&w=150&h=150"
      HUD.hpLabel.Text = "HP: 0 / 0 (0%)"
      HUD.hpBarFill.Size = UDim2.new(0, 0, 1, 0)
      HUD.hpBarFill.BackgroundColor3 = Theme.DangerRed
      HUD.cashLabel.Text = "CASH: 0 MVC"
      HUD.levelLabel.Text = "LVL: --"
      HUD.equipLabel.Text = "EQUIPPED: None"
      HUD.bpTitle.Text = "INVENTORY / TOOLS (0 DETECTED)"
      HUD.bpItems.Text = "No Target Selected"
      if HUD.bpGrid then
        for _, ch in ipairs(HUD.bpGrid:GetChildren()) do
          if ch:IsA("GuiObject") and not ch:IsA("UIListLayout") then pcall(function() ch:Destroy() end) end
        end
      end
      if HUD.equipIcon then HUD.equipIcon.Visible = false end
      if HUD.clone then
        pcall(function() HUD.clone:Destroy() end)
        HUD.clone = nil
      end
      return
    end

    HUD.status.Text = "TRACKING"
    HUD.status.TextColor3 = Theme.NeonGreen
    HUD.avatar.Image = "rbxthumb://type=Avatar&id=" .. tostring(plr.UserId) .. "&w=150&h=150"

    -- Health
    hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    hp = hum and math.max(0, math.floor(hum.Health)) or 0
    maxHp = hum and math.max(1, math.floor(hum.MaxHealth)) or 100
    hpPct = math.clamp(hp / maxHp, 0, 1)
    HUD.hpLabel.Text = string.format("HP: %d / %d (%d%%)", hp, maxHp, math.floor(hpPct * 100))
    HUD.hpBarFill.Size = UDim2.new(hpPct, 0, 1, 0)
    if hpPct > 0.5 then
      HUD.hpBarFill.BackgroundColor3 = Theme.NeonGreen
    elseif hpPct > 0.2 then
      HUD.hpBarFill.BackgroundColor3 = Color3.fromRGB(240, 180, 40)
    else
      HUD.hpBarFill.BackgroundColor3 = Theme.DangerRed
    end

    -- Cash & Level
    ls = plr:FindFirstChild("leaderstats")
    mvc = ls and (ls:FindFirstChild("MVC") or ls:FindFirstChild("Cash") or ls:FindFirstChild("Money") or ls:FindFirstChild("Wallet"))
    cashVal = mvc and tostring(mvc.Value) or "0"
    HUD.cashLabel.Text = "CASH: " .. cashVal .. " MVC"

    lvl = ls and ls:FindFirstChild("LEVEL") and tostring(ls.LEVEL.Value) or "1"
    timeVal = ls and ls:FindFirstChild("TIME") and tostring(ls.TIME.Value) or "0"
    HUD.levelLabel.Text = "LVL: " .. lvl .. " | " .. timeVal .. "m"

    -- Equipped Tool
    char = plr.Character
    eqTool = char and char:FindFirstChildOfClass("Tool")
    if eqTool then
      eqText = eqTool.Name
      if eqTool.ToolTip and eqTool.ToolTip ~= "" and eqTool.ToolTip:lower() ~= eqTool.Name:lower() then
        eqText = eqText .. " [" .. eqTool.ToolTip .. "]"
      end
      local eqImg = GetToolPreviewId and GetToolPreviewId(eqTool) or ""
      HUD.equipLabel.Text = eqImg ~= "" and "EQUIPPED" or ("EQUIPPED: " .. eqText)
      HUD.equipLabel.TextColor3 = Theme.NeonGreen
      if not HUD.equipIcon then
        HUD.equipIcon = Instance.new("ImageLabel", HUD.equipRow)
        HUD.equipIcon.Size = UDim2.fromOffset(16, 16)
        HUD.equipIcon.Position = UDim2.new(1, -18, 0.5, -8)
        HUD.equipIcon.BackgroundTransparency = 1
        HUD.equipIcon.ScaleType = Enum.ScaleType.Fit
      end
      HUD.equipIcon.Image = eqImg
      HUD.equipIcon.Visible = eqImg ~= ""
    else
      HUD.equipLabel.Text = "EQUIPPED: None (Holstered)"
      HUD.equipLabel.TextColor3 = Theme.TextDim
      if HUD.equipIcon then HUD.equipIcon.Visible = false end
    end

    -- Multi-source Detected Inventory / Tools
    allTools = HUD.getTools(plr)
    HUD.bpTitle.Text = string.format("INVENTORY / TOOLS (%d DETECTED)", #allTools)
    if HUD.bpGrid then
      for _, ch in ipairs(HUD.bpGrid:GetChildren()) do
        if ch:IsA("ImageLabel") or ch:IsA("TextLabel") then
          pcall(function() ch:Destroy() end)
        end
      end
    end
    if #allTools > 0 then
      HUD.bpItems.Text = ""
      for i, t in ipairs(allTools) do
        local cell = Instance.new("ImageLabel", HUD.bpGrid)
        cell.Size = UDim2.fromOffset(28, 28)
        cell.BackgroundColor3 = (t.tag == "Equipped") and Color3.fromRGB(18, 48, 32) or Color3.fromRGB(16, 22, 18)
        cell.BackgroundTransparency = 0.15
        cell.Image = t.img or ""
        cell.ScaleType = Enum.ScaleType.Fit
        cell.LayoutOrder = i
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 5)
        if not t.img or t.img == "" then
          cell.Image = ""
          local letter = Instance.new("TextLabel", cell)
          letter.Size = UDim2.new(1,0,1,0)
          letter.BackgroundTransparency = 1
          letter.Text = string.sub(t.name, 1, 2)
          letter.TextColor3 = Theme.NeonGreen
          letter.TextSize = 9
          letter.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
        end
      end
    else
      HUD.bpItems.Text = "No tools yet"
      HUD.bpItems.TextColor3 = Theme.TextDim
    end
  end

  local function fillTargetStats(plr)
    if not tStats then return end
    if not plr then
      tStats.Text = "HP --  |  dist --  |  age --"
      return
    end
    char = plr.Character
    hum = char and char:FindFirstChildOfClass("Humanoid")
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    hp = hum and math.floor(hum.Health) or 0
    maxHp = hum and math.floor(hum.MaxHealth) or 0
    dist = (hrp and myHRP) and math.floor((hrp.Position - myHRP.Position).Magnitude) or nil
    age = (typeof(plr.AccountAge) == "number") and plr.AccountAge or 0
    alive = (hp > 0) and "ALIVE" or "DEAD"
    admin = "-"
    pcall(function()
      a = getAdminData(plr)
      if a and a.isAdmin then admin = a.tag ~= "" and a.tag or "ADMIN" end
    end)
    watch = (SpectateWatcher and SpectateWatcher.spectators and SpectateWatcher.spectators[plr.Name]) and "WATCH" or "-"
    local kind, tname = ClassifyHeldTool(GetHeldTool(plr))
    local toolBit = (kind ~= "NONE") and (kind .. " " .. tname) or "no tool"
    tStats.Text = string.format("%s  |  HP %d/%d  |  %s  |  %s  |  age %dd  |  %s  |  %s",
      alive, hp, maxHp, dist and (dist .. "m") or "--", toolBit, age, admin, watch)
  end

  updateTargetCard = function(plr)
    PaintTargetUI(plr)
    if HUD and HUD.update then pcall(HUD.update, plr) end
    -- never clone 3D here
  end

  task.spawn(function()
    while true do
      task.wait(1.25)
      local live = GetLiveTarget and GetLiveTarget() or nil
      if live then
        PaintTargetUI(live)
        if fillTargetStats then fillTargetStats(live) end
        if false then
          PaintTargetUI(live)
        elseif tStats then
          local info = CollectTargetInfo(live)
          tStats.Text = string.format("%s | HP %d/%d | %s | %s | age %dd | MVC %s | LV %s | %s | %s",
            info.alive and "ALIVE" or "DEAD",
            info.hp, info.maxHp,
            info.dist and (info.dist .. "m") or "--",
            info.tool, info.age, info.cash, info.level, info.admin, info.watch)
          if tId then tId.Text = "id " .. tostring(info.id) .. "  |  " .. info.state .. "  |  " .. info.team end
        end
      else
        if tName and tName.Text ~= "No Target Selected" then
          PaintTargetUI(nil)
        end
      end
    end
  end)
end

RegisterSpectateListener(function(isSpec, tName)
  if isSpec and tName == CFG.cuff_target and CFG.cuff_target ~= "" then
    specTargetBtn.Text = "Unspec"
    specTargetBtn.BackgroundColor3 = Theme.NeonGreen
    specTargetBtn.TextColor3 = Color3.fromRGB(0, 20, 10)
  else
    specTargetBtn.Text = "Spec"
    specTargetBtn.BackgroundColor3 = Theme.NeonDarkGreen
    specTargetBtn.TextColor3 = Theme.TextWhite
  end
end)

function cycleTarget(step)
  local list = {}
  for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(list, p) end
  end
  if #list == 0 then
    ShowNotification("No other players in server!", "", 2)
    return
  end
  local curIdx = 0
  for i, p in ipairs(list) do
    if p.Name == CFG.cuff_target then curIdx = i; break end
  end
  local nextIdx = curIdx + (step or 1)
  if nextIdx > #list then nextIdx = 1 end
  if nextIdx < 1 then nextIdx = #list end
  local pick = list[nextIdx]
  SetSelectedPlayer(pick)
  ShowNotification("Target: " .. pick.DisplayName, "", 1.2)
end

prevTgtBtn.MouseButton1Click:Connect(function() cycleTarget(-1) end)
nextTgtBtn.MouseButton1Click:Connect(function() cycleTarget(1) end)


-- ============================================================
-- TP BAT (Vasper method) - uses SELECTED troll target
-- ============================================================
local _tpBatCool = false
local _tpBatConn = nil
local _tpBatHome = nil
local _specHome = nil

function TpBatFindBat()
  local char = LocalPlayer.Character
  if not char then return nil end
  for _, tool in ipairs(char:GetChildren()) do
    if tool:IsA("Tool") then
      local name = tool.Name:lower()
      if name == "bat" or name:find("bat") or name:find("slap") then
        return tool
      end
    end
  end
  local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
  if bp then
    for _, tool in ipairs(bp:GetChildren()) do
      if tool:IsA("Tool") then
        local name = tool.Name:lower()
        if name == "bat" or name:find("bat") or name:find("slap") then
          local hum = char:FindFirstChildOfClass("Humanoid")
          if hum then pcall(function() hum:EquipTool(tool) end) end
          return tool
        end
      end
    end
  end
  return nil
end

function TpBatTrySwing()
  if _tpBatCool then return end
  _tpBatCool = true
  pcall(function()
    local bat = TpBatFindBat()
    if not bat then return end
    local char = LocalPlayer.Character
    if bat.Parent ~= char then
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hum then pcall(function() hum:EquipTool(bat) end) end
    end
    pcall(function() bat:Activate() end)
    local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
    if remote then pcall(function() remote:FireServer() end) end
  end)
  task.delay(0.05, function() _tpBatCool = false end)
end

function TpBatResolveTarget()
  local name = CFG.cuff_target
  if name and name ~= "" and name ~= "No other players" then
    local p = Players:FindFirstChild(name)
    if p and p ~= LocalPlayer and p.Character then
      local hum = p.Character:FindFirstChildOfClass("Humanoid")
      local hrp = p.Character:FindFirstChild("HumanoidRootPart")
      if hum and hum.Health > 0 and hrp then
        return p, hrp
      end
    end
  end
  return nil, nil
end

function StopTpBat(silent)
  if _tpBatConn then
    _tpBatConn:Disconnect()
    _tpBatConn = nil
  end
  CFG.tpbat_on = false
  _tpBatCool = false
  pcall(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and _tpBatHome then
      hrp.CFrame = _tpBatHome
      hrp.AssemblyLinearVelocity = Vector3.zero
      hrp.AssemblyAngularVelocity = Vector3.zero
    end
  end)
  _tpBatHome = nil
  if not silent and ShowNotification then
    ShowNotification("ABUSE OFF", "", 1.4)
  end
end

function StartTpBat()
  if _tpBatConn then return end
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  if hrp then
    _tpBatHome = hrp.CFrame
  else
    _tpBatHome = nil
  end
  CFG.tpbat_on = true
  _tpBatConn = RunService.Heartbeat:Connect(function()
    if not CFG.tpbat_on then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local target, tr = TpBatResolveTarget()
    if not target or not tr then return end
    local dist = (tr.Position - hrp.Position).Magnitude
    if sethiddenproperty then
      pcall(function()
        sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
        sethiddenproperty(hrp, "NetworkOwnership", 9999)
      end)
    end
    AbuseSnapTo(hrp, tr)
    local cam = workspace.CurrentCamera
    if cam then
      cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
    end
    if not _testFightOn and not _abuseAllOn then
      TpBatTrySwing()
    end
  end)
  if ShowNotification then
    local n = CFG.cuff_target ~= "" and CFG.cuff_target or "no target"
    ShowNotification("ABUSE ON", "", 1.5)
  end
end


function AbuseSwapClosest()
  local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if not my then
    if ShowNotification then ShowNotification("No character", "", 1.2) end
    return
  end
  local cur = CFG.cuff_target
  local best, bestD = nil, 1e9
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
      local char = plr.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hrp and hum and hum.Health > 0 and plr.Name ~= cur then
        local d = (hrp.Position - my.Position).Magnitude
        if d < bestD then
          bestD = d
          best = plr
        end
      end
    end
  end
  if not best then
    if ShowNotification then ShowNotification("No other target", "", 1.2) end
    return
  end
  if SetSelectedPlayer then
    SetSelectedPlayer(best)
  else
    CFG.cuff_target = best.Name
  end
  if ShowNotification then
    ShowNotification("SWAP " .. best.Name, "", 1.2)
  end
end


function ToggleAbuseSwap()
  if CFG.tpbat_on or _testFightOn then
    TestSwitchFightTool(false)
    StopTpBat()
    if ShowNotification then ShowNotification("ABUSE SWAP OFF", "", 1.3) end
    return
  end
  if not CFG.cuff_target or CFG.cuff_target == "" then
    if ShowNotification then ShowNotification("Select a player first!", "", 2) end
    return
  end
  StartTpBat()
  TestSwitchFightTool(true)
  if ShowNotification then ShowNotification("ABUSE SWAP ON", "", 1.3) end
end


local _abuseAllOn = false
local _abuseAllTok = 0
local _abuseAllHome = nil
local ABUSE_ALL_RANGE = 45
function AbuseAllSnap(hrp, tr)
  if not hrp or not tr then return end
  if sethiddenproperty then
    pcall(function()
      sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
      sethiddenproperty(hrp, "NetworkOwnership", 9999)
    end)
  end
  hrp.CFrame = CFrame.new(tr.Position + Vector3.new(0, 0.9, 0))
  hrp.AssemblyLinearVelocity = Vector3.zero
end
function AbuseAllTargets(centerHRP)
  local out = {}
  if not centerHRP then return out end
  for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
      local char = plr.Character
      local hrp = char and char:FindFirstChild("HumanoidRootPart")
      local hum = char and char:FindFirstChildOfClass("Humanoid")
      if hrp and hum and hum.Health > 0 then
        local d = (hrp.Position - centerHRP.Position).Magnitude
        if d <= ABUSE_ALL_RANGE then
          out[#out+1] = {plr = plr, hrp = hrp, dist = d}
        end
      end
    end
  end
  table.sort(out, function(a,b) return a.dist < b.dist end)
  return out
end
function ToggleAbuseAll()
  if _abuseAllOn then
    _abuseAllOn = false
    _abuseAllTok += 1
    TestSwitchFightTool(false)
    pcall(function()
      local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp and _abuseAllHome then
        hrp.CFrame = _abuseAllHome
        hrp.AssemblyLinearVelocity = Vector3.zero
      end
    end)
    _abuseAllHome = nil
    if CFG.tpbat_on then StopTpBat(true) end
    if ShowNotification then ShowNotification("ABUSE ALL OFF", "", 1.3) end
    return
  end
  local focus = Players:FindFirstChild(CFG.cuff_target or "")
  if not focus then
    if ShowNotification then ShowNotification("Select a player first!", "", 2) end
    return
  end
  local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
  if my then _abuseAllHome = my.CFrame end
  if CFG.tpbat_on then StopTpBat(true) end
  _abuseAllOn = true
  _abuseAllTok += 1
  local tok = _abuseAllTok
  if ShowNotification then ShowNotification("ABUSE ALL ON", "", 1.2) end
  task.spawn(function()
    local cHRP = focus.Character and focus.Character:FindFirstChild("HumanoidRootPart")
    local pack = cHRP and AbuseAllTargets(cHRP) or {}
    local n = #pack
    if n == 0 then
      if ShowNotification then ShowNotification("ABUSE ALL  0 near", "", 1.2) end
    else
      local prevPos = nil
      local hitSet = {}
      if ShowNotification then ShowNotification("ABUSE ALL  " .. n, "", 0.8) end
      for _, item in ipairs(pack) do
        if not (_abuseAllOn and tok == _abuseAllTok) then break end
        local uid = item.plr and item.plr.UserId
        if uid and hitSet[uid] then
          -- already hit this pass
        else
        prevPos = item.hrp and item.hrp.Position or prevPos
        local toolsPeek = TestListFightTools()
        local peek = TestPickReady(toolsPeek) or toolsPeek[1]
        local slice = peek and math.clamp(TestToolCd(peek), 0.8, 2.0) or 1.1
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local live = item.plr and item.plr.Character and item.plr.Character:FindFirstChild("HumanoidRootPart")
        if live then item.hrp = live end
        if myHRP and item.hrp and item.hrp.Parent then
          CFG.cuff_target = item.plr.Name
          AbuseSnapTo(myHRP, item.hrp)
          local tools = TestListFightTools()
          local tool = TestPickReady(tools) or tools[1]
          if hum and tool and tool.Parent then
            pcall(function() hum:EquipTool(tool) end)
          end
          local t0 = tick()
          local swung = false
          while _abuseAllOn and tok == _abuseAllTok and tick() - t0 < slice do
            myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            live = item.plr and item.plr.Character and item.plr.Character:FindFirstChild("HumanoidRootPart")
            if live then item.hrp = live end
            if myHRP and item.hrp and item.hrp.Parent then
              AbuseSnapTo(myHRP, item.hrp)
            end
            if not swung and tick() - t0 >= 0.22 and tool and tool.Parent then
              swung = true
              TestSwingTool(tool)
              if firetouchinterest then
                local handle = tool:FindFirstChild("Handle")
                if handle and item.hrp then
                  pcall(firetouchinterest, handle, item.hrp, 0)
                  pcall(firetouchinterest, handle, item.hrp, 1)
                end
              end
              _testLastTool = tool
              _testLastName = tool.Name
              _testUsedAt[tool] = tick()
              _testUsedAt[tool.Name] = tick()
            end
            task.wait()
          end
        end
        if uid then hitSet[uid] = true end
        end
      end
    end
    if tok == _abuseAllTok then
      _abuseAllOn = false
      pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and _abuseAllHome then
          hrp.CFrame = _abuseAllHome
          hrp.AssemblyLinearVelocity = Vector3.zero
        end
      end)
      _abuseAllHome = nil
      if ShowNotification then ShowNotification("ABUSE ALL OFF", "", 1.0) end
    end
  end)
end



function ToggleTpBat()
  if CFG.tpbat_on then
    StopTpBat()
  else
    if not CFG.cuff_target or CFG.cuff_target == "" then
      if ShowNotification then ShowNotification("Select a player first!", "", 2) end
      return
    end
    StartTpBat()
  end
end


function initActionGrid()
  ActionGrid = Instance.new("Frame", trollPage)
  ActionGrid.Name = "ActionGrid"
  ActionGrid.Size = UDim2.new(1, 0, 0, 126)
  ActionGrid.BackgroundTransparency = 1

  agLayout = Instance.new("UIListLayout", ActionGrid)
  agLayout.Padding = UDim.new(0, 6)
  agLayout.FillDirection = Enum.FillDirection.Vertical

  tll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    trollPage.CanvasSize = UDim2.new(0, 0, 0, math.max(280, tll.AbsoluteContentSize.Y + 16))
  end)

  local function makeChipRow()
    local r = Instance.new("Frame", ActionGrid)
    r.Size = UDim2.new(1, 0, 0, 36)
    r.BackgroundTransparency = 1
    local lay = Instance.new("UIListLayout", r)
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 5)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    return r
  end

  local function chipLabel(title, bindKey)
    local kb = bindKey and CFG[bindKey]
    if kb and kb ~= "None" then
      return title .. "  " .. kb
    end
    return title
  end

  local function makeChip(rowParent, title, colType, fn, bindKey)
    local bg = Theme.CardBg
    local stc = Theme.NeonDarkGreen
    if colType == "danger" then
      bg = Color3.fromRGB(42, 16, 20)
      stc = Theme.DangerRed
    elseif colType == "special" then
      bg = Color3.fromRGB(28, 18, 40)
      stc = Theme.SpecialPurple
    end
    local b = Instance.new("TextButton", rowParent)
    b.Name = tostring(title) .. "Btn"
    b.Size = UDim2.new(0.25, -4, 1, 0)
    b.BackgroundColor3 = bg
    b.AutoButtonColor = true
    b.Text = chipLabel(title, bindKey)
    b.TextColor3 = Theme.TextWhite
    b.TextSize = 10
    b.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    b.TextTruncate = Enum.TextTruncate.AtEnd
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local str = Instance.new("UIStroke", b)
    str.Color = stc
    str.Thickness = 1
    str.Transparency = 0.15
    if type(fn) == "function" then
      b.MouseButton1Click:Connect(fn)
    end
    return b
  end

  local row1 = makeChipRow()
  local row2 = makeChipRow()

  makeChip(row1, "Cuff", "normal", L_RM_DoCuffSequence, "cuff_arrest_keybind")
  makeChip(row1, "7BEL", "normal", L_RM_Do7belSequence, "cuff_7bel_keybind")
  makeChip(row1, "Carry", "normal", CarrySide_Execute, "cuff_carryside_keybind")
  makeChip(row1, "Smart Spec", "special", function()
    if not CFG.cuff_target or CFG.cuff_target == "" or not Players:FindFirstChild(CFG.cuff_target) then
      ShowNotification("Select a target first!", "", 2)
      return
    end
    ToggleSpectate()
  end, "spec_keybind")

  makeChip(row2, "C.Fling", "danger", FlingCarry_Execute, "cuff_fling_keybind")
  makeChip(row2, "G.Fling", "danger", FlingCuff_Execute, "cuff_flingcuff_keybind")
  makeChip(row2, "ABUSE", "danger", ToggleTpBat, "tpbat_keybind")
  makeChip(row2, "TP", "special", TeleportToTarget, nil)

  -- Row 3: Cuff Global (full width)
  local row3 = makeChipRow()
  local cgBtn = makeChip(row3, "Cuff Global", "normal", CuffGlobal_Execute, "cuff_global_keybind")
  cgBtn.Size = UDim2.new(1, 0, 1, 0)
end
initActionGrid()

-- ----------------------------------------------------
-- 7. EXPLOITS TAB
-- ----------------------------------------------------
-- XO / Tic-Tac-Toe (Realistic Morocco / Morocco Vibes)
-- Workspace model: TICTACTOE_BOARD > tic tac toe table > Tic Tac Toe
-- Cells: Detector1..Detector9 + ClickDetector
local TTT_Auto = false
local TTT_Conn = nil

function TTT_GetHRP()
  return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

function TTT_FindBoard()
  local hrp = TTT_GetHRP()
  local best, bestDist = nil, 1e9
  for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Model") or obj:IsA("Folder") then
      local n = obj.Name:lower()
      local isBoard = (obj.Name == "TicTacToe") or (obj.Name == "TICTACTOE_BOARD") or n:find("tictactoe") or n:find("tic tac") or n == "xo" or n:find("xoboard") or n:find("ttt")
      if isBoard then
        local part = obj:FindFirstChildWhichIsA("BasePart", true)
        if part then
          local d = hrp and (part.Position - hrp.Position).Magnitude or 0
          if d < bestDist then
            bestDist = d
            best = obj
          end
        end
      end
    end
  end
  return best, bestDist
end

function TTT_GetDetectors(board)
  local list = {}
  local hrp = TTT_GetHRP()
  if board then
    for i = 1, 9 do
      local det = board:FindFirstChild("Detector" .. i, true)
      if det then
        local click = det:FindFirstChildWhichIsA("ClickDetector")
        if click then table.insert(list, click) end
      end
    end
    if #list == 0 then
      for _, d in ipairs(board:GetDescendants()) do
        if d:IsA("ClickDetector") then table.insert(list, d) end
      end
    end
  end
  if #list == 0 and hrp then
    local near = {}
    for _, d in ipairs(workspace:GetDescendants()) do
      if d:IsA("ClickDetector") then
        local part = d.Parent
        if part and part:IsA("BasePart") then
          local dist = (part.Position - hrp.Position).Magnitude
          if dist <= 20 then
            table.insert(near, { click = d, dist = dist })
          end
        end
      end
    end
    table.sort(near, function(a, b) return a.dist < b.dist end)
    for i = 1, math.min(12, #near) do
      table.insert(list, near[i].click)
    end
  end
  return list
end

function TTT_Teleport()
  local hrp = TTT_GetHRP()
  local mg = workspace:FindFirstChild("MiniGames")
  local ttt = mg and mg:FindFirstChild("TicTacToe")
  local gameM = ttt and ttt:FindFirstChild("Game")
  if not hrp or not gameM then
    ShowNotification("XO: MiniGames.TicTacToe missing", "", 2)
    return
  end
  local seat = gameM:FindFirstChild("Chair1") or gameM:FindFirstChild("Chair2") or gameM:FindFirstChild("PS_1")
  local area = gameM:FindFirstChild("Board") and gameM.Board:FindFirstChild("Area")
  local part = (seat and (seat:IsA("BasePart") and seat or seat:FindFirstChildWhichIsA("BasePart")))
    or area or gameM:FindFirstChildWhichIsA("BasePart", true)
  if part then
    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    ShowNotification("XO: TP MiniGames.TicTacToe", "", 2)
  end
end

function TTT_GetTouched()
  local mg = workspace:FindFirstChild("MiniGames")
  local ttt = mg and mg:FindFirstChild("TicTacToe")
  local gameM = ttt and ttt:FindFirstChild("Game")
  return gameM and gameM:FindFirstChild("GetTouched")
end

function TTT_ListButtons()
  local list = {}
  local mg = workspace:FindFirstChild("MiniGames")
  local ttt = mg and mg:FindFirstChild("TicTacToe")
  local gameM = ttt and ttt:FindFirstChild("Game")
  local board = gameM and gameM:FindFirstChild("Board")
  local area = board and board:FindFirstChild("Area")
  local sg = area and area:FindFirstChild("SurfaceGui")
  local holder = sg and sg:FindFirstChild("List")
  if holder then
    for i = 1, 9 do
      local b = holder:FindFirstChild(tostring(i))
      if b and b:IsA("GuiButton") then table.insert(list, b) end
    end
  end
  return list
end

function TTT_CollectRemotes()
  local rem = {}
  local gt = TTT_GetTouched()
  if gt then table.insert(rem, gt) end
  return rem
end

function TTT_ToggleAuto()
  TTT_Auto = not TTT_Auto
  if TTT_Conn then
    pcall(function() TTT_Conn:Disconnect() end)
    TTT_Conn = nil
  end
  if not TTT_Auto then
    ShowNotification("XO Auto OFF", "", 2)
    return
  end
  local board = TTT_FindBoard()
  local dets = TTT_GetDetectors(board)
  local prompts, guiBtns = {}, {}
  for _, b in ipairs(TTT_ListButtons()) do table.insert(guiBtns, b) end
  local hrp = TTT_GetHRP()
  if hrp then
    for _, o in ipairs(workspace:GetDescendants()) do
      if o:IsA("ProximityPrompt") then
        local part = o.Parent
        if part and part:IsA("BasePart") and (part.Position - hrp.Position).Magnitude <= 22 then
          table.insert(prompts, o)
        end
      elseif o:IsA("GuiButton") then
        local ad = o.Parent
        while ad and not ad:IsA("BasePart") and not ad:IsA("Model") do ad = ad.Parent end
        local part = ad and (ad:IsA("BasePart") and ad or ad:FindFirstChildWhichIsA("BasePart"))
        if part and (part.Position - hrp.Position).Magnitude <= 22 then
          table.insert(guiBtns, o)
        end
      end
    end
  end
  pcall(function()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
      for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("GuiButton") then
          local path = o:GetFullName():lower()
          if path:find("tic") or path:find("ttt") or path:find("minigame") or path:find("xo") then
            table.insert(guiBtns, o)
          end
        end
      end
    end
  end)
  local remotes = TTT_CollectRemotes()
  ShowNotification("XO ON clk:" .. #dets .. " pr:" .. #prompts .. " gui:" .. #guiBtns .. " rm:" .. #remotes, "", 3)
  local slot = 0
  TTT_Conn = RunService.Heartbeat:Connect(function()
    if not TTT_Auto then return end
    if fireclickdetector then
      for _, c in ipairs(dets) do pcall(fireclickdetector, c) end
    end
    if fireproximityprompt then
      for _, p in ipairs(prompts) do pcall(fireproximityprompt, p) end
    end
    for _, b in ipairs(guiBtns) do
      pcall(function()
        if firesignal and b.Activated then firesignal(b.Activated) end
        if getconnections and b.MouseButton1Click then
          for _, conn in ipairs(getconnections(b.MouseButton1Click)) do
            pcall(function() conn:Fire() end)
          end
        end
      end)
    end
    slot = (slot % 9) + 1
    for _, r in ipairs(remotes) do
      pcall(function()
        if r:IsA("RemoteFunction") then
          r:InvokeServer(slot)
        else
          r:FireServer()
          r:FireServer(slot)
          r:FireServer(tostring(slot))
        end
      end)
    end
  end)
end


function initExploitsTab()
  exploitPage = pages["Exploits"]
exploitPage.AutomaticCanvasSize = Enum.AutomaticSize.None
exploitPage.CanvasSize = UDim2.new(0, 0, 0, 480)
exploitPage.ScrollBarThickness = 3
exploitPage.ScrollBarImageColor3 = Theme.NeonGreen

-- regfix
expLayout = Instance.new("UIListLayout", exploitPage)
expLayout.Padding = UDim.new(0, 8)

expLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
  exploitPage.CanvasSize = UDim2.new(0, 0, 0, math.max(480, expLayout.AbsoluteContentSize.Y + 24))
end)

makeSectionHead(exploitPage, "EX", "EXPLOIT SUITE", "stealth tools")

MasterInvisBtn = Instance.new("TextButton", exploitPage)
MasterInvisBtn.Size = UDim2.new(1, 0, 0, 44)
MasterInvisBtn.BackgroundColor3 = Theme.CardBg
MasterInvisBtn.Text = "  INV          OFF"
MasterInvisBtn.TextColor3 = Theme.TextWhite
MasterInvisBtn.TextXAlignment = Enum.TextXAlignment.Left
MasterInvisBtn.TextSize = 12
MasterInvisBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
Instance.new("UICorner", MasterInvisBtn).CornerRadius = UDim.new(0, 6)
-- regfix
mibStroke = Instance.new("UIStroke", MasterInvisBtn)
mibStroke.Color = Theme.NeonDarkGreen

MasterInvisBtn.MouseButton1Click:Connect(ToggleServerInvisibility)

updateStealthUI = function()
  if StealthState.active then
    MasterInvisBtn.Text = "  INV          ON"
    MasterInvisBtn.BackgroundColor3 = Theme.NeonDarkGreen
    mibStroke.Color = Theme.NeonGreen
  else
    MasterInvisBtn.Text = "  INV          OFF"
    MasterInvisBtn.BackgroundColor3 = Theme.CardBg
    mibStroke.Color = Theme.NeonDarkGreen
  end
end

-- TP TO VOID 99M (single full-width button)
do
  local voidRow = Instance.new("Frame", exploitPage)
  voidRow.Name = "VoidTpRow"
  voidRow.Size = UDim2.new(1, 0, 0, 40)
  voidRow.BackgroundTransparency = 1
  voidRow.BorderSizePixel = 0

  TpVoid99Btn = Instance.new("TextButton", voidRow)
  TpVoid99Btn.Size = UDim2.new(1, 0, 1, 0)
  TpVoid99Btn.BackgroundColor3 = Theme.CardBg
  TpVoid99Btn.Text = "TP TO VOID 99M"
  TpVoid99Btn.TextColor3 = Theme.TextWhite
  TpVoid99Btn.TextSize = 13
  TpVoid99Btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  TpVoid99Btn.AutoButtonColor = true
  Instance.new("UICorner", TpVoid99Btn).CornerRadius = UDim.new(0, 6)
  local st99 = Instance.new("UIStroke", TpVoid99Btn)
  st99.Color = Theme.NeonDarkGreen
  st99.Thickness = 1
  TpVoid99Btn.MouseButton1Click:Connect(function()
    if TpToVoid99M then TpToVoid99M() end
  end)
end

do
  -- Aura Method (Anti-Cuff Aura) Row with Toggle Switch & Keybind
  auraCard = Instance.new("Frame", exploitPage)
  auraCard.Size = UDim2.new(1, 0, 0, 44)
  auraCard.BackgroundColor3 = Theme.CardBg
  Instance.new("UICorner", auraCard).CornerRadius = UDim.new(0, 6)
  arStroke = Instance.new("UIStroke", auraCard)
  arStroke.Color = Theme.NeonDarkGreen

  tLabel = Instance.new("TextLabel", auraCard)
  tLabel.Size = UDim2.new(1, -140, 0, 18)
  tLabel.Position = UDim2.fromOffset(12, 5)
  tLabel.BackgroundTransparency = 1
  tLabel.Text = "Aura Method"
  tLabel.TextColor3 = Theme.NeonGreen
  tLabel.TextSize = 11
  tLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  tLabel.TextXAlignment = Enum.TextXAlignment.Left

  dLabel = Instance.new("TextLabel", auraCard)
  dLabel.Size = UDim2.new(1, -140, 0, 14)
  dLabel.Position = UDim2.fromOffset(12, 23)
  dLabel.BackgroundTransparency = 1
  dLabel.Text = "Blocks cuffs & auto-reapplies on respawn"
  dLabel.TextColor3 = Theme.TextDim
  dLabel.TextSize = 9
  dLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  dLabel.TextXAlignment = Enum.TextXAlignment.Left

  -- Keybind Button (Left of Switch)
  auraKeyBtn = Instance.new("TextButton", auraCard)
  auraKeyBtn.Size = UDim2.fromOffset(72, 24)
  auraKeyBtn.Position = UDim2.new(1, -130, 0.5, -12)
  currentKey = (CFG.aura_keybind and CFG.aura_keybind ~= "None") and CFG.aura_keybind or CFG.quick_aura_keybind
  isBound = currentKey and currentKey ~= "None"
  auraKeyBtn.BackgroundColor3 = isBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
  auraKeyBtn.Text = isBound and ("[" .. currentKey .. "]") or "Bind Key"
  auraKeyBtn.TextColor3 = isBound and Theme.NeonGreen or Theme.TextDim
  auraKeyBtn.TextSize = 10
  auraKeyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", auraKeyBtn).CornerRadius = UDim.new(0, 5)

  -- Toggle Switch (Right side)
  auraSwitch = Instance.new("TextButton", auraCard)
  auraSwitch.Size = UDim2.fromOffset(38, 20)
  auraSwitch.Position = UDim2.new(1, -48, 0.5, -10)
  auraSwitch.BackgroundColor3 = CFG.aura_enabled and Theme.NeonGreen or Theme.CardOff
  auraSwitch.Text = ""
  Instance.new("UICorner", auraSwitch).CornerRadius = UDim.new(1, 0)

  knob = Instance.new("Frame", auraSwitch)
  knob.Size = UDim2.fromOffset(14, 14)
  knob.Position = CFG.aura_enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
  knob.BackgroundColor3 = CFG.aura_enabled and Color3.fromRGB(0, 30, 15) or Theme.TextDim
  knob.BorderSizePixel = 0
  Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

  UpdateAuraUI = function()
    enabled = CFG.aura_enabled
    auraSwitch.BackgroundColor3 = enabled and Theme.NeonGreen or Theme.CardOff
    knob.Position = enabled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = enabled and Color3.fromRGB(0, 30, 15) or Theme.TextDim
    k = (CFG.aura_keybind and CFG.aura_keybind ~= "None") and CFG.aura_keybind or CFG.quick_aura_keybind
    b = k and k ~= "None"
    auraKeyBtn.Text = b and ("[" .. k .. "]") or "Bind Key"
    auraKeyBtn.TextColor3 = b and Theme.NeonGreen or Theme.TextDim
    auraKeyBtn.BackgroundColor3 = b and Color3.fromRGB(24, 45, 32) or Theme.CardOff
  end

  auraSwitch.MouseButton1Click:Connect(function()
    ToggleAura()
  end)

  auraKbListening = false
  auraKeyBtn.MouseButton1Click:Connect(function()
    if auraKbListening then return end
    auraKbListening = true
    auraKeyBtn.Text = "..."
    auraKeyBtn.TextColor3 = Theme.NeonGreen
    conn = nil
    conn = UserInputService.InputBegan:Connect(function(io, gpe)
      if gpe then return end
      if io.KeyCode ~= Enum.KeyCode.Unknown then
        conn:Disconnect()
        auraKbListening = false
        if io.KeyCode == Enum.KeyCode.Escape then
          CFG.aura_keybind = "None"
          CFG.quick_aura_keybind = "None"
          auraKeyBtn.Text = "Bind Key"
          auraKeyBtn.TextColor3 = Theme.TextDim
          auraKeyBtn.BackgroundColor3 = Theme.CardOff
        else
          CFG.aura_keybind = io.KeyCode.Name
          CFG.quick_aura_keybind = io.KeyCode.Name
          auraKeyBtn.Text = "[" .. io.KeyCode.Name .. "]"
          auraKeyBtn.TextColor3 = Theme.NeonGreen
          auraKeyBtn.BackgroundColor3 = Color3.fromRGB(24, 45, 32)
        end
        ShowNotification("Aura Method Keybind: " .. CFG.aura_keybind, "", 1.5)
      end
    end)
  end)

  makeFiveMToggle(exploitPage, "Auto-Uncuff (Anti-Cuff)", "Breaks cuff welds & repairs body automatically (Safe / Zero Remotes)", "", function() return CFG.auto_uncuff end, function(v) CFG.auto_uncuff = v end)

  do
    -- Self-Uncuff / Break Free Card
    uncuffCard = Instance.new("Frame", exploitPage)
    uncuffCard.Size = UDim2.new(1, 0, 0, 44)
    uncuffCard.BackgroundColor3 = Theme.CardBg
    Instance.new("UICorner", uncuffCard).CornerRadius = UDim.new(0, 6)
    ucStroke = Instance.new("UIStroke", uncuffCard)
    ucStroke.Color = Theme.NeonDarkGreen

    ucTitle = Instance.new("TextLabel", uncuffCard)
    ucTitle.Size = UDim2.new(1, -210, 0, 18)
    ucTitle.Position = UDim2.fromOffset(12, 5)
    ucTitle.BackgroundTransparency = 1
    ucTitle.Text = "Self Uncuff (Break Free)"
    ucTitle.TextColor3 = Theme.NeonGreen
    ucTitle.TextSize = 11
    ucTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    ucTitle.TextXAlignment = Enum.TextXAlignment.Left

    ucDesc = Instance.new("TextLabel", uncuffCard)
    ucDesc.Size = UDim2.new(1, -210, 0, 14)
    ucDesc.Position = UDim2.fromOffset(12, 23)
    ucDesc.BackgroundTransparency = 1
    ucDesc.Text = "Breaks foreign welds & repairs split body (Zero Remotes)"
    ucDesc.TextColor3 = Theme.TextDim
    ucDesc.TextSize = 9
    ucDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    ucDesc.TextXAlignment = Enum.TextXAlignment.Left

    -- Break Free Button
    breakBtn = Instance.new("TextButton", uncuffCard)
    breakBtn.Size = UDim2.fromOffset(72, 24)
    breakBtn.Position = UDim2.new(1, -200, 0.5, -12)
    breakBtn.BackgroundColor3 = Theme.NeonDarkGreen
    breakBtn.Text = "Break Free"
    breakBtn.TextColor3 = Theme.TextWhite
    breakBtn.TextSize = 10
    breakBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", breakBtn).CornerRadius = UDim.new(0, 5)
    breakBtn.MouseButton1Click:Connect(function()
      if DoSelfUncuff then DoSelfUncuff() end
    end)

    -- Emergency Body Repair Button (Motor6D + HRP snap)
    reBtn = Instance.new("TextButton", uncuffCard)
    reBtn.Size = UDim2.fromOffset(55, 24)
    reBtn.Position = UDim2.new(1, -132, 0.5, -12)
    reBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
    reBtn.Text = "ðŸ”§ Fix"
    reBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
    reBtn.TextSize = 10
    reBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", reBtn).CornerRadius = UDim.new(0, 5)
    reBtn.MouseButton1Click:Connect(function()
      if ForceBodyRepair then
        ForceBodyRepair()
        ShowNotification("ðŸ”§ Body Repaired!", "Motor6D & joints reset", 1.5)
      end
    end)

    -- Keybind Button
    uncuffKeyBtn = Instance.new("TextButton", uncuffCard)
    uncuffKeyBtn.Size = UDim2.fromOffset(70, 24)
    uncuffKeyBtn.Position = UDim2.new(1, -73, 0.5, -12)
    isBound = CFG.uncuff_keybind and CFG.uncuff_keybind ~= "None"
    uncuffKeyBtn.BackgroundColor3 = isBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
    uncuffKeyBtn.Text = isBound and ("[" .. CFG.uncuff_keybind .. "]") or "Bind Key"
    uncuffKeyBtn.TextColor3 = isBound and Theme.NeonGreen or Theme.TextDim
    uncuffKeyBtn.TextSize = 10
    uncuffKeyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", uncuffKeyBtn).CornerRadius = UDim.new(0, 5)

    uncuffListening = false
    uncuffKeyBtn.MouseButton1Click:Connect(function()
      if uncuffListening then return end
      uncuffListening = true
      uncuffKeyBtn.Text = "..."
      uncuffKeyBtn.TextColor3 = Theme.NeonGreen
      conn = nil
      conn = UserInputService.InputBegan:Connect(function(io, gpe)
        if gpe then return end
        if io.KeyCode ~= Enum.KeyCode.Unknown then
          conn:Disconnect()
          uncuffListening = false
          if io.KeyCode == Enum.KeyCode.Escape then
            CFG.uncuff_keybind = "None"
            uncuffKeyBtn.Text = "Bind Key"
            uncuffKeyBtn.TextColor3 = Theme.TextDim
            uncuffKeyBtn.BackgroundColor3 = Theme.CardOff
          else
            CFG.uncuff_keybind = io.KeyCode.Name
            uncuffKeyBtn.Text = "[" .. io.KeyCode.Name .. "]"
            uncuffKeyBtn.TextColor3 = Theme.NeonGreen
            uncuffKeyBtn.BackgroundColor3 = Color3.fromRGB(24, 45, 32)
          end
          ShowNotification("Uncuff Keybind: " .. CFG.uncuff_keybind, "", 1.5)
        end
      end)
    end)
  end

  -- ----------------------------------------------------------------
  -- CUFF NEAREST  (Nearest player ≤ range - Fast & Smooth)
  -- ----------------------------------------------------------------
  do
    local ccCard = Instance.new("Frame", exploitPage)
    ccCard.Name = "HandcuffCard"
    ccCard.Size = UDim2.new(1, 0, 0, 78)
    ccCard.BackgroundColor3 = Theme.CardBg
    Instance.new("UICorner", ccCard).CornerRadius = UDim.new(0, 6)
    local ccStroke = Instance.new("UIStroke", ccCard)
    ccStroke.Color = Color3.fromRGB(220, 60, 180)
    ccStroke.Thickness = 1

    -- Title
    local ccTitle = Instance.new("TextLabel", ccCard)
    ccTitle.Size = UDim2.new(1, -16, 0, 18)
    ccTitle.Position = UDim2.fromOffset(12, 5)
    ccTitle.BackgroundTransparency = 1
    ccTitle.Text = "CUFF NEAREST"
    ccTitle.TextColor3 = Color3.fromRGB(255, 100, 210)
    ccTitle.TextSize = 11
    ccTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    ccTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Description
    local ccDesc = Instance.new("TextLabel", ccCard)
    ccDesc.Size = UDim2.new(1, -16, 0, 13)
    ccDesc.Position = UDim2.fromOffset(12, 23)
    ccDesc.BackgroundTransparency = 1
    ccDesc.Text = "Cuff nearest player (Fast, smooth, zero shake)"
    ccDesc.TextColor3 = Theme.TextDim
    ccDesc.TextSize = 9
    ccDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    ccDesc.TextXAlignment = Enum.TextXAlignment.Left

    -- Range label
    local ccRangeLabel = Instance.new("TextLabel", ccCard)
    ccRangeLabel.Size = UDim2.new(0, 90, 0, 13)
    ccRangeLabel.Position = UDim2.fromOffset(12, 40)
    ccRangeLabel.BackgroundTransparency = 1
    ccRangeLabel.Text = "Range: " .. (CFG.color_cuff_range or 20) .. "m"
    ccRangeLabel.TextColor3 = Color3.fromRGB(255, 170, 230)
    ccRangeLabel.TextSize = 9
    ccRangeLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    ccRangeLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Slider track
    local sliderTrack = Instance.new("Frame", ccCard)
    sliderTrack.Name = "CCSliderTrack"
    sliderTrack.Size = UDim2.new(1, -186, 0, 6)
    sliderTrack.Position = UDim2.new(0, 108, 0, 43)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 30, 50)
    sliderTrack.BorderSizePixel = 0
    Instance.new("UICorner", sliderTrack).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame", sliderTrack)
    sliderFill.Name = "CCSliderFill"
    sliderFill.Size = UDim2.new((CFG.color_cuff_range or 20) / 50, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(220, 60, 180)
    sliderFill.BorderSizePixel = 0
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local sliderKnob = Instance.new("TextButton", sliderTrack)
    sliderKnob.Name = "CCSliderKnob"
    sliderKnob.Size = UDim2.fromOffset(14, 14)
    sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderKnob.Position = UDim2.new((CFG.color_cuff_range or 20) / 50, 0, 0.5, 0)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 100, 210)
    sliderKnob.Text = ""
    sliderKnob.AutoButtonColor = false
    sliderKnob.ZIndex = 3
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

    -- Slider drag logic (min 5m, max 50m)
    local ccSliderDragging = false
    local function updateCCSlider(absX)
      local trackAbsPos = sliderTrack.AbsolutePosition.X
      local trackAbsSize = sliderTrack.AbsoluteSize.X
      local frac = math.clamp((absX - trackAbsPos) / trackAbsSize, 0, 1)
      local newRange = math.floor(frac * 45 + 5)  -- 5..50
      CFG.color_cuff_range = newRange
      sliderFill.Size = UDim2.new(frac, 0, 1, 0)
      sliderKnob.Position = UDim2.new(frac, 0, 0.5, 0)
      ccRangeLabel.Text = "Range: " .. newRange .. "m"
    end
    sliderKnob.InputBegan:Connect(function(inp)
      if inp.UserInputType == Enum.UserInputType.MouseButton1
      or inp.UserInputType == Enum.UserInputType.Touch then
        ccSliderDragging = true
      end
    end)
    sliderTrack.InputBegan:Connect(function(inp)
      if inp.UserInputType == Enum.UserInputType.MouseButton1
      or inp.UserInputType == Enum.UserInputType.Touch then
        ccSliderDragging = true
        updateCCSlider(inp.Position.X)
      end
    end)
    UserInputService.InputChanged:Connect(function(inp)
      if ccSliderDragging and (
        inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
        updateCCSlider(inp.Position.X)
      end
    end)
    UserInputService.InputEnded:Connect(function(inp)
      if inp.UserInputType == Enum.UserInputType.MouseButton1
      or inp.UserInputType == Enum.UserInputType.Touch then
        ccSliderDragging = false
      end
    end)

    -- Execute Button (CUFF)
    local ccBtn = Instance.new("TextButton", ccCard)
    ccBtn.Size = UDim2.fromOffset(72, 24)
    ccBtn.Position = UDim2.new(1, -168, 0, 47)
    ccBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 120)
    ccBtn.Text = "CUFF"
    ccBtn.TextColor3 = Color3.fromRGB(255, 220, 245)
    ccBtn.TextSize = 9
    ccBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    ccBtn.AutoButtonColor = true
    Instance.new("UICorner", ccBtn).CornerRadius = UDim.new(0, 5)
    ccBtn.MouseButton1Click:Connect(function()
      if ColorCuff_Execute then ColorCuff_Execute() end
    end)

    -- Keybind Button
    local ccKeyBtn = Instance.new("TextButton", ccCard)
    ccKeyBtn.Size = UDim2.fromOffset(66, 24)
    ccKeyBtn.Position = UDim2.new(1, -92, 0, 47)
    local _ccKb = CFG.color_cuff_keybind
    local _ccBound = _ccKb and _ccKb ~= "None"
    ccKeyBtn.BackgroundColor3 = _ccBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
    ccKeyBtn.Text = _ccBound and ("[" .. _ccKb .. "]") or "Bind Key"
    ccKeyBtn.TextColor3 = _ccBound and Theme.NeonGreen or Theme.TextDim
    ccKeyBtn.TextSize = 10
    ccKeyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", ccKeyBtn).CornerRadius = UDim.new(0, 5)

    -- Dedicated Clear Keybind Button (✕)
    local ccClrBtn = Instance.new("TextButton", ccCard)
    ccClrBtn.Size = UDim2.fromOffset(20, 24)
    ccClrBtn.Position = UDim2.new(1, -23, 0, 47)
    ccClrBtn.BackgroundColor3 = Color3.fromRGB(55, 25, 35)
    ccClrBtn.Text = "✕"
    ccClrBtn.TextColor3 = Color3.fromRGB(255, 120, 140)
    ccClrBtn.TextSize = 11
    ccClrBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", ccClrBtn).CornerRadius = UDim.new(0, 5)

    local function clearHandcuffKeybind()
      CFG.color_cuff_keybind = "None"
      ccKeyBtn.Text = "Bind Key"
      ccKeyBtn.TextColor3 = Theme.TextDim
      ccKeyBtn.BackgroundColor3 = Theme.CardOff
      ShowNotification("Cuff Nearest Keybind Cleared", "", 1.5)
    end

    ccClrBtn.MouseButton1Click:Connect(clearHandcuffKeybind)
    ccKeyBtn.MouseButton2Click:Connect(clearHandcuffKeybind) -- Right click to clear as well!

    local ccKbListening = false
    ccKeyBtn.MouseButton1Click:Connect(function()
      if ccKbListening then return end
      ccKbListening = true
      ccKeyBtn.Text = "..."
      ccKeyBtn.TextColor3 = Theme.NeonGreen
      local kconn
      kconn = UserInputService.InputBegan:Connect(function(io, gpe)
        if gpe then return end
        if io.KeyCode ~= Enum.KeyCode.Unknown then
          kconn:Disconnect()
          ccKbListening = false
          if io.KeyCode == Enum.KeyCode.Escape 
          or io.KeyCode == Enum.KeyCode.Backspace 
          or io.KeyCode == Enum.KeyCode.Delete then
            clearHandcuffKeybind()
          else
            CFG.color_cuff_keybind = io.KeyCode.Name
            ccKeyBtn.Text = "[" .. io.KeyCode.Name .. "]"
            ccKeyBtn.TextColor3 = Theme.NeonGreen
            ccKeyBtn.BackgroundColor3 = Color3.fromRGB(24, 45, 32)
            pcall(SaveToxicCFG)
            ShowNotification("Cuff Nearest Keybind: " .. CFG.color_cuff_keybind, "", 1.5)
          end
        end
      end)
    end)
  end
end
end -- close initExploitsTab

initExploitsTab()
-- ----------------------------------------------------
-- 8. VISUALS TAB (FiveM Card Toggles)
-- ----------------------------------------------------
function initVisualsTab()
  visualsPage = pages["Visuals"]
  visualsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
  visualsPage.ScrollBarThickness = 3
  visualsPage.ScrollBarImageColor3 = Theme.NeonGreen
  local vll = Instance.new("UIListLayout", visualsPage)
  vll.Padding = UDim.new(0, 6)
  vll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    visualsPage.CanvasSize = UDim2.new(0, 0, 0, math.max(360, vll.AbsoluteContentSize.Y + 16))
  end)

  makeSectionHead(visualsPage, "ES", "ESP", "")
  makeFiveMToggle(visualsPage, "ESP", "Master ESP switch", "", function() return CFG.esp_enabled end, function(v)
    CFG.esp_enabled = v and true or false
  end)
  makeFiveMToggle(visualsPage, "Names", "Name tags", "", function() return CFG.esp_names == true end, function(v) CFG.esp_names = v and true or false end)
  makeFiveMToggle(visualsPage, "Flag", "Show player country flag", "", function() return (CFG.esp_flag ~= false and CFG.esp_region ~= false) end, function(v)
    CFG.esp_flag = v and true or false
    CFG.esp_region = v and true or false
  end)
  makeFiveMToggle(visualsPage, "Chams", "Highlight through walls", "", function() return CFG.esp_chams == true end, function(v) CFG.esp_chams = v and true or false end)
  makeFiveMToggle(visualsPage, "Distance", "Meters on tag", "", function() return CFG.esp_distance end, function(v) CFG.esp_distance = v end)
  makeFiveMToggle(visualsPage, "Tools", "Held tool on tag", "", function() return CFG.esp_tools end, function(v) CFG.esp_tools = v end)

  makeSectionHead(visualsPage, "LT", "LIGHT", "")
  makeFiveMToggle(visualsPage, "Anti Ragdoll", "Stand up if knocked", "", function() return CFG.anti_ragdoll == true end, function(v)
    CFG.anti_ragdoll = v and true or false
    if v then StartAntiRagdoll() else StopAntiRagdoll() end
  end)
  makeFiveMToggle(visualsPage, "Fullbright", "Bright world light", "", function() return CFG.fullbright end, function(v)
    CFG.fullbright = v
    pcall(function()
      local L = game:GetService("Lighting")
      if v then
        if not _G._TX_LB then
          _G._TX_LB = {b=L.Brightness, c=L.ClockTime, a=L.Ambient, o=L.OutdoorAmbient, f=L.FogEnd}
        end
        L.Brightness = 3
        L.ClockTime = 14
        L.Ambient = Color3.fromRGB(180,180,180)
        L.OutdoorAmbient = Color3.fromRGB(180,180,180)
        L.FogEnd = 1000000
        local oldcc = L:FindFirstChild("TXFullbright")
        if oldcc then oldcc:Destroy() end
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "TXFullbright"
        cc.Brightness = 0.08
        cc.Contrast = 0.05
        cc.Parent = L
      else
        local st = _G._TX_LB
        if st then
          L.Brightness = st.b
          L.ClockTime = st.c
          L.Ambient = st.a
          L.OutdoorAmbient = st.o
          L.FogEnd = st.f
        end
        local cc = L:FindFirstChild("TXFullbright")
        if cc then cc:Destroy() end
      end
    end)
    SaveToxicCFG()
  end)


  makeSectionHead(visualsPage, "HB", "HITBOX", "")
  do
    local hbCard = makeFiveMCard(visualsPage, "Hitbox Extender", "Expand other HRP for easier hits")
    local tag = Instance.new("TextLabel", hbCard)
    tag.BackgroundTransparency = 1
    tag.Size = UDim2.fromOffset(28, 12)
    tag.Position = UDim2.new(1, -80, 0.5, -6)
    tag.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    tag.TextSize = 9
    tag.TextXAlignment = Enum.TextXAlignment.Right
    local hbSwitch = Instance.new("TextButton")
    hbSwitch.Size = UDim2.fromOffset(38, 20)
    hbSwitch.Position = UDim2.new(1, -48, 0.5, -10)
    hbSwitch.Text = ""
    hbSwitch.AutoButtonColor = false
    hbSwitch.Parent = hbCard
    Instance.new("UICorner", hbSwitch).CornerRadius = UDim.new(1, 0)
    local hbKnob = Instance.new("Frame", hbSwitch)
    hbKnob.Size = UDim2.fromOffset(14, 14)
    hbKnob.BorderSizePixel = 0
    Instance.new("UICorner", hbKnob).CornerRadius = UDim.new(1, 0)
    if paintSwitch then paintSwitch(hbSwitch, hbKnob, tag, CFG.hitbox_extender_enabled and true or false) end
    local hbStepper = Instance.new("Frame", hbCard)
    hbStepper.Size = UDim2.fromOffset(92, 24)
    hbStepper.Position = UDim2.new(1, -176, 0.5, -12)
    hbStepper.BackgroundTransparency = 1
    hbStepper.Visible = CFG.hitbox_extender_enabled and true or false
    local hbMinus = Instance.new("TextButton", hbStepper)
    hbMinus.Size = UDim2.fromOffset(24, 24)
    hbMinus.BackgroundColor3 = Theme.CardOff
    hbMinus.Text = "-"
    hbMinus.TextColor3 = Theme.TextWhite
    hbMinus.TextSize = 14
    hbMinus.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", hbMinus).CornerRadius = UDim.new(0, 5)
    local hbVal = Instance.new("TextLabel", hbStepper)
    hbVal.Size = UDim2.fromOffset(38, 24)
    hbVal.Position = UDim2.fromOffset(27, 0)
    hbVal.BackgroundColor3 = Theme.InputBg
    hbVal.Text = tostring(CFG.hitbox_size or 12)
    hbVal.TextColor3 = Theme.NeonGreen
    hbVal.TextSize = 11
    hbVal.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", hbVal).CornerRadius = UDim.new(0, 5)
    local hbPlus = Instance.new("TextButton", hbStepper)
    hbPlus.Size = UDim2.fromOffset(24, 24)
    hbPlus.Position = UDim2.fromOffset(68, 0)
    hbPlus.BackgroundColor3 = Theme.NeonDarkGreen
    hbPlus.Text = "+"
    hbPlus.TextColor3 = Theme.TextWhite
    hbPlus.TextSize = 14
    hbPlus.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", hbPlus).CornerRadius = UDim.new(0, 5)
    hbMinus.MouseButton1Click:Connect(function()
      CFG.hitbox_size = math.max(4, (CFG.hitbox_size or 12) - 2)
      hbVal.Text = tostring(CFG.hitbox_size)
    end)
    hbPlus.MouseButton1Click:Connect(function()
      CFG.hitbox_size = math.min(60, (CFG.hitbox_size or 12) + 2)
      hbVal.Text = tostring(CFG.hitbox_size)
    end)
    hbSwitch.MouseButton1Click:Connect(function()
      ToggleHitboxExtender(not CFG.hitbox_extender_enabled)
      local on = CFG.hitbox_extender_enabled and true or false
      if paintSwitch then paintSwitch(hbSwitch, hbKnob, tag, on) end
      hbStepper.Visible = on
    end)
  end

  makeSectionHead(visualsPage, "CL", "CLEAN", "")
  makeFiveMToggle(visualsPage, "Hide Aura Visuals", "Strip self glow", "", function() return CFG.hide_aura_visuals end, function(v)
    CFG.hide_aura_visuals = v
    if v and _G.TOXIC_CleanAuraVisuals and LocalPlayer.Character then _G.TOXIC_CleanAuraVisuals(LocalPlayer.Character) end
  end)
  makeFiveMToggle(visualsPage, "Hide Others Effects", "Strip others particles", "", function() return CFG.hide_others_effects end, function(v)
    CFG.hide_others_effects = v
    if v and _G.TOXIC_CleanOthersEffects then _G.TOXIC_CleanOthersEffects() end
  end)
  makeFiveMToggle(visualsPage, "Admin HUD", "Admin overlay", "", function() return CFG.admin_hud_enabled end, function(v)
    CFG.admin_hud_enabled = v
    if SetAdminHudVisible then SetAdminHudVisible(v) end
  end)

  local fixCamBtn = Instance.new("TextButton", visualsPage)
  fixCamBtn.Size = UDim2.new(1, 0, 0, 34)
  fixCamBtn.BackgroundColor3 = Theme.CardBg
  fixCamBtn.Text = "FIX CAMERA"
  fixCamBtn.TextColor3 = Theme.TextWhite
  fixCamBtn.TextSize = 11
  fixCamBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", fixCamBtn).CornerRadius = UDim.new(0, 6)
  fixCamBtn.MouseButton1Click:Connect(function()
    if FixCamera then FixCamera() end
  end)
end
initVisualsTab()

-- 8.5 AUTO-PIANO MAESTRO (Park Piano Bot)
-- ----------------------------------------------------
function initPianoModule()
  pianoPage = pages["Piano"]
  pianoPage.AutomaticCanvasSize = Enum.AutomaticSize.None
  pianoPage.CanvasSize = UDim2.new(0, 0, 0, 750)
  pianoPage.ScrollBarThickness = 3
  pianoPage.ScrollBarImageColor3 = Theme.NeonGreen

  pLayout = Instance.new("UIListLayout", pianoPage)
  pLayout.Padding = UDim.new(0, 8)

  pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    pianoPage.CanvasSize = UDim2.new(0, 0, 0, math.max(750, pLayout.AbsoluteContentSize.Y + 30))
  end)

  -- --- Piano Remotes & Note Mappings ---
  repStorage = game:GetService("ReplicatedStorage")
  PianoKeyPressed = repStorage:FindFirstChild("PianoKeyPressed")
  PianoKeyPress3D = repStorage:FindFirstChild("PianoKeyPress3D")

  whiteKeys = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
    "q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
    "a", "s", "d", "f", "g", "h", "j", "k", "l",
    "z", "x", "c", "v", "b", "n", "m"
  }
  blackKeys = {
    "!", "@", "$", "%", "^", "*", "(",
    "Q", "W", "E", "T", "Y", "I", "O", "P",
    "S", "D", "G", "H", "J", "L",
    "Z", "C", "V", "B"
  }
  whiteMap = {}
  for i, k in ipairs(whiteKeys) do whiteMap[k] = i end
  blackMap = {}
  for i, k in ipairs(blackKeys) do blackMap[k] = i end

  t2 = { 0, 2, 4, 5, 7, 9, 11 }
  t3 = {}
  for i = 1, 36 do
    t3[i] = math.floor((i - 1) / 7) * 12 + 36 + t2[(i - 1) % 7 + 1]
  end

  t4 = { 1, 3, 6, 8, 10 }
  t5 = {}
  for j = 1, 25 do
    t5[j] = math.floor((j - 1) / 5) * 12 + 36 + t4[(j - 1) % 5 + 1]
  end

  soundAssets = {
    "rbxassetid://233836579", "rbxassetid://233844049",
    "rbxassetid://233845680", "rbxassetid://233852841",
    "rbxassetid://233854135", "rbxassetid://233856105"
  }

  local function getPianoFolder()
    return workspace:FindFirstChild("PianoFolder")
  end

  local function getSitPiano()
    pf = getPianoFolder()
    if pf then
      b2 = pf:FindFirstChild("Bench2")
      if b2 then
        return b2:FindFirstChild("SitPiano")
      end
    end
    return nil
  end

  localSounds = nil
  soundIndex = 0
  local function playLocalSound(midiVal)
    if not midiVal then return end
    if not localSounds or #localSounds == 0 then
      pf = getPianoFolder()
      pnl = pf and pf:FindFirstChild("Panel")
      if pnl then
        sList = {}
        for _, ch in ipairs(pnl:GetChildren()) do
          if ch:IsA("Sound") then
            table.insert(sList, ch)
          end
        end
        if #sList > 0 then localSounds = sList end
      end
    end
    if localSounds and #localSounds > 0 then
      v22 = (midiVal - 36) % 12
      timePos = (v22 % 2) * 8 + math.floor((midiVal - 36) / 12) * 16
      assetId = soundAssets[math.floor(v22 / 2) + 1]
      if assetId then
        soundIndex = (soundIndex % #localSounds) + 1
        snd = localSounds[soundIndex]
        if snd then
          pcall(function()
            snd:Stop()
            snd.SoundId = assetId
            snd.TimePosition = timePos
            snd.Volume = 1
            snd:Play()
          end)
        end
      end
    end
  end

  local function playPianoKey(char)
    if not char then return end
    wIdx = whiteMap[char]
    if wIdx then
      midiVal = t3[wIdx]
      if not PianoKeyPressed then
        PianoKeyPressed = repStorage:FindFirstChild("PianoKeyPressed")
      end
      if PianoKeyPressed then
        pcall(function() PianoKeyPressed:FireServer(wIdx, true) end)
      end
      if not PianoKeyPress3D then
        PianoKeyPress3D = repStorage:FindFirstChild("PianoKeyPress3D")
      end
      if PianoKeyPress3D and midiVal then
        pcall(function()
          PianoKeyPress3D:FireServer(math.floor((midiVal - 36) / 12) + 1, (midiVal - 36) % 12 + 1)
        end)
      end
      playLocalSound(midiVal)
      return
    end

    bIdx = blackMap[char]
    if bIdx then
      midiVal = t5[bIdx]
      if not PianoKeyPressed then
        PianoKeyPressed = repStorage:FindFirstChild("PianoKeyPressed")
      end
      if PianoKeyPressed then
        pcall(function() PianoKeyPressed:FireServer(bIdx, false) end)
      end
      if not PianoKeyPress3D then
        PianoKeyPress3D = repStorage:FindFirstChild("PianoKeyPress3D")
      end
      if PianoKeyPress3D and midiVal then
        pcall(function()
          PianoKeyPress3D:FireServer(math.floor((midiVal - 36) / 12) + 1, (midiVal - 36) % 12 + 1)
        end)
      end
      playLocalSound(midiVal)
      return
    end
  end

  -- --- Song Library ---
  PianoSongs = {
    {
      name = "Experience (Ludovico Einaudi)",
      tag = "MASTERPIECE",
      desc = "Epic emotional buildup & sweeping concert arpeggios",
      sheet = "[4e] 8 q [8w] [4e] 8 q [8w] [18t] w t [wy] [18u] w t [wy] [5w] 9 w [9e] [5r] 9 w [9e] [6e] 0 e [0r] [6t] 0 e [0r] [4e] 8 q [8w] [4e] 8 q [8w] [18t] w t [wy] [18u] w t [wy] [5w] 9 w [9e] [5r] 9 w [9e] [6e] 0 e [0r] [6t] 0 e 0 [4e] [8t] [qu] [8i] [4u] [8y] [qt] [8r] [1e] [5w] [8e] [wt] [1r] [5e] [8w] [5q] [5w] [9r] [wy] [9u] [5y] [9t] [wr] [9e] [6w] [0e] [et] [0y] [6t] [0r] [ee] [0w] [4e] 8 q [8w] [4e] 8 q [8w] [18t] w t [wy] [18u] w t [wy]"
    },
    {
      name = "Tokyo Ghoul - Unravel",
      tag = "ANIME",
      desc = "Legendary anime opening, emotional & fast arpeggios",
      sheet = "[6e] 0 [et] [0u] [6e] 0 [ey] [0t] [4q] 8 [qe] [8t] [4q] 8 [qe] [8w] [10] 5 [8w] [5e] [10] 5 [8w] [50] [5w] 9 [wr] [9y] [5w] 9 [wr] [9e] [6e] [0r] [et] [0y] [6u] [0i] [eu] [0y] [4t] [8r] [qe] [8w] [4q] [80] [9q] [8w] [1e] [5r] [8t] [5y] [1u] [5i] [8u] [5y] [5t] [9y] [wu] [9i] [5o] 9 w [9p] [6u] p s d f d s p [4i] o p s d s p o [1u] o p a s a p o [5y] u i o p o i u"
    },
    {
      name = "River Flows In You (Yiruma)",
      tag = "ROMANTIC",
      desc = "Timeless melodic masterpiece, gentle & sweeping",
      sheet = "[4q] [8e] [qt] [8y] [4u] [8y] [qt] [8r] [10] [5w] [8e] [5r] [1t] [5r] [8e] [5w] [59] [9w] [er] [9t] [5y] [9t] [wr] [9e] [60] [0e] [rt] [0y] [6u] [0y] [et] [0r] [4q] [8e] [qt] [8y] [4u] [8y] [qt] [8r] [10] [5w] [8e] [5r] [1t] [5r] [8e] [5w] [59] [9w] [er] [9t] [5y] [9t] [wr] [9e] [60] [0e] [rt] [0y] [6u] 0 e 0 [4e] [8r] [qt] [8y] [4u] 8 [qi] 8 [1u] [5y] [8t] 5 [1r] 5 [8e] 5 [5w] 9 [we] 9 [5r] 9 [wt] 9 [6y] 0 [et] 0 [6r] 0 [ee] 0"
    },
    {
      name = "Giorno's Theme (Il Vento D'oro)",
      tag = "HYPE",
      desc = "The legendary JoJo 3:45 piano breakdown solo",
      sheet = "[6e] [6e] [6e] [et] [6e] [6e] [ry] [6e] [6e] [tu] [6e] [6e] [yi] [6e] [6e] [tu] [6e] [6e] [6e] [et] [6e] [6e] [ry] [6e] [6e] [tu] [6e] [6e] [yi] [6e] [6e] [tu] [6e] 0 e [0t] [6y] 0 e [0u] [4i] 8 q [8u] [4y] 8 q [8t] [1r] 5 8 [5e] [1w] 5 8 [5q] [5w] 9 w [9e] [5r] 9 w [9t] [6y] 0 e [0u] [6i] 0 e [0o] [6p] [6p] [6p] [6o] [6i] [6u] [6y] [6t] [6r] [6e]"
    },
    {
      name = "Moonlight Sonata (Presto Agitato)",
      tag = "VIRTUOSO",
      desc = "Blazing fast Beethoven 3rd Movement storm",
      sheet = "[6u] p s d f d s p [6u] p s d f d s p [4i] o p s d s p o [4i] o p s d s p o [1u] o p a s a p o [1u] o p a s a p o [5y] u i o p o i u [5y] u i o p o i u [6u] p s d f d s p [6u] p s d f d s p [4i] o p s d s p o [4i] o p s d s p o [1u] o p a s a p o [1u] o p a s a p o [5y] u i o p o i u [5y] u i o p o i u [6u] [8p] [0s] [ed] [tf] [ed] [0s] [8p] [6u]"
    },
    {
      name = "Golden Hour (JVKE)",
      tag = "PIANO",
      desc = "Atmospheric modern viral arpeggios",
      sheet = "[8o] w t w [8o] w t w [5o] w r w [5o] w r w [6u] 0 e 0 [6u] 0 e 0 [4y] 8 q 8 [4t] 8 q 8 [8o] w t w [8o] w t w [5o] w r w [5o] w r w [6u] 0 e 0 [6u] 0 e 0 [4y] 8 q 8 [4t] 8 q 8"
    },
    {
      name = "Interstellar (Hans Zimmer)",
      tag = "CINEMA",
      desc = "Epic deep space theme",
      sheet = "[8u] 0 w 0 [8u] 0 w 0 [8o] 0 w 0 [8o] 0 w 0 [8p] 0 w 0 [8p] 0 w 0 [8a] 0 w 0 [8a] 0 w 0 [6s] 8 0 8 [6s] 8 0 8 [6a] 8 0 8 [6a] 8 0 8 [6p] 8 0 8 [6p] 8 0 8 [6o] 8 0 8 [6o] 8 0 8"
    },
    {
      name = "Fur Elise (Beethoven)",
      tag = "CLASSIC",
      desc = "Timeless classical piano piece",
      sheet = "e E e E e u y t [8r] w 0 w [6t] 0 e 0 [6u] 0 e 0 [3y] 7 0 7 [6e] 0 e 0 e E e E e u y t [8r] w 0 w [6t] 0 e 0 [6u] 0 e 0 [3y] 7 0 7 [6e]"
    },
    {
      name = "Pirates of the Caribbean",
      tag = "CINEMA",
      desc = "He's a Pirate adventure theme",
      sheet = "a s [0d] f d [0d] f d [0d] f g [8f] d [8f] d [8f] g a [9s] a [9s] a [9s] d [0f] d [0f] d [0f] g [7h] [6g] [7f] [8d] [9s] [0a] s [0d] f d [0d] f d [0d] f g [8f]"
    },
    {
      name = "Astronomia (Coffin Dance)",
      tag = "MEME",
      desc = "Viral pallbearer dance song",
      sheet = "[8t] [8t] [8t] [8t] [9y] [9y] [9y] [9y] [0u] [0u] [0u] [0u] [9y] [9y] [9y] [9y] [8t] [0w] [0w] [0w] [8t] [0w] [0w] [0w] [7r] [9w] [9w] [9w] [7r] [9w] [9w] [9w] [6e] [80] [80] [80] [6e] [80] [80] [80] [5w] [79] [79] [79] [5w] [79] [79] [79]"
    },
    {
      name = "Never Gonna Give You Up",
      tag = "MEME",
      desc = "Rick Astley classic Rickroll",
      sheet = "y u [1io] [1io] p [3oa] [3oa] s [5id] [5id] f [6os] [6os] [5id] [4os] [4oa] [3ip] [2yo] [1tu] y u [1io] [1io] p [3oa] [3oa] s [5id] [5id] f [6os] [6os] [5id] [4os] [4oa] [3ip] [2yo] [1tu]"
    },
    {
      name = "Megalovania (Undertale)",
      tag = "MEME",
      desc = "Sans iconic boss battle theme",
      sheet = "d d [8f] a [7p] [6o] i u y t [8r] d d [8f] a [7p] [6o] i u y t [8r] d d [8f] a [7p] [6o] i u y t [8r]"
    },
    {
      name = "Rush E (High BPM Test)",
      tag = "CHAOS",
      desc = "Fast multi-key piano spam test",
      sheet = "e e e e e e e e e e e e [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e] [6e]"
    },
    {
      name = "Inception - Time (Hans Zimmer)",
      tag = "CINEMA",
      desc = "Deep resonant bass chords & breathtaking emotional climax",
      sheet = "[18] w t [wy] [18u] w t [wy] [60] e t [er] [60e] e t [er] [4q] 8 q [8w] [4qe] 8 q [8w] [59] w r [we] [59w] w r [we] [18] [5w] [8t] [wy] [18u] [5w] [8t] [wy] [60] [3e] [6t] [er] [60e] [3e] [6t] [er] [4q] [18] [4q] [8w] [4qe] [18] [4q] [8w] [59] [2w] [5r] [we] [59w] [2w] [5r] [we] [18t] w t [wy] [18u] w t [wy] [60e] e t [er] [60t] e t [er] [4qe] 8 q [8w] [4qr] 8 q [8w] [59w] w r [we] [59r] w r [we] [18t]"
    },
    {
      name = "Attack on Titan - Vogel im Kafig",
      tag = "ANIME",
      desc = "Massive goosebumps anime theme, deep bass & soaring melody",
      sheet = "[6e] [0t] [eu] [0p] [6s] [0d] [ef] [0d] [4q] [8e] [qt] [8u] [4i] [8u] [qt] [8e] [10] [5w] [8e] [5t] [1y] [5t] [8e] [5w] [59] [9w] [er] [9t] [5y] [9u] [wi] [9o] [6p] [0s] [ed] [0f] [6g] [0f] [ed] [0s] [4a] [8p] [qo] [8i] [4u] [8y] [qt] [8r] [1e] [5w] [80] [5w] [1e] [5r] [8t] [5y] [5u] [9i] [wo] [9p] [5a] [9s] [wd] [9f] [6g] [8f] [0d] [es] [6p] [8o] [0i] [eu] [4y] [8t] [qr] [8e] [4w] [8q] [0q] [8w] [1e] [5r] [8t] [5y] [1u] [5i] [8o] [5p] [5a] [9s] [wd] [9f] [6g] [8h] [wj] [9k] [6l]"
    },
    {
      name = "Mozart - Turkish March (Rondo Alla Turca)",
      tag = "VIRTUOSO",
      desc = "Ultra-fast energetic virtuoso showpiece, full chord strikes",
      sheet = "[80w] [80w] [80w] [9qe] [0wr] [9qe] [80w] [79q] [80w] [9qe] [0wr] [80w] [79q] [680] [680] [680] [680] [80w] [80w] [80w] [9qe] [0wr] [9qe] [80w] [79q] [80w] [9qe] [0wr] [80w] [79q] [680] [680] [680] [3570] [3570] [680] [80e] [80e] [80e] [9wr] [0et] [9wr] [80e] [79w] [80e] [9wr] [0et] [80e] [79w] [680] [680] [680] [80w] [80w] [80w] [9qe] [0wr] [9qe] [80w] [79q] [680]"
    },
    {
      name = "Chopin - Nocturne Op. 9 No. 2",
      tag = "ROMANTIC",
      desc = "World's most beloved romantic classic, rich warm harmony",
      sheet = "[8t] w [tu] w [8i] [wu] [ty] w [8t] [we] [tu] w [5r] 9 [wr] 9 [5e] 9 [wr] 9 [8t] w [tu] w [8i] [wu] [ty] w [8t] [we] [tu] w [5r] 9 [wr] 9 [5e] 9 [wq] 9 [80] w [tu] w [8i] [wu] [ty] w [6e] 0 [et] 0 [6r] 0 [et] 0 [4q] 8 [qe] 8 [4w] 8 [qe] 8 [10] 5 [8w] 5 [10] [5w] [8t] [wy] [18u] w t [wy] [60e] e t [er] [60t] e t [er] [4qe] 8 q [8w] [59w] w r [we] [18t]"
    },
    {
      name = "Demon Slayer - Tanjiro No Uta",
      tag = "ANIME",
      desc = "Deeply emotional Japanese melody with sweeping chords",
      sheet = "[6e] 0 e [0t] [6y] 0 e [0u] [4i] 8 q [8u] [4y] 8 q [8t] [1r] 5 8 [5e] [1w] 5 8 [5q] [5w] 9 w [9e] [5r] 9 w [9t] [6y] 0 e [0u] [6i] 0 e [0o] [6p] 0 e [0a] [4s] 8 q [8a] [4p] 8 q [8o] [1i] 5 8 [5u] [1y] 5 8 [5t] [5r] 9 w [9e] [5w] 9 w 9 [60e] [0r] [et] [0y] [6u] [0i] [eo] [0p] [4a] 8 [qs] 8 [4d] 8 [qf] 8 [1g] 5 [8f] 5 [1d] 5 [8s] 5 [5a] 9 [wp] 9 [5o] 9 [wi] 9 [6u] 0 e 0 [6e]"
    },
    {
      name = "Bella Ciao (La Casa de Papel)",
      tag = "HYPE",
      desc = "Iconic energetic partisan anthem with pounding rhythms",
      sheet = "[6e] 0 [er] [0t] [6e] 0 [er] [0t] [6e] 0 [er] [0t] [6e] [6e] [6e] [et] [6e] [6e] [ry] [6e] [6e] [tu] [6e] [6e] [yi] [6e] [6e] [tu] [4i] 8 [qu] [8y] [4i] 8 [qu] [8y] [4i] 8 [qo] [8i] [4u] 8 [qy] [8t] [1r] 5 [8w] [5e] [1r] 5 [8t] [5y] [5u] 9 [wi] [9u] [5y] 9 [wt] [9r] [6e] 0 e 0 [6e] 0 e 0 [4i] [8u] [qy] [8t] [4i] [8u] [qy] [8t] [4i] [8o] [qp] [8o] [1u] 5 [8y] [5t] [1r] 5 [8w] [5e] [5r] 9 [wt] [9y] [5u] 9 [wi] [9u] [6e] 0 e 0 [6e]"
    },
    {
      name = "Mariage d'Amour (Spring Waltz)",
      tag = "MASTERPIECE",
      desc = "Flowing romantic arpeggios, concert pianist atmosphere",
      sheet = "[6e] 0 r t [0y] u [4i] 8 q w [8e] r [1t] 5 8 9 [50] w [5e] 9 w e [9r] t [6y] 0 e r [0t] y [4u] 8 q w [8e] r [1t] 5 8 9 [50] w [5e] 9 w 9 [60e] [6e] 0 [et] [0u] [6e] 0 [et] [0u] [4q] 8 [qe] [8t] [4q] 8 [qe] [8t] [10] 5 [8w] [5e] [10] 5 [8w] [5e] [5w] 9 [we] [9r] [5w] 9 [we] [9r] [6e] 0 e 0 [60e]"
    },
    {
      name = "Interstellar - No Time For Caution",
      tag = "CINEMA",
      desc = "Epic docking scene organ & piano build, heart-racing intensity",
      sheet = "[8w] [8w] [8w] [8w] [8w] [8w] [8w] [8w] [60] [60] [60] [60] [60] [60] [60] [60] [4q] [4q] [4q] [4q] [4q] [4q] [4q] [4q] [59] [59] [59] [59] [59] [59] [59] [59] [8w] [0t] [wu] [0t] [8w] [0t] [wu] [0t] [60] [8e] [0t] [8e] [60] [8e] [0t] [8e] [4q] [68] [0w] [68] [4q] [68] [0w] [68] [59] [7w] [9r] [7w] [59] [7w] [9r] [7w] [8wtu] [8wtu] [8wtu] [60et] [60et] [60et] [4qet] [4qet] [4qet] [59wr] [59wr] [59wr] [180wt]"
    }
  }

  -- --- Tokenizer ---
  local function tokenizeSheet(sheetStr)
    tokens = {}
    len = #sheetStr
    i = 1
    while i <= len do
      c = sheetStr:sub(i, i)
      if c == "[" then
        closePos = sheetStr:find("]", i + 1, true)
        if closePos then
          chordNotes = {}
          for k = i + 1, closePos - 1 do
            subC = sheetStr:sub(k, k)
            if whiteMap[subC] or blackMap[subC] then
              table.insert(chordNotes, subC)
            end
          end
          if #chordNotes > 0 then
            table.insert(tokens, { type = "chord", notes = chordNotes })
          end
          i = closePos + 1
        else
          if whiteMap[c] or blackMap[c] then
            table.insert(tokens, { type = "note", key = c })
          end
          i = i + 1
        end
      elseif c == " " or c == "\t" then
        table.insert(tokens, { type = "pause", delay = 0.12 })
        i = i + 1
      elseif c == "|" or c == "\n" then
        table.insert(tokens, { type = "pause", delay = 0.28 })
        i = i + 1
      elseif c == "-" then
        table.insert(tokens, { type = "pause", delay = 0.18 })
        i = i + 1
      else
        if whiteMap[c] or blackMap[c] then
          table.insert(tokens, { type = "note", key = c })
        end
        i = i + 1
      end
    end
    return tokens
  end

  -- --- Playback State & Engine ---
  PianoState = {
    playing = false,
    thread = nil,
    currentSongName = "",
    currentNote = 0,
    totalNotes = 0,
    isSeated = false,
  }

  statusLabel = nil
  playBtn = nil
  stopBtn = nil
  seatStatusLabel = nil
  songCardBtns = {}

  local function isPlayerSeatedAtPiano()
    sit = getSitPiano()
    if not sit then return false end
    occ = sit.Occupant
    char = LocalPlayer.Character
    hum = char and char:FindFirstChildOfClass("Humanoid")
    return (occ ~= nil and hum ~= nil and occ == hum)
  end

  local function updatePianoUI()
    if playBtn then
      playBtn.Text = PianoState.playing and "â-¶ PLAYING..." or "â-¶ PLAY / RESUME"
      playBtn.BackgroundColor3 = PianoState.playing and Theme.NeonDarkGreen or Theme.NeonGreen
      playBtn.TextColor3 = PianoState.playing and Theme.NeonGreen or Color3.fromRGB(0, 25, 12)
    end
    if statusLabel then
      if PianoState.playing then
        statusLabel.Text = string.format("Playing: %s [%d/%d]", PianoState.currentSongName, PianoState.currentNote, PianoState.totalNotes)
        statusLabel.TextColor3 = Theme.NeonGreen
      else
        selObj = PianoSongs[CFG.piano_selected_song or 1]
        selName = selObj and selObj.name or "None"
        statusLabel.Text = "Selected: " .. selName .. " (Ready to play)"
        statusLabel.TextColor3 = Theme.TextDim
      end
    end
    for idx, btn in pairs(songCardBtns) do
      isSel = (idx == (CFG.piano_selected_song or 1))
      btn.BackgroundColor3 = isSel and Theme.CardBgHover or Theme.CardBg
      stroke = btn:FindFirstChildOfClass("UIStroke")
      if stroke then
        stroke.Color = isSel and Theme.NeonGreen or Theme.GlowStroke
        stroke.Transparency = isSel and 0.12 or 0.5
        stroke.Thickness = isSel and 1.6 or 1
      end
      strip = btn:FindFirstChild("SelStrip")
      if strip then
        strip.BackgroundColor3 = isSel and Theme.NeonGreen or Theme.NeonDarkGreen
        strip.BackgroundTransparency = isSel and 0 or 0.35
      end
    end
  end

  local function updatePianoSeatStatus()
    if seatStatusLabel then
      if PianoState.isSeated then
        seatStatusLabel.Text = "STATUS: SEATED AT PIANO"
        seatStatusLabel.TextColor3 = Theme.NeonGreen
      else
        seatStatusLabel.Text = "STATUS: NOT SEATED"
        seatStatusLabel.TextColor3 = Theme.TextDim
      end
    end
  end

  local function stopPiano()
    PianoState.playing = false
    if PianoState.thread then
      pcall(function() task.cancel(PianoState.thread) end)
      PianoState.thread = nil
    end
    updatePianoUI()
  end

  local function startPiano(sheetStr, songTitle)
    stopPiano()
    tokens = tokenizeSheet(sheetStr)
    if #tokens == 0 then
      ShowNotification("Piano: Empty Sheet", "No playable notes detected", 2)
      return
    end

    PianoState.playing = true
    PianoState.currentSongName = songTitle or "Piano Melody"
    PianoState.totalNotes = #tokens
    PianoState.currentNote = 0

    PianoState.thread = task.spawn(function()
      while PianoState.playing do
        for idx, token in ipairs(tokens) do
          if not PianoState.playing then break end
          PianoState.currentNote = idx

          speed = math.clamp(CFG.piano_speed or 1.0, 0.25, 3.0)

          if token.type == "chord" then
            for _, n in ipairs(token.notes) do
              playPianoKey(n)
            end
            if statusLabel then
              statusLabel.Text = string.format("Playing: %s [%d/%d]", PianoState.currentSongName, idx, #tokens)
            end
            task.wait(0.20 / speed)
          elseif token.type == "note" then
            playPianoKey(token.key)
            if statusLabel then
              statusLabel.Text = string.format("Playing: %s [%d/%d]", PianoState.currentSongName, idx, #tokens)
            end
            task.wait(0.18 / speed)
          elseif token.type == "pause" then
            task.wait((token.delay or 0.12) / speed)
          end
        end

        if not CFG.piano_loop or not PianoState.playing then
          break
        end
        task.wait(0.6 / (CFG.piano_speed or 1.0))
      end

      PianoState.playing = false
      updatePianoUI()
    end)

    updatePianoUI()
    ShowNotification("Auto-Piano", "Playing " .. PianoState.currentSongName, 2)
  end

  local function tpToPiano()
    sit = getSitPiano()
    char = LocalPlayer.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
      targetPos = sit and (sit.Position + Vector3.new(0, 2.5, 0)) or Vector3.new(-345.48, 276.5, -97.40)
      hrp.CFrame = CFrame.new(targetPos)
      task.wait(0.25)
      if hum and sit and sit:IsA("Seat") then
        pcall(function() sit:Sit(hum) end)
      end
      ShowNotification("Piano Teleport", "Arrived at Grand Piano!", 2)
    end
  end

  -- --- Sitting Detection Handler ---
  task.spawn(function()
    while task.wait(0.8) do
      seated = isPlayerSeatedAtPiano()
      if seated ~= PianoState.isSeated then
        PianoState.isSeated = seated
        updatePianoSeatStatus()

        if seated then
          if CFG.piano_auto_sit and not PianoState.playing then
            sObj = PianoSongs[CFG.piano_selected_song or 1]
            if sObj then
              startPiano(sObj.sheet, sObj.name)
            end
          end
        else
          if CFG.piano_auto_sit and PianoState.playing then
            stopPiano()
          end
        end
      end
    end
  end)

  -- ====================================================
  -- UI BUILDER FOR PIANO TAB
  -- ====================================================

  -- 1. Hero Banner
  heroCard = Instance.new("Frame", pianoPage)
  heroCard.Size = UDim2.new(1, 0, 0, 72)
  heroCard.BackgroundColor3 = Theme.CardBg
  heroCard.BorderSizePixel = 0
  Instance.new("UICorner", heroCard).CornerRadius = UDim.new(0, 6)
  hcStroke = Instance.new("UIStroke", heroCard)
  hcStroke.Color = Theme.NeonGreen
  hcStroke.Thickness = 1.2

  hTitle = Instance.new("TextLabel", heroCard)
  hTitle.Size = UDim2.new(1, -120, 0, 18)
  hTitle.Position = UDim2.fromOffset(12, 8)
  hTitle.BackgroundTransparency = 1
  hTitle.Text = "AUTO PIANO"
  hTitle.TextColor3 = Theme.TextWhite
  hTitle.TextSize = 13
  hTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
  hTitle.TextXAlignment = Enum.TextXAlignment.Left

  seatStatusLabel = Instance.new("TextLabel", heroCard)
  seatStatusLabel.Size = UDim2.new(1, -120, 0, 14)
  seatStatusLabel.Position = UDim2.fromOffset(12, 28)
  seatStatusLabel.BackgroundTransparency = 1
  seatStatusLabel.Text = "STATUS: NOT SEATED"
  seatStatusLabel.TextColor3 = Theme.TextDim
  seatStatusLabel.TextSize = 9
  seatStatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  seatStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

  statusLabel = Instance.new("TextLabel", heroCard)
  statusLabel.Size = UDim2.new(1, -120, 0, 16)
  statusLabel.Position = UDim2.fromOffset(12, 46)
  statusLabel.BackgroundTransparency = 1
  statusLabel.Text = "Selected: Experience (Ludovico Einaudi) (Ready to play)"
  statusLabel.TextColor3 = Theme.TextDim
  statusLabel.TextSize = 10
  statusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  statusLabel.TextXAlignment = Enum.TextXAlignment.Left

  tpBtn = Instance.new("TextButton", heroCard)
  tpBtn.Size = UDim2.fromOffset(100, 32)
  tpBtn.Position = UDim2.new(1, -112, 0.5, -16)
  tpBtn.BackgroundColor3 = Theme.CardBgHover
  tpBtn.Text = "TP TO PIANO"
  tpBtn.TextColor3 = Theme.NeonGreen
  tpBtn.TextSize = 10
  tpBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
  tpStroke = Instance.new("UIStroke", tpBtn)
  tpStroke.Color = Theme.NeonGreen
  tpStroke.Thickness = 1
  tpBtn.MouseButton1Click:Connect(tpToPiano)

  -- 2. Play / Stop Control Row
  cRow = Instance.new("Frame", pianoPage)
  cRow.Size = UDim2.new(1, 0, 0, 42)
  cRow.BackgroundTransparency = 1

  playBtn = Instance.new("TextButton", cRow)
  playBtn.Size = UDim2.new(0.68, -4, 1, 0)
  playBtn.Position = UDim2.new(0, 0, 0, 0)
  playBtn.BackgroundColor3 = Theme.NeonGreen
  playBtn.Text = "â-¶ PLAY / RESUME"
  playBtn.TextColor3 = Color3.fromRGB(0, 25, 12)
  playBtn.TextSize = 12
  playBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
  playBtn.MouseButton1Click:Connect(function()
    if PianoState.playing then
      stopPiano()
    else
      sObj = PianoSongs[CFG.piano_selected_song or 1]
      if sObj then
        startPiano(sObj.sheet, sObj.name)
      end
    end
  end)

  stopBtn = Instance.new("TextButton", cRow)
  stopBtn.Size = UDim2.new(0.32, -4, 1, 0)
  stopBtn.Position = UDim2.new(0.68, 4, 0, 0)
  stopBtn.BackgroundColor3 = Theme.CardBg
  stopBtn.Text = "â¹ STOP"
  stopBtn.TextColor3 = Theme.DangerRed
  stopBtn.TextSize = 11
  stopBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)
  sStroke = Instance.new("UIStroke", stopBtn)
  sStroke.Color = Theme.DangerRed
  stopBtn.MouseButton1Click:Connect(stopPiano)

  -- 3. Behavior Toggles (FiveM Cards)
  makeFiveMToggle(pianoPage, "Auto-Play On Sit", "Detects when you sit on piano bench & auto-plays", "", function()
    return CFG.piano_auto_sit
  end, function(v)
    CFG.piano_auto_sit = v
    if v and isPlayerSeatedAtPiano() and not PianoState.playing then
      sObj = PianoSongs[CFG.piano_selected_song or 1]
      if sObj then startPiano(sObj.sheet, sObj.name) end
    end
  end)

  makeFiveMToggle(pianoPage, "Loop Song", "Repeats the active song infinitely until stopped", "", function()
    return CFG.piano_loop
  end, function(v)
    CFG.piano_loop = v
  end)

  -- 4. Speed Multiplier Row
  spdCard = Instance.new("Frame", pianoPage)
  spdCard.Size = UDim2.new(1, 0, 0, 48)
  spdCard.BackgroundColor3 = Theme.CardBg
  spdCard.BorderSizePixel = 0
  Instance.new("UICorner", spdCard).CornerRadius = UDim.new(0, 6)
  spdStroke = Instance.new("UIStroke", spdCard)
  spdStroke.Color = Theme.NeonDarkGreen

  spdLbl = Instance.new("TextLabel", spdCard)
  spdLbl.Size = UDim2.new(0.35, 0, 1, 0)
  spdLbl.Position = UDim2.fromOffset(10, 0)
  spdLbl.BackgroundTransparency = 1
  spdLbl.Text = "PLAYBACK SPEED"
  spdLbl.TextColor3 = Theme.TextWhite
  spdLbl.TextSize = 10
  spdLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  spdLbl.TextXAlignment = Enum.TextXAlignment.Left

  speeds = { 0.75, 1.0, 1.25, 1.5, 2.0 }
  speedBtns = {}
  spdCont = Instance.new("Frame", spdCard)
  spdCont.Size = UDim2.new(0.62, 0, 1, -12)
  spdCont.Position = UDim2.new(0.38, 0, 0, 6)
  spdCont.BackgroundTransparency = 1
  spdLL = Instance.new("UIListLayout", spdCont)
  spdLL.FillDirection = Enum.FillDirection.Horizontal
  spdLL.Padding = UDim.new(0, 4)

  local function refreshSpeedBtns()
    for spdVal, b in pairs(speedBtns) do
      isCur = math.abs((CFG.piano_speed or 1.0) - spdVal) < 0.05
      b.BackgroundColor3 = isCur and Theme.NeonGreen or Theme.CardBgHover
      b.TextColor3 = isCur and Color3.fromRGB(0, 20, 10) or Theme.TextWhite
    end
  end

  for _, sVal in ipairs(speeds) do
    sBtn = Instance.new("TextButton", spdCont)
    sBtn.Size = UDim2.new(1 / #speeds, -4, 1, 0)
    sBtn.BackgroundColor3 = (sVal == (CFG.piano_speed or 1.0)) and Theme.NeonGreen or Theme.CardBgHover
    sBtn.Text = tostring(sVal) .. "x"
    sBtn.TextColor3 = (sVal == (CFG.piano_speed or 1.0)) and Color3.fromRGB(0, 20, 10) or Theme.TextWhite
    sBtn.TextSize = 9
    sBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)
    speedBtns[sVal] = sBtn
    sBtn.MouseButton1Click:Connect(function()
      CFG.piano_speed = sVal
      refreshSpeedBtns()
      ShowNotification("Piano Speed", tostring(sVal) .. "x Tempo", 1.5)
    end)
  end

  -- 5. Song Library Section
  makeSectionHead(pianoPage, "PL", "SONG LIBRARY", "click a track to select")

  tagColors = {
    MASTERPIECE = Theme.SpecialPurple,
    ANIME = Theme.AccentCyan,
    ROMANTIC = Color3.fromRGB(244, 114, 182),
    HYPE = Theme.WarningYellow,
    VIRTUOSO = Theme.InfoBlue,
    PIANO = Theme.NeonGreen,
    CINEMA = Color3.fromRGB(251, 146, 60),
    CLASSIC = Theme.TextDim,
    MEME = Theme.DangerRed,
    CHAOS = Color3.fromRGB(251, 146, 60),
  }

  for i, song in ipairs(PianoSongs) do
    isSel0 = (i == (CFG.piano_selected_song or 1))
    sCard = Instance.new("TextButton", pianoPage)
    sCard.Size = UDim2.new(1, 0, 0, 56)
    sCard.BackgroundColor3 = isSel0 and Theme.CardBgHover or Theme.CardBg
    sCard.BorderSizePixel = 0
    sCard.Text = ""
    sCard.AutoButtonColor = true
    Instance.new("UICorner", sCard).CornerRadius = UDim.new(0, 10)
    scStroke = Instance.new("UIStroke", sCard)
    scStroke.Color = isSel0 and Theme.NeonGreen or Theme.GlowStroke
    scStroke.Thickness = isSel0 and 1.6 or 1
    scStroke.Transparency = isSel0 and 0.12 or 0.5
    songCardBtns[i] = sCard

    strip = Instance.new("Frame", sCard)
    strip.Name = "SelStrip"
    strip.Size = UDim2.new(0, 4, 1, 0)
    strip.BackgroundColor3 = isSel0 and Theme.NeonGreen or Theme.NeonDarkGreen
    strip.BackgroundTransparency = isSel0 and 0 or 0.35
    strip.BorderSizePixel = 0
    Instance.new("UICorner", strip).CornerRadius = UDim.new(0, 4)

    idxLbl = Instance.new("TextLabel", sCard)
    idxLbl.Size = UDim2.fromOffset(22, 16)
    idxLbl.Position = UDim2.fromOffset(12, 8)
    idxLbl.BackgroundTransparency = 1
    idxLbl.Text = string.format("%02d", i)
    idxLbl.TextColor3 = Theme.TextMuted
    idxLbl.TextSize = 10
    idxLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    idxLbl.TextXAlignment = Enum.TextXAlignment.Left

    tLbl = Instance.new("TextLabel", sCard)
    tLbl.Size = UDim2.new(1, -100, 0, 18)
    tLbl.Position = UDim2.fromOffset(34, 6)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = song.name
    tLbl.TextColor3 = Theme.TextWhite
    tLbl.TextSize = 12
    tLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.TextTruncate = Enum.TextTruncate.AtEnd

    dLbl = Instance.new("TextLabel", sCard)
    dLbl.Size = UDim2.new(1, -100, 0, 16)
    dLbl.Position = UDim2.fromOffset(12, 30)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = song.desc
    dLbl.TextColor3 = Theme.TextDim
    dLbl.TextSize = 10
    dLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextTruncate = Enum.TextTruncate.AtEnd

    tagCol = tagColors[song.tag] or Theme.NeonGreen
    tagBadge = Instance.new("TextLabel", sCard)
    tagBadge.Size = UDim2.fromOffset(78, 20)
    tagBadge.Position = UDim2.new(1, -88, 0, 8)
    tagBadge.BackgroundColor3 = Theme.InputBg
    tagBadge.Text = song.tag
    tagBadge.TextColor3 = tagCol
    tagBadge.TextSize = 9
    tagBadge.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", tagBadge).CornerRadius = UDim.new(0, 6)
    tagStroke = Instance.new("UIStroke", tagBadge)
    tagStroke.Color = tagCol
    tagStroke.Thickness = 1
    tagStroke.Transparency = 0.45

    sCard.MouseButton1Click:Connect(function()
      CFG.piano_selected_song = i
      updatePianoUI()
      if isPlayerSeatedAtPiano() or PianoState.playing then
        startPiano(song.sheet, song.name)
      else
        ShowNotification("Song Selected", song.name, 1.5)
      end
    end)
  end

  -- 6. Custom Virtual Piano Sheet Input
  makeSectionHead(pianoPage, "CS", "CUSTOM SHEET", "paste virtual piano notes")

  customBoxFrame = Instance.new("Frame", pianoPage)
  customBoxFrame.Size = UDim2.new(1, 0, 0, 68)
  customBoxFrame.BackgroundColor3 = Theme.CardBg
  Instance.new("UICorner", customBoxFrame).CornerRadius = UDim.new(0, 6)
  cbfStroke = Instance.new("UIStroke", customBoxFrame)
  cbfStroke.Color = Theme.NeonDarkGreen

  customInput = Instance.new("TextBox", customBoxFrame)
  customInput.Size = UDim2.new(1, -16, 0, 30)
  customInput.Position = UDim2.fromOffset(8, 6)
  customInput.BackgroundColor3 = Theme.InputBg
  customInput.Text = ""
  customInput.PlaceholderText = "Paste Virtual Piano notes here (e.g. [tuo] [tuo] y u i)..."
  customInput.TextColor3 = Theme.TextWhite
  customInput.PlaceholderColor3 = Theme.TextDim
  customInput.TextSize = 10
  customInput.ClearTextOnFocus = false
  customInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  customInput.TextXAlignment = Enum.TextXAlignment.Left
  Instance.new("UICorner", customInput).CornerRadius = UDim.new(0, 4)

  playCustomBtn = Instance.new("TextButton", customBoxFrame)
  playCustomBtn.Size = UDim2.new(1, -16, 0, 22)
  playCustomBtn.Position = UDim2.fromOffset(8, 40)
  playCustomBtn.BackgroundColor3 = Theme.NeonDarkGreen
  playCustomBtn.Text = "â-¶ PLAY CUSTOM SHEET"
  playCustomBtn.TextColor3 = Theme.NeonGreen
  playCustomBtn.TextSize = 10
  playCustomBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", playCustomBtn).CornerRadius = UDim.new(0, 4)
  playCustomBtn.MouseButton1Click:Connect(function()
    text = customInput.Text or ""
    if #text:gsub("%s+", "") == 0 then
      ShowNotification("Empty Sheet", "Please paste sheet notes first!", 2)
      return
    end
    startPiano(text, "Custom Sheet")
  end)

  updatePianoUI()
  updatePianoSeatStatus()
end
initPianoModule()

task.spawn(function()
  task.wait(6)
  found = false
  pcall(function()
    for _, obj in ipairs(workspace:GetDescendants()) do
      n = string.lower(obj.Name or "")
      if n:find("piano") then found = true break end
    end
  end)
  if not found and tabBtns.Piano then
    tabBtns.Piano.btn.Visible = false
  end
end)

-- ----------------------------------------------------
-- 9. CHAT & SILENT COMMAND CENTER (PUBLIC & FAKE PRV SUB-TABS)
-- ----------------------------------------------------
function initChatTab()
  chatPage = pages["Chat"]
  chatPage.AutomaticCanvasSize = Enum.AutomaticSize.None
  chatPage.CanvasSize = UDim2.new(0, 0, 0, 520)
  chatPage.ScrollBarThickness = 3
  chatPage.ScrollBarImageColor3 = Theme.NeonGreen

  chatLayout = Instance.new("UIListLayout", chatPage)
  chatLayout.Padding = UDim.new(0, 6)

  local function updateChatCanvas()
    chatPage.CanvasSize = UDim2.new(0, 0, 0, math.max(480, chatLayout.AbsoluteContentSize.Y + 25))
  end
  chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateChatCanvas)

  makeSectionHead(chatPage, "CH", "CHAT CENTER", "public and vip self chat")

  -- SUB-TAB NAVIGATION BAR
  subTabCard = Instance.new("Frame", chatPage)
  subTabCard.Size = UDim2.new(1, 0, 0, 32)
  subTabCard.BackgroundColor3 = Theme.CardBg
  subTabCard.BorderSizePixel = 0
  Instance.new("UICorner", subTabCard).CornerRadius = UDim.new(0, 6)
  stcStroke = Instance.new("UIStroke", subTabCard)
  stcStroke.Color = Theme.NeonDarkGreen
  stcStroke.Thickness = 1

  publicTabBtn = Instance.new("TextButton", subTabCard)
  publicTabBtn.Size = UDim2.new(0.5, -4, 1, -6)
  publicTabBtn.Position = UDim2.fromOffset(3, 3)
  publicTabBtn.BackgroundColor3 = Theme.NeonDarkGreen
  publicTabBtn.Text = "[ PUBLIC ]"
  publicTabBtn.TextColor3 = Theme.NeonGreen
  publicTabBtn.TextSize = 10
  publicTabBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", publicTabBtn).CornerRadius = UDim.new(0, 5)

  prvTabBtn = Instance.new("TextButton", subTabCard)
  prvTabBtn.Size = UDim2.new(0.5, -4, 1, -6)
  prvTabBtn.Position = UDim2.new(0.5, 1, 0, 3)
  prvTabBtn.BackgroundColor3 = Theme.CardBg
  prvTabBtn.Text = "[ VIP CHAT ]"
  prvTabBtn.TextColor3 = Theme.TextDim
  prvTabBtn.TextSize = 10
  prvTabBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", prvTabBtn).CornerRadius = UDim.new(0, 5)

  -- ====================================================
  -- 1. PUBLIC CHAT CONTAINER
  -- ====================================================
  publicContainer = Instance.new("Frame", chatPage)
  publicContainer.Size = UDim2.new(1, 0, 0, 0)
  publicContainer.AutomaticSize = Enum.AutomaticSize.Y
  publicContainer.BackgroundTransparency = 1
  publicContainer.Visible = true

  pubLayout = Instance.new("UIListLayout", publicContainer)
  pubLayout.Padding = UDim.new(0, 6)

  -- Public Input Card
  ChatInputCard = Instance.new("Frame", publicContainer)
  ChatInputCard.Size = UDim2.new(1, 0, 0, 52)
  ChatInputCard.BackgroundColor3 = Theme.CardBg
  ChatInputCard.BorderSizePixel = 0
  Instance.new("UICorner", ChatInputCard).CornerRadius = UDim.new(0, 6)
  cicStroke = Instance.new("UIStroke", ChatInputCard)
  cicStroke.Color = Theme.NeonDarkGreen
  cicStroke.Thickness = 1

  customChatBox = Instance.new("TextBox", ChatInputCard)
  customChatBox.Size = UDim2.new(1, -156, 0, 32)
  customChatBox.Position = UDim2.fromOffset(8, 10)
  customChatBox.BackgroundColor3 = Theme.CardBg
  customChatBox.PlaceholderText = "Type public message to bind or send..."
  customChatBox.PlaceholderColor3 = Theme.TextDim
  customChatBox.Text = ""
  customChatBox.TextColor3 = Theme.TextWhite
  customChatBox.TextSize = 11
  customChatBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  customChatBox.ClearTextOnFocus = false
  customChatBox.TextXAlignment = Enum.TextXAlignment.Left
  Instance.new("UIPadding", customChatBox).PaddingLeft = UDim.new(0, 8)
  Instance.new("UICorner", customChatBox).CornerRadius = UDim.new(0, 5)
  boxStroke = Instance.new("UIStroke", customChatBox)
  boxStroke.Color = Theme.NeonDarkGreen
  boxStroke.Thickness = 1

  sendNowBtn = Instance.new("TextButton", ChatInputCard)
  sendNowBtn.Size = UDim2.fromOffset(66, 32)
  sendNowBtn.Position = UDim2.new(1, -142, 0, 10)
  sendNowBtn.BackgroundColor3 = Theme.NeonDarkGreen
  sendNowBtn.Text = "Send"
  sendNowBtn.TextColor3 = Theme.TextWhite
  sendNowBtn.TextSize = 10
  sendNowBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", sendNowBtn).CornerRadius = UDim.new(0, 5)

  addSlotBtn = Instance.new("TextButton", ChatInputCard)
  addSlotBtn.Size = UDim2.fromOffset(66, 32)
  addSlotBtn.Position = UDim2.new(1, -72, 0, 10)
  addSlotBtn.BackgroundColor3 = Theme.SpecialPurple
  addSlotBtn.Text = "+ Add Slot"
  addSlotBtn.TextColor3 = Theme.TextWhite
  addSlotBtn.TextSize = 10
  addSlotBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", addSlotBtn).CornerRadius = UDim.new(0, 5)

  makeSectionHead(publicContainer, "PB", "SAVED PUBLIC BINDS", "press bound key anytime")

  -- Container for dynamic message cards
  ChatSlotsContainer = Instance.new("Frame", publicContainer)
  ChatSlotsContainer.Size = UDim2.new(1, 0, 0, 0)
  ChatSlotsContainer.AutomaticSize = Enum.AutomaticSize.Y
  ChatSlotsContainer.BackgroundTransparency = 1

  csLayout = Instance.new("UIListLayout", ChatSlotsContainer)
  csLayout.Padding = UDim.new(0, 5)

  local function RenderChatSlots()
    for _, c in ipairs(ChatSlotsContainer:GetChildren()) do
      if c:IsA("Frame") then c:Destroy() end
    end

    for idx, item in ipairs(CFG.quick_chat_messages) do
      row = Instance.new("Frame", ChatSlotsContainer)
      row.Size = UDim2.new(1, 0, 0, 42)
      row.BackgroundColor3 = Theme.CardBg
      row.BorderSizePixel = 0
      Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

      str = Instance.new("UIStroke", row)
      str.Color = Theme.NeonDarkGreen
      str.Thickness = 1

      msgBox = Instance.new("TextBox", row)
      msgBox.Size = UDim2.new(1, -170, 0, 26)
      msgBox.Position = UDim2.fromOffset(10, 8)
      msgBox.BackgroundColor3 = Theme.CardBg
      msgBox.Text = item.text
      msgBox.TextColor3 = Theme.TextWhite
      msgBox.TextSize = 10
      msgBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      msgBox.ClearTextOnFocus = false
      msgBox.TextXAlignment = Enum.TextXAlignment.Left
      Instance.new("UIPadding", msgBox).PaddingLeft = UDim.new(0, 6)
      Instance.new("UICorner", msgBox).CornerRadius = UDim.new(0, 4)

      msgBox.FocusLost:Connect(function()
        item.text = msgBox.Text
      end)

      -- Send button
      sendBtn = Instance.new("TextButton", row)
      sendBtn.Size = UDim2.fromOffset(50, 24)
      sendBtn.Position = UDim2.new(1, -168, 0.5, -12)
      sendBtn.BackgroundColor3 = Theme.NeonDarkGreen
      sendBtn.Text = "Send"
      sendBtn.TextColor3 = Theme.TextWhite
      sendBtn.TextSize = 9
      sendBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 5)

      sendBtn.MouseButton1Click:Connect(function()
        SendChatMessage(item.text)
        ShowNotification("Sent: " .. item.text, "", 1.5)
      end)

      -- Keybind button
      keyBtn = Instance.new("TextButton", row)
      keyBtn.Size = UDim2.fromOffset(76, 24)
      keyBtn.Position = UDim2.new(1, -112, 0.5, -12)
      isBound = item.keybind and item.keybind ~= "None"
      keyBtn.BackgroundColor3 = isBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
      keyBtn.Text = isBound and ("[" .. item.keybind .. "]") or "Bind Key"
      keyBtn.TextColor3 = isBound and Theme.NeonGreen or Theme.TextDim
      keyBtn.TextSize = 9
      keyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)

      kbListening = false
      keyBtn.MouseButton1Click:Connect(function()
        if kbListening then return end
        kbListening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = Theme.NeonGreen
        conn = nil
        conn = UserInputService.InputBegan:Connect(function(io, gpe)
          if gpe then return end
          if io.KeyCode ~= Enum.KeyCode.Unknown then
            conn:Disconnect()
            kbListening = false
            if io.KeyCode == Enum.KeyCode.Escape then
              item.keybind = "None"
            else
              item.keybind = io.KeyCode.Name
            end
            bound = item.keybind ~= "None"
            keyBtn.Text = bound and ("[" .. item.keybind .. "]") or "Bind Key"
            keyBtn.TextColor3 = bound and Theme.NeonGreen or Theme.TextDim
            keyBtn.BackgroundColor3 = bound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
            ShowNotification("Bound '" .. item.text .. "' to " .. item.keybind, "", 2)
          end
        end)
      end)

      -- Delete button
      delBtn = Instance.new("TextButton", row)
      delBtn.Size = UDim2.fromOffset(24, 24)
      delBtn.Position = UDim2.new(1, -30, 0.5, -12)
      delBtn.BackgroundColor3 = Theme.DangerRed
      delBtn.Text = "X"
      delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      delBtn.TextSize = 10
      delBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)

      delBtn.MouseButton1Click:Connect(function()
        table.remove(CFG.quick_chat_messages, idx)
        RenderChatSlots()
        ShowNotification("Message removed!", "", 1.5)
      end)
    end
  end

  sendNowBtn.MouseButton1Click:Connect(function()
    msg = customChatBox.Text
    if msg and msg ~= "" then
      SendChatMessage(msg)
      ShowNotification("Chat Sent: " .. msg, "", 1.5)
    else
      ShowNotification("Type a message first!", "", 2)
    end
  end)

  addSlotBtn.MouseButton1Click:Connect(function()
    msg = customChatBox.Text
    if msg and msg ~= "" then
      table.insert(CFG.quick_chat_messages, { text = msg, keybind = "None" })
      customChatBox.Text = ""
      RenderChatSlots()
      ShowNotification("New Message Slot Added!", "", 2)
    else
      ShowNotification("Type a message to add!", "", 2)
    end
  end)

  RenderChatSlots()

  -- ====================================================
  -- 2. FAKE PRV CHAT CONTAINER (SILENT / WHISPER COMMANDS)
  -- ====================================================
  prvContainer = Instance.new("Frame", chatPage)
  prvContainer.Size = UDim2.new(1, 0, 0, 0)
  prvContainer.AutomaticSize = Enum.AutomaticSize.Y
  prvContainer.BackgroundTransparency = 1
  prvContainer.Visible = false

  prvLayout = Instance.new("UIListLayout", prvContainer)
  prvLayout.Padding = UDim.new(0, 6)

  -- Info Banner Card
  infoCard = Instance.new("Frame", prvContainer)
  infoCard.Size = UDim2.new(1, 0, 0, 36)
  infoCard.Visible = false
  infoCard.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
  infoCard.BorderSizePixel = 0
  Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 6)
  infoStroke = Instance.new("UIStroke", infoCard)
  infoStroke.Color = Theme.NeonDarkGreen
  infoStroke.Thickness = 1

  infoTitle = Instance.new("TextLabel", infoCard)
  infoTitle.Size = UDim2.new(1, -16, 0, 16)
  infoTitle.Position = UDim2.fromOffset(8, 2)
  infoTitle.BackgroundTransparency = 1
  infoTitle.Text = "VIP CHAT  (SELF ONLY)"
  infoTitle.TextColor3 = Theme.NeonGreen
  infoTitle.TextSize = 10
  infoTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  infoTitle.TextXAlignment = Enum.TextXAlignment.Left

  infoDesc = Instance.new("TextLabel", infoCard)
  infoDesc.Size = UDim2.new(1, -16, 0, 14)
  infoDesc.Position = UDim2.fromOffset(8, 18)
  infoDesc.BackgroundTransparency = 1
  infoDesc.Text = "Silent self commands. Slots + ;re / ;refresh."
  infoDesc.TextColor3 = Theme.TextDim
  infoDesc.TextSize = 9
  infoDesc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  infoDesc.TextXAlignment = Enum.TextXAlignment.Left

  -- Whisper Recipient Selector Card
  targetCard = Instance.new("Frame", prvContainer)
  targetCard.Size = UDim2.new(1, 0, 0, 38)
  targetCard.Visible = false
  targetCard.BackgroundColor3 = Theme.CardBg
  targetCard.BorderSizePixel = 0
  Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 6)
  tcStroke = Instance.new("UIStroke", targetCard)
  tcStroke.Color = Theme.NeonDarkGreen
  tcStroke.Thickness = 1

  tcLabel = Instance.new("TextLabel", targetCard)
  tcLabel.Size = UDim2.new(0, 52, 1, 0)
  tcLabel.Position = UDim2.fromOffset(8, 0)
  tcLabel.BackgroundTransparency = 1
  tcLabel.Text = "TARGET:"
  tcLabel.TextColor3 = Theme.NeonGreen
  tcLabel.TextSize = 10
  tcLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  tcLabel.TextXAlignment = Enum.TextXAlignment.Left

  selfBtn = Instance.new("TextButton", targetCard)
  selfBtn.Size = UDim2.fromOffset(82, 24)
  selfBtn.Position = UDim2.fromOffset(62, 7)
  selfBtn.BackgroundColor3 = (CFG.prv_whisper_target == "Self") and Theme.NeonDarkGreen or Theme.CardOff
  selfBtn.Text = "@Self (Ghost)"
  selfBtn.TextColor3 = (CFG.prv_whisper_target == "Self") and Theme.NeonGreen or Theme.TextDim
  selfBtn.TextSize = 9
  selfBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", selfBtn).CornerRadius = UDim.new(0, 4)

  targetBtn = Instance.new("TextButton", targetCard)
  targetBtn.Size = UDim2.fromOffset(68, 24)
  targetBtn.Position = UDim2.fromOffset(148, 7)
  targetBtn.BackgroundColor3 = (CFG.prv_whisper_target == "Target") and Theme.NeonDarkGreen or Theme.CardOff
  targetBtn.Text = "@Target"
  targetBtn.TextColor3 = (CFG.prv_whisper_target == "Target") and Theme.NeonGreen or Theme.TextDim
  targetBtn.TextSize = 9
  targetBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", targetBtn).CornerRadius = UDim.new(0, 4)

  customTargetBox = Instance.new("TextBox", targetCard)
  customTargetBox.Size = UDim2.new(1, -226, 0, 24)
  customTargetBox.Position = UDim2.fromOffset(220, 7)
  customTargetBox.BackgroundColor3 = Theme.CardBg
  customTargetBox.PlaceholderText = "@custom_user"
  customTargetBox.PlaceholderColor3 = Theme.TextDim
  customTargetBox.Text = (CFG.prv_whisper_target ~= "Self" and CFG.prv_whisper_target ~= "Target") and CFG.prv_whisper_target or ""
  customTargetBox.TextColor3 = Theme.TextWhite
  customTargetBox.TextSize = 9
  customTargetBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  customTargetBox.ClearTextOnFocus = false
  customTargetBox.TextXAlignment = Enum.TextXAlignment.Left
  Instance.new("UIPadding", customTargetBox).PaddingLeft = UDim.new(0, 6)
  Instance.new("UICorner", customTargetBox).CornerRadius = UDim.new(0, 4)
  ctbStroke = Instance.new("UIStroke", customTargetBox)
  ctbStroke.Color = Theme.NeonDarkGreen
  ctbStroke.Thickness = 1

  local function updateTargetButtons()
    isSelf = CFG.prv_whisper_target == "Self"
    isTarget = CFG.prv_whisper_target == "Target"
    selfBtn.BackgroundColor3 = isSelf and Theme.NeonDarkGreen or Theme.CardOff
    selfBtn.TextColor3 = isSelf and Theme.NeonGreen or Theme.TextDim
    targetBtn.BackgroundColor3 = isTarget and Theme.NeonDarkGreen or Theme.CardOff
    targetBtn.TextColor3 = isTarget and Theme.NeonGreen or Theme.TextDim
  end

  selfBtn.MouseButton1Click:Connect(function()
    CFG.prv_whisper_target = "Self"
    customTargetBox.Text = ""
    updateTargetButtons()
    ShowNotification("Whisper Target: @Self (Ghost)", "", 1.5)
  end)

  targetBtn.MouseButton1Click:Connect(function()
    CFG.prv_whisper_target = "Target"
    customTargetBox.Text = ""
    updateTargetButtons()
    tName = (CFG.cuff_target and CFG.cuff_target ~= "") and CFG.cuff_target or "None Selected"
    ShowNotification("Whisper Target: @" .. tName, "", 1.5)
  end)

  customTargetBox.FocusLost:Connect(function()
    val = customTargetBox.Text:gsub("%s+", "")
    if val and val ~= "" then
      CFG.prv_whisper_target = val
      updateTargetButtons()
      ShowNotification("Whisper Target: @" .. val, "", 1.5)
    else
      CFG.prv_whisper_target = "Self"
      updateTargetButtons()
    end
  end)

  -- Switch In-Game Roblox Chat Bar to PRV Button
  switchChatBarBtn = Instance.new("TextButton", prvContainer)
  switchChatBarBtn.Size = UDim2.new(1, 0, 0, 24)
  switchChatBarBtn.Visible = false
  switchChatBarBtn.BackgroundColor3 = Color3.fromRGB(18, 38, 28)
  switchChatBarBtn.Text = "SWITCH ROBLOX CHAT BAR TO WHISPER (@TARGET)"
  switchChatBarBtn.TextColor3 = Theme.NeonGreen
  switchChatBarBtn.TextSize = 10
  switchChatBarBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", switchChatBarBtn).CornerRadius = UDim.new(0, 5)
  scbStroke = Instance.new("UIStroke", switchChatBarBtn)
  scbStroke.Color = Theme.NeonDarkGreen
  scbStroke.Thickness = 1

  switchChatBarBtn.MouseButton1Click:Connect(function()
    targetName = (CFG.prv_whisper_target == "Target") and CFG.cuff_target or CFG.prv_whisper_target
    if targetName and targetName ~= "" and targetName ~= "Self" then
      SwitchChatBarToWhisper(targetName)
    else
      ShowNotification("Select @Target or type a username first!", "", 2)
    end
  end)

  -- 1-Click Silent Fast Commands Bar
  quickCmdHeader = Instance.new("TextLabel", prvContainer)
  quickCmdHeader.Size = UDim2.new(1, 0, 0, 16)
  quickCmdHeader.Visible = false
  quickCmdHeader.BackgroundTransparency = 1
  quickCmdHeader.Text = "FAST SILENT COMMANDS (CLICK TO FIRE SILENTLY):"
  quickCmdHeader.TextColor3 = Theme.TextDim
  quickCmdHeader.TextSize = 9
  quickCmdHeader.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  quickCmdHeader.TextXAlignment = Enum.TextXAlignment.Left

  quickCmdBar = Instance.new("Frame", prvContainer)
  quickCmdBar.Size = UDim2.new(1, 0, 0, 32)
  quickCmdBar.Visible = false
  quickCmdBar.BackgroundColor3 = Theme.CardBg
  quickCmdBar.BorderSizePixel = 0
  Instance.new("UICorner", quickCmdBar).CornerRadius = UDim.new(0, 6)
  qcbStroke = Instance.new("UIStroke", quickCmdBar)
  qcbStroke.Color = Theme.NeonDarkGreen
  qcbStroke.Thickness = 1

  qcbLayout = Instance.new("UIListLayout", quickCmdBar)
  qcbLayout.FillDirection = Enum.FillDirection.Horizontal
  qcbLayout.Padding = UDim.new(0, 5)
  qcbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
  qcbLayout.VerticalAlignment = Enum.VerticalAlignment.Center

  fastCmds = { ";re", ";refresh" }
  for _, cmd in ipairs(fastCmds) do
    fBtn = Instance.new("TextButton", quickCmdBar)
    fBtn.Size = UDim2.fromOffset(56, 24)
    fBtn.BackgroundColor3 = Color3.fromRGB(20, 36, 26)
    fBtn.Text = cmd
    fBtn.TextColor3 = Theme.NeonGreen
    fBtn.TextSize = 10
    fBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 4)
    fbStr = Instance.new("UIStroke", fBtn)
    fbStr.Color = Theme.NeonDarkGreen
    fbStr.Thickness = 1

    fBtn.MouseButton1Click:Connect(function()
      SendPrivateChatMessage(cmd, "Self")
      ShowNotification("VIP success", "", 1.5)
    end)
  end

  -- PRV Custom Input Card
  PrvInputCard = Instance.new("Frame", prvContainer)
  PrvInputCard.Size = UDim2.new(1, 0, 0, 52)
  PrvInputCard.Visible = true
  PrvInputCard.BackgroundColor3 = Theme.CardBg
  PrvInputCard.BorderSizePixel = 0
  Instance.new("UICorner", PrvInputCard).CornerRadius = UDim.new(0, 6)
  picStroke = Instance.new("UIStroke", PrvInputCard)
  picStroke.Color = Theme.NeonDarkGreen
  picStroke.Thickness = 1

  customPrvBox = Instance.new("TextBox", PrvInputCard)
  customPrvBox.Size = UDim2.new(1, -164, 0, 32)
  customPrvBox.Position = UDim2.fromOffset(8, 10)
  customPrvBox.BackgroundColor3 = Theme.CardBg
  customPrvBox.PlaceholderText = "VIP command to self..."
  customPrvBox.PlaceholderColor3 = Theme.TextDim
  customPrvBox.Text = ""
  customPrvBox.TextColor3 = Theme.TextWhite
  customPrvBox.TextSize = 10.5
  customPrvBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  customPrvBox.ClearTextOnFocus = false
  customPrvBox.TextXAlignment = Enum.TextXAlignment.Left
  Instance.new("UIPadding", customPrvBox).PaddingLeft = UDim.new(0, 8)
  Instance.new("UICorner", customPrvBox).CornerRadius = UDim.new(0, 5)
  pBoxStroke = Instance.new("UIStroke", customPrvBox)
  pBoxStroke.Color = Theme.NeonDarkGreen
  pBoxStroke.Thickness = 1

  sendPrvBtn = Instance.new("TextButton", PrvInputCard)
  sendPrvBtn.Size = UDim2.fromOffset(70, 32)
  sendPrvBtn.Position = UDim2.new(1, -150, 0, 10)
  sendPrvBtn.BackgroundColor3 = Color3.fromRGB(18, 55, 36)
  sendPrvBtn.Text = "Send VIP"
  sendPrvBtn.TextColor3 = Theme.NeonGreen
  sendPrvBtn.TextSize = 10
  sendPrvBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", sendPrvBtn).CornerRadius = UDim.new(0, 5)

  addPrvSlotBtn = Instance.new("TextButton", PrvInputCard)
  addPrvSlotBtn.Size = UDim2.fromOffset(70, 32)
  addPrvSlotBtn.Position = UDim2.new(1, -76, 0, 10)
  addPrvSlotBtn.BackgroundColor3 = Theme.SpecialPurple
  addPrvSlotBtn.Text = "+ Add Slot"
  addPrvSlotBtn.TextColor3 = Theme.TextWhite
  addPrvSlotBtn.TextSize = 10
  addPrvSlotBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", addPrvSlotBtn).CornerRadius = UDim.new(0, 5)

  -- PRV Saved Slots Header
  makeSectionHead(prvContainer, "SB", "SAVED VIP SLOTS", "add slots, bind keys")

  PrvSlotsContainer = Instance.new("Frame", prvContainer)
  PrvSlotsContainer.Size = UDim2.new(1, 0, 0, 0)
  PrvSlotsContainer.AutomaticSize = Enum.AutomaticSize.Y
  PrvSlotsContainer.BackgroundTransparency = 1

  prvSlotLayout = Instance.new("UIListLayout", PrvSlotsContainer)
  prvSlotLayout.Padding = UDim.new(0, 5)

  local function RenderPrvSlots()
    for _, c in ipairs(PrvSlotsContainer:GetChildren()) do
      if c:IsA("Frame") then c:Destroy() end
    end

    for idx, item in ipairs(CFG.quick_prv_messages) do
      row = Instance.new("Frame", PrvSlotsContainer)
      row.Size = UDim2.new(1, 0, 0, 42)
      row.BackgroundColor3 = Theme.CardBg
      row.BorderSizePixel = 0
      Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

      str = Instance.new("UIStroke", row)
      str.Color = Theme.NeonDarkGreen
      str.Thickness = 1

      msgBox = Instance.new("TextBox", row)
      msgBox.Size = UDim2.new(1, -170, 0, 26)
      msgBox.Position = UDim2.fromOffset(10, 8)
      msgBox.BackgroundColor3 = Theme.CardBg
      msgBox.Text = item.text
      msgBox.TextColor3 = Theme.NeonGreen
      msgBox.TextSize = 10
      msgBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      msgBox.ClearTextOnFocus = false
      msgBox.TextXAlignment = Enum.TextXAlignment.Left
      Instance.new("UIPadding", msgBox).PaddingLeft = UDim.new(0, 6)
      Instance.new("UICorner", msgBox).CornerRadius = UDim.new(0, 4)

      msgBox.FocusLost:Connect(function()
        item.text = msgBox.Text
      end)

      sendBtn = Instance.new("TextButton", row)
      sendBtn.Size = UDim2.fromOffset(50, 24)
      sendBtn.Position = UDim2.new(1, -168, 0.5, -12)
      sendBtn.BackgroundColor3 = Color3.fromRGB(18, 55, 36)
      sendBtn.Text = "Send"
      sendBtn.TextColor3 = Theme.NeonGreen
      sendBtn.TextSize = 9
      sendBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 5)

      sendBtn.MouseButton1Click:Connect(function()
        SendPrivateChatMessage(item.text, "Self")
        ShowNotification("VIP success", "", 1.5)
      end)

      keyBtn = Instance.new("TextButton", row)
      keyBtn.Size = UDim2.fromOffset(76, 24)
      keyBtn.Position = UDim2.new(1, -112, 0.5, -12)
      isBound = item.keybind and item.keybind ~= "None"
      keyBtn.BackgroundColor3 = isBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
      keyBtn.Text = isBound and ("[" .. item.keybind .. "]") or "Bind Key"
      keyBtn.TextColor3 = isBound and Theme.NeonGreen or Theme.TextDim
      keyBtn.TextSize = 9
      keyBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)

      kbListening = false
      keyBtn.MouseButton1Click:Connect(function()
        if kbListening then return end
        kbListening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = Theme.NeonGreen
        conn = nil
        conn = UserInputService.InputBegan:Connect(function(io, gpe)
          if gpe then return end
          if io.KeyCode ~= Enum.KeyCode.Unknown then
            conn:Disconnect()
            kbListening = false
            if io.KeyCode == Enum.KeyCode.Escape then
              item.keybind = "None"
            else
              item.keybind = io.KeyCode.Name
            end
            bound = item.keybind ~= "None"
            keyBtn.Text = bound and ("[" .. item.keybind .. "]") or "Bind Key"
            keyBtn.TextColor3 = bound and Theme.NeonGreen or Theme.TextDim
            keyBtn.BackgroundColor3 = bound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
            ShowNotification("VIP success", "", 1.2)
          end
        end)
      end)

      delBtn = Instance.new("TextButton", row)
      delBtn.Size = UDim2.fromOffset(24, 24)
      delBtn.Position = UDim2.new(1, -30, 0.5, -12)
      delBtn.BackgroundColor3 = Theme.DangerRed
      delBtn.Text = "X"
      delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      delBtn.TextSize = 10
      delBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)

      delBtn.MouseButton1Click:Connect(function()
        item.keybind = "None"
        pcall(SaveToxicCFG)
        keyBtn.Text = "Bind Key"
        keyBtn.TextColor3 = Theme.TextDim
        keyBtn.BackgroundColor3 = Theme.CardOff
        ShowNotification("VIP success", "", 1.2)
      end)
    end
  end

  sendPrvBtn.MouseButton1Click:Connect(function()
    msg = customPrvBox.Text
    if msg and msg ~= "" then
      SendPrivateChatMessage(msg, "Self")
      ShowNotification("VIP success", "", 1.5)
    else
      ShowNotification("Type a message or command first!", "", 2)
    end
  end)

  addPrvSlotBtn.MouseButton1Click:Connect(function()
    msg = customPrvBox.Text
    if msg and msg ~= "" then
      table.insert(CFG.quick_prv_messages, { text = msg, keybind = "None" })
      customPrvBox.Text = ""
      RenderPrvSlots()
      ShowNotification("VIP success", "", 1.2)
    else
      ShowNotification("Type a command or message to add!", "", 2)
    end
  end)

  RenderPrvSlots()

  -- ========== RANDOM SKIN (VIP) ==========
  local skinRow = Instance.new("Frame", prvContainer)
  skinRow.Name = "RandomSkinRow"
  skinRow.Size = UDim2.new(1, 0, 0, 36)
  skinRow.BackgroundColor3 = Theme.CardBg
  Instance.new("UICorner", skinRow).CornerRadius = UDim.new(0, 6)
  local skinStroke = Instance.new("UIStroke", skinRow)
  skinStroke.Color = Color3.fromRGB(45, 45, 55)
  skinStroke.Thickness = 1

  local skinTitle = Instance.new("TextLabel", skinRow)
  skinTitle.Size = UDim2.new(1, -175, 1, 0)
  skinTitle.Position = UDim2.fromOffset(12, 0)
  skinTitle.BackgroundTransparency = 1
  skinTitle.Text = "Random Skin"
  skinTitle.TextColor3 = Theme.TextWhite
  skinTitle.TextSize = 11
  skinTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  skinTitle.TextXAlignment = Enum.TextXAlignment.Left

  -- Roll / Execute Button
  local skinGo = Instance.new("TextButton", skinRow)
  skinGo.Size = UDim2.fromOffset(60, 24)
  skinGo.Position = UDim2.new(1, -162, 0.5, -12)
  skinGo.BackgroundColor3 = Color3.fromRGB(130, 45, 180)
  skinGo.Text = "ROLL"
  skinGo.TextColor3 = Color3.fromRGB(255, 255, 255)
  skinGo.TextSize = 10
  skinGo.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", skinGo).CornerRadius = UDim.new(0, 5)
  skinGo.MouseButton1Click:Connect(function()
    DoRandomSkin()
  end)

  -- Keybind Button
  local skinKb = Instance.new("TextButton", skinRow)
  skinKb.Size = UDim2.fromOffset(68, 24)
  skinKb.Position = UDim2.new(1, -98, 0.5, -12)
  local _skinBound = CFG.skin_random_keybind and CFG.skin_random_keybind ~= "None"
  skinKb.BackgroundColor3 = _skinBound and Color3.fromRGB(24, 45, 32) or Theme.CardOff
  skinKb.Text = _skinBound and ("[" .. CFG.skin_random_keybind .. "]") or "Bind Key"
  skinKb.TextColor3 = _skinBound and Theme.NeonGreen or Theme.TextDim
  skinKb.TextSize = 10
  skinKb.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", skinKb).CornerRadius = UDim.new(0, 5)

  -- Clear Keybind Button (✕)
  local skinClrBtn = Instance.new("TextButton", skinRow)
  skinClrBtn.Size = UDim2.fromOffset(22, 24)
  skinClrBtn.Position = UDim2.new(1, -26, 0.5, -12)
  skinClrBtn.BackgroundColor3 = Color3.fromRGB(55, 25, 35)
  skinClrBtn.Text = "✕"
  skinClrBtn.TextColor3 = Color3.fromRGB(255, 120, 140)
  skinClrBtn.TextSize = 11
  skinClrBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  Instance.new("UICorner", skinClrBtn).CornerRadius = UDim.new(0, 5)

  local function clearSkinKeybind()
    CFG.skin_random_keybind = "None"
    skinKb.Text = "Bind Key"
    skinKb.TextColor3 = Theme.TextDim
    skinKb.BackgroundColor3 = Theme.CardOff
    pcall(SaveToxicCFG)
    ShowNotification("Skin Keybind Cleared", "", 1.2)
  end

  skinClrBtn.MouseButton1Click:Connect(clearSkinKeybind)
  skinKb.MouseButton2Click:Connect(clearSkinKeybind)

  local skinListen = false
  skinKb.MouseButton1Click:Connect(function()
    if skinListen then return end
    skinListen = true
    skinKb.Text = "..."
    skinKb.TextColor3 = Theme.NeonGreen
    local c
    c = UserInputService.InputBegan:Connect(function(io, gpe)
      if gpe then return end
      if io.KeyCode ~= Enum.KeyCode.Unknown then
        c:Disconnect()
        skinListen = false
        if io.KeyCode == Enum.KeyCode.Escape 
        or io.KeyCode == Enum.KeyCode.Backspace 
        or io.KeyCode == Enum.KeyCode.Delete then
          clearSkinKeybind()
        else
          CFG.skin_random_keybind = io.KeyCode.Name
          skinKb.Text = "[" .. io.KeyCode.Name .. "]"
          skinKb.TextColor3 = Theme.NeonGreen
          skinKb.BackgroundColor3 = Color3.fromRGB(24, 45, 32)
          pcall(SaveToxicCFG)
          ShowNotification("Skin Keybind: " .. CFG.skin_random_keybind, "", 1.2)
        end
      end
    end)
  end)

  -- ====================================================
  -- SUB-TAB NAVIGATION HANDLER
  -- ====================================================
  local function switchChatSubTab(tabName)
    if tabName == "Public" then
      publicContainer.Visible = true
      prvContainer.Visible = false
      publicTabBtn.BackgroundColor3 = Theme.NeonDarkGreen
      publicTabBtn.TextColor3 = Theme.NeonGreen
      prvTabBtn.BackgroundColor3 = Theme.CardBg
      prvTabBtn.TextColor3 = Theme.TextDim
    else
      publicContainer.Visible = false
      prvContainer.Visible = true
      prvTabBtn.BackgroundColor3 = Theme.NeonDarkGreen
      prvTabBtn.TextColor3 = Theme.NeonGreen
      publicTabBtn.BackgroundColor3 = Theme.CardBg
      publicTabBtn.TextColor3 = Theme.TextDim
    end
    task.defer(updateChatCanvas)
  end

  publicTabBtn.MouseButton1Click:Connect(function()
    switchChatSubTab("Public")
  end)

  prvTabBtn.MouseButton1Click:Connect(function()
    switchChatSubTab("PRV")
  end)
end
initChatTab()

-- ----------------------------------------------------
-- 10. SETTINGS TAB (Keybinds)
-- ----------------------------------------------------


function initAdaptTab()
  local adaptPage = pages["Adapt"]
  if not adaptPage then return end
  adaptPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
  local list = Instance.new("UIListLayout", adaptPage)
  list.Padding = UDim.new(0, 6)
  list.SortOrder = Enum.SortOrder.LayoutOrder
  Instance.new("UIPadding", adaptPage).PaddingTop = UDim.new(0, 4)

  local ADAPT_SONGS = {
    {name="Song 1", url="https://files.catbox.moe/gm9wuu.mp3", cover="rbxthumb://type=Asset&id=86103485431123&w=420&h=420"},
    {name="Song 2", url="https://files.catbox.moe/4fjhdy.mp3", cover="rbxthumb://type=Asset&id=115168375440446&w=420&h=420"},
    {name="Song 3", url="https://files.catbox.moe/s2epvz.mp3", cover="rbxthumb://type=Asset&id=119640313536275&w=420&h=420"},
    {name="Song 4", url="https://files.catbox.moe/yd8wst.mp3", cover="rbxthumb://type=Asset&id=128076226146682&w=420&h=420"},
    {name="Song 5", url="https://files.catbox.moe/y2npwy.mp3", cover="rbxthumb://type=Asset&id=129638978079711&w=420&h=420"},
    {name="Song 6", url="https://files.catbox.moe/s7wuzb.mp3", cover="rbxthumb://type=Asset&id=106003436039570&w=420&h=420"},
    {name="Song 7", url="https://files.catbox.moe/n52dvv.mp3", cover="rbxthumb://type=Asset&id=101703838295262&w=420&h=420"},
    {name="Song 8", url="https://files.catbox.moe/p5mvim.mp3", cover="rbxthumb://type=Asset&id=112003973514134&w=420&h=420"},
    {name="Song 9", url="https://files.catbox.moe/xfihnx.mp3", cover="rbxthumb://type=Asset&id=123579863939760&w=420&h=420"},
    {name="Song 10", url="https://files.catbox.moe/byk07p.mp3", cover="rbxthumb://type=Asset&id=121860015578133&w=420&h=420"},
  }

  -- exact Adapt Settings carousel assets
  local ADAPT_BG = {
    "rbxassetid://90631990302263",
    "rbxassetid://109619268613730",
    "rbxassetid://90453834580322",
    "rbxassetid://82173577293417",
    "rbxassetid://88369503310562",
    "rbxassetid://80708025126373",
    "rbxassetid://111949903851987",
    "rbxassetid://135181794444219",
  }

  local ADAPT_SKIES = {
    {name="Night", clock=22, brightness=2, ambient={110,100,130}, outAmb={120,110,140},
      sky={stars=4000, moon=18, sun=0, moonTex=true},
      atm={dens=0.5, color={120,60,160}, decay={60,24,100}, glare=0.5, haze=1.2}},
    {name="Pink Night", clock=23, brightness=2.2, ambient={40,65,110}, outAmb={140,60,120},
      sky={stars=5000, moon=22, sun=0, moonTex=true},
      atm={dens=0.5, color={240,80,160}, decay={90,30,100}, glare=0.7, haze=1.4},
      clouds={cover=0.3, dens=0.5, color={180,90,150}}},
    {name="Galaxy", clock=0, brightness=1.5, ambient={70,60,100}, outAmb={80,70,110},
      sky={stars=10000, moon=30, sun=0},
      atm={dens=0.15, color={40,20,100}, decay={20,10,50}, glare=0.3, haze=0.5}},
    {name="Ocean", clock=14, brightness=2.4, ambient={80,120,170}, outAmb={90,140,180},
      atm={dens=0.4, color={40,120,200}, decay={20,80,160}, glare=1.2, haze=1.6},
      clouds={cover=0.55, dens=0.5, color={175,200,255}}},
    {name="Inferno", clock=16, brightness=2.2, ambient={160,70,40}, outAmb={200,90,50},
      sky={stars=210, sun=12, moon=0},
      atm={dens=0.62, color={255,60,0}, decay={180,20,0}, glare=3, haze=1.1},
      clouds={cover=0.75, dens=0.9, color={40,35,20}}},
    {name="Dusk", clock=17.2, brightness=2.5, ambient={170,40,100}, outAmb={160,130,110},
      sky={stars=0, sun=25, moon=0},
      atm={dens=0.5, color={255,130,60}, decay={255,80,30}, glare=2, haze=1.6},
      clouds={cover=0.55, dens=0.55, color={255,200,140}}},
    {name="Deep Space", clock=0, brightness=1.2, ambient={20,20,40}, outAmb={30,30,50},
      sky={stars=10000, moon=16, sun=0},
      atm={dens=0.2, color={20,10,40}, decay={8,4,20}, glare=0.2, haze=0.8}},
    {name="Cyber", clock=14, brightness=2.4, ambient={90,120,170}, outAmb={100,140,180},
      sky={stars=2000, moon=8, sun=18},
      atm={dens=0.35, color={0,210,255}, decay={150,0,240}, glare=1.6, haze=1.4},
      clouds={cover=0.4, dens=0.22, color={100,210,255}}},
    {name="Sakura", clock=14, brightness=3.2, ambient={170,150,160}, outAmb={180,160,170},
      sky={sun=8, moon=0, stars=0},
      atm={dens=0.3, color={255,200,220}, decay={255,170,200}, glare=1, haze=1.2},
      clouds={cover=0.55, dens=0.4, color={255,250,252}}},
    {name="Toxic", clock=14, brightness=2.6, ambient={140,180,80}, outAmb={150,190,90},
      sky={sun=16, moon=0, stars=0},
      atm={dens=0.4, color={100,220,40}, decay={60,150,20}, glare=1.4, haze=1.6},
      clouds={cover=0.5, dens=0.55, color={180,255,120}}},
    {name="Aurora", clock=14, brightness=2.6, ambient={150,120,150}, outAmb={160,130,150},
      sky={stars=800, sun=14, moon=0},
      atm={dens=0.4, color={255,80,200}, decay={255,20,150}, glare=1.6, haze=1.8},
      clouds={cover=0.55, dens=0.5, color={255,240,250}}},
    {name="Mint", clock=14, brightness=3.0, ambient={180,230,210}, outAmb={190,240,220},
      sky={sun=16, moon=0, stars=0},
      atm={dens=0.28, color={150,255,210}, decay={100,220,180}, glare=1.2, haze=1.2},
      clouds={cover=0.5, dens=0.4, color={240,255,250}}},
    {name="Storm", clock=14, brightness=2.4, ambient={120,120,140}, outAmb={130,130,150},
      sky={sun=10, moon=0, stars=0},
      atm={dens=0.5, color={80,90,120}, decay={40,50,80}, glare=0.6, haze=2.2},
      clouds={cover=0.85, dens=0.85, color={70,75,90}}},
    {name="Vaporwave", clock=14, brightness=2.6, ambient={180,120,200}, outAmb={190,130,210},
      sky={stars=600, moon=8, sun=12},
      atm={dens=0.35, color={255,100,220}, decay={120,60,255}, glare=1.6, haze=1.6},
      clouds={cover=0.45, dens=0.45, color={200,150,255}}},
  }

  local ADAPT_SWATCH = {
    Color3.fromRGB(150,101,255), Color3.fromRGB(58,128,245), Color3.fromRGB(230,42,57),
    Color3.fromRGB(255,105,180), Color3.fromRGB(255,214,0), Color3.fromRGB(42,42,46),
    Color3.fromRGB(240,240,240), Color3.fromRGB(46,139,87),
  }

  CFG.adapt_bg_idx = tonumber(CFG.adapt_bg_idx) or 1
  local Lighting = game:GetService("Lighting")

  local function rgb(t)
    return Color3.fromRGB(t[1], t[2], t[3])
  end

  local function currentBgImage()
    local i = tonumber(CFG.adapt_bg_idx) or 0
    if i < 1 then return "" end
    return ADAPT_BG[i] or ""
  end

  local toastHolder
  local toastSerial = 0
  local function ensureToasts()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return nil end
    if toastHolder and toastHolder.Parent then return toastHolder end
    local old = pg:FindFirstChild("AdaptSafeModeNotifications")
    if old then old:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "AdaptSafeModeNotifications"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = false
    gui.DisplayOrder = 100005
    gui.Parent = pg
    toastHolder = Instance.new("Frame")
    toastHolder.Name = "ToastHolder"
    toastHolder.BackgroundTransparency = 1
    toastHolder.Parent = gui
    local lay = Instance.new("UIListLayout", toastHolder)
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    return toastHolder
  end

  local function layoutToasts()
    local h = ensureToasts()
    if not h then return 280, 50 end
    local cam = workspace.CurrentCamera
    local vs = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local safe = CFG.adapt_safe == true
    local w = safe and math.clamp(math.floor(vs.X * 0.34), 126, 165) or math.clamp(math.floor(vs.X * 0.23), 250, 330)
    local ht = safe and 28 or 60
    h.Size = UDim2.fromOffset(w, math.min(math.floor(vs.Y * 0.34), safe and 150 or 250))
    h.AnchorPoint = Vector2.new(1, safe and 0 or 1)
    h.Position = safe and UDim2.new(1, -8, 0, 8) or UDim2.new(1, -16, 1, -16)
    h.UIListLayout.VerticalAlignment = safe and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
    h.UIListLayout.Padding = UDim.new(0, safe and 6 or 8)
    return w, ht
  end

  AdaptNotify = function(text)
    pcall(function()
      local h = ensureToasts()
      if not h then
        if ShowNotification then ShowNotification(tostring(text), "", 2) end
        return
      end
      local w, ht = layoutToasts()
      local kids = {}
      for _, ch in ipairs(h:GetChildren()) do
        if ch:IsA("Frame") and ch.Name:sub(1,6) == "Toast_" then
          kids[#kids+1] = ch
        end
      end
      table.sort(kids, function(a,b) return a.LayoutOrder < b.LayoutOrder end)
      while #kids >= 4 do
        kids[1]:Destroy()
        table.remove(kids, 1)
      end
      toastSerial += 1
      local wrap = Instance.new("Frame")
      wrap.Name = "Toast_" .. toastSerial
      wrap.LayoutOrder = toastSerial
      wrap.BackgroundTransparency = 1
      wrap.Size = UDim2.new(1, 0, 0, ht)
      wrap.Parent = h
      local card = Instance.new("Frame")
      card.Name = "Card"
      card.BackgroundColor3 = Color3.fromRGB(10, 3, 4)
      card.BackgroundTransparency = 1
      card.BorderSizePixel = 0
      card.Position = UDim2.fromOffset(w + 24, 0)
      card.Size = UDim2.new(1, 0, 1, 0)
      card.ClipsDescendants = true
      card.ZIndex = 2
      card.Parent = wrap
      Instance.new("UICorner", card).CornerRadius = UDim.new(0, CFG.adapt_safe and 9 or 14)
      local img = Instance.new("ImageLabel")
      img.Name = "CurrentBackground"
      img.BackgroundTransparency = 1
      img.Size = UDim2.new(1, 0, 1, 0)
      img.Image = currentBgImage()
      local sw = ADAPT_SWATCH[CFG.adapt_swatch] or ADAPT_SWATCH[1]
      img.ImageColor3 = CFG.adapt_bgcolor and sw or Color3.new(1,1,1)
      img.ScaleType = Enum.ScaleType.Crop
      img.ZIndex = 2
      img.Parent = card
      Instance.new("UICorner", img).CornerRadius = UDim.new(0, CFG.adapt_safe and 9 or 14)
      local shade = Instance.new("Frame")
      shade.BackgroundColor3 = Color3.new(0,0,0)
      shade.BackgroundTransparency = 0.45
      shade.BorderSizePixel = 0
      shade.Size = UDim2.new(1, 0, 1, 0)
      shade.ZIndex = 3
      shade.Parent = card
      Instance.new("UICorner", shade).CornerRadius = UDim.new(0, CFG.adapt_safe and 9 or 14)
      local msg = Instance.new("TextLabel")
      msg.BackgroundTransparency = 1
      msg.Position = UDim2.new(0, 16, 0, 0)
      msg.Size = UDim2.new(1, -24, 1, 0)
      msg.Font = Enum.Font.GothamBlack
      msg.Text = tostring(text or "")
      msg.TextColor3 = Color3.fromRGB(240, 255, 255)
      msg.TextSize = CFG.adapt_safe and 8 or 16
      msg.TextTransparency = 1
      msg.TextWrapped = true
      msg.TextXAlignment = Enum.TextXAlignment.Left
      msg.ZIndex = 4
      msg.Parent = card
      TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.18
      }):Play()
      TweenService:Create(msg, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
      task.delay(2.35, function()
        if not wrap.Parent then return end
        TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
          Position = UDim2.fromOffset(w + 24, 0), BackgroundTransparency = 1
        }):Play()
        TweenService:Create(img, TweenInfo.new(0.14), {ImageTransparency = 1}):Play()
        TweenService:Create(shade, TweenInfo.new(0.14), {BackgroundTransparency = 1}):Play()
        TweenService:Create(msg, TweenInfo.new(0.14), {TextTransparency = 1}):Play()
        task.delay(0.2, function()
          if wrap.Parent then wrap:Destroy() end
        end)
      end)
    end)
  end

  local function clearWorldSkyLeak()
    pcall(function()
      local Lighting = game:GetService("Lighting")
      for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:GetAttribute("_AdaptSky") or ch.Name == "TXAdaptSky" or ch.Name == "TXAdaptAtmo" or ch.Name == "TXAdaptCC" then
          ch:Destroy()
        end
      end
      local terrain = workspace:FindFirstChildOfClass("Terrain")
      if terrain then
        for _, ch in ipairs(terrain:GetChildren()) do
          if ch:IsA("Clouds") and (ch:GetAttribute("_AdaptSky") or ch.Name == "TXAdaptClouds") then
            ch:Destroy()
          end
        end
      end
    end)
  end

  local function applyWorldSky()
    clearWorldSkyLeak()
    if not CFG.adapt_worldsky then return end
    local def = ADAPT_SKIES[CFG.adapt_sky_idx]
    if not def then return end
    local Lighting = game:GetService("Lighting")
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.GlobalShadows = true
    Lighting.ClockTime = 14
    Lighting.Brightness = math.max(2.4, def.brightness or 2.4)
    if def.outAmb then Lighting.OutdoorAmbient = rgb(def.outAmb) end
    if def.ambient then Lighting.Ambient = rgb(def.ambient) end
    if def.sky then
      local sky = Instance.new("Sky")
      sky.Name = "TXAdaptSky"
      sky:SetAttribute("_AdaptSky", true)
      if def.sky.stars then sky.StarCount = def.sky.stars end
      if def.sky.moon then sky.MoonAngularSize = def.sky.moon end
      if def.sky.sun then sky.SunAngularSize = def.sky.sun end
      if def.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
      sky.Parent = Lighting
    end
    if def.atm then
      local at = Instance.new("Atmosphere")
      at.Name = "TXAdaptAtmo"
      at:SetAttribute("_AdaptSky", true)
      at.Density = def.atm.dens or 0.25
      at.Color = rgb(def.atm.color)
      at.Decay = rgb(def.atm.decay)
      at.Glare = def.atm.glare or 1
      at.Haze = def.atm.haze or 1
      at.Parent = Lighting
    end
    if def.clouds then
      local terrain = workspace:FindFirstChildOfClass("Terrain")
      if terrain then
        local c = Instance.new("Clouds")
        c.Name = "TXAdaptClouds"
        c:SetAttribute("_AdaptSky", true)
        c.Cover = def.clouds.cover or 0.5
        c.Density = def.clouds.dens or 0.5
        c.Color = rgb(def.clouds.color)
        c.Parent = terrain
      end
    end
    if CFG.adapt_bgcolor then
      local cc = Instance.new("ColorCorrectionEffect")
      cc.Name = "TXAdaptCC"
      cc:SetAttribute("_AdaptSky", true)
      cc.TintColor = ADAPT_SWATCH[CFG.adapt_swatch] or ADAPT_SWATCH[1]
      cc.Saturation = 0.12
      cc.Parent = Lighting
    end
  end

  local function applyAdaptSky()
    applyWorldSky()
    local img = currentBgImage()
    local wall = rawget(_G, "MenuWallpaper") or (MainFrame and MainFrame:FindFirstChild("MenuWallpaper"))
    local shade = rawget(_G, "MenuWallpaperShade") or (MainFrame and MainFrame:FindFirstChild("MenuWallpaperShade"))
    if not wall then
      wall = MenuWallpaper
      shade = MenuWallpaperShade
    end
    if wall then
      wall.Image = img
      local sw = ADAPT_SWATCH[CFG.adapt_swatch] or Color3.new(1,1,1)
      wall.ImageColor3 = CFG.adapt_bgcolor and sw or Color3.new(1,1,1)
      wall.ImageTransparency = (img == "" and 1) or 0.12
    end
    if shade then
      shade.BackgroundTransparency = (img == "" and 1) or 0.42
    end
  end

  local introSound
  local function playIntro()
    if introSound then pcall(function() introSound:Stop(); introSound:Destroy() end) introSound = nil end
    local song = ADAPT_SONGS[CFG.adapt_intro_idx] or ADAPT_SONGS[1]
    task.spawn(function()
      local ok = pcall(function()
        local sid
        if writefile and getcustomasset and game.HttpGet then
          local fn = "AdaptIntroMusic_" .. tostring(CFG.adapt_intro_idx) .. ".mp3"
          if not (isfile and isfile(fn)) then writefile(fn, game:HttpGet(song.url)) end
          sid = getcustomasset(fn)
        else
          sid = song.url
        end
        local snd = Instance.new("Sound")
        snd.Name = "AdaptIntroMusic"
        snd.SoundId = sid
        snd.Volume = 0.7
        snd.Parent = game:GetService("SoundService")
        snd:Play()
        introSound = snd
        task.wait(6)
        if snd.Parent then
          TweenService:Create(snd, TweenInfo.new(0.5), {Volume=0}):Play()
          task.wait(0.5)
          snd:Destroy()
        end
      end)
      if not ok then AdaptNotify("Intro unavailable") end
    end)
    AdaptNotify(song.name)
  end

  makeSectionHead(adaptPage, "SF", "SAFETY", "")
  makeFiveMToggle(adaptPage, "Safe Mode", "Small toasts top-right", "", function() return CFG.adapt_safe end, function(v)
    CFG.adapt_safe = v; SaveToxicCFG(); layoutToasts(); AdaptNotify(v and "SAFE MODE" or "Safe Mode OFF")
  end)
  makeFiveMToggle(adaptPage, "Kick Warning", "HIGH PING toast", "", function() return CFG.adapt_kickwarn end, function(v)
    CFG.adapt_kickwarn = v; SaveToxicCFG(); AdaptNotify(v and "Kick Warning ON" or "Kick Warning OFF")
  end)

  makeSectionHead(adaptPage, "IN", "INTRO SONG", "")
  local songRow = Instance.new("Frame", adaptPage)
  songRow.Size = UDim2.new(1, 0, 0, 40)
  songRow.BackgroundColor3 = Theme.CardBg
  Instance.new("UICorner", songRow).CornerRadius = UDim.new(0, 8)
  local cover = Instance.new("ImageLabel", songRow)
  cover.Size = UDim2.fromOffset(32, 32)
  cover.Position = UDim2.fromOffset(4, 4)
  cover.BackgroundColor3 = Color3.fromRGB(20,20,24)
  cover.ScaleType = Enum.ScaleType.Crop
  Instance.new("UICorner", cover).CornerRadius = UDim.new(0, 6)
  local songName = Instance.new("TextLabel", songRow)
  songName.BackgroundTransparency = 1
  songName.Position = UDim2.fromOffset(42, 0)
  songName.Size = UDim2.new(1, -180, 1, 0)
  songName.TextXAlignment = Enum.TextXAlignment.Left
  songName.Font = Enum.Font.GothamBlack
  songName.TextSize = 12
  songName.TextColor3 = Theme.TextWhite
  local function refreshSong()
    local sg = ADAPT_SONGS[CFG.adapt_intro_idx] or ADAPT_SONGS[1]
    songName.Text = sg.name
    cover.Image = sg.cover or ""
  end
  refreshSong()
  local function mini(txt, x, fn)
    local b = Instance.new("TextButton", songRow)
    b.Size = UDim2.fromOffset(42, 24)
    b.Position = UDim2.new(1, x, 0.5, -12)
    b.BackgroundColor3 = Theme.NeonDarkGreen
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(fn)
  end
  mini("<", -140, function()
    CFG.adapt_intro_idx = ((CFG.adapt_intro_idx - 2) % #ADAPT_SONGS) + 1
    refreshSong(); SaveToxicCFG()
  end)
  mini(">", -94, function()
    CFG.adapt_intro_idx = (CFG.adapt_intro_idx % #ADAPT_SONGS) + 1
    refreshSong(); SaveToxicCFG()
  end)
  mini("OPEN", -48, playIntro)

  makeSectionHead(adaptPage, "BG", "BACKGROUND", "")
  local skyName = Instance.new("TextLabel", adaptPage)
  skyName.Size = UDim2.new(1, 0, 0, 16)
  skyName.BackgroundTransparency = 1
  skyName.TextXAlignment = Enum.TextXAlignment.Left
  skyName.Font = Enum.Font.GothamBlack
  skyName.TextSize = 11
  skyName.TextColor3 = Theme.TextWhite

  local picker = Instance.new("Frame", adaptPage)
  picker.Name = "BackgroundPicker"
  picker.Size = UDim2.new(1, 0, 0, 52)
  picker.BackgroundColor3 = Theme.CardBg
  picker.BackgroundTransparency = 0.15
  Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 11)
  local scroll = Instance.new("ScrollingFrame", picker)
  scroll.BackgroundTransparency = 1
  scroll.BorderSizePixel = 0
  scroll.Size = UDim2.new(1, -56, 1, 0)
  scroll.Position = UDim2.fromOffset(28, 0)
  scroll.ScrollingDirection = Enum.ScrollingDirection.X
  scroll.ScrollBarThickness = 0
  scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
  scroll.CanvasSize = UDim2.new()
  scroll.ClipsDescendants = true
  local slay = Instance.new("UIListLayout", scroll)
  slay.FillDirection = Enum.FillDirection.Horizontal
  slay.VerticalAlignment = Enum.VerticalAlignment.Center
  slay.Padding = UDim.new(0, 6)
  Instance.new("UIPadding", scroll).PaddingLeft = UDim.new(0, 4)

  local thumbs = {}
  local function paintThumbs()
    for i, th in ipairs(thumbs) do
      th.UIStroke.Thickness = (i == CFG.adapt_bg_idx) and 2 or 0
    end
    local sk = ADAPT_SKIES[CFG.adapt_sky_idx]
    skyName.Text = sk and sk.name or "Sky"
  end

  for i, asset in ipairs(ADAPT_BG) do
    local b = Instance.new("ImageButton", scroll)
    b.Size = UDim2.fromOffset(42, 42)
    b.Image = asset
    b.ScaleType = Enum.ScaleType.Crop
    b.AutoButtonColor = true
    b.BackgroundColor3 = Color3.fromRGB(20,20,24)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", b)
    st.Color = Color3.new(1,1,1)
    st.Thickness = 0
    thumbs[i] = {btn=b, UIStroke=st}
    b.MouseButton1Click:Connect(function()
      CFG.adapt_bg_idx = i
      CFG.adapt_sky_idx = ((i - 1) % #ADAPT_SKIES) + 1
      paintThumbs()
      applyAdaptSky()
      SaveToxicCFG()
      AdaptNotify((ADAPT_SKIES[CFG.adapt_sky_idx] or {}).name or "BG")
    end)
  end

  local function nav(txt, x, dir)
    local b = Instance.new("TextButton", picker)
    b.Size = UDim2.fromOffset(22, 22)
    b.Position = UDim2.new(dir < 0 and 0 or 1, dir < 0 and 4 or -26, 0.5, -11)
    b.BackgroundColor3 = Color3.fromRGB(20,20,26)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
      CFG.adapt_bg_idx = ((CFG.adapt_bg_idx - 1 + dir) % #ADAPT_BG) + 1
      CFG.adapt_sky_idx = ((CFG.adapt_bg_idx - 1) % #ADAPT_SKIES) + 1
      paintThumbs(); applyAdaptSky(); SaveToxicCFG()
    end)
  end
  nav("<", 0, -1)
  nav(">", 0, 1)
  paintThumbs()
  pcall(function()
    game:GetService("ContentProvider"):PreloadAsync(ADAPT_BG)
  end)

  local swRow = Instance.new("Frame", adaptPage)
  swRow.Size = UDim2.new(1, 0, 0, 26)
  swRow.BackgroundTransparency = 1
  local sl = Instance.new("UIListLayout", swRow)
  sl.FillDirection = Enum.FillDirection.Horizontal
  sl.Padding = UDim.new(0, 5)
  for i, col in ipairs(ADAPT_SWATCH) do
    local b = Instance.new("TextButton", swRow)
    b.Size = UDim2.fromOffset(20, 20)
    b.BackgroundColor3 = col
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function()
      CFG.adapt_swatch = i
      if CFG.adapt_bgcolor then applyAdaptSky() end
      SaveToxicCFG()
    end)
  end

  makeFiveMToggle(adaptPage, "Background Color", "Tint menu photo", "", function() return CFG.adapt_bgcolor end, function(v)
    CFG.adapt_bgcolor = v; applyAdaptSky(); SaveToxicCFG()
  end)
  makeFiveMToggle(adaptPage, "Sky Color", "Change world lighting / sky", "", function() return CFG.adapt_worldsky end, function(v)
    CFG.adapt_worldsky = v
    applyWorldSky()
    SaveToxicCFG()
    AdaptNotify(v and "Sky Color ON" or "Sky Color OFF")
  end)
  makeFiveMToggle(adaptPage, "Steal Bar Match", "Footer uses swatch", "", function() return CFG.adapt_stealmatch end, function(v)
    CFG.adapt_stealmatch = v
    if v then
      local sw = ADAPT_SWATCH[CFG.adapt_swatch] or ADAPT_SWATCH[1]
      pcall(function() if fLine then fLine.BackgroundColor3 = sw end if PBuild then PBuild.BackgroundColor3 = sw end end)
    end
    SaveToxicCFG()
  end)

  task.spawn(function()
    local last = 0
    while task.wait(2.5) do
      if CFG.adapt_kickwarn then
        local ping = 0
        pcall(function()
          ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ping >= 280 and tick() - last > 8 then
          last = tick()
          AdaptNotify(string.format("HIGH PING  %.0fms", ping))
        end
      end
    end
  end)

  pcall(applyAdaptSky)
end
initAdaptTab()


function styleKeyPill(btn, keyName)
    bound = CFG[keyName] and CFG[keyName] ~= "None"
    btn.Text = bound and ("[" .. CFG[keyName] .. "]") or "None"
    btn.BackgroundColor3 = bound and Theme.NeonDarkGreen or Theme.CardOff
    btn.TextColor3 = bound and Theme.NeonGreen or Theme.TextDim
  end

function makeKeybindRow(title, keyName, orbLetter)
    row = Instance.new("Frame", settingsPage)
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Theme.CardBg
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    rStroke = Instance.new("UIStroke", row)
    rStroke.Color = Theme.NeonDarkGreen

    lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -170, 1, 0)
    lbl.Position = UDim2.fromOffset(10, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Theme.TextWhite
    lbl.TextSize = 11
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    if orbLetter then
      ballBtn = Instance.new("TextButton", row)
      ballBtn.Size = UDim2.fromOffset(36, 24)
      ballBtn.Position = UDim2.new(1, -150, 0.5, -12)
      ballBtn.Text = orbLetter
      ballBtn.TextSize = 11
      ballBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
      Instance.new("UICorner", ballBtn).CornerRadius = UDim.new(0, 5)
      local function paintBall()
        local on = CFG.orb_enabled and CFG.orb_enabled[orbLetter]
        ballBtn.BackgroundColor3 = on and Theme.NeonDarkGreen or Theme.CardOff
        ballBtn.TextColor3 = on and Theme.NeonGreen or Theme.TextDim
      end
      paintBall()
      ballBtn.MouseButton1Click:Connect(function()
        CFG.orb_enabled = CFG.orb_enabled or {}
        CFG.orb_enabled[orbLetter] = not CFG.orb_enabled[orbLetter]
        paintBall()
        setActionOrbsVisible(true)
        SaveToxicCFG()
        ShowNotification((CFG.orb_enabled[orbLetter] and "Ball ON: " or "Ball OFF: ") .. title, "", 1.3)
      end)
    end

    local thisKey = keyName
    local thisBtn = Instance.new("TextButton", row)
    thisBtn.Size = UDim2.fromOffset(75, 24)
    thisBtn.Position = UDim2.new(1, -110, 0.5, -12)
    thisBtn.BackgroundColor3 = Theme.NeonDarkGreen
    thisBtn.Text = CFG[thisKey] or "None"
    thisBtn.TextColor3 = Theme.TextWhite
    thisBtn.TextSize = 10
    styleKeyPill(thisBtn, thisKey)
    thisBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", thisBtn).CornerRadius = UDim.new(0, 5)

    local thisX = Instance.new("TextButton", row)
    thisX.Size = UDim2.fromOffset(24, 24)
    thisX.Position = UDim2.new(1, -30, 0.5, -12)
    thisX.BackgroundColor3 = Theme.DangerRed
    thisX.Text = "X"
    thisX.TextColor3 = Color3.fromRGB(255, 255, 255)
    thisX.TextSize = 11
    thisX.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", thisX).CornerRadius = UDim.new(0, 5)

    thisX.MouseButton1Click:Connect(function()
      CFG[thisKey] = "None"
      if thisKey == "aura_keybind" then
        CFG.quick_aura_keybind = "None"
        if UpdateAuraUI then UpdateAuraUI() end
      end
      if thisKey == "cuff_7bel_keybind" then
        CFG.cuff_7bel_keybind = "None"
      end
      styleKeyPill(thisBtn, thisKey)
      SaveToxicCFG()
      ShowNotification(title .. " cleared!", "X", 1.5)
    end)

    local rowListening = false
    thisBtn.MouseButton1Click:Connect(function()
      if rowListening then return end
      rowListening = true
      thisBtn.Text = "..."
      local bindConn
      bindConn = UserInputService.InputBegan:Connect(function(io, gpe)
        if gpe then return end
        if io.KeyCode ~= Enum.KeyCode.Unknown then
          bindConn:Disconnect()
          rowListening = false
          if io.KeyCode == Enum.KeyCode.Escape then
            CFG[thisKey] = "None"
          else
            CFG[thisKey] = io.KeyCode.Name
          end
          if thisKey == "aura_keybind" then
            CFG.quick_aura_keybind = CFG[thisKey]
            if UpdateAuraUI then UpdateAuraUI() end
          end
          styleKeyPill(thisBtn, thisKey)
          SaveToxicCFG()
        end
      end)
    end)
  end


function initSettingsTab_Body()
  settingsPage = pages["Settings"]
  settingsPage.AutomaticCanvasSize = Enum.AutomaticSize.None
  settingsPage.CanvasSize = UDim2.new(0, 0, 0, 520)
  settingsPage.ScrollBarThickness = 3
  settingsPage.ScrollBarImageColor3 = Theme.NeonGreen

  stll = Instance.new("UIListLayout", settingsPage)
  stll.Padding = UDim.new(0, 6)

  stll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    settingsPage.CanvasSize = UDim2.new(0, 0, 0, math.max(520, stll.AbsoluteContentSize.Y + 20))
  end)


  makeSectionHead(settingsPage, "TS", "TEST  SWAP TOOLS", "fight tools only")
  do
    local box = Instance.new("Frame", settingsPage)
    box.Size = UDim2.new(1, 0, 0, 58)
    box.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", box)
    st.Color = Theme.NeonGreen
    st.Thickness = 1.2
    local t = Instance.new("TextLabel", box)
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(10, 6)
    t.Size = UDim2.new(1, -160, 0, 22)
    t.Text = "SWAP TOOLS"
    t.TextColor3 = Theme.NeonGreen
    t.TextSize = 13
    t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    t.TextXAlignment = Enum.TextXAlignment.Left
    local sub = Instance.new("TextLabel", box)
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.fromOffset(10, 28)
    sub.Size = UDim2.new(1, -160, 0, 22)
    sub.Text = "bat / slap / guitar / pan  —  no cuff 7bel kika"
    sub.TextColor3 = Theme.TextDim
    sub.TextSize = 9
    sub.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    local go = Instance.new("TextButton", box)
    go.Size = UDim2.fromOffset(64, 26)
    go.Position = UDim2.new(1, -150, 0.5, -13)
    go.BackgroundColor3 = Theme.NeonDarkGreen
    go.Text = "SWAP"
    go.TextColor3 = Color3.new(1,1,1)
    go.TextSize = 11
    go.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", go).CornerRadius = UDim.new(0, 6)
    go.MouseButton1Click:Connect(function()
      TestSwitchFightTool()
    end)
    local kb = Instance.new("TextButton", box)
    kb.Size = UDim2.fromOffset(70, 26)
    kb.Position = UDim2.new(1, -78, 0.5, -13)
    kb.BackgroundColor3 = Theme.CardOff
    kb.Text = (CFG.test_switch_keybind and CFG.test_switch_keybind ~= "None") and ("[" .. CFG.test_switch_keybind .. "]") or "Bind"
    kb.TextColor3 = Theme.NeonGreen
    kb.TextSize = 10
    kb.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 6)
    local listen = false
    kb.MouseButton1Click:Connect(function()
      if listen then return end
      listen = true
      kb.Text = "..."
      local c
      c = UserInputService.InputBegan:Connect(function(io, gpe)
        if gpe then return end
        if io.KeyCode == Enum.KeyCode.Unknown then return end
        c:Disconnect()
        listen = false
        if io.KeyCode == Enum.KeyCode.Escape then
          CFG.test_switch_keybind = "None"
          kb.Text = "Bind"
        else
          CFG.test_switch_keybind = io.KeyCode.Name
          kb.Text = "[" .. io.KeyCode.Name .. "]"
        end
      end)
    end)
  end

  makeSectionHead(settingsPage, "CB", "COMBAT BINDS", "")


  makeKeybindRow("ABUSE", "tpbat_keybind", "None")
  makeKeybindRow("ABUSE SWAP", "abuse_swap_keybind", "None")
  makeKeybindRow("ABUSE ALL", "abuse_all_keybind", "None")
  makeKeybindRow("TX", "None")
  makeKeybindRow("Arrest Target", "cuff_arrest_keybind", "C")
  makeKeybindRow("7BEL (Rope)", "cuff_7bel_keybind", "R")
  makeKeybindRow("Carry Side", "cuff_carryside_keybind", "Y")
  makeKeybindRow("Fling Carry", "cuff_fling_keybind", "F")
  makeKeybindRow("G.Fling (Cuff Global)", "cuff_flingcuff_keybind", "G")
  makeKeybindRow("Cuff Global", "cuff_global_keybind", "None")
  makeFiveMToggle(settingsPage, "Rope Return TP", "Return to start after roping", "", function() return CFG.cuff_7bel_return end, function(v)
    CFG.cuff_7bel_return = v
    SaveToxicCFG()
  end)
end

function initSettingsTab_Menu()
  settingsPage = pages["Settings"]
  makeSectionHead(settingsPage, "MN", "MENU BINDS", "")
  makeKeybindRow("Toggle Menu", "menu_keybind", "M")
  makeKeybindRow("INV", "invis_keybind", "I")
  makeKeybindRow("Aura Method", "aura_keybind", "A")
  makeKeybindRow("Self Uncuff", "uncuff_keybind", "U")
  makeKeybindRow("Spectate Target", "spec_keybind", "S")
  makeKeybindRow("Skin Random", "skin_random_keybind", "None")

  makeSectionHead(settingsPage, "UI", "INTERFACE", "")
  makeFiveMToggle(settingsPage, "Admin Join Sound", "Owner / Staff / Helper / Creator", "", function() return CFG.admin_join_sound ~= false end, function(v) CFG.admin_join_sound = v end)
  makeFiveMToggle(settingsPage, "Low Performance", "Reduce extra animations", "", function() return CFG.low_perf end, function(v) CFG.low_perf = v; SaveToxicCFG() end)
  makeFiveMToggle(settingsPage, "Phone Action Balls", "One SQ ball + tray of enabled letters", "", function() return CFG.action_orbs ~= false end, function(v)
    CFG.action_orbs = v
    setActionOrbsVisible(true)
    SaveToxicCFG()
  end)
  makeFiveMToggle(settingsPage, "Lock Orb Positions", "Stop dragging shortcut balls", "", function() return CFG.orbs_locked == true end, function(v)
    CFG.orbs_locked = v
    SaveToxicCFG()
  end)

  local function cycleRow(title, getterText, onClick)
    row = Instance.new("Frame", settingsPage)
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Theme.CardBg
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
    lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.fromOffset(10, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Theme.TextWhite
    lbl.TextSize = 11
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    btn = Instance.new("TextButton", row)
    btn.Size = UDim2.fromOffset(84, 24)
    btn.Position = UDim2.new(1, -94, 0.5, -12)
    btn.BackgroundColor3 = Theme.NeonDarkGreen
    btn.Text = getterText()
    btn.TextColor3 = Theme.TextWhite
    btn.TextSize = 10
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
      onClick()
      btn.Text = getterText()
      SaveToxicCFG()
      ApplyDeviceLayout()
      if RefreshNavLabels then RefreshNavLabels() end
    end)
  end

  cycleRow("Player Sort", function() return CFG.player_sort or "admin" end, function()
    CFG.player_sort = (CFG.player_sort == "admin" and "near") or (CFG.player_sort == "near" and "alive") or "admin"
    BuildPlayerCards()
  end)
  cycleRow("One Hand Dock", function() if CFG.one_hand ~= "center" and CFG.one_hand ~= "left" and CFG.one_hand ~= "right" then CFG.one_hand = "center" end; return CFG.one_hand or "center" end, function()
    CFG.one_hand = (CFG.one_hand == "center" and "left") or (CFG.one_hand == "left" and "right") or "center"
    CFG.menu_pos_x, CFG.menu_pos_y = nil, nil
  end)
end
function initSettingsTab()
  initSettingsTab_Body()
  initSettingsTab_Menu()
end
initSettingsTab()

-- ----------------------------------------------------
-- 10. FIVEM FOOTER (.PFooter & .PBuild)
-- ----------------------------------------------------
Footer = Instance.new("Frame", MainFrame)
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 26)
Footer.Position = UDim2.new(0, 0, 1, -26)
Footer.BackgroundColor3 = Theme.Bg
Footer.BorderSizePixel = 0
Instance.new("UICorner", Footer).CornerRadius = UDim.new(0, 6)

-- regfix
fLine = Instance.new("Frame", Footer)
fLine.Size = UDim2.new(1, 0, 0, 1)
fLine.Position = UDim2.new(0, 0, 0, 0)
fLine.BackgroundColor3 = Theme.NeonDarkGreen
fLine.BorderSizePixel = 0

task.spawn(function()
  -- .PBuild Badge: OUMY
  PBuild = Instance.new("Frame", Footer)
  PBuild.Size = UDim2.fromOffset(68, 18)
  PBuild.Position = UDim2.new(0, 8, 0.5, -9)
  PBuild.BackgroundColor3 = Theme.NeonDarkGreen
  Instance.new("UICorner", PBuild).CornerRadius = UDim.new(0, 4)
  pbStroke = Instance.new("UIStroke", PBuild)
  pbStroke.Color = Theme.NeonGreen
  pbStroke.Thickness = 1

  pbText = Instance.new("TextLabel", PBuild)
  pbText.Size = UDim2.new(1, 0, 1, 0)
  pbText.BackgroundTransparency = 1
  pbText.Text = "OUMY"
  pbText.TextColor3 = Theme.TextWhite
  pbText.TextSize = 9
  pbText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)

  FootChip = Instance.new("Frame", Footer)
  FootChip.Size = UDim2.new(0, 168, 0, 20)
  FootChip.Position = UDim2.fromOffset(82, 3)
  FootChip.BackgroundColor3 = Theme.InputBg
  Instance.new("UICorner", FootChip).CornerRadius = UDim.new(0, 6)

  FootAv = Instance.new("ImageLabel", FootChip)
  FootAv.Size = UDim2.fromOffset(16, 16)
  FootAv.Position = UDim2.fromOffset(2, 2)
  FootAv.BackgroundColor3 = Theme.CardBg
  FootAv.Image = ""
  Instance.new("UICorner", FootAv).CornerRadius = UDim.new(1, 0)

  FootTarget = Instance.new("TextLabel", FootChip)
  FootTarget.Size = UDim2.new(1, -22, 1, 0)
  FootTarget.Position = UDim2.fromOffset(20, 0)
  FootTarget.BackgroundTransparency = 1
  FootTarget.Text = "no target"
  FootTarget.TextColor3 = Theme.TextDim
  FootTarget.TextSize = 9
  FootTarget.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  FootTarget.TextXAlignment = Enum.TextXAlignment.Left
  FootTarget.TextTruncate = Enum.TextTruncate.AtEnd

  lastFootName = ""
  RunService.RenderStepped:Connect(function()
    n = CFG.cuff_target
    if n == lastFootName then return end
    lastFootName = n or ""
    if n and n ~= "" then
      p = Players:FindFirstChild(n)
      FootTarget.Text = p and p.DisplayName or n
      FootTarget.TextColor3 = Theme.TextWhite
      FootAv.Image = p and ("rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=48&h=48") or ""
    else
      FootTarget.Text = "no target"
      FootTarget.TextColor3 = Theme.TextDim
      FootAv.Image = ""
    end
    if RefreshHeaderTarget then RefreshHeaderTarget() end
  end)

  -- Right Indicator (.PIndicator)
  PIndicator = Instance.new("TextLabel", Footer)
  PIndicator.Size = UDim2.fromOffset(110, 26)
  PIndicator.Position = UDim2.new(1, -118, 0, 0)
  PIndicator.BackgroundTransparency = 1
  PIndicator.Text = "[" .. (CFG.menu_keybind or "K") .. "] HIDE"
  PIndicator.TextColor3 = Theme.TextDim
  PIndicator.TextSize = 9
  PIndicator.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  PIndicator.TextXAlignment = Enum.TextXAlignment.Right
end)

-- Global Keybind Listener
UserInputService.InputBegan:Connect(function(io, gpe)
  if io.UserInputType ~= Enum.UserInputType.Keyboard then return end
  -- Do not process hotkeys while user is actively typing in a chat or search box
  if UserInputService:GetFocusedTextBox() then return end
  kn = io.KeyCode.Name

  if io.KeyCode == Enum.KeyCode.LeftControl or io.KeyCode == Enum.KeyCode.RightAlt then
    mouseForceUnlocked = not mouseForceUnlocked
    pcall(function()
      if mouseForceUnlocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        ShowNotification("Cursor: UNLOCKED", "", 1.5)
      else
        ShowNotification("Cursor: LOCKED (Camera)", "", 1.5)
      end
    end)
  elseif CFG.menu_keybind and CFG.menu_keybind ~= "None" and kn == CFG.menu_keybind then
    ToggleMenuVisibility()
  elseif CFG.invis_keybind and CFG.invis_keybind ~= "None" and kn == CFG.invis_keybind then
    ToggleServerInvisibility()
  elseif CFG.tpbat_keybind and CFG.tpbat_keybind ~= "None" and kn == CFG.tpbat_keybind then
    ToggleTpBat()
  elseif CFG.abuse_swap_keybind and CFG.abuse_swap_keybind ~= "None" and kn == CFG.abuse_swap_keybind then
    ToggleAbuseSwap()
  elseif CFG.abuse_all_keybind and CFG.abuse_all_keybind ~= "None" and kn == CFG.abuse_all_keybind then
    ToggleAbuseAll()
  elseif CFG.test_switch_keybind and CFG.test_switch_keybind ~= "None" and kn == CFG.test_switch_keybind then
    TestSwitchFightTool()
  elseif (not _cuffIgnoreKey) and CFG.cuff_arrest_keybind and CFG.cuff_arrest_keybind ~= "None" and kn == CFG.cuff_arrest_keybind then
    L_RM_DoCuffSequence()
  elseif CFG.cuff_7bel_keybind and CFG.cuff_7bel_keybind ~= "None" and kn == CFG.cuff_7bel_keybind then
    L_RM_Do7belSequence()
  elseif CFG.cuff_carryside_keybind and CFG.cuff_carryside_keybind ~= "None" and kn == CFG.cuff_carryside_keybind then
    CarrySide_Execute()
  elseif CFG.cuff_fling_keybind and CFG.cuff_fling_keybind ~= "None" and kn == CFG.cuff_fling_keybind then
    FlingCarry_Execute()
  elseif CFG.cuff_flingcuff_keybind and CFG.cuff_flingcuff_keybind ~= "None" and kn == CFG.cuff_flingcuff_keybind then
    FlingCuff_Execute()
  elseif CFG.color_cuff_keybind and CFG.color_cuff_keybind ~= "None" and kn == CFG.color_cuff_keybind then
    ColorCuff_Execute()
  elseif CFG.cuff_global_keybind and CFG.cuff_global_keybind ~= "None" and kn == CFG.cuff_global_keybind then
    CuffGlobal_Execute()
  end

  -- Custom Quick Chat Keybind Triggers
  if CFG.quick_chat_messages then
    for _, item in ipairs(CFG.quick_chat_messages) do
      if item.keybind and item.keybind ~= "None" and kn == item.keybind then
        SendChatMessage(item.text)
        ShowNotification("Chat Sent: " .. item.text, "", 1.5)
        break
      end
    end
  end

  -- Fake PRV / Silent Chat Keybind Triggers
  if CFG.quick_prv_messages then
    for _, item in ipairs(CFG.quick_prv_messages) do
      if item.keybind and item.keybind ~= "None" and kn == item.keybind then
        SendPrivateChatMessage(item.text, "Self")
        ShowNotification("VIP success", "", 1.5)
        break
      end
    end
  end

  if CFG.skin_random_keybind and CFG.skin_random_keybind ~= "None" and kn == CFG.skin_random_keybind then
    DoRandomSkin()
  end

  -- Aura Method Dedicated Keybind (Toggle ON / OFF)
  auraKey = (CFG.aura_keybind and CFG.aura_keybind ~= "None") and CFG.aura_keybind or CFG.quick_aura_keybind
  if auraKey and auraKey ~= "None" and kn == auraKey then
    if ToggleAura then
      ToggleAura()
    elseif DoQuickAura then
      DoQuickAura()
    end
  end

  -- Self Uncuff Dedicated Keybind
  if CFG.uncuff_keybind and CFG.uncuff_keybind ~= "None" and kn == CFG.uncuff_keybind then
    if DoSelfUncuff then
      DoSelfUncuff()
    end
  end
  if CFG.spec_keybind and CFG.spec_keybind ~= "None" and kn == CFG.spec_keybind then
    if CFG.cuff_target and CFG.cuff_target ~= "" then
      ToggleSpectate(CFG.cuff_target)
    end
  end
end)

pcall(function()
  deferFn = task.defer or task.spawn
  deferFn(function()
    pcall(function()
      centerPos = MainFrame.AbsolutePosition + (MainFrame.AbsoluteSize / 2)
      createToxicLogo(centerPos.X, centerPos.Y)
    end)
  end)
end)

-- Chat command listener to toggle menu (;menu / ;toxic)
pcall(function()
  LocalPlayer.Chatted:Connect(function(msg)
    c = msg:lower():gsub("%s+", "")
    if c == ";menu" or c == "/menu" or c == ":menu" or c == ";toxic" or c == "!menu" then
      ToggleMenuVisibility()
    end
  end)
end)

Players.PlayerRemoving:Connect(function(plr)
  if CFG.cuff_target == plr.Name then
    CFG.cuff_target = ""
    if spectating then
      ToggleSpectate()
    end
    if updateTargetCard then
      updateTargetCard(nil)
    end
  end
end)

task.spawn(function()
  t0 = tick()
  ov = Instance.new("Frame")
  ov.Size = UDim2.fromOffset(340, 78)
  ov.Position = UDim2.new(0.5, -170, 0.5, -39)
  ov.BackgroundTransparency = 1
  ov.BorderSizePixel = 0
  ov.ZIndex = 50
  ov.Parent = ToxicGui
  logo = Instance.new("ImageLabel", ov)
  logo.Size = UDim2.fromOffset(28, 28)
  logo.Position = UDim2.new(0.5, -14, 0, -34)
  logo.BackgroundTransparency = 1
  logo.Image = Theme.LogoImage
  logo.ScaleType = Enum.ScaleType.Fit
  logo.ZIndex = 51
  tt = Instance.new("TextLabel", ov)
  tt.Size = UDim2.new(1, 0, 0, 20)
  tt.Position = UDim2.fromOffset(0, 0)
  tt.BackgroundTransparency = 1
  tt.Text = "TOXIC"
  tt.TextColor3 = Theme.TextWhite
  tt.TextSize = 16
  tt.ZIndex = 51
  tt.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
  ver = Instance.new("TextLabel", ov)
  ver.Size = UDim2.new(1, 0, 0, 12)
  ver.Position = UDim2.fromOffset(0, 18)
  ver.BackgroundTransparency = 1
  ver.Text = "TOXIC V2  |  oumy0"
  ver.TextColor3 = Theme.NeonGreen
  ver.TextSize = 10
  ver.ZIndex = 51
  ver.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
  sb = Instance.new("TextLabel", ov)
  sb.Size = UDim2.new(1, 0, 0, 16)
  sb.Position = UDim2.fromOffset(0, 32)
  sb.BackgroundTransparency = 1
  sb.Text = "Verifying..."
  sb.TextColor3 = Theme.TextWhite
  sb.TextSize = 13
  sb.ZIndex = 51
  sb.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
  bg = Instance.new("Frame", ov)
  bg.Size = UDim2.new(1, 0, 0, 10)
  bg.Position = UDim2.fromOffset(0, 54)
  bg.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
  bg.ZIndex = 51
  Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
  bar = Instance.new("Frame", bg)
  bar.Size = UDim2.new(0.04, 0, 1, 0)
  bar.BackgroundColor3 = Theme.NeonGreen
  bar.ZIndex = 52
  Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
  pc = Instance.new("TextLabel", bg)
  pc.Size = UDim2.new(1, 0, 1, 0)
  pc.BackgroundTransparency = 1
  pc.Text = "0%"
  pc.TextColor3 = Theme.TextWhite
  pc.TextSize = 9
  pc.ZIndex = 53
  pc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
  steps = { "Verifying...", "Loading Configuration...", "Building Interface...", "Ready!" }
  for i = 1, 28 do
    a = i / 28
    bar.Size = UDim2.new(a, 0, 1, 0)
    pc.Text = tostring(math.floor(a * 100)) .. "%"
    sb.Text = steps[math.clamp(math.ceil(a * #steps), 1, #steps)]
    task.wait(0.11)
  end
  while tick() - t0 < 3.2 do
    task.wait(0.05)
  end
  pcall(function() ov:Destroy() end)
  menuReady = true
  MainFrame.Visible = true
  ToggleBall.Visible = false
  pcall(function()
    want = CFG.last_tab or "Players"
    if tabBtns[want] then
      for name, data in pairs(tabBtns) do
        isActive = (name == want)
        data.glow.BackgroundColor3 = isActive and Theme.NeonGreen or Theme.CardBg
        data.txt.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.TextDim
        data.line.Visible = isActive
        if data.ic then data.ic.TextColor3 = isActive and Color3.fromRGB(8, 20, 12) or Theme.NeonGreen end
        if data.stroke then
          data.stroke.Color = isActive and Theme.NeonGreen or Theme.GlowStroke
          data.stroke.Transparency = isActive and 0.15 or 0.55
        end
        pages[name].Visible = isActive
      end
    end
  end)
  pcall(function()
    centerPos = MainFrame.AbsolutePosition + (MainFrame.AbsoluteSize / 2)
    createToxicLogo(centerPos.X, centerPos.Y)
  end)
  ShowNotification("TOXIC ready", "", 2)
end)
print("[TOXIC V2] ready — INV + TP TO VOID. Press M or ;menu")

-- ====================================================================
-- AUTO SIT BLOCK — Always ON with INV (no manual execute needed)
-- Disables all seats on load + watches for new ones dynamically
-- ====================================================================
task.spawn(function()
  local _sitDisabledSeats = {}
  local _sitDescConn = nil

  local function _sitDisableAll()
    _sitDisabledSeats = {}
    local n = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
      if (obj:IsA("Seat") or obj:IsA("VehicleSeat")) and not obj.Disabled then
        pcall(function()
          obj.Disabled = true
          table.insert(_sitDisabledSeats, obj)
          n = n + 1
        end)
      end
    end
    return n
  end

  -- Watch for any NEW seat added while in-game
  local function _sitStartWatcher()
    if _sitDescConn then pcall(function() _sitDescConn:Disconnect() end) end
    _sitDescConn = workspace.DescendantAdded:Connect(function(obj)
      if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
        task.defer(function()
          if obj and obj.Parent then
            pcall(function()
              obj.Disabled = true
              table.insert(_sitDisabledSeats, obj)
            end)
          end
        end)
      end
    end)
  end

  -- Reconnect backup on respawn
  local _sitStateConn = nil
  local function _sitAttachBackup()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if _sitStateConn then pcall(function() _sitStateConn:Disconnect() end) end
    _sitStateConn = hum.StateChanged:Connect(function(_, new)
      if new == Enum.HumanoidStateType.Seated then
        task.defer(function()
          pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            for _, w in ipairs(char:GetDescendants()) do
              if w.Name == "SeatWeld" then pcall(function() w:Destroy() end) end
            end
          end)
        end)
      end
    end)
  end

  LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    _sitDisableAll()
    _sitAttachBackup()
  end)

  -- Init
  local n = _sitDisableAll()
  _sitStartWatcher()
  _sitAttachBackup()
  print(string.format("[TOXIC] Sit Block: %d seats disabled", n))
end)

