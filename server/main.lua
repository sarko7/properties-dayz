RegisterNetEvent("property:getPropertys", function()
    TriggerClientEvent("property:sendPropertys", source, PropertyList)

    print(json.encode(PropertyList, {indent = true}))
end)

RegisterNetEvent("property:createPoperty", function(newProperty)
    PropertyList[#PropertyList+1] = newProperty

    Property:CreateProperty(true, newProperty)
    TriggerClientEvent("property:sendNewProperty", -1, newProperty)
end)

RegisterNetEvent("property:entry", function(id)
    local property = findPropertyById(id)

    if property then
        property:Entry(source)
        TriggerClientEvent("property:onEntry", source, property.shellName, property.id)
    end
end)

RegisterNetEvent("property:exit", function(id)
    local property = findPropertyById(id)

    if property then
        property:Exit(source)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    local propertys = MySQL.query.await('SELECT * FROM `property`')

    for i = 1, #propertys do
        local property = propertys[i]
        property.position = json.decode(property.position)
        Property:CreateProperty(false, property)
    end
end)