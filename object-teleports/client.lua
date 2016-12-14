local spawns = {}

local function chatMessage(msg)
	TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

local function chatMessageYou(msg)
	TriggerEvent('chatMessage', 'You', {0, 250, 120}, msg)
end

local cancelFlag = false

RegisterNetEvent('objectTeleports:handleTeleportCommand')

AddEventHandler('objectTeleports:handleTeleportCommand', function(command)
	if #spawns == 0 then
		spawns = exports['object-loader']:getSpawns()
	end

	chatMessageYou('/mtp ' .. command)

	if command:len() == 0 then
		cancelFlag = false

		Citizen.CreateThread(function()
			if #spawns == 0 then
				chatMessage('^1No Object Loader Teleports are ^6loaded :(')
				return
			end

			chatMessage('^1Object Loader Teleports')

			for i, spawn in ipairs(spawns) do
				Citizen.Wait(750)

				if cancelFlag then
					cancelFlag = false
					break
				end

				chatMessage('^3/mtp ' .. i .. ': ^2' .. spawn.name)
			end
		end)
	else
		local idx = tonumber(command)

		if spawns[idx] then
			SetEntityCoords(GetPlayerPed(-1), spawns[idx].spawnPos[1], spawns[idx].spawnPos[2], spawns[idx].spawnPos[3])
			SetEntityHeading(GetPlayerPed(-1), spawns[idx].heading)

			chatMessage('Teleported to ^3' .. spawns[idx].name)

			cancelFlag = true
		else
			chatMessage('Invalid teleport: ' .. tostring(idx))
		end
	end
end)

AddEventHandler('objectLoader:onSpawnLoaded', function(data)
	if #spawns == 0 then
		spawns = exports['object-loader']:getSpawns()
	end

	table.insert(spawns, data)
end)