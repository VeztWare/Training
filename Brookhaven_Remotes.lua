local x = require(game:GetService("Players").LocalPlayer.PlayerGui.Player8Handler.Game8Settings)

for i,v in pairs(x) do
    if type(v) == "userdata" and v:IsA("Instance") then
        v.Name = i
    end
end
