PropertyList = {}

RegisterNetEvent("property:sendPropertys", function(propertys)
    PropertyList = propertys
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    TriggerServerEvent("property:getPropertys")
end)

RegisterNetEvent("property:sendNewProperty", function(property)
    PropertyList[#PropertyList+1] = property
    print(json.encode(property, {indent = true}))
end)

CreateThread(function()
    local sleep = 1000
    while true do
        sleep = 1000
        for i = 1, #PropertyList do
            local property = PropertyList[i]
            local playerCoords = GetEntityCoords(PlayerPedId())
            local entryPos = vec3(property.position.entryPos.x, property.position.entryPos.y, property.position.entryPos.z)
            local distEntry = #(entryPos - playerCoords)


            if distEntry <= 10.0 then
                sleep = 0
                DrawMarker(25, entryPos - vec3(0, 0, 0.98), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 0, 0, 180)
            end
        end
        Wait(sleep)
    end
end)