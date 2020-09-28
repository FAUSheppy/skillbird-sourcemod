#include "Interfaces.sp"

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast){

    SubmittEventActiveClients();
    SubmittEventMapInformation();

    /* generate session id for this round */
    SetConVarInt(FindConVar("session-id"), GetRandomInt(0, 200000));
    return Plugin_Continue;
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast){
    SubmittEventActiveClients("round_winner");
    new team_id = GetEventInt(event, "winner");
    SubmittEventWinnerTeam(team_id);
    SubmittEventRoundEnd();
    return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast){    
    SubmittEventActiveClients("disconnect");
    return Plugin_Continue;
}

public Action:Event_PlayerChangedTeam(Handle:event, const String:name[], bool:dontBroadcast){
    SubmittEventActiveClients("change_team");
    return Plugin_Continue;
}
