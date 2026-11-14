-- ══════════════════════════════════════════════════════════════════
--  CLAN V3.1 — xx1 features + TK4 working ESP engine
--  Left sidebar navigation (TOXIC SLEEPY style icon rows) replaces top tabs
--  ESP runs on RenderStepped (like TK4) instead of Heartbeat
--  Anti-Head-Kill removed from UI (kept in logic for safety)
--  Mobile + PC supported (ScreenGui fallback when no Drawing API)
-- ══════════════════════════════════════════════════════════════════

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
if not LP then
    repeat task.wait() until Players.LocalPlayer
    LP = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera

if not math.clamp then
    math.clamp = function(v, min, max) return math.max(min, math.min(v, max)) end
end

local GStore = (typeof(getgenv) == "function" and getgenv()) or _G

-- ── Re-execution safety ─────────────────────────────────────────────────
-- Running this file 2x / 100x must always leave EXACTLY ONE menu, one ESP,
-- one hook and one set of connections. No duplicate UI, no dead functions.
local function hardSweep()
    -- 1) restore a __namecall hook left by a previous run
    if GStore.CLAN_RAW_NAMECALL then
        if type(restorefunction) == "function" then
            pcall(restorefunction, GStore.CLAN_RAW_NAMECALL)
        else
            pcall(function() hookmetamethod(game, "__namecall", GStore.CLAN_RAW_NAMECALL) end)
        end
        GStore.CLAN_RAW_NAMECALL = nil
    end
    -- 1b) drop the old camera listener
    if GStore.CLAN_CAM_CONN then
        pcall(function() GStore.CLAN_CAM_CONN:Disconnect() end)
        GStore.CLAN_CAM_CONN = nil
    end
    -- 2) remove leftover drawing objects
    if GStore._CLAN_FOVCircle then
        pcall(function() GStore._CLAN_FOVCircle:Remove() end)
        GStore._CLAN_FOVCircle = nil
    end
    if GStore._CLAN_DRAWINGS then
        for _, obj in ipairs(GStore._CLAN_DRAWINGS) do
            pcall(function() obj:Remove() end)
        end
    end
    GStore._CLAN_DRAWINGS = {}
    GStore._CLAN_ESPGui = nil
    -- 3) destroy leftover GUIs in every possible container
    local containers = { CoreGui }
    pcall(function()
        local pg = LP and LP:FindFirstChildOfClass("PlayerGui")
        if pg then containers[#containers + 1] = pg end
    end)
    for _, parent in ipairs(containers) do
        if parent then
            for _, guiName in ipairs({ "CLAN_V3_GUI", "CLAN_ESP_Overlays" }) do
                local ok, old = pcall(function() return parent:FindFirstChild(guiName) end)
                if ok and old then pcall(function() old:Destroy() end) end
            end
        end
    end
    -- 1c) STARTUP SAFETY: always clean leftover TK4_CamSink from a prior session
    -- and restore the camera + mouse to the game's own state before starting again
    pcall(function()
        ContextActionService:UnbindAction("TK4_CamSink")
        ContextActionService:UnbindAction("TK4_CamSink_v2")
        ContextActionService:UnbindAction("TK4_CamSink_old")
    end)
    if GStore._TK4_MouseConn then
        pcall(function() GStore._TK4_MouseConn:Disconnect() end)
        GStore._TK4_MouseConn = nil
    end
    pcall(function() Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
    pcall(function()
        UserInputService.MouseBehavior    = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
end

if GStore.CLAN_RESPECT_CLEANUP then
    pcall(GStore.CLAN_RESPECT_CLEANUP)
    GStore.CLAN_RESPECT_CLEANUP = nil
end
hardSweep()
-- provisional cleanup: protects against a crash *during* this load
GStore.CLAN_RESPECT_CLEANUP = hardSweep

local SCRIPT_ID = HttpService:GenerateGUID(false)
GStore.CLAN_SCRIPT_ID = SCRIPT_ID

-- camera listener (managed so re-execution never stacks listeners)
GStore.CLAN_CAM_CONN = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

-- ── Colors ──────────────────────────────────────────────────────
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
    Name    = "CLAN",
    Full    = "CLAN V3",
    Motto   = "Unity - Respect - Power - Loyalty",
    LogoId  = "rbxassetid://102293188968456",
}

-- ── Config ───────────────────────────────────────────────────────
local Config = {
    -- AIM
    SilentAim          = true,
    HeadRatio          = 20,
    FOVRadius          = 220,
    DrawFOV            = false,
    WallCheck          = true,
    TeamCheck          = true,
    SkipDeflect        = true,
    SkipImmune         = true,
    NoRecoil           = true,
    NoBloom            = true,

    -- ESP (use TK4 key names where they differ)
    ESP_Master         = true,
    ESP_Box            = true,
    ESP_BoxStyle       = "Corner",
    ESP_Health         = true,
    ESP_Names          = true,
    ESP_Distance       = true,
    ESP_Tracers        = false,
    ESP_MaxDistance    = 600,
    ESP_TextSize       = 13,
    ESP_TeamCheck      = true,   -- TK4 key name (same function)
    ESP_Roles          = true,   -- staff/admin role tag + colors (from fk4v11)
    ESP_Skeleton       = true,   -- R15 bone lines (PC only, <220 studs)
    ESP_Head           = true,   -- head circle dot
    ESP_HealthNum      = false,  -- HP number next to health bar
    ESP_Level          = true,   -- Lv.X next to player name
    ESP_Rank           = true,   -- rank name (GOLD II etc) with official color
    ESP_FiringAlert    = true,   -- [FIRING] tag when enemy is shooting
    ESP_Alerts         = true,   -- [PROTECTED] / [HEALING] / [ARMORING] status tags
    -- custom colors (TK4 style)
    esp_col_box_r=130, esp_col_box_g=68,  esp_col_box_b=255,
    esp_col_name_r=255,esp_col_name_g=255,esp_col_name_b=255,
    esp_col_dist_r=180,esp_col_dist_g=170,esp_col_dist_b=200,
    esp_col_tracer_r=130,esp_col_tracer_g=68,esp_col_tracer_b=255,
    esp_col_head_r=130,esp_col_head_g=68, esp_col_head_b=255,

    -- MOVE
    SpeedBoost         = false,
    SpeedValue         = 40,
    AutoSprint         = true,
    InfiniteStamina    = true,
    InfiniteJump       = false,

    -- MISC
    MenuKey            = Enum.KeyCode.K,
    GuiVisible         = false,
    AutoSaveConfig     = true
}

-- ── State ────────────────────────────────────────────────────────
local State = {
    Connections     = {},
    ESPCache        = {},
    ActiveTarget    = nil,
    TargetPart      = nil,
    TargetHP        = 100,
    TargetDist      = 0,
    EquippedWeapon  = "AK",
}

local function regConn(conn)
    if conn then table.insert(State.Connections, conn) end
    return conn
end

-- ── Game modules (optional) ──────────────────────────────────────
local WeaponData, ClientState, GameSettings = nil, nil, nil
task.spawn(function()
    pcall(function() WeaponData  = require(ReplicatedStorage.Shared.Config.WeaponData) end)
    pcall(function() ClientState = require(ReplicatedStorage.Client.ClientState) end)
    pcall(function() GameSettings = require(ReplicatedStorage.Shared.Config.Settings) end)
end)

-- ── Weapon data ──────────────────────────────────────────────────
local WEAPON_DATA_LOOKUP = {
    ["AK"]     = { base=12,  head=3.2,  limb=0.85, fStart=100, fEnd=320, minS=0.8, range=700 },
    ["AR"]     = { base=11,  head=2.75, limb=0.85, fStart=100, fEnd=320, minS=0.8, range=700 },
    ["AW50"]   = { base=100, head=1.5,  limb=0.7,  fStart=700, fEnd=700, minS=1.0, range=700 },
    ["Kar98k"] = { base=70,  head=1.5,  limb=0.8,  fStart=700, fEnd=700, minS=1.0, range=700 },
    ["1911"]   = { base=22,  head=2.7,  limb=0.8,  fStart=35,  fEnd=130, minS=0.6, range=700 },
    ["Glock"]  = { base=17,  head=2.2,  limb=0.8,  fStart=30,  fEnd=120, minS=0.6, range=700 },
    ["RPG"]    = { base=150, head=1.0,  limb=1.0,  fStart=600, fEnd=600, minS=1.0, range=600 },
}
local cachedWeaponKey, cachedWeaponStats = nil, nil

local function getEquippedWeaponStats()
    local name = "AK"
    if LP.Character then
        local tool = LP.Character:FindFirstChildOfClass("Tool")
        if tool then
            for k in pairs(WEAPON_DATA_LOOKUP) do
                if tool.Name:lower():find(k:lower()) then name = k; break end
            end
        end
    end
    if cachedWeaponKey == name and cachedWeaponStats then return name, cachedWeaponStats end
    local stats = WEAPON_DATA_LOOKUP[name] or WEAPON_DATA_LOOKUP["AK"]
    local fromData = false
    if WeaponData and WeaponData[name] and WeaponData[name].Damage then
        local d = WeaponData[name].Damage
        stats = { base=d.Base or stats.base, head=d.Headshot or stats.head, limb=d.Limb or stats.limb,
                  fStart=d.FalloffStart or stats.fStart, fEnd=d.FalloffEnd or stats.fEnd,
                  minS=d.MinScale or stats.minS, range=d.Range or stats.range }
        fromData = true
    end
    if fromData then cachedWeaponKey = name; cachedWeaponStats = stats end
    return name, stats
end

-- ── Helpers ──────────────────────────────────────────────────────
local function getBodyParts(char)
    local parts = {}
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Head" then
            table.insert(parts, child)
        end
    end
    return parts
end

local function pickSmartPart(char, hum, dist)
    if not hum or hum.Health <= 0 then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    end
    local roll = math.random(1, 100)
    if roll <= (Config.HeadRatio or 20) then
        local h = char:FindFirstChild("Head")
        if h then return h end
    end
    local limbs = getBodyParts(char)
    if #limbs > 0 then return limbs[math.random(1, #limbs)] end
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
RayParams.IgnoreWater = true

local function isTeammate(plr)
    if not plr or plr == LP then return true end
    if LP.Team ~= nil and plr.Team ~= nil then return LP.Team == plr.Team end
    local a1, a2 = LP:GetAttribute("Team"), plr:GetAttribute("Team")
    if a1 and a2 and tostring(a1) ~= "" then return tostring(a1) == tostring(a2) end
    return false
end

local function isDeflecting(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, trk in ipairs(hum:GetPlayingAnimationTracks()) do
            local n = trk.Animation and trk.Animation.Name:lower() or ""
            if n:find("deflect") or n:find("parry") or n:find("block") then return true end
        end
    end
    return false
end

local function isImmune(plr)
    if not plr or not plr.Character then return false end
    if plr.Character:FindFirstChildOfClass("ForceField") then return true end
    local prot = plr.Character:GetAttribute("ProtectedUntil")
    if typeof(prot) == "number" and (prot - workspace:GetServerTimeNow()) > 0 then return true end
    for _, attr in ipairs({"IsInvincible","Immune","IsImmune","SpawnProtection"}) do
        if plr.Character:GetAttribute(attr) == true then return true end
    end
    return false
end

local function isVisible(fromPos, toPos, char)
    if not Config.WallCheck then return true end
    RayParams.FilterDescendantsInstances = { Camera, LP.Character, char }
    return Workspace:Raycast(fromPos, toPos - fromPos, RayParams) == nil
end

local function scanBestTarget()
    if not Config.SilentAim then State.ActiveTarget = nil; State.TargetPart = nil; return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local camPos = Camera.CFrame.Position
    local best, bestChar, bestDist, bestDd = Config.FOVRadius, nil, nil, 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and (not Config.TeamCheck or not isTeammate(p)) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0
               and not (Config.SkipDeflect and isDeflecting(p))
               and not (Config.SkipImmune and isImmune(p)) then
                local sPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen and sPos.Z > 0 then
                    local sd = (Vector2.new(sPos.X, sPos.Y) - center).Magnitude
                    if sd <= best and isVisible(camPos, hrp.Position, p.Character) then
                        best = sd; bestChar = p.Character; bestDist = p; bestDd = (hrp.Position - camPos).Magnitude
                    end
                end
            end
        end
    end
    if bestChar and bestDist then
        local hum = bestChar:FindFirstChildOfClass("Humanoid")
        State.ActiveTarget = bestDist
        State.TargetHP     = hum.Health
        State.TargetDist   = bestDd
        State.TargetPart   = pickSmartPart(bestChar, hum, bestDd)
    else
        State.ActiveTarget = nil; State.TargetPart = nil
    end
end

-- ── Namecall hook ────────────────────────────────────────────────
if hookmetamethod then
    local rawNamecall
    rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and typeof(self) == "Instance" and self.Name == "WeaponFire"
           and not (checkcaller and checkcaller()) then
            if Config.SilentAim and State.TargetPart and State.TargetPart.Parent then
                local args = { ... }
                local n = select("#", ...)
                local origin = args[1]
                local targetPart = State.TargetPart
                local targetPos  = targetPart.Position

                if typeof(origin) == "Vector3" then
                    local dir = (targetPos - origin)
                    args[2] = dir.Unit; args[3] = targetPart; args[4] = targetPos
                    args[5] = -dir.Unit
                    if args[7] then args[7] = dir.Unit end
                    if args[8] then args[8] = 0 end
                else
                    args[3] = targetPart; args[4] = targetPos; args[5] = Vector3.new(0,1,0)
                end
                return rawNamecall(self, table.unpack(args, 1, n))
            end
        end
        return rawNamecall(self, ...)
    end))
    GStore.CLAN_RAW_NAMECALL = rawNamecall
end

-- ── Rank color table (from TK4 / RespectPVP_Player_Roles_And_Levels_Guide) ──
local RESPECT_RANKS = {
    ["Unranked"]  = { Color = Color3.fromRGB(120, 126, 140) },
    ["Bronze"]    = { Color = Color3.fromRGB(205, 127,  50) },
    ["Silver"]    = { Color = Color3.fromRGB(192, 198, 210) },
    ["Gold"]      = { Color = Color3.fromRGB(255, 200,  60) },
    ["Platinum"]  = { Color = Color3.fromRGB( 80, 220, 200) },
    ["Diamond"]   = { Color = Color3.fromRGB( 90, 170, 255) },
    ["Master"]    = { Color = Color3.fromRGB(170,  90, 255) },
    ["Champion"]  = { Color = Color3.fromRGB(255,  80, 110) },
}
local function getRankInfo(rankName)
    if not rankName or rankName == "" then return RESPECT_RANKS["Unranked"] end
    local u = string.upper(tostring(rankName))
    if string.find(u,"CHAMPION") then return RESPECT_RANKS["Champion"]
    elseif string.find(u,"MASTER")   then return RESPECT_RANKS["Master"]
    elseif string.find(u,"DIAMOND")  then return RESPECT_RANKS["Diamond"]
    elseif string.find(u,"PLATINUM") then return RESPECT_RANKS["Platinum"]
    elseif string.find(u,"GOLD")     then return RESPECT_RANKS["Gold"]
    elseif string.find(u,"SILVER")   then return RESPECT_RANKS["Silver"]
    elseif string.find(u,"BRONZE")   then return RESPECT_RANKS["Bronze"]
    end
    return RESPECT_RANKS["Unranked"]
end

-- ══════════════════════════════════════════════════════════════════
--  ESP SYSTEM — TK4 engine (RenderStepped, mobile + PC)
-- ══════════════════════════════════════════════════════════════════

local function safeParentGui(gui)
    local ok = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    pcall(function() gui.Parent = CoreGui; ok = true end)
    if not ok then pcall(function() if gethui then gui.Parent = gethui(); ok = true end end) end
    if not ok then pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end) end
end

local HasDrawing = pcall(function() return Drawing ~= nil and Drawing.new ~= nil end) and Drawing ~= nil
local MOBILE_MODE = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) or (not HasDrawing)

local FOVCircle = nil
if HasDrawing then
    pcall(function()
        if GStore._CLAN_FOVCircle then GStore._CLAN_FOVCircle:Remove() end
        GStore._CLAN_FOVCircle = nil
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
        GStore._CLAN_FOVCircle = FOVCircle
    end)
end

local R15_BONES = {
    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},  {"LeftUpperArm","LeftLowerArm"},  {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},  {"LeftUpperLeg","LeftLowerLeg"},  {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

local ESPGui
if GStore._CLAN_ESPGui and GStore._CLAN_ESPGui.Parent then
    ESPGui = GStore._CLAN_ESPGui
else
    ESPGui = Instance.new("ScreenGui")
    ESPGui.Name = "CLAN_ESP_Overlays"
    ESPGui.ResetOnSpawn = false
    ESPGui.IgnoreGuiInset = true
    ESPGui.DisplayOrder = 150
    safeParentGui(ESPGui)
    GStore._CLAN_ESPGui = ESPGui
end
for _, ch in ipairs(ESPGui:GetChildren()) do pcall(function() ch:Destroy() end) end

local function getESPColor(key, defaultCol)
    local r = Config["esp_col_"..key.."_r"]
    local g = Config["esp_col_"..key.."_g"]
    local b = Config["esp_col_"..key.."_b"]
    if r and g and b then
        return Color3.fromRGB(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255))
    end
    return defaultCol or C.accent
end

-- ══ ESP Roles (taken from fk4v11_ORIGINAL_BACKUP) ══
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
    local level = 0
    pcall(function() level = tonumber(pl:GetAttribute("AdminLevel")) or 0 end)
    if STAFF_ROLES[level] then return STAFF_ROLES[level] end
    local isCreator = false
    pcall(function() isCreator = (pl:GetAttribute("ContentCreator") == true) end)
    if isCreator then return CREATOR_ROLE end
    local isAdmin = false
    pcall(function() isAdmin = (pl:GetAttribute("Admin") == true) end)
    if isAdmin then return STAFF_ROLES[2] end
    return nil
end

local function newDrawObj(class, props)
    local obj = Drawing.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    local reg = GStore._CLAN_DRAWINGS
    if reg then reg[#reg + 1] = obj end
    return obj
end

local function createESP(player)
    local esp = {}
    if HasDrawing and not MOBILE_MODE then
        esp.box      = {newDrawObj("Line",{}),newDrawObj("Line",{}),newDrawObj("Line",{}),newDrawObj("Line",{})}
        esp.corners  = {}
        esp.name     = newDrawObj("Text", {Center=true,  Outline=true, Size=Config.ESP_TextSize, Font=2})
        esp.rank     = newDrawObj("Text", {Center=false, Outline=true, Size=13, Font=2})
        esp.level    = newDrawObj("Text", {Center=false, Outline=true, Size=15, Font=2})
        esp.dist     = newDrawObj("Text", {Center=true,  Outline=true, Size=Config.ESP_TextSize, Font=2})
        esp.head     = newDrawObj("Circle", {NumSides=24, Thickness=1.5, Filled=false})
        esp.health   = newDrawObj("Line", {Thickness=2.5})
        esp.healthBg = newDrawObj("Line", {Thickness=2.5, Color=Color3.fromRGB(30,20,38)})
        esp.head     = newDrawObj("Circle", {NumSides=24, Thickness=1.5, Filled=false})
        esp.bones    = {}
        esp.tracers  = newDrawObj("Line", {Thickness=1.2})
        for i=1,8 do esp.corners[i] = newDrawObj("Line", {Thickness=2}) end
        for i=1,#R15_BONES do esp.bones[i] = newDrawObj("Line", {Thickness=1.4}) end
    end

    if MOBILE_MODE then
        local root = Instance.new("Frame")
        root.Name = "MESP_"..tostring(player.Name or "X")
        root.BackgroundTransparency = 1
        root.BorderSizePixel = 0
        root.Visible = false
        root.Parent = ESPGui
        esp.mRoot = root

        local box = Instance.new("Frame")
        box.Name = "Box"
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.Visible = false
        box.Parent = root
        local bStroke = Instance.new("UIStroke")
        bStroke.Thickness = 1.5
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        bStroke.Parent = box
        esp.mBox = box

        esp.mCorners = {}
        for i=1,8 do
            local f = Instance.new("Frame")
            f.Name = "MC"..i
            f.BorderSizePixel = 0
            f.BackgroundColor3 = Color3.new(1,1,1)
            f.Visible = false
            f.Parent = root
            esp.mCorners[i] = f
        end

        local function mLbl(n, sz)
            local l = Instance.new("TextLabel")
            l.Name = n
            l.BackgroundTransparency = 1
            l.BorderSizePixel = 0
            l.Font = Enum.Font.GothamBold
            l.TextSize = sz
            l.TextStrokeTransparency = 0.35
            l.TextColor3 = Color3.new(1,1,1)
            l.ZIndex = 20
            l.Visible = false
            l.Parent = root
            return l
        end

        esp.mLevel = mLbl("Level", 15)
        esp.mLevel.AnchorPoint = Vector2.new(0, 0.5)
        esp.mLevel.Size = UDim2.fromOffset(80, 16)
        esp.mRank  = mLbl("Rank",  13)
        esp.mRank.AnchorPoint = Vector2.new(0, 0.5)
        esp.mRank.Size = UDim2.fromOffset(120, 16)
        esp.mName = mLbl("Name", Config.ESP_TextSize or 13)
        esp.mName.AnchorPoint = Vector2.new(0.5, 1)
        esp.mName.Size = UDim2.fromOffset(240, 16)

        esp.mDist = mLbl("Dist", Config.ESP_TextSize or 13)
        esp.mDist.AnchorPoint = Vector2.new(0.5, 0)
        esp.mDist.Size = UDim2.fromOffset(120, 14)

        local hpBg = Instance.new("Frame")
        hpBg.Name = "HpBg"
        hpBg.BorderSizePixel = 0
        hpBg.BackgroundColor3 = Color3.fromRGB(30,20,38)
        hpBg.BackgroundTransparency = 0.25
        hpBg.Visible = false
        hpBg.Parent = root
        esp.mHpBg = hpBg

        local hpF = Instance.new("Frame")
        hpF.Name = "Hp"
        hpF.BorderSizePixel = 0
        hpF.BackgroundColor3 = Color3.new(0,1,0)
        hpF.Visible = false
        hpF.Parent = root
        esp.mHp = hpF
    end

    return esp
end

local function hideESP(esp)
    if not esp then return end
    if esp.box then
        for _,l in ipairs(esp.box) do l.Visible = false end
        for _,l in ipairs(esp.corners) do l.Visible = false end
        if esp.name    then esp.name.Visible    = false end
        if esp.dist    then esp.dist.Visible    = false end
        if esp.health  then esp.health.Visible  = false end
        if esp.healthBg then esp.healthBg.Visible = false end
        if esp.head    then esp.head.Visible    = false end
        if esp.tracers then esp.tracers.Visible = false end
        if esp.rank    then esp.rank.Visible    = false end
        if esp.level   then esp.level.Visible   = false end
        if esp.head    then esp.head.Visible     = false end
        if esp.mLevel  then esp.mLevel.Visible   = false end
        if esp.mRank   then esp.mRank.Visible    = false end
        if esp.bones   then for _,b in ipairs(esp.bones) do b.Visible=false end end
    end
    if esp.mRoot then esp.mRoot.Visible = false end
end

local function destroyESP(esp)
    if not esp then return end
    if esp.box then
        for _,l in ipairs(esp.box) do pcall(function() l:Remove() end) end
        for _,l in ipairs(esp.corners) do pcall(function() l:Remove() end) end
        if esp.name     then pcall(function() esp.name:Remove() end) end
        if esp.dist     then pcall(function() esp.dist:Remove() end) end
        if esp.health   then pcall(function() esp.health:Remove() end) end
        if esp.healthBg then pcall(function() esp.healthBg:Remove() end) end
        if esp.head     then pcall(function() esp.head:Remove() end) end
        if esp.tracers then pcall(function() esp.tracers:Remove() end) end
        if esp.rank    then pcall(function() esp.rank:Remove()    end) end
        if esp.level   then pcall(function() esp.level:Remove()   end) end
        if esp.head    then pcall(function() esp.head:Remove()    end) end
        if esp.bones    then for _,b in ipairs(esp.bones) do pcall(function() b:Remove() end) end end
    end
    if esp.mRoot then pcall(function() esp.mRoot:Destroy() end) end
end

local function updateESP(player, esp)
    -- KEY FIX: hide when menu open (same as TK4)
    if Config.GuiVisible then hideESP(esp); return end
    if not Config.ESP_Master or not esp then hideESP(esp); return end
    if player == LP or (Config.ESP_TeamCheck and isTeammate(player)) then hideESP(esp); return end

    local char = player.Character
    if not char then hideESP(esp); return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not hum or hum.Health <= 0 or not hrp then hideESP(esp); return end

    local camPos = Camera.CFrame.Position
    local dist3d = (hrp.Position - camPos).Magnitude
    if dist3d > Config.ESP_MaxDistance then hideESP(esp); return end

    local topWorld = ((head and head.Position) or (hrp.Position + Vector3.new(0,1.5,0))) + Vector3.new(0,0.7,0)
    local botWorld = hrp.Position - Vector3.new(0,3.0,0)
    local sTop, onTop = Camera:WorldToViewportPoint(topWorld)
    local sBot, onBot = Camera:WorldToViewportPoint(botWorld)

    if sTop.Z <= 0 or sBot.Z <= 0 or (not onTop and not onBot) then hideESP(esp); return end

    local boxH = math.abs(sBot.Y - sTop.Y)
    if boxH < 3 or boxH > 4000 then hideESP(esp); return end

    local boxW  = math.floor(boxH * 0.58)
    local midX  = math.floor((sTop.X + sBot.X) * 0.5)
    local topY  = math.floor(math.min(sTop.Y, sBot.Y))
    local botY  = topY + boxH
    local leftX = math.floor(midX - (boxW * 0.5))
    local rightX = leftX + boxW

    local hpRatio = math.clamp(hum.Health / (hum.MaxHealth > 0 and hum.MaxHealth or 100), 0, 1)
    local hpColor = Color3.fromRGB(math.floor(255*(1-hpRatio)), math.floor(255*hpRatio), 50)
    local customBoxCol  = getESPColor("box",  C.accent)
    local customDistCol = getESPColor("dist", Color3.fromRGB(180,170,200))

    -- staff / admin role (fk4v11 style: tag + role color on box & name)
    local staffRole = Config.ESP_Roles and getStaffRole(player) or nil
    local roleTag   = staffRole and (" ["..staffRole.Text.."]") or ""
    local boxCol    = staffRole and staffRole.Color or customBoxCol
    local nameCol   = staffRole and staffRole.Color or Color3.new(1,1,1)

    -- Level / Rank from player attributes
    local plLevel  = pcall(function() return player:GetAttribute("Level") end) and player:GetAttribute("Level") or nil
    local plRank   = pcall(function() return player:GetAttribute("RankName") end) and player:GetAttribute("RankName") or nil
    local rankInfo = getRankInfo(plRank)
    local rankColor = rankInfo.Color

    -- FiringAlert: check ClientState.ShotTimes if available
    local isFiring = false
    pcall(function()
        if Config.ESP_FiringAlert and ClientState and ClientState.ShotTimes then
            local lastShot = ClientState.ShotTimes[char]
            if type(lastShot) == "number" and (os.clock() - lastShot) < 0.35 then
                isFiring = true
            end
        end
    end)

    -- ═══ MOBILE RENDERER ═══
    if MOBILE_MODE then
        local r = esp.mRoot
        if not r then hideESP(esp); return end
        r.Visible = true
        r.Position = UDim2.fromOffset(leftX, topY)
        r.Size = UDim2.fromOffset(boxW, boxH)

        if Config.ESP_Box then
            if Config.ESP_BoxStyle == "Corner" then
                esp.mBox.Visible = false
                local cl = math.max(4, math.floor(boxW*0.25))
                local ct = math.max(4, math.floor(boxH*0.25))
                local mc = esp.mCorners
                mc[1].Position=UDim2.fromOffset(0,0);              mc[1].Size=UDim2.fromOffset(cl,2)
                mc[2].Position=UDim2.fromOffset(0,0);              mc[2].Size=UDim2.fromOffset(2,ct)
                mc[3].Position=UDim2.fromOffset(boxW-cl,0);        mc[3].Size=UDim2.fromOffset(cl,2)
                mc[4].Position=UDim2.fromOffset(boxW-2,0);         mc[4].Size=UDim2.fromOffset(2,ct)
                mc[5].Position=UDim2.fromOffset(0,boxH-2);         mc[5].Size=UDim2.fromOffset(cl,2)
                mc[6].Position=UDim2.fromOffset(0,boxH-ct);        mc[6].Size=UDim2.fromOffset(2,ct)
                mc[7].Position=UDim2.fromOffset(boxW-cl,boxH-2);   mc[7].Size=UDim2.fromOffset(cl,2)
                mc[8].Position=UDim2.fromOffset(boxW-2,boxH-ct);   mc[8].Size=UDim2.fromOffset(2,ct)
                for i=1,8 do mc[i].BackgroundColor3=boxCol; mc[i].Visible=true end
            else
                for _,f in ipairs(esp.mCorners) do f.Visible=false end
                esp.mBox.Position=UDim2.fromOffset(0,0)
                esp.mBox.Size=UDim2.fromOffset(boxW,boxH)
                local st = esp.mBox:FindFirstChildOfClass("UIStroke")
                if st then st.Color=boxCol end
                esp.mBox.Visible=true
            end
        else
            esp.mBox.Visible=false
            for _,f in ipairs(esp.mCorners) do f.Visible=false end
        end

        if Config.ESP_Names then
            local nTxt   = (player.DisplayName or player.Name)..roleTag
            local nCol   = nameCol
            local glowCol = nil
            if Config.ESP_Alerts and char then
                local now = workspace:GetServerTimeNow()
                local prot = char:GetAttribute("ProtectedUntil")
                local band = char:GetAttribute("BandageEnds")
                local arm  = char:GetAttribute("ArmorEnds")
                if typeof(prot)=="number" and (prot-now)>0 then
                    nTxt = nTxt.." [PROTECTED]"
                    nCol = Color3.fromRGB(80,140,255)   -- blue
                    glowCol = Color3.fromRGB(0,100,255)
                    boxCol = Color3.fromRGB(0,80,255)   -- box blue
                elseif typeof(band)=="number" and (band-now)>0 then
                    nTxt = nTxt.." [HEALING]"
                    nCol = Color3.fromRGB(80,255,120)   -- green
                    glowCol = Color3.fromRGB(0,200,80)
                    boxCol = Color3.fromRGB(0,200,80)   -- box green
                elseif typeof(arm)=="number" and (arm-now)>0 then
                    nTxt = nTxt.." [ARMORING]"
                    nCol = Color3.fromRGB(160,160,160)  -- grey text
                    glowCol = Color3.fromRGB(20,20,20)
                    boxCol = Color3.fromRGB(15,15,15)   -- box black
                end
            end
            if isFiring then
                nTxt = nTxt.." [FIRING]"
                nCol = Color3.fromRGB(255,50,50)        -- red
                glowCol = Color3.fromRGB(220,0,0)
                boxCol = Color3.fromRGB(220,0,0)        -- box red
            end
            esp.mName.Text = nTxt
            esp.mName.TextColor3 = nCol
            -- mobile glow: TextStrokeColor3 = colored shadow = shimmer, no background
            esp.mName.TextStrokeTransparency = glowCol and 0.0 or 0.65
            esp.mName.TextStrokeColor3 = glowCol or Color3.fromRGB(0,0,0)
            esp.mName.Position = UDim2.fromOffset(math.floor(boxW*0.5), -2)
            esp.mName.Visible = true
        else esp.mName.Visible=false end

        -- Level + Rank (mobile)
        local showLv = Config.ESP_Level and plLevel ~= nil
        local showRk = Config.ESP_Rank and plRank and plRank ~= ""
        local headerY = -(Config.ESP_Names and 34 or 18)
        if showLv and esp.mLevel then
            esp.mLevel.Text = "Lv."..tostring(plLevel)
            esp.mLevel.TextColor3 = Color3.fromRGB(255,235,120)
            esp.mLevel.Position = UDim2.fromOffset(math.floor(boxW*0.5)-40, headerY)
            esp.mLevel.Visible = true
        elseif esp.mLevel then esp.mLevel.Visible=false end
        if showRk and esp.mRank then
            esp.mRank.Text = tostring(plRank)
            esp.mRank.TextColor3 = rankColor
            esp.mRank.Position = UDim2.fromOffset(math.floor(boxW*0.5)+(showLv and 20 or -30), headerY)
            esp.mRank.Visible = true
        elseif esp.mRank then esp.mRank.Visible=false end

        if Config.ESP_Distance then
            esp.mDist.Text = math.floor(dist3d).."m"
            esp.mDist.TextColor3 = customDistCol
            esp.mDist.Position = UDim2.fromOffset(math.floor(boxW*0.5), boxH+2)
            esp.mDist.Visible = true
        else esp.mDist.Visible=false end

        if Config.ESP_Health then
            esp.mHpBg.Position=UDim2.fromOffset(-7,0); esp.mHpBg.Size=UDim2.fromOffset(3,boxH); esp.mHpBg.Visible=true
            esp.mHp.Position=UDim2.fromOffset(-7,math.floor(boxH*(1-hpRatio)))
            esp.mHp.Size=UDim2.fromOffset(3,math.max(1,math.floor(boxH*hpRatio)))
            esp.mHp.BackgroundColor3=hpColor; esp.mHp.Visible=true
        else esp.mHp.Visible=false; esp.mHpBg.Visible=false end
        return
    end
    -- ═══ END MOBILE RENDERER ═══

    -- ═══ PC Drawing ESP ═══
    if Config.ESP_Box then
        if Config.ESP_BoxStyle == "Corner" then
            for _,l in ipairs(esp.box) do l.Visible=false end
            local cl=math.floor(boxW*0.25); local ct=math.floor(boxH*0.25)
            esp.corners[1].From=Vector2.new(leftX,topY);  esp.corners[1].To=Vector2.new(leftX+cl,topY)
            esp.corners[2].From=Vector2.new(leftX,topY);  esp.corners[2].To=Vector2.new(leftX,topY+ct)
            esp.corners[3].From=Vector2.new(rightX,topY); esp.corners[3].To=Vector2.new(rightX-cl,topY)
            esp.corners[4].From=Vector2.new(rightX,topY); esp.corners[4].To=Vector2.new(rightX,topY+ct)
            esp.corners[5].From=Vector2.new(leftX,botY);  esp.corners[5].To=Vector2.new(leftX+cl,botY)
            esp.corners[6].From=Vector2.new(leftX,botY);  esp.corners[6].To=Vector2.new(leftX,botY-ct)
            esp.corners[7].From=Vector2.new(rightX,botY); esp.corners[7].To=Vector2.new(rightX-cl,botY)
            esp.corners[8].From=Vector2.new(rightX,botY); esp.corners[8].To=Vector2.new(rightX,botY-ct)
            for i=1,8 do esp.corners[i].Color=boxCol; esp.corners[i].Visible=true end
        else
            for _,l in ipairs(esp.corners) do l.Visible=false end
            esp.box[1].From=Vector2.new(leftX,topY);  esp.box[1].To=Vector2.new(rightX,topY)
            esp.box[2].From=Vector2.new(rightX,topY); esp.box[2].To=Vector2.new(rightX,botY)
            esp.box[3].From=Vector2.new(rightX,botY); esp.box[3].To=Vector2.new(leftX,botY)
            esp.box[4].From=Vector2.new(leftX,botY);  esp.box[4].To=Vector2.new(leftX,topY)
            for i=1,4 do esp.box[i].Color=boxCol; esp.box[i].Visible=true end
        end
    else
        for _,l in ipairs(esp.box) do l.Visible=false end
        for _,l in ipairs(esp.corners) do l.Visible=false end
    end

    if Config.ESP_Names then
        local nTxt = (player.DisplayName or player.Name)..roleTag
        local nCol = nameCol
        local glowCol = nil  -- outline glow color for status shimmer
        if Config.ESP_Alerts and char then
            local now = workspace:GetServerTimeNow()
            local prot = char:GetAttribute("ProtectedUntil")
            local band = char:GetAttribute("BandageEnds")
            local arm  = char:GetAttribute("ArmorEnds")
            if typeof(prot)=="number" and (prot-now)>0 then
                nTxt = nTxt.." [PROTECTED]"
                nCol = Color3.fromRGB(80,140,255)      -- blue
                glowCol = Color3.fromRGB(0,100,255)
                boxCol = Color3.fromRGB(0,80,255)      -- box blue
            elseif typeof(band)=="number" and (band-now)>0 then
                nTxt = nTxt.." [HEALING]"
                nCol = Color3.fromRGB(80,255,120)      -- green
                glowCol = Color3.fromRGB(0,200,80)
                boxCol = Color3.fromRGB(0,200,80)      -- box green
            elseif typeof(arm)=="number" and (arm-now)>0 then
                nTxt = nTxt.." [ARMORING]"
                nCol = Color3.fromRGB(160,160,160)     -- grey text
                glowCol = Color3.fromRGB(20,20,20)
                boxCol = Color3.fromRGB(15,15,15)      -- box black
            end
        end
        if isFiring then
            nTxt = nTxt.." [FIRING]"
            nCol = Color3.fromRGB(255,50,50)           -- red
            glowCol = Color3.fromRGB(220,0,0)
            boxCol = Color3.fromRGB(220,0,0)           -- box red
        end
        esp.name.Text = nTxt
        esp.name.Position = Vector2.new(midX, topY-14)
        esp.name.Color = nCol
        -- shimmer: set outline color to glow color, outline=true already set at creation
        if esp.name.Outline ~= nil then
            esp.name.Outline = true
            if glowCol then
                -- Drawing outline = thick colored shadow = glow/shimmer effect, no bg needed
                pcall(function() esp.name.OutlineColor = glowCol end)
            else
                pcall(function() esp.name.OutlineColor = Color3.fromRGB(0,0,0) end)
            end
        end
        esp.name.Visible = true
    else esp.name.Visible=false end

    -- Level + Rank (PC Drawing)
    local showLv = Config.ESP_Level and plLevel ~= nil
    local showRk = Config.ESP_Rank  and plRank  and plRank ~= ""
    if showLv or showRk then
        local headerY = topY - (Config.ESP_Names and 32 or 16)
        local lvStr  = showLv and ("Lv."..tostring(plLevel)) or ""
        local rkStr  = showRk and tostring(plRank) or ""
        local lvW    = showLv and (#lvStr * 8.5) or 0
        local rkW    = showRk and (#rkStr * 7.2) or 0
        local gap    = 5
        local totalW = lvW + (lvW > 0 and gap or 0) + rkW
        local curX   = midX - math.floor(totalW * 0.5)
        if showLv and esp.level then
            esp.level.Text     = lvStr
            esp.level.Size     = 15
            esp.level.Color    = Color3.fromRGB(255,235,120)
            esp.level.Position = Vector2.new(math.floor(curX), math.floor(headerY))
            esp.level.Visible  = true
            curX = curX + lvW + gap
        elseif esp.level then esp.level.Visible = false end
        if showRk and esp.rank then
            esp.rank.Text     = rkStr
            esp.rank.Size     = 13
            esp.rank.Color    = rankColor
            esp.rank.Position = Vector2.new(math.floor(curX), math.floor(headerY+1))
            esp.rank.Visible  = true
        elseif esp.rank then esp.rank.Visible = false end
    else
        if esp.level then esp.level.Visible = false end
        if esp.rank  then esp.rank.Visible  = false end
    end

    if Config.ESP_Distance then
        esp.dist.Text = math.floor(dist3d).."m"
        esp.dist.Position = Vector2.new(midX, botY+2)
        esp.dist.Color = customDistCol
        esp.dist.Visible = true
    else esp.dist.Visible=false end

    if Config.ESP_Health then
        local barH = math.floor(boxH*hpRatio)
        esp.healthBg.From=Vector2.new(leftX-5,topY); esp.healthBg.To=Vector2.new(leftX-5,botY); esp.healthBg.Visible=true
        esp.health.From=Vector2.new(leftX-5,botY-barH); esp.health.To=Vector2.new(leftX-5,botY)
        esp.health.Color=hpColor; esp.health.Visible=true
    else esp.health.Visible=false; esp.healthBg.Visible=false end

    if Config.ESP_Head and esp.head and head then
        local hp, hOn = Camera:WorldToViewportPoint(head.Position)
        if hOn and hp.Z > 0 then
            esp.head.Position = Vector2.new(hp.X, hp.Y)
            esp.head.Radius   = math.clamp(boxW*0.22, 2.5, 12)
            esp.head.Color    = customBoxCol
            esp.head.Visible  = true
        else esp.head.Visible=false end
    elseif esp.head then esp.head.Visible=false end

    -- Skeleton (PC only, within 220 studs, behind ESP_Skeleton toggle)
    if Config.ESP_Skeleton and dist3d < 220 then
        local parts = esp._cachedParts
        if not parts or esp._cachedChar ~= char then
            parts = {}
            for _, bone in ipairs(R15_BONES) do
                parts[bone[1]] = char:FindFirstChild(bone[1])
                parts[bone[2]] = char:FindFirstChild(bone[2])
            end
            esp._cachedParts = parts; esp._cachedChar = char
        end
        for i, bone in ipairs(R15_BONES) do
            local p1, p2 = parts[bone[1]], parts[bone[2]]
            if p1 and p2 then
                local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                local s2, on2 = Camera:WorldToViewportPoint(p2.Position)
                if s1.Z>0 and s2.Z>0 and (on1 or on2) then
                    esp.bones[i].From=Vector2.new(s1.X,s1.Y); esp.bones[i].To=Vector2.new(s2.X,s2.Y)
                    esp.bones[i].Color=Color3.fromRGB(245,245,255); esp.bones[i].Visible=true
                else esp.bones[i].Visible=false end
            else esp.bones[i].Visible=false end
        end
    else
        if esp.bones then for _,b in ipairs(esp.bones) do b.Visible=false end end
    end

    if Config.ESP_Tracers then
        local vx2, vy2 = Camera.ViewportSize.X, Camera.ViewportSize.Y
        esp.tracers.From=Vector2.new(vx2*0.5,vy2); esp.tracers.To=Vector2.new(midX,botY)
        esp.tracers.Color=C.accent; esp.tracers.Visible=true
    else esp.tracers.Visible=false end
end

-- ══════════════════════════════════════════════════════════════════
--  LOOPS
--  KEY FIX: ESP on RenderStepped (like TK4), aim scan on Heartbeat
-- ══════════════════════════════════════════════════════════════════

-- Aim scan: Heartbeat (fine for silent aim)
local scanAccumulator = 0
regConn(RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        scanAccumulator = scanAccumulator + dt
        if scanAccumulator >= 0.01 then
            scanAccumulator = 0
            pcall(scanBestTarget)
        end

        -- Speed boost
        if Config.SpeedBoost and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local md = hum.MoveDirection
                if md.Magnitude > 0.001 then
                    local alv = hrp.AssemblyLinearVelocity
                    local tv = md.Unit * math.clamp(Config.SpeedValue or 40, 16, 75)
                    hrp.AssemblyLinearVelocity = Vector3.new(tv.X, alv.Y, tv.Z)
                end
            end
        end

        -- ClientState patches
        if Config.InfiniteStamina and ClientState then
            ClientState.Stamina = 100; ClientState.Exhausted = false
        end
        if Config.NoRecoil and ClientState then
            ClientState.RecoilPitch = 0; ClientState.RecoilYaw = 0
        end
        if Config.NoBloom and ClientState then
            ClientState.Spread = 0
            if GameSettings then GameSettings.BloomScale = 0 end
        end
    end)
end))

-- ESP: RenderStepped — smooth 60fps box tracking (THE KEY FIX)
regConn(RunService.RenderStepped:Connect(function()
    pcall(function()
        -- FOV circle update
        if FOVCircle then
            local vp = Camera.ViewportSize
            FOVCircle.Position = Vector2.new(vp.X/2, vp.Y/2)
            FOVCircle.Radius   = Config.FOVRadius
            FOVCircle.Visible  = Config.DrawFOV
        end

        if Config.ESP_Master then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    local ch  = p.Character
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        if not State.ESPCache[p] then
                            State.ESPCache[p] = createESP(p)
                        end
                        updateESP(p, State.ESPCache[p])
                    elseif State.ESPCache[p] then
                        hideESP(State.ESPCache[p])
                    end
                end
            end
        else
            for _, esp in pairs(State.ESPCache) do hideESP(esp) end
        end

        -- Stale ESP cleanup
        for key, esp in pairs(State.ESPCache) do
            if typeof(key) == "Instance" and not key.Parent then
                destroyESP(esp); State.ESPCache[key] = nil
            end
        end
    end)
end))

-- Remove ESP when player leaves
regConn(Players.PlayerRemoving:Connect(function(p)
    local esp = State.ESPCache[p]
    if esp then destroyESP(esp); State.ESPCache[p] = nil end
end))

-- Infinite jump
regConn(UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, 48, v.Z)
        end
    end
end))

-- ══════════════════════════════════════════════════════════════════
--  UI
-- ══════════════════════════════════════════════════════════════════

local WIN_W, WIN_H, TITLE_H = 600, 440, 56

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CLAN_V3_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then pcall(function() ScreenGui.Parent = LP:WaitForChild("PlayerGui") end) end

local mainOuter = Instance.new("Frame", ScreenGui)
mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
mainOuter.AnchorPoint = Vector2.new(0.5, 0.5)
mainOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
mainOuter.BackgroundTransparency = 1
mainOuter.BorderSizePixel = 0
mainOuter.ClipsDescendants = true
mainOuter.Active = true
mainOuter.Visible = Config.GuiVisible
Instance.new("UICorner", mainOuter).CornerRadius = UDim.new(0, 24)

local mainStroke = Instance.new("UIStroke", mainOuter)
mainStroke.Thickness = 1.4; mainStroke.Color = Color3.fromRGB(255,255,255)
mainStroke.Transparency = 0.2; mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local msGrad = Instance.new("UIGradient", mainStroke)
msGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130,20,170)),
    ColorSequenceKeypoint.new(0.5, C.accent),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130,20,170))
})
task.spawn(function() while mainOuter.Parent do msGrad.Rotation=(msGrad.Rotation+1.6)%360; task.wait(0.066) end end)

local bgImg = Instance.new("ImageLabel", mainOuter)
bgImg.Size=UDim2.new(1,0,1,0); bgImg.BackgroundTransparency=1; bgImg.ZIndex=1
bgImg.Image=BRAND.LogoId; bgImg.ScaleType=Enum.ScaleType.Crop; bgImg.ImageTransparency=0.20
Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 24)

local bgDark = Instance.new("Frame", mainOuter)
bgDark.Size=UDim2.new(1,0,1,0); bgDark.BackgroundColor3=Color3.fromRGB(6,4,10)
bgDark.BackgroundTransparency=0.35; bgDark.BorderSizePixel=0; bgDark.ZIndex=1
Instance.new("UICorner", bgDark).CornerRadius = UDim.new(0, 24)

local titleBar = Instance.new("Frame", mainOuter)
titleBar.Size=UDim2.new(1,0,0,TITLE_H); titleBar.BackgroundTransparency=1
titleBar.BorderSizePixel=0; titleBar.Active=true; titleBar.ZIndex=5

-- Drag
do
    local dragging, dragStartPos, startPos = false, Vector2.zero, UDim2.new()
    titleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStartPos=Vector2.new(inp.Position.X,inp.Position.Y); startPos=mainOuter.Position
        end
    end)
    regConn(UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end))
    regConn(UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=Vector2.new(inp.Position.X,inp.Position.Y)-dragStartPos
            mainOuter.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end))
end

-- Avatar
local avatarBg = Instance.new("Frame", titleBar)
avatarBg.Size=UDim2.new(0,40,0,40); avatarBg.Position=UDim2.new(0,14,0.5,-20)
avatarBg.BackgroundColor3=Color3.fromRGB(12,8,18); avatarBg.BorderSizePixel=0; avatarBg.ZIndex=6
Instance.new("UICorner", avatarBg).CornerRadius=UDim.new(0,20)
local avs=Instance.new("UIStroke",avatarBg); avs.Color=C.accent; avs.Thickness=2
local avatarImg=Instance.new("ImageLabel",avatarBg)
avatarImg.Size=UDim2.new(1,-6,1,-6); avatarImg.Position=UDim2.new(0,3,0,3)
avatarImg.BackgroundTransparency=1; avatarImg.ScaleType=Enum.ScaleType.Crop; avatarImg.ZIndex=7
Instance.new("UICorner",avatarImg).CornerRadius=UDim.new(0,17)
task.spawn(function()
    local ok, thumb = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
    if ok and thumb then avatarImg.Image=thumb end
end)

local titleLbl=Instance.new("TextLabel",titleBar)
titleLbl.Size=UDim2.new(0,320,0,18); titleLbl.Position=UDim2.new(0,66,0,10)
titleLbl.BackgroundTransparency=1; titleLbl.Text=BRAND.Full
titleLbl.TextColor3=C.topTitle; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=15
titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=6

local subLbl=Instance.new("TextLabel",titleBar)
subLbl.Size=UDim2.new(0,340,0,14); subLbl.Position=UDim2.new(0,66,0,30)
subLbl.BackgroundTransparency=1; subLbl.Text='"'..BRAND.Motto..'" | RESPECT PVP'
subLbl.TextColor3=C.topSub; subLbl.Font=Enum.Font.GothamBold; subLbl.TextSize=9
subLbl.TextXAlignment=Enum.TextXAlignment.Left; subLbl.ZIndex=6

local toggleMenu
local CAM_SINK = "TK4_CamSink"
local _savedCamType = nil

-- TRUE ROOT FIX:
-- task.defer only lasts 1 frame. The game's CameraScript uses ContextActionService
-- to re-lock the mouse EVERY frame.
-- Solution: set Camera.CameraType = Scriptable while menu is open
-- (tells the engine to stop letting the CameraScript own the mouse)
-- and restore Custom when menu closes.
-- A high-priority ContextAction sink absorbs any remaining mouse-lock
-- remaps from the game while the menu is open.

local function openMenuMouse()
    pcall(function()
        _savedCamType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
    end)
    UserInputService.MouseBehavior    = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    pcall(function()
        ContextActionService:BindActionAtPriority(CAM_SINK,
            function() return Enum.ContextActionResult.Sink end,
            false,
            3000,
            Enum.UserInputType.MouseMovement,
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.MouseButton2
        )
    end)
    if not GStore._TK4_MouseConn then
        GStore._TK4_MouseConn = RunService.Heartbeat:Connect(function()
            if not Config.GuiVisible then
                if GStore._TK4_MouseConn then
                    GStore._TK4_MouseConn:Disconnect()
                    GStore._TK4_MouseConn = nil
                end
                return
            end
            if UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)
    end
end

_G._TK4_openMenuMouse = openMenuMouse

local function closeMenuMouse()
    pcall(function() ContextActionService:UnbindAction(CAM_SINK) end)
    if GStore._TK4_MouseConn then
        pcall(function() GStore._TK4_MouseConn:Disconnect() end)
        GStore._TK4_MouseConn = nil
    end
    pcall(function()
        Camera.CameraType = _savedCamType or Enum.CameraType.Custom
        _savedCamType = nil
    end)
    pcall(function()
        UserInputService.MouseBehavior    = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = false
    end)
end

toggleMenu = function()
    Config.GuiVisible = not Config.GuiVisible
    mainOuter.Visible = Config.GuiVisible
    if Config.GuiVisible then
        openMenuMouse()
    else
        closeMenuMouse()
    end
end

local minBtn=Instance.new("TextButton",titleBar)
minBtn.Size=UDim2.new(0,26,0,26); minBtn.Position=UDim2.new(1,-72,0.5,-13)
minBtn.BackgroundColor3=Color3.fromRGB(18,12,26); minBtn.Text="-"
minBtn.TextColor3=Color3.fromRGB(235,235,235); minBtn.Font=Enum.Font.GothamBlack
minBtn.TextSize=16; minBtn.ZIndex=7
Instance.new("UICorner",minBtn).CornerRadius=UDim.new(0,13)
minBtn.MouseButton1Click:Connect(toggleMenu)

local closeBtn=Instance.new("TextButton",titleBar)
closeBtn.Size=UDim2.new(0,26,0,26); closeBtn.Position=UDim2.new(1,-38,0.5,-13)
closeBtn.BackgroundColor3=Color3.fromRGB(18,12,26); closeBtn.Text="X"
closeBtn.TextColor3=Color3.fromRGB(240,240,240); closeBtn.Font=Enum.Font.GothamBlack
closeBtn.TextSize=12; closeBtn.ZIndex=7
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,13)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ══════════════════════════════════════════════════════════════════════
--  SIDEBAR  (style taken from TOXIC SLEEPY: icon + label rows)
--  Rename labels / swap icons here only - the tab keys stay the same,
--  so every toggle/stepper below keeps working untouched.
-- ══════════════════════════════════════════════════════════════════════
local SIDE_W=148
local SIDE_TOP=TITLE_H

local MAIN_TABS={"AIM","VISUALS","MOVE","CONFIG"}
local TAB_DEFS={
    AIM     = {label="aimbot",   icon="aim",      section="main"},
    VISUALS = {label="visuals",  icon="visuals",  section="main"},
    MOVE    = {label="movement", icon="movement", section="main"},
    CONFIG  = {label="config",   icon="config",   section="settings"},
}
local activeMainTab="AIM"
local mainTabBtns, mainTabFrames = {}, {}

-- sidebar shell
local sidebar=Instance.new("Frame",mainOuter)
sidebar.Name="Sidebar"
sidebar.Position=UDim2.new(0,0,0,SIDE_TOP)
sidebar.Size=UDim2.new(0,SIDE_W,1,-SIDE_TOP)
sidebar.BackgroundColor3=Color3.fromRGB(10,7,16)
sidebar.BackgroundTransparency=0.12
sidebar.BorderSizePixel=0
sidebar.ZIndex=3
local sbGrad=Instance.new("UIGradient",sidebar)
sbGrad.Rotation=90
sbGrad.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(20,13,32)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(8,5,13)),
})

-- separation line between sidebar and content
local sideSep=Instance.new("Frame",mainOuter)
sideSep.Name="SideSep"
sideSep.Position=UDim2.new(0,SIDE_W,0,SIDE_TOP)
sideSep.Size=UDim2.new(0,1,1,-SIDE_TOP)
sideSep.BackgroundColor3=C.winBorder
sideSep.BackgroundTransparency=0.25
sideSep.BorderSizePixel=0
sideSep.ZIndex=4

-- content area (right of the sidebar)
local CONTENT_Y=SIDE_TOP+10
local CONTENT_H=WIN_H-CONTENT_Y-14
local CONTENT_X=SIDE_W+13
local contentArea=Instance.new("Frame",mainOuter)
contentArea.Name="Content"
contentArea.Size=UDim2.new(1,-(CONTENT_X+12),0,CONTENT_H)
contentArea.Position=UDim2.new(0,CONTENT_X,0,CONTENT_Y)
contentArea.BackgroundTransparency=1; contentArea.ZIndex=4

-- content header (title + divider only, no function description)
local headTitle=Instance.new("TextLabel",contentArea)
headTitle.Name="HeadTitle"
headTitle.Size=UDim2.new(1,0,0,20); headTitle.Position=UDim2.new(0,0,0,0)
headTitle.BackgroundTransparency=1
headTitle.Font=Enum.Font.GothamBlack; headTitle.TextSize=15
headTitle.TextColor3=Color3.fromRGB(255,255,255)
headTitle.TextXAlignment=Enum.TextXAlignment.Left
headTitle.Text="AIMBOT"; headTitle.ZIndex=6

local headLine=Instance.new("Frame",contentArea)
headLine.Name="HeadLine"
headLine.Size=UDim2.new(1,0,0,1); headLine.Position=UDim2.new(0,0,0,28)
headLine.BackgroundColor3=C.winBorder; headLine.BackgroundTransparency=0.4
headLine.BorderSizePixel=0; headLine.ZIndex=6

-- icons are DRAWN with frames (no asset ids, no emoji -> always visible)
local function tintIcon(holder, color)
    local info=TweenInfo.new(0.14)
    for _, ch in ipairs(holder:GetDescendants()) do
        if ch:IsA("UIStroke") then
            TweenService:Create(ch,info,{Color=color}):Play()
        elseif ch:IsA("Frame") and ch.BackgroundTransparency < 1 then
            TweenService:Create(ch,info,{BackgroundColor3=color}):Play()
        end
    end
end

-- repaint one sidebar row (active / hover / idle)
local function paintRow(key, active, hovered)
    local row=mainTabBtns[key]; if not row then return end
    local bg=row:FindFirstChild("ActiveBg")
    if active and not bg then
        bg=Instance.new("Frame",row)
        bg.Name="ActiveBg"
        bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(34,22,54)
        bg.BackgroundTransparency=0.25
        bg.BorderSizePixel=0
        bg.ZIndex=5
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,8)
        local st=Instance.new("UIStroke",bg)
        st.Color=C.accent; st.Thickness=1; st.Transparency=0.7

        local bar=Instance.new("Frame",row)
        bar.Name="ActiveBar"
        bar.Size=UDim2.new(0,3,0,16)
        bar.Position=UDim2.new(0,0,0.5,-8)
        bar.BackgroundColor3=C.accent
        bar.BorderSizePixel=0
        bar.ZIndex=8
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    elseif not active then
        if bg then bg:Destroy() end
        local bar=row:FindFirstChild("ActiveBar")
        if bar then bar:Destroy() end
    end
    local info=TweenInfo.new(0.14)
    TweenService:Create(row,info,{BackgroundTransparency = active and 1 or (hovered and 0.6 or 1)}):Play()
    local lbl=row:FindFirstChild("Label")
    if lbl then
        local col=active and Color3.fromRGB(255,255,255)
            or (hovered and Color3.fromRGB(220,212,235) or C.tabIdleTx)
        TweenService:Create(lbl,info,{TextColor3=col}):Play()
    end

    local icon=row:FindFirstChild("Icon")
    if icon then
        local targetCol = active and C.accent
            or (hovered and Color3.fromRGB(210,195,240) or C.tabIdleTx)
        tintIcon(icon, targetCol)
        -- scale bounce
        local sc=icon:FindFirstChildOfClass("UIScale")
        if sc then
            TweenService:Create(sc,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
                Scale = active and 1.12 or (hovered and 1.07 or 1)
            }):Play()
        end
        -- glow chip
        local chip=icon:FindFirstChild("Chip")
        if chip then
            TweenService:Create(chip,TweenInfo.new(0.18),{
                BackgroundTransparency = active and 0.78 or (hovered and 0.92 or 1)
            }):Play()
        end
        -- thicken UIStrokes on active for glow feel
        for _,d in ipairs(icon:GetDescendants()) do
            if d:IsA("UIStroke") then
                TweenService:Create(d,TweenInfo.new(0.14),{
                    Thickness = active and 2.2 or (hovered and 1.8 or 1.5)
                }):Play()
            end
        end
    end
end

local function switchMainTab(name)
    activeMainTab=name
    local def=TAB_DEFS[name]
    if def then
        headTitle.Text=string.upper(def.label)
    end
    for _,key in ipairs(MAIN_TABS) do
        paintRow(key,key==name,false)
        if mainTabFrames[key] then mainTabFrames[key].Visible=(key==name) end
    end
end

-- section caption (premium: gradient text + thin accent line)
local function makeSideSection(text,y)
    local wrap=Instance.new("Frame",sidebar)
    wrap.Size=UDim2.new(1,-16,0,14); wrap.Position=UDim2.new(0,8,0,y)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.ZIndex=6

    -- left accent pip
    local pip=Instance.new("Frame",wrap)
    pip.Size=UDim2.new(0,2,0,10); pip.Position=UDim2.new(0,0,0.5,-5)
    pip.BackgroundColor3=C.accent; pip.BackgroundTransparency=0.4; pip.BorderSizePixel=0; pip.ZIndex=7
    Instance.new("UICorner",pip).CornerRadius=UDim.new(0,1)

    local g=Instance.new("TextLabel",wrap)
    g.Size=UDim2.new(1,-10,1,0); g.Position=UDim2.new(0,8,0,0)
    g.BackgroundTransparency=1
    g.Text=string.upper(text); g.TextColor3=C.topSub
    g.TextTransparency=0.0
    g.Font=Enum.Font.GothamBlack; g.TextSize=8.5
    g.TextXAlignment=Enum.TextXAlignment.Left
    g.ZIndex=7
    -- subtle gradient on text
    local tg=Instance.new("UIGradient",g)
    tg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(180,140,230)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(130,100,180)),
    })
    tg.Rotation=0

    -- thin separator line after text
    local sep=Instance.new("Frame",wrap)
    sep.Size=UDim2.new(1,0,0,1); sep.Position=UDim2.new(0,0,1,2)
    sep.BackgroundColor3=C.accent; sep.BackgroundTransparency=0.82; sep.BorderSizePixel=0; sep.ZIndex=6
    local sg2=Instance.new("UIGradient",sep)
    sg2.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.6,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})

    return wrap
end

-- ── SIDEBAR ICONS · taken from TOXIC SLEEPY ───────────────────────────────
-- 64x64 white glyph PNGs (tinted at runtime with ImageColor3). They are written
-- through the executor file API; if that is missing the Roblox asset ids are used,
-- and if those do not load either, the drawn icons below are used instead.
-- Change the right-hand names in SBI_MAP to swap an icon (pistol, eye, wrench,
-- swirl, zap, gear, person_sun, pickaxe are the ones embedded here).
local SBI_PNG = {
    ["pistol"] = "\137PNG\013\010\026\010\000\000\000\013IHDR\000\000\000\064\000\000\000\064\008\006\000\000\000\170iq\222\000\000\005HIDATx\218\237\155\207\139\028U\016\199\063\175\1236\155\141k\178Y\137\136\094\036\018\009\008B\208\093PAE\060\196\008\030D\047\006\005\193\004\033\007Q0\228\159\240\032\146\131z\016\193\156\188y0\030\020\207I\144\160\130\008\202\226\033\254\002\227n\216\036\027w\123\166\060l\061\044\202\158\158\238\158\201\246L\182\0314\221\211\243\186\251\213\183\170\190\245\163g\130\136\176\157G\1946\031\045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\045\000\219ut\220\231\000\164z\220\003\038\189P\008F\201\221\060y\130\041\134\194\045\032p\025\064\036\207\002\226\023\183\003\199\245\248S\224\234\132\011\060\011\188\168\242\125\000\172z\016\130\136\004\0619\007\156\005\022\245\1875\224\031\061\150\009\2124\19240\163\199\231\129g\128\021\149G\162\005t\128\013\224\152\010\127C\207\205\152\139\039yd\186\045\002\175\002\239\168\124\153\039\193L\137\047\130\034\253\136\195D\144\196\093\063\142\036\2231\164\062\1517\161\167\199\023\156\064\033\039J\020\141\169\009\008\249YQ\024\1562\254\046\010\192\199\192\047\1428\018\005\237I\224\009\061w\003xW\247\2272v\002o\232\222sC\046\000\214\212\123\154\015\188\007\124\211\231\001\039\013\000\215\129Sc\168\245c\010\128\148M\132\252\216\171sR\229\003\012\129\204\058d\247\001\203c\144O\196\231\239\205\211xU\000\186\042\172\024\000\044a\250\185r\147\194f\149\1724\002P\138\148\059\035D\125\195\1294\145\181\064\221\177\001\204\043\017\166\192\039\006\012\169\001\038z\159\163z\252\150\186\215\200\173kT\000\092\003N\003\207\234\231WF\172\168\020x\217q\209X\001\208\036\225\165\2062\034\007\164\091\009\192m\192\009\224\018p\064\0230l\175\161\167\194\044i\136\013\142x\007\145\221J\025w\025\021\000S\192\223\192\235\091\028\234l\245z\209\240G\252njX\000\0185\165\212\249\163\215\176h\1941\168z\012E\205\137\130kz\206\196c\245\250\133\169\094\203\016\171T\005\224\170\046\182\235\226\125\044\151\045\000\203\021\011\162\186\009S\170\2079\238\170\215\196\221\0478\037\245\242\228\237\244\201\147\227\241c\192\046\199\190\241\248\160s\129\035y\013\007\039\236\161\162\230D\1412\183\151S\241\137\185oO\183L\045t\229\127w\017\145TD\016\145\199est\229\230\143s\034r\135\136\036\034\018\244\249e\183\184\222G\043\174\247\156\136\204\251gF\211\233\002\011\006\177\164\015\162V\155\137\179\154A\233j0\218X\212\036\231\180ZOV\131\035\2382\238\023\215\252\182\022o\169YO\161\213u\156\059\036\192\186\033\192\188\220\094\092\217L\133\012\205\154\234B\014\191\148\225\136\008\210\131\206\183W\129\143\128\203n\254\215\131\154\162\153\010\251\033\240\124IV\0296\171\011\192\011\192\231\192\031\166\199P\134\035\226\2319\039X\215\148\241\222b\251ZUl\139\023\197\213as\239\040\220\001\224\125\227RE\227\060p\024\184\146ci\241\126\095\001O\169\197\238P\211\127\196T\175\229\134\033\151\170dTg\251RI\043\019\145\158\2383\061\215\021\145\013\017YS\210\058\169\215t\220\026\131\136\204\136\200\015\058o\093\247guNReM\062\153\009\038\172\164\035\220\166Us\159\233\062\150\206\193\197l\219\144\237\167EQ\141\223\237\206\0954\022R\201\060\253\205c\027\185\059\194\045\018\235\0255\239\157\134tS\151\169u4\001\059\227\018\047\235\207\247\040\008\214\157\174\141s5\024\181y\025x\218\240\204\183\234\207\175\001\047\169\176\029\221\095\047\136\000w\178\249\206\194Z\209\133\058\253\130\173\044\135\163\182V\217\1249a\199\155\038\164\001\252\164\026MrZo\000\247\154\123\1989k\147\208\015\016W\195\199\0403\159S\131l\228\184h\212\246\126\007\192\042\240\163\003ql\027\034\145g\162\240\123\128\251\157\128\223\229\212\039V\184\007\220\249e\181\128Pu1\227\240\003\137\029\186y\129\040\016h\222\249\251\146ZM\229\188\165I\000\226\179\015\002\187\149\208\018g\001\210\167\009\178\223\001\180\060\236\034\154\02839\154\094\046p\159T\221\198\142\239\235\202\211\036\000Q\232\005\227\223\145\208\150\250X\000\192\125\218\163\232\221\042\022\176\043\167\168\185R\000\192\062\045\161\037\1354\043\215\045M\182\197\035\163\063\236\022\255\179\246\022\167\092H\139k\125\200\185\195\026\240\251\036\002\016\045\208\255\010\229\047\242\095\179\199\148x\218\229\020\235\192o\147\006\064\236\014\2376\189\197\232\142\235Z\230\038\174\014\136\025\223a\231\018\191\2345\161\206B\154\182\128Yc\0011\059\124N\183\178\036\250\167\186AR5\011l\018\128\216\218\062\202\230\091\165\204\172E\250\008\226\123\145q\222\165\001I\211XG\129\248\146\0353mn\025PQ\218\146\061\225\191\095\176\212\002\0324\244\183\185\040\248\030\202\191\221\233\215\058\059\162y\128\212\033\193\208\224\255\006\235\244\033G\254\130\0374\252\199\201Q4\093\135\186G\211Q\192\247\007\170\1880\141\185\193P\000\134\246\175\179\219\124\180\000\180\000l\243\241\047U\246E\040\151pNJ\000\000\000\000IEND\174B\096\130",
    ["eye"] = "\137PNG\013\010\026\010\000\000\000\013IHDR\000\000\000\064\000\000\000\064\008\006\000\000\000\170iq\222\000\000\004\240IDATx\218\237\154Mh\092U\020\199\127\239e\038\233\162m\012\017t\035\186\016\234G\137\173\216P\131\184\232\038\212\0150\020\172\226F\045\150n\091\164\130\008M\041\221\214\157\187j6\146U\141\224\023BW\034\017R\017\041M\196\170\032\184\201B\177\041\2218\147y\255n\206\133\227\245\189\201L\152\212\153\230\030\024\230\205\123\247\156\123\206\255\156\123\2229\247N\038\137\237L9\219\156\018\000\009\128\004\064\002\032\001\144\000H\000\036\000\018\000\009\128\004\192\246\164\218\029\156\043\139\000\207\162\231\190\045\045\162\223\091\167\212\022\182\195\193\224\012hm\194\160\012\0242\190\045\003\164\215\000x\047\183\162g\247\002\143\153Q5\096\018\168\219\179\038\176\004\172\027\223\010\240g\196\063T\033\183\047\000\240\158\0144\012\060\013\236\003\1587\131G\059\148\183f\128\124\001\252\008\124\0074\034\144Cd\252\175\000\228n\205\002\140\000\207\000G\129g\129\061\209\248\194\173w\149DOV\145\156\127\006\190\001\230\128\1976\243\2231\000b\143O\002\135\129W\128G\034\131\011g\156\034c\179\008\016\255\060\252\206\035\064\150\128\047\129\175\236\154\040WtG\146\186\253\212\220\245\094I\243\2507\181\0365\037\173\187O\161\238\169\136d4K\228\204\155\014A\159\161n\237\233\038\002\124\184\237\001\222\001\094\179\181\046\231iEI\043\208\170yl\013\024\007\246\002\015\216\179\063\128k\192\095\150\039\038\129\251\035\254VE\0206\128\143\129\011\038\163\171e\209\041\0005\203\208\000\239\001o\187\132\214\178I\011\167\020f\204\183\192gf\248\013\224U\224\037\224Q\096\167\171C\214\129\091\192O\192\167\192\060p\143\001\241\162\229\149\241\008\1400g\000\186\001\124\000\156\044\209y\211K\032s\033\255\164\164\203\046\252\154\046L\061\045J\058\041i\220\201\217\039i\185\139\240\0956\158\192\063n2\023m\137\005ZwK\046\208e\2115\044\215\172\157\141\237\140\247\235\233\093I7\035\195\091nM\174\155r\135K\228\156p\227\154\198\215\218\224\058\228\128\019\037\242\166\036\125\034i5\202\059r\1887M\231\013sC\149\241u\135\252\092\132\184\034\175\095\1484\017E\205\176\093\0314C\138\010\222\152\252\152\192w\208d\013G\222\188O\210\025Ik\145\241\094\254\156\139\196Z\039\000\248\144\159\145t\189\141\215\175I\058\026\241\014\217w\046iT\210o\145\241\158\247\180\164i\251\156\182\123\138\162\1700\025\163\0383\200\246\030\157\140x\131\142\001\144\235\146\094\182\177y\188\036b\227\125\2007\034d\155\046\220\222r\094\0302\193\241kr\182\132\175\176\251\059J\188\177\195\158\021\037\033\061\091\226E\239\172a\211\169U\161\179\036\189\239x\243\024\128pc\151\164\243\209\218\042\028\024\063H\058\180\193\218\202\036\141H\250\197\025\019\034\224\172\027\247\132\0256k\215\225\254\217\040\193\021\038k\164\034\161y\240\015\153\142\094w\063\255EI\059\061\159\247\252nI\0116\176\017yB\146\046\024\064\237\178kPf\127\164\128\036\173\184\1689\238\064\013\243\029w\222\092\0411b\127\137\193e\209\176K\210\185\146\004\025\230\091pvdA\224\152\164\165h\096X\139\255Hz\163\195j\043\040q\204y1\132\225\041\247J\044\220\092\126\190\240\234\059\229B8x\239X\187dV\162\219\180\164\027\145\045a\174\037\1799\015\197\196\155\192\001\043\038\234\174\255\094\006\094\000\062\178\130\035\235\176\029\125\200\213\248\1612\187j\252G\092\011\092\183O\211\238\029\1771W\093\181\167Hf\059j\025\127\029\248\026\1522\027BeX7\027\015\152\205E\190\137\206o\144\232\193\146\221\166\255\024\149\003\031\002W\172\174o\186\146\246q\224s\096\218\238\171\164\198\047\163\223\093W\023j\242\009\227\191d\191\131\231\155nc\228\146\141\153p\094\203\034\153\237\040t\133M\211y\193l\008\123\008M\179\241\138\217\156w\147\004\207\013p\018\044\162\036\184\219\039\193N\094\131\173\001\127\013\006\058\239\156\152\247\170\016\138\163\161\031\011\161F\212\027d\189\042\133g\162h\200\251\180\020\158\169Z\186\155m\134\060\178g\1721\233\247f\168\190\021\237p\160UkQ\167\238\150vx\179\027\034\173A\219\016\233\245\150\152\175\017\006bK\172\215\155\162e\0399\125\189\041\186\021\219\226\197\221\186\045\222\201\193\200sv\0610\007\035\189\062\026\195\058\176\215\043\142\198\188\145E\133\172\172\228\232\188\239\142\198\170\034\194\031c\199\135\163O\001c\029\202\251\027\248\126\016\014G\171\058\178\178\1645\006\060\236\178\127\213\241\248\045\224W\003a\096\142\199\211\031\036\210\095d\210\191\196\018\000\009\128\004\064\002\032\001\144\000H\000\036\000\018\000\009\128\004\064\002\096p\2326q\153\194\153JT\040\165\000\000\000\000IEND\174B\096\130",
    ["wrench"] = "\137PNG\013\010\026\010\000\000\000\013IHDR\000\000\000\064\000\000\000\064\008\006\000\000\000\170iq\222\000\000\0050IDATx\218\237\155\207\139\028E\020\199\063\2213\155\213\021\0937\134h\132\037\130\160\162\040\130\038\007o\010b\014\129\196\032\042\185\172Q\019\240\146\163\008\158\132\021\242\023DQ\002\010\030\036\044B\240\178K\064\016\127\0286FE1\006QP\146U\140\196\141\145\013\155\157\031\095\015\190\130g\059\061\211\061\1793\211\061\155\130\162\183k\170j\234\251\234\189W\239\125k\039\146\196F\0461\027\188\092\019\192F\023\064\181\004\027\020Y\245EV\155\163\040\128\200\12873\000\244\125\187\242\230Q\193N\129\010\208p\239\211\192\061\192N\096\204\218j\192\034p\0228\215fl\1694\032\168y\003\216\010\236\001\158\003\030\004\038R\198\092\001\190\006\222\001N\000\023L\027\148K\027\036\013\187\198\238\239\231\037\045\233\191\165\033\169\150\168\141D\159\037\027\027\230\137\178\126\255\176M\032\216\239f\224\013\224ik\175\059\199\167\132\035\148k\011\239A\147\223\007\094\006\150\178jB\092\000\240S\192\188\129\175\217\162\043\206\174\171\246\140\173\250\182\208G\192\042\240\044\176\215\230\173\020\217\007D\182\232\041\096\001\216a\224\199l\241\001\232Y\019\2067\192\0476v\059\240\000\176\203\028\036\192\026p\029\240\166\213\216\180\168\176\062\160b\182\063g6\188f\207\186\179\233\003\146\198\219\2041n\125\206\217\152\227\206\2543\251\128a\129G\210L\010\248EI\219\092\255\170\213\138\213\240\030\062\191\093\210QI\155\013x\156g\061\131v\130\193q\221\002\124kG\0940\135\0248\005\060\001\044\1559\212\2198\178\016\0045zuD\131\014t\004\060\009\220\230\192E\192\239\192n\003\095q\0141\213z\013\124d\253\1632\008\0328\184\023\029\184\166\045\254\021\011f\198r\238j\016D\225C\225p\236M\003\223\00378\129\252\000\220\239T\126\160\139\026\180\253\223\235\192\135dg\222\142\178x\144\224\135\037\128\135\019\170\015p\186\091\027\046c\058\188\169\133P\126\094G\213\143\019IQ\219y\139N\136t\235h\155E\214\128\181\132\007\007\184\003\248\164G3\008\187\254\040p\039\240\035\240\019p\009\184\092\004\031\016\192\126\145X0\192C\235\160\254a\190\167\128\183\128\143\1283\038\132\157\046\014\025\154\006\004\128g\128\021\059\009B\217e\190\161\238\034\195\188\014\182is\060fqA\211\190c\012\248\035\177\134\161h\0648\243\151\128\239\156sj\000w\001\251\173O7\155R\181\177\251\129\187\019q\199W\230d\227V\190a\208\145\096X\1961g\239Au\143XnP\203\154\203\059\181\174\217\216\035\046\175\008s\031K\180\0135\029\014Y\221\205\146\206\091\246\215t\020\215\162\164\041\235\059\214\033\173\141\172\0156f\209Qha\206\223\036mi\151\034\015\139\251\187Q\210\225D\026\220m\058\188\205\129\175\039R\236\153D\010\0624\001\132\005\236\147tB\210\005I\023\245\255\210\013\033\178\148\002\126\206\132\094\0256\031\016\248\250Y\224\213\028\206\146\028\148X\024\019h\181\192\043\092J\243\254\131\202\006\171v\180\237\006\062t\060\093\037\017\010\135\210p\224\179\016\155\190\127\061\001\1269\205\243\015J\000\158\245\253\024\184\047\193\248v\002F\023\180\248q\224\037\224\207\044\224\251y\012z\240\011\150\235\147\002\062\236\1922p\0248o\253\042\142\014\151\139\241\229X\227\064\145\255\010\188\000\060\147\007\124\191\142\193\184\197\209TSzi\218\243\162\141\219\034\233\144\164\207\036\173\180\025\183b\125\014J\218\234\190\059\026\038\041\154\220\249\029f\155\237\162\187\186\237\228I\243\0215\247Y\223\047G\215S\000\173\192\095\005\198\059\228\007\193\217\237\229\223K\206\170k\239\180\184\158\175\199\171\125\004\2230\240\205\020\095\227\193\191n\224\1477\058Y\254A\162\039Z\188\1596\095\151\244i\034H\241v\031\218\014\186\136o\224\0235\253\000\191j\207\003\1466I\058\237b\244B\129\239U\000\237\192\123\096\019\146\094\179\016\181\094\036\240\189\008\032\011\248\016\199OJ\1547\013X\043\018\248n\005\144\007\252\148\164S\137\036\1650\224\187\017\064\094\240\237L\131\178\009\096\228\192\231\017\064u\020\193g\021\064eT\193g\017\128gr\190L\0045\165\007\223I\000\193\230g\019Q\220\223\163\002\190\157\000\194\206\239q\160\026\146NJ\218\238X\219R\131\239\036\128H\210\130\011\093\047K\186uTv\062\2128\037\197l\000\147v\151\031\181\248\199\133\171\246y2\237\061\004\188\237\184\192\194\151\172\148X\019\184\009x\207H\138i\096\206\192\175\150\021\124\059B\164b\160\231\129\199M\035\002wp\197\158\019\142\134\046\037\248N\026\032\224\168\035\035\234\038\136\009\224z\187\231\0475\248N\132H\2181\232\203l\153\028\0947\164h\032\026\247\0013\192\035\214\2549\240\046\240Aiw\062\007\041\2349\246I\123\254\213\226\179\145\021\128\191\208h\164\188\143\188\000H\220\229\141\204\239m\243\210\226\035\247C\227k\063\157\189\038\128\013\094\254\001e\228\195\094\147\217\159\146\000\000\000\000IEND\174B\096\130",
    ["swirl"] = "\137PNG\013\010\026\010\000\000\000\013IHDR\000\000\000\064\000\000\000\064\008\006\000\000\000\170iq\222\000\000\006\174IDATx\218\237Z\093\136UU\020\254\206\185\247J\136c\0226\216T\016\024\218\143JAjc\160\2254AF\130\133\026\061\132\047\037\250\212S\244\018B\024\021\061\004\165\163V\154Ea\250b\016\037\040\061\132\149\020\017\036\133\246KIN\063\154\153\035\058\206\189\231\126\189\172\013\095\139s\231\158\059s\239\157Ks6\028\238\185\231\236\159\181\191\189\214\183\215ZgG\0361\153K\140I\094r\000r\000r\000r\000r\000r\000r\000r\000\038m\041N\224\216\005\185\143\236\151\238\250\223\001\016\219d\171\000\146\058u\035\003\169jWKJ\212\166\096\040LD\007\091\044\0110\023\192u\000\062\001p\018\192\239\000\254v\096\196\025\064\2358\000\002\199\132\021\092\004\224\094\000\247\001XX\163M\005\192\016\128\047\000\188\015\096\063\128\019\002D\212T\141\032\217\170\171\032\247\253\036\015\242\191\165jWB\178B\178l\247\190\156\183\182\253\210\095\220\0449\091\165\001\005S\215\219\000\060\015\160\095HNW\047\144\093\228\158\133\149\166\227\169\003\000\158\000\240\181\188\2398\019\136m\146k\000l\007p\133\216nP\223\044\228Kk\023\011\0401\1282\128G\000\188c\253T\058\009\128\176\242k\000\236\021\155\046\218\196\003\039\036\000\190\004\240\043\128\163\174\143\025\000\1508\142H\164\239\000\196\038\000O\003\040\025\040\029\193\001\1936\143\136\093W\197\182\143\145\124\133\228\130\012\125\045\033\249\002\201\063\172m\034\188Q\177g\155S\248\166\161\171U\196\183\203\004\188d\002\147\228v\146S\164nd\245K\238\042\218\187P\175\155\228\171\1428\021\212u\227\001\161\145\137e\025\032\178k\038\201\195\002\194zy\0954M\041\214\232\179\032WQ\158\063d\125Q\000HH\1585\144\198\180\059d\225\000e\219\044\204\027\234\020\000\044\0030\008\224\184\144\025\220\094\062\021\192\020\187\031r\132\169\125U\000\172\000\240\174qJ\036\188r\004\192r\000\035\141\186\209YIp\177\253\126\214\032\008\161\148\132\192\194\004W\155S\180\028\192t\123\246\155\141\241\026\128O\221\174\018\024\127\041\128C\246\063\022\130\092e\224\020\026\242\024\235\016ZLr\064\156\146\129\006\236\045\170a\058\179H\238\225\232\037\033\249\001\2019n\188\096\018\175\091\189\138\152\195I\146W\137\025\142\139\003\194\128w\200\064e\187\239\031\003\233\244\146\092Hr\017\201\239\164\207a\231\253\149\237Y\032\206\191\172\157\046HL\242\026\146\023Rv\133u\014\168\166\002P1a\127\032\217e\130Du4\168\2284\040\145\137\234\196\207\024\153\169\155\092\150w\179e\242A\182\173nq\170\036w7\1868\141\152\064E\144\222Z\007\233\130\129s\139SU\221\207i\166\208K\242JS\223\149\036\095\022\032F\236\247\160\147\041\034y\189\197\009\170\001\223\146\188\172\025\038\224\029\155\001Y\1850X\223\040h\007\096v\058\001\131\189\150ekL\187\030\149m\046h\194\1312\094\144\235\144\200E\146\231dK\140\154\001\064d\131M3\213\175\138\186\2132\133\000\200z\167\246\042\232\139V\167\036\218\018H38K\187\173n\224\132\247\164\255\224\044\061\227L\0421\0152\179\025\196\025\002\146\008\192y\000\235eoN\000\204\006\240\156mQ\005\023\011\244\002\216\150\178\029\005\095\096\191lo\137\236\221\137\004\064\091\036\142\136\000\220\010\160K\182S\0028\229d\141\001\204jvR41\033\062\0040\032\147M\000l\004\208g\130\150lB\221\182\031k\038G\005\252\007\192\177QR\093\225\249\247\000\206\201x\211l\012\045\093\014\000\000X\224\242\140M\201\010\135Uy\018\192\143\038TX\181\029\226\200\1966\249nis\017\192\0377\193\145\012cN\201\032\223P\198g\227\006\032\152\194\208\040\166P\182\248\191\2154\034\168\248JKi\133\250\211\173M\092c\252\130\061\159\003\224r\137\247\047\164\132\189\221\041\153\229j\043\195\225\162\219\131\203B\140\219\132\244\002\217m\180\250\123\172\222\176\061\223\043\253y\018\044J\027\037\193\183\092\027\144\060\032\219l\032\219\165\141\144\096\163\000\132\093\161Kv\133\19690\225\255\014\217JW\1658\064\027F\025gC\010\152\171\156\143Q\032\249\185\212\011\253\046k\037\000\218q\159slt\021\062\018\175\045\212\223\039\206M\034\142P\159\133\2073\237\126\143\244\027\028\161\125\206\007\136H\094m\142\144\2020HrF3\253\128z\166\176\1979\058\009\201\139\036\231\185\213\138\205A9\037\032TEs\206\166\184\194a\242\167\172m\044\043\015\146\155R\226\1487\155\233\010\215\211\130\136\228\124\231\236\132\224\228\039\091\137X\000\008\233\241Ai3\044\194k0\020\000\029\148\224K\251\154E\242\180K\171WH\222\213\046\000\032Y\029\141\021\244w\167x\123\234V\247d\008\135\131y\244\184\182\037\231\037j\124\242\198XRc\205J\130\062\2364\033\008\181\214\153\140\010w\143\229\014\191\177\136\239\012\201\159\237\217\234\020\206\009\046\242\003\178\234U\209\164\185N\219\218\150\020\013\002\030t\145\095X\157\021\002B\148\034d\193\204e\006\201\169\014\220P\063\172\252\205\036O\184\160j\204\171\223L\000\034\091\129\178\248\006\154\189\093\234\234\199\163\036Z\011\178\215k\184\189\198\038\239S\228\167\093\190\096B\210\226a\224\181\041\002\006F\223e1\188\231\016\159\022\247\147\2321\062\161\235\059\236\018w\183\035\045\222\008\008O\1658E\148x\253\037\1467f\208\170Z\031F\018\225\152\199\027M\129\181\250\227h\008\1357\091\224T\144\160H\195\230\017\000\031\091\058\187\226\014l\044\002p\045\128\155R\130\177\016\153\018\192c\150\061n\044\011\220\134\207\227\037\177\217\063\157\175\174NS\189R\021\215Y\219\252Bry\035\222\222D\126\030\239\001\176\015\192\157\238\000\132\1432\145\018\213\249\179D\035\000\222\006\240\172\229\010\198\253e\184\093\007\036J\150\207\059\154\178\250Uqe\2035\014I\012\027\129\206\171q\248\162\0355\032\237\011Q\012\096\030\128\251\237\147\217\237vv\032\173\0922\142\216\011\224\176\125Z\131\036b\154vD\166\029\135\164j\029p\186\002\192\013v8j\190\229\029\019\000\095\217\039\178\227\206\012\154\058\241v\159\018\211\143\157\177\036B\179\028\169k\201\196\039\002\128Z\154\129\1483B\045\157t\167\000\208\017\037\063\044\157\003\144\003\144\003\144\003\144\003\144\003\144\003\144\0030Y\203\191\030\163\212\125\233\239\227\195\000\000\000\000IEND\174B\096\130",
}
local SBI_ASSET = {
    pistol = "rbxassetid://7733765307", eye = "rbxassetid://7733774602",
    wrench = "rbxassetid://7743878358", swirl = "rbxassetid://7734053495",
}
local SBI_MAP = { aim = "pistol", visuals = "eye", movement = "wrench", config = "swirl" }
local SBI_CUSTOM = {}
pcall(function()
    if not (writefile and getcustomasset) then return end
    local dir, ver = "clan_sidebar_icons", "v1"
    if isfolder and makefolder and not isfolder(dir) then makefolder(dir) end
    for name, bytes in pairs(SBI_PNG) do
        pcall(function()
            local path = dir .. "/" .. ver .. "_" .. name .. ".png"
            if not (isfile and isfile(path)) then writefile(path, bytes) end
            local a = getcustomasset(path)
            if a and a ~= "" then SBI_CUSTOM[name] = a end
        end)
    end
end)
local function SBI_resolve(name)
    if not name then return nil end
    if SBI_CUSTOM[name] then return SBI_CUSTOM[name], true end
    if SBI_ASSET[name] then return SBI_ASSET[name], false end
    return nil
end

-- ── PREMIUM ICON SYSTEM ─────────────────────────────────────────────────────
-- Each icon: 24×24 canvas, pixel-precise frame shapes, animated glow chip,
-- gradient stroke on active, UIScale for hover bounce.
local function makeSideIcon(parent, kind)
    -- outer holder (24×24, vertically centered)
    local holder=Instance.new("Frame",parent)
    holder.Name="Icon"
    holder.Size=UDim2.new(0,24,0,24)
    holder.Position=UDim2.new(0,10,0.5,-12)
    holder.BackgroundTransparency=1
    holder.BorderSizePixel=0
    holder.ZIndex=7
    local usc=Instance.new("UIScale",holder); usc.Scale=1

    -- animated glow chip (shown when active)
    local chip=Instance.new("Frame",holder)
    chip.Name="Chip"
    chip.AnchorPoint=Vector2.new(0.5,0.5)
    chip.Position=UDim2.new(0.5,0,0.5,0)
    chip.Size=UDim2.new(0,34,0,34)
    chip.BackgroundColor3=C.accent
    chip.BackgroundTransparency=1
    chip.BorderSizePixel=0
    chip.ZIndex=5
    Instance.new("UICorner",chip).CornerRadius=UDim.new(0,10)
    -- subtle inner glow gradient on chip
    local cg=Instance.new("UIGradient",chip)
    cg.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(160,80,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(90,30,180)),
    })
    cg.Rotation=135

    -- helper: solid rect piece
    local function px(nm,sz,pos,rad,alpha)
        local f=Instance.new("Frame",holder)
        f.Name=nm; f.Size=sz; f.Position=pos
        f.BackgroundColor3=C.tabIdleTx
        f.BackgroundTransparency=alpha or 0
        f.BorderSizePixel=0; f.ZIndex=8
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,rad or 0)
        return f
    end

    -- helper: outlined ring (hollow circle)
    local function ring(nm,sz,pos,rad,thick)
        local f=Instance.new("Frame",holder)
        f.Name=nm; f.Size=sz; f.Position=pos
        f.BackgroundTransparency=1; f.BorderSizePixel=0; f.ZIndex=8
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,rad)
        local st=Instance.new("UIStroke",f)
        st.Thickness=thick or 1.5; st.Color=C.tabIdleTx; st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
        return f,st
    end

    -- ── redesigned icons ───────────────────────────────────────────────
    -- Everything is placed in SCALE units of the 24x24 holder (UDim.Offset is an
    -- integer in Roblox, so fractional pixel values would be rounded and look
    -- distorted). Shapes use centre coordinates; rotation is in degrees (clockwise).
    local ICON_PX = 24
    local function cround(w, h, rad)           -- UICorner scale is relative to the shorter side
        local m = math.min(w, h)
        return UDim.new(math.clamp(rad / m, 0, 0.5), 0)
    end
    local function cbar(nm, cx, cy, w, h, rot, rad, alpha)
        local f = Instance.new("Frame", holder)
        f.Name = nm; f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Size = UDim2.new(w / ICON_PX, 0, h / ICON_PX, 0)
        f.Position = UDim2.new(cx / ICON_PX, 0, cy / ICON_PX, 0)
        f.Rotation = rot
        f.BackgroundColor3 = C.tabIdleTx
        f.BackgroundTransparency = alpha or 0
        f.BorderSizePixel = 0; f.ZIndex = 8
        Instance.new("UICorner", f).CornerRadius = cround(w, h, rad)
        return f
    end
    local function cdisc(nm, cx, cy, d, alpha)
        return cbar(nm, cx, cy, d, d, 0, d / 2, alpha)
    end
    local function cring(nm, cx, cy, d, thick)
        local f = Instance.new("Frame", holder)
        f.Name = nm; f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Size = UDim2.new(d / ICON_PX, 0, d / ICON_PX, 0)
        f.Position = UDim2.new(cx / ICON_PX, 0, cy / ICON_PX, 0)
        f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ZIndex = 8
        Instance.new("UICorner", f).CornerRadius = UDim.new(0.5, 0)
        local st = Instance.new("UIStroke", f)
        st.Thickness = thick; st.Color = C.tabIdleTx
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return f
    end

    local function drawFallback()
    if kind=="aim" then
        -- Precision reticle: ring + 4 crossing ticks + centre dot
        cring("Ring",12.00,12.00,14.00,1.60)
        cbar("TickT",12.00,3.00,2.00,6.00,0,1,0.00)
        cbar("TickB",12.00,21.00,2.00,6.00,0,1,0.00)
        cbar("TickL",3.00,12.00,6.00,2.00,0,1,0.00)
        cbar("TickR",21.00,12.00,6.00,2.00,0,1,0.00)
        cdisc("Dot",12.00,12.00,3.50,0.00)
    elseif kind=="visuals" then
        -- Eye: almond lid outline (arc segments) + iris
        cbar("Up0",2.29,11.06,3.18,1.80,-49,0,0.00)
        cbar("Up1",4.05,9.35,3.18,1.80,-38,0,0.00)
        cbar("Up2",6.10,8.01,3.18,1.80,-27,0,0.00)
        cbar("Up3",8.37,7.09,3.18,1.80,-16,0,0.00)
        cbar("Up4",10.78,6.62,3.18,1.80,-5,0,0.00)
        cbar("Up5",13.22,6.62,3.18,1.80,5,0,0.00)
        cbar("Up6",15.63,7.09,3.18,1.80,16,0,0.00)
        cbar("Up7",17.90,8.01,3.18,1.80,27,0,0.00)
        cbar("Up8",19.95,9.35,3.18,1.80,38,0,0.00)
        cbar("Up9",21.71,11.06,3.18,1.80,49,0,0.00)
        cbar("Lo0",2.29,12.94,3.18,1.80,49,0,0.00)
        cbar("Lo1",4.05,14.65,3.18,1.80,38,0,0.00)
        cbar("Lo2",6.10,15.99,3.18,1.80,27,0,0.00)
        cbar("Lo3",8.37,16.91,3.18,1.80,16,0,0.00)
        cbar("Lo4",10.78,17.38,3.18,1.80,5,0,0.00)
        cbar("Lo5",13.22,17.38,3.18,1.80,-5,0,0.00)
        cbar("Lo6",15.63,16.91,3.18,1.80,-16,0,0.00)
        cbar("Lo7",17.90,15.99,3.18,1.80,-27,0,0.00)
        cbar("Lo8",19.95,14.65,3.18,1.80,-38,0,0.00)
        cbar("Lo9",21.71,12.94,3.18,1.80,-49,0,0.00)
        cdisc("Iris",12.00,12.00,6.40,0.00)
    elseif kind=="movement" then
        -- Double chevron (sprint / speed)
        cbar("B1U",8.40,8.60,8.90,2.20,45,1,0.00)
        cbar("B1D",8.40,15.40,8.90,2.20,-45,1,0.00)
        cbar("B2U",15.60,8.60,8.90,2.20,45,1,0.00)
        cbar("B2D",15.60,15.40,8.90,2.20,-45,1,0.00)
    elseif kind=="config" then
        -- Gear: hub ring + 8 teeth + core
        cring("Hub",12.00,12.00,12.50,2.20)
        cbar("Tooth0",20.90,12.00,4.20,3.20,0,1,0.00)
        cbar("Tooth1",18.29,18.29,4.20,3.20,45,1,0.00)
        cbar("Tooth2",12.00,20.90,4.20,3.20,90,1,0.00)
        cbar("Tooth3",5.71,18.29,4.20,3.20,135,1,0.00)
        cbar("Tooth4",3.10,12.00,4.20,3.20,180,1,0.00)
        cbar("Tooth5",5.71,5.71,4.20,3.20,225,1,0.00)
        cbar("Tooth6",12.00,3.10,4.20,3.20,270,1,0.00)
        cbar("Tooth7",18.29,5.71,4.20,3.20,315,1,0.00)
        cdisc("Core",12.00,12.00,3.00,0.00)
    else
        -- fallback: clean hexagonal dot
        local dot=px("Dot",UDim2.new(0,12,0,12),UDim2.new(0,6,0,6),4,1)
        local dst=Instance.new("UIStroke",dot); dst.Thickness=1.5; dst.Color=C.tabIdleTx
    end

    end -- drawFallback

    -- Sleepy glyph first; drawn icon only if no glyph is available / it never loads
    local asset, isFile = SBI_resolve(SBI_MAP[kind])
    if asset then
        local img = Instance.new("ImageLabel", holder)
        img.Name = "Glyph"
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Size = UDim2.new(0, 22, 0, 22)
        img.BackgroundTransparency = 1; img.BorderSizePixel = 0
        img.Image = asset
        img.ImageColor3 = C.tabIdleTx
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = 8
        if not isFile then
            task.delay(2.5, function()
                if img.Parent and not img.IsLoaded then img:Destroy(); drawFallback() end
            end)
        end
    else
        drawFallback()
    end

    return holder
end

-- build rows
local sideY=12
local currentSection=nil
for _,key in ipairs(MAIN_TABS) do
    local def=TAB_DEFS[key]
    if def.section~=currentSection then
        if currentSection~=nil then sideY=sideY+12 end
        makeSideSection(def.section,sideY)
        sideY=sideY+22
        currentSection=def.section
    end

    local btn=Instance.new("TextButton",sidebar)
    btn.Name="SideTab_"..key
    btn.AutoButtonColor=false
    btn.Text=""
    btn.BackgroundColor3=Color3.fromRGB(26,18,42)
    btn.BackgroundTransparency=1
    btn.Position=UDim2.new(0,10,0,sideY)
    btn.Size=UDim2.new(1,-20,0,34)
    btn.ZIndex=6
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)

    makeSideIcon(btn, def.icon)

    local lbl=Instance.new("TextLabel",btn)
    lbl.Name="Label"
    lbl.Size=UDim2.new(1,-54,1,0)
    lbl.Position=UDim2.new(0,42,0,0)
    lbl.BackgroundTransparency=1
    lbl.Text=string.upper(def.label)
    lbl.TextColor3=C.tabIdleTx
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=11
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.ZIndex=7

    btn.MouseEnter:Connect(function()
        if key~=activeMainTab then paintRow(key,false,true) end
    end)
    btn.MouseLeave:Connect(function()
        if key~=activeMainTab then paintRow(key,false,false) end
    end)
    btn.MouseButton1Click:Connect(function() switchMainTab(key) end)

    mainTabBtns[key]=btn
    sideY=sideY+38
end

-- initial state
for _,key in ipairs(MAIN_TABS) do
    paintRow(key,key==activeMainTab,false)
end

local function makeTabScroll(name)
    local scroll=Instance.new("ScrollingFrame",contentArea)
    scroll.Name="Tab_"..name
    scroll.Position=UDim2.new(0,0,0,36); scroll.Size=UDim2.new(1,0,1,-36)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3; scroll.ScrollBarImageColor3=C.accent
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new(0,0,0,0)
    scroll.Visible=(name==activeMainTab); scroll.ZIndex=4
    local ll=Instance.new("UIListLayout",scroll)
    ll.Padding=UDim.new(0,6); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local pad=Instance.new("UIPadding",scroll)
    pad.PaddingRight=UDim.new(0,4); pad.PaddingTop=UDim.new(0,4); pad.PaddingBottom=UDim.new(0,8)
    mainTabFrames[name]=scroll
    return scroll
end

local function makeToggleRow(parent, label, defaultOn, onToggle)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.rowBg
    row.BackgroundTransparency=C.rowAlpha; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local rs=Instance.new("UIStroke",row); rs.Color=C.rowStroke; rs.Thickness=1
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.68,0,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.rowLabel
    lbl.Font=Enum.Font.Gotham; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local pill=Instance.new("Frame",row)
    pill.Name="Pill"
    pill.Size=UDim2.new(0,46,0,24); pill.Position=UDim2.new(1,-58,0.5,-12); pill.BorderSizePixel=0
    pill.ZIndex=3
    Instance.new("UICorner",pill).CornerRadius=UDim.new(0,12)
    local pStroke=Instance.new("UIStroke",pill)
    pStroke.Thickness=1; pStroke.Color=C.rowStroke; pStroke.Transparency=0.2
    local dot=Instance.new("Frame",pill)
    dot.Name="Dot"
    dot.Size=UDim2.new(0,18,0,18); dot.BorderSizePixel=0; dot.BackgroundColor3=Color3.fromRGB(255,255,255)
    dot.ZIndex=4
    Instance.new("UICorner",dot).CornerRadius=UDim.new(0,9)
    local on=defaultOn
    local function updatePill()
        local ti=TweenInfo.new(0.14)
        TweenService:Create(pill,ti,{BackgroundColor3=on and C.pillOn or C.pillOff}):Play()
        TweenService:Create(pStroke,ti,{
            Color=on and C.accent or C.rowStroke,
            Transparency=on and 0 or 0.2
        }):Play()
        TweenService:Create(dot,ti,{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        }):Play()
    end
    updatePill()
    local btn=Instance.new("TextButton",row)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.MouseButton1Click:Connect(function() on=not on; updatePill(); if onToggle then pcall(onToggle,on) end end)
    return row
end

local function makeStepperRow(parent, label, defaultVal, minVal, maxVal, step, onChange)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.rowBg
    row.BackgroundTransparency=C.rowAlpha; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local rs=Instance.new("UIStroke",row); rs.Color=C.rowStroke; rs.Thickness=1
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.rowLabel
    lbl.Font=Enum.Font.Gotham; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local cur=defaultVal or minVal
    local valLbl=Instance.new("TextLabel",row)
    valLbl.Size=UDim2.new(0.18,0,1,0); valLbl.Position=UDim2.new(0.55,0,0,0)
    valLbl.BackgroundTransparency=1; valLbl.Text=tostring(cur)
    valLbl.TextColor3=C.rowValue; valLbl.Font=Enum.Font.GothamBold; valLbl.TextSize=12
    local function setVal(v)
        cur=math.clamp(v,minVal,maxVal); valLbl.Text=tostring(cur)
        if onChange then pcall(onChange,cur) end
    end
    local dec=Instance.new("TextButton",row)
    dec.Size=UDim2.new(0,26,0,22); dec.Position=UDim2.new(1,-58,0.5,-11)
    dec.BackgroundColor3=Color3.fromRGB(24,18,36); dec.Text="-"; dec.TextColor3=C.accent
    dec.Font=Enum.Font.GothamBold; dec.TextSize=13
    Instance.new("UICorner",dec).CornerRadius=UDim.new(0,6)
    dec.MouseButton1Click:Connect(function() setVal(cur-step) end)
    local inc=Instance.new("TextButton",row)
    inc.Size=UDim2.new(0,26,0,22); inc.Position=UDim2.new(1,-28,0.5,-11)
    inc.BackgroundColor3=Color3.fromRGB(24,18,36); inc.Text="+"; inc.TextColor3=C.accent
    inc.Font=Enum.Font.GothamBold; inc.TextSize=13
    Instance.new("UICorner",inc).CornerRadius=UDim.new(0,6)
    inc.MouseButton1Click:Connect(function() setVal(cur+step) end)
    return row
end

local function makeButtonRow(parent, label, btnText, onClick)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.rowBg
    row.BackgroundTransparency=C.rowAlpha; row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local rs=Instance.new("UIStroke",row); rs.Color=C.rowStroke; rs.Thickness=1
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.rowLabel
    lbl.Font=Enum.Font.Gotham; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local b=Instance.new("TextButton",row)
    b.Size=UDim2.new(0,90,0,24); b.Position=UDim2.new(1,-98,0.5,-12)
    b.BackgroundColor3=C.accentDim; b.Text=btnText; b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold; b.TextSize=11
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function() if onClick then pcall(onClick) end end)
    return row
end

-- Build pages
local aimPage  = makeTabScroll("AIM")
local visPage  = makeTabScroll("VISUALS")
local movePage = makeTabScroll("MOVE")
local cfgPage  = makeTabScroll("CONFIG")

-- AIM tab
makeToggleRow(aimPage, "Silent Aim",                Config.SilentAim,     function(v) Config.SilentAim=v end)
do
    -- HEAD / BODY split row
    local splitRow = Instance.new("Frame", aimPage)
    splitRow.Size = UDim2.new(1, 0, 0, 56)
    splitRow.BackgroundColor3 = C.rowBg
    splitRow.BackgroundTransparency = C.rowAlpha
    splitRow.BorderSizePixel = 0
    Instance.new("UICorner", splitRow).CornerRadius = UDim.new(0, 10)
    local rs2 = Instance.new("UIStroke", splitRow); rs2.Color = C.rowStroke; rs2.Thickness = 1

    -- label top
    local splitLbl = Instance.new("TextLabel", splitRow)
    splitLbl.Size = UDim2.new(1, -16, 0, 14)
    splitLbl.Position = UDim2.new(0, 12, 0, 6)
    splitLbl.BackgroundTransparency = 1
    splitLbl.Text = "Headshot Ratio"
    splitLbl.TextColor3 = C.rowLabel
    splitLbl.Font = Enum.Font.Gotham
    splitLbl.TextSize = 12
    splitLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- percentage labels
    local headPct = Instance.new("TextLabel", splitRow)
    headPct.Size = UDim2.new(0, 60, 0, 12)
    headPct.Position = UDim2.new(0, 12, 0, 22)
    headPct.BackgroundTransparency = 1
    headPct.Font = Enum.Font.GothamBold; headPct.TextSize = 11
    headPct.TextXAlignment = Enum.TextXAlignment.Left
    headPct.TextColor3 = Color3.fromRGB(180, 100, 255)

    local bodyPct = Instance.new("TextLabel", splitRow)
    bodyPct.Size = UDim2.new(0, 80, 0, 12)
    bodyPct.Position = UDim2.new(1, -92, 0, 22)
    bodyPct.BackgroundTransparency = 1
    bodyPct.Font = Enum.Font.GothamBold; bodyPct.TextSize = 11
    bodyPct.TextXAlignment = Enum.TextXAlignment.Right
    bodyPct.TextColor3 = Color3.fromRGB(100, 200, 255)

    -- bar background
    local barBg = Instance.new("Frame", splitRow)
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 38)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    barBg.BorderSizePixel = 0
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 4)

    -- head fill (purple)
    local headFill = Instance.new("Frame", barBg)
    headFill.Position = UDim2.new(0, 0, 0, 0)
    headFill.BackgroundColor3 = Color3.fromRGB(130, 68, 255)
    headFill.BorderSizePixel = 0
    Instance.new("UICorner", headFill).CornerRadius = UDim.new(0, 4)

    -- body fill (blue)
    local bodyFill = Instance.new("Frame", barBg)
    bodyFill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
    bodyFill.BorderSizePixel = 0
    Instance.new("UICorner", bodyFill).CornerRadius = UDim.new(0, 4)

    local function updateSplitBar()
        local h = math.clamp(Config.HeadRatio, 0, 100)
        local b = 100 - h
        headFill.Size = UDim2.new(h / 100, 0, 1, 0)
        bodyFill.Size = UDim2.new(b / 100, 0, 1, 0)
        bodyFill.Position = UDim2.new(h / 100, 0, 0, 0)
        headPct.Text = "Head " .. h .. "%"
        bodyPct.Text = "Body " .. b .. "%"
    end
    updateSplitBar()

    -- dec / inc buttons
    local dec2 = Instance.new("TextButton", splitRow)
    dec2.Size = UDim2.new(0, 26, 0, 22); dec2.Position = UDim2.new(0, 12, 0, 20)
    -- invisible, we use a bigger invisible overlay row below

    -- stepper buttons on the right of label
    local decBtn = Instance.new("TextButton", splitRow)
    decBtn.Size = UDim2.new(0, 26, 0, 20)
    decBtn.Position = UDim2.new(1, -62, 0, 4)
    decBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
    decBtn.Text = "-"; decBtn.TextColor3 = C.accent
    decBtn.Font = Enum.Font.GothamBold; decBtn.TextSize = 13
    Instance.new("UICorner", decBtn).CornerRadius = UDim.new(0, 6)
    decBtn.MouseButton1Click:Connect(function()
        Config.HeadRatio = math.clamp(Config.HeadRatio - 1, 0, 100)
        updateSplitBar()
    end)

    local incBtn = Instance.new("TextButton", splitRow)
    incBtn.Size = UDim2.new(0, 26, 0, 20)
    incBtn.Position = UDim2.new(1, -32, 0, 4)
    incBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
    incBtn.Text = "+"; incBtn.TextColor3 = C.accent
    incBtn.Font = Enum.Font.GothamBold; incBtn.TextSize = 13
    Instance.new("UICorner", incBtn).CornerRadius = UDim.new(0, 6)
    incBtn.MouseButton1Click:Connect(function()
        Config.HeadRatio = math.clamp(Config.HeadRatio + 1, 0, 100)
        updateSplitBar()
    end)

    -- cleanup the invisible extra button
    dec2:Destroy()
end
makeStepperRow(aimPage,"FOV Radius",                 Config.FOVRadius, 40, 500, 10, function(v) Config.FOVRadius=v; if FOVCircle then FOVCircle.Radius=v end end)
makeToggleRow(aimPage, "Draw FOV Circle",           Config.DrawFOV,       function(v) Config.DrawFOV=v; if FOVCircle then FOVCircle.Visible=v end end)
makeToggleRow(aimPage, "Wall Check",                Config.WallCheck,     function(v) Config.WallCheck=v end)
makeToggleRow(aimPage, "Team Check",                Config.TeamCheck,     function(v) Config.TeamCheck=v; Config.ESP_TeamCheck=v end)
makeToggleRow(aimPage, "No Recoil",                 Config.NoRecoil,      function(v) Config.NoRecoil=v end)
makeToggleRow(aimPage, "No Bloom",                  Config.NoBloom,       function(v) Config.NoBloom=v end)

-- VISUALS tab
makeToggleRow(visPage, "ESP Master Switch",         Config.ESP_Master,    function(v) Config.ESP_Master=v end)
makeToggleRow(visPage, "Player Box ESP",            Config.ESP_Box,       function(v) Config.ESP_Box=v end)
makeToggleRow(visPage, "Health Bar",                Config.ESP_Health,    function(v) Config.ESP_Health=v end)
makeToggleRow(visPage, "Player Names",              Config.ESP_Names,     function(v) Config.ESP_Names=v end)
makeToggleRow(visPage, "Distance Labels",           Config.ESP_Distance,  function(v) Config.ESP_Distance=v end)
makeToggleRow(visPage, "Snapline Tracers",          Config.ESP_Tracers,   function(v) Config.ESP_Tracers=v end)
makeToggleRow(visPage, "Show Admin Roles",          Config.ESP_Roles,       function(v) Config.ESP_Roles=v end)
makeToggleRow(visPage, "Full Skeleton (R15)",       Config.ESP_Skeleton,    function(v) Config.ESP_Skeleton=v end)
makeToggleRow(visPage, "Head Circle",               Config.ESP_Head,        function(v) Config.ESP_Head=v end)
makeToggleRow(visPage, "Show Level (Lv.X)",         Config.ESP_Level,       function(v) Config.ESP_Level=v end)
makeToggleRow(visPage, "Show Rank Name",            Config.ESP_Rank,        function(v) Config.ESP_Rank=v end)
makeToggleRow(visPage, "Real-time Firing Alert",    Config.ESP_FiringAlert, function(v) Config.ESP_FiringAlert=v end)
makeToggleRow(visPage, "Status Alerts (Heal/Prot)", Config.ESP_Alerts,      function(v) Config.ESP_Alerts=v end)
makeStepperRow(visPage,"Max ESP Distance",           Config.ESP_MaxDistance, 50, 1000, 50, function(v) Config.ESP_MaxDistance=v end)

-- MOVE tab
makeToggleRow(movePage,"Speed Boost",               Config.SpeedBoost,    function(v) Config.SpeedBoost=v end)
makeStepperRow(movePage,"Boost Speed Value",        Config.SpeedValue, 16, 75, 2, function(v) Config.SpeedValue=v end)
makeToggleRow(movePage,"Auto Sprint",               Config.AutoSprint,    function(v) Config.AutoSprint=v end)
makeToggleRow(movePage,"Infinite Stamina",          Config.InfiniteStamina, function(v) Config.InfiniteStamina=v end)
makeToggleRow(movePage,"Infinite Jump",             Config.InfiniteJump,  function(v) Config.InfiniteJump=v end)

-- CONFIG tab
makeButtonRow(cfgPage,"Unload Script","Destroy",function()
    pcall(function() GStore.CLAN_RESPECT_CLEANUP() end)
end)

-- Mobile FAB
local mobileFab=Instance.new("TextButton",ScreenGui)
mobileFab.Name="CLAN_MobileToggle"; mobileFab.Size=UDim2.new(0,46,0,46)
mobileFab.Position=UDim2.new(0,16,0.45,-23); mobileFab.BackgroundColor3=Color3.fromRGB(16,12,24)
mobileFab.BackgroundTransparency=0.15; mobileFab.BorderSizePixel=0
mobileFab.Text="CLAN"; mobileFab.TextColor3=Color3.fromRGB(245,190,35)
mobileFab.Font=Enum.Font.GothamBold; mobileFab.TextSize=13; mobileFab.ZIndex=200
Instance.new("UICorner",mobileFab).CornerRadius=UDim.new(0,23)
local mfs=Instance.new("UIStroke",mobileFab); mfs.Color=Color3.fromRGB(214,160,30); mfs.Thickness=1.6
mobileFab.MouseButton1Click:Connect(toggleMenu)

-- Keyboard toggle
regConn(UserInputService.InputBegan:Connect(function(inp, gpe)
    if inp.UserInputType==Enum.UserInputType.Keyboard and inp.KeyCode==Config.MenuKey then
        toggleMenu()
    end
end))

-- ── Cleanup (idempotent: safe to call any number of times) ─────────
GStore.CLAN_RESPECT_CLEANUP = function()
    GStore.CLAN_SCRIPT_ID = nil
    for _, conn in ipairs(State.Connections) do pcall(function() conn:Disconnect() end) end
    State.Connections = {}
    State.ESPCache = State.ESPCache or {}
    for _, esp in pairs(State.ESPCache) do pcall(destroyESP, esp) end
    State.ESPCache = {}
    if FOVCircle then pcall(function() FOVCircle:Remove() end); FOVCircle=nil; GStore._CLAN_FOVCircle=nil end
    if ESPGui then pcall(function() ESPGui:Destroy() end); ESPGui=nil; GStore._CLAN_ESPGui=nil end
    if ScreenGui then pcall(function() ScreenGui:Destroy() end); ScreenGui=nil end
    hardSweep()
    pcall(function() ContextActionService:UnbindAction("TK4_CamSink") end)
    pcall(function() ContextActionService:UnbindAction("TK4_CamSink_v2") end)
    pcall(function() ContextActionService:UnbindAction("TK4_CamSink_old") end)
    if GStore._TK4_MouseConn then
        pcall(function() GStore._TK4_MouseConn:Disconnect() end)
        GStore._TK4_MouseConn = nil
    end
    print("[CLAN V3] Cleaned up.")
end

print("[CLAN V3.1] Loaded! Sidebar UI + TK4 ESP engine active. Press [K] to toggle menu.")
