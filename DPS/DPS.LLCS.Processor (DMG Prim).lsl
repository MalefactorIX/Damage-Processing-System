vector tar(key id)
{
    return (vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
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
                    if(llVecMag((vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY])))>15.0)llSetScale(<4.0,4.0,4.0>);
                    //(ﾉ´･ω･)ﾉ ﾐ ┸━┸
                    llSetStatus(STATUS_PHANTOM,0);
                    llResetTime();
                    while(llGetTime()<2.0)
                    {
                        llSetRegionPos(tar(id));
                    }
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
