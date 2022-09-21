//Tracer FX Parameters
vector color=<1.0,0.5,0.0>;
string fxprim="[FI]Hellshot.FX";
string obj;
integer obchan=-1;
key objkey;
list beam;
integer beamfx;
fxupdate()//Run on state_entry and attach/on_rez
{
    objkey="";
    llRegionSay(obchan,"die");
}
hitfx(string pos,string epos)
{
    llRegionSayTo(objkey,obchan,pos+","+epos);
    //llLinkParticleSystem(beamfx,beam+[PSYS_SRC_TARGET_KEY,objkey,PSYS_SRC_MAX_AGE,0.2]);
}
purge(integer hex,key targ, string name,string fdmg)
{
    llRegionSayTo(o,-1995,"lba:"+name+":"+fdmg+":"+llKey2Name(llGetOwnerKey(targ)));
    if(hex)llRegionSayTo(targ,hex,(string)targ+","+fdmg);
    else llRegionSayTo(targ,-500,(string)targ+",damage,"+fdmg);
}
integer flip;
float range=25.0;//How far before LBA no longer triggers
rcshot()
{
    rotation rot=llGetCameraRot();
    vector pos=llGetCameraPos();
    vector epos=pos+<100.0,0.0,0.0>*rot;
    list ray=llCastRay(pos,epos,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
    vector hit=llList2Vector(ray,1);
    if(hit)
    {
        if(objkey)hitfx((string)pos,(string)epos);
        if(llVecDist(pos,hit)<range)
        {
            if(flip=!flip)
            {
                //llSay(0,(string)ammo);
                key tid=llList2Key(ray,0);
                string desc=(string)llGetObjectDetails(tid,[OBJECT_DESC]);
                if(desc!=""&&(llGetSubString(desc,0,1)=="v."||llGetSubString(desc,0,5)=="LBA.v."))
                {
                    integer hex=(integer)("0x" + llGetSubString(llMD5String(tid,0), 0, 3));
                    if(llGetSubString(desc,0,5)!="LBA.v.")hex=0;
                    string fmg="3";
                    if(llList2String(llCSV2List(desc),-1)=="NPC")fmg="8";
                    //llSay(0,(string)hex);
                    purge(hex,tid,llKey2Name(tid),fmg);
                }
            }
        }
    }
    else if(pos.x<255.0&&pos.y<255.0)
    {
        if(objkey)hitfx((string)pos,"");
    }
}
colorchange()
{
    //llRegionSayTo(o,-9010,"color:"+(string)color);
    /*beam=[PSYS_PART_FLAGS,( 0 //Energy
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
             PSYS_PART_START_SCALE,<0.8,5.0,5.0>,
             PSYS_PART_END_SCALE,<0.1,5.0,5.0>,
             PSYS_PART_MAX_AGE,0.25,
             PSYS_SRC_MAX_AGE,0.0,
             PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
             PSYS_SRC_BURST_PART_COUNT,1,
             PSYS_SRC_BURST_RADIUS,0.1,
             PSYS_SRC_BURST_RATE,0.05,
             PSYS_SRC_BURST_SPEED_MIN,10.0,
             PSYS_SRC_BURST_SPEED_MAX,10.0,
             PSYS_SRC_ANGLE_BEGIN,0.0,
             PSYS_SRC_ANGLE_END,0.0,
             PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
             PSYS_SRC_TEXTURE, "ef728e1e-4122-560e-7dcf-3e9525f8068d"];*/
    /*beam=[PSYS_PART_FLAGS,( 0 //Ballistic
             |PSYS_PART_INTERP_COLOR_MASK
             |PSYS_PART_INTERP_SCALE_MASK
             //|PSYS_PART_RIBBON_MASK
             |PSYS_PART_EMISSIVE_MASK),
             //|PSYS_PART_TARGET_POS_MASK ),
             PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
             PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
             PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
             PSYS_PART_START_ALPHA,1.0,
             PSYS_PART_END_ALPHA,1.0,
             PSYS_PART_START_COLOR, color,
             PSYS_PART_END_COLOR,color,
             PSYS_PART_START_GLOW,0.2,
             PSYS_PART_END_GLOW,0.2,
             PSYS_PART_START_SCALE,<0.5,0.2,5.0>,
             PSYS_PART_END_SCALE,<0.5,0.2,5.0>,
             PSYS_PART_MAX_AGE,0.2,
             PSYS_SRC_MAX_AGE,0.0,
             PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
             PSYS_SRC_BURST_PART_COUNT,10,
             PSYS_SRC_BURST_RADIUS,0.1,
             PSYS_SRC_BURST_RATE,0.05,
             PSYS_SRC_BURST_SPEED_MIN,250.0,
             PSYS_SRC_BURST_SPEED_MAX,250.0,
             PSYS_SRC_ANGLE_BEGIN,0.0,
             PSYS_SRC_ANGLE_END,0.15,
             PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
             PSYS_SRC_MAX_AGE, 0.25,
             PSYS_SRC_TEXTURE,"773aba72-60d4-4301-c37b-719b2d8b7a2f"];*/
    fxupdate();
}
key o;
default
{
    state_entry()
    {
        obchan=(integer)("0x" + llGetSubString(llMD5String((string)llGetKey(),0), 1, 3));
        integer i=llGetNumberOfPrims()+1;
        while(i--)
        {
            string name=llGetLinkName(i);
            if(name=="bfx")beamfx=i;
            //llSay(0,(string)i+" | "+(string)llGetObjectDetails(llGetLinkKey(i),[OBJECT_DESC])+" | "+(string)sgfx);
        }
        colorchange();
        llRequestPermissions(o=llGetOwner(),0x414);
    }
    run_time_permissions(integer p)
    {
        if(p)
        {
            obchan=(integer)("0x" + llGetSubString(llMD5String((string)llGetKey(),0), 1, 3));
            fxupdate();
            llRezObject(fxprim,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,1);
        }
    }
    link_message(integer s, integer n, string m, key id)
    {
        if(id=="")
        {
            if(objkey)rcshot();
            else if(llGetTime()>5.0)
            {
                fxupdate();
                llRezObject(fxprim,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,1);
                llResetTime();
            }
        }
    }
    attach(key id)
    {
        if(id)
        {
            if(id==o)llRequestPermissions(id,0x414);
            else llResetScript();
        }
    }
    object_rez(key id)
    {
        if(llKey2Name(id)==fxprim)
        {
            if(objkey)llRegionSayTo(objkey,obchan,"die");
            objkey=id;
        }
    }
}
