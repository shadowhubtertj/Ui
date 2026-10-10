# -- ==========================================================
-- KYÔKA HUB • INTERFACE GRAFICA (WINDUI)
-- Project Slayers 2 BY SHADOW
-- ==========================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local parentContainer = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") or CoreGui)
local Flags = getgenv().KyokaFlags
local Core = getgenv().KyokaCore

-- [1] CARREGAMENTO WINDUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [2] CRIAÇÃO DA JANELA PRINCIPAL
local Window = WindUI:CreateWindow({
    Title = "Kyôka Hub",
    SubTitle = "Project Slayers 2 BY SHADOW",
    Folder = "KyokaHub",
    Size = UDim2.fromOffset(620, 460),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 160,
    HasOutline = true
})

local Tabs = {
    Home     = Window:Tab({ Title = "Início",    Icon = "home" }),
    Farm     = Window:Tab({ Title = "Auto Farm", Icon = "sword" }),
    Combat   = Window:Tab({ Title = "Combate",   Icon = "zap" }),
    Visuals  = Window:Tab({ Title = "Visuals",   Icon = "eye" }),
    Teleport = Window:Tab({ Title = "Teleportes",Icon = "map-pin" }),
    Misc     = Window:Tab({ Title = "Utilidades",Icon = "package" }),
    Settings = Window:Tab({ Title = "Ajustes",   Icon = "settings" })
}

-- ABA INÍCIO
Tabs.Home:Section({ Title = "Painel Principal" })
Tabs.Home:Paragraph({
    Title = "Bem-vindo, " .. LocalPlayer.DisplayName .. "!",
    Desc = "Jogador: @" .. LocalPlayer.Name .. "\nNível Atual: " .. (Core.GetLevel and Core.GetLevel() or "N/A")
})
Tabs.Home:Button({
    Title = "Copiar Link do Discord",
    Callback = function()
        if setclipboard then setclipboard("https://discord.gg/9e8RASjRR") end
        WindUI:Notify({ Title = "Discord", Content = "Link copiado com sucesso!", Duration = 3 })
    end
})

-- ABA AUTO FARM
Tabs.Farm:Section({ Title = "Opções de Farm" })
Tabs.Farm:Toggle({ Title = "Auto Farm Geral (Fly + NoClip)", Default = false, Callback = function(v) Flags.AutoFarmLevel = v end })
Tabs.Farm:Toggle({ Title = "Auto Farm Mob Selecionado", Default = false, Callback = function(v) Flags.AutoFarmMob = v end })
Tabs.Farm:Dropdown({
    Title = "Selecionar Mob",
    Values = { "Bandit", "Demon", "Soryu Trainee", "Snow Demon", "Yowai", "Zahab" },
    Default = "Bandit",
    Callback = function(v) Flags.SelectedMob = v end
})

-- ABA COMBATE
Tabs.Combat:Section({ Title = "Opções de Ataque" })
Tabs.Combat:Toggle({ Title = "Auto Clicker (M1 Attack)", Default = false, Callback = function(v) Flags.AutoAttack = v end })
Tabs.Combat:Toggle({ Title = "Auto Skill", Default = false, Callback = function(v) Flags.AutoSkill = v end })
Tabs.Combat:Dropdown({
    Title = "Tecla da Skill",
    Values = { "Q", "E", "R", "F", "V", "Z", "X", "C" },
    Default = "Q",
    Callback = function(v) Flags.SelectedSkill = v end
})

-- ABA VISUAIS
Tabs.Visuals:Section({ Title = "Proteções e Iluminação" })
Tabs.Visuals:Toggle({ Title = "Anti Sun Damage", Default = false, Callback = function(v) Flags.AntiSun = v end })
Tabs.Visuals:Toggle({ Title = "Anti Drown Damage", Default = false, Callback = function(v) Flags.AntiDrown = v end })
Tabs.Visuals:Toggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(v)
        Flags.Fullbright = v
        game:GetService("Lighting").Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
    end
})

-- ABA TELEPORTES
Tabs.Teleport:Section({ Title = "Locais Principais" })
local locs = {
    ["Spawn"] = Vector3.new(0, 50, 0),
    ["Zahab Town"] = Vector3.new(150, 20, -300),
    ["Butterfly Mansion"] = Vector3.new(-400, 30, 200)
}
Tabs.Teleport:Dropdown({
    Title = "Teleportar Para",
    Values = { "Spawn", "Zahab Town", "Butterfly Mansion" },
    Default = "Spawn",
    Callback = function(dest)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and locs[dest] then hrp.CFrame = CFrame.new(locs[dest]) end
    end
})

-- ABA UTILIDADES
Tabs.Misc:Section({ Title = "Automações" })
Tabs.Misc:Toggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(state)
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if state then
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
})

-- ABA AJUSTES
Tabs.Settings:Section({ Title = "Tema" })
Tabs.Settings:Dropdown({
    Title = "Cor do Tema",
    Values = { "Dark", "Red", "Blue", "Green", "Purple" },
    Default = "Dark",
    Callback = function(t) if Window.SetTheme then Window:SetTheme(t) end end
})
Tabs.Settings:Button({
    Title = "Destruir Hub",
    Callback = function()
        if parentContainer:FindFirstChild("KyokaHub_ToggleBtn") then
            parentContainer.KyokaHub_ToggleBtn:Destroy()
        end
        Window:Destroy()
    end
})

-- [3] BOTÃO FLUTUANTE ARRASTÁVEL "K"
if parentContainer:FindFirstChild("KyokaHub_ToggleBtn") then
    parentContainer.KyokaHub_ToggleBtn:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "KyokaHub_ToggleBtn"
ToggleGui.Parent = parentContainer
ToggleGui.ResetOnSpawn = false

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingButton"
FloatingBtn.Parent = ToggleGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Text = "K"
FloatingBtn.TextColor3 = Color3.fromRGB(235, 50, 50)
FloatingBtn.TextSize = 24
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Active = true

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(1, 0)
fCorner.Parent = FloatingBtn

local fStroke = Instance.new("UIStroke")
fStroke.Color = Color3.fromRGB(235, 50, 50)
fStroke.Transparency = 0.2
fStroke.Thickness = 2
fStroke.Parent = FloatingBtn

l-- ==========================================================
-- KYÔKA HUB • INTERFACE GRAFICA (WINDUI)
-- Project Slayers 2 BY SHADOW
-- ==========================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local parentContainer = (gethui and gethui()) or (CoreGui:FindFirstChild("RobloxGui") or CoreGui)
local Flags = getgenv().KyokaFlags
local Core = getgenv().KyokaCore

-- [1] CARREGAMENTO WINDUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [2] CRIAÇÃO DA JANELA PRINCIPAL
local Window = WindUI:CreateWindow({
    Title = "Kyôka Hub",
    SubTitle = "Project Slayers 2 BY SHADOW",
    Folder = "KyokaHub",
    Size = UDim2.fromOffset(620, 460),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 160,
    HasOutline = true
})

local Tabs = {
    Home     = Window:Tab({ Title = "Início",    Icon = "home" }),
    Farm     = Window:Tab({ Title = "Auto Farm", Icon = "sword" }),
    Combat   = Window:Tab({ Title = "Combate",   Icon = "zap" }),
    Visuals  = Window:Tab({ Title = "Visuals",   Icon = "eye" }),
    Teleport = Window:Tab({ Title = "Teleportes",Icon = "map-pin" }),
    Misc     = Window:Tab({ Title = "Utilidades",Icon = "package" }),
    Settings = Window:Tab({ Title = "Ajustes",   Icon = "settings" })
}

-- ABA INÍCIO
Tabs.Home:Section({ Title = "Painel Principal" })
Tabs.Home:Paragraph({
    Title = "Bem-vindo, " .. LocalPlayer.DisplayName .. "!",
    Desc = "Jogador: @" .. LocalPlayer.Name .. "\nNível Atual: " .. (Core.GetLevel and Core.GetLevel() or "N/A")
})
Tabs.Home:Button({
    Title = "Copiar Link do Discord",
    Callback = function()
        if setclipboard then setclipboard("https://discord.gg/9e8RASjRR") end
        WindUI:Notify({ Title = "Discord", Content = "Link copiado com sucesso!", Duration = 3 })
    end
})

-- ABA AUTO FARM
Tabs.Farm:Section({ Title = "Opções de Farm" })
Tabs.Farm:Toggle({ Title = "Auto Farm Geral (Fly + NoClip)", Default = false, Callback = function(v) Flags.AutoFarmLevel = v end })
Tabs.Farm:Toggle({ Title = "Auto Farm Mob Selecionado", Default = false, Callback = function(v) Flags.AutoFarmMob = v end })
Tabs.Farm:Dropdown({
    Title = "Selecionar Mob",
    Values = { "Bandit", "Demon", "Soryu Trainee", "Snow Demon", "Yowai", "Zahab" },
    Default = "Bandit",
    Callback = function(v) Flags.SelectedMob = v end
})

-- ABA COMBATE
Tabs.Combat:Section({ Title = "Opções de Ataque" })
Tabs.Combat:Toggle({ Title = "Auto Clicker (M1 Attack)", Default = false, Callback = function(v) Flags.AutoAttack = v end })
Tabs.Combat:Toggle({ Title = "Auto Skill", Default = false, Callback = function(v) Flags.AutoSkill = v end })
Tabs.Combat:Dropdown({
    Title = "Tecla da Skill",
    Values = { "Q", "E", "R", "F", "V", "Z", "X", "C" },
    Default = "Q",
    Callback = function(v) Flags.SelectedSkill = v end
})

-- ABA VISUAIS
Tabs.Visuals:Section({ Title = "Proteções e Iluminação" })
Tabs.Visuals:Toggle({ Title = "Anti Sun Damage", Default = false, Callback = function(v) Flags.AntiSun = v end })
Tabs.Visuals:Toggle({ Title = "Anti Drown Damage", Default = false, Callback = function(v) Flags.AntiDrown = v end })
Tabs.Visuals:Toggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(v)
        Flags.Fullbright = v
        game:GetService("Lighting").Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
    end
})

-- ABA TELEPORTES
Tabs.Teleport:Section({ Title = "Locais Principais" })
local locs = {
    ["Spawn"] = Vector3.new(0, 50, 0),
    ["Zahab Town"] = Vector3.new(150, 20, -300),
    ["Butterfly Mansion"] = Vector3.new(-400, 30, 200)
}
Tabs.Teleport:Dropdown({
    Title = "Teleportar Para",
    Values = { "Spawn", "Zahab Town", "Butterfly Mansion" },
    Default = "Spawn",
    Callback = function(dest)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and locs[dest] then hrp.CFrame = CFrame.new(locs[dest]) end
    end
})

-- ABA UTILIDADES
Tabs.Misc:Section({ Title = "Automações" })
Tabs.Misc:Toggle({
    Title = "Anti-AFK",
    Default = true,
    Callback = function(state)
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if state then
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
})

-- ABA AJUSTES
Tabs.Settings:Section({ Title = "Tema" })
Tabs.Settings:Dropdown({
    Title = "Cor do Tema",
    Values = { "Dark", "Red", "Blue", "Green", "Purple" },
    Default = "Dark",
    Callback = function(t) if Window.SetTheme then Window:SetTheme(t) end end
})
Tabs.Settings:Button({
    Title = "Destruir Hub",
    Callback = function()
        if parentContainer:FindFirstChild("KyokaHub_ToggleBtn") then
            parentContainer.KyokaHub_ToggleBtn:Destroy()
        end
        Window:Destroy()
    end
})

-- [3] BOTÃO FLUTUANTE ARRASTÁVEL "K"
if parentContainer:FindFirstChild("KyokaHub_ToggleBtn") then
    parentContainer.KyokaHub_ToggleBtn:Destroy()
end

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "KyokaHub_ToggleBtn"
ToggleGui.Parent = parentContainer
ToggleGui.ResetOnSpawn = false

local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingButton"
FloatingBtn.Parent = ToggleGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Text = "K"
FloatingBtn.TextColor3 = Color3.fromRGB(235, 50, 50)
FloatingBtn.TextSize = 24
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Active = true

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(1, 0)
fCorner.Parent = FloatingBtn

local fStroke = Instance.new("UIStroke")
fStroke.Color = Color3.fromRGB(235, 50, 50)
fStroke.Transparency = 0.2
fStroke.Thickness = 2
fStroke.Parent = FloatingBtn

local dragging, dragInput, dragStart, startPos
local dragDistance = 0

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
        dragDistance = 0
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatingBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        FloatingBtn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

FloatingBtn.MouseButton1Click:Connect(function()
    if dragDistance < 5 and Window and Window.Toggle then
        Window:Toggle()
    end
end)

WindUI:Notify({ Title = "Kyôka Hub", Content = "Kyôka Hub 100% Carregado!", Duration = 3 })

local dragDistance = 0

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
        dragDistance = 0
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatingBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        dragDistance = delta.Magnitude
        FloatingBtn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

FloatingBtn.MouseButton1Click:Connect(function()
    if dragDistance < 5 and Window and Window.Toggle then
        Window:Toggle()
    end
end)

WindUI:Notify({ Title = "Kyôka Hub", Content = "Kyôka Hub 100% Carregado!", Duration = 3 })
 
