#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include <socket>

#define DEFAULT_LEN 64
#define SNAME_LEN   256
#define ACTIVE_CLIENTS_LENGTH 8192

public void  ClientName(const client,char[] buf,buflen){
    new String:name[DEFAULT_LEN];
    if(IsClientConnected(client)){
        GetClientName(client, name, DEFAULT_LEN);
        
        /* get fucked if you use my seperators in your name */
        ReplaceString(name, DEFAULT_LEN,",","$");
        ReplaceString(name, DEFAULT_LEN,"|","&");
        ReplaceString(name, DEFAULT_LEN,"0x42","0x21");
    }
}

public void ClientID(int client, char[] buf, int buflen){
    if(IsClientConnected(client)){
        GetClientAuthId(client, AuthId_SteamID64, buf, DEFAULT_LEN, true);
    }
}

public void ActiveClients(char[] prefix, char[] buf, buflen){
    new String:str_tmp[ACTIVE_CLIENTS_LENGTH];
    for(new i = 1; i <= MaxClients;i++){
        new String:strCliID[DEFAULT_LEN];
        new String:strCliName[DEFAULT_LEN];
        ClientID(i, strCliID, DEFAULT_LEN);
        ClientName(i, strCliName, DEFAULT_LEN);
        Format(str_tmp, ACTIVE_CLIENTS_LENGTH, 
                "%s|%s|%s|%d,", str_tmp, strCliID, strCliName, GetClientTeam(i));
    }
    Format(str_tmp, ACTIVE_CLIENTS_LENGTH, "%s%s", prefix,str_tmp);
}

public void LogActiveClients(Handle:logfile, char[] prefix){
    char strActiveClients[ACTIVE_CLIENTS_LENGTH];
    ActiveClients(prefix, strActiveClients, ACTIVE_CLIENTS_LENGTH);
    LogToOpenFile(logfile, strActiveClients);
}

public void LogClientEventFormat(Handle:logfile, Handle:event, char[] prefix){
    char strClientEvent[2*DEFAULT_LEN];
    ClientEventFormat(event, prefix, strClientEvent, 2*DEFAULT_LEN);
    LogToOpenFile(logfile, strClientEvent);

}

public void ClientEventFormat(Handle:event, char[] prefix, char[] buf, buflen){
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    char team[4];
    Format(team, sizeof(team), "%d", GetClientTeam(client));
    char tmp[DEFAULT_LEN*2];
    char strCliID[DEFAULT_LEN];
    ClientID(client, strCliID, DEFAULT_LEN);
    Format(tmp, 2*DEFAULT_LEN, "%s%s,%s", prefix, strCliID, team);
}
