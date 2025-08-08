function generateUUID()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 15) or random(8, 11)
        return string.format("%x", v)
    end)
end

function propertyHasUuid()
    local uuid = generateUUID()

    for i = 1, #PropertyList do
        local property = PropertyList[i]

        if property.uuid == uuid then
            propertyHasUuid()
        end
    end
    return uuid
end

function saveProperty(uuid, newProperty)
    local property = MySQL.insert.await('INSERT INTO `property` (UUID, type, price_buy, price_rental, position, shellName, address) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        uuid, 
        newProperty.type, 
        newProperty.price_buy,
        newProperty.price_rental,
        json.encode(newProperty.position),
        newProperty.shellName,
        newProperty.address
    })
end

function findPropertyById(id)
    for i = 1, #PropertyList do
        if PropertyList[i].id == id then
            return PropertyList[i]
        end
    end
    return nil
end


ESX.RegisterServerCallback('property:IsOwner', function(src, cb, propertyId)
    local property = findPropertyById(propertyId)

    if not property then
        cb(nil)
        return
    end

    if not property:GetIsOwner(src) then
        cb(false)
        return
    end

    cb(true)
end)