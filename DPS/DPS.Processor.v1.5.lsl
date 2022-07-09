//Settings
string prim="[TK]Teravolt.RC.DPS";//Damage Prim for DPS
float expose=1.25;//Damage multiplier for Exposed targets
float resist=0.75;//Damage multiplier for Resisting targets
float pen=0.5;//Armor Penetration (1.0 = No Penetration)
list auxdata;//Used for storing AUX usage
integer externalinput;//Does this weapon have an external component (ie. Grenades)?
integer sync=-10283;//Channel weapopns listen to for syncing
integer staticchan=-10284;//Channel meters listen to for syncing
integer hitmarker=-1991;//Channel hitmarker listens to
string url="https://raw.githubusercontent.com/MalefactorIX/Damage-Processing-System/master/DPS/VersionAuth/Series%20A1";//URL for doc
//
list agents;
string aspect="tek";//Damage flagging for meter interpretation
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
    integer agent=llListFindList(agents,[id]);
    if(agent<0)return;//Agent no longer in region. (Usually the result of a delayed hit)
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
            damage*=1.5;
            lhit=hit;
        }
    }
    integer aux=llListFindList(auxdata,[id]);
    if(aux>-1)//Aux processing
    {
        damage+=pdam;//Scale
        integer ochan=(integer)llList2String(auxdata,aux+2);
        //llSay(0,(string)ochan+" | "+llKey2Name(llList2String(auxdata,aux))+" | "+llKey2Name(llList2String(auxdata,aux+1))+" | "+llList2String(auxdata,aux+2));
        string aid=llList2String(auxdata,aux+1);
        string temp=llKey2Name(aid);
        string desc=(string)llGetObjectDetails(aid,[OBJECT_DESC]);
        //llSay(0,llDumpList2String(desc,":"));
        if(check(desc,"dead"))return;
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
        else if(check(desc,"resist"))damage*=resist;//Same thing
        if(temp=="[DPS]Health")//Target is not shielded
        {
            string pretext="health";
            float armor=armorcheck(desc);
            if(armor>0.0&&!head)damage-=armor*pen;
            else if(check(desc,"block"))armor=1.0;
            if(damage<1.0)text("armor",name,"0",0);
            else
            {
                if(armor)pretext="armor";
                if(head)llRegionSayTo(aid,ochan,"dmg:"+(string)damage+":expose:"+dur+":"+aspect);
                else llRegionSayTo(aid,ochan,"dmg:"+(string)damage+":"+aspect);
                text("armor",name,(string)llFloor(damage),head);
            }
            return;
        }
        else if(temp=="[DPS]Shield")//Target is shielded
        {
            float armor=armorcheck(desc);
            if(armor>0.0&&!head)damage-=armor*pen;
            if(damage<1.0)text("armor",name,"0",0);
            else
            {
                text("shield",name,(string)llFloor(damage),head);
                if(head)llRegionSayTo(aid,ochan,"shdmg:"+(string)damage+":expose:"+dur+":"+aspect);//Pass damage to shield
                else llRegionSayTo(aid,ochan,"shdmg:"+(string)damage+":"+aspect);//Pass damage to shield
            }
            return;
        }
        else //Invalid aux name or no name returned (detached)
        {
            auxdata=llDeleteSubList(auxdata,aux,aux+2);//AUX no longer valid, so remove from storage
        }
    }
    else if(dmode)
    {
        //LLCS Text
        if(head)text("crit",name,(string)llFloor(damage),1);//gottem
        else text("hit",name,(string)llFloor(damage),0);
        float damage=damage*10.0;//Final damage
        //LLCS processing
        string aparse=(string)agent;
        if(agent<10)aparse="00"+(string)agent;
        else aparse="0"+(string)agent;
        integer D=(integer)damage;
        string parse=(string)D+aparse;
        integer p=(integer)parse;
        llRezObject(prim,llGetPos()+<0.0,0.0,5.0>,ZERO_VECTOR,ZERO_ROTATION,p);
    }
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
string ver="TKTera v1.1.3";
string oname;
integer mychan;
integer exchan;
key oaux;
//Prowess Vars
float pdam=1.0;
float basedur=2.0;
string dur="2";
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
        llOwnerSay("[DEV KIT NOTICE] Damage prim set to ["+prim+"]. If this is incorrect, make sure there is only 1 object in the link this script is inside of and then reset this script");
        mychan=(integer)("0x" + llGetSubString(llMD5String(o=llGetOwner(),0), 0, 2));
        oname=llGetObjectName();
        auxdata=[];
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
        if(id)
        {
            if(oaux)
            {
                string desc=(string)llGetObjectDetails(oaux,[OBJECT_DESC]);
                if(desc=="")
                {
                    oaux="";
                    if(!dmode)return;
                }
                else if(check(desc,"stun"))return;
                list parse=llCSV2List(data);
                proc(llList2String(parse,0),(float)llList2String(parse,1),id,(integer)llList2String(parse,2),0);
            }
            else if(dmode)
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
        if(message=="pong")
        {
            //llSay(0,name+" ["+llKey2Name(llGetOwnerKey(id))+"]: "+message);
            key oid=llGetOwnerKey(id);
            //if(id==oid||oid==o)return;
            integer aux=llListFindList(auxdata,[oid]);//Owner_UUID Parameter
            if(aux<0)//Owner not found
            {
                string ochan="0x"+llGetSubString(llMD5String((string)oid,0),0,3);
                auxdata+=[oid,id,ochan];//New data: Written as Owner_ID,AUX_ID,AUX_Channel
                if(oid==o)
                {
                    llRegionSay(staticchan,"stat");//Polls DPS stats for owner
                    oaux=id;
                }
                //llSay(0, "Added "+llKey2Name(oid)+" with "+(string)((integer)ochan));
                //llSay(0,llDumpList2String(auxdata," | "));
                //llOwnerSay("AUX Data added for "+llKey2Name(oid));
            }
            else if(llList2Key(auxdata,aux+1)!=id)//Aux UUID does not match registered AUX ID (reattach or relog)
            {
                if(oid==o)
                {
                    llRegionSay(staticchan,"stat");//Polls DPS stats for owner
                    oaux=id;
                }
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
                    if(!dmode)return;
                }
                list parse=llCSV2List(message);
                //llSay(0,message);
                if(llList2String(parse,0)=="dmg")
                //Data is: Flag, Target NAME,Damage Dealt,TargetUUID
                //Target UUID is placed in event
                    proc(llList2String(parse,1),(float)llList2String(parse,2),llList2String(parse,3),0,1);
            }
            else if(dmode)
            {
                list parse=llCSV2List(message);
                //llSay(0,message);
                if(llList2String(parse,0)=="dmg")
                //Data is: Flag, Target NAME,Damage Dealt,TargetUUID
                //Target UUID is placed in event
                    proc(llList2String(parse,1),(float)llList2String(parse,2),llList2String(parse,3),0,1);
            }
        }
        else
        {
            //llList2CSV([prowess,durability,mobility,sustain,battery]));
            if(id==oaux)
            {
                llMessageLinked(LINK_ROOT,1,message,"stat");
                list parse=llCSV2List(message);
                float prow=(float)llList2String(parse,0);
                if(prow>60)prow=60;
                //float dura=1.0+(prow/100.0);
                pdam=prow*0.25;
                //aspect=llList2String(parse,-1);
                //dur=(string)llFloor(basedur*dura);
            }
        }
    }
    timer()
    {
        list temp=llGetAgentList(AGENT_LIST_REGION,[]);
        if(temp!=agents)
        {
            agents=temp;
            llRegionSay(staticchan,"ping");//Resync
        }
        if(llGetTime()>15.0)
        {
            cleanup();
            dmode=llGetParcelFlags(<128.0,128.0,0.0>)&PARCEL_FLAG_ALLOW_DAMAGE;
        }
    }
}
state inactive
{
    on_rez(integer p)
    {
        llResetScript();
    }
}
