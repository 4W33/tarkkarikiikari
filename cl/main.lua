local ESX, kiikari = nil, nil

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

RegisterNetEvent('tarkkakiikari:kiikari')
AddEventHandler('tarkkakiikari:kiikari', function(kiikari)
    while kiikari do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local ped2 = PlayerId()
        local aiming = IsPlayerFreeAiming(ped2)
        if GetFollowPedCamViewMode() ~= 4 and aiming then -- if kiikari then
            local hit, coords = RayCastGamePlayCamera(4491)
            local weapon = GetWeapontypeModel(GetSelectedPedWeapon(ped))
            local position = GetEntityCoords(ped)
            local calc2 = math.floor(#(coords - position))
            while calc2 == 0 do
                Citizen.Wait(0)
                hit, coords = RayCastGamePlayCamera(4491)
                position = GetEntityCoords(ped)
                calc2 = math.floor(#(coords - position))
                print(calc2)
            end
            for i = 1, #Whitelist do
                if hit and GetSelectedPedWeapon(ped) == GetHashKey(Whitelist[i]) then
                    DrawScreenText(0.7, 1.1, 1.0, 1.0, 0.4, "Etäisyys: " .. calc2 .. ', Metriä', 207, 207, 207, 255)
                end
            end
        end
        if IsEntityDead(ped) then
            kiikari = false
        end
    end 
end)


RegisterCommand('kiikaripois', function()
    TriggerEvent('tarkkakiikari:kiikari', false)
end)

RegisterCommand('kiikari', function()
    TriggerEvent('tarkkakiikari:kiikari', true)
end)

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