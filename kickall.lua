local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local TrollRemote = LocalPlayer.PlayerGui
    :WaitForChild("Troll"):WaitForChild("Troll")
    :WaitForChild("TrollBtn"):WaitForChild("LocalScript")
    :WaitForChild("RemoteEvent")

-- Map PlaceIds to product IDs
local ProductMap = {
    [88993574192386] = 3530789704,
    [77451737406508] = 3503251274
}

-- Function to get correct product ID
local function getProductId()
    return ProductMap[game.PlaceId] or 3530789704 -- fallback
end

-- Loop every second
while true do
    local productId = getProductId()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            TrollRemote:FireServer(player.Name)
            MarketplaceService:SignalPromptProductPurchaseFinished(
                LocalPlayer.UserId,
                productId,
                true
            )
        end
    end

    task.wait(1) -- 1 second delay
end
