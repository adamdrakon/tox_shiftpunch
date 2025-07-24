Config = Config or {}

Config.Enabled = true -- Set false to disable the entire anti-shiftpunch system
Config.StaminaCost = 10.0 -- How much stamina should shift punching consume? MUST BE A FLOAT (0.0 to 100.0)
Config.MinStamina = 20.0 -- How much stamina (minimum) must a player have in order to shift punch? MUST BE A FLOAT (0.0 to 100.0)
Config.RagdollChance = 10 -- Chance (%) to fall over if trying to shiftpunch when stamina is too low
Config.RagdollTime = {
    Min = 1.5, -- Minimum duration (seconds) for which a player will be ragdolled
    Max = 3 -- Maximum duration (seconds) for which a player will be ragdolled
}
Config.AffectedMeleeWeapons = { -- List of extra weapons (keyed by hash) which the anti-shiftpunch system should account for
    [`WEAPON_KNUCKLE`] = true,
    [`WEAPON_BAT`] = true,
}