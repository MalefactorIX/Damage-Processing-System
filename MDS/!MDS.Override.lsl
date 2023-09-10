key o;
integer hchan;//Channel for height override, sent when a user is damaged.
string dataname="MDSOver";
clean(string id)
{
    list data=llCSV2List(llLinksetDataRead(dataname));
    if(llSubStringIndex((string)data,id)<0)return;
    else
    {
        integer n=llListFindList(data,[id]);
        if(n<0)return;
        data=llDeleteSubList(data,n,n+1);
    }
    llLinksetDataWrite(dataname,llList2CSV(data));
}
update(string id,string value)
{
    //llSay(0,id+","+value);
    list data=llCSV2List(llLinksetDataRead(dataname));
    if(llSubStringIndex((string)data,id)<0)data+=[id,value];
    else
    {
        integer n=llListFindList(data,[id]);
        if(n<0)return;
        data=llListReplaceList(data,[id,value],n,n+1);
    }
    llLinksetDataWrite(dataname,llList2CSV(data));
}
default
{
    state_entry()
    {
        o=llGetOwner();
        hchan=(integer)("0x" + llGetSubString(llMD5String(o,0), 4, 7));
        llListen(hchan,"","","");
    }
    on_rez(integer p)
    {
        llResetScript();
    }
    listen(integer chan, string name, key id, string message)
    {
        if(chan==hchan)
        {
            //llSay(0,message);
            id=llGetOwnerKey(id);
            if(llKey2Name(id))//Makes sure owner is in the sim
            {
                list data=llCSV2List(message);
                update((string)id,llList2String(data,4));
            }
        }
    }
}
