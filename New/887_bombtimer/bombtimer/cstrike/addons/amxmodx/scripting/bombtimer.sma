#include <amxmodx>
#include <engine>

#define MAX_SPRITES	2

#define PLUGIN	"C4 Timer"
#define VERSION	"0.1"
#define AUTHOR 	"Lightman"

new const g_timersprite[MAX_SPRITES][] = { "bombticking", "bombticking1"}

new g_c4timer

new g_msg_showtimer
new g_msg_roundtime
new g_msg_scenario

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_logevent("Logevent_Planted", 3, "2=Planted_The_Bomb");
	
	g_msg_showtimer	= get_user_msgid("ShowTimer");
	g_msg_roundtime	= get_user_msgid("RoundTime");
	g_msg_scenario	= get_user_msgid("Scenario");
	
	g_c4timer = get_pcvar_num(get_cvar_pointer("mp_c4timer"));
	
	if(find_ent_by_class(-1, "func_bomb_target") || find_ent_by_class(-1, "info_bomb_target")) 
	{return;} else {pause("ad");}
}

public Logevent_Planted()
{
	new iPlayers[32], iNum, i;
	get_players(iPlayers, iNum, "ach");
	for(i=0; i < iNum; i++)
	{
		Bomb_Informer(iPlayers[i]);
	}
}
	
stock Bomb_Informer(id)
{
	message_begin(MSG_ONE_UNRELIABLE, g_msg_showtimer, _, id);
	message_end();
	
	message_begin(MSG_ONE_UNRELIABLE, g_msg_roundtime, _, id);
	write_short(g_c4timer);
	message_end();
	
	message_begin(MSG_ONE_UNRELIABLE, g_msg_scenario, _, id);
	write_byte(1);
	write_string(g_timersprite[MAX_SPRITES - 1]);
	write_byte(150);
	write_short(20);
	message_end();
}