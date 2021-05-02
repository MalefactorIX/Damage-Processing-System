string texture = "297d1492-3376-a074-d3bd-eab692691ebb";
string btexture = "ffd92d42-4f88-836d-b660-040fc50d8244";
vector color=<0.5,0.75,1.0>;
parts()
{
         //Super Tracers: Now with 200% more visibility.
        llLinkParticleSystem(-1,[
             PSYS_PART_FLAGS,( 0
             |PSYS_PART_INTERP_COLOR_MASK
             |PSYS_PART_INTERP_SCALE_MASK
             |PSYS_PART_RIBBON_MASK
             |PSYS_PART_EMISSIVE_MASK ),
             PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
             PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
             PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA ,
             PSYS_PART_START_ALPHA,0.5,
             PSYS_PART_END_ALPHA,0.0,
             PSYS_PART_START_COLOR,color,
             PSYS_PART_END_COLOR,color,
             PSYS_PART_START_GLOW,0.2,
             PSYS_PART_END_GLOW,0.0,
             PSYS_PART_START_SCALE,<0.4,0.4,0.4>,
             PSYS_PART_END_SCALE,<0.0,0.0,0.0>,
             PSYS_PART_MAX_AGE,2.0,
             PSYS_SRC_MAX_AGE,0.0,
             PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
             PSYS_SRC_BURST_PART_COUNT,1,
             PSYS_SRC_BURST_RADIUS,0.0,
             PSYS_SRC_BURST_RATE,0.01,
             PSYS_SRC_BURST_SPEED_MIN,0.0,
             PSYS_SRC_BURST_SPEED_MAX,0.,
             PSYS_SRC_ANGLE_BEGIN, PI,
             PSYS_SRC_ANGLE_END, PI*2,
             PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
             PSYS_SRC_TEXTURE, (key)"f913b654-1d0e-21e3-1592-71a515784b46",
             PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"]);
        llLinkParticleSystem(3,[
            PSYS_PART_FLAGS,(0
            |PSYS_PART_EMISSIVE_MASK
            |PSYS_PART_INTERP_COLOR_MASK
            |PSYS_PART_INTERP_SCALE_MASK
            |PSYS_PART_FOLLOW_SRC_MASK),
            PSYS_PART_START_COLOR,color,
            PSYS_PART_END_COLOR,color,
            PSYS_PART_START_ALPHA,0.50000,
            PSYS_PART_END_ALPHA,0.000000,
            PSYS_PART_START_SCALE,<0.40000, 0.30000, 0.00000>,
            PSYS_PART_END_SCALE,<0.0000, 0.80000, 0.00000>,
            PSYS_PART_MAX_AGE,1.00000,
            PSYS_PART_START_GLOW,0.10000,
            PSYS_PART_END_GLOW,0.00000,
            PSYS_SRC_ACCEL,<0.00000, 0.00000, 0.30000>,
            PSYS_SRC_PATTERN,8,
            PSYS_SRC_TEXTURE,texture,
            PSYS_SRC_BURST_RATE,0.030000,
            PSYS_SRC_BURST_PART_COUNT,1,
            PSYS_SRC_BURST_RADIUS,0.100000,
            PSYS_SRC_BURST_SPEED_MIN,0.10000,
            PSYS_SRC_BURST_SPEED_MAX,0.200000,
            PSYS_SRC_MAX_AGE,0.000000,
            PSYS_SRC_OMEGA,<10.00000, -100.00000, 10.00000>,
            PSYS_SRC_ANGLE_BEGIN,1.0,
            PSYS_SRC_ANGLE_END,1.0]);
        llLinkParticleSystem(4,[
            PSYS_PART_FLAGS,(0
            |PSYS_PART_EMISSIVE_MASK
            |PSYS_PART_INTERP_COLOR_MASK
            |PSYS_PART_INTERP_SCALE_MASK ),
            //|PSYS_PART_FOLLOW_SRC_MASK),
            PSYS_PART_START_COLOR,color,
            PSYS_PART_END_COLOR,color,
            PSYS_PART_START_ALPHA,0.50000,
            PSYS_PART_END_ALPHA,0.000000,
            PSYS_PART_START_SCALE,<0.10000, 0.100000, 0.00000>,
            PSYS_PART_END_SCALE,<0.0000, 0.00000, 0.00000>,
            PSYS_PART_MAX_AGE,1.00000,
            PSYS_PART_START_GLOW,0.30000,
            PSYS_PART_END_GLOW,0.00000,
            PSYS_SRC_ACCEL,<0.00000, 0.00000, 0.00000>,
            PSYS_SRC_PATTERN,2,
            PSYS_SRC_TEXTURE,btexture,
            PSYS_SRC_BURST_RATE,0.050000,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,0.00000,
            PSYS_SRC_BURST_SPEED_MIN,0.20000,
            PSYS_SRC_BURST_SPEED_MAX,0.300000,
            PSYS_SRC_MAX_AGE,0.000000,
            PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
            PSYS_SRC_ANGLE_BEGIN,PI,
            PSYS_SRC_ANGLE_END,PI]);
}
boom()
{
    llSetLinkPrimitiveParamsFast(-1,[PRIM_PHYSICS,0,PRIM_PHANTOM,1,PRIM_COLOR,-1,ZERO_VECTOR,0.0,PRIM_GLOW,-1,0.0]);
    llLinkParticleSystem(-1,[]);
}
integer chan;
key o;
integer los(vector start, vector target, key id)
{
    string data=llToLower(llKey2Name(id));
    list parse=llParseStringKeppNulls(data,"","emp");
    if(llGetListLength(parse)>1)return 1;
    list ray=llCastRay(start,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_MAX_HITS,1]);
    if(llList2Vector(ray,1)==ZERO_VECTOR||llList2Key(ray,0)==me)return 1;
    else return 0;//Land in way
}
vector tar(key id)
{
    vector pos=(vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
    return pos;
}
default
{
    state_entry()
    {
        llSetObjectDesc("v.LBA.Mine,1,1,1,NPC");
        //lListen(-910,"","","det");//Deprecated. Find remaining dependencies and remove from source
        llListen(-500,"","","");
    }
    listen(integer chan, string name, key id, string message)
    {
        if(chan==-500)
        {
            list parse=llParseString2List(message,[","],[" "]);
            if((key)llList2String(parse,0)==llGetKey())
            {
                if(los(llGetPos(),tar(id),id))//Force line of sight.
                {
                    llOwnerSay("/me Destroyed");
                    llDie();
                }
            }
        }
        /*else if(message=="det")
        {

            if(los(llGetPos(),tar(id),id))
            {
                llOwnerSay("/me Destroyed");
                llDie();
            }
        }*/
        else if(message=="die"&&id==o)llDie();
    }
    collision_start(integer c)
    {
        if(llGetTime()<2.0)return;
        if(llVecMag(llDetectedVel(0))>10.0)
        {
            boom();
            state boomed;
        }
        else if(llDetectedType(0)&1)
        {
            boom();
            state boomed;
        }
    }
    on_rez(integer p)
    {
        if(p)
        {
            llResetTime();
            o=(string)llGetObjectDetails(llGetKey(),[OBJECT_REZZER_KEY]);
            //color=(vector)((string)llGetObjectDetails(o,[OBJECT_DESC]));
            chan=(integer)("0x" + llGetSubString(llMD5String(llGetOwner(),0), 0, 2));
            vector init=tar(o);
            llListen(-910,"",o,"die");
            vector center=llGetPos();
            rotation rot=llGetRot();
            list ray=llCastRay(center,center+<4.0,0.0,0.0>*rot,[RC_REJECT_TYPES,RC_REJECT_PHYSICAL,RC_MAX_HITS, 1]);
            vector hit=llList2Vector(ray,1);
            integer nlba=1;
            string desc=(string)llGetObjectDetails(llList2Key(ray,0),[OBJECT_DESC]);//Deprecated. Intent was to prevent people from placing mines on LBA objects.
            if(llGetSubString(desc,0,1)=="v."||llGetSubString(desc,0,5)=="LBA.v.")nlba=0;
            if(hit!=ZERO_VECTOR&&nlba)
            {
                llSetRegionPos(hit);
                llSetStatus(STATUS_PHANTOM,0);
            }
            else
            {
                vector av=llGetAgentSize(o);
                llSetRot(<0.00000, 0.70711, 0.00000, 0.70711>);
                ray=llCastRay(center,center-<0.0,0.0,10.0>,[RC_REJECT_TYPES,RC_REJECT_PHYSICAL,RC_MAX_HITS, 1]);
                hit=llList2Vector(ray,1);
                if(hit)llSetRegionPos(hit);
                else
                {
                    vector offset=<1.0,0.0,0.0>*rot;
                    offset.z=0.0;
                    llSetRegionPos(init+<offset.x,offset.y,-((av.z/2.0)+0.9)>);
                }
                llSetStatus(STATUS_PHANTOM,0);
            }
            llSensorRepeat("","",1,3.0,PI,1.0);
            llSetTimerEvent(2.0);
        }
    }
    sensor(integer d)
    {
        vector pos=llGetPos()+<-0.5,0.0,0.0>*llGetRot();
        while(d--)
        {
            if(llDetectedGroup(d));//llSay(0,"Same Group");
            else
            {
                if(los(pos,llDetectedPos(d)))
                {
                    llTriggerSound("466b38a2-d582-5b05-8d93-a3e8df9718ef",1.0);
                    boom();
                    state boomed;
                }
            }
        }
    }
    timer()
    {
        rotation rot=llGetRot();
        vector center=llGetPos();
        list ray=llCastRay(center+<0.0,0.0,1.0>*rot,center-<0.0,0.0,1.0>*rot,[RC_REJECT_TYPES,RC_REJECT_PHYSICAL,RC_MAX_HITS, 1]);
        if(llKey2Name(o)!=""&&llList2Vector(ray,1)!=ZERO_VECTOR)return;
        else
        {
            llOwnerSay("/me Expired");
            llDie();
        }
    }
}
state boomed//Note to self, not optimal. Fix later.
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
        llSensor("","",AGENT,5.0,PI);
    }
    sensor(integer d)
    {
        vector init=llGetPos()+<-0.5,0.0,0.0>*llGetRot();
        while(d--)
        {
            key hit=llDetectedKey(d);
            vector tpos=llDetectedPos(d);
            list ray=llCastRay(tpos,init,[RC_REJECT_TYPES,RC_REJECT_AGENTS]);
            if(llList2Vector(ray,1)==ZERO_VECTOR)
            {
                //llRezObject("Fragmentation Blast.DMG",vel,ZERO_VECTOR,ZERO_ROTATION,param);
                llRegionSayTo(o,chan+1,"dmg,"+llDetectedName(d)+","+(string)(120.0-(7.5*llVecDist(tpos,init)))+","+(string)llDetectedKey(d));
            }
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
