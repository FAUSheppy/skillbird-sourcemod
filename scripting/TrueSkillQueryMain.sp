/* no idea, but removes warnings */
#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include <socket>
#include "query.sp"
#include "client.sp"
#include "utils.sp"

#define DEFAULT_LEN  64
#define INVALID      0

#define REBUILD_TEAM    true
#define NO_REBUILD_TEAM false

/* ---------------------- Hooks ---------------------- */
public OnClientAuthorized(client,const String:auth[]){
    CreateTimer(5.0, Timer_ConnectMessage, client);
    CreateTimer(5.0, Timer_QueryTeam,      client);
}
public OnScrambleTeams(){
    QueryTeam(GetSocket(), "NONE", REBUILD_TEAM);
}

/* ---------------------- Timers ---------------------- */
public Action Timer_ConnectMessage(Handle timer, int client){
    QueryRating(client);
    return Plugin_Continue;
}

public Action Timer_QueryTeam(Handle timer, int client){
    char clientIDString[DEFAULT_LEN];
    ClientID(client, clientIDString, DEFAULT_LEN);
    QueryTeam(GetSocket(), clientIDString, false);
    return Plugin_Continue;
}

/* ---------------------- Plugin ---------------------- */
public Plugin:myinfo = {
	name = "TrueSkill Query Plugin",
	author = "sheppy",
	description = "Queries to RatingDB",
	version = "2.0",
	url = "atlantishq.hq"
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max){
	return APLRes_Success;
}

public OnPluginStart(){
    CreateQuerySocket(7040);
}

public OnPluginEnd(){
    if (GetSocket() == INVALID_HANDLE){
        return;
    }
	CloseHandle(GetSocket());
}
