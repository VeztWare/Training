local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local NoteRandomization = false

local function notif(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "Vezt",
        Text = txt,
        Duration = 5
    })
end

notif("Getting Things Done...")

if not _G.OptionsTable then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VeztWare/Vezt/main/KeybindSpy.lua"))()
end

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local playertype = {"Left", "Right"}
local codes = {
    [9] = {"Left", "Down", "Up", "Right", "Space", "Left2", "Down2", "Up2", "Right2"},
    [8] = {"Left", "Down", "Up", "Right", "Left2", "Down2", "Up2", "Right2"},
    [7] = {"Left", "Up", "Right", "Space", "Left2", "Down", "Right2"},
    [6] = {"Left", "Up", "Right", "Left2", "Down", "Right2"},
    [5] = {"Left", "Down", "Space", "Up", "Right"},
    [4] = {"Left", "Down", "Up", "Right"}
}

local function sort(parent)
    local nodes = parent:GetChildren()
    table.sort(nodes, function(lhs, rhs)
        local lx, rx = lhs.AbsolutePosition.X, rhs.AbsolutePosition.X
        return lx < rx
    end)
    return nodes
end

local function getMatch()
    for _, obj in pairs(getgc(true)) do
        if type(obj) == 'table' then
            if rawget(obj, 'MatchFolder') then
                return obj
            end
        end
    end
end

local function IsMechanic(item)
    return item:GetAttribute("NoteType") == "a1"
end

local function nominus(item)
    return string.gsub(item, "-", "")
end

local function calculateOffset(speed, arrows) -- this is my offset algorithm :)
    local normspeed = 60 * speed - 32
    local ninespeed = 60 * speed - 42
    if speed < 1.2 then
        return (arrows == 9) and ninespeed or nominus(normspeed)
    else
        return 40
    end
end

local function AutoPlayer()
    if not _G.OptionsTable then
        notif("Please Do The Tutorial Or Join dsc.gg/veztontop for more info")
        return
    end

    local match = getMatch()
    if not match then
        notif("Join A Match Before Clicking This Button!")
        return
    end

    repeat wait() until rawget(match, "Songs")

    local options = _G.OptionsTable
    local side = playertype[match.PlayerType]
    local arrowGui = match.ArrowGui
    local sideFrame = arrowGui[side]
    local container, longNotes, notes = sideFrame.MainArrowContainer, sideFrame.LongNotes, sideFrame.Notes
    local maxArrows = match.MaxArrows
    local keycodes = codes[maxArrows]
    local controls = maxArrows < 5 and options or options.ExtraKeySettings[tostring(maxArrows)]

    container, longNotes, notes = sort(container), sort(longNotes), sort(notes)

    local tasks = {
        {list = notes, handleChild = true},
        {list = longNotes, handleChild = false}
    }

    for _, task in ipairs(tasks) do
        for i, holder in ipairs(task.list) do
            local keycode = controls[keycodes[i] .. "Key"]
            if task.handleChild then
                local longNote = longNotes[i]
                local fakeNote = container[i]
                local offset = calculateOffset(options.NoteSpeed, maxArrows)
                local newOffset = NoteRandomization and tonumber(offset) + math.random(1,5) or tonumber(offset)
                
                holder.ChildAdded:Connect(function(note)
                    local conn
                    conn = RunService.RenderStepped:Connect(function()
                        if (fakeNote.AbsolutePosition - note.AbsolutePosition).Magnitude < newOffset then
                            conn:Disconnect()
                            VirtualInputManager:SendKeyEvent(true, keycode, false, nil)
                            if #longNote:GetChildren() == 0 then
                                VirtualInputManager:SendKeyEvent(false, keycode, false, nil)
                            end
                        end
                    end)
                end)
            else
                holder.ChildRemoved:Connect(function()
                    VirtualInputManager:SendKeyEvent(false, keycode, false, nil)
                end)
            end
        end
    end
end

local kavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/VeztWare/KavoUi/main/KavoUi.lua"))()
local window = kavoUi.CreateLib("Vezt - AutoPlayer", "VeztPur")

local Tab1 = window:NewTab("Main")
local Tab1Section = Tab1:NewSection("Click On Options from the menu.")
Tab1Section:NewLabel("Then Click [Leave] next to the chat button")

local Tab2 = window:NewTab("AutoPlayer")
local Tab2Section = Tab2:NewSection("Please Join dsc.gg/veztontop For Support!")

local Tab3 = window:NewTab("Extra")
local Tab3Section = Tab3:NewSection("cool!")

Tab2Section:NewButton("AutoPlayer", "?", function()
    AutoPlayer()
end)

Tab3Section:NewToggle("Note Randomization", "add random timings", function(s)
    NoteRandomization = s
end)

Tab3Section:NewButton("Hide Your Name (in match)", "?", function()
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj.Text == LocalPlayer.DisplayName then
            obj:Destroy()
        end
    end
end)

local label = Tab2Section:NewLabel("Retrieved Keybinds: ???")
RunService.Heartbeat:Connect(function()
    if _G.OptionsTable then
        label:UpdateLabel("Retrieved Keybinds: Yes")
    else
        label:UpdateLabel("Retrieved Keybinds: No")
    end
end)
