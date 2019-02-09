#define DEFAULT_LEN 64
#define MAX_PLAYERS 32
#define MAX_LENGTH_ID_TEAM 128

public void EventWinnerTeam(Handle:event, char[] prefix, char[] buf, int buflen){
    new team_id = GetEventInt(event, "winner");
    Format(buf,buflen,"%s,%d",prefix,team_id);
}

public void MapName(char[] prefix, char[] buf, int buflen){
    new String:map[DEFAULT_LEN];
    GetCurrentMap(map, sizeof(map));
    Format(buf, buflen, "%s%s", prefix, map);
}

public void ServerName(char[] buf,int buflen){
    new String:sname[SNAME_LEN];
    ConVar servername = FindConVar("hostname");
    servername.GetString("sname",SNAME_LEN);
    ReplaceString(sname,SNAME_LEN," ","");
    ReplaceString(sname,SNAME_LEN,"[","");
    ReplaceString(sname,SNAME_LEN,"]","");
    ReplaceString(sname,SNAME_LEN,"(","");
    ReplaceString(sname,SNAME_LEN,")","");
}


public void RebuildTeams(char[] SEP, char[] SUBSEP, char[] input){
    
    /* buffers for later */
    char buffers[MAX_PLAYERS][MAX_LENGTH_ID_TEAM];
    new parts = ExplodeString(input, SEP, buffers, MAX_PLAYERS, MAX_LENGTH_ID_TEAM);
    new StringMap:map;

    /* i=1 to skip tag in something like TAG,player|team,player|team,... */
    for(new i = 1; i < parts; i++){
      char idAndTeam[2][MAX_LENGTH_ID_TEAM];
      ExplodeString(buffers[i], SUBSEP, idAndTeam, 2, MAX_LENGTH_ID_TEAM);
      map.SetString(idAndTeam[0], idAndTeam[1], true);
    }

    /* hasmap indirection nessesary cause there doesnt exist a "ClientByAuthID-like function */
    for(new client=0; client <MaxClients; client++){ 
      /* get Steam-Id to match */
      char sid[DEFAULT_LEN];
      if(client>0 && IsClientConnected(client)){
          GetClientAuthId(client, AuthId_SteamID64, sid, DEFAULT_LEN, true);
      }
      /* get team for steamid  and balance*/
      char team[MAX_LENGTH_ID_TEAM];
      if(map.GetString(sid, team, sizeof(team))){
          new tid = StringToInt(team);
          if(tid>0 && IsClientConnected(client)){
              ChangeClientTeam(client, tid);
          } 
      }
    }
}
