RegisterNetEvent("property:getPropertys", function()
    TriggerClientEvent("property:sendPropertys", source, PropertyList)

    print(json.encode(PropertyList, {indent = true}))
end)

RegisterNetEvent("property:createPoperty", function(newProperty)
    createProperty(newProperty)

    newProperty.id = currentId
    currentId += 1
    PropertyList[#PropertyList+1] = newProperty
    TriggerClientEvent("property:sendNewProperty", -1, newProperty)

    print(json.encode(PropertyList, {indent = true}))
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    local propertys = MySQL.query.await('SELECT * FROM `property`')

    reformatPropertyData(propertys)

end)