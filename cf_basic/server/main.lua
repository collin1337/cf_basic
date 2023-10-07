AddEventHandler('playerDropped', function(playerReason)
  TriggerClientEvent('cf_basic:combatlog:sendDisconnect', -1, source, GetPlayerName(source), GetEntityCoords(GetPlayerPed(source)), GetPlayerIdentifier(source, 0), playerReason)
end)