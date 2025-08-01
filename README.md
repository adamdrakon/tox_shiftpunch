# tox_shiftpunch

A simple FiveM script which causes "shift punching" to consume a configurable amount of stamina and require a configurable minimum amount of stamina to perform, with an optional configurable chance for players to fall over (ragdoll) when attempting to "shift punch" if their stamina is too low.

Additional weapons can be added to the config for detection regarding "shift punching", such as the brass knuckles.

Also includes a configurable minimum time delay between allowed shiftpunches, for an extra layer of protection against exploitative/unfair combat behavior.

**Note:** Players *will* still be able to throw an initial "running punch" to initiate a fight (this, I think, is still a valuable part of some players' RP when it comes to starting fights or catching up to a fleeing foe) before the stamina checks come into play. Players must regain their stamina over the minimum threshold before they will be granted another "running punch".

# Requirements:
- ox_lib: [CommunityOx/ox_lib](https://github.com/CommunityOx/ox_lib) (maintained) / [overextended/ox_lib](https://github.com/overextended/ox_lib) (original, archived)

# Known Issues:
- Occasionally, spammed attempts to shift punch can result in stamina consumption without a punch actually being thrown; this is likely due to the stamina consumption thread and combat disabling thread being seperate; I will be looking at combining the two treads into one to see if this addresses the issue.
- Resmon usage reports are not as low as I'd normally like them to be but I will look at ways to improve them, it is up to you whether any performance impact incurred is a tradeoff you're content with in order to combat "shift punch" abuse on your server.