PropertyList = {}
onProperty = nil

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
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i = 1, #PropertyList do
            local property = PropertyList[i]
            local entryPos = vec3(property.position.entryPos.x, property.position.entryPos.y, property.position.entryPos.z)
            local distEntry = #(entryPos - playerCoords)


            if distEntry <= 10.0 then
                sleep = 0
                DrawMarker(25, entryPos - vec3(0, 0, 0.98), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 0, 0, 180)

                if distEntry <= 2.0 then
                    drawTextUI("Appuyer sur ~INPUT_CONTEXT~ pour renter dans la propriété")

                    if (IsControlJustPressed(0, 51)) then
                        TriggerServerEvent("property:entry", property.id)
                        onProperty = property.shellName
                    end
                end
            end

            if onProperty then
                local exitDist = #(Config.PropertyList[onProperty].coords - playerCoords)

                if exitDist <= 10.0 then
                    sleep = 0
                    DrawMarker(25, Config.PropertyList[onProperty].coords - vec3(0, 0, 0.98), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 0, 0, 180)

                    if exitDist <= 2.0 then
                        drawTextUI("Appuyer sur ~INPUT_CONTEXT~ pour sortir dans la propriété")

                        if (IsControlJustPressed(0, 51)) then
                            TriggerServerEvent("property:exit", property.id)
                            onProperty = nil
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)