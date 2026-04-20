local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local TrollRemote = LocalPlayer.PlayerGui
    :WaitForChild("Troll"):WaitForChild("Troll")
    :WaitForChild("TrollBtn"):WaitForChild("LocalScript")
    :WaitForChild("RemoteEvent")

-- Map PlaceIds to product IDs
local ProductMap = {
    [123882157996955] = 3485832735,
    [74235991966880] = 3492856822,
    [139733039793068] = 3513881790,
    [94754832944762] = 3511773536,
    [88761612446816] = 3506257777,
    [128334198813458] = 3492026771,
    [93052351618271] = 3512913788
}

local function getProductId()
    return ProductMap[game.PlaceId] or 3485832735 -- fallback to first ID
end

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

    task.wait(1)
end
