propertyList = {}

RegisterNetEvent("property:sendPropertys", function(propertyList)
    propertyList = propertyList

    print(json.encode(propertyList, {indent = true}))
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    TriggerServerEvent("property:getPropertys")
end)