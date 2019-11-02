#pragma tabsize 0
#include <sourcemod>
#include <sdktools>
#include <socket>
#include "client.sp"
#include "utils.sp"
#include "query.sp"
#define DEFAULT_LEN 64
#define SNAME_LEN   256

/* ---------------------- Globals ---------------------- */
static Handle:logfile;

/* ---------------------- Timers ---------------------- */
public Action:Timer_MapStart(Handle:timer){
    LogActiveClients(logfile, "0x42,map_start_active,");
    return Plugin_Continue;
}

public Action:Timer_RoundStart(Handle:timer){
    LogActiveClients(logfile, "0x42,round_start_active,");
    char map[SNAME_LEN];
    MapName("0x42,mapname,",map, sizeof(map));
    LogToOpenFile(logfile, map);
    return Plugin_Continue;
}

/* ---------------------- Events ---------------------- */
public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast){
    LogActiveClients(logfile, "0x42,round_start_active,");
    return Plugin_Continue;
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast){
    char eventWTeam[SNAME_LEN];
    EventWinnerTeam(event, "0x42,winner,", eventWTeam, sizeof(eventWTeam));
    LogToOpenFile(logfile, eventWTeam);
    LogActiveClients(logfile, "0x42,round_end_active,");
    return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast){    
    LogClientEventFormat(logfile, event, "0x42,disconnect,");
    LogActiveClients(logfile, "0x42,dc,");
	  return Plugin_Continue;
}

public Action:Event_PlayerChangedTeam(Handle:event, const String:name[], bool:dontBroadcast){
    LogActiveClients(logfile, "0x42,tc,");
    LogClientEventFormat(logfile, event,"0x42,teamchange,");
	  return Plugin_Continue;
}

public OnMapStart(){
    CreateTimer(5.0,Timer_MapStart);
}

/* ---------------------- Plugin ---------------------- */
public Plugin:myinfo = {
	name = "skillbird-query",
	author = "FAUSheppy",
	description = "Backend for trueskill rating system",
	version = "2.0",
	url = "https://github.com/FAUSheppy/skillbird-sourcemod"
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max){
	return APLRes_Success;
}

public OnPluginStart(){
    
    char server[SNAME_LEN];
    ServerName(server, sizeof(server));
    logfile = OpenFile(server,"at",false,NULL_STRING);
   
    /* inial line */
    LogToOpenFile(logfile,"0x42,start");
     
    /* Hook Events */
	HookEvent("round_end", Event_RoundEnd);	
	HookEvent("player_team", Event_PlayerChangedTeam);	
	HookEvent("player_disconnect", Event_PlayerDisconnect);	
}

public OnPluginEnd(){
    LogToOpenFile(logfile,"0x42,plugin unloaded");
    CloseHandle(logfile);
}
