PropertyList = {}
PropertyPanel = {}
onProperty = nil

RegisterNetEvent("property:sendPropertys", function(propertys)
    PropertyList = propertys
    CreateSellPanel(PropertyList)
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    TriggerServerEvent("property:getPropertys")
end)

RegisterNetEvent("property:sendNewProperty", function(property)
    PropertyList[#PropertyList+1] = property
    CreateSellPanel({property})
    print(json.encode(property, {indent = true}))
end)

RegisterNetEvent("property:onEntry", function(shellName, id)
    print("Arriver client side des property current : Name :"..shellName.." ID :"..id)

    onProperty= {
        name = shellName,
        id = id
    }
end)

RegisterNetEvent("property:onAcquisition", function(id, newStatue)
    local property = findPropertyById(id)

    if not property then
        return
    end

    local panel = GetEntityAtCoords(property.position.panelPos, 2.0)

    if not panel then
        return
    end

    DeleteEntity(panel)
    property.statue = newStatue

    print(property.statue)
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
                        ESX.TriggerServerCallback('property:IsOwner', function(isOwner)
                            print(property.statue)
                            openAccesPropertyMenu(property.id, property.address, isOwner, property.statue, property.price_buy, property.price_rental)
                        end, property.id)
                    end
                end
            end
        end

        if onProperty then
            local exitDist = #(Config.PropertyList[onProperty.name].coords - playerCoords)

            if exitDist <= 10.0 then
                sleep = 0
                DrawMarker(25, Config.PropertyList[onProperty.name].coords - vec3(0, 0, 0.98), 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 255, 0, 0, 180)

                if exitDist <= 2.0 then
                    drawTextUI("Appuyer sur ~INPUT_CONTEXT~ pour sortir dans la propriété")

                    if (IsControlJustPressed(0, 51)) then
                        TriggerServerEvent("property:exit", onProperty.id)
                        onProperty = nil
                    end
                end
            end
        end

        Wait(sleep)
    end
end)