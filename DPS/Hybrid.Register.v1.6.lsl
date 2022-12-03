//Important Note: This should -NEVER- be used in excess of 600 RPM. It is too bloated to run any faster than that.
//Most of the balancing for ranged weapons is contained within this script. Automatic, instant kill raycast with no strings attachs is dumb, stupid, and saying it's "semi-automatic" doesn't change that the fact you can instantly pop someone irregardless of distance in a single physics frame dipshit.
//Note to self: Replace all references to llKey2Name(llGetOwnerKey(id)) with SLURL profile links instead.
integer dps=1;//Toggles between using DPS (1) or RC (0)
float rpm;
boosh()//Link message delay was starting to piss me off.
{
    rpm=llGetTimeOfDay();
    while(llGetColor(1)!=ZERO_VECTOR)
    {
        float time=llGetTimeOfDay();
        if(llFabs(time-rpm)>0.1)
        {
            rpm=time;
            //llSay(0,"fire");
            if(dps)fire();
            else rc();
        }
    }
}
float base_damage=55.0;//Max damage
float min_damage=35.0;//Min damage
float falloff=-0.5;//Damage falloff (Negative Float)
float range=40.0;//How many meters before falloff starts, applies to both damage and ranged inaccuracy
float minbloom=0.35;//Roughly, how thick an avatar is with a little margin for error. Determines threshold for aiming inaccuracy.
float maxbloom=1.0;//How large (radius in meters) the cone for spread can get at any distance.
float distmod=0.1;///How much less accurate rounds are per meter from target (%)
float recoil=0.75;//How much less accurate rounds are per shot (%)
float recovery=4.0;//How long it takes for recoil to fully reset
float move=5.0;//How less accurate you are per m/s. Example: Avatars run at 5.3 m/s, so at 5.0, this will result in a movement penalty of about 26%. Also nerfs the shit of pre-fire dashes. Git gud.
float jumping=25.0;//Accuracy penalty for jumping or being in the air. Should always be higher than running at full speed.
float maxspread=50.0;//Max penalty for recoil.
proc(float damage, key id, integer head)
{
    if(damage<min_damage)damage=min_damage;
    llMessageLinked(auxcore,0,llKey2Name(id)+","+(string)damage+","+(string)head+",0",id);

}
float spread;//Do not edit. How the script keeps track of current recoil inaccuracy.
float bloommod;//Do not edit. Set in state_entry. Determines how quickly spread grows
string lasthit;//Used for phantom detection
float lhittime;//Used for phantom detection
fire()//SRS Firing Pattern
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
    mod*=1.0-(mob/200.0);//Remove mobility (stat system)
    while(l--)
    {
        key id=llList2Key(agents,l);//i
        if(id!=o)//Don't shoot yourself
        {
            vector target=tar(id);
            float dist=llVecDist(center,target);
            float inacc=llFrand(100.0)-((dist-range)*distmod)-mod;
            vector end=center+<dist,0.0,0.0>*rot;
            if(inacc>0.0&&llVecDist(target,end)<5.0)//Filter out targets more than 5m away as invalid
            {

                vector vel=(vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY]));//Used for lag compensation
                vector h=llGetAgentSize(id);
                float avh=h.z*0.5;

                float spr=minbloom+(dist*bloommod);//Cone, or physical spread of the shots
                if(dist>range)spr=maxbloom;//Maximum cone width
                float hor=llVecDist(<end.x,end.y,0.0>,<target.x,target.y,0.0>);
                if(hor>minbloom)inacc-=10.0*(hor-minbloom);//Reduces accuracy based on how far off target the aim is.
                if(inacc>0.0//Checks to see if shot lands (accuracy)
                    &&hor<spr+(llVecMag(<vel.x,vel.y,0.0>)*0.0134)//Checks to see if shot is within the X,Y cordinates (Lag Compensated)
                    &&llVecDist(<0.0,0.0,end.z>,<0.0,0.0,target.z>)<avh+(0.5+(llFabs(vel.z)*0.0134)))//Checks to see if shot is within Z coordinates (Lag Compensated)
                {
                    integer phantom;
                    key pid;
                    vector hit;//Cast me a ray
                    if(llGetAgentInfo(id)&AGENT_CROUCHING)//Is the target crouching?
                    {
                        list ray=llCastRay(gpos,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                        hit=llList2Vector(ray,1);
                        pid=llList2Key(ray,0);
                        phantom=(integer)((string)llGetObjectDetails(pid,[OBJECT_PHANTOM]));
                    }
                    else //They are Standing
                    {
                        target.z+=avh;//Place their head around the actual head
                        list ray=llCastRay(gpos,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                        hit=llList2Vector(ray,1);
                        if(hit)//Did we strike something else?
                        {
                            target.z-=(avh*2.0)+0.3;//Can we see their feet?
                            ray=llCastRay(center,target,[RC_REJECT_TYPES,RC_REJECT_AGENTS,RC_DATA_FLAGS,RC_GET_ROOT_KEY]);
                            hit=llList2Vector(ray,1);
                            phantom=(integer)((string)llGetObjectDetails(pid,[OBJECT_PHANTOM]));
                        }
                    }
                    //llOwnerSay((string)phantom+":"+llKey2Name(pid));
                    integer bypass=phantom;//Get fucked idiot.
                    if(hit==ZERO_VECTOR||bypass)//Did we not hit anything?
                    {
                        float damage;
                        if(dist<range)damage=base_damage;
                        else damage=base_damage+((dist-range)*falloff);
                        if(phantom)
                        {
                            string lhit=llKey2Name(pid);
                            float time=llFrand(llFabs(llGetTimeOfDay()-lhittime));//So it doesn't spam us
                            if(lhit!=lasthit||time>10.0)
                            {
                                lasthit=lhit;
                                llOwnerSay("Phantom hit "+lasthit);
                                lhittime=llGetTimeOfDay();
                            }
                            else if(time>3.0)
                            {
                                llTriggerSound("1c6981cf-8b14-0bf3-0f1e-6fce03705592",0.5);
                                lhittime=llGetTimeOfDay();
                            }
                            //llRegionSayTo(id,0,"Cheeky comment about raycast blocker goes here");
                            damage=100.0;//Sets damage to 100 as punishment, in addition to bypassing raycast checks
                        }
                        if(llVecDist(end,target)<0.35)proc(damage,id,1);
                        else proc(damage,id,0);
                        l=0;//Prevents a single shot from hitting multiple targets. Can be removed for your COD montages.
                    }
                }
            }
        }
    }
    spread+=recoil;//Part that adds recoil
    if(spread>maxspread)spread=maxspread;
}
list params=[RC_REJECT_TYPES,RC_REJECT_PHYSICAL,RC_DATA_FLAGS,RC_GET_ROOT_KEY,RC_MAX_HITS,5];
//Sometimes, simpler is better.
rc()//Raycast Firing Pattern
{
    //Due to the nature and inconsistency of raycast, no inaccuracy modifiers are factored.
    //All hits deal max damage.
    rotation rot=llGetCameraRot();
    vector gpos=llGetPos();
    vector center=llGetCameraPos();
    center.x=gpos.x;
    center.y=gpos.y;
    integer attempts=3;//RaYcAsT iS rElIaBlE gAiS, rEaLlY!
    list offsets=[<500.0,0.75,0.0>,<500.0,-0.75,0.0>,<500.0,0.0,0.0>];
    integer phantom;
    while(attempts--)
    {
        list ray=llCastRay(center,center+llList2Vector(offsets,attempts)*rot,params);
        if(llList2Integer(ray,-1)>0)//Did we hit anything?
        {
            integer l=llGetListLength(ray);
            integer i;//Unlike agentlist, the order inwhich we process hits matters. So we start from 0.
            while(i<l)
            {
                key id=llList2Key(ray,i);
                if(id!=o)//Ownerguard
                {
                    if(llGetAgentSize(id))//Hit avatar
                    {
                        //if(phantom)damage=100.0;//Fuck 'em
                        vector size=llGetAgentSize(id);
                        vector end=llList2Vector(ray,i+1);
                        vector target=tar(id);
                        if(~llGetAgentInfo(id)&AGENT_CROUCHING)target.z+=size.z*0.5;//Adjusts head height for standing avatars
                        if(llVecDist(end,target)<0.35)proc(base_damage,id,1);//hed
                        else proc(base_damage,id,0);
                        attempts=0;//Ends loop if a valid target is hit.
                    }
                    else//Hit object/land
                    {
                        if((integer)((string)llGetObjectDetails(id,[OBJECT_PHANTOM])))//Raycast Blocker
                        {
                            llOwnerSay("Hit raycast blocker ["+llKey2Name(id)+"] owned by "+llKey2Name(llGetOwnerKey(id)));
                            ++phantom;//Sets all proceeding damage numbers to 100. Get fucked idiot.
                            //To be fair, this is not as punishing as the agentlist method since the ray will still stop if it hits a valid obstruction.
                        }
                        else l=0;//Stopped by obstruction
                    }
                }
                //else llOwnerSay("Hit owner");
                if(l)i+=2;
            }
        }
    }
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
        bloommod=(maxbloom-minbloom)/range;
        if(bloommod<=0.0)bloommod=0.01;
        //Locates link the Processor is in. Otherwise, keeps default setting -2 or everything except what this script is in.
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
            check();
            vector size=llGetAgentSize(o);
            ovh=size.z*0.5;
            llTakeControls(CONTROL_ML_LBUTTON,1,1);
        }
    }
    link_message(integer s, integer n, string m, key id)
    {
        if(id==(key)"dps")dps=n;
        //if(n)fire();//If true, fires via completely fair and balanced agentlist.
        //else rc();//If false, uses raycast only for target acquisition.
    }
    changed(integer c)
    {
        if(c&CHANGED_COLOR)boosh();
    }
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
