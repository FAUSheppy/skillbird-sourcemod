#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include "Timers.sp"
#include "EventHandlers.sp"

#define DEFAULT_LEN 64
#define SNAME_LEN   256


/* ---------------------- Plugin ---------------------- */
public Plugin:myinfo = {
	name        = "skillbird",
	author      = "FAUSheppy",
	description = "Module to interact with the skillbird framework",
	version     = "3.0",
	url         = "https://github.com/FAUSheppy/skillbird-sourcemod"
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max){
	return APLRes_Success;
}

public OnPluginStart(){

    /* Hook Events */
	HookEvent("round_end", Event_RoundEnd);	
	HookEvent("player_team", Event_PlayerChangedTeam);	
	HookEvent("player_disconnect", Event_PlayerDisconnect);	
}

public OnClientAuthorized(client, const String:auth[]){
    CreateTimer(5.0, Timer_ConnectMessage, client);
}

public OnMapStart(){
}