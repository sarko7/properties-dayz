PropertyList = {}

function generateUUID()
    local random = math.random
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and random(0, 15) or random(8, 11)
        return string.format("%x", v)
    end)
end

currentId = Config.minId

function reformatPropertyData(propertys)
    for i = 1, #propertys do
        local property = propertys[i]

        PropertyList[#PropertyList+1] = {
            id = currentId,
            UUID = property.UUID,
            type = property.type,
            owner = property.owner,
            price_buy = property.price_buy,
            price_rental = property.price_rental,
            position = json.decode(property.position),
            shellName = property.shellName,
            rental_deadline = property.rental_deadline,
            address = property.address
        }

        currentId += 1
    end
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

function createProperty(newProperty)
    local uuid = propertyHasUuid()
    local position = json.encode(newProperty.position)

    local property = MySQL.insert.await('INSERT INTO `property` (UUID, type, price_buy, price_rental, position, shellName, address) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        uuid, 
        newProperty.type, 
        newProperty.price_sell,
        newProperty.price_rental,
        position,
        newProperty.shellName,
        newProperty.address
    })
end