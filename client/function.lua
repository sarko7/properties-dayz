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

    if not newProperty.address or not newProperty.propertyNumber or not newProperty.shellName then
        return false
    end

    if not newProperty.position or not newProperty.position.entryPos or not newProperty.position.panelPos then
        return false
    end

    if not newProperty.price or not newProperty.price.rental or not newProperty.price.sell then
        return false
    end

    return true
end
