#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

bool IsPlayer(int entity)
{
	return (entity >= 1 && entity <= MaxClients);
}

void StartTouch(int entity, int other)
{
	if(IsPlayer(other)) {
		ForcePlayerSuicide(other);
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname, "trigger_multiple")) {
		char name[32];
		GetEntPropString(entity, Prop_Send, "m_iName", name, sizeof(name));

		if(StrEqual(name, "trigger_admroom")) {
			SDKHook(entity, SDKHook_StartTouch, StartTouch);
		}
	}
}

public void OnMapStart()
{
	int ent = FindEntityByClassname(-1, "trigger_multiple");
	if(ent != -1) {
		OnEntityCreated(ent, "trigger_multiple");
	}
}