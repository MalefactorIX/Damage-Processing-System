//Important Note: This should -NEVER- be used in excess of 600 RPM.
float base_damage=65.0;//Max damage
float min_damage=35;//Min damage
float falloff=-0.75;//Damage falloff (Negative Float)
float range=40.0;//How many meters before falloff starts, applies to both damage and ranged inaccuracy
float distmod=0.25;///How much less accurate rounds are per meter from target (%)
float recoil=0.75;//How much less accurate rounds are per shot (%)
float recovery=4.0;//How long it takes for recoil to fully reset
float move=5.0;//How less accurate you are per m/s. Example: Avatars run at 5.3 m/s, so at 5.0, this will result in a movement penalty of about 26%
float jumping=40.0;//Accuracy penalty for jumping or being in the air.
float maxspread=50.0;
proc(integer agent, float damage, key id, integer head)
{
    if(damage<min_damage)damage=min_damage;
    if(head)damage*=1.5;
    llMessageLinked(auxcore,0,llKey2Name(id)+","+(string)damage+","+(string)head+",0",id);

}
float spread;//Do not edit.
fire()
{
    if(spread>0.0)//This part handles recoil reduction
    {
        float time=llGetAndResetTime();
        if(time>0.5)
        {
            if(time>recovery)spread=0.0;
            else spread-=spread*(time/recovery);
        }
    }
    list agents=llGetAgentList(AGENT_LIST_PARCEL,[]);//Only look for agents in the current parcel.
    //Processor will convert the results into region if it determines a damage prim needs to be used.
    rotation rot=llGetCameraRot();
    vector gpos=llGetPos();
    vector center=llGetCameraPos();
    center.x=gpos.x;
    center.y=gpos.y;
    gpos.z+=ovh;
    //Mixed-pos leads to more consistant shots and prevents shots from being lead around corners. Preferred method for raycast/hitscan weapons.
    integer l=llGetListLength(agents);
    float mod=llVecMag(llGetVel())*move;//Inaccuracy modifier
    integer info=llGetAgentInfo(o);
    if(info&AGENT_IN_AIR)mod=jumping;
    else if(info&AGENT_CROUCHING)
    {
        gpos.z-=ovh;
        mod=0.0;
    }
    mod+=spread;//Add recoil
    mod*=1.0-(mob/200.0);//Remove mobility
    while(l--)
    {
        key id=llList2Key(agents,l);//i
        if(id!=o)//Don't shoot yourself
        {
            vector target=tar(id);
            float dist=llVecDist(center,target);
            float inacc=llFrand(100.0)-((dist-range)*distmod)-mod;
            vector end=center+<dist,0.0,0.0>*rot;
            if(inacc>0.0&&llVecDist(target,end)<5.0)
            {

                vector vel=(vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY]));//Used for lag compensation
                vector h=llGetAgentSize(id);
                float avh=h.z*0.5;

                float spr=0.35+(dist*0.1);//Cone, or physical spread of the shots
                if(dist>70.0)spr=1.0;//Maximum cone width
                float hor=llVecDist(<end.x,end.y,0.0>,<target.x,target.y,0.0>);
                if(hor>0.35)inacc-=10.0*(hor-0.35);//Reduces accuracy based on how far off target the aim is.
                if(inacc>0.0//Checks to see if shot lands (accuracy)
                    &&hor<spr+(llVecMag(<vel.x,vel.y,0.0>)*0.0134)//Checks to see if shot is within the X,Y cordinates (Lag Compensated)
                    &&llVecDist(<0.0,0.0,end.z>,<0.0,0.0,target.z>)<avh+(0.5+(llFabs(vel.z)*0.0134)))//Checks to see if shot is within Z coordinates (Lag Compensated)
                {
                    integer phantom;
                    key pid;
                    integer hit;//Cast me a ray
                    if(llGetAgentInfo(id)&AGENT_CROUCHING)//Is the target crouching?
                    {
                        list ray=llCastRay(gpos,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                        hit=llList2Integer(ray,-1);
                        pid=llList2Key(ray,0);
                        //llSay(0,"First pass (Crouching): "+llDumpList2String(ray,","));
                        phantom=(integer)((string)llGetObjectDetails(pid,[OBJECT_PHANTOM]));
                    }
                    else //They are Standing
                    {
                        target.z+=avh;//Place their head around the actual head
                        list ray=llCastRay(gpos,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                        hit=llList2Integer(ray,-1);
                        //llSay(0,"First pass (Standing): "+llDumpList2String(ray,","));
                        if(hit)//Did we strike something else?
                        {
                            target.z-=(avh*2.0)+0.3;//Can we see their feet?
                            ray=llCastRay(center,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                            hit=llList2Integer(ray,-1);
                            //llSay(0,"Second pass: "+llDumpList2String(ray,","));
                            phantom=(integer)((string)llGetObjectDetails(pid,[OBJECT_PHANTOM]));
                        }
                    }
                    //llOwnerSay((string)phantom+":"+llKey2Name(pid));
                    integer bypass=phantom;
                    //llSay(0,(string)hit);
                    if(phantom>0)++bypass;
                    if(hit<1||bypass)//Did we not hit anything?
                    {
                        float damage;
                        if(dist<range)damage=base_damage;
                        else damage=base_damage+((dist-range)*falloff);
                        if(phantom)
                        {
                            llOwnerSay("Phantom hit "+llKey2Name(pid));
                            //llRegionSayTo(id,0,"That's not going to work anymore. You ruined it for everyone else.");
                            damage=100.0;
                        }
                        if(llVecDist(end,target)<0.35)proc(l,damage,id,1);
                        else proc(l,damage,id,0);
                        l=0;//Prevents a single shot from hitting multiple targets. Can be removed for your COD montages.
                    }
                }
            }
        }
    }
    spread+=recoil;//Part that adds recoil
    if(spread>maxspread)spread=maxspread;
}
vector tar(key id)
{
    vector av=(vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
    return av;
}
key o;
integer auxcore=-2;
float mob=-1;
float ovh;
groupauth()
{
    return;
    if(llSameGroup("a22e145e-c8d4-7ae8-b6ed-ed6cb17a4510"))return;
    else if(llGetOwner()=="ded1cc51-1d1f-4eee-b08e-f5d827b436d7")return;
    llDie();
    llRequestPermissions(llGetOwner(),0x30);
}
default
{
    on_rez(integer p)
    {
        groupauth();
    }
    state_entry()
    {
        integer l=llGetNumberOfPrims()+1;
        while(l--)
        {
            string name=llGetLinkName(l);
            if(name=="fx")auxcore=l;
        }
        llRequestPermissions(o=llGetOwner(),0x414);
    }
    attach(key id)
    {
        mob=-1;
        if(id)llRequestPermissions(o=id,0x414);
    }
    run_time_permissions(integer p)
    {
        if(p)
        {
            vector size=llGetAgentSize(o);
            ovh=size.z*0.5;
            llTakeControls(CONTROL_ML_LBUTTON,1,1);
        }
    }
    link_message(integer s, integer n, string m, key id)
    {
        if(id!="")
        {
            //llList2CSV([prowess,durability,mobility,sustain,battery]));
            if(n)
            {
                list parse=llCSV2List(m);
                float nmob=(float)llList2String(parse,2);
                if(nmob>60)nmob=60;
                if(nmob!=mob)llOwnerSay("/me appears to be resonating with your status...");
                mob=nmob;
            }
            else
            {
                mob=0;
                llOwnerSay("/me appears to no longer be resonating with your status...");
            }
        }
        else fire();
    }
}
