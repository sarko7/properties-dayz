
local mainPropertyCreator = RageUI.CreateMenu(nil, "Gestion immobiliere", 0, 0)
local choosePropertyType = RageUI.CreateSubMenu(mainPropertyCreator, nil, "Chosir le type de la propriété", 0, 0)
local builderProperty = RageUI.CreateSubMenu(choosePropertyType, nil, "Création de properiété", 0, 0)
local coordsProperty = RageUI.CreateSubMenu(builderProperty, nil, "Choisir le position", 0, 0)
local chooseInteriorProperty = RageUI.CreateSubMenu(builderProperty, nil, "Choisir l'intérieur", 0, 0)

streetProperty = nil
propertyNumber = nil

newProperty = {}

function openPropertyCreator()
    if menuAdminState then return end

    mainPropertyCreator.Closed = function()
        menuState = false
    end

    menuState = true
    RageUI.Visible(mainPropertyCreator, true)

    CreateThread(function()
        while menuState do

            RageUI.IsVisible(mainPropertyCreator, function()

                RageUI.Button("Crée une propriété", nil, {}, true, {
                    onSelected = function()
                        newProperty = {}
                    end
                }, choosePropertyType)

                RageUI.Button("Liste des propriétés", nil, {}, true, {})

            end)

            RageUI.IsVisible(choosePropertyType, function()

                for typeName, typeLabel in pairs(Config.PropertyType) do
                    RageUI.Button(("Crée un %s"):format(typeLabel), nil, {}, true, {
                        onSelected = function()
                            newProperty.type = typeName
                            newProperty.position = {}
                            streetProperty = nil
                            propertyNumber = nil
                        end
                    }, builderProperty)
                end
    
            end)

            RageUI.IsVisible(builderProperty, function()
                if newProperty.type and newProperty.position then

                    RageUI.Button("Chosir l'intérieur", nil, {RightLabel = not newProperty.shellLabel and nil or newProperty.shellLabel}, true, {}, chooseInteriorProperty)

                    RageUI.Button("Le numéro de properiété", nil, {RightLabel = not propertyNumberr and nil or propertyNumber}, true, {
                        onSelected = function ()
                            propertyNumber = keyboardInput("Entrer le numéro de la propriété", nil, 3)
                        end
                    })

                    RageUI.Button("Prix de vente", nil, {RightLabel = not newProperty.price_sell and nil or ("~g~%s$"):format(newProperty.price_sell or 0)}, true, {
                        onSelected = function()
                            newProperty.price_sell = keyboardInput("Entrer le prix de vente", nil, 10)
                        end
                    })

                    RageUI.Button("Prix a la location", nil, {RightLabel = not newProperty.price_rental and nil or ("~b~%s$"):format(newProperty.price_rental or 0)}, true, {
                        onSelected = function()
                            newProperty.price_rental = keyboardInput("Entrer le prix a la locaiton par jour", nil, 10)
                        end
                    })

                    if newProperty.position.panelPos then
                        DrawMarker(0, newProperty.position.panelPos, 0, 0.0, 0.0, 0, 0, 0, 0.80, 0.80, 0.80, 255, 255, 255, 80)
                    end

                    RageUI.Line()

                    RageUI.Button("Position panneau", nil, {RightBadge = not newProperty.position.panelPos and RageUI.BadgeStyle.None or RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            newProperty.position.panelPos = GetEntityCoords(PlayerPedId())
                            newProperty.position.panelHeading = GetEntityHeading(PlayerPedId())
                        end
                    })

                    if newProperty.position.entryPos then
                        DrawMarker(0, newProperty.position.entryPos, 0, 0.0, 0.0, 0, 0, 0, 0.80, 0.80, 0.80, 255, 255, 255, 80)
                    end

                    RageUI.Button("Position d'entré", nil, {RightBadge = not newProperty.position.entryPos and RageUI.BadgeStyle.None or RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            local playerStreet, crossingRoad = GetStreetNameAtCoord(playerCoords.x , playerCoords.y, playerCoords.z)
                            local streetName = GetStreetNameFromHashKey(playerStreet)
                            streetProperty = streetName
                            newProperty.position.entryPos = playerCoords
                        end
                    })

                    if newProperty.position.exitGaragePos then
                        DrawMarker(0, newProperty.position.exitGaragePos, 0, 0.0, 0.0, 0, 0, 0, 0.80, 0.80, 0.80, 255, 255, 255, 80)
                    end

                    if newProperty.type == "garage" then
                        RageUI.Button("Position de sortie du garage", nil, {RightBadge = not newProperty.position.exitGaragePos and RageUI.BadgeStyle.None or RageUI.BadgeStyle.Tick}, true, {
                            onSelected = function()
                                newProperty.position.exitGaragePos = GetEntityCoords(PlayerPedId())
                                newProperty.position.exitGarageHeading = GetEntityHeading(PlayerPedId())
                            end
                        })
                    end

                    RageUI.Line()

                    RageUI.Button("Valider la création", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            if hasValidPropertyData() then
                                newProperty.address = ("%s %s"):format(propertyNumber, streetProperty)
                                TriggerServerEvent("property:createPoperty", newProperty)
                                newProperty = {}
                                RageUI.GoBack()
                            end
                        end
                    })

                end
            end)


            RageUI.IsVisible(chooseInteriorProperty, function()

                for propertyName, propertyData in pairs(Config.PropertyList) do
                    local property = Config.PropertyList[i]

                    if newProperty.type == propertyData.category then
                        RageUI.Button(propertyData.label, nil, {}, true, {
                            onSelected = function()
                                newProperty.shellName = propertyName
                                newProperty.shellLabel = propertyData.label
                                RageUI.GoBack()
                            end
                        })
                    end
                end

            end)

            Wait(0)
        end
    end)
end

RegisterCommand("property", function(source, args, rawCommand)
    openPropertyCreator()
end, false)