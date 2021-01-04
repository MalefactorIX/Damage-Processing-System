## **Rules are broken into 3 categories**
1. Administration
2. Weapons and Utilities
3. Assists

## **Administration**
   All offenders should be notified and cited of their infractions. Depending on the severity of the offense, a citation may not arrive until after enforcement, if at all.

   Those who wish to oversee the actions of their members will be granted that opportunity, if deemed fit. As such, OiCs may not be immediately granted this status upon request and can be refused if they are found unfit for the role. In addition, individual offenders may not redirect administrative proxies during citations. They are to comply with any requests or they will be considered non-compliant and will be removed from the region.

   Participants should ask administration if they may use or test gear that may be outside the guidelines. Administration can opt to not enforce rules as long as participants agree to not be disruptive and other participants don't take issue with what is being used. Our goal is primarily to target disruptive behavior, as such these rules may not always be enforced as written. It's the spirit of the rule we seek to uphold, not so much the letter of it.

   Rules are likely to change in response to developments within the region. However changes will not go into effect in the middle of any combat event.
    
## **Weapons**
    
#### [Projectiles]
- Must be labeled properly, ie. "*Smooth Criminal*" is not a valid name for a bullet. This is so administration can quickly identify a projectile's type, purpose, and origin.
- May not exceed 200m/s
- May not exceed 5 meters in length and 0.05 meters in width, Example: 5.0x0.05x0.05
    - Some omissions may be made for explosive projectiles or vehicle rounds.

#### [Raycast Weapons]
- All raycast weapons are to be vetted by administration before they're permitted use. This is to make sure fair play is maintained between the varying types that may be present.
- Standard line-of-sight checks for things like melee weapons or explosives are regulated in the MELEE and EXPLOSIVES categories.
- For automatic weapons, their LBA damage can be designed to trigger at set intervals instead of every round to prevent flooding LBA parsers with low damage values. 
    - For standard ROF automatics (600 RPM or lower), it will be every other round.
    - Weapons exceeding 600 RPM will not be allowed deal LBA damage with their bullets.

####    [Ammo]
- Weapons with a rate of fire exceeding 900 RPM are limited to 30 rounds with a minimum of 3 seconds of reload.
- Weapons may not exceed 100 rounds per reload unless otherwise permitted.
- Minimum acceptable reload time is 2.5 seconds + 0.5 seconds for every 10 rounds above 30.

####    [Explosives]
- Launched Rockets, Grenades, or similar may not exceed 100m/s
    - Tank shells are excluded from this rule.
- Thrown Grenades may not exceed 50m/s, excluding gravity.
- May not use collision-based (legacy) AT. All relevant objects are required to take LBA damage.
- Lingering effects such as [Flashbangs, Caging Devices, etc] will not be permitted.
- Lingering Damage effects such as flames, gas, etc must not be immediately lethal and must possess the potential of survival.
   - Example 1: Fire should deal reduced damage to avatars that are standing still or crouching. The total damage for this should be less than 100 for the entire duration of the burning effect.
   - Example 2: Gas DOTs should be limited ot the AOE of the actual blast and therefore non-lethal once an avatar exits the radius.
   - For inquiry or other allowances, please contact an administrative proxy.
- Explosive radius may not exceed 10 meters and must be raycasted from epicenter.
    - If explosion radius exceeds 5 meters, damage must be reduced by at least 10 per meter after 3 meters.
- Minimum reload time for any explosive launcher is 5 second per projectile.
- Proximity AT damage must fall off by at least 20% of the initial amount per meter from the center of the blast.
- Off-hand explosives capable of inflicting 100% damage which are gesture-activated, or otherwise not required to be drawn in place of a firearm, must have at least a [15 second] cooldown. This is reduced to 5 seconds for explosives that must be drawn.
- Seeking Munitions must follow the guidelines ![here](https://github.com/MalefactorIX/SLMC-Seeker-2020)
    - They may not target infantry-class units.

####    [Melee]
- All melee weapons must perform line-of-sight checks.
- Offhand melee weapons, or melee weapons which can be used at any time, are limited to 3 meters and must have a [2 second] cooldown after use.
- Dedicated melee weapons, or melee weapons which are required to be drawn, are limited to 5 meters and much have a [1 second] cooldown between swings.
- May not do more than [5 LBA] a swing to standard LBA objects.

####    [LBA/Listen-Based Health]
- LBA Objects are required to support LBA's hex or non-hex format.
- LBA Objects may not throttle damage. All damage received must immediately take effect. 
    - Directional Modifiers from LBHD are not factored into this rule.
- No avatar-wielded weapon may deal more than 9 LBA per second of reload. Example: 45 LBA for 5 second reload.

####    [Deployables/Mines]
- All deployables must support LBA damage.
- Barricades will be permitted use and may not exceed 100 HP and may be Fortified (See Glossary).
- Riot Shields are will be permitted use and may not exceed 25 HP.
    - Shield must drop if the user attempts to shoot from it and must have a minimum 2s cooldown before it can be raised again.
- A single person is limited to [ 5 ] mines, remote explosives (ie. C4), or offensive devices at a time.
    - All devices in this category must support LBA and only have 1 HP. It is not required to display LBA set-text or health.
- Mines...
    - Placing a new mine must despawn or move the eldest one if the previous limit is exceeded.
    - Mine may not embed itself into an object or terrain to the point it cannot be detected with basic line-of-sight checks.
    - Mine must be naturally visible to an avatar within 10 meters of it. It must have some part of it visible that can be identified as a mine.
    - Mines may not have a detection radius exceeding 3 meters. This sensor may use IFF or group-safe detection,
    - Mines must detonate on physical contact with any person, including the group using it.
    - Mines may not move once placed. They are no longer mines at that point; They are drones.

####    [Vehicles]
- Must be compliant with all LBA restrictions
- Ground Vehicles must have a description ending in ",VEH"
- Air Vehicles must have a description ending in "AIR"
- Air Vehicles may not engage units below the Aegis Barrier while it is online.
- Maximum LBA damage for any vehicle-mounted weapon is 300 DPM.
    - A heavy vehicle (100+ HP) may have up to 4 hardpoints (See Glossary for Details)
    - A light vehicle (50 or Less HP) may have up to 2 hard points.
- Air vehicles must take damage from collisions. 
- Tanks are permitted to be Fortified (See Glossary)

## **Assists**
####    [Movement]
All form of movement assistance is disallowed excluding those provided via the DPS system. This includes but is not limited to...
   - Hard fall cancelling
   - Dashing/Dodgerolls
   - Jetpacks/Boostpacks/Boostpads
   - Prejump Disabling or Nimble 
    
####    [Weapons]
All forms of weapon assistance is disallowed. This includes but is not limited to...  
- [Trigger botting] is Having the weapon fire independently from user input.
- [Trigger locking/Smart Scope] is Having the weapon's trigger lock on to a target to fire automatically when aimed.
- [Aim botting] is Having the weapon aim independently from user input.
- [Aim locking] is Having the viewer/client/weapon lock on to avatar position independent from user input. 
    
####    [Client]
All forms of visual assistance is disallowed. This includes but is not limited to...
- Sight HUDs/Nametag on hover
- Hitboxes, ARC, Wireframe, or similar client-enabled features.
- Weapons or devices which mark the position of an avatar.
    
## **Glossary**
   - [Direct AT] AT Damage dealt by the source of the collision
   - [Proximity AT] AT Damage dealt in an area around the source.
   - [Projectile] A physical, movable object with a traceable and interruptible path.
   - [Legacy AT] (Primbashing, Collision-Based AT) AT which works by repeatedly bombarding an object with prims.
   - [LBA] Short for “Listen-Based Armor” which largely replaced how objects were to take damage in the LLCS combat community. 
   - [LBA HEX] Refers to v2 LBA format which has objects define a unique channel based on their object keys.
   - [LBA NON-HEX] Refers to v1 LBA format which uses a fixed channel.
   - [HARDPOINT] Weapon/Utility mount. Weapons and utilities such as flares, ADS, smoke launcher, etc consume a hardpoint slot.
   - [DPM] Damage Per Minute. How much damage a weapon can put out within 60 seconds - This includes reloads or other forms of downtime and is a metric of a weapon's 'sustainable' damage output.
   - [DPS] 
        - [DAMAGE PER SECOND] Similar to DPM but over the course of a single second, typically used for calculating a weapon's damage output while disregarding any downtime. This is mostly used to calculate a weapon's 'burst' damage output.
        - [DAMAGE PROCESSING SYSTEM] The metered combat system.
   - [Tank] A ground vehicle that is relatively slow but features high burst damage and decent armor.
   - [Mech] A ground vehicle that is more maneuverable than a tank but is typically weaker defensively. They can be small or large.
   - [Fortified] Ignores LBA damage less than 5 and is immune to legacy AT. Typically associated with tanks and barricades.
