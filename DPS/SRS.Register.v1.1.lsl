//Important Note: This should -NEVER- be used in excess of 600 RPM.
float base_damage=45.0;//Max damage
float min_damage=15;//Min damage
float falloff=-0.5;//Damage falloff (Negative Float)
float range=15.0;//How many meters before falloff starts, applies to both damage and ranged inaccuracy
float distmod=0.5;///How much less accurate rounds are per meter from target (%)
float recoil=0.2;//How much less accurate rounds are per shot (%)
float recovery=3.0;//How long it takes for recoil to fully reset
float move=2.5;//How less accurate you are per m/s. Example: Avatars run at 5.3 m/s, so at 5.0, this will result in a movement penalty of about 26%
float jumping=25.0;//Accuracy penalty for jumping or being in the air.
float maxspread=30.0;
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

                float spr=0.5+(dist*0.025);//Cone, or physical spread of the shots
                if(dist>40.0)spr=1.5;//Maximum cone width
                float hor=llVecDist(<end.x,end.y,0.0>,<target.x,target.y,0.0>);
                if(hor>0.75)inacc-=10.0*(hor-0.5);//Reduces accuracy based on how far off target the aim is.
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
                        float damage;
                        if(dist<range)damage=base_damage;
                        else damage=base_damage+((dist-range)*falloff);
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
default
{
    state_entry()
    {
        integer l=llGetNumberOfPrims()+1;
        while(l--)
        {
            string name=llGetLinkName(l);
            if(name=="dps")auxcore=l;
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
                if(nmob>50)nmob=50;
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
