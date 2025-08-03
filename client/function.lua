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

    if not newProperty.price_rental or not newProperty.price_sell then
        return false
    end

    return true
end

function drawTextUI(text)
    AddTextEntry("HelpNotification", text or "null")
    DisplayHelpTextThisFrame("HelpNotification", false)
end