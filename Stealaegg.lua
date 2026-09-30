--[[
    Vertex Menu (FAKE / TROLL)
    Nao faz nada de verdade: so UI, logs falsos no F9 e tela branca.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- tenta colocar em lugar "escondido", senao cai no PlayerGui
local function getGuiParent()
    local ok, ui = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if ok and ui then return ui end
    return player:WaitForChild("PlayerGui")
end

-- remove versao antiga
local parent = getGuiParent()
local old = parent:FindFirstChild("VertexMenu")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "VertexMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

-- helpers
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 90
    g.Parent = obj
    return g
end

local ACCENT = Color3.fromRGB(139, 92, 246)
local ACCENT2 = Color3.fromRGB(99, 102, 241)

-- janela principal
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(420, 300)
main.Position = UDim2.new(0.5, -210, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 14)
stroke(main, ACCENT, 1.5, 0.3)
gradient(main, Color3.fromRGB(22, 20, 34), Color3.fromRGB(12, 12, 18), 90)

-- topbar
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 44)
top.BackgroundTransparency = 1
top.Parent = main

local logo = Instance.new("TextLabel")
logo.Size = UDim2.fromOffset(28, 28)
logo.Position = UDim2.fromOffset(14, 8)
logo.BackgroundColor3 = ACCENT
logo.Text = "V"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 16
logo.TextColor3 = Color3.new(1, 1, 1)
logo.Parent = top
corner(logo, 8)
gradient(logo, ACCENT, ACCENT2, 45)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.fromOffset(50, 0)
title.BackgroundTransparency = 1
title.Text = "Vertex Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.Parent = top

local version = Instance.new("TextLabel")
version.Size = UDim2.fromOffset(60, 18)
version.Position = UDim2.new(1, -110, 0, 13)
version.BackgroundColor3 = Color3.fromRGB(34, 30, 54)
version.Text = "v2.4.1"
version.Font = Enum.Font.GothamMedium
version.TextSize = 11
version.TextColor3 = Color3.fromRGB(180, 160, 255)
version.Parent = top
corner(version, 9)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(34, 30, 54)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.fromRGB(255, 120, 120)
close.AutoButtonColor = true
close.Parent = top
corner(close, 8)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local line = Instance.new("Frame")
line.Size = UDim2.new(1, -28, 0, 1)
line.Position = UDim2.fromOffset(14, 44)
line.BackgroundColor3 = ACCENT
line.BackgroundTransparency = 0.7
line.BorderSizePixel = 0
line.Parent = main

-- drag
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- lista de toggles fake
local list = Instance.new("Frame")
list.Size = UDim2.new(1, -28, 0, 140)
list.Position = UDim2.fromOffset(14, 56)
list.BackgroundTransparency = 1
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

local function makeToggle(name)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(24, 22, 36)
    row.Parent = list
    corner(row, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.fromOffset(14, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(215, 215, 235)
    label.Parent = row

    local track = Instance.new("TextButton")
    track.Size = UDim2.fromOffset(40, 20)
    track.Position = UDim2.new(1, -54, 0.5, -10)
    track.BackgroundColor3 = Color3.fromRGB(50, 46, 72)
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = row
    corner(track, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = track
    corner(knob, 8)

    local on = false
    track.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(track, TweenInfo.new(0.2), {
            BackgroundColor3 = on and ACCENT or Color3.fromRGB(50, 46, 72)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = on and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
        }):Play()
    end)
end

makeToggle("Auto Collect")
makeToggle("Anti AFK")
makeToggle("Speed Boost")

-- botao principal
local start = Instance.new("TextButton")
start.Size = UDim2.new(1, -28, 0, 46)
start.Position = UDim2.new(0, 14, 1, -60)
start.BackgroundColor3 = ACCENT
start.Text = "Iniciar Auto Farm"
start.Font = Enum.Font.GothamBold
start.TextSize = 16
start.TextColor3 = Color3.new(1, 1, 1)
start.AutoButtonColor = false
start.Parent = main
corner(start, 12)
gradient(start, ACCENT, ACCENT2, 0)
stroke(start, Color3.fromRGB(190, 160, 255), 1, 0.5)

start.MouseEnter:Connect(function()
    TweenService:Create(start, TweenInfo.new(0.15), { Size = UDim2.new(1, -20, 0, 48) }):Play()
end)
start.MouseLeave:Connect(function()
    TweenService:Create(start, TweenInfo.new(0.15), { Size = UDim2.new(1, -28, 0, 46) }):Play()
end)

-- logs falsos
local fakeLogs = {
    "[Vertex] Injecting hook into RemoteEvent 'CollectEgg'...",
    "[Vertex] Bypassing anti-cheat module (layer %d/5)",
    "[Vertex] Scanning workspace.Eggs... found %d targets",
    "[Vertex] Spoofing WalkSpeed = %d",
    "[Vertex] Hooked __namecall successfully",
    "[Vertex] Sending packet 0x%X to server",
    "[Vertex] Teleporting to egg spawn (%d, %d, %d)",
    "[Vertex] Decrypting session token...",
    "[Vertex] Handshake OK (ping: %dms)",
    "[Vertex] Patching memory at 0x%X",
    "[Vertex] Loading payload chunk %d/12",
    "[Vertex] Farm loop tick #%d",
    "[Vertex] Eggs collected: %d",
    "[Vertex] Fetching remote config from vertex-api...",
    "[Vertex] Rotating proxy node %d",
    "[Vertex] Flushing cache...",
}

local warnLogs = {
    "[Vertex] Warning: rate limit near threshold",
    "[Vertex] Warning: unstable connection, retrying...",
    "[Vertex] Warning: checksum mismatch, ignoring",
}

local function randomLog()
    local msg = fakeLogs[math.random(#fakeLogs)]
    msg = msg:gsub("%%d", function() return tostring(math.random(1, 9999)) end)
    msg = msg:gsub("%%X", function() return string.format("%X", math.random(0x1000, 0xFFFFFF)) end)
    return msg
end

-- limpeza local: apaga itens de construcao e ovos ligados ao player
-- (so no cliente, volta ao normal quando sair e entrar de novo)
local logsRunning = true
local keywords = { "build", "construc", "construÃ§", "egg", "ovo" }

local function matches(name)
    local n = string.lower(name)
    for _, k in ipairs(keywords) do
        if string.find(n, k, 1, true) then
            return true
        end
    end
    return false
end

local function wipeStuff()
    for _, root in ipairs({ player, player.Character }) do
        if root then
            for _, inst in ipairs(root:GetDescendants()) do
                if inst ~= gui and not inst:IsDescendantOf(gui) and matches(inst.Name) then
                    pcall(function()
                        inst:Destroy()
                    end)
                end
            end
        end
    end
end

-- tela branca
local function whiteScreen()
    local white = Instance.new("Frame")
    white.Name = "White"
    white.Size = UDim2.fromScale(1, 1)
    white.BackgroundColor3 = Color3.new(1, 1, 1)
    white.BorderSizePixel = 0
    white.ZIndex = 100
    white.Active = true -- bloqueia cliques
    white.BackgroundTransparency = 1
    white.Parent = gui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = "ROUBANDO TODOS OS SEUS OVOS"
    text.Font = Enum.Font.GothamBold
    text.TextSize = 38
    text.TextWrapped = true
    text.TextColor3 = Color3.new(0, 0, 0)
    text.TextTransparency = 1
    text.ZIndex = 101
    text.Parent = white

    -- bloqueia todas as teclas do teclado dentro do jogo
    local CAS = game:GetService("ContextActionService")
    local keys = {}
    for _, key in ipairs(Enum.KeyCode:GetEnumItems()) do
        if key ~= Enum.KeyCode.Unknown then
            table.insert(keys, key)
        end
    end
    CAS:BindActionAtPriority("VertexBlockKeys", function()
        return Enum.ContextActionResult.Sink
    end, false, 3000, unpack(keys))

    TweenService:Create(white, TweenInfo.new(0.6), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(text, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

    -- sequencia: 10s "roubando", depois "ovos roubados", limpa tudo e some
    task.spawn(function()
        local t0 = os.clock()
        local dots = 0
        while os.clock() - t0 < 10 and white.Parent do
            dots = (dots % 3) + 1
            text.Text = "ROUBANDO TODOS OS SEUS OVOS" .. string.rep(".", dots)
            task.wait(0.5)
        end
        if not white.Parent then return end

        text.Text = "OVOS ROUBADOS"
        wipeStuff()
        logsRunning = false
        task.wait(2.5)

        game:GetService("ContextActionService"):UnbindAction("VertexBlockKeys")
        player:Kick("ovos roubados, base zerada!")
    end)
end

local started = false
start.MouseButton1Click:Connect(function()
    if started then return end
    started = true
    start.Text = "Farmando..."

    -- spam de logs no console (F9)
    task.spawn(function()
        print("[Vertex] Auto Farm started")
        while gui.Parent and logsRunning do
            if math.random() < 0.12 then
                warn(warnLogs[math.random(#warnLogs)])
            else
                print(randomLog())
            end
            task.wait(math.random() * 0.25 + 0.03)
        end
    end)

    task.delay(0.4, whiteScreen)
end)
