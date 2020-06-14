#include <sourcemod>
#include <sdktools>
#include <system2>

#define DEFAULT_LEN 64
#define SNAME_LEN   256

#define VAR_TARGET_PORT "skillbird_target_port"


public void PrintHttpResponse(bool success, const char[] error, System2HTTPRequest request, System2HTTPResponse response, HTTPRequestMethod method) {
    if (success) {
	if(response.StatusCode == 204 || response.StatusCode == 200){
            char[] content = new char[response.ContentLength + 1];
            response.GetContent(content, response.ContentLength + 1);
            PrintToChatAll("%s", content);
	}else if(response.StatusCode == 404){
            PrintToChatAll("skillbird:error:player_not_in_db");
	}else{
            PrintToChatAll("skillbird:error:scheduled_downtime:database_backup");
	}
    } else {
        PrintToChatAll("skillbird:error: backend unavailiable");
    }
 }

public void DisplayRating(int client){
    new String:url[SNAME_LEN];
    new String:clientId[DEFAULT_LEN];
    GetClientAuthId(client, AuthId_SteamID64, clientId, DEFAULT_LEN);
    Format(url, sizeof(url), "http://localhost:%d/get-player-rating-msg?id=%s", GetConVarInt(FindConVar(VAR_TARGET_PORT)), clientId);
    System2HTTPRequest httpRequest = new System2HTTPRequest(PrintHttpResponse, url);
    httpRequest.GET();
}

public Action Timer_ConnectMessage(Handle timer, int client){
    DisplayRating(client);
    return Plugin_Continue;
}

public Action CommandRating(int client, int args){
    DisplayRating(client);
    return Plugin_Continue;
}
