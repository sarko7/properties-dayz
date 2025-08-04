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
    if not self:GetIsOwner(src) then
        return print("Pas owner")
    end

    local entityId = GetPlayerPed(src)
    SetPlayerRoutingBucket(src, self.id)
    SetEntityCoords(entityId, Config.PropertyList[self.shellName].coords)
    TriggerClientEvent("property:onEntry", source, self.shellName, self.id)
end

function Property:Buy(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return
    end
    
    print(self.price_buy)

    print("Agent sur joueur : "..xPlayer.getAccount("bank").money)

    if xPlayer.getAccount("bank").money < self.price_buy then
        return
    end

    xPlayer.removeAccountMoney("bank", self.price_buy)
    saveBuyProperty(self.UUID, xPlayer.getIdentifier())
end

function Property:GetIsOwner(src)
    
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return false
    end

    if self.owner ~= xPlayer.getIdentifier() then
        return false
    end

    return true
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

function saveBuyProperty(uuid, license)
    MySQL.update('UPDATE property SET owner = ?, statue = 1 WHERE UUID = ?', {
        license,
        uuid
    })
end