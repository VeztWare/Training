local function calculate(expression)
    expression = expression:gsub("x", "*")
    expression = expression:gsub("÷", "/")
    local func, err = loadstring("return " .. expression)
    if func then
        local success, result = pcall(func)
        if success then
            return result
        else
            return "Error in calculation."
        end
    else
        return "Invalid expression."
    end
end

local question = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frame.Calculator.QuestionTxt
local answerBox = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frame.Calculator.AnswerBox

local connection
local TextButtonFire

_G.funni = true -- set this to false if you want to stop it

for i,v in getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frame.Calculator.Submit.MouseButton1Click) do
    TextButtonFire = v
end
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.funni == true then 
        local answer = calculate(question.Text)
        answerBox.Text = tostring(answer) -- set the answer as the text 
        TextButtonFire:Fire() -- click the submit button, im not sure but this might block keyboard inputs somehow.
    end
end)
