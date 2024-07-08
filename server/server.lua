ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Vérifier l'inventaire et changer la plaque d'immatriculation
ESX.RegisterServerCallback('vehicle:changePlate', function(source, cb, newPlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local screwdriverCount = xPlayer.getInventoryItem(screwdriverItem).count
    local plateCount = xPlayer.getInventoryItem(plateItem).count

    if screwdriverCount > 0 and plateCount > 0 then
        xPlayer.removeInventoryItem(plateItem, 1)
        cb(true)
    else
        cb(false)
    end
end)
