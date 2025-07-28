propertyList = {}

function generateUUID()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 15) or random(8, 11)
        return string.format("%x", v)
    end)
end

function sendNewProperty()
    
end

function createProperty(type, position, shellName, adresse)
    local uuid = propertyHasUuid()


end

function propertyHasUuid()
    local uuid = generateUUID()

    for i = 1, #propertyList do
        local property = propertyList[i]

        if property.uuid == uuid then
            propertyHasUuid()
        end
    end
    return uuid
end

RegisterNetEvent("property:getPropertys", function()
    TriggerClientEvent("property:sendPropertys", source, propertyList)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return
    end
    
    MySQL.query('SELECT * FROM `property`', function(propertys)
        propertyList = propertys
    end)
end)