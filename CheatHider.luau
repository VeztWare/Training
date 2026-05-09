local b = game:GetService("CoreGui").TopBarApp.TopBarApp.MenuIconHolder.TriggerPoint.IconHitArea
local t, h = 2, false
local pow = false

function HideAll()
	pow = not pow
	for i,o in pairs(gethui():GetChildren()) do
		if o:IsA("ScreenGui") then
			o.Enabled = pow
		end
	end
end

local function s()
	h = true
	local n = tick()

	task.delay(t, function()
		if h and tick() - n >= t then
			HideAll()
		end
	end)
end

local function e()
	h = false
end

b.MouseButton1Down:Connect(s)
b.MouseButton1Up:Connect(e)
b.MouseLeave:Connect(e)

b.TouchLongPress:Connect(function(_, i)
	if i == Enum.UserInputState.Begin then
		s()
	else
		e()
	end
end)

b.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch then
		e()
	end
end)
