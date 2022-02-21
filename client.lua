local ESX, kiikari, display, bool, tarkkari, thermalvision, kiikaripaalla = nil, nil, nil, nil, nil, nil, nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local Whitelist = {
    'weapon_heavysniper',
    'weapon_heavysniper_mk2',
    'weapon_sniperrifle',
    'weapon_marksmanrifle'
}

local types = {
    'kiikari',
    'kiikaripois',
    'tv',
    'tvpois',
    'yonako',
    'yonakopois'
}

RegisterNUICallback('exit', function(data)
    SetDisplay(false)
end)

RegisterNUICallback('kiikariasetukset', function(data)
    for i = 1, #types do
        if data.type == types[i] then 
            SetDisplay(false)
            TriggerServerEvent('kiikari:asetukset', data.type)
        end
    end
end)

RegisterNetEvent('kiikari:paalle')
AddEventHandler('kiikari:paalle', function(kiikaripaalla)
    if kiikaripaalla then
        SetDisplay(true)
        disablecontrols()
    else
        ESX.ShowNotification('Hommaas se kiikari eka;)')
    end
end)

RegisterNetEvent('kiikari:tarkkarikiikari')
AddEventHandler('kiikari:tarkkarikiikari', function(bool)
    if bool then
        tarkkari = true
        tarkkarikiikari(bool)
    else
        tarkkari = false
        tarkkarikiikari(bool)
    end
end)

RegisterNetEvent('kiikari:thermalvision')
AddEventHandler('kiikari:thermalvision', function(bool)
    if bool then
        thermalvision = true
        Thermalli(bool)
    else
        thermalvision = false
        Thermalli(bool)
    end
end)

RegisterNetEvent('kiikari:nightvision')
AddEventHandler('kiikari:nightvision', function(bool)
    if bool then 
        nightvision = true
        nightvisioni(bool)
    else
        nightvision = false
        nightvisioni(bool)
    end
end)

function tarkkarikiikari(bool)
    while bool do
        Citizen.Wait(0)
        local aiming = IsPlayerFreeAiming(PlayerId())
        local ped = PlayerPedId()
        if GetFollowPedCamViewMode() ~= 4 and aiming then 
            local hit, coords = RayCastGamePlayCamera(10000)
            local position = GetEntityCoords(ped)
            local calc2 = math.floor(#(coords - position))
            while calc2 == 0 do
                Citizen.Wait(0)
                hit, coords = RayCastGamePlayCamera(10000)
                position = GetEntityCoords(ped)
                calc2 = math.floor(#(coords - position))
            end
            for i = 1, #Whitelist do
                if hit and GetSelectedPedWeapon(ped) == GetHashKey(Whitelist[i]) then
                    DrawScreenText(0.7, 1.1, 1.0, 1.0, 0.4, "Etäisyys: " .. calc2 .. ', Metriä', 207, 207, 207, 255)
                end
            end
        end
        if IsEntityDead(ped) then
            bool = false
        end
        if not tarkkari then 
            bool = false
        end
    end 
end

function Thermalli(bool)
    while bool do 
        Citizen.Wait(0)
        for k,v in pairs(Whitelist) do
            local ped = PlayerPedId()
            local aiming = IsPlayerFreeAiming(PlayerId())
            if GetFollowPedCamViewMode() ~= 4 and aiming then 
                if GetSelectedPedWeapon(ped) == GetHashKey(v) then
                    SetSeethrough(true)
                    print(bool)
                end
            else
                SetSeethrough(false)
            end
        end
        if not thermalvision then 
            bool = false
        end
    end
end

function nightvisioni(bool)
    while bool do 
        Citizen.Wait(0)
        for k,v in pairs(Whitelist) do
            local ped = PlayerPedId()
            local aiming = IsPlayerFreeAiming(PlayerId())
            if GetFollowPedCamViewMode() ~= 4 and aiming then 
                if GetSelectedPedWeapon(ped) == GetHashKey(v) then
                    SetNightvision(true)
                    print(bool)
                end
            else
                SetNightvision(false)
            end
        end
        if not nightvision then 
            bool = false
        end
    end
end

function disablecontrols()
    while display do 
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

function RotationToDirection(rotation)
	local adjustedRotation = 
	{ 
		x = (math.pi / 180) * rotation.x, 
		y = (math.pi / 180) * rotation.y, 
		z = (math.pi / 180) * rotation.z 
	}
	local direction = 
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), 
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
	local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = cameraCoord.x + direction.x * distance, 
		y = cameraCoord.y + direction.y * distance, 
		z = cameraCoord.z + direction.z * distance 
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end


function DrawScreenText(x,y, width, height, scale, text, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end