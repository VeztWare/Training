local kavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/VeztWare/KavoUi/main/KavoUi.lua"))()
local window = kavoUi.CreateLib("Vezt | Bubble Gum","VeztPur")

local InfoTab = window:NewTab("Info")
local Info = InfoTab:NewSection("Game: Bubble Gum || " ..game.PlaceId)
local MainTab = window:NewTab("Main")
local Main = MainTab:NewSection("Main Functions")

local player = game.Players.LocalPlayer
local lplr = player
local character = player.Character
local hrp = character and character:FindFirstChild("HumanoidRootPart")
local sharedEvent =  game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event")
local PickupRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup")

getgenv().AutoBubble = false
getgenv().AutoSell = false
getgenv().AutoPickup = false

function GetPickUpChunk()
    for i, v in pairs(workspace.Rendered:GetChildren()) do
        if v.Name == "Chunker" then
            local model = v:FindFirstChildWhichIsA("Model")
            if model and string.find(model.Name, "-") then
                return v
            end
        end
    end
    return nil
end

function BuyFromAlienShop(shelf, amount)
    for i = 1, amount do
        task.wait(0.5)
        local args = {
            "BuyShopItem",
            "alien-shop",
            shelf
        }
       sharedEvent:FireServer(unpack(args))
    end
end       

function BuyFromDiceShop(shelf, amount)
    for i = 1, amount do
        task.wait(0.5)
        local args = {
            "BuyShopItem",
            "dice-shop",
            shelf
        }
       sharedEvent:FireServer(unpack(args))
    end
end      

function ActionAlienShop()
    for i = 1, 3 do
        BuyFromAlienShop(tonumber(i), 15)
    end
end

function ActionDiceShop()
    for i = 1, 3 do
        BuyFromDiceShop(tonumber(i), 15)
    end
end

local function stripRichText(str)
    return str:gsub("<[^>]+>", "")
end

function GetBubbleStatus()
    local cur, max = stripRichText(lplr.PlayerGui.ScreenGui.HUD.Left.Currency.Bubble.Frame.Label.Text):match("([%d,]+)%s*/%s*([%d,]+)")
    local temp = string.gsub(cur, ",", "")
    local temp2 = string.gsub(max, ",", "")

    if tonumber(temp2) - tonumber(temp) == 0 then
        return "max"
    else
        return tonumber(temp2) - tonumber(temp)
    end
end

function GetNearestPickup()
    local chunk = GetPickUpChunk()

    if not hrp or not chunk then return nil end

    local nearest, shortestDistance = nil, 100

    for _, item in pairs(chunk:GetChildren()) do
        local dist = (hrp.Position - item.WorldPivot.Position).Magnitude
        if dist < shortestDistance then
            nearest = item
            shortestDistance = dist
        end
    end

    return nearest
end


Main:NewToggle("Auto Bubble", "?", function(s)
    getgenv().AutoBubble = s
    if s then
        task.spawn(function()
            while getgenv().AutoBubble and task.wait() do
                sharedEvent:FireServer("BlowBubble")
            end
        end)
    end
end)

Main:NewToggle("Auto Sell Bubbles", "?", function(s)
    getgenv().AutoSell = s
    if s then
        task.spawn(function()
            while getgenv().AutoSell and task.wait() do
                sharedEvent:FireServer("SellBubble")
            end
        end)
    end
end)


Main:NewToggle("Auto Pickup", "?", function(s)
    getgenv().AutoPickup = s
    if s then
        
        task.spawn(function()
            while getgenv().AutoPickup and task.wait(0.25) do
                local item = GetNearestPickup()
                if item then
                    PickupRemote:FireServer(item.Name)
                    item:Destroy()
                end
            end
        end)
    end
end)

Main:NewToggle("Auto Claim Playtime", "?", function(s)
    getgenv().AutoPlayTime = s
    if s then
        
        task.spawn(function()
            while getgenv().AutoPlayTime and task.wait(10) do
                for i = 1, 9 do
                    local args = {
                        [1] = "ClaimPlaytime",
                        [2] = i
                    }
                
                    game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Function"):InvokeServer(unpack(args))    
                end            
            end
        end)
    end
end)


Main:NewToggle("Auto Hatch Egg", "?", function(s)
    getgenv().AutoClan = s
    if s then
        
        task.spawn(function()
            while getgenv().AutoClan and task.wait(0.1) do
                local args = {
                    "HatchEgg",
                    "100M Egg",
                    3
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))                
            end
        end)
    end
end)

Main:NewToggle("Auto Buy Alien Shop", "?", function(s)
    getgenv().AutoAlienShop = s
    if s then
        
        task.spawn(function()
            while getgenv().AutoAlienShop do
                ActionAlienShop()
                task.wait(20)
            end
        end)
    end
end)

Main:NewToggle("Auto Buy Dice Merchant", "?", function(s)
    getgenv().AutoDiceShop = s
    if s then
        
        task.spawn(function()
            while getgenv().AutoDiceShop do
                ActionDiceShop()
                task.wait(20)
            end
        end)
    end
end)

Chest:NewToggle("Auto Claim Chests [Need Mastery]", "?", function(s)
    getgenv().AutoClaim = s
    if s then
            
        task.spawn(function()
            while getgenv().AutoClaim do
                local args = {
                    "ClaimChest",
                    "Void Chest",
                    true
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))
                wait(20)
            end
        end)
    end
end)            
--[[local s = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.MinigameHUD["Pet Match"].Content:GetChildren()

for i,v in pairs(s) do
    v.Inner.Icon.ZIndex = 2
    v.Inner.Icon.ImageTransparency = 0
end
]]
