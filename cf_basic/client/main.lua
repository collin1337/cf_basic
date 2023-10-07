local isSpawned = false

local showDisconnectText = false

local function RegisterKey(command, desc, keybind)
    RegisterKeyMapping(command, desc, 'keyboard', keybind)
end

local function Draw3DText(x, y, z, text, scale, r, g, b, a)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(scale, scale)
    SetTextFont(6) -- Orgi 6
    SetTextProportional(1)
    SetTextEntry('STRING')
    SetTextCentre(true)
    SetTextDropshadow(10.0, r, g, b, a)
    SetTextColour(r, g, b, a)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function ShowDisconnect(playerSource, playerName, playerCoords, playerIdentifier, playerReason)
    local displaying = true
    showDisconnectText = true

    Citizen.CreateThread(function()
        Citizen.Wait(20000)
        displaying = false
        showDisconnectText = false
    end)

    Citizen.CreateThread(function()
        while displaying do
            Citizen.Wait(0)
            local pcoords = GetEntityCoords(PlayerPedId())
            if #(GetEntityCoords(PlayerPedId()) - vector3(playerCoords.x, playerCoords.y, playerCoords.z)) <= 12.0 and showDisconnectText then
                Draw3DText(playerCoords.x, playerCoords.y, playerCoords.z - 0.6, '['..playerSource..'] '..playerName, 0.45, 255, 255, 255, 255)
                Draw3DText(playerCoords.x, playerCoords.y, playerCoords.z - 0.8, 'Reason: '..playerReason, 0.45, 255, 255, 255, 255)
            else
                Citizen.Wait(1500)
            end
        end
    end)
end

local function playerSpawned()
    if Config.General_Client['Settings']['Disable Idle Camera'] then
        DisableIdleCamera(true)
    end

    if Config.General_Client['Settings']['Infinity Stamina'] then
        StatSetInt('MP0_STAMINA', 100, true)
    end

    if Config.General_Client['Settings']['Disable Wanted Level'] then
        ClearPlayerWantedLevel(PlayerId())
        SetMaxWantedLevel(0)
    end

    for i = 1, #(Config.General_Client['Settings']['Remove Hud Components']) do
        if Config.General_Client['Settings']['Remove Hud Components'][i] then
            SetHudComponentPosition(i, 999999.0, 999999.0)
        end
    end
end

local function HaendeInDieHoeh()
    RequestAnimDict('random@mugging3')
    while not HasAnimDictLoaded('random@mugging3') do
        Citizen.Wait(100)
    end

    if (DoesEntityExist(PlayerPedId())) and not (IsEntityDead(PlayerPedId())) and (IsPedOnFoot(PlayerPedId())) then
        hatDieHaendeInDieHoeh = not hatDieHaendeInDieHoeh
        if hatDieHaendeInDieHoeh then
            if (not IsPauseMenuActive()) then
                if Config.General_Client.Animations['Hands Up'].DisableWeapon then
                    lastWeapon = GetSelectedPedWeapon(PlayerPedId(), false)
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'),true)
                    SetCanPedEquipAllWeapons(PlayerPedId(), false)
                end
                TaskPlayAnim(PlayerPedId(), Config.General_Client.Animations['Hands Up']['Settings'].animDictionary, Config.General_Client.Animations['Hands Up']['Settings'].animationName, 5.0, 8.0, -1, 50, 0, false, false, false)
            end
        else
            SetCanPedEquipAllWeapons(PlayerPedId(), true)
            SetCurrentPedWeapon(PlayerPedId(), lastWeapon, true)
            ClearPedTasks(PlayerPedId())
        end
    end
end

local function GehAufDieKnie()
    if (DoesEntityExist(PlayerPedId())) and not (IsEntityDead(PlayerPedId())) and (IsPedOnFoot(PlayerPedId())) then
        hatDieKnieAufmBoden = not hatDieKnieAufmBoden
        if hatDieKnieAufmBoden then
            if (not IsPauseMenuActive()) then
                RequestAnimSet('move_ped_crouched')

                while (not HasAnimSetLoaded('move_ped_crouched')) do
                    Citizen.Wait(100)
                end

                if Config.General_Client.Animations['Crouch'].DisableWeapon then
                    lastWeapon = GetSelectedPedWeapon(PlayerPedId(), false)
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'),true)
                    SetCanPedEquipAllWeapons(PlayerPedId(), false)
                end

                SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 0.25)
            end
        else
            ResetPedMovementClipset(PlayerPedId(), 0)
            SetCanPedEquipAllWeapons(PlayerPedId(), true)
            SetCurrentPedWeapon(PlayerPedId(), lastWeapon, true)
            ClearPedTasks(PlayerPedId())
        end
    end
end

local function FingerHoch()
    RequestAnimDict('anim@mp_point')
    while not HasAnimDictLoaded('anim@mp_point') do
        Citizen.Wait(100)
    end
    SetPedCurrentWeaponVisible(PlayerPedId(), 0, 1, 1, 1)
    SetPedConfigFlag(PlayerPedId(), 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, PlayerPedId(), 'task_mp_pointing', 0.5, 0, 'anim@mp_point', 24)
    RemoveAnimDict('anim@mp_point')
end

local function FingerRunter()
    Citizen.InvokeNative(0xD01015C7316AE176, PlayerPedId(), 'Stop')
    if not IsPedInjured(PlayerPedId()) then
        ClearPedSecondaryTask(PlayerPedId())
    end
    if not IsPedInAnyVehicle(PlayerPedId(), 1) then
        SetPedCurrentWeaponVisible(PlayerPedId(), 1, 1, 1, 1)
    end
    SetPedConfigFlag(PlayerPedId(), 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local function MachDenFingerNachOben()
    hatDenFingerOben = not hatDenFingerOben
    if hatDenFingerOben then
        if Config.General_Client.Animations['Pointing'].DisableWeapon then
            lastWeapon = GetSelectedPedWeapon(PlayerPedId(), false)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'),true)
            SetCanPedEquipAllWeapons(PlayerPedId(), false)
        end
        FingerHoch()
        while hatDenFingerOben do
            Citizen.Wait(0)
            if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
                if not IsPedOnFoot(PlayerPedId()) then
                    stopPointing()
                else
                    local ped = PlayerPedId()
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
                    camPitch = (camPitch + 70.0) / 112.0
                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading = Cos(camHeading)
                    local sinCamHeading = Sin(camHeading)
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end
                    camHeading = (camHeading + 180.0) / 360.0
                    local blocked = 0
                    local nn = 0
                    local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                    local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                    nn,blocked,coords,coords = GetRaycastResult(ray)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, 'Pitch', camPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, 'Heading', camHeading * -1.0 + 1.0)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, 'isBlocked', blocked)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, 'isFirstPerson', Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
                end
            end
        end
    else
        FingerRunter()
        SetCanPedEquipAllWeapons(PlayerPedId(), true)
        SetCurrentPedWeapon(PlayerPedId(), lastWeapon, true)
        ClearPedTasks(PlayerPedId())
    end
end

local function FunkCheck()
    RequestAnimDict('random@arrests')
    while not HasAnimDictLoaded('random@arrests') do
        Citizen.Wait(10)
    end

    if (DoesEntityExist(PlayerPedId())) and not (IsEntityDead(PlayerPedId())) then
        if (not IsPauseMenuActive()) then
            TaskPlayAnim(PlayerPedId(), 'random@arrests','generic_radio_chatter', 2.0, 0.150, 0.150, 50, 0, false, false, false);
        end
    end
end

local function Check()
    if (DoesEntityExist(PlayerPedId())) and not (IsEntityDead(PlayerPedId())) then
        if (not IsPauseMenuActive()) then
            StopAnimTask(PlayerPedId(), 'random@arrests','generic_radio_chatter', -3.0);
        end
    end
end

local function StartBasicThread()
    if Config.General_Client['Discord Presence'].Enabled then
        Citizen.CreateThread(function()
            while true do
                SetDiscordAppId(Config.General_Client['Discord Presence'].ApplicationID)
                SetDiscordRichPresenceAsset(Config.General_Client['Discord Presence'].LargeLogoName)
                SetDiscordRichPresenceAssetText(Config.General_Client['Discord Presence'].LargeLogoText)
                SetDiscordRichPresenceAssetSmall(Config.General_Client['Discord Presence'].SmallLogoName)
                SetDiscordRichPresenceAssetSmallText(Config.General_Client['Discord Presence'].SmallLogoText)
                SetDiscordRichPresenceAction(0, Config.General_Client['Discord Presence'].FirstButton.Name, Config.General_Client['Discord Presence'].FirstButton.Link)
                SetDiscordRichPresenceAction(1, Config.General_Client['Discord Presence'].SecondButton.Name, Config.General_Client['Discord Presence'].SecondButton.Link)

                SetRichPresence(Config.General_Client['Discord Presence'].PresenceText())

                Citizen.Wait(Config.General_Client['Discord Presence'].updateIntervall)
            end
        end)
    end

    if Config.General_Client['Pause Menu'].Enabled then
        Citizen.CreateThread(function()
            AddTextEntry('PM_SCR_MAP', Config.General_Client['Pause Menu'].Map)
            AddTextEntry('PM_SCR_STA', Config.General_Client['Pause Menu'].Stats)
            AddTextEntry('PM_SCR_GAM', Config.General_Client['Pause Menu'].Game)
            AddTextEntry('PM_SCR_INF', Config.General_Client['Pause Menu'].Info)
            AddTextEntry('PM_SCR_SET', Config.General_Client['Pause Menu']['Settings'])
            AddTextEntry('PM_SCR_GAL', Config.General_Client['Pause Menu'].Galerie)
            AddTextEntry('PM_SCR_RPL', Config.General_Client['Pause Menu'].Editor)

            AddTextEntry('PM_PANE_CFX', Config.General_Client['Pause Menu'].KeyBinds)

            AddTextEntry('PM_PANE_LEAVE', Config.General_Client['Pause Menu'].Leave)
            AddTextEntry('PM_PANE_QUIT', Config.General_Client['Pause Menu'].Quit)

            AddTextEntry('FE_THDR_GTAO', Config.General_Client['Pause Menu'].Title())
        end)
    end

    if Config.General_Client['Blips Creator'] ~= nil then
        Citizen.CreateThread(function()
            for k, v in pairs(Config.General_Client['Blips Creator']) do
                local blip = AddBlipForCoord(v.coords)
                SetBlipSprite(blip, v.sprite)
                SetBlipDisplay(blip, v.display)
                SetBlipScale(blip, v.scale)
                SetBlipColour(blip, v.color)
                SetBlipAsShortRange(blip, v.shortRange)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(v.text)
                EndTextCommandSetBlipName(blip)
            end
        end)
    end

    if Config.General_Client['Settings']['Disable Vehicle Controls'] then
        CreateThread(function()
            while true do
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local roll = GetEntityRoll(vehicle)
                if GetVehiclePedIsIn(PlayerPedId(), false) then
                    if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
                        sleep = 0
                        DisableControlAction(2, 59, true)
                        DisableControlAction(2, 60, true)
                    else
                        sleep = 500
                    end
                end
                Wait(sleep)
            end
        end)
    end
end

local function StartCommandsThread()
    if Config.General_Client['Commands']['MapFix'].Enabled then
        RegisterCommand(Config.General_Client['Commands'].MapFix.Name, function()
            PinInteriorInMemory(GetInteriorAtCoords(GetEntityCoords(PlayerPedId())))
            RefreshInterior(GetInteriorAtCoords(GetEntityCoords(PlayerPedId())))
            print('Refresh Interior: ' .. GetInteriorAtCoords(GetEntityCoords(PlayerPedId())) .. ' | '.. GetEntityCoords(PlayerPedId()) )
        end)
    end

    if Config.General_Client.Animations['Hands Up'].Enabled then
        RegisterCommand('-haendeindiehoeh', function()
            HaendeInDieHoeh()
        end)
        RegisterKey('-haendeindiehoeh', 'Hands Up', 'H')
    end

    if Config.General_Client.Animations['Crouch'].Enabled then
        RegisterCommand('-gehaufdieknie', function()
            GehAufDieKnie()
        end)
        RegisterKey('-gehaufdieknie', 'Crouch', 'Q')
    end

    if Config.General_Client.Animations['Pointing'].Enabled then
        RegisterCommand('-hatdenfingeroben', function()
            MachDenFingerNachOben()
        end)
        RegisterKey('-hatdenfingeroben', 'Pointing', 'B')
    end

    if Config.General_Client.Animations['Radio Animtaion'].Enabled then
        RegisterCommand('+funkcheck', function()
            FunkCheck()
        end)

        RegisterCommand('-funkcheck', function()
            Check()
        end)
        RegisterKey('+funkcheck', 'Radio Animtaion', 'N')
    end
end

AddEventHandler('playerSpawned', function()
    isSpawned = true

    if isSpawned then
        playerSpawned()
    end
end)

Citizen.CreateThread(function()
    if NetworkIsPlayerActive(PlayerId()) then
        StartBasicThread()
        StartCommandsThread()
    end

    print('^0[^5CF_BASIC^0 DEBUG] ^1>>^0 StartBasicThread() ^0')
    print('^0[^5CF_BASIC^0 DEBUG] ^1>>^0 StartCommandsThread() ^0')
end)

RegisterNetEvent('cf_basic:combatlog:sendDisconnect')
AddEventHandler('cf_basic:combatlog:sendDisconnect', function(playerSource, playerName, playerCoords, playerIdentifier, playerReason)
    ShowDisconnect(playerSource, playerName, playerCoords, playerIdentifier, playerReason)
end)