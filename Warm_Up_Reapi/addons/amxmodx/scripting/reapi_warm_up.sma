#include <amxmisc>
#include <reapi>

#define PLUGIN "[ReAPI] Warm UP"
#define VERSION "1.0.0.0-23.11.2025"
#define AUTHOR "Emma Jule"
#define URL "None"
#define DESCRIPTIONPLUGIN "Plugin for Warm Up"

enum (+=1)
{
	NULL = -1,
	VARIABLES,
	PLUGINS,
	WEAPS,
};

enum _:WARM_STRUCT
{
	GUNS[128],
	DESCRIPTION[64],
	Float:HEALTH,
	Float:PROTECTION_TIME,
	Float:RESPAWN_TIME,
	TIME,
	KEVLAR,
	FALL_DAMAGE,
	MUSIC[MAX_RESOURCE_PATH_LENGTH],
	TRACKTIME,
	TRACK[64],
};

enum _:CVARS
{
	RESTART,
	AUTO_AMMO,
	PAUSE_STATS,
};

new const g_eCvarsToDisable[][][] =
{
	{ "mp_maxmoney", "0" },
	{ "mp_freezetime", "0" },
	{ "mp_item_staytime", "0.0" },
	{ "mp_round_infinite", "1" },
	{ "mp_refill_bpammo_weapons", "3" },
	{ "mp_infinite_ammo", "2" },
	{ "mp_hostage_hurtable", "0" },
	{ "mp_give_player_c4", "0" },
	{ "mp_weapons_allow_map_placed", "0" },
	{ "mp_scoreboard_showmoney", "-1" },
	{ "mp_scoreboard_showhealth", "-1" },
	
	// Backwards
	{ "mp_free_armor", "0" },
	{ "mp_forcerespawn", "0" },
	{ "mp_respawn_immunitytime", "0.0" },
	{ "mp_infinite_grenades", "0" },
	{ "mp_t_give_player_knife", "0" },
	{ "mp_ct_give_player_knife", "0" },
	{ "mp_t_default_weapons_primary", "" },
	{ "mp_ct_default_weapons_primary", "" },
	{ "mp_t_default_weapons_secondary", "" },
	{ "mp_ct_default_weapons_secondary", "" },
	{ "mp_t_default_grenades", "" },
	{ "mp_ct_default_grenades", "" },
	{ "mp_falldamage", "0" },
};

new Array:g_aWarm, Array:g_aPlugins;
new HookChain:g_hCheckMapConditions, HookChain:g_hDropPlayerItem, HookChain:g_hOnSpawnEquip, HookChain:g_hKilled;

new g_pDefaultCvars[sizeof(g_eCvarsToDisable)][64], g_pCvar[CVARS];
new g_szWarmUpDescription[64], g_szWarmUpTrack[128], Float:g_flMaxHealth, g_iCountDown, g_iSection, g_iTrackTime;

public plugin_precache()
{
	
	g_aWarm = ArrayCreate(WARM_STRUCT, 0);
	g_aPlugins = ArrayCreate(32, 0);
	
	if (!ReadConfig())
		set_fail_state("Something went wrong");
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR, URL, DESCRIPTIONPLUGIN);
	
	register_event("TextMsg", "event_game_commencing", "a", "2=#Game_Commencing");
	
	DisableHookChain(g_hCheckMapConditions = RegisterHookChain(RG_CSGameRules_CheckMapConditions, "CSGameRules_CheckMapConditions", false));
	DisableHookChain(g_hDropPlayerItem = RegisterHookChain(RG_CBasePlayer_DropPlayerItem, "CBasePlayer_DropPlayerItem", false));
	DisableHookChain(g_hOnSpawnEquip = RegisterHookChain(RG_CBasePlayer_OnSpawnEquip, "CBasePlayer_OnSpawnEquip", true));
	
	if (g_pCvar[AUTO_AMMO]) {
		DisableHookChain(g_hKilled = RegisterHookChain(RG_CBasePlayer_Killed, "CBasePlayer_Killed", true));
	} else {
		#pragma unused g_hKilled
	}
}

public event_game_commencing()
{
	EnableHookChain(g_hCheckMapConditions);
	
	//
	for (new i = MaxClients; i > 0; --i)
		if (is_user_alive(i))
			set_member(i, m_bNotKilled, false);
}

public CSGameRules_CheckMapConditions()
{
	DisableHookChain(g_hCheckMapConditions);
	
	EnableHookChain(g_hDropPlayerItem);
	EnableHookChain(g_hOnSpawnEquip);
	if (g_pCvar[AUTO_AMMO])
		EnableHookChain(g_hKilled);
	
	for (new i, pCvar; i < sizeof(g_eCvarsToDisable); i++)
	{
		pCvar = get_cvar_pointer(g_eCvarsToDisable[i][0]);
		
		get_pcvar_string(pCvar, g_pDefaultCvars[i], charsmax(g_pDefaultCvars[]));
		set_pcvar_string(pCvar, g_eCvarsToDisable[i][1]);
	}
	
	//
	if (g_pCvar[PAUSE_STATS])
	{
		set_cvar_num("csstats_pause", 1);
		set_cvar_num("aes_track_pause", 1);
	}
	
	new aWarm[WARM_STRUCT];
	ArrayGetArray(g_aWarm, random(ArraySize(g_aWarm)), aWarm);
	
	// 
	set_cvar_num("mp_free_armor", aWarm[KEVLAR]);
	set_cvar_num("mp_falldamage", aWarm[FALL_DAMAGE]);
	
	set_cvar_float("mp_forcerespawn", aWarm[RESPAWN_TIME]);
	set_cvar_float("mp_respawn_immunitytime", aWarm[PROTECTION_TIME]);
	
	g_flMaxHealth = aWarm[HEALTH];
	g_iCountDown = aWarm[TIME];
	g_iTrackTime = aWarm[TRACKTIME];
	if (g_iTrackTime > g_iCountDown) g_iTrackTime = g_iCountDown;
	
	copy(g_szWarmUpDescription, charsmax(g_szWarmUpDescription), aWarm[DESCRIPTION]);
	copy(g_szWarmUpTrack, charsmax(g_szWarmUpTrack), aWarm[TRACK]);
	
	// 
	FillWeapons(aWarm[GUNS]);
	
	//
	set_task(1.0, "Show_Timer", .flags = "b");
	
	// 
	for (new i; i < ArraySize(g_aPlugins); i++)
		pause("ac", fmt("%a", ArrayGetStringHandle(g_aPlugins, i)));
	
	//
	if (aWarm[MUSIC][0]) {
		client_cmd(0, "stopsound; mp3 stop; wait; mp3 play ^"sound/%s^"", aWarm[MUSIC]);
	}
}

public CBasePlayer_DropPlayerItem()
{
	SetHookChainReturn(ATYPE_INTEGER, NULLENT);
	return HC_SUPERCEDE;
}

public CBasePlayer_OnSpawnEquip(id)
{
	set_entvar(id, var_health, g_flMaxHealth);
	set_entvar(id, var_max_health, g_flMaxHealth);
}

public CBasePlayer_Killed(id, attacker, gib)
{
	if (id == attacker || !is_user_connected(attacker))
		return;
	
	if (get_member(id, m_bKilledByGrenade))
		return;
	
	//
	new pWeapon = get_member(attacker, m_pActiveItem);
	if (is_nullent(pWeapon) || ~CSW_ALL_GUNS & 1 << get_member(pWeapon, m_iId))
		return;
	
	rg_instant_reload_weapons(attacker, pWeapon);
}

public Show_Timer()
{
	if (--g_iCountDown == 0)
	{
		remove_task();
		
		DisableHookChain(g_hDropPlayerItem);
		DisableHookChain(g_hOnSpawnEquip);
		
		if (g_pCvar[AUTO_AMMO])
			DisableHookChain(g_hKilled);
		
		//
		for (new i; i < sizeof(g_eCvarsToDisable); i++) {
			set_pcvar_string(get_cvar_pointer(g_eCvarsToDisable[i][0]), g_pDefaultCvars[i]);
		}
		
		if (g_pCvar[PAUSE_STATS])
		{
			set_cvar_num("csstats_pause", 0);
			set_cvar_num("aes_track_pause", 0);
		}
		
		set_cvar_num("sv_restart", 1);
		if (g_pCvar[RESTART] > 1)
			set_task(1.5, "@restart", .flags = "a", .repeat = g_pCvar[RESTART] - 1);
		
		// 
		for (new i; i < ArraySize(g_aPlugins); i++)
		unpause("ac", fmt("%a", ArrayGetStringHandle(g_aPlugins, i)));
	}
	else
	{
		set_dhudmessage( .red = 255, .green = 0, .blue = 0, .x = -1.0, .y = 0.01, .effects = 0, .fxtime = 0.0, .holdtime = 1.1, .fadeintime = 0.0, .fadeouttime = 0.0);
		show_dhudmessage(0, "%s", g_szWarmUpDescription);
		if(--g_iTrackTime <= 0){
			set_dhudmessage( .red = 0, .green = 255, .blue = 0, .x = -1.0, .y = 0.04, .effects = 0, .fxtime = 0.0, .holdtime = 1.0, .fadeintime = 0.0, .fadeouttime = 0.1);
			show_dhudmessage(0, "РЕСТАРТ ЧЕРЕЗ %i СЕК", g_iCountDown);
		}else{
			set_dhudmessage( .red = 255, .green = 255, .blue = 255, .x = -1.0, .y = 0.04, .effects = 0, .fxtime = 0.0, .holdtime = 1.1, .fadeintime = 0.0, .fadeouttime = 0.0);
			show_dhudmessage(0, "СЕЙЧАС ИГРАЕТ: %s", g_szWarmUpTrack);
			set_dhudmessage( .red = 0, .green = 255, .blue = 0, .x = -1.0, .y = 0.07, .effects = 0, .fxtime = 0.0, .holdtime = 1.0, .fadeintime = 0.0, .fadeouttime = 0.1);
			show_dhudmessage(0, "РЕСТАРТ ЧЕРЕЗ %i СЕК", g_iCountDown);
		}
	}
}

@restart() {
	client_cmd(0, "stopsound; mp3 stop");
	set_cvar_num("sv_restart", 1);
}

stock FillWeapons(szGun[])
{
	new Trie:tPrimaryWeapon = TrieCreate(),
		Trie:tSecondaryWeapon = TrieCreate(),
		Trie:tGrenade = TrieCreate(),
		Trie:tKnife = TrieCreate();
	
	new szPrimaryWeapon[128],
		szSecondaryWeapon[128],
		szGrenade[64],
		szWeapon[11];
	
	new bool:bKnife = false;
	new value;
	
	// Primary
	TrieSetCell(tPrimaryWeapon, "m3", value);
	TrieSetCell(tPrimaryWeapon, "xm1014", value);
	TrieSetCell(tPrimaryWeapon, "tmp", value);
	TrieSetCell(tPrimaryWeapon, "mac10", value);
	TrieSetCell(tPrimaryWeapon, "ump45", value);
	TrieSetCell(tPrimaryWeapon, "mp5navy", value);
	TrieSetCell(tPrimaryWeapon, "p90", value);
	TrieSetCell(tPrimaryWeapon, "galil", value);
	TrieSetCell(tPrimaryWeapon, "famas", value);
	TrieSetCell(tPrimaryWeapon, "ak47", value);
	TrieSetCell(tPrimaryWeapon, "m4a1", value);
	TrieSetCell(tPrimaryWeapon, "sg552", value);
	TrieSetCell(tPrimaryWeapon, "aug", value);
	TrieSetCell(tPrimaryWeapon, "sg550", value);
	TrieSetCell(tPrimaryWeapon, "g3sg1", value);
	TrieSetCell(tPrimaryWeapon, "awp", value);
	TrieSetCell(tPrimaryWeapon, "m249", value);
	
	// Secondary
	TrieSetCell(tSecondaryWeapon, "glock18", value);
	TrieSetCell(tSecondaryWeapon, "usp", value);
	TrieSetCell(tSecondaryWeapon, "p228", value);
	TrieSetCell(tSecondaryWeapon, "deagle", value);
	TrieSetCell(tSecondaryWeapon, "fiveseven", value);
	TrieSetCell(tSecondaryWeapon, "elite", value);
	
	// Nades
	TrieSetCell(tGrenade, "hegrenade", value);
	TrieSetCell(tGrenade, "grenade", value);
	TrieSetCell(tGrenade, "flash", value);
	TrieSetCell(tGrenade, "sgren", value);
	
	// Knife
	TrieSetCell(tKnife, "knife", value);
	
	while (argbreak(szGun, szWeapon, charsmax(szWeapon), szGun, strlen(szGun) - 1) != -1)
	{
		if (TrieGetCell(tKnife, szWeapon, value))
			bKnife = true;
		
		if (TrieGetCell(tPrimaryWeapon, szWeapon, value))
			strcat(szPrimaryWeapon, fmt("%s ", szWeapon), charsmax(szPrimaryWeapon));
		if (TrieGetCell(tSecondaryWeapon, szWeapon, value))
			strcat(szSecondaryWeapon, fmt("%s ", szWeapon), charsmax(szSecondaryWeapon));
		if (TrieGetCell(tGrenade, szWeapon, value))
			strcat(szGrenade, fmt("%s ", szWeapon), charsmax(szGrenade));
	}
	
	if (szPrimaryWeapon[0] != '^0')
	{
		set_cvar_string("mp_t_default_weapons_primary", szPrimaryWeapon);
		set_cvar_string("mp_ct_default_weapons_primary", szPrimaryWeapon);
	}
	
	if (szSecondaryWeapon[0] != '^0')
	{
		set_cvar_string("mp_t_default_weapons_secondary", szSecondaryWeapon);
		set_cvar_string("mp_ct_default_weapons_secondary", szSecondaryWeapon);
	}
	
	if (szGrenade[0] != '^0')
	{
		set_cvar_string("mp_t_default_grenades", szGrenade);
		set_cvar_string("mp_ct_default_grenades", szGrenade);
		
		if (szPrimaryWeapon[0] == '^0' && szSecondaryWeapon[0] == '^0')
			set_cvar_num("mp_infinite_grenades", 1);
		
		// 
		if (containi(szGrenade, "grenade") == -1)
			bKnife = true;
	}
	
	if (bKnife)
	{
		set_cvar_num("mp_t_give_player_knife", 1);
		set_cvar_num("mp_ct_give_player_knife", 1);
	}
	
	TrieDestroy(tPrimaryWeapon);
	TrieDestroy(tSecondaryWeapon);
	TrieDestroy(tGrenade);
	TrieDestroy(tKnife);
}

ReadConfig()
{
	new szPath[PLATFORM_MAX_PATH];
	get_configsdir(szPath, charsmax(szPath));
	strcat(szPath, "/plugins/warm_up.ini", charsmax(szPath));
	
	if (!file_exists(szPath))
		return false;
	
	new INIParser:parser = INI_CreateParser();

	if (parser == Invalid_INIParser)
		return false;
	
	INI_SetReaders(parser, "values", "sections");
	INI_ParseFile(parser, szPath);
	INI_DestroyParser(parser);
	
	return true;
}

public bool:sections(INIParser:handle, const section[], bool:invalid_tokens, bool:close_bracket)
{
	if (!close_bracket)
		return false;
	
	if (equal(section, "VARIABLES"))
	{
		g_iSection = VARIABLES;
		return true;
	}
	
	if (equal(section, "PLUGINS"))
	{
		g_iSection = PLUGINS;
		return true;
	}
	
	if (equal(section, "WEAPS"))
	{
		g_iSection = WEAPS;
		return true;
	}
	
	return false;
}

public bool:values(INIParser:handle, const key[], const value[])
{
	switch (g_iSection)
	{
		case NULL:
			return false;
        
		case VARIABLES:
		{
			if (equal(key, "RESTART"))
				g_pCvar[RESTART] = str_to_num(value);
			if (equal(key, "AUTO_AMMO"))
				g_pCvar[AUTO_AMMO] = str_to_num(value);
			if (equal(key, "PAUSE_STATS"))
				g_pCvar[PAUSE_STATS] = str_to_num(value);
		}
		
		case PLUGINS:
			ArrayPushString(g_aPlugins, fmt("%s.amxx", key));
		
		case WEAPS:
		{
			new aData[11][256], aWarm[WARM_STRUCT];
			if (explode_string(key, " | ", aData, sizeof(aData), charsmax(aData[])) == 11)
			{
				copy(aWarm[GUNS], charsmax(aWarm[GUNS]), aData[0]);
				copy(aWarm[DESCRIPTION], charsmax(aWarm[DESCRIPTION]), aData[1]);
				aWarm[HEALTH] = floatmax(1.0, str_to_float(aData[2]));
				aWarm[PROTECTION_TIME] = str_to_float(aData[3]);
				aWarm[RESPAWN_TIME] = floatmax(0.1, str_to_float(aData[4]));
				aWarm[TIME] = str_to_num(aData[5]);
				aWarm[KEVLAR] = str_to_num(aData[6]);
				aWarm[FALL_DAMAGE] = str_to_num(aData[7]);
				copy(aWarm[MUSIC], charsmax(aWarm[MUSIC]), aData[8]);
				aWarm[TRACKTIME] = str_to_num(aData[9]);
				copy(aWarm[TRACK], charsmax(aWarm[TRACK]), aData[10]);
				
				
				
				if (file_exists(fmt("sound/%s", aWarm[MUSIC])) /* && containi(aWarm[MUSIC], ".mp3") != -1 no care */ )
				{
					precache_generic(fmt("sound/%s", aWarm[MUSIC]));
				} else {
					aWarm[MUSIC] = '^0';
				}
				ArrayPushArray(g_aWarm, aWarm);
			}
		}
	}
	
	return true;
}
		
		

