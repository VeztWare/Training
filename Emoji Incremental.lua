function RequestClick(Type, Emoji_Number, ItemName)
    local args = {
        [1] = {
            ["\0"] = {
                [1] = {
                    [Type] = {
                        [Emoji_Number] = {
                            [1] = ItemName
                        }
                    }
                }
            }
        },
        [2] = {}
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("RedEvent"):FireServer(unpack(args))
end

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Statics.GameContainer.GameArea.Items:GetChildren()) do
    RequestClick(v:GetAttribute("Type"), tostring(v:GetAttribute("EmojiNumber")), v.Name)
end
