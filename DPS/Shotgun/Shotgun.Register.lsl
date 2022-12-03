//Important Note: This should -NEVER- be used in excess of 600 RPM.
//Note to self: Add min and max bloom settings like with rifles and shit.
float base_damage=45.0;//Max damage
float min_damage=15;//Min damage
float pellets=5.0;//Total Pellets
float min_acc=25.0;//Used to counter RNG Jank at close range.
float falloff=-1.0;//Damage falloff (Negative Float)
float range=25.0;//How many meters before falloff starts, applies to both damage and ranged inaccuracy
float distmod=1.0;///How much less accurate rounds are per meter from target (%)
float recoil=0.2;//How much less accurate rounds are per shot (%)
float recovery=2.0;//How long it takes for recoil to fully reset
float move=2.5;//How less accurate you are per m/s. Example: Avatars run at 5.3 m/s, so at 5.0, this will result in a movement penalty of about 26%
float jumping=15.0;//Accuracy penalty for jumping or being in the air.
float maxspread=50.0;//Max recoil
proc(integer agent, float damage, key id,integer pellet)
{
    if(damage<min_damage)damage=min_damage;
    //llSay(0,llKey2Name(id));
    llMessageLinked(auxcore,0,llKey2Name(id)+","+(string)damage+","+(string)pellet+",0",id);

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
            float inacc=(min_acc+llFrand(100.0))-((dist-range)*distmod)-mod;
            vector end=center+<dist,0.0,0.0>*rot;
            if(inacc>0.0&&llVecDist(target,end)<5.0)
            {

                vector vel=(vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY]));//Used for lag compensation
                vector h=llGetAgentSize(id);
                float avh=h.z*0.5;

                float spr=0.5+(dist*0.1);//Cone, or physical spread of the shots
                if(dist>30.0)spr=3.5;//Maximum cone width
                float hor=llVecDist(<end.x,end.y,0.0>,<target.x,target.y,0.0>);
                if(hor>0.75)inacc-=7.5*(hor-0.5);//Reduces accuracy based on how far off target the aim is.
                if(inacc>0.0//Checks to see if shot lands (accuracy)
                    &&hor<spr+(llVecMag(<vel.x,vel.y,0.0>)*0.0134)//Checks to see if shot is within the X,Y cordinates (Lag Compensated)
                    &&llVecDist(<0.0,0.0,end.z>,<0.0,0.0,target.z>)<avh+(0.5+(llFabs(vel.z)*0.0134)))//Checks to see if shot is within Z coordinates (Lag Compensated)
                {
                    vector hit;//Cast me a ray
                    if(llGetAgentInfo(id)&AGENT_CROUCHING)//Is the target crouching?
                    {
                        list ray=llCastRay(target,gpos,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_MAX_HITS,1]);
                        hit=llList2Vector(ray,1);
                    }
                    else //They are Standing
                    {
                        target.z+=avh;//Place their head around the actual head
                        list ray=llCastRay(target,gpos,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_MAX_HITS,1]);
                        hit=llList2Vector(ray,1);
                        if(hit)//Did we strike something else?
                        {
                            target.z-=(avh*2.0)+0.3;//Can we see their feet?
                            ray=llCastRay(target,center,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_MAX_HITS,1]);
                            hit=llList2Vector(ray,1);
                        }
                    }
                    if(hit==ZERO_VECTOR)//Did we not hit anything?
                    {
                        if(inacc>100.0)inacc=100.0;
                        integer pellet=1+llFloor(pellets*(inacc/100.0));
                        float damage;
                        if(dist<range)damage=base_damage;
                        else damage=base_damage+((dist-range)*falloff);
                        proc(l,damage,id,pellet);
                        //l=0;//Prevents a single shot from hitting multiple targets. Can be removed for your COD montages.
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
float mob=-1;//Dex modifier, formally called "Mobility" hence "mob"
float ovh;
key checksum;
check()
{
    checksum=llReadKeyValue((string)o+"_STAT");
}
groupauth()//Rewrite this shit
{
    //Experience.exe
    //DEX modifier goes here
    //Key = Avatar UUID. Data: 0 Currency,1 EXP,2 Rank,3 Division,4 STR,5 PRC,6 DEX,7 FRT,8 END,9 RES
    o=llGetOwner();
    //check();
    //return;
    if(llSameGroup("c01afc6c-c374-f61e-fe90-f84b13924095"))return;
    else if(o=="ded1cc51-1d1f-4eee-b08e-f5d827b436d7")return;//Creator whitelist
    //else {check(); return;}
    if(llGetAttached())
    {
        llRequestPermissions(o,0x30);
        llDetachFromAvatar();
    }
    else llDie();
}
default
{
    on_rez(integer p)
    {
        groupauth();
    }
    state_entry()
    {
        //Locates link the Processor is in. Otherwise, keeps default setting -2 or everything except what this script is in.
        /*integer l=llGetNumberOfPrims()+1;
        while(l--)
        {
            string name=llGetLinkName(l);
            if(name=="fx")auxcore=l;
        }*/
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
            check();
            vector size=llGetAgentSize(o);
            ovh=size.z*0.5;
            llTakeControls(CONTROL_ML_LBUTTON,1,1);
        }
    }
    link_message(integer s, integer n, string m, key id)
    {
        fire();
    }
    /*changed(integer c)
    {
        if(c&CHANGED_COLOR)boosh();
    }*/
     dataserver(key sum, string data)//Experience shit.
    {
        if (sum != checksum)return;
        list parse=llCSV2List(data);
        if((integer)llList2String(parse,0)>0)
        {
            //Data: (1)Currency,(2)EXP,(3)Rank,(4)Division,(5)STR,(6)PRC,(7)DEX,(8)FRT,(9)END,(10)RES
            if(llGetListLength(parse)!=11)
            {
                 mob=0;
                 llSetTimerEvent(0.0);
            }
            else //if(mob!=(integer)llList2String(parse,7))
            {
                llMessageLinked(auxcore,0,data,"stat");
                integer new=(integer)llList2String(parse,7);
                if(new!=mob)llOwnerSay("Your Dexterity is affecting this weapon...");
                mob=new;
                llSetTimerEvent(900.0);
            }
        }
        else
        {
            mob=0;
            llSetTimerEvent(0.0);
        }
    }
    timer()
    {
        check();
    }
}
