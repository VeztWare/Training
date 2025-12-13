local lplr = game.Players.LocalPlayer
local chr = lplr.Character or lplr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local RollFlower = ReplicatedStorage.Remotes:WaitForChild("RollFlower")
local Mining = ReplicatedStorage.Remotes:WaitForChild("Mining")
local OneWayRemote = ReplicatedStorage.Remotes:WaitForChild("UpgradeStat")
local StarterGui = game:GetService("StarterGui")
local Data = ReplicatedStorage.Remotes:WaitForChild("Data")
local sunflowers = {"Sunflower 1", "Sunflower 2", "Sunflower 3", "Sunflower 4"}
local RollFlowerPart = workspace.Npcs.GamblingFlower.Stem
local movementEnabled = false
local movementLoop

local function calculateCenter(points)
    local totalX, totalY, totalZ = 0, 0, 0
    for _, point in ipairs(points) do
        totalX = totalX + point.Position.X
        totalY = totalY + point.Position.Y
        totalZ = totalZ + point.Position.Z
    end
    local avgX = totalX / #points
    local avgY = totalY / #points
    local avgZ = totalZ / #points
    return CFrame.new(avgX, avgY, avgZ)
end

local function notif(txt)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vezt",
            Text = txt,
            Duration = 5
        })
    end)
end

local point1 = CFrame.new(-3.68071651, 147.14917, 2.59087896, 0.294739813, 3.02437932e-08, -0.955577552, -3.36073782e-08, 1, 2.12838422e-08, 0.955577552, 2.58412616e-08, 0.294739813)
local point2 = CFrame.new(27.9887123, 147.14917, 3.03761816, -0.0141035793, 4.24161328e-08, -0.99990052, 7.84437262e-08, 1, 4.13139034e-08, 0.99990052, -7.7853251e-08, -0.0141035793)
local point3 = CFrame.new(26.4466629, 147.14917, 35.0248566, -0.156921014, 3.42076376e-08, -0.987611175, 9.25747301e-08, 1, 1.99275974e-08, 0.987611175, -8.830078e-08, -0.156921014)
local point4 = CFrame.new(17.3044987, 147.147202, 34.1901627, 0.999629378, -1.04208375e-09, -0.0272240192, 1.19985966e-09, 1, 5.77913006e-09, 0.0272240192, -5.8096532e-09, 0.999629378)
local point5 = CFrame.new(18.2048931, 147.147202, 1.13557732, 0.999629378, 5.55601254e-09, -0.0272240192, -6.39736575e-09, 1, -3.08177093e-08, 0.0272240192, 3.09804484e-08, 0.999629378)
local point6 = CFrame.new(-3.71193027, 147.14917, 34.3383827, 0.41823557, -6.91096602e-08, 0.908338606, 1.07944274e-07, 1, 2.63817057e-08, -0.908338606, 8.70161827e-08, 0.41823557)

local points = {point1, point2, point3, point4}
local center = calculateCenter(points)

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local tweentime = 0.75

local function tweenTo(cframe)
    local tweenInfo = TweenInfo.new(tweentime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goal = {CFrame = cframe}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

local function startMovement()
    movementLoop = coroutine.create(function()
        while movementEnabled do
            tweenTo(point1)
            tweenTo(point2)
            tweenTo(point3)
            tweenTo(point4)
            tweenTo(point5)
            tweenTo(point6)
            tweenTo(center)
        end
    end)
    coroutine.resume(movementLoop)
end

local function stopMovement()
    movementEnabled = false
    if movementLoop and coroutine.status(movementLoop) ~= "dead" then
        coroutine.close(movementLoop)
    end
end

function HasUnlockedWorld(world)
    if Data.WORLDS[world] == true then
        return true
    else
        return false
    end
end
function HasUnlockedItem(item)
    if item.Transparency ~= 1 then
        return true
    else
        return false
    end
end
local special_args = {
    ["Process"] = {"Processor", "Processors"},
    ["Supercharger"] = {"Supercharge", "OilUpgrades"},
    ["SellRocks"] = {"SellAll", "OreShop"},
    ["Space_Click"] = {"Click", "ClickBoard"}
}

local temp_data_tbl = Data:InvokeServer()
local user_data = {
    ["Cash"] = temp_data_tbl["SpaceCurrency"].Cash,
    ["Currency"] = temp_data_tbl["Currencies"],
    ["World"] = game.Players.LocalPlayer:GetAttribute("World")
}

function NearestRock()
    local nearestRock = nil
    local shortestDistance = math.huge

    for _, v in pairs(workspace.Debris:GetChildren()) do
        if string.find(v.Name, "-") then
            local distance = (v.WorldPivot.Position - hrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestRock = v
            end
        end
    end

    return nearestRock
end


local kavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/VeztWare/KavoUi/main/KavoUi.lua"))()
local window = kavoUi.CreateLib("Vezt - Sunflower Incremental", "VeztPur")
local Tab1 = window:NewTab("Main")
local Main = Tab1:NewSection("Beta")
local Tab2 = window:NewTab("Info")
local Info = Tab2:NewSection("Beta 1.0")
Info:NewLabel("[+] Added AntiBan")
local Tab3 = window:NewTab("Misc")
local Misc = Tab3:NewSection("nice")
Main:NewLabel("World1 / Spawn")

Main:NewToggle("AutoFarm Sunflower [pattern]", "?", function(st)
    if st then
        movementEnabled = true
        startMovement()
    else
        stopMovement()
    end
end)
Main:NewToggle("AutoFarm Sunflower V2 (all)", "?", function(st)
    if st then
        autosun_con = true
        autosun_con = workspace.Debris.ChildAdded:Connect(function(lol)
            if string.find(lol.Name, "-") then
                hrp:PivotTo(lol.WorldPivot)
            end
        end)
    else
        autosun_con = false
    end
end)

Main:NewSlider("Tween Speed", "?", 0.5, 3, function(num)
    tweentime = num
end)
Main:NewToggle("Auto Roll Flower", "?", function(st)
    if st then
        if HasUnlockedItem(RollFlowerPart) then
            rollflower_con = true
            while rollflower_con and wait(20) do
                RollFlower:FireServer()
            end
        else
            notif("You have not unlocked the sunflower lord yet.")
        end
    else
        rollflower_con = false
    end
end)
Main:NewLabel("World2 / Runes & Oil")
Main:NewToggle("Auto Process Oil", "?", function(st)
    if st then
            process_con = RunService.Heartbeat:Connect(function()
                OneWayRemote:FireServer(unpack(special_args["Process"]))
            end)
    else
        if process_con then
            process_con:Disconnect()
            process_con = nil
        end
    end
end)


Main:NewToggle("Auto Supercharge", "?", function(st)
    if st then
            supercharge_con = RunService.Heartbeat:Connect(function()
                OneWayRemote:FireServer(unpack(special_args["Supercharger"]))
            end)
    else
        if supercharge_con then
            supercharge_con:Disconnect()
            supercharge_con = nil
        end
    end
end)

Main:NewToggle("AutoFarm Oil", "?", function(st)
    if st then
            oil_con = true
            while oil_con and wait(1) do
                for i, v in pairs(sunflowers) do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradeStat"):FireServer(v, "Planting")
                    wait(0.75)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradeStat"):FireServer("Collect " .. v, "Planting")
                end
            end
    else
        oil_con = false
    end
end)


Main:NewLabel("World3 / Space")

Main:NewToggle("AutoFarm Space Rocks", "?", function(st)
    if st then
        if game.Players.LocalPlayer:GetAttribute("World") == "World3" then
            rockscon = RunService.RenderStepped:Connect(function()
                local res = NearestRock()
                Mining:FireServer(tostring(res))
            end)
        else
            notif("CallBack Rejected, You Are Not In Space")
            if rockscon then
                rockscon:Disconnect()
                rockscon = nil
            end
        end
    else
        if rockscon then
            rockscon:Disconnect()
            rockscon = nil
        end
    end
end)

Main:NewToggle("Auto Click Boost", "?", function(st)
    if st then
        if game.Players.LocalPlayer:GetAttribute("World") == "World3" then
            clickcon = RunService.RenderStepped:Connect(function()
                OneWayRemote:FireServer(special_args["Space_Click"])
            end)
        else
            notif("CallBack Rejected, You Are Not In Space")
            if clickcon then
                clickcon:Disconnect()
                clickcon = nil
            end
        end
    else
        if clickcon then
            clickcon:Disconnect()
            clickcon = nil
        end
    end
end)

Main:NewToggle("Auto Sell Rocks", "?", function(st)
    if st then
        if game.Players.LocalPlayer:GetAttribute("World") == "World3" then
            sellrocks_con = true
            while sellrocks_con and wait(20) do
                OneWayRemote:FireServer(unpack(special_args["SellRocks"]))
            end
        else
            notif("You are not in space, please go to space.")
        end
    else
        sellrocks_con = false
    end
end)


Misc:NewButton("Block Favorite Prompt", "?", function()
    local AvatarEditorService = game:GetService('AvatarEditorService')
    if hookfunction then
        hookfunction(AvatarEditorService.PromptSetFavorite, function(...)
            print("it was tried to be called")
        end)
        notif("PromptSetFavorite has been blocked.")
    else
        notif("Hookfunction not found.")
    end
end)
