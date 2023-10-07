---                 ::: General Configuration :::
---                 ::: Support / Discord / @collin1337 :::
---                 ::: by collin1337 :::

Config = {} -- Do Not Touch

Config.General_Client = { -- General Client Configuration
    ['Settings'] = {
        ['Infinity Stamina'] = true, -- Infinity Stamina
        ['Disable Idle Camera'] = true, -- If you want to Disable the Idle Cam
        ['Disable Wanted Level'] = true, -- If you want to Disable Wanted Level
        ['Disable Vehicle Controls'] = true, -- If you want to Disable Controls when the Vehicle is upside down
        ['Remove Hud Components'] = { -- Remove Hud Components
            [1] = true, --WANTED_STARS,
            [2] = false, --WEAPON_ICON
            [3] = true, --CASH
            [4] = true,  --MP_CASH
            [5] = false, --MP_MESSAGE
            [6] = true, --VEHICLE_NAME
            [7] = true,-- AREA_NAME
            [8] = true,-- VEHICLE_CLASS
            [9] = true, --STREET_NAME
            [10] = false, --HELP_TEXT
            [11] = false, --FLOATING_HELP_TEXT_1
            [12] = false, --FLOATING_HELP_TEXT_2
            [13] = true, --CASH_CHANGE
            [14] = false, --RETICLE
            [15] = false, --SUBTITLE_TEXT
            [16] = true, --RADIO_STATIONS
            [17] = false, --SAVING_GAME,
            [18] = false, --GAME_STREAM
            [19] = false, --WEAPON_WHEEL
            [20] = true, --WEAPON_WHEEL_STATS
            [21] = false, --HUD_COMPONENTS
            [22] = false, --HUD_WEAPONS
        }
    },

    ['Discord Presence'] = {
        Enabled = true, -- Enabled = true / Disabled = false

        ApplicationID = 'APPLICATION_ID',  -- Your Application --> https://discord.com/developers/applications

        SmallLogoName = 'SMALL_LOGO_NAME', -- Small Logo Name
        SmallLogoText = 'SMALL LOGO TEXT', -- Small Logo Text

        LargeLogoName = 'LARGE_LOGO_NAME', -- Large Logo Name
        LargeLogoText = 'LARGE LGO TEXT', -- Large Logo Text

        ['FirstButton'] = { -- FirstButton Button
            Name = 'Example 1', -- Button Name
            Link = 'https://github.com/collin1337', -- Button Link
        },

        ['SecondButton'] = { -- Second Button
            Name = 'Example 2', -- Button Name
            Link = 'https://github.com/collin1337', -- Button Link
        },

        updateIntervall = 60000, -- 1 Minute

        MaxSlots = '1337', -- Max Server Slots

        PresenceText = function() -- Discord Presence Text
            return GetPlayerName(PlayerId()) .. ' - ' ..  #GetActivePlayers() .. '/' .. Config.General_Client['Discord Presence'].MaxSlots
        end
    },

    ['Pause Menu'] = {
        Enabled = true, -- Enabled = true / Disabled = false

        Title = function() -- Pause Menu Title
            return '~p~FiveM Basic~s~ | ~g~'.. GetPlayerName(PlayerId()) ..'~s~ | ID: ~y~'.. GetPlayerServerId(PlayerId()) ..''
        end,

        Map = 'MAP', -- Map Text
        Game = 'GAME', -- Game Text
        Info = 'INFO', -- Info Text
        Stats = 'STATS', -- Status Text
        Settings = 'SETTINGS', -- Settings Text
        Galerie = 'GALLERY', -- Galerie Text
        Editor = 'EDITOR', -- Editor Text

        KeyBinds = 'Fivem Keybinds', -- KeyBinds Text

        Quit = 'Quit Game', -- Quit Text
        Leave = 'Leave Server', -- Leave Text
    },

    ['Blips Creator'] = { --You can add as much as u need
        { coords = vector3(-75.3101, -819.3862, 326.1749), sprite = 590, display = 2, scale = 0.8, color = 50, shortRange = true, text = 'collin1337' }, -- Example / https://docs.fivem.net/docs/game-references/blips/
    },

    ['Commands'] = {
        ['MapFix'] = { -- Refresh the MLO / Interior at Current Position
            Name = 'mapfix', -- Command Name
            Enabled = true  -- Command Enabled = true / Disabled = false
        }
    },

    ['Animations'] = {
        ['Hands Up'] = { -- Hands Up
            Enabled = true, -- Enabled = true / Disabled = false
            DisableWeapon = true, -- Enabled = true / Disabled = false (Disable Weapons During Hands Up)
            ['Settings'] = {
                animDictionary = 'random@mugging3', -- animDictionary
                animationName = 'handsup_standing_base' -- animationName
            }
        },
        ['Crouch'] = { -- Crouching
            Enabled = true, -- Enabled = true / Disabled = false
            DisableWeapon = true, -- Enabled = true / Disabled = false (Disable Weapons During Crouching)
        },
        ['Pointing'] = { -- Finger Pointing
            Enabled = true, -- Enabled = true / Disabled = false
            DisableWeapon = true, -- Enabled = true / Disabled = false (Disable Weapons During Pointing)
        },
        ['Radio Animtaion'] = { -- Radio Animtaion (!) NO FUNCTION JUST THE ANIMATION (!)
            Enabled = true, -- Enabled = true / Disabled = false
        },
    }
}
