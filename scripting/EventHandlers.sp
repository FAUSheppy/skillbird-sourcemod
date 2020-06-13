#include "Interfaces.sp"

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast){

    SubmittEventActiveClients();
    SubmittEventMapInformation()
    return Plugin_Continue;
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast){
    SubmittEventActiveClients();
    new team_id = GetEventInt(event, "winner");
    SubmittEventWinnerTeam(team_id);
    SubmittEventRoundEnd();
    return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast){    
    SubmittEventActiveClients();
	return Plugin_Continue;
}

public Action:Event_PlayerChangedTeam(Handle:event, const String:name[], bool:dontBroadcast){
    SubmittEventActiveClients();
	return Plugin_Continue;
}