ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local types = {
    'kiikari',
    'kiikaripois',
    'tv',
    'tvpois',
    'yonako',
    'yonakopois'
}

RegisterServerEvent('kiikari:asetukset')
AddEventHandler('kiikari:asetukset', function(type)
    if type == 'kiikari' then 
        TriggerClientEvent('kiikari:tarkkarikiikari', source, true)
        TriggerClientEvent('esx:showNotification', source, 'Tarkkarikiikari [PÄÄLLÄ]')
    elseif type == 'kiikaripois' then 
        TriggerClientEvent('kiikari:tarkkarikiikari', source, false)
        TriggerClientEvent('esx:showNotification', source, 'Tarkkarikiikari [POIS PÄÄLTÄ]')
    elseif type == 'tv' then 
        TriggerClientEvent('kiikari:thermalvision', source, true)
        TriggerClientEvent('esx:showNotification', source, 'Lämpökamera [PÄÄLLÄ]')
    elseif type == 'tvpois' then 
        TriggerClientEvent('kiikari:thermalvision', source, false)
        TriggerClientEvent('esx:showNotification', source, 'Lämpökamera [POIS PÄÄLTÄ]')
    elseif type == 'yonako' then 
        TriggerClientEvent('kiikari:nightvision', source, true)
        TriggerClientEvent('esx:showNotification', source, 'Yönäkö [PÄÄLLÄ]')
    elseif type == 'yonakopois' then 
        TriggerClientEvent('kiikari:nightvision', source, false)
        TriggerClientEvent('esx:showNotification', source, 'Yönäkö [POIS PÄÄLTÄ]')
    end
end)

ESX.RegisterUsableItem('kiikari', function(source)
    TriggerClientEvent('kiikari:paalle', source, true)
end)