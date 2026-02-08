
local ClientId = game:GetService('RbxAnalyticsService'):GetClientId()
local UserId = game.Players.LocalPlayer.UserId
local Username = game.Players.LocalPlayer.Name

setclipboard(ClientId)

print("READ ME , what u got")
print("ClientId:", ClientId, "copied this one only")
print("UserId:", UserId)
print("Username:", Username)

game.StarterGui:SetCore("SendNotification", {
    Title = "ClientId";
    Text = "ClientId: " .. ClientId .. "\nUserId: " .. UserId;
    Duration = 10;
})
