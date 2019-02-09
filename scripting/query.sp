/* no idea, but removes warnings */
#pragma tabsize 0

#include <sourcemod>
#include <sdktools>
#include <socket>

#define DEFAULT_LEN 64
#define TAG_LEN 64
#define INDEX_SEP ","
#define ACTIVE_CLIENTS_LENGTH 8192

#define NO_PREFIX ""

/* ---------------------- Globals ---------------------- */
static Handle:socket

/* ---------------------- Queries ---------------------- */
public QueryTeam(Handle:socketl, char[] steamid, bool rebuild){
    /* steamid may be used to only query a single player's new team */
    char strActiveClients[ACTIVE_CLIENTS_LENGTH];
    char request[ACTIVE_CLIENTS_LENGTH + DEFAULT_LEN*2];

    ActiveClients(NO_PREFIX, strActiveClients, ACTIVE_CLIENTS_LENGTH);
    if(rebuild){
        Format(request, sizeof(request), "rebuildteam,%s", strActiveClients);
    }else{
        Format(request, sizeof(request), "getteam,%s,%s", steamid, strActiveClients);
    }
    SocketSend(socket, request);
}

public QueryRating(client){
    if(client>0 && IsClientConnected(client)){
        /* get steamid first */ 
        char pid[DEFAULT_LEN];
        GetClientAuthId(client, AuthId_SteamID64, pid, DEFAULT_LEN, true);
        /* build the request and send */
        char request[2*DEFAULT_LEN];
        Format(request, sizeof(request), "player,%s", pid);
        SocketSend(socket, request);
    }
}

/* ---------------------- Receive ---------------------- */
public CaseSwitchReceive(Handle:socketl, String:receiveData[], const dataSize, any:arg) {
    char tag[TAG_LEN];
    
    //TODO why is receiveData and array of strings?!?!
    SplitString(receiveData, INDEX_SEP, tag, TAG_LEN);

    if(StrEqual(tag, "BALANCE_SINGLE")){
        RebuildTeams(INDEX_SEP,"|",receiveData);
    }else if(StrEqual(tag, "BALANCE_TEAMS")){
        RebuildTeams(INDEX_SEP,"|",receiveData);
    }else if(StrEqual(tag, "RATING_SINGLE")){
        char ratingInfo[DEFAULT_LEN];
        SplitString(receiveData, INDEX_SEP, ratingInfo, DEFAULT_LEN);
        PrintToChatAll("%s",receiveData);
    }
}

/* ---------------------- Socket ---------------------- */
public CreateQuerySocket(int port){
	    socket = SocketCreate(SOCKET_TCP, OnSocketError);
	    SocketConnect(socket, OnSocketConnected, CaseSwitchReceive, OnSocketDisconnected, "127.0.0.1", port);
}

public Action AttemptReconnectSocket(Handle:socketl){
    if(socket != INVALID_HANDLE){
        CloseHandle(socketl);
    }else{
        socket = SocketCreate(SOCKET_TCP,OnSocketError);
        if(socket != INVALID_HANDLE){
	          SocketConnect(socket, OnSocketConnected, CaseSwitchReceive, 
                            OnSocketDisconnected, "127.0.0.1", 7040);
        }
    }
    /* check if socket is connected  */
    if(SocketIsConnected(socketl)){
        return Plugin_Stop;
    }else{
        return Plugin_Continue;
    }
}

public Handle GetSocket(){
    return socket;
}

public OnSocketConnected(Handle:socketl,any:arg) {
}

public OnSocketDisconnected(Handle:socketl,any:arg) {
	CreateTimer(10.0,AttemptReconnectSocket,socketl,TIMER_REPEAT);
}

public OnSocketError(Handle:socketl, const errorType, const errorNum,any:arg) {
	LogError("socket error %d (errno %d)", errorType, errorNum);
	CloseHandle(socket);
}
