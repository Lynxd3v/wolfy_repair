ESX = exports.es_extended:getSharedObject()
local IsReparing = false
local StopReparing = false

local function StartRepairing(dict, name, vehicle)
    local ped = PlayerPedId()
    local time = 60 -- 1 minute
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end

    StopReparing = false
    IsReparing = true

    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, max.y + 0.2, 0.0)

    TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, 1.0, 5000, GetEntityHeading(vehicle) - 180.0, 0.2)

    Wait(200)

    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local vehCoords = vector3(coords.x, coords.y, coords.z)
        local distance = #(pCoords - vehCoords)

        if distance < 1.0 then
            ClearPedTasks(ped)
            break
        end

        if StopReparing then
            ClearPedTasks(ped)
            return
        end
        Wait(100)
    end

    FreezeEntityPosition(vehicle, true)

    SetEntityCoords(ped, coords.x, coords.y, coords.z - 1.0, false, false, false, true)
    SetEntityHeading(ped, GetEntityHeading(vehicle))

    SendNUIMessage({
        type = 'startProgressBar',
        duration = 61000
    })

    TaskPlayAnim(ped, dict, name, 8.0, 1.0, -1, 1, 1.0, false, false, false)

    SetEntityHeading(ped, GetEntityHeading(vehicle))
    TaskPlayAnim(ped, dict, name, 8.0, 1.0, -1, 1, 1.0, false, false, false)

    while time > 0 do
        if StopReparing then
            FreezeEntityPosition(vehicle,false)
            IsReparing = false
            return
        else
            time = time - 1
        end
        Wait(1000)
    end

    IsReparing = false
    ClearPedTasks(ped)
    FreezeEntityPosition(vehicle,false)

    if DoesEntityExist(vehicle) then
        local Fuellevel = GetVehicleFuelLevel(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleFuelLevel(vehicle, Fuellevel)
        TriggerServerEvent('wolfy_repair:EndReparing')
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        if IsReparing then
            sleep = 0

            if IsControlJustPressed(0, 73) then
                StopReparing = true
                IsReparing = false
                ClearPedTasks(PlayerPedId())
                SendNUIMessage({
                    type = 'hideProgressBar'
                })
            end

            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 36, true)

            DisableControlAction(0, 22, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    exports.ox_target:addGlobalVehicle({
        label = 'Jármű javítása',
        name = 'wolfy_repair:Repairoptions',
        icon = "fa-solid fa-toolbox",
        distance = 2.5,
        canInteract = function()
            return not IsReparing
        end,
        onSelect = function(data)
            ESX.TriggerServerCallback('wolfy_repair:HaveaRepairkit', function(Have)
                if Have then
                    StartRepairing("amb@world_human_vehicle_mechanic@male@base", "base", data.entity)
                else
                    ESX.ShowNotification('Nincsen nálad javító készlet', 5000, 'info')
                end
            end)
        end
    })
end)

RegisterNetEvent('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    ClearPedTasks(PlayerPedId())
end)
