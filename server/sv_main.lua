
lib.callback.register('tox_shiftpunch:servercb:getconfig', function(src)
    local config = {
        Enabled = Config.Enabled,
        StaminaCost = Config.StaminaCost,
        MinStamina = Config.MinStamina,
        RagdollChance = Config.RagdollChance,
        RagdollTime = Config.RagdollTime,
        AffectedMeleeWeapons = Config.AffectedMeleeWeapons
    }

    return config
end)