//Settings
string ver="Fugi v1.0";//Skill yourself
string prim;//Damage Prim for DPS (Updated on boot but can be hardcoded here)
integer hitmarker=-1991;//Channel hitmarker listens to
integer externalinput;//Does this weapon have an external component (ie. Grenades)?
string url="https://raw.githubusercontent.com/MalefactorIX/Damage-Processing-System/master/DPS/VersionAuth/Series%20FI";//URL for version auth
//
list agents;
float lhit;
proc(string name, float damage, key id, integer head, integer ex)
{
    list agents=llGetAgentList(AGENT_LIST_REGION,[]);
    integer agent=llListFindList(agents,[id]);
    if(agent<0||tar(id)==ZERO_VECTOR)return;//Agent no longer in region. (Usually the result of a delayed hit)
    else if(llGetAgentInfo(id)&AGENT_SITTING)//Don't attempt to damage unkillable avatars (vehicles)
    {
        key lid=(string)llGetObjectDetails(id,[OBJECT_ROOT]);
        if(lid!=id)
        {
            if((integer)((string)llGetObjectDetails(lid,[OBJECT_PHANTOM])))return;//Checks to see if they're on a tank
        }
    }
    //
    if(head)
    {
        float hit=llGetTimeOfDay();
        if(llFabs(hit-lhit)>0.5)
        {
            damage*=2.0;
            lhit=hit;
        }
    }
    //LLCS Text
    if(head)text("crit",name,(string)llFloor(damage),1);//skill issue
    else text("hit",name,(string)llFloor(damage),0);
    //LLCS processing
    integer tkey=1+(integer)("0x"+llGetSubString(llMD5String(id,0), 0, 1));
    if(tkey<10)tkey*=10;
    else if(tkey>99)tkey=llRound(tkey*0.1);
    if(tkey>99)
    {
        llOwnerSay("DPS ERROR: Unable to generate a validation code for "+name);
        return;
    }
    string aparse=(string)agent;
    if(agent<10)aparse="0"+aparse;//Supports sims with up to 99 agents
    string parse=(string)tkey+aparse+(string)((integer)damage);//Note to self: Never put aparse at the start of the string
    integer p=(integer)parse;
    //Output Format: VVAADDDD...
    llRezObject(prim,llGetPos()+<0.0,0.0,5.0>,ZERO_VECTOR,ZERO_ROTATION,p);
}
text(string type, string name, string damage, integer head)
{
    if(head)llRegionSayTo(o,hitmarker,type+":"+name+":"+damage+" (Headshot)");
    else llRegionSayTo(o,hitmarker,type+":"+name+":"+damage);
}
vector tar(key id)
{
    vector av=(vector)((string)llGetObjectDetails(id,[OBJECT_POS]));
    return av;
}
key o;
boot()
{
    llSetObjectName(oname);
    if(externalinput)
    {
        exchan=mychan+externalinput;
        llListen(exchan,"","","");
    }
    llSetTimerEvent(3.0);
    llRequestPermissions(o,0x4);
    llTakeControls(CONTROL_ML_LBUTTON,1,1);
    //llOwnerSay("System now online.");
}
string oname;
integer mychan;
integer exchan;
//Prowess Vars
integer dmode;
default
{
    on_rez(integer P)
    {
        llResetScript();
    }
    state_entry()
    {
        prim=llGetInventoryName(INVENTORY_OBJECT,0);
        if(prim=="")prim="INVALID_NAME_NO_OBJECT";
        //llOwnerSay("Damage prim set to '"+prim+"]' If this is incorrect, make sure there is only 1 object in the link this script is inside of and then reset this script");
        mychan=(integer)("0x" + llGetSubString(llMD5String(o=llGetOwner(),0), 0, 2));
        oname=llGetObjectName();
        dmode=llGetParcelFlags(<128.0,128.0,0.0>)&PARCEL_FLAG_ALLOW_DAMAGE;
        llHTTPRequest(url, [HTTP_BODY_MAXLENGTH,6000], "");

    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        list parse=llCSV2List(body);
        body="";
        //integer usable=16384-llStringLength(llList2String(parse,0));
        llSetObjectName("DPS Processor");
        if(llGetListLength(parse)>1)
        {
            integer p=llListFindList(parse,[ver]);
            if(p>-1)
            {
                llOwnerSay("System is up to date. Starting up...");
                boot();
            }
            else
            {
                llOwnerSay("ERROR: Version is out of date or no longer supported. Please grab the latest copy from a vendor. System start has been terminated");
                llSetObjectName(oname);
                state inactive;
            }
        }
        else
        {
            llOwnerSay("ERROR: Unable to communicate properly with version log. Forcing startup...");
            boot();//Failsafe
        }
    }
    link_message(integer s, integer n, string data, key id)
    {
        //Data: (1)Currency,(2)EXP,(3)Rank,(4)Division,(5)STR,(6)PRC,(7)DEX,(8)FRT,(9)END,(10)RES
        if(id==(key)"stat")return;
        else if(id)
        {
            if(dmode)//Make sure damage is on
            {
                //Data is: Target NAME,Damage Dealt,Headshot
                //Target UUID is placed in event ID
                list parse=llCSV2List(data);
                proc(llList2String(parse,0),(float)llList2String(parse,1),id,(integer)llList2String(parse,2),0);

            }
        }
    }
    listen(integer chan, string name, key id, string message)
    {
        //if(chan==exchan)
        {
            if(dmode)//Make sure damage is on
            {
                list parse=llCSV2List(message);
                //llSay(0,message);
                if(llList2String(parse,0)=="dmg")
                //Data is: Flag, Target NAME,Damage Dealt,TargetUUID
                //Target UUID is placed in event
                    proc(llList2String(parse,1),(float)llList2String(parse,2),llList2String(parse,3),0,1);
            }
        }
    }
    timer()
    {
        if(llGetTime()>15.0)dmode=llGetParcelFlags(<128.0,128.0,0.0>)&PARCEL_FLAG_ALLOW_DAMAGE;
    }
}
state inactive
{
    on_rez(integer p)
    {
        llResetScript();
    }
}
