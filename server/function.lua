PropertyList = {}
Property = {}

currentId = Config.minId

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

function Property:CreateProperty(isNew, newProperty)
    local uuid = generateUUID()
    newProperty.UUID = uuid
    newProperty.id = currentId
    currentId += 1

    local instance = newProperty
    setmetatable(instance, {__index = Property})

    PropertyList[#PropertyList+1] = newProperty

    if isNew then
        saveProperty(uuid, newProperty)
    end
end

function Property:Exit(src)
    local entityId = GetPlayerPed(src)

    SetPlayerRoutingBucket(src, 0)
    SetEntityCoords(entityId, self.position.entryPos.x, self.position.entryPos.y, self.position.entryPos.z)
end

function Property:Entry(src)
    local entityId = GetPlayerPed(src)

    SetPlayerRoutingBucket(src, self.id)
    SetEntityCoords(entityId, Config.PropertyList[self.shellName].coords)
end

function saveProperty(uuid, newProperty)
    local property = MySQL.insert.await('INSERT INTO `property` (UUID, type, price_buy, price_rental, position, shellName, address) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        uuid, 
        newProperty.type, 
        newProperty.price_sell,
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