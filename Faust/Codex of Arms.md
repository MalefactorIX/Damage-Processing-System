## **Rules are broken into 3 categories**
1. Administration
2. Weapons and Utilities
3. Assists
4. Glossary
5. Tiering and Escalation

## **Administration**
   All offenders should be notified and cited of their infractions. Depending on the severity of the offense, a citation may not arrive until after enforcement, if at all. No warnings will be issued for griefing offenses.

   Those who wish to oversee the actions of their members will be granted that opportunity, if deemed fit. As such, OiCs may not be immediately granted this status upon request and can be refused if they are found unfit for the role. In addition, individual offenders may not redirect administration during citations. They are to comply with any requests or they will be considered non-compliant and will be removed from the region.

   Participants should ask administration if they may use or test gear that may be outside the guidelines. Administration can opt to not enforce rules as long as participants agree to not be disruptive and other participants don't take issue with what is being used. Our goal is primarily to target disruptive behavior, as such these rules may not always be enforced as written. It's the spirit of the rule we seek to uphold, not so much the letter of it. Rules are likely to change in response to developments within the region. However changes will not go into effect in the middle of any combat event.

   This documentation will go over rules in detail for the Faust Infernium sim, as well as our weapon tiers. There are not many rules that will result in a ban, but many serves as our expectations for equipment balance in our region. While we will make an effort to avoid immediate administrative action, there are some offenses that will result in an unavoidable need for such a reaction. If you feel you have been unjustly banned, contact relevant high command within Faust in order to appeal.

Our primary enforcement method is Escalation. Usually, this is reciprocal - you pull out Tier 2 equipment, we'll employ our Tier 2. However, punitive escalation exists for rule-breakers, so please be aware of this before you begin to flaunt rules. In addition, equipment or conduct considered Tier 4 will generally result in administrative action.
    
## **Weapons**
    
#### [Projectile Weapons]
- All projectiles must be labeled properly, ie. "*Smooth Criminal*" is not a valid name for a bullet. This is so administration can quickly identify a projectile's type, purpose, and origin.
- Projectiles should not exceed 200m/s
- Projectiles should not exceed 5 meters in length and 0.05 meters in width, Example: 5.0x0.05x0.05
    - Some omissions may be made for explosive projectiles or vehicle rounds.
- Weapons with a rate of fire exceeding 1200 RPM are not permitted.
- Explosive Ammo (See Glossary) should not exceed 3m in blast radius, may not deal more than 45 proximity LLCS damage, and may not deal LBA.
- AP Ammo (See Glossary) should not deal more than 5 LBA per round.

#### [Raycast Weapons]
- All closed-source, agentlist-based raycast weapons will be disallowed. This includes equipment which functions in a similar principle (widecast). They must follow all regulations which govern raycast weapons and will be subject to higher scrutiny. This is to make sure fair play is maintained between the varying types that may be present.
- Standard line-of-sight checks for things like melee weapons or explosives are regulated in the MELEE and EXPLOSIVES categories.
- For automatic weapons, their LBA damage can be designed to trigger at set intervals instead of every round to prevent flooding LBA parsers with low damage values. 
    - For standard ROF automatics (600 RPM or lower), it will be every other round.
    - Weapons exceeding 600 RPM will not be allowed deal LBA damage with their bullets.
- Raycast weapons are generally considered Tier 2 for anything that isn't bolt-action weapon (60RPM or lower), shotguns, or partial damage semi-automatic weapons.
- Raycast weapons must suffer from some form of inaccuracy or damage reduction with range and/or movement. Weapons firing in excess of 120 RPM must deal partial damage and cannot be lethal on a single-shot level, excluding specific trigger conditions like headshots.

####    [Ammo, Capacity, and Reload]
- Weapons may not exceed 200 rounds per reload unless otherwise permitted for standard LLCS rounds.
  - Minimum acceptable reload time is 2.0 seconds + 0.5 seconds for every 10 rounds above 30 for standard LLCS rounds.
- Weapons which fire explosive or AP projectiles are limited to 20 rounds per reload.
  - Weapons which fire explosive or AP projectiles must have a minimum reload of 5 seconds.

####    [Explosives]
- Launched Rockets, Grenades, or similar may not exceed 120m/s
    - Tank shells are excluded from this rule.
- Thrown Grenades may not exceed 50m/s, excluding gravity.
- Explosives may not use collision-based (legacy) AT. All relevant objects are required to take LBA damage.
- Lingering effects such as [Flashbangs, Caging Devices, etc] may not last longer than 10 seconds. 
- Lingering Damage effects such as flames, gas, etc must not be immediately lethal and must possess the potential of survival.
   - Example 1: Fire should deal reduced damage to avatars that are standing still or crouching. The total damage for this should be less than 100 for the entire duration of the burning effect.
   - Example 2: Gas DOTs should be limited ot the AOE of the actual blast and therefore non-lethal once an avatar exits the radius.
   - For inquiry or other allowances, please contact an administrator.
- Explosive radius may not exceed 10 meters and must be raycasted from epicenter.
    - For infantry: If explosion radius exceeds 5 meters, LLCS damage must be reduced by at least 10 per meter after 3 meters and may only be lethal within those 3 meters.
- Minimum reload time for any explosive launcher is 5 second per projectile. Some consideration will be offered for weapons with reduced effectiveness per projectile.
- Proximity AT damage must fall off by at least 20% of the initial amount per meter from the center of the blast. This may not be required for weapons which deal 10 or less LBA in proximity.
- Off-hand explosives capable of inflicting 100% damage which are gesture-activated, or otherwise not required to be drawn in place of a firearm, must have at least a [5 second] cooldown. If the explosive must be drawn before being fired/thrown, this is reduced to 3.5 seconds.
- Infantry-launched Explosives may not be immediately lethal either via damage reduction or by explosion type if their cooldown timer is less than 5 seconds. This applies strictly to LLCS damage. If the explosive must be drawn before being fired/thrown, this is reduced to 3.5 seconds.
- Seeking Munitions must follow the guidelines ![here](https://github.com/MalefactorIX/SLMC-Seeker-2020)
    - If used by infantry, they may not target infantry-class units.
- You may stock up to 6 of any type of non-seeking explosive projectile. The minimum delay between each use must be 0.5 second (120 RPM). Cooldown must start/reset which each successful use of the weapon.

####    [Melee]
- All melee weapons must perform line-of-sight checks.
- Offhand melee weapons, or melee weapons which can be used at any time, are limited to 3 meters and must have a [2 second] cooldown after use.
- Dedicated melee weapons, or melee weapons which are required to be drawn, are limited to 5 meters and much have a [1 second] cooldown between swings.
- Dedicated melee weapons are permitted to have a lunge of no further than 20 meters. Must have at least a [10 second] cooldown between uses.
- Melee weapons may not do more than [5 LBA] a swing to standard LBA objects per second of cooldown.

####    [LBA/Listen-Based Health]
- LBA Objects are required to support LBA's hex or non-hex format
- All LBA code must be publically available.
- LBA damage caps must be reasonable. This does not factor in modifiers such as LBAD or LBHD. As a general rule of thumb...
  - Barricades: Must be at least 50% of their total HP (Killable in 2 hits or less)
  - Interceptors: Must be at least 99% of their total HP. (Basic 1-shot protection)
  - Teleporters: Must not have a damage cap.
- LBA Objects may not throttle damage. All damage received must immediately take effect. 
    - Directional Modifiers from LBHD are not factored into this rule.
    - All forms of LBA blacklisting is disallowed outside what is incorporated as part of the sim build. Report LBA grief or problematic LBA use to the OIC and offenders will be dealt with administratively.
- No avatar-wielded weapon may deal more than 10 LBA per second of reload. Example: 50 LBA for 5 second reload.

####    [Deployables/Mines]
- All deployables must support LBA damage.
- Barricades will be permitted use and may not exceed 200 HP and may be Fortified (See Glossary).
  - Barricades/Objects which exceed 200 LBA may not be fortified, must have an area larger than 100m cubed (See Glossary), and may not exceed 400 HP.
- Riot Shields are will be permitted use and may not exceed 25 HP.
    - Shield must drop if the user attempts to shoot from it and must have a minimum 2s cooldown before it can be raised again.
- A single person is limited to [ 5 ] mines, remote explosives (ie. C4), or offensive devices at a time.
    - All devices in this category must support LBA and only have 1 HP. It is not required to display LBA set-text or health.
- Mines...
    - Placing a new mine must despawn or move the eldest one if the previous limit is exceeded.
    - Mine may not embed itself into an object or terrain to the point it cannot be detected with basic line-of-sight checks.
    - Mine must be naturally visible to an avatar within 20 meters of it. It must have some part of it visible that can be identified as a mine.
    - Mines may not have a detection radius exceeding 4 meters. This sensor may use IFF or group-safe detection.
    - Mines must detonate on physical contact with any person, including the group using it.
    - Mines may not move once placed. They are no longer mines at that point; They are drones.

####    [Vehicles]
- Must be compliant with all LBA restrictions
- Hitboxes must be reasonably accurate to the model.
- Maximum LBA damage for any vehicle-mounted weapon is 300 DPM.
    - A heavy vehicle (200+ HP) may have up to 4 hardpoints (See Glossary for Details)
    - A light vehicle (100 or Less HP) may have up to 2 hard points.
- (Optional) Ground Vehicles should have a description ending in ",VEH". This whitelists ground vehicles for anti-air munitions.
- Tanks are permitted to be Fortified (See Glossary)
- (Optional) Air Vehicles should have a description ending in ",AIR". This allows us to better filter anti-air munitions to target them exclusively.
- Air vehicles may not be fortified.

## **Assists**
####    [Movement]
- The following forms of movement assistance is disallowed:
   - Hard fall/landing cancelling
   - Omnidirectional Jetpacks
   - Prejump Disabling or Nimble 
- Dashes may not cover more than 5m of distance and have no less than 5 seconds of delay between uses. 
- Boosters with strictly vertical, single-burst movement are permitted as well as slow-fall functions. One can be provided as an example.
    
####    [Weapons]
All forms of weapon assistance is disallowed. This includes but is not limited to...  
- [Trigger botting] is having the weapon fire independently from user input.
- [Trigger locking/Smart Scope] is having the weapon's trigger lock on to a target to fire automatically when aimed.
- [Aim botting] is having the weapon aim independently from user input.
- [Aim locking] is having the viewer/client/weapon lock on to avatar position independent from user input. 
    
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
        - [DAMAGE PROCESSING SYSTEM] A script which calculates LLCS damage in weapons made by Tactical UwU. Most commonly used for raycast/hitscan functions and explosives.
   - [Tank] A ground vehicle that is relatively slow but features high burst damage and decent armor.
   - [Mech] A ground vehicle that is more maneuverable than a tank but is typically weaker defensively. They can be small or large.
   - [Fortified] Ignores LBA damage less than 5 and is immune to legacy AT. Typically associated with tanks and barricades.
   - [Explosive Ammo] Distinct though very similar to traditional explosives, this classification refers to BULLETS which detonate in a small radius on impact.
   - [AP Ammo] This classification refers to BULLETS which deal LBA damage on impact.

## **Tiering and Escalation**
Escalation is broken down into 4 tiers. Only 3 of which are acceptable for combat.

Tier 1: Basic Equipment - Rifles, Hand Grenades, Etc. Basic gruntwork.
  - This tier primarily covers basic explosives, LLCS munitions, and hud utilities like barricades.

Tier 2: Advanced Technology - Raycast, Multi-Explosive Munitions, Vehicles, Light Artillery, Rockets, MGLs, Etc. Meat and potatoes madmax romp.
  - This tier is the most common during group fights. It permits the use of more traditional combat tactics and vehicles.

Tier 3: War Crimes - Turrets, Drones, Fleet, Large Explosives/Heavy Artillery, Bussian Rias (aka Heavy Vehicles), Etc. Popcorn is sold out.
  - This is a higher escalation tier. It's exercises far less restraint and is the functional equvalent of ![this video](https://youtu.be/BXDBBcptR_0).

Tier 4: Heavy Fleet, Nukes, Estate Ban.
 - This isn't even combat anymore. It's a race to see who crashes first, but Operation Get Banned is not a race.
