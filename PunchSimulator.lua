local suffixes = {
	[""] = 1,
	["K"] = 1e3,
	["M"] = 1e6,
	["B"] = 1e9,
	["T"] = 1e12,
	["Qa"] = 1e15, 
	["Qi"] = 1e18, 
	["Sx"] = 1e21, 
	["Sp"] = 1e24,
	["Oc"] = 1e27,
	["No"] = 1e30,
	["Dc"] = 1e33,
}

local orderedSuffixes = {}
for suffix, _ in pairs(suffixes) do
	table.insert(orderedSuffixes, suffix)
end

table.sort(orderedSuffixes, function(a, b)
	return suffixes[a] < suffixes[b]
end)

function Encode(num)
	if num < 1000 then
		return tostring(num)
	end

	for i = #orderedSuffixes, 1, -1 do
		local suffix = orderedSuffixes[i]
		local value = suffixes[suffix]

		if num >= value then
			local rounded = math.floor((num / value) * 100) / 100
			return tostring(rounded) .. suffix
		end
	end

	return tostring(num)
end

function Decode(str)
	local num = tonumber(string.match(str, "[%d%.]+"))
	local suffix = string.match(str, "[%a]+")

	if suffixes[suffix] then
		return num * suffixes[suffix]
	end

	return tonumber(str) or 0
end

for i,v in pairs(workspace.Arenas:GetChildren()) do -- all stages
    for x,b in pairs(v:GetChildren()) do -- 1, 2, 3, 4 etc
        pcall(function()
            local PowerPart = b.SuggestedPart.BillboardGui.Frame.Number
			local Original = b.SuggestedPart.BillboardGui.Frame.Numbe.Text
            local Power = Decode(PowerPart)
            local Strenght = game:GetService("Players").LocalPlayer.leaderstats.Damage.Value
        
            if Strenght < (Power / 2.75) then
                PowerPart.TextColor3 = Color3.fromRGB(255, 0, 0)
            else
                PowerPart.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end)
    end
end


--workspace.Arenas.Stage19["4"].SuggestedPart.BillboardGui.Frame.Number
