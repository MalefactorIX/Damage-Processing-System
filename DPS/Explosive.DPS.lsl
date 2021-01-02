float base_damage=120.0;//Max damage
float falloff=10.0;//Damage falloff (positive number)
float radius=5.0;//Blast radius
vector vel;
boom(vector pos)
{
    llSetLinkPrimitiveParamsFast(-1,[PRIM_PHYSICS,0,PRIM_PHANTOM,1,PRIM_COLOR,-1,ZERO_VECTOR,0.0,PRIM_GLOW,-1,0.0]);
    llLinkParticleSystem(-1,[]);
    list ray=llCastRay(pos-(vel*0.075),pos+(vel*0.075),[]);
    vector raypos=llList2Vector(ray,1);
    if(raypos)llSetRegionPos(vel=raypos);
    else vel=pos;
}
key o;
integer chan;
vector color=<1.0,1.0,1.0>;//Particle color
default
{
    on_rez(integer p)
    {
        if(p)
        {
            o=(string)llGetObjectDetails(llGetKey(),[OBJECT_REZZER_KEY]);
            //color=(vector)((string)llGetObjectDetails(o,[OBJECT_DESC]));//Dynamic color setting
            vel=llGetVel();
            chan=(integer)("0x" + llGetSubString(llMD5String(o,0), 0, 1));//Interfaces externally with the DPS processor.
        }
    }
    collision_start(integer c)
    {
        boom(llGetPos());
        state boomed;
    }
    land_collision_start(vector c)
    {
        boom(c);
        state boomed;
    }
}
state boomed
{
    state_entry()
    {
        llParticleSystem([
            PSYS_PART_FLAGS,            PSYS_PART_EMISSIVE_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK,
            PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
            PSYS_PART_START_COLOR,    color,
            PSYS_PART_END_COLOR,      color,
            PSYS_PART_START_ALPHA,      0.5,
            PSYS_PART_END_ALPHA,        0.0,
            PSYS_PART_START_GLOW,        0.3,
            PSYS_PART_START_SCALE,      <9.0,9.0,0.0>,
            PSYS_PART_END_SCALE,        <9.0,9.0,0.0>,
            PSYS_PART_MAX_AGE,          0.5,
            PSYS_SRC_ACCEL,             <0.0,0.0,1.0>,
            PSYS_SRC_TEXTURE,           "8738201d-ec3d-288a-7d65-031211f9fee7",
            PSYS_SRC_BURST_RATE,        .05,
            PSYS_SRC_ANGLE_BEGIN,       0.0,
            PSYS_SRC_ANGLE_END,        PI,
            PSYS_SRC_BURST_PART_COUNT,  10,
            PSYS_SRC_BURST_RADIUS,      2.0,
            PSYS_SRC_BURST_SPEED_MIN,   1.0,
            PSYS_SRC_BURST_SPEED_MAX,   5.0,
            PSYS_SRC_MAX_AGE, 0.0]);
        llTriggerSound("01729e19-162b-699d-d45a-357a9d5e3656",1.0);
        llSensor("","",AGENT,radius,PI);
    }
    sensor(integer d)
    {
        while(d--)
        {
            key hit=llDetectedKey(d);
            vector tpos=llDetectedPos(d);
            list ray=llCastRay(tpos,vel,[RC_REJECT_TYPES,RC_REJECT_AGENTS]);
            if(llList2Vector(ray,1)==ZERO_VECTOR)
                llRegionSayTo(o,chan,"dmg,"+llDetectedName(d)+","+(string)(base_damage-(falloff*llVecDist(tpos,vel)))+","+(string)llDetectedKey(0));
        }
        llSleep(1.0);
        llDie();
    }
    no_sensor()
    {
        llSleep(1.0);
        llDie();
    }
}
