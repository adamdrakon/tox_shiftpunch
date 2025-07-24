
local enabled, stamcost, minstam, ragdollchance, ragdolltime, weapons = false, 0, 0, 0, {Min=1.5,Max = 3.0}, {} -- do not touch
local shiftpunch_allowed = true -- do not touch

local function IsUsingAffectedWeapon()
    local curwep = GetCurrentPedWeapon(cache.ped)
    if not curwep then return true end
    if curwep == `WEAPON_UNARMED` then return true end
    if weapons[curwep] then return true end
    return false
end

local function ShiftPunchProcess()
    while true do
        if not enabled then break end

        local sleep = 1500
        local plyped = cache.ped
        local plyid = cache.playerId

        if IsPedOnFoot(plyped) and (not IsPedSwimming(plyped)) and (not IsPedInAnyVehicle(plyped, true)) then
            sleep = 500
            local sprintstam = GetPlayerSprintStaminaRemaining(plyid)
            local stam = 100 - sprintstam

            if (IsControlPressed(0, 21) or IsPedSprinting(cache.ped) or IsPedRunning(cache.ped)) and IsUsingAffectedWeapon() and (not IsPedDeadOrDying(plyped)) then 
                sleep = 0
                local melee_light = IsControlJustReleased(0, 140)
                local melee_heavy = IsControlJustReleased(0, 141)
                local melee_alt = IsControlJustReleased(0, 142)
                if melee_light or melee_heavy or melee_alt then
                    if not IsPedRagdoll(plyped) then
                        if shiftpunch_allowed then
                            SetPlayerStamina(plyid, math.max(0.0, stam - stamcost))
                        else
                            if ragdollchance > 0 then
                                if math.random(1,100) <= ragdollchance then
                                    SetPedToRagdoll(plyped, ragdolltime.Min * 1000, ragdolltime.Max * 1000, 0)
                                end
                            end
                        end
                    end

                    sprintstam = GetPlayerSprintStaminaRemaining(plyid)
                    stam = 100 - sprintstam
                    if ((stam <= minstam) or (sprintstam >= (100.0 - minstam))) and shiftpunch_allowed then
                        shiftpunch_allowed = false
                    end
                end
            end
        end

        Wait(sleep)
    end
end

local function Init(config)
    enabled = config.Enabled
    stamcost = config.StaminaCost
    minstam = config.MinStamina
    ragdollchance = config.RagdollChance
    ragdolltime = config.RagdollTime
    weapons = config.AffectedMeleeWeapons

    if not enabled then return end
    CreateThread(function()
        while true do
            if not enabled then break end
            local sprintstam = GetPlayerSprintStaminaRemaining(cache.playerId)
            if not shiftpunch_allowed then
                if sprintstam < (100.0 - minstam) then
                    shiftpunch_allowed = true
                else
                    if (IsControlPressed(0, 21) or IsPedSprinting(cache.ped) or IsPedRunning(cache.ped)) and IsUsingAffectedWeapon() and (not IsPedDeadOrDying(cache.ped)) then
                        DisablePlayerFiring(cache.playerId, true)
                    end
                end
            end
            Wait(0)
        end
    end)
    CreateThread(ShiftPunchProcess)
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        lib.callback('tox_shiftpunch:servercb:getconfig', 500, function(config)
            Init(config)
        end)
    end
end)