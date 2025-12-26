--sorry for the shit decmopiled code because i made this rewriring in like 5 minutes

local v1 = game:GetService("ReplicatedStorage")
local v7 = v1:WaitForChild("meow")
local v_u_8 = v1:WaitForChild("nya")
local v_u_2 = game:GetService("Stats")

for _, v in getconnections(game:GetService('LogService').MessageOut) do -- annoying console log bypass
	if v.Function then
		v:Disable()
	end
end

x = getconnections(v7.OnClientEvent)[1].Function
local old

old = hookfunction(x, function(...) -- the rewiring of the original function signal
    v_u_8:FireServer({
        ["t"] = "metrics",
        ["fps"] = Random.new():NextNumber(1500, 2400),
        ["gfx"] = 9,
        ["mem"] = v_u_2:GetTotalMemoryUsageMb(),
        ["res"] = Vector2.new(3840, 2160)
    })
end)
