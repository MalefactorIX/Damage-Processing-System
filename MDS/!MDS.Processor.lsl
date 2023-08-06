//Settings
string ver="Fugi v1.0";//Skill yourself
float expose=1.25;//Damage multiplier for Exposed targets
float resist=0.75;//Damage multiplier for Resisting targets
float pen=0.5;//Armor Penetration (1.0 = No Penetration)
list auxdata;//Used for storing AUX usage
integer externalinput;//Does this weapon have an external component (ie. Grenades)?
string aspect="mdsbeta";//Required to be set in parity for meter sync
integer sync=-10283;//Channel weapopns listen to for syncing. Required to be set in parity for meter sync
integer staticchan=-10284;//Channel meters listen to for syncing, Required to be set in parity for meter sync
integer hitmarker=-1991;//Channel hitmarker listens to
//string url="https://raw.githubusercontent.com/MalefactorIX/Damage-Processing-System/master/DPS/VersionAuth/Series%20FI";//URL for version auth
//
list agents;
float armorcheck(string parse)//Returns armor value for armored avatars
{
    integer boot=llSubStringIndex(parse,"armor");
    if(boot<0)return 0.0;
    else return (float)llGetSubString(parse,boot+6,-1);
}
integer check(string parse, string text)//Checks AUX flags and status
{
    integer boot=llSubStringIndex(parse,text);
    if(boot<0)return 0;
    else return 1;
}
float lhit;
proc(string name, float damage, key id, integer head, integer ex)
{
    if(tar(id)==ZERO_VECTOR)return;//Agent no longer in region. (Usually the result of a delayed hit)
    if(llGetAgentInfo(id)&AGENT_SITTING)//Don't attempt to damage unkillable avatars (vehicles)
    {
        key lid=(string)llGetObjectDetails(id,[OBJECT_ROOT]);
        if(lid!=id)
        {
            if((integer)((string)llGetObjectDetails(lid,[OBJECT_PHANTOM])))return;
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
    integer aux=llListFindList(auxdata,[id]);
    //llSay(0,"Hit "+llKey2Name(id)+", AUX Value: "+(string)aux);
    if(aux>-1)//Aux processing
    {
        damage+=pdam;//Hey guys, remember when you could dump 50 points into Prowess and have 250 damage buckshot at any range? Yeah fuck that.
        integer ochan=llList2Integer(auxdata,aux+2);
        //llSay(0,(string)ochan+" | "+llKey2Name(llList2String(auxdata,aux))+" | "+llKey2Name(llList2String(auxdata,aux+1))+" | "+llList2String(auxdata,aux+2));
        string aid=llList2String(auxdata,aux+1);
        string temp=llKey2Name(aid);
        string desc=(string)llGetObjectDetails(aid,[OBJECT_DESC]);
        //llSay(0,llDumpList2String(desc,":"));
        if(check(desc,"dead"))return;//They're already dead
        else if(check(desc,"invul")){text("invul",name,"0",0);return;}//Ignore invulnerable targets
        else if(check(desc,"evad"))//Check for evasion status
        {
            if(~llGetAgentInfo(id)&AGENT_CROUCHING)
            {
                float vel=llVecMag((vector)((string)llGetObjectDetails(id,[OBJECT_VELOCITY])));
                float er=10.0*vel;
                if(llFrand(100.0)-er<0.0)//If true, roll miss.
                {
                    text("miss",name,"0",0);
                    return;
                }
            }
        }
        if(check(desc,"expose"))damage*=expose;//If target is exposed, apply multiplier
        else if(check(desc,"resist"))damage*=resist;//Same thing, but if they're resisting
        if(temp=="[MDS]Health")//Target is not shielded
        {
            string pretext="health";
            float armor=armorcheck(desc);
            if(armor>0.0&&!head)damage-=armor*pen;
            else if(check(desc,"block"))armor=1.0;
            if(damage<1.0)text("armor",name,"0",0);
            else
            {
                if(armor)pretext="armor";
                if(head)llRegionSayTo(aid,ochan,"dmg:"+(string)damage+":stagger:"+dur+":Lightning");
                else llRegionSayTo(aid,ochan,"dmg:"+(string)damage+":Lightning");
                text("armor",name,(string)llFloor(damage),head);
            }
            return;
        }
        else if(temp=="[MDS]Shield")//Target is shielded. We have to discrimnate since certain weapons have damage variance based on whether or not they're hitting a shield
        {
            float armor=armorcheck(desc);
            if(armor>0.0&&!head)damage-=armor*pen;
            if(damage<1.0)text("armor",name,"0",0);
            else
            {
                text("shield",name,(string)llFloor(damage),head);
                if(head)llRegionSayTo(aid,ochan,"shdmg:"+(string)damage+":stagger:"+dur+":Lightning");//Pass damage to shield
                else llRegionSayTo(aid,ochan,"shdmg:"+(string)damage+":Lightning");//Pass damage to shield
            }
            return;
        }
        else //Invalid aux name or no name returned (detached)
        {
            auxdata=llDeleteSubList(auxdata,aux,aux+2);//AUX no longer valid, so remove from storage
        }
    }
    else llRegionSayTo(id,staticchan,"ping");//Attempt to get their AUX to ping if they're wearing one.
}
text(string type, string name, string damage, integer head)
{
    if(head)llRegionSayTo(o,hitmarker,type+":"+name+":"+damage+" (Headshot)");
    else llRegionSayTo(o,hitmarker,type+":"+name+":"+damage);
}
cleanup()
{
    integer l=llGetListLength(auxdata);
    integer i;
    while(i<l)
    {
        key id=llList2String(auxdata,i);
        if(llGetAgentSize(id)!=ZERO_VECTOR&&tar(llList2String(auxdata,i+1))!=ZERO_VECTOR)i+=3;
        else
        {
            if(id==o)oaux="";
            l-=3;
            auxdata=llDeleteSubList(auxdata,i,i+2);
        }
    }
    //llSay(0,llDumpList2String(auxdata," | "));
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
    llListen(mychan,"","","");
    llListen(sync,"","","pong");
    llSetTimerEvent(3.0);
    llRegionSay(staticchan,"ping");
    llRequestPermissions(o,0x4);
    llTakeControls(CONTROL_ML_LBUTTON,1,1);
    //llOwnerSay("System now online.");
}
string oname;
integer mychan;
integer exchan;
key oaux;
//Prowess Vars
float pdam=1.0;
float basedur=2.0;
string dur="2";
default
{
    on_rez(integer P)
    {
        llResetScript();
    }
    state_entry()
    {
        mychan=-1*llAbs((integer)("0x" + llGetSubString(llMD5String(o=llGetOwner(),0), 0, 5)));
        staticchan=-1*llAbs((integer)("0x" + llGetSubString(llMD5String(aspect,0),0,5))-staticchan);
        sync=-1*llAbs((integer)("0x" + llGetSubString(llMD5String(aspect,0),0,5))-sync);
        oname=llGetObjectName();
        auxdata=[];
        llReadKeyValue("WeaponVersion_MDS");
        //llHTTPRequest(url, [HTTP_BODY_MAXLENGTH,6000], "");//Fuck that, lmfao.
        //Since the experience is a hard requirement to use the meter, we can version lock via that experince to avoid hitting the region with more HTTP requests.

    }
    dataserver(key req, string data)
    {
        integer checksum=(integer)llGetSubString(data,0,0);
        llSetObjectName("MDS Processor");
        if(checksum)
        {
            checksum=llSubStringIndex(data,ver);
            if(checksum>-1)
            {
                llOwnerSay("System is up to date. Starting up...");
                boot();
            }
            else
            {
                llOwnerSay("[MDS Failure] Please make sure you are using the most up-to-date version of this item.\nIf you continue to receive this error, please notify the distributor.");
                llSetObjectName(oname);
                state inactive;
            }
        }
        else
        {
            llOwnerSay("[Experience Error] MDS not available due to an error ["+llGetSubString(data,2,-1)+"].\nPlease make sure you are in a DPS Experience-enabled region and try again.");
            llSetObjectName(oname);
            boot();//Force debug
            //state inactive;
        }
    }
    /*http_response(key request_id, integer status, list metadata, string body)
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
    }*/
    link_message(integer s, integer n, string data, key id)
    {
        //Data: (1)Currency,(2)EXP,(3)Rank,(4)Division,(5)STR,(6)PRC,(7)DEX,(8)FRT,(9)END,(10)RES
        if(id==(key)"stat")//Root script gets stats and passes them here (for now)
        {
            list stats=llCSV2List(data);
            float prc=(float)llList2String(stats,6);
            if(prc>25)prc=25;//No seriously, fuck that shit
            if(prc!=pdam)llOwnerSay("Your Precision is affecting this weapon...");
            pdam=prc;
        }
        else if(id)
        {
            if(oaux)
            {
                string desc=(string)llGetObjectDetails(oaux,[OBJECT_DESC]);
                if(desc=="")
                {
                    oaux="";
                    return;
                }
                else if(check(desc,"stun"))return;
                list parse=llCSV2List(data);
                proc(llList2String(parse,0),(float)llList2String(parse,1),id,(integer)llList2String(parse,2),0);
            }
        }
    }
    listen(integer chan, string name, key id, string message)
    {
        if(message=="pong")
        {
            //llSay(0,name+" ["+llKey2Name(llGetOwnerKey(id))+"]: "+message);
            key oid=llGetOwnerKey(id);
            //if(id==oid||oid==o)return;
            integer aux=llListFindList(auxdata,[oid]);//Owner_UUID Parameter
            if(aux<0)//Owner not found
            {
                //llSay(0,aspect);
                integer auxchan=-1*llAbs((integer)("0x" + llGetSubString(llMD5String((string)oid+aspect,0), 0, 5)));
                auxdata+=[oid,id,auxchan];//New data: Written as Owner_ID,AUX_ID,AUX_Channel
                //llSay(0,"Received response from "+llKey2Name(oid)+" set to "+(string)auxchan);
                if(oid==o)oaux=id;
                //llSay(0, "Added "+llKey2Name(oid)+" with "+(string)((integer)ochan));
                //llSay(0,llDumpList2String(auxdata," | "));
                //llOwnerSay("AUX Data added for "+llKey2Name(oid));
            }
            else if(llList2Key(auxdata,aux+1)!=id)//Aux UUID does not match registered AUX ID (reattach or relog)
            {
                if(oid==o)oaux=id;
                auxdata=llListReplaceList(auxdata,[id],aux+1,aux+1);//Update data
                //llOwnerSay("AUX Data updated for "+llKey2Name(oid)+" on channel "+(string)llList2Integer(auxdata,aux+2));
            }
        }
        else if(chan==exchan)
        {
            if(oaux)
            {
                string desc=(string)llGetObjectDetails(oaux,[OBJECT_DESC]);
                if(desc=="")
                {
                    oaux="";
                    return;
                }
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
        if(llGetTime()>15.0)cleanup();
    }
}
state inactive
{
    on_rez(integer p)
    {
        llResetScript();
    }
}
