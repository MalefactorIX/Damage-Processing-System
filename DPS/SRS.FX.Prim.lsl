key id;//Rezzer UUID
string trail="ef728e1e-4122-560e-7dcf-3e9525f8068d";// - Wavy
string puff="8738201d-ec3d-288a-7d65-031211f9fee7";//- Smoke puff
list sounds=["b092565f-3251-428e-116c-6a5568ff0164","ceef0f78-8b32-42d3-5e22-18b19b2e6623","cd1ed82d-779e-5f79-02c4-af45dc86a315"];//Sounds
proc(vector pos)
{
    if(pos)//nullcheck
    {
        llSetRegionPos(pos);
        if(llVecDist(pos,llGetPos())>0.5)return;//Clamp
        llTriggerSound(llList2String(sounds,llFloor(llFrand(3.0))),1.0);
        llParticleSystem([PSYS_PART_FLAGS,( 0
             |PSYS_PART_INTERP_COLOR_MASK
             |PSYS_PART_INTERP_SCALE_MASK
             |PSYS_PART_RIBBON_MASK
             |PSYS_PART_EMISSIVE_MASK
             |PSYS_PART_TARGET_POS_MASK ),
             PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_DROP,
             PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
             PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
             PSYS_PART_START_ALPHA,1.0,
             PSYS_PART_END_ALPHA,1.0,
             PSYS_PART_START_COLOR, color,
             PSYS_PART_END_COLOR,color,
             PSYS_PART_START_GLOW,0.2,
             PSYS_PART_END_GLOW,0.2,
             PSYS_PART_START_SCALE,<0.5,5.3,5.0>,
             PSYS_PART_END_SCALE,<0.5,5.1,5.0>,
             PSYS_PART_MAX_AGE,0.3,
             PSYS_SRC_MAX_AGE,0.0,
             PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
             PSYS_SRC_BURST_PART_COUNT,1,
             PSYS_SRC_BURST_RADIUS,0.1,
             PSYS_SRC_BURST_RATE,0.05,
             PSYS_SRC_BURST_SPEED_MIN,250.0,
             PSYS_SRC_BURST_SPEED_MAX,250.0,
             PSYS_SRC_ANGLE_BEGIN,0.0,
             PSYS_SRC_ANGLE_END,0.0,
             PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
             PSYS_SRC_MAX_AGE, 0.25,
             PSYS_SRC_TEXTURE, trail,
             PSYS_SRC_TARGET_KEY,id]);
        llLinkParticleSystem(2,[
                    PSYS_PART_FLAGS,            PSYS_PART_EMISSIVE_MASK|PSYS_PART_FOLLOW_VELOCITY_MASK|PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK,
                    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_PART_START_COLOR,      ZERO_VECTOR,
                    PSYS_PART_END_COLOR,      <0.2,0.2,0.2>,
                    PSYS_PART_START_ALPHA,      0.5,
                    PSYS_PART_END_ALPHA,        0.05,
                    PSYS_PART_START_SCALE,      <0.2,0.2,0.0>,
                    PSYS_PART_END_SCALE,        <1.0,1.0,0.0>,
                    PSYS_PART_MAX_AGE,          0.5,
                    PSYS_SRC_MAX_AGE,          0.5,
                    PSYS_SRC_ACCEL,             <0.0,0.0,1.0>,
                    PSYS_SRC_TEXTURE,           puff,
                    PSYS_SRC_BURST_RATE,        .1,
                    PSYS_SRC_ANGLE_BEGIN,       0.0,
                    PSYS_SRC_ANGLE_END,        PI,
                    PSYS_SRC_BURST_PART_COUNT,  3,
                    PSYS_SRC_BURST_RADIUS,      .1,
                    PSYS_SRC_BURST_SPEED_MIN,   .0,
                    PSYS_SRC_BURST_SPEED_MAX,   1.0]);
    }
}
check()
{
    vector pos=(vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
    if(pos)return;
    else llDie();
}
vector color=<0.75,0.5,1.0>;
default
{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE,1);
    }
    on_rez(integer p)
    {
        if(p)
        {
            id=(string)llGetObjectDetails(llGetKey(),[OBJECT_REZZER_KEY]);
            //color=(vector)((string)llGetObjectDetails(id,[OBJECT_DESC]));//Sync with weapon or
            color=llGetColor(0);//Use the color of the FX prim itself
            integer mychan=(integer)("0x" + llGetSubString(llMD5String((string)id,0), 1, 3));
            llListen(mychan,"",id,"");
            llSetTimerEvent(5.0);
        }
    }
    listen(integer chan, string name, key oid, string message)
    {
        if(message=="die")llDie();
        else proc((vector)message);
    }
    timer()
    {
        check();
    }
}
