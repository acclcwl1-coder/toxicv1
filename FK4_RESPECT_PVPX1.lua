local Players          = game:GetService("Players")

local RunService       = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local TweenService     = game:GetService("TweenService")

local Workspace        = game:GetService("Workspace")

local Lighting         = game:GetService("Lighting")

local CoreGui          = game:GetService("CoreGui")

local HttpService      = game:GetService("HttpService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

if not LP then

repeat task.wait() until Players.LocalPlayer

LP = Players.LocalPlayer

end

local Camera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()

Camera = Workspace.CurrentCamera

end)

if not math.clamp then

math.clamp = function(v, min, max) return math.max(min, math.min(v, max)) end

end

if not table.unpack then table.unpack = unpack end

local _mousemoverel = mousemoverel or function(dx, dy)

local vim = game:GetService("VirtualInputManager")

if vim then

local m = UserInputService:GetMouseLocation()

vim:SendMouseMoveEvent(m.X + dx, m.Y + dy, game)

end

end

local GStore = (typeof(getgenv) == "function" and getgenv()) or _G

pcall(function()

if GStore.TK4_RESPECT_CLEANUP then

pcall(GStore.TK4_RESPECT_CLEANUP)

GStore.TK4_RESPECT_CLEANUP = nil

end

GStore.TK4_TP_LISTENER_ACTIVE = nil

GStore.TK4_TP_QUEUED = nil

pcall(function()

local CAS_boot = game:GetService("ContextActionService")

CAS_boot:UnbindAction("TK4_CamSink")

CAS_boot:UnbindAction("TK4_CamSink_v2")

CAS_boot:UnbindAction("TK4_CamSink_old")

end)

pcall(function()

if _G._TK4_MouseConn then

_G._TK4_MouseConn:Disconnect()

_G._TK4_MouseConn = nil

end

end)

pcall(function()

workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

end)

pcall(function()

UserInputService.MouseBehavior    = Enum.MouseBehavior.Default

UserInputService.MouseIconEnabled = true

end)

pcall(function()

if type(restorefunction) == "function" then

local mt = getrawmetatable and getrawmetatable(game)

if mt and mt.__namecall and type(isfunctionhooked) == "function" and isfunctionhooked(mt.__namecall) then

restorefunction(mt.__namecall)

end

end

GStore.TK4_RAW_NAMECALL = nil

end)

local guiTargets = {}

pcall(function() if CoreGui then table.insert(guiTargets, CoreGui) end end)

pcall(function() if gethui then table.insert(guiTargets, gethui()) end end)

pcall(function() if LP and LP:FindFirstChild("PlayerGui") then table.insert(guiTargets, LP.PlayerGui) end end)

for _, parent in ipairs(guiTargets) do

for _, child in ipairs(parent:GetChildren()) do

local lower = string.lower(child.Name)

if string.sub(lower, 1, 4) == "tk4_" or child.Name == "TK4_RespectPVP" or child.Name == "TK4_RespectPVP_Vasper" then

pcall(function() child:Destroy() end)

end

end

end

end)

local SCRIPT_ID = HttpService:GenerateGUID(false)

GStore.TK4_SCRIPT_ID = SCRIPT_ID

local C = {

winBg       = Color3.fromRGB(8, 6, 12),

winBg2      = Color3.fromRGB(12, 10, 18),

winBorder   = Color3.fromRGB(52, 34, 82),

topBg       = Color3.fromRGB(6, 4, 10),

topTitle    = Color3.fromRGB(255, 255, 255),

topSub      = Color3.fromRGB(165, 150, 185),

rowBg       = Color3.fromRGB(17, 13, 25),

rowHov      = Color3.fromRGB(28, 20, 42),

rowStroke   = Color3.fromRGB(50, 36, 75),

rowLabel    = Color3.fromRGB(245, 245, 245),

rowValue    = Color3.fromRGB(220, 220, 220),

pillOff     = Color3.fromRGB(42, 30, 58),

pillOn      = Color3.fromRGB(130, 68, 255),

dotColor    = Color3.fromRGB(255, 255, 255),

dotColorOn  = Color3.fromRGB(255, 255, 255),

tabBg       = Color3.fromRGB(15, 11, 22),

tabActiveBg = Color3.fromRGB(130, 68, 255),

tabActiveTx = Color3.fromRGB(255, 255, 255),

tabIdleTx   = Color3.fromRGB(170, 160, 185),

accent      = Color3.fromRGB(130, 68, 255),

accentDim   = Color3.fromRGB(90, 42, 180),

danger      = Color3.fromRGB(255, 55, 85),

rowAlpha    = 0.25,

}

local BRAND = {

Name    = "TK4",

Full    = "THE KINGS FOUR",

Motto   = "Unión · Respeto · Poder · Lealtad",

LogoId  = "rbxassetid://102293188968456",

Version = "God Edition v5.1 Â· Mobile ESP",

}

local Config = {

SilentAim          = true,

HitPart            = "Head",

HitChance          = 100,

FOVRadius          = 200,

DrawFOV            = false,

TeamCheck          = true,

WallCheck          = false,

SkipDeflect        = true,

SkipImmune         = true,

PersistentLoad     = true,

CamAimbot          = false,

CamAimMethod       = "Auto",

CamAimMode         = "Auto",

CamAimPart         = "Head",

CamAimFOV          = 250,

CamAimSmooth       = 35,

CamAimWallCheck    = true,

CamAimPrediction   = true,

CamAimPredStrength = 1.0,

CamAimSwitchDelay  = 0.0,

CamAimSticky       = false,

CamAimKey          = nil,

CamAimLinger       = 0.40,

ESP_Master         = true,

ESP_Box            = true,

ESP_BoxStyle       = "Corner",

ESP_Skeleton       = true,

ESP_Health         = true,

ESP_HealthNum      = true,

ESP_Names          = true,

ESP_Distance       = true,

ESP_Tracers        = false,

ESP_TracerOrigin   = "Bottom",

ESP_Head           = true,

ESP_TeamCheck      = true,

ESP_MaxDistance    = 500,

ESP_TextSize       = 13,

ESP_Level          = true,   

ESP_Rank           = true,   

esp_col_box_r      = 123, esp_col_box_g = 92, esp_col_box_b = 234,

esp_col_skel_r     = 245, esp_col_skel_g = 245, esp_col_skel_b = 255,

esp_col_name_r     = 255, esp_col_name_g = 255, esp_col_name_b = 255,

esp_col_dist_r     = 180, esp_col_dist_g = 170, esp_col_dist_b = 200,

esp_col_tracer_r   = 123, esp_col_tracer_g = 92, esp_col_tracer_b = 234,

esp_col_head_r     = 123, esp_col_head_g = 92, esp_col_head_b = 234,

Crosshair_Enabled  = false,

Crosshair_Size     = 8,

Crosshair_Gap      = 4,

Crosshair_Thick    = 2,

Crosshair_Dot      = true,

HitboxExpander     = false,

HitboxSize         = 18,

HitboxTarget       = "Head",

NoRecoil           = false,

NoBloom            = false,

RapidFire          = false,

RapidMultiplier    = 2.0,

FullAuto           = false,

CombatMaster       = false,   -- Master God Mode Combo
AutoReload         = false,   -- Auto Spam Recharge on empty
InfiniteAmmo       = false,   -- Smart Adaptive Infinite Ammo (Never exceeds legal gun mag)

InfiniteStamina    = false,

SpeedBoost         = false,

SpeedBoostValue    = 40,

AutoSprint         = true,   

HumanoidSwap       = false,

InfiniteJump       = false,

NoJumpDelay        = false,

FullSpeedADS       = false,

InstantTurn        = false,

FastCrouch         = false,

CrouchSpeed        = 40,

NoShotSlowdown     = false,

NoScopeBlackout    = false,

ESP_Alerts         = true,

MatchNotifier      = true,

HighlightEnabled        = false,

HighlightTeamCheck      = true,   

HighlightDepthMode      = "AlwaysOnTop",  

hl_col_outline_r        = 123, hl_col_outline_g = 92, hl_col_outline_b = 234,

hl_col_fill_r           = 123, hl_col_fill_g   = 92, hl_col_fill_b   = 234,

hl_fill_transparency    = 0.85,

hl_outline_transparency = 0.0,

LightFullbright    = false,

LightNoFog         = false,

LightClockOn       = false,

LightClock         = 14,

CameraFOV          = 70,

NoKillShake        = false,

ESP_FiringAlert    = true,

SilentHitSound     = true,

GuiVisible         = false,

MenuKey            = Enum.KeyCode.K,

MenuScaleAuto      = true,

UIScale            = 1.0,

MenuScalePercent   = 100,

AutoSaveConfig     = true,

}

local State = {

HookStatus       = "ACTIVE",

SilentTarget     = nil,

TargetPart       = nil,

CachedTarget     = nil,

TargetDist       = 0,

TargetHP         = 0,

ShotsHooked      = 0,

LastShotTarget   = nil,

LastShotTime     = 0,

ESPCache         = {},

Connections      = {},

OldLighting      = {

Ambient    = Lighting.Ambient,

Brightness = Lighting.Brightness,

FogEnd     = Lighting.FogEnd,

FogStart   = Lighting.FogStart,

ClockTime  = Lighting.ClockTime,

},

OriginalWalkSpeed = 18,

_speedOverriding  = false,          

_swapPack         = { orig = nil, clone = nil },  

_staffInServer    = {},             

}

local function regConn(conn)

if conn then table.insert(State.Connections, conn) end

return conn

end

local _tk4MainGuiModule = nil

local function makeWritable(tbl)

if type(tbl) ~= "table" then return tbl end

if type(setreadonly) == "function" and type(isreadonly) == "function" and isreadonly(tbl) then

pcall(setreadonly, tbl, false)

end

return tbl

end

local ClientState     = nil

local GameSettings    = nil

local WeaponData      = nil

local originalWeaponStats = {}

local WeaponController  = nil

local CameraController  = nil

local MovementController = nil

local CrouchController  = nil

local Prefs           = nil

local Sfx             = nil

local getupvaluesFn = type(debug.getupvalues) == "function" and debug.getupvalues or (type(getupvalues) == "function" and getupvalues)

local setupvalueFn  = type(debug.setupvalue) == "function" and debug.setupvalue or (type(setupvalue) == "function" and setupvalue)

task.spawn(function()

pcall(function()

ClientState = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("ClientState"))

end)

pcall(function()

GameSettings = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Settings"))

if GameSettings then

makeWritable(GameSettings)

if GameSettings.Roll then makeWritable(GameSettings.Roll) end

if GameSettings.Stamina then makeWritable(GameSettings.Stamina) end

if GameSettings.Jump then makeWritable(GameSettings.Jump) end

State.OriginalWalkSpeed = GameSettings.WalkSpeed or 18

end

end)

pcall(function()

WeaponData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("WeaponData"))

makeWritable(WeaponData)

for name, w in pairs(WeaponData) do

if type(w) == "table" and w.Fire then

makeWritable(w)

makeWritable(w.Fire)

if w.Recoil then makeWritable(w.Recoil) end

originalWeaponStats[name] = {

RPM = w.Fire.RPM,

Mode = w.Fire.Mode,

Recoil = w.Recoil and {

Up = w.Recoil.Up,

Side = w.Recoil.Side,

Return = w.Recoil.Return,

AimScale = w.Recoil.AimScale,

Smooth = w.Recoil.Smooth,

} or nil

}

end

end

end)

pcall(function()

WeaponController = require(ReplicatedStorage.Client.Controllers.WeaponController)

end)

pcall(function()

HudController = require(ReplicatedStorage.Client.Controllers.HudController)

end)

pcall(function()

CameraController = require(ReplicatedStorage.Client.Controllers.CameraController)

end)

pcall(function()

MovementController = require(ReplicatedStorage.Client.Controllers.MovementController)

end)

pcall(function()

CrouchController = require(ReplicatedStorage.Client.Controllers.CrouchController)

end)

pcall(function()

Prefs = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Prefs"))

end)

pcall(function()

Sfx = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Sfx"))

end)

end)

local function resetWeaponCooldown()

if not (WeaponController and getupvaluesFn and setupvalueFn) then return end

pcall(function()

local startUps = getupvaluesFn(WeaponController.Start)

if not startUps then return end

local updateFn = startUps[16]

if type(updateFn) ~= "function" then return end

local updateUps = getupvaluesFn(updateFn)

if not updateUps then return end



local u75 = updateUps[2]

if type(u75) == "table" and u75.Fire then

if Config.RapidFire or Config.CombatMaster then

local baseRpm = u75.Fire._BaseRPM or u75.Fire.RPM

if not u75.Fire._BaseRPM then u75.Fire._BaseRPM = baseRpm end

local mult = Config.CombatMaster and 2.3 or (Config.RapidMultiplier or 2.0)

u75.Fire.RPM = math.round(baseRpm * mult)

elseif u75.Fire._BaseRPM then

u75.Fire.RPM = u75.Fire._BaseRPM

end

if Config.FullAuto or Config.CombatMaster then

u75.Fire.Mode = "Auto"

end

if (Config.NoRecoil or Config.CombatMaster) and u75.Recoil then

u75.Recoil.Up = 0

u75.Recoil.Side = 0

u75.Recoil.AimScale = 0

end

end



if (Config.FullAuto or Config.CombatMaster) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then

local isReloading = ClientState and ClientState.Reloading

local cursorFree = ClientState and (ClientState.CursorFree or (ClientState.InMenu and ClientState.InMenu()))

if not isReloading and not cursorFree then

if WeaponController and WeaponController.SetTrigger then

pcall(WeaponController.SetTrigger, true)

end

end

end



-- SMART ADAPTIVE INFINITE AMMO & ANTI-RELOAD LOCK

if Config.InfiniteAmmo or Config.CombatMaster then

local startReloadFn = WeaponController and WeaponController.Reload and getupvaluesFn(WeaponController.Reload)[1]

if type(startReloadFn) == "function" then

local rUps = getupvaluesFn(startReloadFn)

if rUps then

local curAmmo = rUps[7] -- u77: current ammo in mag

local maxMag  = rUps[8] -- u78: exact legal capacity of currently held gun

local wData   = rUps[10] -- u75: weapon data table

local legalMax = (type(maxMag) == "number" and maxMag > 0) and maxMag

or (wData and wData.Ammo and wData.Ammo.Mag)

or (u75 and u75.Ammo and u75.Ammo.Mag)

or 17

if type(curAmmo) == "number" and curAmmo <= 2 then

setupvalueFn(startReloadFn, 7, legalMax)

end

-- Dismiss stuck reload animation if ammo is full

if ClientState and ClientState.Reloading and curAmmo and curAmmo >= legalMax then

ClientState.Reloading = false

if HudController and HudController.SetReloading then

pcall(function() HudController.SetReloading(false) end)

end

end

end

end

end



-- AUTO SPAM RECHARGE / AUTO RELOAD (Cadenced 0.5s when NOT firing)

if (Config.AutoReload or Config.CombatMaster) then

local now = os.clock()

if (now - (_G._TK4_LastSpamReload or 0) >= 0.5) then

local isReloading = ClientState and ClientState.Reloading

local cursorFree = ClientState and (ClientState.CursorFree or (ClientState.InMenu and ClientState.InMenu()))

local isFiring = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

if not isReloading and not cursorFree and not isFiring then

local startReloadFn = WeaponController and WeaponController.Reload and getupvaluesFn(WeaponController.Reload)[1]

if type(startReloadFn) == "function" then

local rUps = getupvaluesFn(startReloadFn)

if rUps then

local curAmmo = rUps[7]

local maxMag  = rUps[8] or 17

if type(curAmmo) == "number" and curAmmo < maxMag then

_G._TK4_LastSpamReload = now

if WeaponController.Reload then

pcall(WeaponController.Reload)

end

end

end

end

end

end

end

end)

end

local function applyWeaponMods()

if not WeaponData then return end

for name, w in pairs(WeaponData) do

if type(w) == "table" and w.Fire and originalWeaponStats[name] then

if Config.RapidFire or Config.CombatMaster then

local mult = Config.CombatMaster and 2.3 or (Config.RapidMultiplier or 2.0)

w.Fire.RPM = math.round(originalWeaponStats[name].RPM * mult)

else

w.Fire.RPM = originalWeaponStats[name].RPM

end

if Config.FullAuto or Config.CombatMaster then

w.Fire.Mode = "Auto"

else

w.Fire.Mode = originalWeaponStats[name].Mode

end

if (Config.NoRecoil or Config.CombatMaster) and w.Recoil then

w.Recoil.Up = 0

w.Recoil.Side = 0

w.Recoil.AimScale = 0

elseif originalWeaponStats[name].Recoil and w.Recoil then

w.Recoil.Up = originalWeaponStats[name].Recoil.Up

w.Recoil.Side = originalWeaponStats[name].Recoil.Side

w.Recoil.AimScale = originalWeaponStats[name].Recoil.AimScale

end

end

end

if Config.RapidFire or Config.InfiniteAmmo then

resetWeaponCooldown()

end

end

local function updateHitboxes()

local function expandChar(char)

if not char then return end

local part = char:FindFirstChild(Config.HitboxTarget == "Head" and "Head" or "HumanoidRootPart")

if part then

if Config.HitboxExpander then

part.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)

part.Transparency = 0.65

part.CanCollide = false

else

part.Transparency = 0

end

end

end

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LP and player.Character then

expandChar(player.Character)

end

end

local matchBotsFolder = workspace:FindFirstChild("MatchBots")

if matchBotsFolder then

for _, bot in ipairs(matchBotsFolder:GetChildren()) do

expandChar(bot)

end

end

local targetsFolder = workspace:FindFirstChild("Targets")

if targetsFolder then

for _, dummy in ipairs(targetsFolder:GetChildren()) do

expandChar(dummy)

end

end

end

local function setCombatMaster(enabled)
  Config.CombatMaster = enabled
  pcall(applyWeaponMods)
  pcall(resetWeaponCooldown)
  if enabled and HudController and HudController.SetReloading then
    pcall(function() HudController.SetReloading(false) end)
  end
end

local function applyLighting()

Lighting.Ambient = Config.LightFullbright and Color3.fromRGB(220, 220, 220) or State.OldLighting.Ambient

Lighting.Brightness = Config.LightFullbright and 2.5 or State.OldLighting.Brightness

Lighting.FogEnd = Config.LightNoFog and 1e9 or State.OldLighting.FogEnd

Lighting.FogStart = Config.LightNoFog and 1e9 or State.OldLighting.FogStart

if Config.LightClockOn then Lighting.ClockTime = Config.LightClock else Lighting.ClockTime = State.OldLighting.ClockTime end

end

local function applyPrefs()

if not Prefs then return end

pcall(function()

Prefs.Set("FieldOfView", Config.CameraFOV or 70)

if Config.NoKillShake then

Prefs.Set("KillShake", false)

else

Prefs.Set("KillShake", true)

end

end)

end

local function mkCorner(p, r)

local c = Instance.new("UICorner", p)

c.CornerRadius = UDim.new(0, r or 6)

return c

end

local function mkStroke(p, col, th)

local s = Instance.new("UIStroke", p)

s.Color = col or Color3.fromRGB(255, 255, 255)

s.Thickness = th or 1

s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

return s

end

local TK4_NOTIFY_STYLES = {

info   = { accent = Color3.fromRGB(170,  90, 255), icon = "◆" },

ok     = { accent = Color3.fromRGB( 80, 220, 140), icon = "✔" },

warn   = { accent = Color3.fromRGB(255, 180,  60), icon = "▲" },

staff  = { accent = Color3.fromRGB(214, 160,  30), icon = "⚠" },

danger = { accent = Color3.fromRGB(255,  80, 110), icon = "✖" },

}

local tk4NotifyGui = Instance.new("ScreenGui")

tk4NotifyGui.Name           = "TK4_Notify_GUI"

tk4NotifyGui.ResetOnSpawn   = false

tk4NotifyGui.IgnoreGuiInset = true

tk4NotifyGui.DisplayOrder   = 300

tk4NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

do

local parented = false

pcall(function() if syn and syn.protect_gui then syn.protect_gui(tk4NotifyGui) end end)

pcall(function() tk4NotifyGui.Parent = CoreGui; parented = true end)

if not parented then pcall(function() if gethui then tk4NotifyGui.Parent = gethui(); parented = true end end) end

if not parented then pcall(function() tk4NotifyGui.Parent = LP:WaitForChild("PlayerGui") end) end

end

local tk4NotifyStack = Instance.new("Frame", tk4NotifyGui)

tk4NotifyStack.Name          = "Stack"

tk4NotifyStack.AnchorPoint   = Vector2.new(1, 0)

tk4NotifyStack.Position      = UDim2.new(1, -12, 0, 64)

tk4NotifyStack.Size          = UDim2.new(0, 330, 0, 0)

tk4NotifyStack.BackgroundTransparency = 1

do

local nl = Instance.new("UIListLayout", tk4NotifyStack)

nl.Padding             = UDim.new(0, 8)

nl.SortOrder           = Enum.SortOrder.LayoutOrder

nl.HorizontalAlignment = Enum.HorizontalAlignment.Right

end

local TK4_TOASTS   = {}

local TK4_TOAST_LO = 0

local function tk4Notify(title, body, kind, duration)

local style = TK4_NOTIFY_STYLES[kind or "info"] or TK4_NOTIFY_STYLES.info

duration = tonumber(duration) or 4

while #TK4_TOASTS >= 4 do

local old = table.remove(TK4_TOASTS, 1)

pcall(function() old:Destroy() end)

end

TK4_TOAST_LO = TK4_TOAST_LO + 1

local card = Instance.new("Frame")

card.Name               = "TK4Toast"

card.BackgroundColor3   = Color3.fromRGB(13, 11, 20)

card.BackgroundTransparency = 0.05

card.BorderSizePixel    = 0

card.Size               = UDim2.new(0, 330, 0, 0)

card.AutomaticSize      = Enum.AutomaticSize.Y

card.LayoutOrder        = TK4_TOAST_LO

card.Parent             = tk4NotifyStack

mkCorner(card, 12)

mkStroke(card, style.accent, 1.3)

local bar = Instance.new("Frame", card)

bar.Name             = "Accent"

bar.Size             = UDim2.new(0, 4, 1, 0)

bar.BackgroundColor3 = style.accent

bar.BorderSizePixel  = 0

bar.ZIndex           = 2

mkCorner(bar, 2)

local pad = Instance.new("Frame", card)

pad.Position               = UDim2.new(0, 16, 0, 0)

pad.Size                   = UDim2.new(1, -28, 0, 0)

pad.AutomaticSize          = Enum.AutomaticSize.Y

pad.BackgroundTransparency = 1

do

local pl = Instance.new("UIListLayout", pad)

pl.Padding   = UDim.new(0, 2)

pl.SortOrder = Enum.SortOrder.LayoutOrder

end

do

local pp = Instance.new("UIPadding", pad)

pp.PaddingTop    = UDim.new(0, 10)

pp.PaddingBottom = UDim.new(0, 14)

end

local head = Instance.new("TextLabel", pad)

head.Name           = "Title"

head.Size           = UDim2.new(1, 0, 0, 16)

head.AutomaticSize  = Enum.AutomaticSize.Y

head.BackgroundTransparency = 1

head.Font           = Enum.Font.GothamBold

head.TextSize       = 13

head.TextColor3     = style.accent

head.TextXAlignment = Enum.TextXAlignment.Left

head.Text           = style.icon .. "  " .. tostring(title)

head.LayoutOrder    = 1

local msg = Instance.new("TextLabel", pad)

msg.Name           = "Body"

msg.Size           = UDim2.new(1, 0, 0, 15)

msg.AutomaticSize  = Enum.AutomaticSize.Y

msg.BackgroundTransparency = 1

msg.Font           = Enum.Font.Gotham

msg.TextSize       = 12

msg.TextColor3     = Color3.fromRGB(228, 228, 238)

msg.TextXAlignment = Enum.TextXAlignment.Left

msg.TextWrapped    = true

msg.Text           = tostring(body or "")

msg.LayoutOrder    = 2

local timer = Instance.new("Frame", card)

timer.Name             = "Timer"

timer.AnchorPoint      = Vector2.new(0, 1)

timer.Position         = UDim2.new(0, 4, 1, -3)

timer.Size             = UDim2.new(1, -8, 0, 2)

timer.BackgroundColor3 = style.accent

timer.BackgroundTransparency = 0.35

timer.BorderSizePixel  = 0

timer.ZIndex           = 2

mkCorner(timer, 1)

card.BackgroundTransparency = 1

head.TextTransparency = 1

msg.TextTransparency  = 1

TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {

BackgroundTransparency = 0.05,

}):Play()

TweenService:Create(head, TweenInfo.new(0.18), { TextTransparency = 0 }):Play()

TweenService:Create(msg,  TweenInfo.new(0.18), { TextTransparency = 0 }):Play()

TweenService:Create(timer, TweenInfo.new(duration, Enum.EasingStyle.Linear), {

Size = UDim2.new(0, 0, 0, 2),

}):Play()

table.insert(TK4_TOASTS, card)

task.delay(duration, function()

for i, c in ipairs(TK4_TOASTS) do

if c == card then

table.remove(TK4_TOASTS, i)

break

end

end

if not card.Parent then return end

TweenService:Create(card,  TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()

TweenService:Create(head,  TweenInfo.new(0.25), { TextTransparency = 1 }):Play()

TweenService:Create(msg,   TweenInfo.new(0.25), { TextTransparency = 1 }):Play()

TweenService:Create(timer, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()

task.delay(0.27, function()

pcall(function() card:Destroy() end)

end)

end)

end

local function safeParentGui(gui)

local ok = false

pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)

pcall(function() gui.Parent = CoreGui; ok = true end)

if not ok then pcall(function() if gethui then gui.Parent = gethui(); ok = true end end) end

if not ok then pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end) end

end

local CONFIG_FILE_NAME = "tk4_respect_pvp_config.json"

local function serializeConfig()

local s = {}

for k, v in pairs(Config) do

if typeof(v) == "EnumItem" then

s[k] = { __type = "EnumItem", enum = tostring(v.EnumType), name = v.Name }

else

s[k] = v

end

end

return s

end

local function saveConfigToFile()

if not (writefile and HttpService) then return false end

local ok = pcall(function()

local s = serializeConfig()

writefile(CONFIG_FILE_NAME, HttpService:JSONEncode(s))

end)

return ok

end

local function loadConfigFromFile()

if not (readfile and isfile and HttpService) then return false end

local ok, res = pcall(function()

if isfile(CONFIG_FILE_NAME) then

local data = HttpService:JSONDecode(readfile(CONFIG_FILE_NAME))

if typeof(data) == "table" then

for k, v in pairs(data) do

if typeof(v) == "table" and v.__type == "EnumItem" then

pcall(function()

local enumGroup = Enum[v.enum]

if enumGroup and enumGroup[v.name] then Config[k] = enumGroup[v.name] end

end)

elseif typeof(v) ~= "table" then

if k ~= "GuiVisible" then

Config[k] = v

end

end

end

Config.GuiVisible = true

return true

end

end

return false

end)

return ok and res == true

end

local UISetters = {}

local function registerUISetter(key, setter)

local cur = UISetters[key]

if type(cur) == "function" then

UISetters[key] = { cur, setter }

elseif type(cur) == "table" then

cur[#cur + 1] = setter

else

UISetters[key] = setter

end

end

local saveDebounce = nil

local function onConfigChanged()

if Config.AutoSaveConfig ~= false then

if saveDebounce then

pcall(task.cancel, saveDebounce)

end

saveDebounce = task.delay(0.4, function()

saveConfigToFile()

saveDebounce = nil

end)

end

end

pcall(function()

game:BindToClose(function()

if Config.AutoSaveConfig ~= false then

saveConfigToFile()

end

end)

end)

local TK4_SCRIPT_URL = "https://raw.githubusercontent.com/acclcwl1-coder/toxicv1/refs/heads/main/FK4_RESPECT_PVPX1.lua"

local TK4_queueOnTeleport = nil

pcall(function()

TK4_queueOnTeleport =

(syn and syn.queue_on_teleport) or          

(fluxus and fluxus.queue_on_teleport) or    

(solara and solara.queue_on_teleport) or    

(wave and wave.queue_on_teleport) or        

(arceus and arceus.queue_on_teleport) or    

(delta and delta.queue_on_teleport) or      

(hydrogen and hydrogen.queue_on_teleport) or 

(krnl and krnl.queue_on_teleport) or        

(typeof(getgenv) == "function" and getgenv().queue_on_teleport) or

queue_on_teleport                           

end)

if TK4_queueOnTeleport then

local TK4_Q_CODE = [[

    -- DEDUPE: only the first queued copy proceeds (flag lives in BOTH _G

    -- and getgenv so it works on executors that isolate script envs)

    if _G.TK4_AUTOLOAD_RUNNING then return end

    if getgenv and getgenv().TK4_AUTOLOAD_RUNNING then return end

    _G.TK4_AUTOLOAD_RUNNING = true

    if getgenv then getgenv().TK4_AUTOLOAD_RUNNING = true end



    repeat task.wait() until game:IsLoaded()

    task.wait(3)

    local LP = game:GetService("Players").LocalPlayer

    if not LP then

      repeat task.wait(0.1)

        LP = game:GetService("Players").LocalPlayer

      until LP

    end



    -- wait for a fully spawned, alive character (up to 30s)

    local char = LP.Character

    if not char then char = LP.CharacterAdded:Wait() end

    local t0 = os.clock()

    while os.clock() - t0 < 30 do

      local hum  = char:FindFirstChildOfClass("Humanoid")

      local hrp  = char:FindFirstChild("HumanoidRootPart")

      local head = char:FindFirstChild("Head")

      if char.Parent and hum and hrp and head and hum.Health > 0 then break end

      task.wait(0.2)

      char = LP.Character or char

    end

    task.wait(1) -- settle delay so the spawn finishes visually



    -- WAIT FOR THE INTRO: if the game's Welcome screen is showing, press

    -- its SKIP button (client-side) and wait until it closes (max 45s).

    local okSkip, skipErr = pcall(function()

      local pg2 = LP:FindFirstChildOfClass("PlayerGui")

      local mg2 = pg2 and pg2:FindFirstChild("MainGui")

      local welcome2 = mg2 and mg2:FindFirstChild("Welcome")

      if welcome2 and welcome2.Visible then

        local card = welcome2:FindFirstChild("Canvas")

        card = card and card:FindFirstChild("Card")

        local skipBtn = card and card:FindFirstChild("Skip")

        if skipBtn and getconnections then

          for _, conn in ipairs(getconnections(skipBtn.Activated)) do

            pcall(function() conn:Fire() end)

          end

          print("[TK4] Auto-skipped game intro (post-teleport)")

        end

        local t2 = os.clock()

        while welcome2.Visible and os.clock() - t2 < 45 do task.wait(0.25) end

      end

    end)

    if not okSkip then warn("[TK4] intro wait failed:", skipErr) end

    task.wait(1)



    -- RANKED FLOW DETECTION:

    -- Ranked match uses a 2-TP flow:

    --   TP1 → voting lobby (weapon/map vote) → TP2 → actual arena

    -- We detect if we landed in the vote lobby (Vote UI visible), and if so,

    -- wait for TP2 (the arena teleport) before loading the menu.

    -- Casual matches go directly to arena (no Vote UI) — handled by the timeout.

    local t3 = os.clock()

    local voteDetected = false

    while os.clock() - t3 < 60 do

      task.wait(0.25)

      local pgx = LP:FindFirstChildOfClass("PlayerGui")

      local mgx = pgx and pgx:FindFirstChild("MainGui")

      local v3 = mgx and mgx:FindFirstChild("Vote")

      if v3 and v3.Visible then

        voteDetected = true

        break

      end

    end



    if voteDetected then

      -- We are in the vote lobby. Wait for TP2 (arena) before loading.

      -- Method: wait until Vote UI disappears (vote ended → TP incoming)

      -- then wait for the actual teleport to complete (game reloads / char respawns)

      print("[TK4] Vote lobby detected — waiting for arena TP2 before loading...")

      local tVote = os.clock()

      -- Step 1: wait for vote to end (Vote UI hides or disappears, max 90s)

      while os.clock() - tVote < 90 do

        task.wait(0.3)

        local pgx2 = LP:FindFirstChildOfClass("PlayerGui")

        local mgx2 = pgx2 and pgx2:FindFirstChild("MainGui")

        local v3b  = mgx2 and mgx2:FindFirstChild("Vote")

        if not v3b or not v3b.Visible then break end

      end

      -- Step 2: vote ended → TP2 is happening. Wait for OnTeleport or just wait

      -- for the character to respawn in the new place (arena pivot X >> 1000).

      -- We wait up to 15s for the character position to change to arena coords.

      local tArena = os.clock()

      while os.clock() - tArena < 15 do

        task.wait(0.3)

        local char2 = LP.Character

        local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")

        if hrp2 and math.abs(hrp2.Position.X) > 1000 then

          -- Arrived in arena (all arenas have |X| > 1000)

          break

        end

      end

      task.wait(1.5) -- settle after arena spawn

      print("[TK4] Arena TP2 complete — loading menu now")

    else

      -- No vote UI found (casual match or timeout) — arrived directly in arena

      task.wait(2)

    end



    -- METHOD 1 (preferred): local files (clean copy — no Panda crash risk)

    local paths = {

      "TK4_RespectPVP_final_v10_mobile.lua",

      "FK4 RESPECT PVP GOOD.lua",

      "TK4/TK4_RespectPVP_final_v10_mobile.lua",

      "tk4/TK4_RespectPVP_final_v10_mobile.lua",

      "scripts/TK4_RespectPVP_final_v10_mobile.lua",

      "autoexec/TK4_RespectPVP_final_v10_mobile.lua",

      "TK4_cache.lua",

    }

    for _, p in ipairs(paths) do

      if isfile and isfile(p) then

        local fOk, fErr = pcall(function()

          loadstring(readfile(p))()

        end)

        if fOk then

          print("[TK4] Loaded from file: " .. p)

          return

        else

          warn("[TK4] File load failed:", p, fErr)

        end

      end

    end



    -- METHOD 2 (fallback): hosted URL

    local LOAD_URL = "]] .. TK4_SCRIPT_URL .. [["

    if LOAD_URL ~= "" then

      local urlOk, urlErr = pcall(function()

        loadstring(game:HttpGet(LOAD_URL, true))()

      end)

      if urlOk then

        print("[TK4] Loaded from URL after teleport!")

        return

      else

        warn("[TK4] URL load failed:", urlErr)

      end

    end

    warn("[TK4] No source found after teleport! Place the file in the executor workspace.")

  ]]

pcall(function()

-- DEDUPE: only ONE OnTeleport listener allowed across all instances.

-- If a previous instance already registered the listener, skip.

if GStore.TK4_TP_LISTENER_ACTIVE then

  print("[TK4] TP listener already registered by previous instance — skipping duplicate")

  return

end

GStore.TK4_TP_LISTENER_ACTIVE = true

LP.OnTeleport:Connect(function(teleportState)

if Config.PersistentLoad

and (teleportState == Enum.TeleportState.Started

or teleportState == Enum.TeleportState.InProgress) then

-- DEDUPE: prevent multiple queues from firing on same TP

if GStore.TK4_TP_QUEUED then return end

GStore.TK4_TP_QUEUED = true

task.delay(3, function() GStore.TK4_TP_QUEUED = nil end)

pcall(saveConfigToFile)

pcall(TK4_queueOnTeleport, TK4_Q_CODE)

print("[TK4] TP Queue registered (auto-load next match)")

end

end)

end)

print("[TK4] Persistent teleport queue ready (auto-load next match)")

task.spawn(function()

pcall(function()

if writefile and isfile and game.HttpGet and TK4_SCRIPT_URL ~= "" then

if not isfile("TK4_cache.lua") then

local src = game:HttpGet(TK4_SCRIPT_URL, true)

if src and #src > 1000 then

writefile("TK4_cache.lua", src)

print("[TK4] Auto-installed local fallback copy (TK4_cache.lua)")

end

end

end

end)

end)

else

print("[TK4] No queue_on_teleport found — manual re-execute needed after teleport")

end

loadConfigFromFile()

task.spawn(function()

local ok, err = pcall(function()

local pg = LP:WaitForChild("PlayerGui", 30)

local mg = pg and pg:WaitForChild("MainGui", 30)

local welcome = mg and mg:WaitForChild("Welcome", 30)

if not welcome then return end

local function pressSkip()

local card = welcome:FindFirstChild("Canvas")

card = card and card:FindFirstChild("Card")

local skipBtn = card and card:FindFirstChild("Skip")

if skipBtn and typeof(getconnections) == "function" then

for _, conn in ipairs(getconnections(skipBtn.Activated)) do

pcall(function() conn:Fire() end)

end

print("[TK4] Auto-skipped game intro")

end

end

welcome:GetPropertyChangedSignal("Visible"):Connect(function()

if welcome.Visible then

task.delay(1.5, function()

if welcome.Visible then pcall(pressSkip) end

end)

end

end)

if welcome.Visible then

task.delay(1.5, function()

if welcome.Visible then pcall(pressSkip) end

end)

end

end)

if not ok then print("[TK4] Auto-skip intro unavailable: " .. tostring(err)) end

end)

do

local function fix(key, def, maxV)

local v = tonumber(Config[key])

if not v or v < 1 or v > maxV then Config[key] = def end

end

fix("SpeedBoostValue", 40, 100)

fix("CrouchSpeed", 40, 100)

end

local function isTeammate(player)

if not player or player == LP then return true end

local ok, res = pcall(function()

if LP.Team ~= nil and player.Team ~= nil then

return LP.Team == player.Team

end

if (LP.Team ~= nil) ~= (player.Team ~= nil) and #game:GetService("Teams"):GetChildren() > 0 then

return false

end

local lpAttr = LP:GetAttribute("Team") or LP:GetAttribute("TeamID")

local plAttr = player:GetAttribute("Team") or player:GetAttribute("TeamID")

if lpAttr ~= nil and plAttr ~= nil and tostring(lpAttr) ~= "" and tostring(plAttr) ~= "" then

return tostring(lpAttr) == tostring(plAttr)

end

if LP.Character and player.Character then

local cAttrL = LP.Character:GetAttribute("Team") or LP.Character:GetAttribute("TeamID")

local cAttrP = player.Character:GetAttribute("Team") or player.Character:GetAttribute("TeamID")

if cAttrL ~= nil and cAttrP ~= nil and tostring(cAttrL) ~= "" and tostring(cAttrP) ~= "" then

return tostring(cAttrL) == tostring(cAttrP)

end

end

return false

end)

return ok and res or false

end

local function isPlayerDeflecting(player)

if not player or not player.Character then return false end

local char = player.Character

local tool = char:FindFirstChildOfClass("Tool") or char:FindFirstChild("Katana")

if tool and (tool.Name:lower():find("katana") or tool.Name:lower():find("blade") or tool.Name:lower():find("scythe") or tool.Name:lower():find("sword")) then

local hum = char:FindFirstChildOfClass("Humanoid")

if hum then

for _, trk in ipairs(hum:GetPlayingAnimationTracks()) do

local aName = trk.Animation and trk.Animation.Name:lower() or ""

if aName:find("deflect") or aName:find("parry") or aName:find("block") or aName:find("reflect") then

return true

end

end

end

end

return false

end

local IMMUNE_ATTRS = { "IsInvincible", "Immune", "IsImmune", "SpawnProtection" }

local function isTargetImmune(player)

if not player then return false end

local char = player.Character

if char then

if char:FindFirstChildOfClass("ForceField") then return true end

local prot = char:GetAttribute("ProtectedUntil")

if typeof(prot) == "number" and (prot - workspace:GetServerTimeNow()) > 0 then

return true

end

for _, attr in ipairs(IMMUNE_ATTRS) do

if char:GetAttribute(attr) == true then return true end

end

end

if typeof(player) == "Instance" and player.GetAttribute then

for _, attr in ipairs(IMMUNE_ATTRS) do

if player:GetAttribute(attr) == true then return true end

end

end

return false

end

local RaycastFilter = RaycastParams.new()

RaycastFilter.FilterType = Enum.RaycastFilterType.Exclude

RaycastFilter.IgnoreWater = true

local function isVisible(fromPos, toPos, char)

if not Config.WallCheck then return true end

local excludeList = { Camera, LP.Character }

if char then table.insert(excludeList, char) end

RaycastFilter.FilterDescendantsInstances = excludeList

local result = Workspace:Raycast(fromPos, toPos - fromPos, RaycastFilter)

return result == nil

end

local function getTargetPart(char, overridePart)

if not char then return nil end

local hp = overridePart or Config.HitPart

if hp == "Head" then

return char:FindFirstChild("Head") or char:FindFirstChild("HitboxHead") or char:FindFirstChild("HumanoidRootPart")

elseif hp == "Neck" then

return char:FindFirstChild("Neck") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

elseif hp == "Torso" or hp == "HumanoidRootPart" or hp == "Body" then

return char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")

elseif hp == "Closest" then

local camPos = Camera.CFrame.Position

local best, bestDist = nil, math.huge

for _, n in ipairs({"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}) do

local p = char:FindFirstChild(n)

if p then

local d = (p.Position - camPos).Magnitude

if d < bestDist then best = p; bestDist = d end

end

end

return best

else

return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

end

end

local function getAimScreenCenter()

  local vp = (Camera and Camera.ViewportSize) or Vector2.new(1366, 768)

  return Vector2.new(vp.X / 2, vp.Y / 2)

end

local function findSilentTarget()

if not (Config.SilentAim or Config.CombatMaster) then return nil, nil end

local mousePos = getAimScreenCenter()

local camPos   = Camera.CFrame.Position

local shortest = Config.CombatMaster and 9999 or Config.FOVRadius

local bestPart, bestPlayer = nil, nil

local function considerChar(char, pseudoPlayer)

if not char then return end

local hum = char:FindFirstChildOfClass("Humanoid")

if not hum or hum.Health <= 0 then return end

if Config.SkipDeflect and isPlayerDeflecting(pseudoPlayer) then return end

if Config.SkipImmune and isTargetImmune(pseudoPlayer) then return end

local part = getTargetPart(char, Config.HitPart)

if not part then return end

local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

if not onScreen or screenPos.Z <= 0 then return end

local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

if dist <= shortest then

if not Config.WallCheck or isVisible(camPos, part.Position, char) then

shortest   = dist

bestPart   = part

bestPlayer = pseudoPlayer

end

end

end

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LP and (not Config.TeamCheck or not isTeammate(player)) then

considerChar(player.Character, player)

end

end

local matchBotsFolder = workspace:FindFirstChild("MatchBots")

if matchBotsFolder then

for _, bot in ipairs(matchBotsFolder:GetChildren()) do

local isEnemyBot = true

if Config.TeamCheck and ClientState and ClientState.Match and ClientState.Match.Players then

for _, entry in ipairs(ClientState.Match.Players) do

if entry.Name == bot.Name and entry.Team and ClientState.Match.Team and entry.Team == ClientState.Match.Team then

isEnemyBot = false

break

end

end

end

if isEnemyBot then

considerChar(bot, { Name = bot.Name, DisplayName = bot.Name, Character = bot, IsBot = true })

end

end

end

local targetsFolder = workspace:FindFirstChild("Targets")

if targetsFolder then

for _, dummy in ipairs(targetsFolder:GetChildren()) do

considerChar(dummy, { Name = dummy.Name, DisplayName = dummy.Name, Character = dummy, IsBot = true })

end

end

return bestPart, bestPlayer

end

if hookmetamethod then

local rawNamecall

rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)

local method = getnamecallmethod()

local args = {...}

if (Config.SilentAim or Config.CombatMaster) and method == "FireServer" and typeof(self) == "Instance" then

if self.Name == "WeaponFire" then

local targetPart, targetPlayer = State.SilentTarget, State.CachedTarget

if not targetPart then

targetPart, targetPlayer = findSilentTarget()

end

if targetPart then

local activeHitChance = Config.CombatMaster and 100 or Config.HitChance

local hitChanceOk = (activeHitChance >= 100) or (math.random(1, 100) <= activeHitChance)

if hitChanceOk then

local origin = args[1]

local targetPos = targetPart.Position

if typeof(origin) == "Vector3" then

local toTarget = targetPos - origin

args[2] = toTarget.Unit

args[4] = targetPos

args[5] = -toTarget.Unit

if args[7] then args[7] = toTarget.Unit end

else

args[4] = targetPos

args[5] = Vector3.new(0, 1, 0)

end

args[3] = targetPart

if args[8] then args[8] = 0 end

State.ShotsHooked = State.ShotsHooked + 1

State.LastShotTarget = targetPlayer

State.LastShotTime = os.clock()

end

end

end

end

return rawNamecall(self, table.unpack(args))

end))

GStore.TK4_RAW_NAMECALL = rawNamecall

end

do

local aimParams = RaycastParams.new()

aimParams.FilterType = Enum.RaycastFilterType.Exclude

aimParams.IgnoreWater = true

local isTouchOnly = UserInputService.TouchEnabled

and not UserInputService.KeyboardEnabled

and not UserInputService.MouseEnabled

local fireHeld, aimHeld, keyHeld = false, false, false

local lastFireTime = 0

regConn(UserInputService.InputBegan:Connect(function(inp, gpe)

if inp.UserInputType == Enum.UserInputType.MouseButton1 then

if not gpe then

fireHeld = true

lastFireTime = os.clock()

end

elseif inp.UserInputType == Enum.UserInputType.MouseButton2 then

aimHeld = true

elseif inp.UserInputType == Enum.UserInputType.Keyboard then

if not gpe and Config.CamAimKey and inp.KeyCode == Config.CamAimKey then keyHeld = true end

end

end))

regConn(UserInputService.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 then

fireHeld = false

lastFireTime = os.clock()

elseif inp.UserInputType == Enum.UserInputType.MouseButton2 then

aimHeld = false

elseif inp.UserInputType == Enum.UserInputType.Keyboard then

if Config.CamAimKey and inp.KeyCode == Config.CamAimKey then keyHeld = false end

end

end))

local function modeActive()

local mode = Config.CamAimMode or "Auto"

if mode == "Auto" then

mode = isTouchOnly and "Always" or "While Firing"

end

if mode == "Always" then return true end

if mode == "Hold Key" then return keyHeld end

local now = os.clock()

local linger = Config.CamAimLinger or 0.40

local recentlyFired = ((now - lastFireTime) < linger) or ((now - (State.LastShotTime or 0)) < linger)

return fireHeld or aimHeld or recentlyFired

end

local function useMouseMethod()

local m = Config.CamAimMethod or "Auto"

local hasRel = type(mousemoverel) == "function"

if m == "Mouse" then return hasRel end

if m == "Camera" then return false end

return hasRel and UserInputService.MouseEnabled and not isTouchOnly

end

local function targetStillValid(part, center, camPos, maxFOV)

if not part or not part.Parent then return false end

local ch = part:FindFirstAncestorOfClass("Model")

local hum = ch and ch:FindFirstChildOfClass("Humanoid")

if not hum or hum.Health <= 0 then return false end

local pl = Players:GetPlayerFromCharacter(ch)

if pl and pl == LP then return false end

if pl and Config.TeamCheck and isTeammate(pl) then return false end

local sp, on = Camera:WorldToViewportPoint(part.Position)

if not on or sp.Z <= 0 then return false end

local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude

if d > maxFOV then return false end

if Config.CamAimWallCheck then

aimParams.FilterDescendantsInstances = { Camera, LP.Character, ch }

if Workspace:Raycast(camPos, part.Position - camPos, aimParams) ~= nil then return false end

end

return true

end

local lastTarget, lastSwitch = nil, 0

local stickyPart = nil

local function pickAimTarget()

local vp = Camera.ViewportSize

local center = Vector2.new(vp.X / 2, vp.Y / 2)

local camPos = Camera.CFrame.Position

local bestPart, bestD = nil, Config.CamAimFOV

if Config.CamAimSticky and stickyPart and targetStillValid(stickyPart, center, camPos, Config.CamAimFOV * 1.4) then

return stickyPart

end

local function considerAimbotChar(ch, pseudoPlayer)

if not ch then return end

local hum = ch:FindFirstChildOfClass("Humanoid")

if not hum or hum.Health <= 0 then return end

if Config.SkipImmune and isTargetImmune(pseudoPlayer) then return end

if Config.SkipDeflect and isPlayerDeflecting(pseudoPlayer) then return end

local part = getTargetPart(ch, Config.CamAimPart)

if not part then return end

local sp, on = Camera:WorldToViewportPoint(part.Position)

if not on or sp.Z <= 0 then return end

local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude

if d <= bestD then

local visible = true

if Config.CamAimWallCheck then

aimParams.FilterDescendantsInstances = { Camera, LP.Character, ch }

visible = Workspace:Raycast(camPos, part.Position - camPos, aimParams) == nil

end

if visible then bestD, bestPart = d, part end

end

end

for _, pl in ipairs(Players:GetPlayers()) do

if pl ~= LP and (not Config.TeamCheck or not isTeammate(pl)) then

considerAimbotChar(pl.Character, pl)

end

end

local matchBotsFolder = workspace:FindFirstChild("MatchBots")

if matchBotsFolder then

for _, bot in ipairs(matchBotsFolder:GetChildren()) do

local isEnemyBot = true

if Config.TeamCheck and ClientState and ClientState.Match and ClientState.Match.Players then

for _, entry in ipairs(ClientState.Match.Players) do

if entry.Name == bot.Name and entry.Team and ClientState.Match.Team and entry.Team == ClientState.Match.Team then

isEnemyBot = false

break

end

end

end

if isEnemyBot then

considerAimbotChar(bot, { Name = bot.Name, DisplayName = bot.Name, Character = bot, IsBot = true })

end

end

end

local targetsFolder = workspace:FindFirstChild("Targets")

if targetsFolder then

for _, dummy in ipairs(targetsFolder:GetChildren()) do

considerAimbotChar(dummy, { Name = dummy.Name, DisplayName = dummy.Name, Character = dummy, IsBot = true })

end

end

return bestPart

end

local curCamCF = nil

local RS_NAME = "TK4_CamAimV5"

local smoothedVelocities = {}

local function releaseBlend()

if not curCamCF then return end

local base = Camera.CFrame

curCamCF = curCamCF:Lerp(base, 0.15)

local _, ang = (curCamCF:ToObjectSpace(base)):ToAxisAngle()

if math.abs(ang) < math.rad(1) then

curCamCF = nil

else

Camera.CFrame = curCamCF

end

end

local function stepCameraAimbot(dt)

pcall(function()

if not Config.CamAimbot then curCamCF = nil; return end

if Config.GuiVisible then curCamCF = nil; return end

local ch = LP.Character

local myHum = ch and ch:FindFirstChildOfClass("Humanoid")

if not myHum or myHum.Health <= 0 then curCamCF = nil; return end

if not modeActive() then releaseBlend(); return end

local part = pickAimTarget()

if part and part ~= lastTarget then

local delay = Config.CamAimSwitchDelay or 0

local vp0 = Camera.ViewportSize

if lastTarget and delay > 0 and (tick() - lastSwitch) < delay

and targetStillValid(lastTarget, Vector2.new(vp0.X / 2, vp0.Y / 2), Camera.CFrame.Position, Config.CamAimFOV) then

part = lastTarget

else

lastTarget, lastSwitch = part, tick()

end

elseif not part then

lastTarget = nil

end

stickyPart = part

local pChar = nil

if part then

State.TargetPart = part

pChar = part:FindFirstAncestorOfClass("Model")

State.CachedTarget = pChar and Players:GetPlayerFromCharacter(pChar)

if State.CachedTarget then

State.TargetDist = math.floor((part.Position - Camera.CFrame.Position).Magnitude)

local hum2 = pChar:FindFirstChildOfClass("Humanoid")

State.TargetHP = hum2 and math.floor(hum2.Health) or 0

end

end

if not part then releaseBlend(); return end

local rawVel = part.AssemblyLinearVelocity

local prevVel = smoothedVelocities[part] or rawVel

local alpha = math.clamp(dt * 14, 0.1, 0.7)

local sVel = prevVel:Lerp(rawVel, alpha)

smoothedVelocities[part] = sVel

for pRef, _ in pairs(smoothedVelocities) do

if pRef ~= part and (not pRef.Parent or not pRef:IsDescendantOf(workspace)) then

smoothedVelocities[pRef] = nil

end

end

local isRolling = false

if pChar then

local hum = pChar:FindFirstChildOfClass("Humanoid")

if hum then

for _, trk in ipairs(hum:GetPlayingAnimationTracks()) do

local aName = trk.Animation and trk.Animation.Name:lower() or ""

if aName:find("roll") or aName:find("dodge") or aName:find("dash") then

isRolling = true

break

end

end

end

end

local aimPos = part.Position

local targetDist = (aimPos - Camera.CFrame.Position).Magnitude

if Config.CamAimPrediction then

local baseLead = 0.12

local distLead = math.clamp(targetDist / 700, 0, 0.08)

local totalLead = (baseLead + distLead) * (Config.CamAimPredStrength or 1)

local lead = sVel * totalLead

lead = Vector3.new(lead.X, math.clamp(lead.Y, -5, 5), lead.Z)

if lead.Magnitude > 14 then

lead = lead.Unit * 14

end

aimPos = aimPos + lead

end

local targetSpeed = sVel.Magnitude

local speedBoost = math.clamp(targetSpeed / 25, 0, 0.35)

if isRolling then

speedBoost = math.max(speedBoost, 0.45)

end

local baseSmooth = (Config.CamAimSmooth or 35) / 100

local adaptiveS = math.clamp(baseSmooth + speedBoost, 0.05, 0.95)

local a = (adaptiveS >= 0.98) and 1 or (1 - (1 - adaptiveS) ^ (math.min(dt, 0.1) * 60))

if useMouseMethod() then

curCamCF = nil

local sp, on = Camera:WorldToViewportPoint(aimPos)

if on and sp.Z > 0 then

local vp = Camera.ViewportSize

local gain = math.min(a, 0.65) * 0.72

local ex, ey = sp.X - vp.X / 2, sp.Y - vp.Y / 2

if math.abs(ex) < 0.8 then ex = 0 end

if math.abs(ey) < 0.8 then ey = 0 end

local dx, dy = ex * gain, ey * gain

local m = 60

if dx ~= 0 or dy ~= 0 then

pcall(mousemoverel, math.clamp(dx, -m, m), math.clamp(dy, -m, m))

end

end

else

local base = Camera.CFrame

local dir = aimPos - base.Position

if dir.Magnitude < 0.5 then return end

dir = dir.Unit

local maxY = math.sin(math.rad(75))

if math.abs(dir.Y) > maxY then

local flat = Vector3.new(dir.X, 0, dir.Z)

flat = flat.Magnitude > 1e-3 and flat.Unit or base.LookVector

local c = math.sqrt(1 - maxY * maxY)

dir = Vector3.new(flat.X * c, maxY * (dir.Y > 0 and 1 or -1), flat.Z * c)

end

local goal = CFrame.lookAt(base.Position, base.Position + dir)

curCamCF = (curCamCF or base)

curCamCF = CFrame.new(base.Position) * curCamCF.Rotation

curCamCF = curCamCF:Lerp(goal, a)

Camera.CFrame = curCamCF

end

end) 

end

pcall(function() RunService:UnbindFromRenderStep(RS_NAME) end)

RunService:BindToRenderStep(RS_NAME, Enum.RenderPriority.Last.Value, stepCameraAimbot)

end

local HasDrawing = pcall(function() return Drawing ~= nil and Drawing.new ~= nil end) and Drawing ~= nil

local FOVCircle = nil

if HasDrawing then

pcall(function()

if GStore._TK4_FOVCircle then GStore._TK4_FOVCircle:Remove() end

GStore._TK4_FOVCircle = nil

end)

pcall(function()

FOVCircle = Drawing.new("Circle")

FOVCircle.Visible      = Config.DrawFOV

FOVCircle.Radius       = Config.FOVRadius

FOVCircle.Color        = C.accent

FOVCircle.Thickness    = 1.8

FOVCircle.Filled       = false

FOVCircle.Transparency = 1

FOVCircle.NumSides     = 64

GStore._TK4_FOVCircle = FOVCircle  

end)

end

local R15_BONES = {

{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},

{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},

{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},

{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},

{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},

}

local ESPGui

if GStore._TK4_ESPGui and GStore._TK4_ESPGui.Parent then

ESPGui = GStore._TK4_ESPGui

else

ESPGui = Instance.new("ScreenGui")

ESPGui.Name = "TK4_ESP_Overlays"

ESPGui.ResetOnSpawn = false

ESPGui.IgnoreGuiInset = true

ESPGui.DisplayOrder = 150

safeParentGui(ESPGui)

GStore._TK4_ESPGui = ESPGui

end

for _, ch in ipairs(ESPGui:GetChildren()) do pcall(function() ch:Destroy() end) end

local RESPECT_RANKS = {

["Unranked"] = { Color = Color3.fromRGB(120, 126, 140), Id = "Unranked" },

["Bronze"]   = { Color = Color3.fromRGB(205, 127, 50),  Id = "Bronze" },

["Silver"]   = { Color = Color3.fromRGB(192, 198, 210), Id = "Silver" },

["Gold"]     = { Color = Color3.fromRGB(255, 200, 60),  Id = "Gold" },

["Platinum"] = { Color = Color3.fromRGB(80, 220, 200),  Id = "Platinum" },

["Diamond"]  = { Color = Color3.fromRGB(90, 170, 255),  Id = "Diamond" },

["Master"]   = { Color = Color3.fromRGB(170, 90, 255),  Id = "Master" },

["Champion"] = { Color = Color3.fromRGB(255, 80, 110),  Id = "Champion" },

}

local function getRankInfo(rankName)

if not rankName or rankName == "" then return RESPECT_RANKS["Unranked"] end

local upper = string.upper(tostring(rankName))

if string.find(upper, "CHAMPION") then return RESPECT_RANKS["Champion"]

elseif string.find(upper, "MASTER") then return RESPECT_RANKS["Master"]

elseif string.find(upper, "DIAMOND") then return RESPECT_RANKS["Diamond"]

elseif string.find(upper, "PLATINUM") then return RESPECT_RANKS["Platinum"]

elseif string.find(upper, "GOLD") then return RESPECT_RANKS["Gold"]

elseif string.find(upper, "SILVER") then return RESPECT_RANKS["Silver"]

elseif string.find(upper, "BRONZE") then return RESPECT_RANKS["Bronze"]

end

return RESPECT_RANKS["Unranked"]

end

local function getESPColor(key, defaultCol)
  local r = Config["esp_col_" .. key .. "_r"]
  local g = Config["esp_col_" .. key .. "_g"]
  local b = Config["esp_col_" .. key .. "_b"]
  if r and g and b then
    return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
  end
  return defaultCol or C.accent
end

local function newDrawing(class, props)
  local obj = Drawing.new(class)
  for k, v in pairs(props or {}) do obj[k] = v end
  return obj
end

local function createESP(player)
  if not HasDrawing then return nil end
  local esp = {
    box      = {newDrawing("Line",{}), newDrawing("Line",{}), newDrawing("Line",{}), newDrawing("Line",{})},
    corners  = {},
    name     = newDrawing("Text", {Center = true, Outline = true, Size = Config.ESP_TextSize, Font = 2}),
    rank     = newDrawing("Text", {Center = false, Outline = true, Size = 13, Font = 2}),
    level    = newDrawing("Text", {Center = false, Outline = true, Size = 15, Font = 2}),
    dist     = newDrawing("Text", {Center = true, Outline = true, Size = Config.ESP_TextSize, Font = 2}),
    health   = newDrawing("Line", {Thickness = 2.5}),
    healthBg = newDrawing("Line", {Thickness = 2.5, Color = Color3.fromRGB(30, 20, 38)}),
    head     = newDrawing("Circle", {NumSides = 24, Thickness = 1.5, Filled = false}),
    bones    = {},
    tracers  = newDrawing("Line", {Thickness = 1.2}),
  }
  for i = 1, 8 do esp.corners[i] = newDrawing("Line", {Thickness = 2}) end
  for i = 1, #R15_BONES do esp.bones[i] = newDrawing("Line", {Thickness = 1.4}) end

  -- Real In-Game Rank Badge Icon from Respect PVP Templates (3-layer composite: Base, Inner, Gem)
  pcall(function()
    local badgeFrame = Instance.new("Frame", ESPGui)
    badgeFrame.Name = "RankBadge"
    badgeFrame.Size = UDim2.fromOffset(18, 18)
    badgeFrame.BackgroundTransparency = 1
    badgeFrame.BorderSizePixel = 0
    badgeFrame.Visible = false

    local badgeBase = Instance.new("ImageLabel", badgeFrame)
    badgeBase.Name = "Base"
    badgeBase.Size = UDim2.new(1, 0, 1, 0)
    badgeBase.BackgroundTransparency = 1
    badgeBase.Image = "rbxassetid://77587354723565"
    badgeBase.ZIndex = 10

    local badgeInner = Instance.new("ImageLabel", badgeFrame)
    badgeInner.Name = "Inner"
    badgeInner.Size = UDim2.new(1, 0, 1, 0)
    badgeInner.BackgroundTransparency = 1
    badgeInner.Image = "rbxassetid://70726727364699"
    badgeInner.ImageColor3 = Color3.fromRGB(120, 126, 140)
    badgeInner.ZIndex = 11

    local badgeGem = Instance.new("ImageLabel", badgeFrame)
    badgeGem.Name = "Gem"
    badgeGem.Size = UDim2.new(1, 0, 1, 0)
    badgeGem.BackgroundTransparency = 1
    badgeGem.Image = "rbxassetid://123146282595303"
    badgeGem.ZIndex = 12

    esp.badge = badgeFrame
    esp.badgeInner = badgeInner
  end)

  return esp
end

local function hideESP(esp)
  if not esp then return end
  for _, l in ipairs(esp.box) do l.Visible = false end
  for _, l in ipairs(esp.corners) do l.Visible = false end
  esp.name.Visible = false
  if esp.rank then esp.rank.Visible = false end
  if esp.level then esp.level.Visible = false end
  if esp.badge then esp.badge.Visible = false end
  esp.dist.Visible = false
  esp.health.Visible = false
  esp.healthBg.Visible = false
  esp.head.Visible = false
  esp.tracers.Visible = false
  for _, b in ipairs(esp.bones) do b.Visible = false end
end

local function destroyESP(esp)
  if not esp then return end
  for _, l in ipairs(esp.box) do pcall(function() l:Remove() end) end
  for _, l in ipairs(esp.corners) do pcall(function() l:Remove() end) end
  pcall(function() esp.name:Remove() end)
  if esp.rank then pcall(function() esp.rank:Remove() end) end
  if esp.level then pcall(function() esp.level:Remove() end) end
  if esp.badge then pcall(function() esp.badge:Destroy() end) end
  pcall(function() esp.dist:Remove() end)
  pcall(function() esp.health:Remove() end)
  pcall(function() esp.healthBg:Remove() end)
  pcall(function() esp.head:Remove() end)
  pcall(function() esp.tracers:Remove() end)
  for _, b in ipairs(esp.bones) do pcall(function() b:Remove() end) end
end

local function updateESP(player, esp)
  -- Keep ESP visible even if menu is open
  if not Config.ESP_Master or not esp then hideESP(esp); return end
  if player == LP or (Config.ESP_TeamCheck and isTeammate(player)) then hideESP(esp); return end

  local char = player.Character
  if not char then hideESP(esp); return end
  local hum  = char:FindFirstChildOfClass("Humanoid")
  local hrp  = char:FindFirstChild("HumanoidRootPart")
  local head = char:FindFirstChild("Head")
  if not hum or hum.Health <= 0 or not hrp then hideESP(esp); return end

  local camPos = Camera.CFrame.Position
  local hrpPos = hrp.Position
  local dist3d = (hrpPos - camPos).Magnitude
  if dist3d > Config.ESP_MaxDistance then hideESP(esp); return end

  -- Direct 3D bounding projection (Ultra-fast, zero-lag, no caching jitter)
  local headPos = (head and head.Position) or (hrpPos + Vector3.new(0, 1.5, 0))
  local topWorld = headPos + Vector3.new(0, 0.7, 0)
  local botWorld = hrpPos - Vector3.new(0, 3.0, 0)

  local topScreen, topOn = Camera:WorldToViewportPoint(topWorld)
  local botScreen, botOn = Camera:WorldToViewportPoint(botWorld)

  if topScreen.Z <= 0 or botScreen.Z <= 0 or (not topOn and not botOn) then
    hideESP(esp)
    return
  end

  local boxH = math.abs(botScreen.Y - topScreen.Y)
  if boxH < 3 or boxH > 4000 then hideESP(esp); return end

  local boxW = math.floor(boxH * 0.58)
  local midX = math.floor((topScreen.X + botScreen.X) * 0.5)
  local topY = math.floor(math.min(topScreen.Y, botScreen.Y))
  local botY = topY + boxH
  local leftX = math.floor(midX - (boxW * 0.5))
  local rightX = leftX + boxW

  local hpRatio = math.clamp(hum.Health / (hum.MaxHealth > 0 and hum.MaxHealth or 100), 0, 1)
  local hpColor = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 50)

  -- Staff ESP: override box/name color when player is staff
  local staffEntry = State._staffInServer and State._staffInServer[player]
  local espBoxColor = staffEntry and staffEntry.color or C.accent
  local staffTag = staffEntry and (" [" .. staffEntry.text .. "]") or ""

  -- Custom ESP component colors from Free Color Picker
  local customBoxCol    = getESPColor("box", espBoxColor)
  local customSkelCol   = getESPColor("skel", Color3.fromRGB(245, 245, 255))
  local customNameCol   = getESPColor("name", staffEntry and staffEntry.color or Color3.fromRGB(255, 255, 255))
  local customDistCol   = getESPColor("dist", Color3.fromRGB(180, 170, 200))
  local customTracerCol = getESPColor("tracer", C.accent)
  local customHeadCol   = getESPColor("head", C.accent)

  -- Level / Rank from player attributes (RespectPVP_Player_Roles_And_Levels_Guide.md)
  local plLevel  = (typeof(player) == "Instance" and player:GetAttribute("Level")) or (type(player) == "table" and player.Level) or nil
  local plRank   = (typeof(player) == "Instance" and player:GetAttribute("RankName")) or (type(player) == "table" and player.RankName) or nil
  local rankInfo = getRankInfo(plRank)
  local rankColor = rankInfo.Color

  if Config.ESP_Box then
    local c = customBoxCol
    if Config.ESP_BoxStyle == "Corner" then
      for _, l in ipairs(esp.box) do l.Visible = false end
      local cl = math.floor(boxW * 0.25)
      local ct = math.floor(boxH * 0.25)
      esp.corners[1].From = Vector2.new(leftX, topY); esp.corners[1].To = Vector2.new(leftX + cl, topY)
      esp.corners[2].From = Vector2.new(leftX, topY); esp.corners[2].To = Vector2.new(leftX, topY + ct)
      esp.corners[3].From = Vector2.new(rightX, topY); esp.corners[3].To = Vector2.new(rightX - cl, topY)
      esp.corners[4].From = Vector2.new(rightX, topY); esp.corners[4].To = Vector2.new(rightX, topY + ct)
      esp.corners[5].From = Vector2.new(leftX, botY); esp.corners[5].To = Vector2.new(leftX + cl, botY)
      esp.corners[6].From = Vector2.new(leftX, botY); esp.corners[6].To = Vector2.new(leftX, botY - ct)
      esp.corners[7].From = Vector2.new(rightX, botY); esp.corners[7].To = Vector2.new(rightX - cl, botY)
      esp.corners[8].From = Vector2.new(rightX, botY); esp.corners[8].To = Vector2.new(rightX, botY - ct)
      for i = 1, 8 do esp.corners[i].Color = c; esp.corners[i].Visible = true end
    else
      for _, l in ipairs(esp.corners) do l.Visible = false end
      esp.box[1].From = Vector2.new(leftX, topY); esp.box[1].To = Vector2.new(rightX, topY)
      esp.box[2].From = Vector2.new(rightX, topY); esp.box[2].To = Vector2.new(rightX, botY)
      esp.box[3].From = Vector2.new(rightX, botY); esp.box[3].To = Vector2.new(leftX, botY)
      esp.box[4].From = Vector2.new(leftX, botY); esp.box[4].To = Vector2.new(leftX, topY)
      for i = 1, 4 do esp.box[i].Color = c; esp.box[i].Visible = true end
    end
  else
    for _, l in ipairs(esp.box) do l.Visible = false end
    for _, l in ipairs(esp.corners) do l.Visible = false end
  end

  -- Name Line (Immediately above head/box)
  if Config.ESP_Names then
    local nameText = (player.DisplayName or player.Name or "Unknown") .. staffTag
    local nameColor = staffEntry and staffEntry.color or customNameCol
    if Config.ESP_Alerts and char then
      local nowTime = workspace:GetServerTimeNow()
      local prot = char:GetAttribute("ProtectedUntil")
      local band = char:GetAttribute("BandageEnds")
      local arm = char:GetAttribute("ArmorEnds")
      if typeof(prot) == "number" and (prot - nowTime) > 0 then
        nameText = nameText .. " [PROTECTED]"
        nameColor = Color3.fromRGB(110, 200, 255)
      elseif typeof(band) == "number" and (band - nowTime) > 0 then
        nameText = nameText .. " [HEALING]"
        nameColor = Color3.fromRGB(255, 220, 80)
      elseif typeof(arm) == "number" and (arm - nowTime) > 0 then
        nameText = nameText .. " [ARMORING]"
        nameColor = Color3.fromRGB(255, 220, 80)
      end
      if Config.ESP_FiringAlert and ClientState and ClientState.ShotTimes then
        local lastShot = ClientState.ShotTimes[char]
        if type(lastShot) == "number" and (os.clock() - lastShot) < 0.35 then
          nameText = nameText .. " [FIRING]"
          nameColor = Color3.fromRGB(255, 85, 40)
        end
      end
    end
    esp.name.Text = nameText
    esp.name.Position = Vector2.new(midX, topY - 14)
    esp.name.Color = nameColor
    esp.name.Visible = true
  else
    esp.name.Visible = false
  end

  -- Real In-Game Rank Badge + Big Lv.X (Size 15) + Exact Official Rank Color
  local showRank = Config.ESP_Rank and plRank and plRank ~= ""
  local showLevel = Config.ESP_Level and plLevel ~= nil

  if showRank or showLevel then
    local headerY = topY - (Config.ESP_Names and 32 or 16)
    local lvlStr  = showLevel and ("Lv." .. tostring(plLevel)) or ""
    local rkStr   = showRank and tostring(plRank) or ""

    local lvlW   = showLevel and (#lvlStr * 8.5) or 0
    local rkW    = showRank and (#rkStr * 7.2) or 0
    local badgeW = (showRank and esp.badge) and 18 or 0
    local gap    = 5
    local totalW = (badgeW > 0 and (badgeW + gap) or 0) + (lvlW > 0 and (lvlW + gap) or 0) + rkW
    local startX = midX - math.floor(totalW * 0.5)

    local curX = startX
    if badgeW > 0 and esp.badge then
      esp.badge.Position = UDim2.fromOffset(math.floor(curX), math.floor(headerY - 1))
      if esp.badgeInner then esp.badgeInner.ImageColor3 = rankColor end
      esp.badge.Visible = true
      curX = curX + badgeW + gap
    elseif esp.badge then
      esp.badge.Visible = false
    end

    if showLevel and esp.level then
      esp.level.Text = lvlStr
      esp.level.Size = 15
      esp.level.Color = Color3.fromRGB(255, 235, 120) -- Prominent warm gold
      esp.level.Position = Vector2.new(math.floor(curX), math.floor(headerY))
      esp.level.Visible = true
      curX = curX + lvlW + gap
    elseif esp.level then
      esp.level.Visible = false
    end

    if showRank and esp.rank then
      esp.rank.Text = rkStr
      esp.rank.Size = 13
      esp.rank.Color = rankColor -- Official exact Rank Color!
      esp.rank.Position = Vector2.new(math.floor(curX), math.floor(headerY + 1))
      esp.rank.Visible = true
    elseif esp.rank then
      esp.rank.Visible = false
    end
  else
    if esp.badge then esp.badge.Visible = false end
    if esp.level then esp.level.Visible = false end
    if esp.rank then esp.rank.Visible = false end
  end

  if Config.ESP_Distance then
    esp.dist.Text = math.floor(dist3d) .. "m"
    esp.dist.Position = Vector2.new(midX, botY + 2)
    esp.dist.Color = customDistCol
    esp.dist.Visible = true
  else esp.dist.Visible = false end

  if Config.ESP_Health then
    local barH = math.floor(boxH * hpRatio)
    esp.healthBg.From = Vector2.new(leftX - 5, topY); esp.healthBg.To = Vector2.new(leftX - 5, botY); esp.healthBg.Visible = true
    esp.health.From = Vector2.new(leftX - 5, botY - barH); esp.health.To = Vector2.new(leftX - 5, botY)
    esp.health.Color = hpColor; esp.health.Visible = true
  else esp.health.Visible = false; esp.healthBg.Visible = false end

  if Config.ESP_Head and head then
    local hp, hOn = Camera:WorldToViewportPoint(head.Position)
    if hOn and hp.Z > 0 then
      esp.head.Position = Vector2.new(hp.X, hp.Y)
      esp.head.Radius = math.clamp(boxW * 0.22, 2.5, 12)
      esp.head.Color = customHeadCol
      esp.head.Visible = true
    else esp.head.Visible = false end
  else esp.head.Visible = false end

  if Config.ESP_Skeleton and dist3d < 220 then
    -- Cache body part references to eliminate 28 FindFirstChild lookups per frame
    local parts = esp._cachedParts
    if not parts or esp._cachedChar ~= char then
      parts = {}
      for _, bone in ipairs(R15_BONES) do
        parts[bone[1]] = char:FindFirstChild(bone[1])
        parts[bone[2]] = char:FindFirstChild(bone[2])
      end
      esp._cachedParts = parts
      esp._cachedChar = char
    end

    local camW, camH = Camera.ViewportSize.X, Camera.ViewportSize.Y
    for i, bone in ipairs(R15_BONES) do
      local p1 = parts[bone[1]]
      local p2 = parts[bone[2]]
      if p1 and p2 then
        local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
        local s2, on2 = Camera:WorldToViewportPoint(p2.Position)
        if s1.Z > 0 and s2.Z > 0 and (on1 or on2) and
           s1.X >= -50 and s1.X <= camW + 50 and s1.Y >= -50 and s1.Y <= camH + 50 and
           s2.X >= -50 and s2.X <= camW + 50 and s2.Y >= -50 and s2.Y <= camH + 50 then
          esp.bones[i].From = Vector2.new(s1.X, s1.Y)
          esp.bones[i].To   = Vector2.new(s2.X, s2.Y)
          esp.bones[i].Color = customSkelCol
          esp.bones[i].Visible = true
        else esp.bones[i].Visible = false end
      else esp.bones[i].Visible = false end
    end
  else
    for _, b in ipairs(esp.bones) do b.Visible = false end
  end

  if Config.ESP_Tracers then
    local vx, vy = Camera.ViewportSize.X, Camera.ViewportSize.Y
    local origin = (Config.ESP_TracerOrigin == "Center" and Vector2.new(vx * 0.5, vy * 0.5))
      or (Config.ESP_TracerOrigin == "Mouse" and getAimScreenCenter())
      or Vector2.new(vx * 0.5, vy)
    esp.tracers.From = origin
    esp.tracers.To   = Vector2.new(midX, botY)
    esp.tracers.Color = customTracerCol
    esp.tracers.Visible = true
  else esp.tracers.Visible = false end
end

local CrosshairLines = {}
if HasDrawing then
  for i = 1, 4 do
    CrosshairLines[i] = Drawing.new("Line")
    CrosshairLines[i].Thickness = Config.Crosshair_Thick
    CrosshairLines[i].Color = C.accent
    CrosshairLines[i].Visible = false
  end
end

local function updateCrosshair()

if not HasDrawing or not Config.Crosshair_Enabled then

for _, l in ipairs(CrosshairLines) do l.Visible = false end

return

end

local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2

local s, g = Config.Crosshair_Size, Config.Crosshair_Gap

CrosshairLines[1].From = Vector2.new(cx - g, cy); CrosshairLines[1].To = Vector2.new(cx - g - s, cy)

CrosshairLines[2].From = Vector2.new(cx + g, cy); CrosshairLines[2].To = Vector2.new(cx + g + s, cy)

CrosshairLines[3].From = Vector2.new(cx, cy - g); CrosshairLines[3].To = Vector2.new(cx, cy - g - s)

CrosshairLines[4].From = Vector2.new(cx, cy + g); CrosshairLines[4].To = Vector2.new(cx, cy + g + s)

for i = 1, 4 do

CrosshairLines[i].Thickness = Config.Crosshair_Thick

CrosshairLines[i].Visible = true

end

end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TK4_V5_GUI"

ScreenGui.ResetOnSpawn = false

ScreenGui.IgnoreGuiInset = true

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.DisplayOrder = 100

safeParentGui(ScreenGui)

local TK4_INTRO_BG_ASSET  = BRAND.LogoId  

local TK4_INTRO_MUSIC_URL  = "https://www.dropbox.com/scl/fi/jm68qcearh1su2zwyd8z2/ytmp3free-mp3cut.net.mp3?rlkey=vzz6ykp06zrtnnuosj4m36rz6&st=4bho7co9&dl=1"

local TK4_INTRO_SOUND_FILE = "tk4_intro.mp3"

local TK4_INTRO_DURATION   = 3.5   

local function tk4IsInLobby()

local inMatch = false

pcall(function()

local RS = game:GetService("ReplicatedStorage")

local cs = RS:FindFirstChild("ClientState") or RS:FindFirstChild("MatchData") or RS:FindFirstChild("GameState")

if cs then

if cs:IsA("ModuleScript") then

local ok, m = pcall(require, cs)

if ok and type(m)=="table" then

if m.Match ~= nil or m.InMatch == true or m.RoundActive == true then

inMatch = true

end

end

elseif cs:IsA("BoolValue") and cs.Value == true then

inMatch = true

end

end

end)

if inMatch then return false end

local matchAttr = LP:GetAttribute("InMatch") or LP:GetAttribute("RoundActive") 

or LP:GetAttribute("GameActive") or LP:GetAttribute("IsPlaying")

if matchAttr == true then return false end

pcall(function()

local team = LP.Team

if team and team.Name ~= "Lobby" and team.Name ~= "Spectators" and team.Name ~= "Neutral" then

inMatch = true

end

end)

if inMatch then return false end

return true

end

local _tk4SoundId    = nil

local _tk4SoundReady = false

task.spawn(function()

pcall(function()

if isfile and getcustomasset and isfile(TK4_INTRO_SOUND_FILE) then

local ok, a = pcall(getcustomasset, TK4_INTRO_SOUND_FILE)

if ok and type(a) == "string" and #a > 5 then

_tk4SoundId = a; _tk4SoundReady = true; return

end

end

if writefile and getcustomasset then

local ok, data = pcall(game.HttpGet, game, TK4_INTRO_MUSIC_URL)

if ok and type(data) == "string" and #data > 1000 then

pcall(writefile, TK4_INTRO_SOUND_FILE, data)

if isfile and isfile(TK4_INTRO_SOUND_FILE) then

local ok2, a = pcall(getcustomasset, TK4_INTRO_SOUND_FILE)

if ok2 and type(a) == "string" and #a > 5 then

_tk4SoundId = a; _tk4SoundReady = true; return

end

end

end

end

_tk4SoundId = TK4_INTRO_MUSIC_URL

_tk4SoundReady = true

end)

if not _tk4SoundReady then

_tk4SoundId = TK4_INTRO_MUSIC_URL

_tk4SoundReady = true

end

end)

local function tk4StartIntroSound()

local sound = nil

pcall(function()

local t0 = tick()

while not _tk4SoundReady and (tick() - t0) < 3 do

task.wait(0.05)

end

local soundId = _tk4SoundId or TK4_INTRO_MUSIC_URL

local old1 = workspace:FindFirstChild("TK4_IntroSound")

if old1 then pcall(function() old1:Destroy() end) end

local SS = game:GetService("SoundService")

local old2 = SS:FindFirstChild("TK4_IntroSound")

if old2 then pcall(function() old2:Destroy() end) end

sound = Instance.new("Sound")

sound.Name   = "TK4_IntroSound"

sound.SoundId = soundId

sound.Volume  = 0.65

sound.Looped  = false

sound.Parent  = workspace

task.wait(0.05)

sound:Play()

end)

return sound

end

local function tk4PlayIntro(onDone)

local pg = LP:WaitForChild("PlayerGui", 5)

if not pg then if onDone then onDone() end return end

local function mkF(props, parent)

local f = Instance.new("Frame")

for k,v in pairs(props) do pcall(function() f[k]=v end) end

if parent then f.Parent = parent end

return f

end

local function mkL(props, parent)

local l = Instance.new("TextLabel")

for k,v in pairs(props) do pcall(function() l[k]=v end) end

if parent then l.Parent = parent end

return l

end

local function mkImg(props, parent)

local img = Instance.new("ImageLabel")

for k,v in pairs(props) do pcall(function() img[k]=v end) end

if parent then img.Parent = parent end

return img

end

local function corner(inst, r)

local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r or 8); c.Parent = inst

end

local sg = Instance.new("ScreenGui")

sg.Name = "TK4_Intro"; sg.ResetOnSpawn = false

sg.IgnoreGuiInset = true; sg.DisplayOrder = 999

sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

sg.Parent = pg

local bg = mkImg({

Size = UDim2.new(1,20,1,20),   

Position = UDim2.new(0,-10,0,-10),

BackgroundTransparency = 1,

Image = TK4_INTRO_BG_ASSET,

ScaleType = Enum.ScaleType.Crop,

ImageTransparency = 1,

ZIndex = 1,

}, sg)

local overlay = mkF({

Size = UDim2.new(1,0,1,0),

BackgroundColor3 = Color3.fromRGB(4,2,10),

BackgroundTransparency = 1,

BorderSizePixel = 0,

ZIndex = 2,

}, sg)

local logo = mkImg({

Size = UDim2.new(0,110,0,110),

Position = UDim2.new(0.5,-55, 0.5,-130),

BackgroundTransparency = 1,

Image = BRAND.LogoId,

ScaleType = Enum.ScaleType.Fit,

ImageTransparency = 1,

ZIndex = 4,

}, sg)

local title = mkL({

Size = UDim2.new(0.9,0,0,88),

Position = UDim2.new(0.5,0, 0.5,-10),

AnchorPoint = Vector2.new(0.5,0.5),

BackgroundTransparency = 1,

Text = BRAND.Full,

Font = Enum.Font.GothamBlack,

TextScaled = true,

TextColor3 = Color3.fromRGB(255,255,255),

TextTransparency = 1,

ZIndex = 5,

}, sg)

local grad = Instance.new("UIGradient")

grad.Rotation = 0

grad.Color = ColorSequence.new({

ColorSequenceKeypoint.new(0,  Color3.fromRGB(130,68,255)),

ColorSequenceKeypoint.new(0.5,Color3.fromRGB(220,200,255)),

ColorSequenceKeypoint.new(1,  Color3.fromRGB(130,68,255)),

})

grad.Parent = title

task.spawn(function()

while sg.Parent do

grad.Rotation = (grad.Rotation + 3) % 360

task.wait(0.05)

end

end)

local sub = mkL({

Size = UDim2.new(0.8,0,0,18),

Position = UDim2.new(0.5,0, 0.5,52),

AnchorPoint = Vector2.new(0.5,0.5),

BackgroundTransparency = 1,

Text = BRAND.Motto,

TextColor3 = Color3.fromRGB(220,210,240),

Font = Enum.Font.GothamBold,

TextSize = 12,

TextTransparency = 1,

ZIndex = 5,

}, sg)

local ver = mkL({

Size = UDim2.new(0,160,0,20),

Position = UDim2.new(0.5,0, 0.5,76),

AnchorPoint = Vector2.new(0.5,0.5),

BackgroundTransparency = 1,

Text = BRAND.Version,

TextColor3 = Color3.fromRGB(130,68,255),

Font = Enum.Font.GothamMedium,

TextSize = 11,

TextTransparency = 1,

ZIndex = 5,

}, sg)

local barBg = mkF({

Size = UDim2.new(0.42,0, 0,5),

Position = UDim2.new(0.5,0, 0.5,100),

AnchorPoint = Vector2.new(0.5,0.5),

BackgroundColor3 = Color3.fromRGB(30,20,50),

BorderSizePixel = 0,

BackgroundTransparency = 1,

ZIndex = 4,

}, sg)

corner(barBg, 3)

local bar = mkF({

Size = UDim2.new(0,0,1,0),

BackgroundColor3 = Color3.fromRGB(130,68,255),

BorderSizePixel = 0,

ZIndex = 5,

}, barBg)

corner(bar, 3)

local fi = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local fo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenService:Create(bg,      fi, { ImageTransparency  = 0.15 }):Play()  

TweenService:Create(overlay, fi, { BackgroundTransparency = 0.72 }):Play()  

TweenService:Create(logo,    TweenInfo.new(0.5), { ImageTransparency = 0 }):Play()

TweenService:Create(title,   fi, { TextTransparency = 0 }):Play()

TweenService:Create(sub,     TweenInfo.new(0.5), { TextTransparency = 0.1 }):Play()

TweenService:Create(ver,     TweenInfo.new(0.5), { TextTransparency = 0.2 }):Play()

TweenService:Create(barBg,   fi, { BackgroundTransparency = 0.35 }):Play()

local song = tk4StartIntroSound()

TweenService:Create(bar, TweenInfo.new(TK4_INTRO_DURATION, Enum.EasingStyle.Linear),

{ Size = UDim2.new(1,0,1,0) }):Play()

task.wait(TK4_INTRO_DURATION)

if song then pcall(function() TweenService:Create(song, TweenInfo.new(0.4), {Volume=0}):Play() end) end

TweenService:Create(bg,      fo, { ImageTransparency   = 1 }):Play()

TweenService:Create(overlay, fo, { BackgroundTransparency = 1 }):Play()

TweenService:Create(logo,    fo, { ImageTransparency   = 1 }):Play()

TweenService:Create(title,   fo, { TextTransparency    = 1 }):Play()

TweenService:Create(sub,     fo, { TextTransparency    = 1 }):Play()

TweenService:Create(ver,     fo, { TextTransparency    = 1 }):Play()

TweenService:Create(barBg,   fo, { BackgroundTransparency = 1 }):Play()

task.wait(0.35)

pcall(function() sg:Destroy() end)

if song then pcall(function() song:Destroy() end) end

if onDone then onDone() end

end

task.spawn(function()

if tk4IsInLobby() then

tk4PlayIntro(function()

local deadline = tick() + 8

while tick() < deadline do

if mainOuter and _G._TK4_openMenuMouse then

Config.GuiVisible = true

mainOuter.Visible = true

pcall(_G._TK4_openMenuMouse)

return

end

task.wait(0.05)

end

end)

else

end

end)

local StaffHUD = (function()

local HUD_W = 190

local ROW_H = 22

local HEADER_H = 26

local hudGui = Instance.new("ScreenGui")

hudGui.Name = "TK4_StaffHUD_GUI"

hudGui.ResetOnSpawn = false

hudGui.IgnoreGuiInset = true

hudGui.DisplayOrder = 200

safeParentGui(hudGui)

local hudOuter = Instance.new("Frame", hudGui)

hudOuter.Name        = "TK4_StaffHUD"

hudOuter.Size        = UDim2.new(0, HUD_W, 0, HEADER_H)

hudOuter.Position    = UDim2.new(0, 10, 0.3, 0)

hudOuter.BackgroundColor3 = Color3.fromRGB(8, 6, 14)

hudOuter.BackgroundTransparency = 0.12

hudOuter.BorderSizePixel = 0

hudOuter.Active      = true

hudOuter.Visible     = false

hudOuter.ZIndex      = 50

mkCorner(hudOuter, 10)

mkStroke(hudOuter, Color3.fromRGB(214, 160, 30), 1.4) 

local header = Instance.new("TextLabel", hudOuter)

header.Size               = UDim2.new(1, 0, 0, HEADER_H)

header.Position           = UDim2.new(0, 0, 0, 0)

header.BackgroundTransparency = 1

header.Text               = "⚠  STAFF IN SERVER"

header.TextColor3         = Color3.fromRGB(214, 160, 30)

header.Font               = Enum.Font.GothamBlack

header.TextSize           = 11

header.TextXAlignment     = Enum.TextXAlignment.Center

header.ZIndex             = 51

do

local drag, dStart, hStart = false, Vector2.zero, UDim2.new()

hudOuter.InputBegan:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

drag = true

dStart = Vector2.new(inp.Position.X, inp.Position.Y)

hStart = hudOuter.Position

end

end)

regConn(UserInputService.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

drag = false

end

end))

regConn(UserInputService.InputChanged:Connect(function(inp)

if not drag then return end

if inp.UserInputType == Enum.UserInputType.MouseMovement

or inp.UserInputType == Enum.UserInputType.Touch then

local delta = Vector2.new(inp.Position.X, inp.Position.Y) - dStart

hudOuter.Position = UDim2.new(

hStart.X.Scale, hStart.X.Offset + delta.X,

hStart.Y.Scale, hStart.Y.Offset + delta.Y)

end

end))

end

local rowPool = {}

local activeRows = 0

local function getRow(idx)

if not rowPool[idx] then

local r = Instance.new("Frame", hudOuter)

r.Name              = "StaffRow_" .. idx

r.Size              = UDim2.new(1, 0, 0, ROW_H)

r.Position          = UDim2.new(0, 0, 0, HEADER_H + (idx - 1) * ROW_H)

r.BackgroundTransparency = 1

r.BorderSizePixel   = 0

r.ZIndex            = 51

local dot = Instance.new("Frame", r)

dot.Name  = "Dot"

dot.Size  = UDim2.new(0, 6, 0, 6)

dot.Position = UDim2.new(0, 8, 0.5, -3)

dot.BorderSizePixel = 0

dot.ZIndex = 52

mkCorner(dot, 3)

local lbl = Instance.new("TextLabel", r)

lbl.Name  = "Lbl"

lbl.Size  = UDim2.new(1, -22, 1, 0)

lbl.Position = UDim2.new(0, 20, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Font  = Enum.Font.Gotham

lbl.TextSize = 10

lbl.TextXAlignment = Enum.TextXAlignment.Left

lbl.TextColor3 = Color3.fromRGB(240, 240, 240)

lbl.ZIndex = 52

rowPool[idx] = r

end

return rowPool[idx]

end

local function refresh()

activeRows = 0

if not State._staffInServer then

State._staffInServer = {}  

end

local entries = {}

for pl, info in pairs(State._staffInServer) do

if pl and pl.Parent then

table.insert(entries, { name = pl.DisplayName, text = info.text, color = info.color })

end

end

if #entries == 0 then

hudOuter.Visible = true

hudOuter.Size = UDim2.new(0, HUD_W, 0, HEADER_H + ROW_H + 4)

local idle = getRow(1)

idle.Visible = true

idle.Dot.BackgroundColor3 = Color3.fromRGB(120, 120, 130)

idle.Lbl.Text = "No staff online"

idle.Lbl.TextColor3 = Color3.fromRGB(165, 165, 175)

for i = 2, #rowPool do rowPool[i].Visible = false end

return

end

hudOuter.Visible = true

activeRows = #entries

hudOuter.Size = UDim2.new(0, HUD_W, 0, HEADER_H + activeRows * ROW_H + 4)

for i, e in ipairs(entries) do

local row = getRow(i)

row.Visible = true

row.Position = UDim2.new(0, 0, 0, HEADER_H + (i - 1) * ROW_H)

row.Dot.BackgroundColor3 = e.color

row.Lbl.Text = string.format("%s  %s", e.name, e.text)

row.Lbl.TextColor3 = e.color

end

for i = #entries + 1, #rowPool do

rowPool[i].Visible = false

end

end

task.spawn(function()

pcall(refresh)

end)

return { refresh = refresh }

end)()

local WIN_W   = 600

local WIN_H   = 460

local TITLE_H = 56

local mainOuter = Instance.new("Frame", ScreenGui)

mainOuter.Name = "MainOuter"

mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)

mainOuter.AnchorPoint = Vector2.new(0.5, 0.5)

mainOuter.Position = UDim2.new(0.5, 0, 0.5, 0)

mainOuter.BackgroundTransparency = 1

mainOuter.BorderSizePixel = 0

mainOuter.ClipsDescendants = true

mainOuter.Active = true

Config.GuiVisible = false

mainOuter.Visible = false

mkCorner(mainOuter, 24)

local mainScale = Instance.new("UIScale", mainOuter)

mainScale.Name = "MainScale"

local toggleMenu

local CAS = game:GetService("ContextActionService")

local CAM_SINK = "TK4_CamSink"

local _savedCamType = nil

local function openMenuMouse()

  if ClientState then

    ClientState.CursorFree = true

  end

  UserInputService.MouseBehavior    = Enum.MouseBehavior.Default

  UserInputService.MouseIconEnabled = true

  pcall(function()

    CAS:BindActionAtPriority(CAM_SINK,

      function() return Enum.ContextActionResult.Sink end,

      false,

      3000,

      Enum.UserInputType.MouseMovement,

      Enum.UserInputType.MouseButton1,

      Enum.UserInputType.MouseButton2

    )

  end)

  if not _G._TK4_MouseConn then

    _G._TK4_MouseConn = game:GetService("RunService").Heartbeat:Connect(function()

      if not Config.GuiVisible then

        if _G._TK4_MouseConn then

          _G._TK4_MouseConn:Disconnect()

          _G._TK4_MouseConn = nil

        end

        return

      end

      if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default

      end

      if ClientState and not ClientState.CursorFree then

        ClientState.CursorFree = true

      end

    end)

  end

end

_G._TK4_openMenuMouse = openMenuMouse  



local function closeMenuMouse()

  pcall(function() CAS:UnbindAction(CAM_SINK) end)

  if _G._TK4_MouseConn then

    pcall(function() _G._TK4_MouseConn:Disconnect() end)

    _G._TK4_MouseConn = nil

  end

  if ClientState then

    ClientState.CursorFree = false

  end

  local function relock()

    UserInputService.MouseBehavior    = Enum.MouseBehavior.LockCenter

    UserInputService.MouseIconEnabled = false

    if ClientState then

      ClientState.CursorFree = false

    end

  end

  relock()

  task.defer(relock)

  task.defer(function() task.defer(relock) end)

  task.delay(0.05, relock)

end



toggleMenu = function()

  Config.GuiVisible = not Config.GuiVisible

  mainOuter.Visible = Config.GuiVisible

  if Config.GuiVisible then

    openMenuMouse()

  else

    closeMenuMouse()

  end

  if not Config.GuiVisible and Config.AutoSaveConfig ~= false then

    pcall(saveConfigToFile)

  end

  if Config.GuiVisible then

    for _, esp in pairs(State.ESPCache) do hideESP(esp) end

  end

  if mobileFab then

    mobileFab.Visible = (not Config.GuiVisible) or UserInputService.TouchEnabled

  end

end



-- Floating Mobile / Desktop Toggle Button (FAB)

local mobileFab = Instance.new("TextButton", ScreenGui)

mobileFab.Name = "TK4_MobileToggle"

mobileFab.Size = UDim2.new(0, 46, 0, 46)

mobileFab.Position = UDim2.new(0, 16, 0.45, -23)

mobileFab.BackgroundColor3 = Color3.fromRGB(16, 12, 24)

mobileFab.BackgroundTransparency = 0.15

mobileFab.BorderSizePixel = 0

mobileFab.Text = "TK4"

mobileFab.TextColor3 = Color3.fromRGB(245, 190, 35)

mobileFab.Font = Enum.Font.GothamBold

mobileFab.TextSize = 13

mobileFab.ZIndex = 200

mobileFab.Active = true

mobileFab.Visible = (not Config.GuiVisible) or UserInputService.TouchEnabled

mkCorner(mobileFab, 23)

mkStroke(mobileFab, Color3.fromRGB(214, 160, 30), 1.6)



do

  local fabDragging = false

  local fabStartPos = Vector2.zero

  local fabStartFramePos = UDim2.new(0, 0, 0, 0)

  mobileFab.InputBegan:Connect(function(inp)

    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

      fabDragging = true

      fabStartPos = Vector2.new(inp.Position.X, inp.Position.Y)

      fabStartFramePos = mobileFab.Position

    end

  end)

  regConn(UserInputService.InputEnded:Connect(function(inp)

    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

      fabDragging = false

    end

  end))

  regConn(UserInputService.InputChanged:Connect(function(inp)

    if fabDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then

      local delta = Vector2.new(inp.Position.X, inp.Position.Y) - fabStartPos

      mobileFab.Position = UDim2.new(

        fabStartFramePos.X.Scale,

        fabStartFramePos.X.Offset + delta.X,

        fabStartFramePos.Y.Scale,

        fabStartFramePos.Y.Offset + delta.Y

      )

    end

  end))

end



mobileFab.MouseButton1Click:Connect(function()

  toggleMenu()

end)

local function computeSmartScale()

local cam = workspace.CurrentCamera

local vp = (cam and cam.ViewportSize) or Vector2.new(1366, 768)

local isTouch = UserInputService.TouchEnabled

local fit = math.min(vp.X / (WIN_W + 30), vp.Y / (WIN_H + 30))

if fit < 1.0 or isTouch then

return math.clamp(fit, 0.40, 1.0)

end

return 1.0

end

local function applySmartScale()

if Config.MenuScaleAuto == false then return end

Config.UIScale = computeSmartScale()

Config.MenuScalePercent = math.floor(Config.UIScale * 100 + 0.5)

mainScale.Scale = Config.UIScale

end

applySmartScale()

if Camera then

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()

applySmartScale()

end)

end

local startDrag

do

local dragging = false

local dragStartPos = Vector2.zero

local startFramePos = UDim2.new(0, 0, 0, 0)

local touchLast = Vector2.zero

startDrag = function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

dragging = true

dragStartPos = Vector2.new(inp.Position.X, inp.Position.Y)

touchLast = dragStartPos

startFramePos = mainOuter.Position

end

end

mainOuter.InputBegan:Connect(startDrag)

regConn(UserInputService.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

dragging = false

end

end))

regConn(UserInputService.InputChanged:Connect(function(inp)

if not dragging then return end

local sc = (mainScale and mainScale.Scale) or 1.0

if inp.UserInputType == Enum.UserInputType.MouseMovement then

local curPos = UserInputService:GetMouseLocation()

local delta = curPos - dragStartPos

if delta.Magnitude < 1 then

local mDelta = UserInputService:GetMouseDelta()

if mDelta.Magnitude > 0 then

mainOuter.Position = UDim2.new(

mainOuter.Position.X.Scale,

mainOuter.Position.X.Offset + (mDelta.X / sc),

mainOuter.Position.Y.Scale,

mainOuter.Position.Y.Offset + (mDelta.Y / sc)

)

return

end

end

mainOuter.Position = UDim2.new(

startFramePos.X.Scale,

startFramePos.X.Offset + (delta.X / sc),

startFramePos.Y.Scale,

startFramePos.Y.Offset + (delta.Y / sc)

)

elseif inp.UserInputType == Enum.UserInputType.Touch then

local curPos = Vector2.new(inp.Position.X, inp.Position.Y)

local delta = curPos - touchLast

touchLast = curPos

mainOuter.Position = UDim2.new(

mainOuter.Position.X.Scale,

mainOuter.Position.X.Offset + (delta.X / sc),

mainOuter.Position.Y.Scale,

mainOuter.Position.Y.Offset + (delta.Y / sc)

)

end

end))

end

do

local toggleGui = Instance.new("ScreenGui")

toggleGui.Name = "TK4_ToggleBtn"

toggleGui.ResetOnSpawn = false

toggleGui.IgnoreGuiInset = true

toggleGui.DisplayOrder = 200

toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

safeParentGui(toggleGui)

local toggleOuter = Instance.new("Frame")

toggleOuter.Name        = "ToggleOuter"

toggleOuter.Size        = UDim2.fromOffset(50, 50)

toggleOuter.Position    = UDim2.new(0, 14, 0.5, -25)

toggleOuter.AnchorPoint = Vector2.new(0, 0)

toggleOuter.BackgroundTransparency = 1

toggleOuter.BorderSizePixel = 0

toggleOuter.ZIndex = 10

toggleOuter.Parent = toggleGui

local pill = Instance.new("TextButton")

pill.Name            = "Pill"

pill.Size            = UDim2.fromScale(1, 1)

pill.BackgroundColor3 = Color3.fromRGB(18, 10, 32)

pill.BorderSizePixel = 0

pill.Text            = ""

pill.AutoButtonColor = false

pill.ZIndex          = 11

pill.Active          = true

pill.Parent          = toggleOuter

do

local c = Instance.new("UICorner")

c.CornerRadius = UDim.new(0, 10)

c.Parent = pill

local s = Instance.new("UIStroke")

s.Color = Color3.fromRGB(120, 80, 220)

s.Thickness = 2

s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

s.Parent = pill

end

local iconImg = Instance.new("ImageLabel")

iconImg.Name               = "Icon"

iconImg.Size               = UDim2.fromOffset(36, 36)

iconImg.Position           = UDim2.new(0.5, -18, 0.5, -18)

iconImg.BackgroundTransparency = 1

iconImg.BorderSizePixel    = 0

iconImg.Image              = BRAND.LogoId

iconImg.ScaleType          = Enum.ScaleType.Fit

iconImg.ImageTransparency  = 0

iconImg.ZIndex             = 12

iconImg.Parent             = pill

local dot = Instance.new("Frame")

dot.Size             = UDim2.fromOffset(7, 7)

dot.Position         = UDim2.new(1, -9, 1, -9)

dot.BackgroundColor3 = Color3.fromRGB(80, 220, 120)

dot.BorderSizePixel  = 0

dot.ZIndex           = 13

dot.Parent           = pill

do

local c = Instance.new("UICorner")

c.CornerRadius = UDim.new(0.5, 0)

c.Parent = dot

end

local function refreshDot()

dot.BackgroundColor3 = Config.GuiVisible

and Color3.fromRGB(80, 220, 120)

or  Color3.fromRGB(80, 60, 110)

end

refreshDot()

local _drag, _dragStart, _startPos = false, Vector2.zero, UDim2.new()

local _touchLast = Vector2.zero

pill.InputBegan:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

_drag      = true

_dragStart = Vector2.new(inp.Position.X, inp.Position.Y)

_touchLast = _dragStart

_startPos  = toggleOuter.Position

end

end)

UserInputService.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

_drag = false

end

end)

UserInputService.InputChanged:Connect(function(inp)

if not _drag then return end

if inp.UserInputType == Enum.UserInputType.MouseMovement then

local cur   = UserInputService:GetMouseLocation()

local delta = cur - _dragStart

toggleOuter.Position = UDim2.new(

_startPos.X.Scale, _startPos.X.Offset + delta.X,

_startPos.Y.Scale, _startPos.Y.Offset + delta.Y)

elseif inp.UserInputType == Enum.UserInputType.Touch then

local cur   = Vector2.new(inp.Position.X, inp.Position.Y)

local delta = cur - _touchLast

_touchLast  = cur

toggleOuter.Position = UDim2.new(

toggleOuter.Position.X.Scale,

toggleOuter.Position.X.Offset + delta.X,

toggleOuter.Position.Y.Scale,

toggleOuter.Position.Y.Offset + delta.Y)

end

end)

local _clickStart = Vector2.zero

pill.InputBegan:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

_clickStart = Vector2.new(inp.Position.X, inp.Position.Y)

end

end)

pill.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1

or inp.UserInputType == Enum.UserInputType.Touch then

local moved = (Vector2.new(inp.Position.X, inp.Position.Y) - _clickStart).Magnitude

if moved < 8 then

toggleMenu()

refreshDot()

end

end

end)

local _origToggle = toggleMenu

toggleMenu = function()

_origToggle()

refreshDot()

end

end

local bgImg = Instance.new("ImageLabel", mainOuter)

bgImg.Name = "BgFill"

bgImg.Size = UDim2.new(1, 0, 1, 0)

bgImg.Position = UDim2.new(0, 0, 0, 0)

bgImg.BackgroundTransparency = 1

bgImg.BorderSizePixel = 0

bgImg.ZIndex = 1

bgImg.Image = BRAND.LogoId

bgImg.ScaleType = Enum.ScaleType.Crop

bgImg.ImageTransparency = 0.20

mkCorner(bgImg, 24)

local bgDark = Instance.new("Frame", mainOuter)

bgDark.Name = "BgDarkOverlay"

bgDark.Size = UDim2.new(1, 0, 1, 0)

bgDark.BackgroundColor3 = Color3.fromRGB(6, 4, 10)

bgDark.BackgroundTransparency = 0.35

bgDark.BorderSizePixel = 0

bgDark.ZIndex = 1

mkCorner(bgDark, 24)

local mainStroke = Instance.new("UIStroke", mainOuter)

mainStroke.Thickness = 1.4

mainStroke.Color = Color3.fromRGB(255, 255, 255)

mainStroke.Transparency = 0.2

mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local mainStrokeGrad = Instance.new("UIGradient", mainStroke)

mainStrokeGrad.Color = ColorSequence.new({

ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 20, 170)),

ColorSequenceKeypoint.new(0.5, C.accent),

ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 20, 170))

})

task.spawn(function()

while mainOuter.Parent do

mainStrokeGrad.Rotation = (mainStrokeGrad.Rotation + 1.6) % 360  

task.wait(0.066)  

end

end)

local titleBar = Instance.new("Frame", mainOuter)

titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)

titleBar.BackgroundColor3 = C.topBg

titleBar.BackgroundTransparency = 1

titleBar.BorderSizePixel = 0

titleBar.Active = true

titleBar.ZIndex = 5

titleBar.InputBegan:Connect(startDrag)

local avatarBg = Instance.new("Frame", titleBar)

avatarBg.Size = UDim2.new(0, 40, 0, 40)

avatarBg.Position = UDim2.new(0, 14, 0.5, -20)

avatarBg.BackgroundColor3 = Color3.fromRGB(12, 8, 18)

avatarBg.BorderSizePixel = 0

avatarBg.ZIndex = 6

mkCorner(avatarBg, 20)

local avStroke = mkStroke(avatarBg, C.accent, 2)

avStroke.Transparency = 0.15

local avatarImg = Instance.new("ImageLabel", avatarBg)

avatarImg.Size = UDim2.new(1, -6, 1, -6)

avatarImg.Position = UDim2.new(0, 3, 0, 3)

avatarImg.BackgroundTransparency = 1

avatarImg.ScaleType = Enum.ScaleType.Crop

avatarImg.ZIndex = 7

mkCorner(avatarImg, 17)

task.spawn(function()

local ok, thumb = pcall(function()

return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

end)

if ok and thumb then avatarImg.Image = thumb end

end)

local titleLbl = Instance.new("TextLabel", titleBar)

titleLbl.Size = UDim2.new(0, 280, 0, 18)

titleLbl.Position = UDim2.new(0, 66, 0, 10)

titleLbl.BackgroundTransparency = 1

titleLbl.Text = BRAND.Name .. " — " .. BRAND.Full

titleLbl.TextColor3 = C.topTitle

titleLbl.Font = Enum.Font.GothamBlack

titleLbl.TextSize = 15

titleLbl.TextXAlignment = Enum.TextXAlignment.Left

titleLbl.ZIndex = 6

local subtitleLbl = Instance.new("TextLabel", titleBar)

subtitleLbl.Size = UDim2.new(0, 300, 0, 14)

subtitleLbl.Position = UDim2.new(0, 66, 0, 30)

subtitleLbl.BackgroundTransparency = 1

subtitleLbl.Text = '"' .. BRAND.Motto .. '" | RESPECT PVP'

subtitleLbl.TextColor3 = C.topSub

subtitleLbl.Font = Enum.Font.GothamBold

subtitleLbl.TextSize = 9

subtitleLbl.TextXAlignment = Enum.TextXAlignment.Left

subtitleLbl.ZIndex = 6

local minBtn = Instance.new("TextButton", titleBar)

minBtn.Size = UDim2.new(0, 26, 0, 26)

minBtn.Position = UDim2.new(1, -72, 0.5, -13)

minBtn.BackgroundColor3 = Color3.fromRGB(18, 12, 26)

minBtn.BorderSizePixel = 0

minBtn.Text = "-"

minBtn.TextColor3 = Color3.fromRGB(235, 235, 235)

minBtn.Font = Enum.Font.GothamBlack

minBtn.TextSize = 16

minBtn.ZIndex = 7

mkCorner(minBtn, 13)

mkStroke(minBtn, C.rowStroke, 1)

minBtn.MouseButton1Click:Connect(function()

toggleMenu()

end)

local closeBtn = Instance.new("TextButton", titleBar)

closeBtn.Size = UDim2.new(0, 26, 0, 26)

closeBtn.Position = UDim2.new(1, -38, 0.5, -13)

closeBtn.BackgroundColor3 = Color3.fromRGB(18, 12, 26)

closeBtn.BorderSizePixel = 0

closeBtn.Text = "X"

closeBtn.TextColor3 = Color3.fromRGB(240, 240, 240)

closeBtn.Font = Enum.Font.GothamBlack

closeBtn.TextSize = 14

closeBtn.ZIndex = 7

mkCorner(closeBtn, 13)

mkStroke(closeBtn, C.rowStroke, 1)

closeBtn.MouseButton1Click:Connect(function()

toggleMenu()

end)

local titleDiv = Instance.new("Frame", mainOuter)

titleDiv.Size = UDim2.new(1, 0, 0, 1)

titleDiv.Position = UDim2.new(0, 0, 0, TITLE_H)

titleDiv.BackgroundColor3 = Color3.fromRGB(36, 26, 52)

titleDiv.BorderSizePixel = 0

titleDiv.ZIndex = 5

local MAIN_TABS = { "AIM", "VISUALS", "MOVE", "WORLD", "CONFIG" }

local activeMainTab = "AIM"

local mainTabBtns   = {}

local mainTabFrames = {}

local TAB_BAR_Y = TITLE_H + 6

local tabBarFrame = Instance.new("Frame", mainOuter)

tabBarFrame.Name = "MainTabBar"

tabBarFrame.Size = UDim2.new(1, -24, 0, 32)

tabBarFrame.Position = UDim2.new(0, 12, 0, TAB_BAR_Y)

tabBarFrame.BackgroundColor3 = C.tabBg

tabBarFrame.BackgroundTransparency = 0.15

tabBarFrame.BorderSizePixel = 0

tabBarFrame.ZIndex = 5

mkCorner(tabBarFrame, 10)

mkStroke(tabBarFrame, C.winBorder, 1)

local CONTENT_Y = TAB_BAR_Y + 36

local CONTENT_H = WIN_H - CONTENT_Y - 20

local contentArea = Instance.new("Frame", mainOuter)

contentArea.Name = "ContentArea"

contentArea.Size = UDim2.new(1, -16, 0, CONTENT_H)

contentArea.Position = UDim2.new(0, 8, 0, CONTENT_Y)

contentArea.BackgroundTransparency = 1

contentArea.BorderSizePixel = 0

contentArea.ClipsDescendants = true

contentArea.ZIndex = 2

local function makeMainTabBtn(label, idx)

local W = 1 / #MAIN_TABS

local btn = Instance.new("TextButton", tabBarFrame)

btn.Size = UDim2.new(W, -3, 1, -6)

btn.Position = UDim2.new(W * (idx-1), 2, 0, 3)

btn.BackgroundColor3 = (label == activeMainTab) and C.accent or C.tabBg

btn.Text = label

btn.TextColor3 = (label == activeMainTab) and C.tabActiveTx or C.tabIdleTx

btn.Font = Enum.Font.GothamBold

btn.TextSize = 11

btn.ZIndex = 6

btn.AutoButtonColor = false

mkCorner(btn, 8)

mainTabBtns[label] = btn

return btn

end

local lo = 0

local function LO() lo = lo + 1; return lo end

local function switchMainTab(name)

activeMainTab = name

for _, t in ipairs(MAIN_TABS) do

local btn = mainTabBtns[t]

local isAct = (t == name)

TweenService:Create(btn, TweenInfo.new(0.13), {

BackgroundColor3 = isAct and C.accent or C.tabBg,

TextColor3       = isAct and C.tabActiveTx or C.tabIdleTx,

}):Play()

if mainTabFrames[t] then

mainTabFrames[t].Visible = isAct

end

end

end

for i, name in ipairs(MAIN_TABS) do

local btn = makeMainTabBtn(name, i)

btn.MouseButton1Click:Connect(function() switchMainTab(name) end)

end

local function makeMainTabFrame(tabName)

local f = Instance.new("Frame", contentArea)

f.Name = "MainTab_" .. tabName

f.Size = UDim2.new(1, 0, 1, 0)

f.BackgroundTransparency = 1

f.BorderSizePixel = 0

f.Visible = (tabName == activeMainTab)

mainTabFrames[tabName] = f

return f

end

local SUB_BAR_H = 38

local function makeSubSystem(parentFrame)

local subTabs     = {}

local activeSubTab = nil

local pillBar = Instance.new("Frame", parentFrame)

pillBar.Name = "SubTabBar"

pillBar.Size = UDim2.new(1, -28, 0, SUB_BAR_H)

pillBar.Position = UDim2.new(0, 14, 0, 6)

pillBar.BackgroundColor3 = Color3.fromRGB(14, 10, 22)

pillBar.BackgroundTransparency = 0.15

pillBar.BorderSizePixel = 0

pillBar.ZIndex = 6

mkCorner(pillBar, 10)

mkStroke(pillBar, Color3.fromRGB(60, 42, 90), 1)

local pillLayout = Instance.new("UIListLayout", pillBar)

pillLayout.FillDirection = Enum.FillDirection.Horizontal

pillLayout.SortOrder = Enum.SortOrder.LayoutOrder

pillLayout.Padding = UDim.new(0, 5)

pillLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local pillPad = Instance.new("UIPadding", pillBar)

pillPad.PaddingLeft  = UDim.new(0, 8)

pillPad.PaddingRight = UDim.new(0, 8)

pillPad.PaddingTop   = UDim.new(0, 4)

pillPad.PaddingBottom = UDim.new(0, 4)

local scrollBg = Instance.new("Frame", parentFrame)

scrollBg.Name = "SubScrollBg"

scrollBg.Size = UDim2.new(1, 0, 1, -(SUB_BAR_H + 14))

scrollBg.Position = UDim2.new(0, 0, 0, SUB_BAR_H + 10)

scrollBg.BackgroundTransparency = 1

scrollBg.BorderSizePixel = 0

scrollBg.ClipsDescendants = true

scrollBg.ZIndex = 2

local scroll = Instance.new("ScrollingFrame", scrollBg)

scroll.Name = "SubScroll"

scroll.Size = UDim2.new(1, 0, 1, 0)

scroll.BackgroundTransparency = 1

scroll.BorderSizePixel = 0

scroll.ScrollBarThickness = 3

scroll.ScrollBarImageColor3 = C.accent

scroll.ScrollBarImageTransparency = 0.3

scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

scroll.CanvasSize = UDim2.new(0,0,0,0)

scroll.ScrollingDirection = Enum.ScrollingDirection.Y

scroll.ZIndex = 3

local scrollPad = Instance.new("UIPadding", scroll)

scrollPad.PaddingLeft   = UDim.new(0, 6)

scrollPad.PaddingRight  = UDim.new(0, 4)

scrollPad.PaddingTop    = UDim.new(0, 4)

scrollPad.PaddingBottom = UDim.new(0, 8)

local function switchSub(label)

activeSubTab = label

for _, st in ipairs(subTabs) do

local isAct = (st.label == label)

st.btn.BackgroundColor3 = isAct and C.accent or Color3.fromRGB(22, 16, 32)

st.btn.TextColor3 = isAct and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 170, 200)

local stroke = st.btn:FindFirstChildOfClass("UIStroke")

if stroke then

stroke.Color = isAct and Color3.fromRGB(170, 120, 255) or Color3.fromRGB(50, 36, 70)

stroke.Transparency = isAct and 0.2 or 0.5

end

st.page.Visible = isAct

end

scroll.CanvasPosition = Vector2.new(0,0)

end

local function addSubTab(label)

local btn = Instance.new("TextButton", pillBar)

btn.AutomaticSize = Enum.AutomaticSize.X

btn.Size = UDim2.new(0, 0, 0, 28)

btn.BackgroundColor3 = Color3.fromRGB(22, 16, 32)

btn.Text = label

btn.TextColor3 = Color3.fromRGB(180, 170, 200)

btn.Font = Enum.Font.GothamBold

btn.TextSize = 12

btn.ZIndex = 7

btn.AutoButtonColor = false

btn.LayoutOrder = #subTabs + 1

mkCorner(btn, 8)

local btnStroke = Instance.new("UIStroke", btn)

btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

btnStroke.Color = Color3.fromRGB(50, 36, 70)

btnStroke.Thickness = 1

btnStroke.Transparency = 0.5

local btnPad = Instance.new("UIPadding", btn)

btnPad.PaddingLeft  = UDim.new(0, 14)

btnPad.PaddingRight = UDim.new(0, 14)

local page = Instance.new("Frame", scroll)

page.Name = "SubPage_" .. label

page.Size = UDim2.new(1, 0, 0, 0)

page.AutomaticSize = Enum.AutomaticSize.Y

page.BackgroundTransparency = 1

page.BorderSizePixel = 0

page.Visible = false

local ll = Instance.new("UIListLayout", page)

ll.SortOrder = Enum.SortOrder.LayoutOrder

ll.Padding = UDim.new(0, 6)

ll.HorizontalAlignment = Enum.HorizontalAlignment.Center

local entry = { label = label, btn = btn, page = page }

table.insert(subTabs, entry)

btn.MouseButton1Click:Connect(function() switchSub(label) end)

if #subTabs == 1 then

task.defer(function() switchSub(label) end)

end

return page

end

return addSubTab

end

local function makeToggleRow(page, label, defaultOn, onToggle, configKey)

local row = Instance.new("Frame", page)

row.Name = "Row_" .. label

row.Size = UDim2.new(1, 0, 0, 36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

row.MouseEnter:Connect(function()

TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = C.rowHov}):Play()

end)

row.MouseLeave:Connect(function()

TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = C.rowBg}):Play()

end)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.65, 0, 1, 0)

lbl.Position = UDim2.new(0, 10, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

lbl.TextWrapped = true

local pill = Instance.new("Frame", row)

pill.Size = UDim2.new(0, 44, 0, 22)

pill.Position = UDim2.new(1, -50, 0.5, -11)

pill.BorderSizePixel = 0

mkCorner(pill, 11)

local dot = Instance.new("Frame", pill)

dot.Size = UDim2.new(0, 16, 0, 16)

dot.AnchorPoint = Vector2.new(0, 0.5)

dot.BorderSizePixel = 0

mkCorner(dot, 8)

local on = (defaultOn == true)

local function refresh()

pill.BackgroundColor3 = on and C.pillOn or C.pillOff

dot.BackgroundColor3  = on and C.dotColorOn or C.dotColor

dot.Position = on and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

end

refresh()

local function toggle()

on = not on

if configKey then Config[configKey] = on end

TweenService:Create(pill, TweenInfo.new(0.15), {BackgroundColor3 = on and C.pillOn or C.pillOff}):Play()

TweenService:Create(dot, TweenInfo.new(0.15), {

Position = on and UDim2.new(1,-19,0.5,0) or UDim2.new(0,3,0.5,0),

BackgroundColor3 = on and C.dotColorOn or C.dotColor

}):Play()

if onToggle then pcall(onToggle, on) end

onConfigChanged()

end

local clk = Instance.new("TextButton", row)

clk.Size = UDim2.new(1,0,1,0)

clk.BackgroundTransparency = 1

clk.Text = ""

clk.ZIndex = row.ZIndex + 1

clk.MouseButton1Click:Connect(toggle)

local pClk = Instance.new("TextButton", pill)

pClk.Size = UDim2.new(1,0,1,0)

pClk.BackgroundTransparency = 1

pClk.Text = ""

pClk.ZIndex = pill.ZIndex + 1

pClk.MouseButton1Click:Connect(toggle)

end

local function makeStepperRow(page, label, default, minVal, maxVal, step, onChange, configKey)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1, 0, 0, 36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowHov}):Play() end)

row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowBg}):Play() end)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.52, 0, 1, 0)

lbl.Position = UDim2.new(0, 10, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local val = default or minVal

local valLbl = Instance.new("TextBox", row)

valLbl.ClearTextOnFocus = false

valLbl.PlaceholderText = tostring(minVal) .. "-" .. tostring(maxVal)

valLbl.ZIndex = row.ZIndex + 2

valLbl.Size = UDim2.new(0.18, 0, 1, 0)

valLbl.Position = UDim2.new(0.52, 0, 0, 0)

valLbl.BackgroundTransparency = 1

valLbl.Text = tostring(val)

valLbl.TextColor3 = C.rowValue

valLbl.Font = Enum.Font.GothamBold

valLbl.TextSize = 12

valLbl.TextXAlignment = Enum.TextXAlignment.Center

local function mkBtn(sym, posX)

local b = Instance.new("TextButton", row)

b.Size = UDim2.new(0, 28, 0, 24)

b.Position = UDim2.new(1, posX, 0.5, -12)

b.BackgroundColor3 = Color3.fromRGB(18, 12, 28)

b.Text = sym

b.TextColor3 = C.accent

b.Font = Enum.Font.GothamBold

b.TextSize = 14

b.ZIndex = row.ZIndex + 1

mkCorner(b, 7)

mkStroke(b, C.rowStroke, 1)

return b

end

local decBtn = mkBtn("−", -62)

local incBtn = mkBtn("+", -30)

local function setVal(v)

local s = step or 1

if math.floor(s) ~= s then

v = math.floor(v / s + 0.5) * s

v = tonumber(string.format("%.2f", v)) or v

else

v = math.floor(v + 0.5)

end

val = math.clamp(v, minVal, maxVal)

valLbl.Text = tostring(val)

if configKey then Config[configKey] = val end

if onChange then pcall(onChange, val) end

onConfigChanged()

end

valLbl.FocusLost:Connect(function()

local n = tonumber(valLbl.Text)

if n then setVal(n) else valLbl.Text = tostring(val) end

end)

if configKey then registerUISetter(configKey, function(v) if tonumber(v) then val = math.clamp(tonumber(v), minVal, maxVal); valLbl.Text = tostring(val) end end) end

decBtn.MouseButton1Click:Connect(function() setVal(val - (step or 1)) end)

incBtn.MouseButton1Click:Connect(function() setVal(val + (step or 1)) end)

end

local function makeDropdownRow(page, label, options, current, onChange, configKey)

local ROW_H = 36

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1, 0, 0, ROW_H)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

row.ClipsDescendants = false

row.ZIndex = 10

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.48, 0, 1, 0)

lbl.Position = UDim2.new(0, 10, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local selBtn = Instance.new("TextButton", row)

selBtn.Size = UDim2.new(0.44, 0, 0, 26)

selBtn.Position = UDim2.new(0.52, 0, 0.5, -13)

selBtn.BackgroundColor3 = Color3.fromRGB(18, 12, 28)

selBtn.Text = (current or options[1] or "?") .. " ▾"

selBtn.TextColor3 = C.accent

selBtn.Font = Enum.Font.GothamBold

selBtn.TextSize = 11

selBtn.ZIndex = 11

mkCorner(selBtn, 8)

mkStroke(selBtn, C.rowStroke, 1)

local open = false

local dropFrame = Instance.new("Frame", row)

dropFrame.Size = UDim2.new(0.44, 0, 0, #options * 28 + 4)

dropFrame.Position = UDim2.new(0.52, 0, 1, 2)

dropFrame.BackgroundColor3 = Color3.fromRGB(14, 10, 22)

dropFrame.BorderSizePixel = 0

dropFrame.Visible = false

dropFrame.ZIndex = 20

mkCorner(dropFrame, 8)

mkStroke(dropFrame, C.accent, 1)

local ll = Instance.new("UIListLayout", dropFrame)

ll.SortOrder = Enum.SortOrder.LayoutOrder

ll.Padding = UDim.new(0, 2)

local pad = Instance.new("UIPadding", dropFrame)

pad.PaddingLeft = UDim.new(0,4); pad.PaddingRight = UDim.new(0,4)

pad.PaddingTop  = UDim.new(0,2); pad.PaddingBottom = UDim.new(0,2)

for i, opt in ipairs(options) do

local ob = Instance.new("TextButton", dropFrame)

ob.Size = UDim2.new(1,0,0,24)

ob.BackgroundTransparency = 1

ob.Text = opt

ob.TextColor3 = Color3.fromRGB(220,220,220)

ob.Font = Enum.Font.Gotham

ob.TextSize = 11

ob.TextXAlignment = Enum.TextXAlignment.Left

ob.LayoutOrder = i

ob.ZIndex = 21

ob.MouseEnter:Connect(function() ob.TextColor3 = C.accent end)

ob.MouseLeave:Connect(function() ob.TextColor3 = Color3.fromRGB(220,220,220) end)

ob.MouseButton1Click:Connect(function()

selBtn.Text = opt .. " ▾"

if configKey then Config[configKey] = opt end

if onChange then pcall(onChange, opt) end

onConfigChanged()

dropFrame.Visible = false

open = false

end)

end

selBtn.MouseButton1Click:Connect(function()

open = not open

dropFrame.Visible = open

end)

end

local function makeButtonRow(page, label, btnText, onClick)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1,0,0,36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.52,0,1,0)

lbl.Position = UDim2.new(0,10,0,0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local btn = Instance.new("TextButton", row)

btn.Size = UDim2.new(0.42,0,0,26)

btn.Position = UDim2.new(0.56,0,0.5,-13)

btn.BackgroundColor3 = C.accentDim

btn.Text = btnText

btn.TextColor3 = Color3.fromRGB(255,255,255)

btn.Font = Enum.Font.GothamBold

btn.TextSize = 11

btn.ZIndex = row.ZIndex + 1

mkCorner(btn, 8)

btn.MouseButton1Click:Connect(function() if onClick then pcall(onClick) end end)

end

local function makeKeybindRow(page, label, currentKey, onKeyChange)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1,0,0,36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.52,0,1,0)

lbl.Position = UDim2.new(0,10,0,0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local keyName = (currentKey and currentKey ~= Enum.KeyCode.Unknown) and currentKey.Name or "None"

local keyBtn = Instance.new("TextButton", row)

keyBtn.Size = UDim2.new(0, 72, 0, 26)

keyBtn.Position = UDim2.new(1, -106, 0.5, -13)

keyBtn.BackgroundColor3 = Color3.fromRGB(18,12,28)

keyBtn.Text = keyName

keyBtn.TextColor3 = C.accent

keyBtn.Font = Enum.Font.GothamBold

keyBtn.TextSize = 10

keyBtn.ZIndex = row.ZIndex + 1

mkCorner(keyBtn, 8)

mkStroke(keyBtn, C.rowStroke, 1)

local clearBtn = Instance.new("TextButton", row)

clearBtn.Size = UDim2.new(0, 26, 0, 26)

clearBtn.Position = UDim2.new(1, -32, 0.5, -13)

clearBtn.BackgroundColor3 = Color3.fromRGB(24,16,28)

clearBtn.Text = "✕"

clearBtn.TextColor3 = Color3.fromRGB(255,80,100)

clearBtn.Font = Enum.Font.GothamBold

clearBtn.TextSize = 12

mkCorner(clearBtn, 6)

mkStroke(clearBtn, Color3.fromRGB(70,30,45), 1)

clearBtn.MouseButton1Click:Connect(function()

keyBtn.Text = "None"

if onKeyChange then onKeyChange(nil) end

end)

keyBtn.MouseButton1Click:Connect(function()

keyBtn.Text = "..."

local conn

conn = UserInputService.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.Keyboard then

conn:Disconnect()

if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then

keyBtn.Text = "None"

if onKeyChange then onKeyChange(nil) end

else

keyBtn.Text = input.KeyCode.Name

if onKeyChange then onKeyChange(input.KeyCode) end

end

end

end)

end)

end

local openColorPicker; do

local pickerFrame = Instance.new("Frame", ScreenGui)

pickerFrame.Name = "TK4_ColorPicker"

pickerFrame.Size = UDim2.fromOffset(214, 194)

pickerFrame.Position = UDim2.new(0.5, -107, 0.5, -97)

pickerFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 22)

pickerFrame.BorderSizePixel = 0

pickerFrame.Visible = false

pickerFrame.ZIndex = 250

pickerFrame.Active = true

mkCorner(pickerFrame, 10)

mkStroke(pickerFrame, C.accent, 1.5)

local title = Instance.new("TextLabel", pickerFrame)

title.Size = UDim2.new(1, -30, 0, 26)

title.Position = UDim2.new(0, 10, 0, 0)

title.BackgroundTransparency = 1

title.Text = "Color Picker"

title.TextColor3 = Color3.fromRGB(255, 255, 255)

title.Font = Enum.Font.GothamBold

title.TextSize = 11

title.TextXAlignment = Enum.TextXAlignment.Left

title.ZIndex = 251

local closeBtn = Instance.new("TextButton", pickerFrame)

closeBtn.Size = UDim2.fromOffset(22, 22)

closeBtn.Position = UDim2.new(1, -26, 0, 2)

closeBtn.BackgroundTransparency = 1

closeBtn.Text = "X"

closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)

closeBtn.Font = Enum.Font.GothamBold

closeBtn.TextSize = 12

closeBtn.ZIndex = 251

closeBtn.MouseButton1Click:Connect(function() pickerFrame.Visible = false end)

local svSquare = Instance.new("Frame", pickerFrame)

svSquare.Size = UDim2.fromOffset(150, 110)

svSquare.Position = UDim2.fromOffset(10, 28)

svSquare.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

svSquare.BorderSizePixel = 0

svSquare.ZIndex = 252

mkCorner(svSquare, 6)

local whiteGrad = Instance.new("Frame", svSquare)

whiteGrad.Size = UDim2.new(1, 0, 1, 0)

whiteGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

whiteGrad.BorderSizePixel = 0

whiteGrad.ZIndex = 253

mkCorner(whiteGrad, 6)

local wGrad = Instance.new("UIGradient", whiteGrad)

wGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

local blackGrad = Instance.new("Frame", svSquare)

blackGrad.Size = UDim2.new(1, 0, 1, 0)

blackGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

blackGrad.BorderSizePixel = 0

blackGrad.ZIndex = 254

mkCorner(blackGrad, 6)

local bGrad = Instance.new("UIGradient", blackGrad)

bGrad.Rotation = 90

bGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})

local svKnob = Instance.new("Frame", svSquare)

svKnob.Size = UDim2.fromOffset(8, 8)

svKnob.AnchorPoint = Vector2.new(0.5, 0.5)

svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

svKnob.BorderSizePixel = 0

svKnob.ZIndex = 256

mkCorner(svKnob, 4)

mkStroke(svKnob, Color3.fromRGB(0, 0, 0), 1)

local hueBar = Instance.new("Frame", pickerFrame)

hueBar.Size = UDim2.fromOffset(24, 110)

hueBar.Position = UDim2.fromOffset(170, 28)

hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

hueBar.BorderSizePixel = 0

hueBar.ZIndex = 252

mkCorner(hueBar, 6)

local hGrad = Instance.new("UIGradient", hueBar)

hGrad.Rotation = 90

hGrad.Color = ColorSequence.new({

ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),

ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),

ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),

ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),

ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),

ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),

ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))

})

local hueKnob = Instance.new("Frame", hueBar)

hueKnob.Size = UDim2.new(1, 4, 0, 4)

hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)

hueKnob.Position = UDim2.new(0.5, 0, 0, 0)

hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

hueKnob.BorderSizePixel = 0

hueKnob.ZIndex = 256

mkCorner(hueKnob, 2)

mkStroke(hueKnob, Color3.fromRGB(0, 0, 0), 1)

local preview = Instance.new("Frame", pickerFrame)

preview.Size = UDim2.fromOffset(45, 26)

preview.Position = UDim2.fromOffset(10, 150)

preview.BackgroundColor3 = C.accent

preview.BorderSizePixel = 0

preview.ZIndex = 252

mkCorner(preview, 6)

mkStroke(preview, C.rowStroke, 1)

local hexLbl = Instance.new("TextLabel", pickerFrame)

hexLbl.Size = UDim2.fromOffset(80, 26)

hexLbl.Position = UDim2.fromOffset(62, 150)

hexLbl.BackgroundTransparency = 1

hexLbl.Text = "#7B5CEA"

hexLbl.TextColor3 = Color3.fromRGB(200, 200, 220)

hexLbl.Font = Enum.Font.GothamBold

hexLbl.TextSize = 11

hexLbl.ZIndex = 252

local currentReq = nil

local curH, curS, curV = 0.75, 0.8, 0.9

local function applyColor()

local col = Color3.fromHSV(curH, curS, curV)

preview.BackgroundColor3 = col

local r = math.clamp(math.floor(col.R * 255 + 0.5), 0, 255)

local g = math.clamp(math.floor(col.G * 255 + 0.5), 0, 255)

local b = math.clamp(math.floor(col.B * 255 + 0.5), 0, 255)

hexLbl.Text = string.format("#%02X%02X%02X", r, g, b)

if currentReq then

if currentReq.key then

Config["esp_col_" .. currentReq.key .. "_r"] = r

Config["esp_col_" .. currentReq.key .. "_g"] = g

Config["esp_col_" .. currentReq.key .. "_b"] = b

end

if currentReq.swatch then currentReq.swatch.BackgroundColor3 = col end

if currentReq.hexLabel then currentReq.hexLabel.Text = hexLbl.Text end

if currentReq.onChange then pcall(currentReq.onChange, col) end

end

end

local svDrag, hueDrag = false, false

svSquare.InputBegan:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

svDrag = true

local pos = inp.Position

local ap = svSquare.AbsolutePosition

local as = svSquare.AbsoluteSize

curS = math.clamp((pos.X - ap.X) / as.X, 0, 1)

curV = 1 - math.clamp((pos.Y - ap.Y) / as.Y, 0, 1)

svKnob.Position = UDim2.new(curS, 0, 1 - curV, 0)

applyColor()

end

end)

hueBar.InputBegan:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

hueDrag = true

local pos = inp.Position

local ap = hueBar.AbsolutePosition

local as = hueBar.AbsoluteSize

curH = math.clamp((pos.Y - ap.Y) / as.Y, 0, 1)

hueKnob.Position = UDim2.new(0.5, 0, curH, 0)

svSquare.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)

applyColor()

end

end)

regConn(UserInputService.InputChanged:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then

if svDrag then

local pos = inp.Position

local ap = svSquare.AbsolutePosition

local as = svSquare.AbsoluteSize

curS = math.clamp((pos.X - ap.X) / as.X, 0, 1)

curV = 1 - math.clamp((pos.Y - ap.Y) / as.Y, 0, 1)

svKnob.Position = UDim2.new(curS, 0, 1 - curV, 0)

applyColor()

elseif hueDrag then

local pos = inp.Position

local ap = hueBar.AbsolutePosition

local as = hueBar.AbsoluteSize

curH = math.clamp((pos.Y - ap.Y) / as.Y, 0, 1)

hueKnob.Position = UDim2.new(0.5, 0, curH, 0)

svSquare.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)

applyColor()

end

end

end))

regConn(UserInputService.InputEnded:Connect(function(inp)

if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then

svDrag = false

hueDrag = false

end

end))

openColorPicker = function(req)

currentReq = req

title.Text = "Color: " .. (req.label or "Picker")

local initCol = req.color or Color3.fromRGB(

Config["esp_col_" .. req.key .. "_r"] or 123,

Config["esp_col_" .. req.key .. "_g"] or 92,

Config["esp_col_" .. req.key .. "_b"] or 234

)

curH, curS, curV = Color3.toHSV(initCol)

svSquare.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)

svKnob.Position = UDim2.new(curS, 0, 1 - curV, 0)

hueKnob.Position = UDim2.new(0.5, 0, curH, 0)

applyColor()

pickerFrame.Visible = true

end

end

local function makeColorPickerRow(page, label, keyPrefix, defaultColor, onChange)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1, 0, 0, 36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.55, 0, 1, 0)

lbl.Position = UDim2.new(0, 10, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local curCol = getESPColor(keyPrefix, defaultColor)

local hexCode = string.format("#%02X%02X%02X", math.floor(curCol.R * 255), math.floor(curCol.G * 255), math.floor(curCol.B * 255))

local hexLbl = Instance.new("TextLabel", row)

hexLbl.Size = UDim2.new(0, 60, 0, 22)

hexLbl.Position = UDim2.new(1, -98, 0.5, -11)

hexLbl.BackgroundTransparency = 1

hexLbl.Text = hexCode

hexLbl.TextColor3 = C.rowValue

hexLbl.Font = Enum.Font.Gotham

hexLbl.TextSize = 10

hexLbl.TextXAlignment = Enum.TextXAlignment.Right

local swatchBtn = Instance.new("TextButton", row)

swatchBtn.Size = UDim2.new(0, 28, 0, 22)

swatchBtn.Position = UDim2.new(1, -34, 0.5, -11)

swatchBtn.BackgroundColor3 = curCol

swatchBtn.BorderSizePixel = 0

swatchBtn.Text = ""

swatchBtn.ZIndex = row.ZIndex + 1

mkCorner(swatchBtn, 6)

mkStroke(swatchBtn, Color3.fromRGB(255, 255, 255), 1)

swatchBtn.MouseButton1Click:Connect(function()

if openColorPicker then

openColorPicker({

label = label,

key = keyPrefix,

color = getESPColor(keyPrefix, defaultColor),

swatch = swatchBtn,

hexLabel = hexLbl,

onChange = onChange

})

end

end)

return row

end

do

local aimFrame = makeMainTabFrame("AIM")

local addSub   = makeSubSystem(aimFrame)

local p0 = addSub("Combat Master")

makeToggleRow(p0, "Combat Master (God Combo)", Config.CombatMaster, function(on) setCombatMaster(on) end, "CombatMaster")

makeToggleRow(p0, "Auto Spam Recharge", Config.AutoReload, function(on) Config.AutoReload = on end, "AutoReload")

local p1 = addSub("Silent Aim")

makeToggleRow(p1, "Silent Aim", Config.SilentAim, function(on) Config.SilentAim = on end, "SilentAim")

makeDropdownRow(p1, "Hit Part", {"Head","Neck","Torso","Closest"}, Config.HitPart, function(v) Config.HitPart = v end, "HitPart")

makeStepperRow(p1, "Hit Chance (%)", Config.HitChance, 10, 100, 5, function(n) Config.HitChance = n end, "HitChance")

makeStepperRow(p1, "Silent FOV Radius", Config.FOVRadius, 30, 500, 10, function(n) Config.FOVRadius = n; if FOVCircle then FOVCircle.Radius = n end end, "FOVRadius")

makeToggleRow(p1, "Wall Check", Config.WallCheck, function(on) Config.WallCheck = on end, "WallCheck")

makeToggleRow(p1, "Skip Deflect / Parry", Config.SkipDeflect, function(on) Config.SkipDeflect = on end, "SkipDeflect")

makeToggleRow(p1, "Skip Spawn Protection", Config.SkipImmune, function(on) Config.SkipImmune = on end, "SkipImmune")

local p2 = addSub("Camera Aim")

makeToggleRow(p2, "Camera Aimbot", Config.CamAimbot, function(on) Config.CamAimbot = on end, "CamAimbot")

makeDropdownRow(p2, "Aim Mode", {"While Firing", "Always", "Hold Key"}, (Config.CamAimMode == "Auto" or not Config.CamAimMode) and "While Firing" or Config.CamAimMode, function(v) Config.CamAimMode = v end, "CamAimMode")

makeStepperRow(p2, "Smoothness", Config.CamAimSmooth, 5, 100, 5, function(n) Config.CamAimSmooth = n end, "CamAimSmooth")

makeStepperRow(p2, "Camera FOV Radius", Config.CamAimFOV, 30, 500, 10, function(n) Config.CamAimFOV = n end, "CamAimFOV")

makeDropdownRow(p2, "Aim Part", {"Head","Neck","Torso","Closest"}, Config.CamAimPart, function(v) Config.CamAimPart = v end, "CamAimPart")

makeKeybindRow(p2, "Hold Key", Config.CamAimKey, function(key) Config.CamAimKey = key end)

makeToggleRow(p2, "Team Check", Config.TeamCheck, function(on) Config.TeamCheck = on end, "TeamCheck")

makeToggleRow(p2, "Hitbox Expander", Config.HitboxExpander, function(on) Config.HitboxExpander = on; if not on then updateHitboxes() end end, "HitboxExpander")

makeStepperRow(p2, "Hitbox Size", Config.HitboxSize, 4, 35, 1, function(n) Config.HitboxSize = n end, "HitboxSize")

local p3 = addSub("Weapons")

makeToggleRow(p3, "Rapid Fire", Config.RapidFire, function(on) Config.RapidFire = on; applyWeaponMods() end, "RapidFire")

makeStepperRow(p3, "Rapid Multiplier", Config.RapidMultiplier, 1.2, 3.5, 0.2, function(n) Config.RapidMultiplier = n; if Config.RapidFire then applyWeaponMods() end end, "RapidMultiplier")

makeToggleRow(p3, "Full Auto", Config.FullAuto, function(on) Config.FullAuto = on; applyWeaponMods() end, "FullAuto")

makeToggleRow(p3, "Smart Infinite Ammo", Config.InfiniteAmmo, function(on) Config.InfiniteAmmo = on; if on then resetWeaponCooldown() end end, "InfiniteAmmo")

makeToggleRow(p3, "Auto Spam Recharge", Config.AutoReload, function(on) Config.AutoReload = on end, "AutoReload")

makeToggleRow(p3, "No Recoil", Config.NoRecoil, function(on) Config.NoRecoil = on; applyWeaponMods() end, "NoRecoil")

makeToggleRow(p3, "No Bloom / No Spread", Config.NoBloom, function(on) Config.NoBloom = on end, "NoBloom")

makeToggleRow(p3, "No Shot Slowdown", Config.NoShotSlowdown, function(on) Config.NoShotSlowdown = on end, "NoShotSlowdown")

makeToggleRow(p3, "No Scope Blackout", Config.NoScopeBlackout, function(on) Config.NoScopeBlackout = on end, "NoScopeBlackout")

end

do

local visFrame = makeMainTabFrame("VISUALS")

local addSub   = makeSubSystem(visFrame)

local p1 = addSub("ESP")

makeToggleRow(p1, "ESP Master Switch", Config.ESP_Master, function(on) Config.ESP_Master = on end, "ESP_Master")

makeToggleRow(p1, "Box ESP", Config.ESP_Box, function(on) Config.ESP_Box = on end, "ESP_Box")

makeDropdownRow(p1, "Box Style", {"Corner","2D Box"}, Config.ESP_BoxStyle, function(v) Config.ESP_BoxStyle = v end, "ESP_BoxStyle")

makeToggleRow(p1, "Full Skeleton (R15)", Config.ESP_Skeleton, function(on) Config.ESP_Skeleton = on end, "ESP_Skeleton")

makeToggleRow(p1, "Health Bar", Config.ESP_Health, function(on) Config.ESP_Health = on end, "ESP_Health")

makeToggleRow(p1, "Player Names", Config.ESP_Names, function(on) Config.ESP_Names = on end, "ESP_Names")

makeToggleRow(p1, "Show Level (Lv.X)", Config.ESP_Level, function(on) Config.ESP_Level = on end, "ESP_Level")

makeToggleRow(p1, "Show Rank Name", Config.ESP_Rank, function(on) Config.ESP_Rank = on end, "ESP_Rank")

makeToggleRow(p1, "Protected & Heal Alerts", Config.ESP_Alerts, function(on) Config.ESP_Alerts = on end, "ESP_Alerts")

makeToggleRow(p1, "Real-time Firing Alert", Config.ESP_FiringAlert, function(on) Config.ESP_FiringAlert = on end, "ESP_FiringAlert")

local p2 = addSub("Overlays")

makeToggleRow(p2, "Distance Label", Config.ESP_Distance, function(on) Config.ESP_Distance = on end, "ESP_Distance")

makeToggleRow(p2, "Snapline Tracers", Config.ESP_Tracers, function(on) Config.ESP_Tracers = on end, "ESP_Tracers")

makeStepperRow(p2, "Max Distance", Config.ESP_MaxDistance, 50, 1000, 25, function(n) Config.ESP_MaxDistance = n end, "ESP_MaxDistance")

makeToggleRow(p2, "Draw FOV Circle", Config.DrawFOV, function(on) Config.DrawFOV = on; if FOVCircle then FOVCircle.Visible = on end end, "DrawFOV")

makeToggleRow(p2, "Enable Crosshair", Config.Crosshair_Enabled, function(on) Config.Crosshair_Enabled = on end, "Crosshair_Enabled")

makeStepperRow(p2, "Crosshair Size", Config.Crosshair_Size, 2, 25, 1, function(n) Config.Crosshair_Size = n end, "Crosshair_Size")

makeStepperRow(p2, "Crosshair Gap", Config.Crosshair_Gap, 0, 15, 1, function(n) Config.Crosshair_Gap = n end, "Crosshair_Gap")

local p3 = addSub("Colors")

makeColorPickerRow(p3, "Box ESP Color", "box", Color3.fromRGB(123, 92, 234))

makeColorPickerRow(p3, "Skeleton Color", "skel", Color3.fromRGB(245, 245, 255))

makeColorPickerRow(p3, "Snapline Tracers", "tracer", Color3.fromRGB(123, 92, 234))

makeColorPickerRow(p3, "Head Circle Color", "head", Color3.fromRGB(123, 92, 234))

makeColorPickerRow(p3, "Player Name Color", "name", Color3.fromRGB(255, 255, 255))

makeColorPickerRow(p3, "Distance Color", "dist", Color3.fromRGB(180, 170, 200))

local p4 = addSub("Highlight")

makeToggleRow(p4, "Highlight Players (Outline/Glow)", Config.HighlightEnabled,

function(on)

Config.HighlightEnabled = on

pcall(refreshAllHighlights)

end, "HighlightEnabled")

makeToggleRow(p4, "Skip Teammates", Config.HighlightTeamCheck,

function(on)

Config.HighlightTeamCheck = on

pcall(refreshAllHighlights)

end, "HighlightTeamCheck")

makeDropdownRow(p4, "Depth Mode",

{"AlwaysOnTop", "Occluded"},

Config.HighlightDepthMode,

function(v)

Config.HighlightDepthMode = v

pcall(refreshAllHighlights)

end, "HighlightDepthMode")

makeStepperRow(p4, "Fill Transparency", Config.hl_fill_transparency, 0, 1, 0.05,

function(n)

Config.hl_fill_transparency = n

pcall(refreshAllHighlights)

end, "hl_fill_transparency")

makeStepperRow(p4, "Outline Transparency", Config.hl_outline_transparency, 0, 1, 0.05,

function(n)

Config.hl_outline_transparency = n

pcall(refreshAllHighlights)

end, "hl_outline_transparency")

do

local function makeHLColorRow(page, label, prefix)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1, 0, 0, 36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowHov}):Play() end)

row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowBg}):Play() end)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.52,0,1,0)

lbl.Position = UDim2.new(0,10,0,0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local swatch = Instance.new("TextButton", row)

swatch.Size = UDim2.new(0, 56, 0, 24)

swatch.Position = UDim2.new(1, -66, 0.5, -12)

swatch.BorderSizePixel = 0

swatch.Text = ""

swatch.ZIndex = row.ZIndex + 1

mkCorner(swatch, 6)

mkStroke(swatch, C.rowStroke, 1)

local function updateSwatch()

swatch.BackgroundColor3 = Color3.fromRGB(

math.clamp(Config["hl_col_" .. prefix .. "_r"] or 123, 0, 255),

math.clamp(Config["hl_col_" .. prefix .. "_g"] or 92,  0, 255),

math.clamp(Config["hl_col_" .. prefix .. "_b"] or 234, 0, 255)

)

end

updateSwatch()

swatch.MouseButton1Click:Connect(function()

openColorPicker(

Color3.fromRGB(

Config["hl_col_" .. prefix .. "_r"] or 123,

Config["hl_col_" .. prefix .. "_g"] or 92,

Config["hl_col_" .. prefix .. "_b"] or 234

),

function(col)

Config["hl_col_" .. prefix .. "_r"] = math.floor(col.R * 255 + 0.5)

Config["hl_col_" .. prefix .. "_g"] = math.floor(col.G * 255 + 0.5)

Config["hl_col_" .. prefix .. "_b"] = math.floor(col.B * 255 + 0.5)

updateSwatch()

pcall(refreshAllHighlights)

onConfigChanged()

end

)

end)

end

makeHLColorRow(p4, "Outline Color", "outline")

makeHLColorRow(p4, "Fill Color",    "fill")

end

end

do

local moveFrame = makeMainTabFrame("MOVE")

local addSub    = makeSubSystem(moveFrame)

local p2 = addSub("Speed")

makeToggleRow(p2, "Speed Boost (ALV)", Config.SpeedBoost, function(on)

Config.SpeedBoost = on

if not on then

if State._swapPack and State._swapPack.clone then

local char = LP.Character

local pack = State._swapPack

pcall(function()

pack.clone:Destroy()

if pack.orig then pack.orig.Parent = char end

end)

pack.orig  = nil

pack.clone = nil

end

end

end, "SpeedBoost")

local function numInput(page, label, key, minV, maxV, isFloat)

local row = Instance.new("Frame", page)

row.Size = UDim2.new(1, 0, 0, 36)

row.BackgroundColor3 = C.rowBg

row.BackgroundTransparency = C.rowAlpha

row.BorderSizePixel = 0

row.LayoutOrder = LO()

mkCorner(row, 10)

mkStroke(row, C.rowStroke, 1)

row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowHov}):Play() end)

row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowBg}):Play() end)

local lbl = Instance.new("TextLabel", row)

lbl.Size = UDim2.new(0.6, 0, 1, 0)

lbl.Position = UDim2.new(0, 10, 0, 0)

lbl.BackgroundTransparency = 1

lbl.Text = label

lbl.TextColor3 = C.rowLabel

lbl.Font = Enum.Font.Gotham

lbl.TextSize = 12

lbl.TextXAlignment = Enum.TextXAlignment.Left

local wrap = Instance.new("Frame", row)

wrap.Size = UDim2.new(0, 68, 0, 24)

wrap.Position = UDim2.new(1, -76, 0.5, -12)

wrap.BackgroundColor3 = Color3.fromRGB(18, 12, 28)

wrap.BorderSizePixel = 0

mkCorner(wrap, 7)

local stroke = mkStroke(wrap, C.rowStroke, 1)

local box = Instance.new("TextBox", wrap)

box.Size = UDim2.new(1, -6, 1, 0)

box.Position = UDim2.new(0, 3, 0, 0)

box.BackgroundTransparency = 1

box.TextColor3 = C.rowValue

box.Font = Enum.Font.GothamBold

box.TextSize = 13

box.ClearTextOnFocus = false

box.ZIndex = row.ZIndex + 2

box.TextXAlignment = Enum.TextXAlignment.Center

box.PlaceholderText = tostring(minV) .. "-" .. tostring(maxV)

local function fmt(v)

v = math.clamp(tonumber(v) or minV, minV, maxV)

if not isFloat then v = math.floor(v + 0.5) end

return v

end

box.Text = tostring(fmt(Config[key]))

box.Focused:Connect(function()

TweenService:Create(stroke, TweenInfo.new(0.15), {Color = C.accent}):Play()

end)

box.FocusLost:Connect(function()

TweenService:Create(stroke, TweenInfo.new(0.15), {Color = C.rowStroke}):Play()

local n = tonumber(box.Text)

if n then Config[key] = fmt(n) end

box.Text = tostring(fmt(Config[key]))

if onConfigChanged then pcall(onConfigChanged) end

end)

registerUISetter(key, function(v) box.Text = tostring(fmt(v)) end)

end

numInput(p2, "Boost Speed (1-100)", "SpeedBoostValue", 1, 100)

makeToggleRow(p2, "Auto Sprint + Stamina (mobile ok)", Config.AutoSprint, function(on) Config.AutoSprint = on end, "AutoSprint")

makeToggleRow(p2, "Humanoid Swap Shield", Config.HumanoidSwap, function(on) Config.HumanoidSwap = on end, "HumanoidSwap")

local p3 = addSub("Crouch & Handling")

makeToggleRow(p3, "Fast Crouch (Slide-Walk)", Config.FastCrouch, function(on) Config.FastCrouch = on end, "FastCrouch")

numInput(p3, "Crouch Speed (1-100)", "CrouchSpeed", 1, 100)

makeToggleRow(p3, "Full Speed ADS", Config.FullSpeedADS, function(on) Config.FullSpeedADS = on end, "FullSpeedADS")

makeToggleRow(p3, "Instant Turn", Config.InstantTurn, function(on) Config.InstantTurn = on end, "InstantTurn")

local p1 = addSub("Agility")

makeToggleRow(p1, "Infinite Stamina", Config.InfiniteStamina, function(on) Config.InfiniteStamina = on end, "InfiniteStamina")

makeToggleRow(p1, "Infinite Jump", Config.InfiniteJump, function(on) Config.InfiniteJump = on end, "InfiniteJump")

makeToggleRow(p1, "No Jump Delay", Config.NoJumpDelay, function(on) Config.NoJumpDelay = on end, "NoJumpDelay")

end

do

local worldFrame = makeMainTabFrame("WORLD")

local addSub     = makeSubSystem(worldFrame)

local p1 = addSub("Lighting")

makeToggleRow(p1, "Fullbright", Config.LightFullbright, function(on) Config.LightFullbright = on; applyLighting() end, "LightFullbright")

makeToggleRow(p1, "No Fog", Config.LightNoFog, function(on) Config.LightNoFog = on; applyLighting() end, "LightNoFog")

makeToggleRow(p1, "Custom Time Of Day", Config.LightClockOn, function(on) Config.LightClockOn = on; applyLighting() end, "LightClockOn")

makeStepperRow(p1, "Clock Time (Hours)", Config.LightClock, 0, 24, 1, function(n) Config.LightClock = n; applyLighting() end, "LightClock")

local p2 = addSub("Camera & View")

makeStepperRow(p2, "Camera FOV", Config.CameraFOV, 70, 120, 5, function(n) Config.CameraFOV = n; applyPrefs() end, "CameraFOV")

makeToggleRow(p2, "No Kill Screen Shake", Config.NoKillShake, function(on) Config.NoKillShake = on; applyPrefs() end, "NoKillShake")

end

do

local cfgFrame = makeMainTabFrame("CONFIG")

local addSub   = makeSubSystem(cfgFrame)

local p1 = addSub("Settings & Alerts")

makeToggleRow(p1, "Match Start Notifications", Config.MatchNotifier, function(on) Config.MatchNotifier = on end, "MatchNotifier")

makeToggleRow(p1, "Silent Hit Sound", Config.SilentHitSound, function(on) Config.SilentHitSound = on end, "SilentHitSound")

makeKeybindRow(p1, "Menu Toggle Key", Config.MenuKey, function(key) Config.MenuKey = key end)

makeToggleRow(p1, "Auto Save On Change", Config.AutoSaveConfig, function(on) Config.AutoSaveConfig = on end, "AutoSaveConfig")

local p2 = addSub("Manager")

local infoLbl = Instance.new("TextLabel", p2)

infoLbl.Size = UDim2.new(1, 0, 0, 52)

infoLbl.BackgroundTransparency = 1

infoLbl.Font = Enum.Font.Gotham

infoLbl.Text = string.format("%s — %s\n%s\n%s", BRAND.Name, BRAND.Full, BRAND.Motto, BRAND.Version)

infoLbl.TextColor3 = C.rowLabel

infoLbl.TextSize = 12

infoLbl.TextWrapped = true

infoLbl.LayoutOrder = LO()

makeButtonRow(p1, "Test Staff HUD (5s preview)", "Test", function()

State._staffInServer["__test__"] = {

text = "OWNER",

color = Color3.fromRGB(214, 160, 30)

}

pcall(function() StaffHUD.refresh() end)

task.delay(5, function()

State._staffInServer["__test__"] = nil

pcall(function() StaffHUD.refresh() end)

end)

end)

makeButtonRow(p2, "Save Configuration", "Save", function() saveConfigToFile() end)

makeButtonRow(p2, "Destroy Script", "Destroy", function() pcall(function() GStore.TK4_RESPECT_CLEANUP() end) end)

end

switchMainTab("AIM")

UserInputService.InputBegan:Connect(function(inp, gpe)

if inp.UserInputType == Enum.UserInputType.Keyboard

and inp.KeyCode == Config.MenuKey then

toggleMenu()

return

end

if gpe then return end  

if (Config.InfiniteJump or Config.CombatMaster) and not Config.GuiVisible

and inp.KeyCode == Enum.KeyCode.Space then

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end

end

end)

UserInputService.JumpRequest:Connect(function()

if (Config.InfiniteJump or Config.CombatMaster) and not Config.GuiVisible then

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end

end

end)

do

local function bindControls(hum)

pcall(function()

local pm = LP.PlayerScripts and LP.PlayerScripts:FindFirstChild("PlayerModule")

if pm then

local c = require(pm):GetControls()

if type(c) == "table" then c.humanoid = hum end

end

end)

end

local function bounceAnimate(char)

local anim = char and char:FindFirstChild("Animate")

if anim and anim:IsA("LocalScript") then

task.spawn(function()

anim.Enabled = false

task.wait()

anim.Enabled = true

end)

end

end

local _groundedStates = {

[Enum.HumanoidStateType.Running] = true,

[Enum.HumanoidStateType.RunningNoPhysics] = true,

[Enum.HumanoidStateType.Landed] = true,

}

local function isGrounded(hum)

if not hum or hum.Health <= 0 then return false end

if hum.FloorMaterial == Enum.Material.Air then return false end

return _groundedStates[hum:GetState()] == true

end

local function doSwap()

local char = LP.Character

local hum = char and char:FindFirstChildOfClass("Humanoid")

if not hum or hum.Health <= 0 then return end

local pack = State._swapPack

if pack.clone and pack.clone.Parent == char then return end  

if not isGrounded(hum) then return end

local ok, clone = pcall(function() return hum:Clone() end)

if not ok or not clone then return end

pcall(function()

hum.Parent = nil

clone.Parent = char

workspace.CurrentCamera.CameraSubject = clone

bindControls(clone)

bounceAnimate(char)

pack.orig  = hum

pack.clone = clone

end)

end

local function undoSwap()

local pack = State._swapPack

local char = LP.Character

local orig  = pack.orig

local clone = pack.clone

if orig and clone and char then

pcall(function()

clone:Destroy()

orig.Parent = char

workspace.CurrentCamera.CameraSubject = orig

bindControls(orig)

bounceAnimate(char)

end)

end

pack.orig  = nil

pack.clone = nil

end

local function releaseSprint()

if not State._autoSprint then return end

State._autoSprint = false

pcall(function()

if MovementController and MovementController.SetSprint then

MovementController.SetSprint(false)

end

end)

end

local function isCrouching()

local c = false

pcall(function()

if ClientState and ClientState.Crouching ~= nil then

c = (ClientState.Crouching == true)

end

end)

if not c then

pcall(function()

local ch2 = LP.Character

if ch2 and CrouchController and CrouchController.IsCrouched then

c = CrouchController.IsCrouched(ch2) and true or false

end

end)

end

if not c then

pcall(function()

c = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C)

end)

end

return c

end

local function restoreALV()

releaseSprint()

if not State._speedOverriding then return end

State._speedOverriding = false

local char = LP.Character

local hrp  = char and char:FindFirstChild("HumanoidRootPart")

local hum  = char and char:FindFirstChildOfClass("Humanoid")

if not hrp or not hum then return end

local alv = hrp.AssemblyLinearVelocity

local md  = hum.MoveDirection

local flat = Vector3.new(md.X, 0, md.Z)

local snap = flat.Magnitude > 0.001 and flat.Unit * hum.WalkSpeed or Vector3.zero

pcall(function()

hrp.AssemblyLinearVelocity = Vector3.new(snap.X, alv.Y, snap.Z)

end)

end

task.spawn(function()

while GStore.TK4_SCRIPT_ID == SCRIPT_ID do

task.wait(0.25)

if not Config.SpeedBoost or not Config.HumanoidSwap then

if State._swapPack.clone then undoSwap() end

else

if Config.SpeedBoost and Config.HumanoidSwap then

pcall(doSwap)

end

end

end

end)

regConn(LP.CharacterAdded:Connect(function(newChar)

State._swapPack.orig  = nil

State._swapPack.clone = nil

State._speedOverriding = false

State._matchBotsFolderCache = nil

task.spawn(function()

task.wait(0.4)

pcall(applyWeaponMods)

pcall(updateHitboxes)

if Config.SpeedBoost and Config.HumanoidSwap then

task.wait(0.6)

pcall(doSwap)

end

end)

end))

local _lastMatchObj = nil

regConn(RunService.Heartbeat:Connect(function()

if ClientState then

local m = ClientState.Match

if m ~= _lastMatchObj then

_lastMatchObj = m

State._matchBotsFolderCache = nil

task.spawn(function()

task.wait(0.3)

pcall(applyWeaponMods)

pcall(updateHitboxes)

end)

end

end

end))

regConn(RunService.Heartbeat:Connect(function()

if not Config.SpeedBoost then

restoreALV()

return

end

local char = LP.Character

local hrp  = char and char:FindFirstChild("HumanoidRootPart")

local hum  = char and char:FindFirstChildOfClass("Humanoid")

if not hrp or not hum or hum.Health <= 0 or hum.Sit or hum.PlatformStand then

restoreALV()

return

end

local rag = tonumber(LP:GetAttribute("RagdollEndTime"))

if rag and rag > workspace:GetServerTimeNow() then

restoreALV()

return

end

local md   = hum.MoveDirection

local flat = Vector3.new(md.X, 0, md.Z)

if flat.Magnitude <= 0.001 then

restoreALV()

return

end

if Config.AutoSprint ~= false then

if isCrouching() then

releaseSprint()   

else

pcall(function()

if ClientState then

ClientState.Stamina = 100

ClientState.Exhausted = false

end

if MovementController and MovementController.SetSprint then

local on = false

if MovementController.IsSprintOn then on = MovementController.IsSprintOn() end

if not on then

MovementController.SetSprint(true)

State._autoSprint = true

end

end

end)

end

else

releaseSprint()

end

local n9  = math.clamp(Config.SpeedBoostValue or 40, 1, 100)

if isCrouching() then

local cs = (GameSettings and GameSettings.CrouchSpeed) or 12

n9 = math.min(n9, math.clamp(cs, 1, 100))

end

local n10 = flat.Unit * n9

local alv = hrp.AssemblyLinearVelocity

pcall(function()

hrp.AssemblyLinearVelocity = Vector3.new(n10.X, alv.Y, n10.Z)

end)

State._speedOverriding = true

end))

end

local renderConn = regConn(RunService.RenderStepped:Connect(function(dt)

pcall(function()

if Config.GuiVisible then return end

if Config.SilentAim or Config.CombatMaster then

local tPart, tPlr = findSilentTarget()

State.SilentTarget = tPart

State.CachedTarget = tPlr

else

State.SilentTarget = nil

State.CachedTarget = nil

end

if FOVCircle then

local mPos = getAimScreenCenter()

FOVCircle.Position = mPos

FOVCircle.Radius   = Config.FOVRadius

FOVCircle.Visible  = Config.DrawFOV

end

if ClientState then

pcall(function()

if Config.NoRecoil then

ClientState.RecoilPitch = 0

ClientState.RecoilYaw = 0

end

if Config.NoBloom then

ClientState.Spread = 0

if GameSettings then GameSettings.BloomScale = 0 end

elseif GameSettings and GameSettings.BloomScale == 0 then

GameSettings.BloomScale = 0.8

end

if Config.NoShotSlowdown or Config.CombatMaster then

pcall(function()

if GameSettings then

GameSettings.ShotRecovery = 0

end

ClientState.ShotRecoveryUntil = 0

ClientState.ShotRecoverySpeed = (GameSettings and GameSettings.SprintSpeed) or 26

end)

elseif GameSettings and GameSettings.ShotRecovery == 0 then

pcall(function()

GameSettings.ShotRecovery = 0.2

end)

end

if Config.NoScopeBlackout then

pcall(function()

if not _tk4MainGuiModule then

local mainGui = ReplicatedStorage:FindFirstChild("Client")

and ReplicatedStorage.Client:FindFirstChild("UI")

and ReplicatedStorage.Client.UI:FindFirstChild("MainGui")

if mainGui then

local ok, m = pcall(require, mainGui)

if ok then _tk4MainGuiModule = m end

end

end

if _tk4MainGuiModule then

local sc = _tk4MainGuiModule.Screen and _tk4MainGuiModule.Screen("Scope")

if sc and sc.Visible then

sc.Visible = false

end

end

end)

end

if Config.InfiniteStamina or Config.CombatMaster then

pcall(function()

ClientState.Stamina = 100

ClientState.Exhausted = false

end)

end

if Config.FastCrouch or Config.CombatMaster then

pcall(function()

if GameSettings then

local cs = math.clamp(Config.CrouchSpeed or 40, 1, 100)

GameSettings.CrouchSpeed = cs

GameSettings.CrouchStrafeSpeed = cs

end

end)

elseif GameSettings and GameSettings.CrouchSpeed ~= 12 then

pcall(function()

GameSettings.CrouchSpeed = 12

GameSettings.CrouchStrafeSpeed = 14

end)

end

if Config.FullSpeedADS then

pcall(function()

ClientState.AimWalkSpeed = (GameSettings and GameSettings.SprintSpeed) or 26

end)

elseif ClientState.AimWalkSpeed and ClientState.AimWalkSpeed > 11 then

pcall(function()

ClientState.AimWalkSpeed = 11

end)

end

if Config.InstantTurn then

pcall(function()

if GameSettings then

GameSettings.CombatTurnSpeed = 9999

GameSettings.TurnSpeed = 9999

GameSettings.SprintTurnSpeed = 9999

end

end)

elseif GameSettings and GameSettings.CombatTurnSpeed == 9999 then

pcall(function()

GameSettings.CombatTurnSpeed = 28

GameSettings.TurnSpeed = 14

GameSettings.SprintTurnSpeed = 9

end)

end

if Config.NoJumpDelay or Config.CombatMaster then

pcall(function()

if GameSettings and GameSettings.Jump then

GameSettings.Jump.Cooldown = 0

GameSettings.Jump.CameraDip = 0

GameSettings.Jump.HardLanding = 999999

end

ClientState.JumpReadyAt = 0

ClientState.LandDrop = 0

end)

elseif GameSettings and GameSettings.Jump and GameSettings.Jump.Cooldown == 0 then

pcall(function()

GameSettings.Jump.Cooldown = 0.3

GameSettings.Jump.CameraDip = 0.6

GameSettings.Jump.HardLanding = 60

end)

end

if Config.RapidFire or Config.InfiniteAmmo then

resetWeaponCooldown()

end

end) 

end

do

do

if Config.ESP_Master then

for _, player in ipairs(Players:GetPlayers()) do

if player ~= LP then

local ch = player.Character

local hum = ch and ch:FindFirstChildOfClass("Humanoid")

if hum and hum.Health > 0 then

if not State.ESPCache[player] then

State.ESPCache[player] = createESP(player)

end

updateESP(player, State.ESPCache[player])

elseif State.ESPCache[player] then

hideESP(State.ESPCache[player])

end

end

end

local matchBotsFolder = workspace:FindFirstChild("MatchBots")

if matchBotsFolder then

for _, bot in ipairs(matchBotsFolder:GetChildren()) do

local bHum = bot:FindFirstChildOfClass("Humanoid")

if bHum and bHum.Health > 0 then

local isEnemyBot = true

if Config.ESP_TeamCheck and ClientState and ClientState.Match and ClientState.Match.Players then

for _, entry in ipairs(ClientState.Match.Players) do

if entry.Name == bot.Name and entry.Team and ClientState.Match.Team and entry.Team == ClientState.Match.Team then

isEnemyBot = false; break

end

end

end

if isEnemyBot then

if not State.ESPCache[bot] then

local pseudo = { Name = bot.Name, DisplayName = "[BOT] " .. bot.Name, Character = bot, IsBot = true }

State.ESPCache[bot] = createESP(pseudo)

State.ESPCache[bot]._pseudo = pseudo

end

local pseudo = State.ESPCache[bot]._pseudo

updateESP(pseudo, State.ESPCache[bot])

elseif State.ESPCache[bot] then

hideESP(State.ESPCache[bot])

end

elseif State.ESPCache[bot] then

hideESP(State.ESPCache[bot])

end

end

end

local targetsFolder = workspace:FindFirstChild("Targets")

if targetsFolder then

for _, dummy in ipairs(targetsFolder:GetChildren()) do

local dHum = dummy:FindFirstChildOfClass("Humanoid")

if dHum and dHum.Health > 0 then

if not State.ESPCache[dummy] then

local pseudo = { Name = dummy.Name, DisplayName = dummy.Name, Character = dummy, IsBot = true }

State.ESPCache[dummy] = createESP(pseudo)

State.ESPCache[dummy]._pseudo = pseudo

end

local pseudo = State.ESPCache[dummy]._pseudo

updateESP(pseudo, State.ESPCache[dummy])

elseif State.ESPCache[dummy] then

hideESP(State.ESPCache[dummy])

end

elseif State.ESPCache[dummy] then

hideESP(State.ESPCache[dummy])

end

end

end

else

for _, esp in pairs(State.ESPCache) do hideESP(esp) end

end

for key, esp in pairs(State.ESPCache) do

if typeof(key) == "Instance" and not key.Parent then

destroyESP(esp)

State.ESPCache[key] = nil

end

end

end

end 

do

local _ch = Config.Crosshair_Enabled and Config.Crosshair_Style and Config.Crosshair_Size

local _sig = tostring(Config.Crosshair_Enabled) .. (Config.Crosshair_Style or "") ..

tostring(Config.Crosshair_Size) .. tostring(Config.Crosshair_Gap) ..

tostring(Config.Crosshair_Thick) .. tostring(Config.Crosshair_Dot) ..

tostring(Config.Crosshair_Outline)

if _sig ~= State._crosshairSig then

State._crosshairSig = _sig

updateCrosshair()

elseif Config.Crosshair_Enabled then

updateCrosshair()

end

end

if Config.HitboxExpander then updateHitboxes() end

end) 

end))

regConn(Players.PlayerRemoving:Connect(function(player)

local esp = State.ESPCache[player]

if esp then

destroyESP(esp)

State.ESPCache[player] = nil

end

end))

GStore.TK4_RESPECT_CLEANUP = function()

GStore.TK4_SCRIPT_ID = nil

GStore.TK4_TP_LISTENER_ACTIVE = nil

GStore.TK4_TP_QUEUED = nil

pcall(function()

local CAS_cleanup = game:GetService("ContextActionService")

CAS_cleanup:UnbindAction("TK4_CamSink")

CAS_cleanup:UnbindAction("TK4_CamSink_v2")  

CAS_cleanup:UnbindAction("TK4_CamSink_old")

end)

pcall(function()

local cam = workspace.CurrentCamera

if cam then

cam.CameraType = Enum.CameraType.Custom

end

end)

pcall(function()

local UIS = game:GetService("UserInputService")

UIS.MouseBehavior    = Enum.MouseBehavior.Default

UIS.MouseIconEnabled = true

end)

if _G._TK4_MouseConn then

pcall(function() _G._TK4_MouseConn:Disconnect() end)

_G._TK4_MouseConn = nil

end

pcall(function()

if type(restorefunction) == "function" then

local mt = getrawmetatable and getrawmetatable(game)

if mt and mt.__namecall and type(isfunctionhooked) == "function" and isfunctionhooked(mt.__namecall) then

restorefunction(mt.__namecall)

end

end

GStore.TK4_RAW_NAMECALL = nil

end)

if State and State.Connections then

for _, conn in ipairs(State.Connections) do

pcall(function() conn:Disconnect() end)

end

State.Connections = {}

end

pcall(function() RunService:UnbindFromRenderStep("TK4_CamAimV5") end)

pcall(function()

local pack = State._swapPack

local char = LP.Character

if pack and pack.clone and char then

pack.clone:Destroy()

if pack.orig then pack.orig.Parent = char end

end

if pack then

pack.orig  = nil

pack.clone = nil

end

end)

if State and State.ESPCache then

for _, esp in pairs(State.ESPCache) do destroyESP(esp) end

State.ESPCache = {}

end

if FOVCircle then pcall(function() FOVCircle:Remove() end) end

pcall(function()

if GStore._TK4_FOVCircle then GStore._TK4_FOVCircle:Remove(); GStore._TK4_FOVCircle = nil end

end)

pcall(function()

if GStore._TK4_ESPGui then

for _, ch in ipairs(GStore._TK4_ESPGui:GetChildren()) do pcall(function() ch:Destroy() end) end

pcall(function() GStore._TK4_ESPGui:Destroy() end)

GStore._TK4_ESPGui = nil

end

end)

if CrosshairLines then

for _, l in ipairs(CrosshairLines) do pcall(function() l:Remove() end) end

end

local targets = {}

pcall(function() if CoreGui then table.insert(targets, CoreGui) end end)

pcall(function() if gethui then table.insert(targets, gethui()) end end)

pcall(function() if LP and LP:FindFirstChild("PlayerGui") then table.insert(targets, LP.PlayerGui) end end)

for _, p in ipairs(targets) do

for _, child in ipairs(p:GetChildren()) do

local lower = string.lower(child.Name)

if string.sub(lower, 1, 4) == "tk4_" or child.Name == "TK4_RespectPVP" or child.Name == "TK4_RespectPVP_Vasper" then

pcall(function() child:Destroy() end)

end

end

end

pcall(function()

if WeaponData and originalWeaponStats then

for name, orig in pairs(originalWeaponStats) do

if WeaponData[name] and WeaponData[name].Fire then

WeaponData[name].Fire.RPM = orig.RPM

WeaponData[name].Fire.Mode = orig.Mode

end

end

end

end)

pcall(function()

if GameSettings then

if GameSettings.Roll then

GameSettings.Roll.Distance = 1.2

GameSettings.Roll.TimeScale = 1.7

end

if GameSettings.Jump then

GameSettings.Jump.Cooldown = 0.3

GameSettings.Jump.CameraDip = 0.6

GameSettings.Jump.HardLanding = 60

end

GameSettings.CrouchSpeed = 12

GameSettings.CrouchStrafeSpeed = 14

GameSettings.CombatTurnSpeed = 28

GameSettings.TurnSpeed = 14

GameSettings.SprintTurnSpeed = 9

GameSettings.ShotRecovery = 0.2

GameSettings.BloomScale = 0.8

end

if ClientState then

ClientState.AimWalkSpeed = 11

ClientState.ShotRecoveryUntil = 0

end

end)

pcall(function()

if State and State.OldLighting then

Lighting.Ambient = State.OldLighting.Ambient

Lighting.Brightness = State.OldLighting.Brightness

Lighting.FogEnd = State.OldLighting.FogEnd

Lighting.FogStart = State.OldLighting.FogStart

Lighting.ClockTime = State.OldLighting.ClockTime

end

end)

pcall(function()

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

if hum and State and State.OriginalWalkSpeed then hum.WalkSpeed = State.OriginalWalkSpeed end

end)

pcall(function()

for pl, hl in pairs(_hlCache) do

pcall(function() hl:Destroy() end)

_hlCache[pl] = nil

end

end)

print("[TK4] Respect PVP God Edition Cleaned Up Completely.")

end

task.spawn(function()

local lastMatchId = nil

while GStore.TK4_SCRIPT_ID == SCRIPT_ID do

pcall(function()

if Config.MatchNotifier and ClientState then

local curMatch = ClientState.Match

if curMatch and type(curMatch) == "table" and curMatch.Id then

if curMatch.Id ~= lastMatchId then

lastMatchId = curMatch.Id

local map = tostring(curMatch.Map or "Arena")

local mode = tostring(curMatch.Mode or "1v1")

local round = tostring(curMatch.Round or 1)

pcall(function()

tk4Notify("MATCH DETECTED", mode .. " on " .. map .. " (Round " .. round .. ")", "info", 4)

end)

end

else

lastMatchId = nil

end

end

end)

task.wait(1)

end

end)

task.spawn(function()

local alertedStaff = {}

local isStaffInServer = false

local preStaffBackup = nil

local STAFF_ROLES = {

[1] = { Text = "MOD",     Color = Color3.fromRGB(64,  170, 205) },

[2] = { Text = "ADMIN",   Color = Color3.fromRGB(138,  52, 255) },

[3] = { Text = "MANAGER", Color = Color3.fromRGB(10,  110, 130) },

[4] = { Text = "DEV",     Color = Color3.fromRGB(0,    70, 230) },

[5] = { Text = "OWNER",   Color = Color3.fromRGB(214, 160,  30) },

}

local CREATOR_ROLE = { Text = "CREATOR", Color = Color3.fromRGB(200, 30, 30) }

local function getStaffRole(pl)

if not pl or pl == LP then return nil end

local level = pl:GetAttribute("AdminLevel") or 0

if STAFF_ROLES[level] then return STAFF_ROLES[level] end

if pl:GetAttribute("ContentCreator") == true then return CREATOR_ROLE end

if pl:GetAttribute("Admin") == true then return STAFF_ROLES[2] end

return nil

end

local function checkStaffStatus(pl)

local role = getStaffRole(pl)

if role then return true, role.Text, role.Color end

return false, nil, nil

end

while GStore.TK4_SCRIPT_ID == SCRIPT_ID do

local currentStaffFound = false

for _, pl in ipairs(Players:GetPlayers()) do

local yes, roleText, roleColor = checkStaffStatus(pl)

if yes then

currentStaffFound = true

State._staffInServer = State._staffInServer or {}

State._staffInServer[pl] = { text = roleText, color = roleColor }

if not alertedStaff[pl] then 

alertedStaff[pl] = true

pcall(function()

tk4Notify("STAFF IN SERVER!", pl.DisplayName .. " [" .. roleText .. "] joined your server!", "staff", 8)

end)

end

else

if State._staffInServer then State._staffInServer[pl] = nil end

end

end

if State._staffInServer then

for pl in pairs(State._staffInServer) do

if not pl.Parent then State._staffInServer[pl] = nil end

end

end

do 

if currentStaffFound and not isStaffInServer then

isStaffInServer = true

preStaffBackup = {

HitChance = Config.HitChance,

HitPart = Config.HitPart,

RapidFire = Config.RapidFire,

HitboxExpander = Config.HitboxExpander

}

Config.HitChance = 75

Config.HitPart = "Closest"

Config.RapidFire = false

Config.HitboxExpander = false

pcall(function()

tk4Notify("AUTO-LEGIT ACTIVE!", "Staff detected! Silent Aim switched to legit mode.", "warn", 6)

end)

elseif not currentStaffFound and isStaffInServer then

isStaffInServer = false

if preStaffBackup then

Config.HitChance = preStaffBackup.HitChance or 100

Config.HitPart = preStaffBackup.HitPart or "Head"

Config.RapidFire = preStaffBackup.RapidFire or false

Config.HitboxExpander = preStaffBackup.HitboxExpander or false

preStaffBackup = nil

end

pcall(function()

tk4Notify("STAFF LEFT SERVER", "Staff left! Normal settings restored.", "ok", 6)

end)

end

end

pcall(function() StaffHUD.refresh() end)

task.wait(0.5)

end

end)

pcall(applyPrefs)

local _gcAccum = 0

regConn(RunService.Heartbeat:Connect(function(dt)

_gcAccum = _gcAccum + dt

if _gcAccum >= 0.16 then

_gcAccum = 0

pcall(collectgarbage, "step", 1)

end

end))

pcall(function()

local queueOnTeleport = (syn and syn.queue_on_teleport)

or queue_on_teleport

or (fluxus and fluxus.queue_on_teleport)

or (getgenv and getgenv().queue_on_teleport)

if type(queueOnTeleport) == "function" then

regConn(LP.OnTeleport:Connect(function(teleState)

local persistLoader = [[

        task.spawn(function()

          local startT = tick()

          repeat task.wait(0.2) until game:IsLoaded() or (tick() - startT > 15)

          -- FIX 4: Try hosted URL first (works when loaded via loadstring/HttpGet),

          -- then fall back to local file paths (works when loaded from file).

          local hostedUrl = "https://raw.githubusercontent.com/acclcwl1-coder/toxicv1/refs/heads/main/FK4_RESPECT_PVPX1.lua"

          local ok = pcall(function()

            loadstring(game:HttpGet(hostedUrl))()

          end)

          if ok then return end

          -- Fallback: local file paths

          local candidatePaths = {

            "work now/TK4_RespectPVP_ work.lua",

            "TK4_RespectPVP_ work.lua",

            "CLAN/work now/TK4_RespectPVP_ work.lua",

            "TK4_RespectPVP.lua",

            "TK4_RespectPVP khdama.lua"

          }

          for _, p in ipairs(candidatePaths) do

            if isfile and isfile(p) then

              pcall(loadstring(readfile(p)))

              return

            end

          end

        end)

      ]]

pcall(queueOnTeleport, persistLoader)

end))

end

end)

print("[TK4] THE KINGS FOUR — Respect PVP God Edition v5 Loaded!")

task.spawn(function()

if not UserInputService.TouchEnabled then return end

task.wait(0.5) 

local mBtn = Instance.new("TextButton")

mBtn.Name = "TK4_MobileMenuBtn"

mBtn.Size = UDim2.new(0, 54, 0, 54)

mBtn.Position = UDim2.new(1, -66, 1, -120)

mBtn.AnchorPoint = Vector2.new(0, 0)

mBtn.BackgroundColor3 = Color3.fromRGB(130, 68, 255)

mBtn.BorderSizePixel = 0

mBtn.Text = "☰"

mBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

mBtn.Font = Enum.Font.GothamBlack

mBtn.TextSize = 24

mBtn.AutoButtonColor = false

mBtn.ZIndex = 200

local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0,14); mc.Parent = mBtn

local ms = Instance.new("UIStroke"); ms.Thickness = 1.5; ms.Color = Color3.fromRGB(180,140,255); ms.Parent = mBtn

mBtn.Parent = ScreenGui

mBtn.MouseButton1Click:Connect(function()

pcall(toggleMenu)

TweenService:Create(mBtn, TweenInfo.new(0.08), { BackgroundColor3 = Color3.fromRGB(90,42,180) }):Play()

task.wait(0.08)

TweenService:Create(mBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(130,68,255) }):Play()

end)

end)

print("[TK4] Silent Aim Hook (WeaponFire) Active! Press [K] to toggle menu.")

