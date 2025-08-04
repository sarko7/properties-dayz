function keyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function hasValidPropertyData()
    if not newProperty then
        return false
    end

    if not streetProperty or not propertyNumber or not newProperty.shellName then
        return false
    end

    if not newProperty.position or not newProperty.position.entryPos or not newProperty.position.panelPos then
        return false
    end

    if not newProperty.price_rental or not newProperty.price_buy then
        return false
    end

    return true
end

function drawTextUI(text)
    AddTextEntry("HelpNotification", text or "null")
    DisplayHelpTextThisFrame("HelpNotification", false)
end

function CreateProps(model, pos, heading, isNetwork)
    local propsHash = GetHashKey(model)
    RequestModel(propsHash)
    while not HasModelLoaded(propsHash) do Wait(100) end
    local props = CreateObject(propsHash, pos, isNetwork, false, false)
    PlaceObjectOnGroundProperly(props)
    SetEntityHeading(props, heading)
    SetEntityInvincible(props, true)
    SetBlockingOfNonTemporaryEvents(props, true)
    FreezeEntityPosition(props, true)
    return props
end

function CreateSellPanel(propertys)
    for i = 1, #propertys do
        local property = propertys[i]

        if property.statue == 0 then
            local pos = vec3(property.position.panelPos.x, property.position.panelPos.y, property.position.panelPos.z)
            local props = CreateProps("prop_forsale_sign_05", pos, property.position.panelHeading, false)
            PropertyPanel[#PropertyPanel+1] = props
        end
    end
end