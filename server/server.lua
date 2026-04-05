ESX.RegisterServerCallback('wolfy_repair:HaveaRepairkit', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local HaveRepairKit = false

    if xPlayer.getInventoryItem(Wolfy.RepairKit).count > 0 then
        HaveRepairKit = true
    end

    cb(HaveRepairKit)
end)

RegisterNetEvent('wolfy_repair:EndReparing',function ()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if xPlayer.getInventoryItem(Wolfy.RepairKit).count > 0 then
        xPlayer.removeInventoryItem(Wolfy.RepairKit, 1)
    end
end)