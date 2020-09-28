#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include <socket>
#include <system2>
#include <json>

#define DEFAULT_LEN 64
#define SNAME_LEN   256
#define ACTIVE_CLIENTS_LENGTH 8192
#define VAR_TARGET_PORT "skillbird_target_port"
#define VAR_SESSION_ID "session_id"

public void HttpResponseCallback(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method) {
    if (success) {
        char mimeType[128];
        response.GetHeader("Content-Type", mimeType, sizeof(mimeType));
        if(StrEqual(mimeType, "application/json", false)){
            char[] content = new char[response.ContentLength + 1];
            response.GetContent(content, response.ContentLength + 1);
            JSON_Object obj = json_decode(content)

            char action[256];
            obj.GetString("action", action, sizeof(action));

            if(StrEqual(action, "balance", false)){
                JSON_Array teamA = view_as<JSON_Array>(obj.GetObject("teamA"));
                JSON_Array teamB = view_as<JSON_Array>(obj.GetObject("teamB"));

                /* strmap for teamA */
                StringMap teamMapA = new StringMap();
                for (new i = 0; i < teamA.Length; i++) {
                    new teamId = teamA.GetObject(i).GetInt("team");
                    char playerId[SNAME_LEN];
                    teamA.GetObject(i).GetString("id", playerId, sizeof(playerId));
                    teamMapA.setValue(playerId, teamId);
                }

                /*strmap for teamB */
                StringMap teamMapB = new StringMap();
                for (new i = 0; i < teamB.Length; i++){
                    new teamId = teamB.GetObject(i).GetInt("team");
                    new playerId = teamB.GetObject(i).GetString("id");
                    teamMapB.setValue(playerId, teamId);
                }

                for(new i = 1; i <= MaxClients;i++){
                    new String:clientId[DEFAULT_LEN];

                    /* check client auth */
                    if(!GetClientAuthId(i, AuthId_SteamID64, clientId, DEFAULT_LEN, true)){
	                    continue;
	                }

                    /* change team when nessesary */
                    int mapTeamId;
                    if(teamMapAGetValue(clientId, &value)){
                        ChangeTeam(clientId, value);
                    }else if(teamMapAGetValue(clientId, &value)){
                        ChangeTeam(clientId, value);
                    }else{
                        ChangeTeam(clientId, 0);
                    }
                }
            }

            obj.Cleanup();
            delete obj;
        }
    }
}

public void SubmittViaHTTP(char[] jsonString, char[] type){

    new String:url[SNAME_LEN];
    # TODO type switch case
    Format(url, sizeof(url), "http://localhost:%d/single-event?session=%d", GetConVarInt(FindConVar(VAR_TARGET_PORT)), GetConVarInt(FindConVar(VAR_SESSION_ID)) );

    System2HTTPRequest httpRequest = new System2HTTPRequest(HttpResponseCallback, url);
    httpRequest.SetHeader("Content-Type", "application/json");
    httpRequest.SetData(jsonString);
    httpRequest.POST();
}

public void SubmittEventActiveClients(const char[] type){

    /* primary json */
    JSON_Object obj = new JSON_Object();
    obj.SetString("etype", "active_players");
    obj.SetInt("timestamp", GetTime());

    /* generate players */
    JSON_Array players = new JSON_Array();

    for(new i = 1; i <= MaxClients;i++){
        if(!IsClientConnected(i)){
            continue;
        }

        JSON_Object player = new JSON_Object();

        new String:clientId[DEFAULT_LEN];
        new String:clientName[SNAME_LEN];
        if(!GetClientAuthId(i, AuthId_SteamID64, clientId, DEFAULT_LEN, true)){
	        continue;
	    }
        GetClientName(i, clientName, SNAME_LEN);

        player.SetString("id", clientId);
        player.SetString("name", clientName);
        player.SetInt("team", GetClientTeam(i));
        players.PushObject(player);
    }

    /* add players array to primary object */
    obj.SetObject("players", players);
    obj.SetString("type", type);

    char output[2048];
    obj.Encode(output, sizeof(output));
    SubmittViaHTTP(output, type);

    obj.Cleanup();
    delete obj;
}

public void SubmittEventMapInformation(){
    new String:mapname[DEFAULT_LEN];
    GetCurrentMap(mapname, sizeof(mapname));

    JSON_Object obj = new JSON_Object();
    obj.SetString("etype", "map");
    obj.SetInt("timestamp", GetTime());
    obj.SetString("map", mapname);

    char output[2048];
    obj.Encode(output, sizeof(output));
    SubmittViaHTTP(output);
}

public void SubmittEventWinnerTeam(int team_id){

    JSON_Object obj = new JSON_Object();
    obj.SetString("etype", "winner");
    obj.SetInt("timestamp", GetTime());
    obj.SetInt("winnerTeam", team_id);

    char output[2048];
    obj.Encode(output, sizeof(output));
    SubmittViaHTTP(output);
}

public void SubmittEventRoundEnd(){
    JSON_Object obj = new JSON_Object();
    obj.SetString("etype", "round_end");
    obj.SetInt("timestamp", GetTime());

    char output[2048];
    obj.Encode(output, sizeof(output));
    SubmittEventActiveClients("round_end")
    SubmittViaHTTP(output);
}
