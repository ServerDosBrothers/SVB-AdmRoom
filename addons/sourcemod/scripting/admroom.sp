#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

bool g_bLateLoaded = false;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int length)
{
	g_bLateLoaded = late;
	return APLRes_Success;
}

bool IsPlayer(int entity)
{
	return (entity >= 1 && entity <= MaxClients);
}

void StartTouch(int entity, int other)
{
	if(IsPlayer(other)) {
		if(!(GetUserFlagBits(other) & (ADMFLAG_GENERIC))) {
			ForcePlayerSuicide(other);
		}
	}
}

void TriggerCreated(int entity)
{
	char name[32];
	GetEntPropString(entity, Prop_Send, "m_iName", name, sizeof(name));

	if(StrEqual(name, "trigger_admroom")) {
		SDKHook(entity, SDKHook_StartTouch, StartTouch);
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname, "trigger_multiple")) {
		TriggerCreated(entity);
	}
}

public void OnMapStart()
{
	if(g_bLateLoaded) {
		int ent = FindEntityByClassname(-1, "trigger_multiple");
		if(ent != -1) {
			TriggerCreated(ent);
		}
	}
}