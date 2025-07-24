
local enabled, mindelay, stamcost, minstam, ragdollchance, ragdolltime, weapons = false, 0.0, 0.0, 0.0, 0, {Min=1.5,Max = 3.0}, {} -- do not touch
local shiftpunch_allowed = true -- do not touch
local last_shiftpunch = 0 -- do not touch

local function IsUsingAffectedWeapon()
    local curwep = GetCurrentPedWeapon(cache.ped)
    if not curwep then return true end
    if curwep == `WEAPON_UNARMED` then return true end
    if weapons[curwep] then return true end
    return false
end

local function IsShifting()
    local plyped = cache.ped
    return (not IsPedDeadOrDying(plyped)) and ((IsControlPressed(0, 21) or IsPedSprinting(plyped) or IsPedRunning(plyped)) and IsUsingAffectedWeapon()) 
end

local function DisableCombatThisFrame()
    if IsShifting() then
        DisablePlayerFiring(cache.playerId, true)
    end
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

            if IsShifting() then
                sleep = 0
                local melee_light = IsControlJustReleased(0, 140)
                local melee_heavy = IsControlJustReleased(0, 141)
                local melee_alt = IsControlJustReleased(0, 142)
                if melee_light or melee_heavy or melee_alt then
                    if not IsPedRagdoll(plyped) then
                        if shiftpunch_allowed then
                            SetPlayerStamina(plyid, math.max(0.0, stam - stamcost))
                            last_shiftpunch = GetGameTimer()
                            if mindelay > 0 then
                                shiftpunch_allowed = false
                            end
                        else
                            if (ragdollchance > 0) and ((stam <= minstam) or (sprintstam >= (100.0 - minstam))) then
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
    mindelay = config.MinDelay
    stamcost = config.StaminaCost
    minstam = config.MinStamina
    ragdollchance = config.RagdollChance
    ragdolltime = config.RagdollTime
    weapons = config.AffectedMeleeWeapons

    if not enabled then return end
    CreateThread(function()
        while true do
            if not enabled then break end
            local sleep = 0
            local GT = GetGameTimer()
            local delay = mindelay * 1000

            local sprintstam = GetPlayerSprintStaminaRemaining(cache.playerId)
            if not shiftpunch_allowed then
                if sprintstam < (100.0 - minstam) then
                    if delay > 0.0 then
                        if last_shiftpunch > 0 then
                            if GT >= (last_shiftpunch + delay) then
                                shiftpunch_allowed = true
                                last_shiftpunch = 0
                                sleep = 100
                            else
                                DisableCombatThisFrame()
                            end
                        else
                            shiftpunch_allowed = true
                        end
                    else
                        shiftpunch_allowed = true
                    end
                else
                    if IsShifting() then
                        DisableCombatThisFrame()
                    end
                end
            else
                sleep = 100
                if (delay > 0) and (last_shiftpunch > 0) then
                    if (last_shiftpunch + delay) > GT then
                        shiftpunch_allowed = false
                        DisableCombatThisFrame()
                    end
                end
            end
            Wait(sleep)
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