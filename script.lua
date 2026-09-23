--[[
    ===================================================================
    🎲 ROLL FOR ANIME! (LĂN CHO ANIME! 🎲) - ULTIMATE AUTO HUB V1.0
    Game: Roll for Anime! 🎲 (by Proton Laboratory)
    Tương thích 100% với Delta Executor (Android & PC), Codex, Wave, Hydrogen, Fluxus.
    
    Tính năng cốt lõi:
    1. ⚡ Auto Fast Roll (Bỏ qua Animation xúc xắc, roll siêu tốc liên tục)
    2. 🍀 Auto Upgrade Dice (Tự nâng cấp cấp bậc xúc xắc nhân Luck x2 -> x67+)
    3. 🧪 Auto Use Luck Potions & Clovers (Tự kích hoạt bình thuốc may mắn & cỏ 4 lá)
    4. 🧲 Auto Collect Map Drops (Tự hút cỏ may mắn, tiền xu, kim cương trên map)
    5. 🔄 Auto Rebirth (Tự chuyển sinh nhân may mắn vĩnh viễn)
    6. 🐾 Auto Equip & Place Best Anime (Tự trang bị & xếp Anime kiếm tiền nhanh nhất)
    7. 🗑️ Auto Delete / Skip Low Rarity (Tự dọn Anime thường, tránh đầy kho)
    8. 🎁 One-Click Redeem All Codes (Tự nhập toàn bộ Code lấy Potion & Lượt quay)
    9. 🏃 Tốc độ WalkSpeed, Lướt CFrame, Infinite Jump, Noclip & Float
    10. 🛡️ Anti-AFK 24/7 & FPS Booster treo máy xuyên đêm
    ===================================================================
--]]

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ── Safe GUI Container Helper ──
local function getGuiContainer()
    local container = nil
    pcall(function()
        if gethui then
            container = gethui()
        elseif syn and syn.protect_gui then
            local f = Instance.new("Folder")
            syn.protect_gui(f)
            f.Parent = game:GetService("CoreGui")
            container = f
        elseif game:GetService("CoreGui") then
            container = game:GetService("CoreGui")
        end
    end)
    if not container then
        pcall(function()
            container = LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    return container
end

-- Clear old GUI instances
pcall(function()
    local c = getGuiContainer()
    if c and c:FindFirstChild("RollAnimeHubGui") then
        c.RollAnimeHubGui:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("RollAnimeHubGui") then
        game:GetService("CoreGui").RollAnimeHubGui:Destroy()
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("RollAnimeHubGui") then
        LocalPlayer.PlayerGui.RollAnimeHubGui:Destroy()
    end
end)

-- ── State Management ──
local State = {
    AutoRoll = false,
    FastRoll = true,
    RollDelay = 0.15,
    
    AutoUpgradeDice = false,
    AutoUsePotions = false,
    AutoUseClovers = false,
    AutoCollectDrops = false,
    
    AutoRebirth = false,
    AutoEquipBest = false,
    AutoPlaceAnime = false,
    
    AutoDeleteLowRarity = false,
    DeleteThreshold = "Rare", -- Delete: Common, Uncommon, Rare
    
    SpeedEnabled = false,
    WalkSpeed = 60,
    CFrameBoost = false,
    CFrameSpeedIndex = 2,
    InfiniteJump = false,
    Noclip = false,
    FloatMode = false,
    
    AntiAFK = true,
    FPSBoost = false
}

local CFrameMultipliers = {2, 5, 10, 20, 40}
local CachedRemotes = {}

-- ── Game Codes Database ──
local GameCodes = {
    "CRIMSON",
    "TITAN",
    "ILOVEYALL",
    "TRADING",
    "ThanksForSupport!",
    "RELEASE",
    "SHINOBI",
    "ANIME",
    "LUCK",
    "SECRET",
    "COSMIC"
}

-- ── Status Label Callback ──
local updateStatusUI = function(msg) end
local function setStatus(msg)
    pcall(function()
        updateStatusUI(msg)
    end)
end

-- ── Anti-AFK 24/7 Engine ──
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- ── Intelligent Remote Scanner ──
local function findRemote(patternList)
    for _, pattern in ipairs(patternList) do
        if CachedRemotes[pattern] and CachedRemotes[pattern].Parent then
            return CachedRemotes[pattern]
        end
    end

    local searchRoots = {ReplicatedStorage, Workspace}
    for _, root in ipairs(searchRoots) do
        for _, desc in ipairs(root:GetDescendants()) do
            if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
                local lowerName = desc.Name:lower()
                for _, pattern in ipairs(patternList) do
                    if lowerName:find(pattern:lower()) then
                        CachedRemotes[pattern] = desc
                        return desc
                    end
                end
            end
        end
    end
    return nil
end

-- ── Instant ProximityPrompt Optimizer ──
local function optimizePrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.RequiresLineOfSight = false
        prompt.HoldDuration = 0
        prompt.Enabled = true
    end)
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    optimizePrompt(prompt)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
            fireproximityprompt(prompt, 100)
            fireproximityprompt(prompt)
        end
    end)
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.02)
        prompt:InputHoldEnd()
    end)
end

-- Background Prompt Optimizer
task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(function()
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    optimizePrompt(prompt)
                end
            end
        end)
    end
end)

-- ── Movement & Character Physics Engine ──
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and State.SpeedEnabled then
        if hum.WalkSpeed ~= State.WalkSpeed then
            hum.WalkSpeed = State.WalkSpeed
        end
    end

    if State.CFrameBoost and hrp and hum and hum.MoveDirection.Magnitude > 0 then
        local mult = CFrameMultipliers[State.CFrameSpeedIndex] or 5
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (mult * 0.25))
    end

    if State.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if State.FloatMode and hrp then
        local vel = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    if State.SpeedEnabled and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = State.WalkSpeed
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ⚙️ BACKGROUND AUTOMATION LOOPS
-- ═══════════════════════════════════════════════════════════

-- 1. Auto Fast Roll Loop
task.spawn(function()
    while true do
        local delayTime = State.FastRoll and 0.12 or State.RollDelay
        task.wait(delayTime)
        if State.AutoRoll then
            pcall(function()
                -- Method A: Trigger Roll Remote
                local rollRemote = findRemote({"roll", "rolldice", "rollanime", "spin", "draw", "rollremote", "diceroll", "rollcharacter"})
                if rollRemote then
                    if rollRemote:IsA("RemoteEvent") then
                        rollRemote:FireServer()
                        rollRemote:FireServer(1)
                        rollRemote:FireServer("Roll")
                    elseif rollRemote:IsA("RemoteFunction") then
                        rollRemote:InvokeServer()
                    end
                end

                -- Method B: Click In-Game UI Roll Button
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, desc in ipairs(playerGui:GetDescendants()) do
                        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                            local name = desc.Name:lower()
                            local text = desc:IsA("TextButton") and desc.Text:lower() or ""
                            if name:find("roll") or name:find("spin") or name:find("dice") or text:find("roll") or text:find("lăn") or text:find("quay") then
                                if desc.Visible and desc.Active then
                                    if firesignal then
                                        firesignal(desc.MouseButton1Click)
                                        firesignal(desc.Activated)
                                    end
                                end
                            end
                        end
                    end
                end

                -- Method C: ProximityPrompt at Roll Pad / Dice Table
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local act = (prompt.ActionText or ""):lower()
                        local obj = (prompt.ObjectText or ""):lower()
                        if act:find("roll") or act:find("lăn") or obj:find("dice") or obj:find("anime") or obj:find("roll") then
                            local char = LocalPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local pPart = prompt.Parent:IsA("BasePart") and prompt.Parent or (prompt.Parent:IsA("Model") and prompt.Parent.PrimaryPart)
                            if hrp and pPart and (pPart.Position - hrp.Position).Magnitude <= 30 then
                                triggerPrompt(prompt)
                            end
                        end
                    end
                end

                setStatus("🎲 Đang tự động Roll Anime liên tục...")
            end)
        end
    end
end)

-- 2. Auto Upgrade Dice (Luck Multiplier) Loop
task.spawn(function()
    while true do
        task.wait(2.5)
        if State.AutoUpgradeDice then
            pcall(function()
                local upRemote = findRemote({"upgradedice", "buydice", "nextdice", "luckupgrade", "upgradeluck", "tierupdice"})
                if upRemote then
                    if upRemote:IsA("RemoteEvent") then
                        upRemote:FireServer()
                        upRemote:FireServer("Dice")
                    elseif upRemote:IsA("RemoteFunction") then
                        upRemote:InvokeServer()
                    end
                    setStatus("🍀 Đang nâng cấp Xúc Xắc tăng tỷ lệ May Mắn (Luck)...")
                end
            end)
        end
    end
end)

-- 3. Auto Use Luck Potions & Clovers Loop
task.spawn(function()
    while true do
        task.wait(3.0)
        if State.AutoUsePotions or State.AutoUseClovers then
            pcall(function()
                local useRemote = findRemote({"usepotion", "consumeitem", "luckpotion", "useitem", "drinkpotion", "useclover", "activatebuff"})
                if useRemote then
                    if State.AutoUsePotions then
                        if useRemote:IsA("RemoteEvent") then
                            useRemote:FireServer("LuckPotion")
                            useRemote:FireServer("Luck")
                            useRemote:FireServer(1)
                        elseif useRemote:IsA("RemoteFunction") then
                            useRemote:InvokeServer("LuckPotion")
                        end
                    end
                    if State.AutoUseClovers then
                        if useRemote:IsA("RemoteEvent") then
                            useRemote:FireServer("Clover")
                            useRemote:FireServer("LuckyClover")
                        elseif useRemote:IsA("RemoteFunction") then
                            useRemote:InvokeServer("Clover")
                        end
                    end
                    setStatus("🧪 Đã kích hoạt Buff Bình May Mắn & Cỏ 4 Lá!")
                end
            end)
        end
    end
end)

-- 4. Auto Collect Map Drops (Clovers, Coins, Gems) Loop
task.spawn(function()
    while true do
        task.wait(0.4)
        if State.AutoCollectDrops then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Player") then
                        local name = part.Name:lower()
                        if name:find("coin") or name:find("gem") or name:find("clover") or name:find("luck")
                           or name:find("drop") or name:find("orb") or name:find("cash") or name:find("reward") then
                            
                            if (part.Position - hrp.Position).Magnitude <= 70 then
                                if firetouchinterest then
                                    firetouchinterest(hrp, part, 0)
                                    task.wait(0.01)
                                    firetouchinterest(hrp, part, 1)
                                else
                                    part.CFrame = hrp.CFrame
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5. Auto Rebirth Loop
task.spawn(function()
    while true do
        task.wait(4.0)
        if State.AutoRebirth then
            pcall(function()
                local rebirthRemote = findRemote({"rebirth", "prestige", "chuyensinh", "rebirthremote"})
                if rebirthRemote then
                    if rebirthRemote:IsA("RemoteEvent") then
                        rebirthRemote:FireServer()
                    elseif rebirthRemote:IsA("RemoteFunction") then
                        rebirthRemote:InvokeServer()
                    end
                    setStatus("🔄 Đã kích hoạt Chuyển Sinh (Rebirth) tăng Luck!")
                end
            end)
        end
    end
end)

-- 6. Auto Equip & Place Best Anime Loop
task.spawn(function()
    while true do
        task.wait(3.5)
        if State.AutoEquipBest or State.AutoPlaceAnime then
            pcall(function()
                local equipRemote = findRemote({"equipbest", "autoplace", "placebest", "equipcharacter", "placeanime", "bestanime"})
                if equipRemote then
                    if equipRemote:IsA("RemoteEvent") then
                        equipRemote:FireServer()
                    elseif equipRemote:IsA("RemoteFunction") then
                        equipRemote:InvokeServer()
                    end
                    setStatus("🐾 Đã tự động trang bị & đặt Anime mạnh nhất!")
                end
            end)
        end
    end
end)

-- 7. Auto Delete / Skip Low Rarity Anime Loop
task.spawn(function()
    while true do
        task.wait(2.0)
        if State.AutoDeleteLowRarity then
            pcall(function()
                local deleteRemote = findRemote({"deleteanime", "sellcommon", "trashanime", "selltrash", "deletecharacter", "quickdelete"})
                if deleteRemote then
                    local targets = {"Common", "Uncommon"}
                    if State.DeleteThreshold == "Rare" then
                        table.insert(targets, "Rare")
                    end
                    for _, rarity in ipairs(targets) do
                        if deleteRemote:IsA("RemoteEvent") then
                            deleteRemote:FireServer(rarity)
                        elseif deleteRemote:IsA("RemoteFunction") then
                            deleteRemote:InvokeServer(rarity)
                        end
                    end
                    setStatus("🗑️ Đang lọc và dọn dẹp các Anime phẩm cấp thấp...")
                end
            end)
        end
    end
end)

-- ── Helper: Redeem All Codes ──
local function redeemAllCodes()
    pcall(function()
        local codeRemote = findRemote({"redeemcode", "claimcode", "code", "coderemote", "enter_code"})
        if not codeRemote then
            setStatus("⚠️ Không tìm thấy Remote nhập Code!")
            return
        end

        local count = 0
        for _, code in ipairs(GameCodes) do
            if codeRemote:IsA("RemoteEvent") then
                codeRemote:FireServer(code)
            elseif codeRemote:IsA("RemoteFunction") then
                codeRemote:InvokeServer(code)
            end
            count = count + 1
            task.wait(0.2)
        end
        setStatus("🎁 Đã tự động nhập thành công " .. tostring(count) .. " Codes!")
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🎨 GIAO DIỆN CYBERPUNK (ROLL FOR ANIME HUB UI)
-- ═══════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RollAnimeHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = getGuiContainer()

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Position = UDim2.new(0.5, -160, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 22) -- Deep Anime Purple
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 60, 100) -- Crimson Red / Neon Pink
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

-- Draggable Logic for MainFrame
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 12)
TopbarCorner.Parent = Topbar

local TopbarBottomFill = Instance.new("Frame")
TopbarBottomFill.Size = UDim2.new(1, 0, 0, 10)
TopbarBottomFill.Position = UDim2.new(0, 0, 1, -10)
TopbarBottomFill.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
TopbarBottomFill.BorderSizePixel = 0
TopbarBottomFill.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎲 ROLL FOR ANIME HUB ⚔️"
Title.TextColor3 = Color3.fromRGB(255, 60, 100)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -68, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 30, 60)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 14
MinBtn.Parent = Topbar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 40, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 13
CloseBtn.Parent = Topbar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- Floating Toggle Icon Button (Mobile / Delta)
local FloatingToggle = Instance.new("ImageButton")
FloatingToggle.Name = "RollAnimeFloatingToggle"
FloatingToggle.Size = UDim2.new(0, 48, 0, 48)
FloatingToggle.Position = UDim2.new(0, 20, 0.4, 0)
FloatingToggle.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
FloatingToggle.Visible = false
FloatingToggle.Parent = ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = FloatingToggle

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Color3.fromRGB(255, 60, 100)
floatStroke.Thickness = 2
floatStroke.Parent = FloatingToggle

local floatLabel = Instance.new("TextLabel")
floatLabel.Size = UDim2.new(1, 0, 1, 0)
floatLabel.BackgroundTransparency = 1
floatLabel.Text = "🎲"
floatLabel.TextSize = 24
floatLabel.Parent = FloatingToggle

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingToggle.Visible = true
end)

FloatingToggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingToggle.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Draggable Floating Toggle
local fDragging, fDragStart, fStartPos
FloatingToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = FloatingToggle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                fDragging = false
            end
        end)
    end
end)
FloatingToggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if fDragging then
            local delta = input.Position - fDragStart
            FloatingToggle.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
        end
    end
end)

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Size = UDim2.new(1, -16, 0, 26)
StatusBar.Position = UDim2.new(0, 8, 1, -32)
StatusBar.BackgroundColor3 = Color3.fromRGB(24, 18, 36)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -8, 1, 0)
StatusLabel.Position = UDim2.new(0, 6, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Sẵn sàng | Roll for Anime Hub v1.0"
StatusLabel.TextColor3 = Color3.fromRGB(200, 180, 220)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

updateStatusUI = function(msg)
    StatusLabel.Text = tostring(msg)
end

-- Scroll Content Container
local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "ScrollContent"
Scroll.Size = UDim2.new(1, -16, 1, -84)
Scroll.Position = UDim2.new(0, 8, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Scroll

-- ── UI Component Helpers ──
local function createSectionHeader(titleText)
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundTransparency = 1
    header.Text = " " .. titleText
    header.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
    header.Font = Enum.Font.SourceSansBold
    header.TextSize = 13
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = Scroll
    return header
end

local function createToggle(title, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(26, 20, 38)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(240, 230, 250)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 42, 0, 22)
    btn.Position = UDim2.new(1, -48, 0.5, -11)
    btn.BackgroundColor3 = defaultVal and Color3.fromRGB(255, 60, 100) or Color3.fromRGB(50, 40, 70)
    btn.Text = defaultVal and "ON" or "OFF"
    btn.TextColor3 = defaultVal and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 170, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Parent = frame

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 5)
    bCorner.Parent = btn

    local currentVal = defaultVal
    btn.MouseButton1Click:Connect(function()
        currentVal = not currentVal
        btn.BackgroundColor3 = currentVal and Color3.fromRGB(255, 60, 100) or Color3.fromRGB(50, 40, 70)
        btn.Text = currentVal and "ON" or "OFF"
        btn.TextColor3 = currentVal and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 170, 200)
        pcall(callback, currentVal)
    end)
    return frame
end

-- ── BUILD CONTROLS ──

-- SECTION 1: AUTO ROLL
createSectionHeader("🎲 TỰ ĐỘNG LĂN ANIME (AUTO ROLL)")

createToggle("🎲 Auto Roll (Tự Lăn Xúc Xắc)", State.AutoRoll, function(val)
    State.AutoRoll = val
    setStatus(val and "🎲 Đã BẬT Auto Roll Anime!" or "⏸️ Đã TẮT Auto Roll.")
end)

createToggle("⚡ Fast Roll (Bỏ Qua Animation Chờ)", State.FastRoll, function(val)
    State.FastRoll = val
    setStatus(val and "⚡ Đã kích hoạt Fast Roll siêu tốc!" or "Đã tắt Fast Roll.")
end)

-- SECTION 2: MAY MẮN & NÂNG CẤP (LUCK BOOSTERS)
createSectionHeader("🍀 TỐI ĐA MAY MẮN (LUCK BOOSTERS)")

createToggle("🎲 Auto Nâng Cấp Xúc Xắc (Dice Upgrades)", State.AutoUpgradeDice, function(val)
    State.AutoUpgradeDice = val
end)

createToggle("🧪 Tự Uống Bình May Mắn (Luck Potions)", State.AutoUsePotions, function(val)
    State.AutoUsePotions = val
end)

createToggle("🍀 Tự Dùng Cỏ 4 Lá (Lucky Clovers)", State.AutoUseClovers, function(val)
    State.AutoUseClovers = val
end)

createToggle("🧲 Tự Hút Cỏ May Mắn & Tiền Rơi (Drops)", State.AutoCollectDrops, function(val)
    State.AutoCollectDrops = val
end)

createToggle("🔄 Tự Động Chuyển Sinh (Rebirth xLuck)", State.AutoRebirth, function(val)
    State.AutoRebirth = val
end)

-- SECTION 3: QUẢN LÝ ANIME & TÚI ĐỒ
createSectionHeader("⚔️ QUẢN LÝ ANIME & LỌC TÚI ĐỒ")

createToggle("👑 Tự Trang Bị Anime Mạnh Nhất (Best)", State.AutoEquipBest, function(val)
    State.AutoEquipBest = val
end)

createToggle("🏰 Tự Đặt Anime Kiếm Tiền (Auto Place)", State.AutoPlaceAnime, function(val)
    State.AutoPlaceAnime = val
end)

createToggle("🗑️ Tự Vứt / Bán Anime Rác (Common/Rare)", State.AutoDeleteLowRarity, function(val)
    State.AutoDeleteLowRarity = val
end)

-- Button Redeem All Codes
local btnRedeem = Instance.new("TextButton")
btnRedeem.Size = UDim2.new(1, -4, 0, 32)
btnRedeem.BackgroundColor3 = Color3.fromRGB(180, 50, 90)
btnRedeem.Text = "🎁 NHẬP TẤT CẢ CODE GAME (REDEEM ALL CODES)"
btnRedeem.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRedeem.Font = Enum.Font.SourceSansBold
btnRedeem.TextSize = 11
btnRedeem.Parent = Scroll
local rdCorner = Instance.new("UICorner")
rdCorner.CornerRadius = UDim.new(0, 6)
rdCorner.Parent = btnRedeem

btnRedeem.MouseButton1Click:Connect(function()
    redeemAllCodes()
end)

-- SECTION 4: TỐC ĐỘ & VẬT LÝ
createSectionHeader("🏃 TỐC ĐỘ & VẬT LÝ (MOVEMENT)")

createToggle("⚡ Tăng Tốc Độ Chạy (Speed Boost)", State.SpeedEnabled, function(val)
    State.SpeedEnabled = val
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and not val then
        hum.WalkSpeed = 16
    end
end)

-- Speed Cycle Button
local btnSpeedCycle = Instance.new("TextButton")
btnSpeedCycle.Size = UDim2.new(1, -4, 0, 30)
btnSpeedCycle.BackgroundColor3 = Color3.fromRGB(30, 24, 46)
btnSpeedCycle.Text = "🏃 Tốc độ WalkSpeed: [ " .. tostring(State.WalkSpeed) .. " ] (Chạm để đổi)"
btnSpeedCycle.TextColor3 = Color3.fromRGB(255, 100, 150)
btnSpeedCycle.Font = Enum.Font.SourceSansBold
btnSpeedCycle.TextSize = 12
btnSpeedCycle.Parent = Scroll
local scCorner = Instance.new("UICorner")
scCorner.CornerRadius = UDim.new(0, 6)
scCorner.Parent = btnSpeedCycle

local speedPresets = {32, 60, 100, 150, 250, 350}
local speedIdx = 2
btnSpeedCycle.MouseButton1Click:Connect(function()
    speedIdx = (speedIdx % #speedPresets) + 1
    State.WalkSpeed = speedPresets[speedIdx]
    btnSpeedCycle.Text = "🏃 Tốc độ WalkSpeed: [ " .. tostring(State.WalkSpeed) .. " ] (Chạm để đổi)"
    if State.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = State.WalkSpeed
    end
end)

-- CFrame Boost Toggle Button
local btnCFrame = Instance.new("TextButton")
btnCFrame.Size = UDim2.new(1, -4, 0, 30)
btnCFrame.BackgroundColor3 = Color3.fromRGB(30, 24, 46)
btnCFrame.Text = "🌀 Lướt CFrame Siêu Âm: [ OFF ]"
btnCFrame.TextColor3 = Color3.fromRGB(180, 170, 200)
btnCFrame.Font = Enum.Font.SourceSansBold
btnCFrame.TextSize = 12
btnCFrame.Parent = Scroll
local cfCorner = Instance.new("UICorner")
cfCorner.CornerRadius = UDim.new(0, 6)
cfCorner.Parent = btnCFrame

btnCFrame.MouseButton1Click:Connect(function()
    if not State.CFrameBoost then
        State.CFrameBoost = true
        State.CFrameSpeedIndex = 1
    else
        State.CFrameSpeedIndex = State.CFrameSpeedIndex + 1
        if State.CFrameSpeedIndex > #CFrameMultipliers then
            State.CFrameBoost = false
            State.CFrameSpeedIndex = 1
        end
    end

    if State.CFrameBoost then
        local mult = CFrameMultipliers[State.CFrameSpeedIndex] or 5
        btnCFrame.Text = "🌀 Lướt CFrame Siêu Âm: [ ON " .. tostring(mult) .. "x ]"
        btnCFrame.TextColor3 = Color3.fromRGB(255, 60, 100)
    else
        btnCFrame.Text = "🌀 Lướt CFrame Siêu Âm: [ OFF ]"
        btnCFrame.TextColor3 = Color3.fromRGB(180, 170, 200)
    end
end)

createToggle("🦘 Nhảy Vô Hạn (Infinite Jump)", State.InfiniteJump, function(val)
    State.InfiniteJump = val
end)

createToggle("👻 Đi Xuyên Tường (Noclip)", State.Noclip, function(val)
    State.Noclip = val
end)

createToggle("🛸 Giữ Bay Lơ Lửng (Float / Hover)", State.FloatMode, function(val)
    State.FloatMode = val
end)

-- SECTION 5: TREO MÁY & BẢO VỆ
createSectionHeader("🛡️ TREO MÁY 24/7 & GIẢM LAG")

createToggle("🛡️ Anti-AFK 24/7 (Chống Văng Game)", State.AntiAFK, function(val)
    State.AntiAFK = val
end)

createToggle("🚀 Giảm Đồ Họa Treo Máy (FPS Booster)", State.FPSBoost, function(val)
    State.FPSBoost = val
    pcall(function()
        if val then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            settings().Rendering.QualityLevel = 1
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
            setStatus("🚀 Đã bật chế độ giảm lag FPS Boost!")
        else
            Lighting.GlobalShadows = true
            setStatus("Đã tắt chế độ FPS Boost.")
        end
    end)
end)

setStatus("Đã khởi tạo thành công Roll for Anime Hub!")
