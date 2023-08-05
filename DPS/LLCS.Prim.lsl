vector tar(key id)
{
    vector pos=(vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
    if(llGetParcelFlags(pos)&PARCEL_FLAG_ALLOW_DAMAGE)return pos;
    else //Trying to move to a parcel where damage is off, kill the prim
    {
        llDie();
        return ZERO_VECTOR;
    }
}
default
{
    state_entry()
    {
        llCollisionSound("",1.0);
    }
    on_rez(integer p)
    {
        if(p)
        {   //Still less laggy than a projectile moving at 200m/s
            vector o=llGetPos();
            integer agent=(integer)llGetSubString((string)p,2,3);
            key id=llList2Key(llGetAgentList(AGENT_LIST_REGION,[]),agent);
            integer checksum=(integer)llGetSubString((string)p,0,1);
            integer tkey=1+(integer)("0x"+llGetSubString(llMD5String(id,0), 0, 1));
            if(tkey<10)tkey*=10;
            else if(tkey>99)tkey=llRound(tkey*0.1);
            if(tkey==checksum)
            {
                float dam=(float)llGetSubString((string)p,4,-1);
                //llSay(0,"Parse: "+agent+"|"+(string)dam);
                llSetDamage(dam);
                llSetRegionPos(o=tar(id));
                llSetObjectName(llGetObjectName()+" ["+(string)((integer)dam)+" LLCS]");
                if(llVecDist(o,llGetPos())<0.5)
                {
                    if(llVecMag((vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY])))>15.0)
                        llSetScale(<5.0,5.0,5.0>);//Forces the prim to be bigger to hit fast moving avatars
                    //(ﾉ´･ω･)ﾉ ﾐ ┸━┸
                    llSetStatus(STATUS_PHANTOM,0);
                    llResetTime();
                    while(llGetTime()<4.0)llSetRegionPos(tar(id));
                    llSetStatus(STATUS_PHYSICS,1);
                    llSleep(0.2);
                }
                else llOwnerSay("/me cannot move to target's position!");
            }
            else llOwnerSay("/me cannot validate agent parameter: Expected "+(string)checksum+" got "+(string)tkey+" from agent ID# "+(string)agent+" "+llKey2Name(id));
            llDie();
        }
    }
}
