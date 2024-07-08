ESX = nil
local screwdriverItem = 'screwdriver' -- Nom de l'item tournevis dans votre inventaire
local plateItem = 'license_plate' -- Nom de l'item plaque dans votre inventaire

-- Initialisation de ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Fonction pour changer la plaque d'immatriculation
function ChangeVehiclePlate(newPlate)
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71)
    if vehicle and DoesEntityExist(vehicle) then
        ESX.TriggerServerCallback('vehicle:changePlate', function(success)
            if success then
                SetVehicleNumberPlateText(vehicle, newPlate)
                ESX.ShowNotification('La plaque a été changée avec succès.')
            else
                ESX.ShowNotification('Vous avez besoin d\'outil.')
            end
        end, newPlate)
    else
        ESX.ShowNotification('Aucun véhicule à proximité pour changer la plaque.')
    end
end

-- Ajouter une cible à la plaque d'immatriculation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

        if vehicle and DoesEntityExist(vehicle) then
            local plateLightIndex = GetEntityBoneIndexByName(vehicle, 'platelight')
            if plateLightIndex ~= -1 then
                local plateCoords = GetWorldPositionOfEntityBone(vehicle, plateLightIndex)
                exports.ox_target:addBoxZone({
                    coords = plateCoords,
                    size = vec3(0.5, 0.5, 0.5),
                    rotation = GetEntityHeading(vehicle),
                    debug = false,
                    options = {
                        {
                            name = 'change_plate',
                            icon = 'fa-solid fa-screwdriver',
                            label = 'Changer la plaque d\'immatriculation',
                            onSelect = function()
                                local input = lib.inputDialog('Changer la plaque', {'Nouvelle plaque'})
                                if input then
                                    local newPlate = input[1]
                                    ChangeVehiclePlate(newPlate)
                                end
                            end
                        }
                    }
                })
            end
        end
    end
end)
