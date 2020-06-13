#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include <socket>

#define DEFAULT_LEN 64
#define SNAME_LEN   256
#define ACTIVE_CLIENTS_LENGTH 8192

public void SmartClientName(const client, char[] buf, buflen){
    new String:name[DEFAULT_LEN];
    if(IsClientConnected(client)){
        GetClientName(client, name, DEFAULT_LEN);
    }
}

public void SmartClientID(int client, char[] buf, int buflen){
    if(IsClientConnected(client)){
        GetClientAuthId(client, AuthId_SteamID64, buf, DEFAULT_LEN, true);
    }
}

public void SubmittEventActiveClients(){
    //new String:str_tmp[ACTIVE_CLIENTS_LENGTH];
    for(new i = 1; i <= MaxClients;i++){
        new String:strCliID[DEFAULT_LEN];
        new String:strCliName[DEFAULT_LEN];
        SmartClientID(i, strCliID, DEFAULT_LEN);
        SmartClientName(i, strCliName, DEFAULT_LEN);
        // strCliID, strCliName, GetClientTeam(i));
    }
    // return json
}

public void SubmittEventMapInformation(){
    new String:mapname[DEFAULT_LEN];
    GetCurrentMap(mapname, sizeof(mapname));
}

public void SubmittEventWinnerTeam(int team_id){

}

public void SubmittEventRoundEnd(){

}