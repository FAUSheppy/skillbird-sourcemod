#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include "IngameMessages.sp"
#include "EventHandlers.sp"

#define DEFAULT_LEN 64
#define SNAME_LEN   256

#define VAR_SESSION_ID "session_id"
#define VAR_TARGET_PORT "skillbird_target_port"

/* ---------------------- Plugin ---------------------- */
public Plugin:myinfo = {
    name        = "Skillbird",
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
    HookEvent("round_start", Event_RoundStart);
    HookEvent("player_team", Event_PlayerChangedTeam);    
    HookEvent("player_disconnect", Event_PlayerDisconnect);    

    CreateConVar(VAR_SESSION_ID, "0", "Session in for this round");
    CreateConVar(VAR_TARGET_PORT, "6200", "Skillbird backend target port", FCVAR_PROTECTED);

    RegConsoleCmd("rating", CommandRating);
}

public OnClientAuthorized(client, const String:auth[]){
    CreateTimer(5.0, Timer_ConnectMessage, client);
}

public OnMapStart(){
    SetConVarInt(FindConVar(VAR_SESSION_ID), GetRandomInt(1, 200000));
}
