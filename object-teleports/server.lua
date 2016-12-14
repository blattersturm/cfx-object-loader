AddEventHandler('chatMessage', function(source, name, message)
	if message:sub(1, 4) == '/mtp' then
		TriggerClientEvent('objectTeleports:handleTeleportCommand', source, message:sub(5))
		CancelEvent()
	end
end)