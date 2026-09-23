--[[
    ===================================================================
    🎲 ROLL FOR ANIME! (LĂN CHO ANIME! 🎲) - ULTIMATE AUTO HUB LOADER V1.0
    Game: Roll for Anime! 🎲 (by Proton Laboratory)
    Repository: https://github.com/khahuynh963/roll_anime.git
    Author: khahuynh963
    ===================================================================
--]]

pcall(function()
    local container = (gethui and gethui()) or game:GetService("CoreGui")
    if container and container:FindFirstChild("RollAnimeHubGui") then
        container.RollAnimeHubGui:Destroy()
    end
    local pl = game:GetService("Players").LocalPlayer
    if pl and pl:FindFirstChild("PlayerGui") and pl.PlayerGui:FindFirstChild("RollAnimeHubGui") then
        pl.PlayerGui.RollAnimeHubGui:Destroy()
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/roll_anime/main/script.lua?v=" .. tostring(os.time()) .. "_" .. tostring(math.random(10000, 99999))))()
