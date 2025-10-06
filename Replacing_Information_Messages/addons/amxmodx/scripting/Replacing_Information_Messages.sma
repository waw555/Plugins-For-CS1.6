#include <amxmodx>
#define PLUGIN "Replacing Information Messages"
#define VERSION "1.0.0.0"
#define AUTHOR "MS"
#define URL "www.masks-show.ru"
#define DESCRIPTION "The plugin replaces information messages"

#pragma semicolon 1

new Trie:g_tReplaceInfoMsg;

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR, URL, DESCRIPTION);
	
	g_tReplaceInfoMsg = TrieCreate();
	Fill_trie();
	
	register_message(get_user_msgid("SayText"), "MessageSayText");
	register_message(get_user_msgid("TextMsg"), "MessageTextMsg");
}

public Fill_trie() {
	//	A
	TrieSetString(g_tReplaceInfoMsg, "#Accept_All_Messages",				"Теперь принимаются все текстовые сообщения");
	TrieSetString(g_tReplaceInfoMsg, "#Accept_Radio",						"Теперь принимаются все радио сообщения");
	TrieSetString(g_tReplaceInfoMsg, "#Affirmative",						"Подтверждаю");
	TrieSetString(g_tReplaceInfoMsg, "#Alias_Not_Avail",					"%s не доступен для покупки Вашей командой!");
	TrieSetString(g_tReplaceInfoMsg, "#All_Hostages_Rescued",				"Все заложники спасены");
	TrieSetString(g_tReplaceInfoMsg, "#Already_Have_Kevlar",				"У вас уже имеется бронежилет");
	TrieSetString(g_tReplaceInfoMsg, "#Already_Have_Kevlar_Helmet",			"У вас уже имеется бронежилет и шлем");
	TrieSetString(g_tReplaceInfoMsg, "#Already_Own_Weapon",					"У вас уже имеется данное оружие");
	TrieSetString(g_tReplaceInfoMsg, "#Auto_Team_Balance_Next_Round",		"Автоматический баланс команды наступит в следующем раунде");
	//	B
	TrieSetString(g_tReplaceInfoMsg, "#Bomb_Defused",						"Бомба обезврежена");
	TrieSetString(g_tReplaceInfoMsg, "#Bomb_Planted",						"Бомба установлена");
	//	C
	TrieSetString(g_tReplaceInfoMsg, "#C4_Arming_Cancelled",				"Бомба может быть установлена только в зоне установки бомбы");
	TrieSetString(g_tReplaceInfoMsg, "#C4_Defuse_Must_Be_On_Ground",		"Вы должны быть на земле, чтобы обезвредить бомбу!");
	TrieSetString(g_tReplaceInfoMsg, "#C4_Plant_At_Bomb_Spot",				"Бомба может быть установлена только в зоне установки бомбы");
	TrieSetString(g_tReplaceInfoMsg, "#C4_Plant_Must_Be_On_Ground",			"Для установки бобмы Вы должны находиться на земле");
	TrieSetString(g_tReplaceInfoMsg, "#Cannot_Carry_Anymore",				"Вы не можете взять больше");
	TrieSetString(g_tReplaceInfoMsg, "#Cant_buy",							"%s секунд уже истекли.^rПокупка запрещена");
	TrieSetString(g_tReplaceInfoMsg, "#Command_Not_Available",				"Данное действие недоступно в Вашем местонахождении");
	TrieSetString(g_tReplaceInfoMsg, "#CTs_Win",							"Контр-Террористы победили");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_TitlesTXT_Enemy",			"Противник!");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_TitlesTXT_Game_timelimit",	"Оставшееся время:  %s:%s");
	//	D
	TrieSetString(g_tReplaceInfoMsg, "#Defusing_Bomb_With_Defuse_Kit",		"Обезвреживание бомбы с набором сапёра");
	TrieSetString(g_tReplaceInfoMsg, "#Defusing_Bomb_Without_Defuse_Kit",	"Обезвреживание бомбы без набора сапёра");
	//	G
	TrieSetString(g_tReplaceInfoMsg, "#Game_bomb_drop",						"%s выбросил бомбу");
	TrieSetString(g_tReplaceInfoMsg, "#Game_bomb_pickup",					"%s подобрал бомбу");
	TrieSetString(g_tReplaceInfoMsg, "#Game_Commencing",					"Игра началась");
	TrieSetString(g_tReplaceInfoMsg, "#Game_will_restart_in",				"Рестарт игры произойдет через %s секунд");
	TrieSetString(g_tReplaceInfoMsg, "#Got_bomb",							"Вы подобрали бомбу");
	TrieSetString(g_tReplaceInfoMsg, "#Got_defuser",						"Вы подобрали комплект разминирования!");
	TrieSetString(g_tReplaceInfoMsg, "#Go_go_go",							"ВПЕРЕД ВПЕРЕД ВПЕРЕД!");
	//	H
	TrieSetString(g_tReplaceInfoMsg, "#Hostages_Not_Rescued",				"Не удалось спасти заложников");
	TrieSetString(g_tReplaceInfoMsg, "#Hostages_Rescued",					"Все заложники спасены!");
	//	N
	TrieSetString(g_tReplaceInfoMsg, "#Name_change_at_respawn",				"Ваше имя будет изменено после следующего возрождения");
	TrieSetString(g_tReplaceInfoMsg, "#Not_Enough_Money",					"У вас недостаточно денег!");
	//	O
	TrieSetString(g_tReplaceInfoMsg, "#Only_1_Team_Change",					"Только 1 раз можно сменить команду");
	TrieSetString(g_tReplaceInfoMsg, "#Only_CT_Can_Move_Hostages",			"Только Контр-Террористы могут перемещать заложников!");
	// 	R
	TrieSetString(g_tReplaceInfoMsg, "#Round_Draw",							"Раунд закончился вничью");
	//	S
	TrieSetString(g_tReplaceInfoMsg, "#Selection_Not_Available",			"Выбор недоступен.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Auto",							"Автоматически");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_NoPlayers",						"Нет игроков в режиме Наблюдателя.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Not_In_Spectator_Mode",			"** Вы не находитесь в режиме Наблюдателя.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Not_Valid_Choice",				"** Вам запрещено наблюдать за этим игроком.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Duck",							"Нажмите ПРИГНУТЬСЯ для входа в меню наблюдения!");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Help_Text",						"Используйте следующие клавиши для изменения стилей просмотра: ^r^rFIRE1 — преследование следующего игрока^rFIRE2 — преследование предыдущего игрока^rJUMP — смена режима просмотра^rUSE — смена режима окна^r^rDUCK — включение меню наблюдателя^r^rВ режиме обзора карты для перемещения используются следующие клавиши:^r^rMOVELEFT — движение влево^rMOVERIGHT — движение вправо^rFORWARD — увеличение масштаба^rBACK — уменьшение масштаба^rMOUSE — вращение вокруг карты/цели");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Help_Title",					"Режим наблюдателя");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_ListPlayers",					"Список игроков.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Map",							"Обзор карты");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode1",							"Фиксированная камера за спиной");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode2",							"Свободная камера за спиной");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode3",							"Свободный обзор");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode4",							"Режим от первого лица");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode5",							"Свободный обзор карты");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Mode6",							"Фиксированный обзор карты");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_No_PIP",						"Режим картинка в картинке во время игры^rот первого лица недоступен.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_NoTarget",						"Нет подходящих целей. Невозможно переключиться в режим динамичной камеры.");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Replay",						"Повтор");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Slow_Motion",					"Замедленные кадры");
	TrieSetString(g_tReplaceInfoMsg, "#Spec_Time",							"Время");
	TrieSetString(g_tReplaceInfoMsg, "#Spectators",							"Наблюдатели");
	TrieSetString(g_tReplaceInfoMsg, "#Switch_To_BurstFire",				"Переключен в режим пулеметного огня");
	TrieSetString(g_tReplaceInfoMsg, "#Switch_To_FullAuto",					"Переключен в автоматический режим");
	TrieSetString(g_tReplaceInfoMsg, "#Switch_To_SemiAuto",					"Переключен в полуавтоматический режим");
	//	T
	TrieSetString(g_tReplaceInfoMsg, "#Target_Bombed",						"Цель уничтожена");
	TrieSetString(g_tReplaceInfoMsg, "#Target_Saved",						"Цель спасена");
	TrieSetString(g_tReplaceInfoMsg, "#Terrorists_Win",						"Террористы победили");
	//	U
	TrieSetString(g_tReplaceInfoMsg, "#Unassigned",							"Неназначено");
	//	V
	TrieSetString(g_tReplaceInfoMsg, "#VIP_Escaped",						"VIP-игрок спасен");
	TrieSetString(g_tReplaceInfoMsg, "#VIP_Assassinated",					"VIP-игрок убит");
	//	W
	TrieSetString(g_tReplaceInfoMsg, "#Weapon_Cannot_Be_Dropped",			"Нельзя выбросить данное оружие");
	TrieSetString(g_tReplaceInfoMsg, "#Weapon_Not_Available",				"Это оружие вам недоступно!");
	
	////// cstrike_english.txt line 655 - Titles.txt strings
	TrieSetString(g_tReplaceInfoMsg, "#CAM_OPTIONS",								"Параметры камеры");
	TrieSetString(g_tReplaceInfoMsg, "#SPECT_OPTIONS",								"Параметры");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_MAP_CHASE",								"Фиксированный обзор карты");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_MAP_FREE",								"Режим свободной камеры");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_IN_EYE",									"Режим от первого лица");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_ROAMING",								"Свободный обзор");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_CHASE_FREE",								"Режим свободной камеры");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_CHASE_LOCKED",							"Режим фиксированной камеры");
	TrieSetString(g_tReplaceInfoMsg, "#OBS_NONE",									"Настройки камеры");
	TrieSetString(g_tReplaceInfoMsg, "#No_longer_hear_that_player",					"Вы больше не услышите этого игрока.");
	TrieSetString(g_tReplaceInfoMsg, "#Unmuted",									"Вы включили звук %s.");
	TrieSetString(g_tReplaceInfoMsg, "#Muted",										"Вы отключили звук %s.");
	TrieSetString(g_tReplaceInfoMsg, "#Map_Description_not_available",				"Описание карты недоступно.");
	
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_DEAD",								"Мертв");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_BOMB",								"Бомба");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_DEFUSE_KIT",							"Дефузер");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_HEALTH",								"Жизни");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_ACCOUNT",							"Деньги");
	TrieSetString(g_tReplaceInfoMsg, "#PlayerAccount",								"Деньги");
	TrieSetString(g_tReplaceInfoMsg, "#PlayerMoney",								"Деньги");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_TitlesTXT_Friend",								"Друг");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_TitlesTXT_Enemy",								"Враг");
	TrieSetString(g_tReplaceInfoMsg, "#Cstrike_TitlesTXT_Health",								"Здоровье");
	TrieSetString(g_tReplaceInfoMsg, "#Friend",								"Друг");
	TrieSetString(g_tReplaceInfoMsg, "#Enemy",								"Враг");
	TrieSetString(g_tReplaceInfoMsg, "#Health",								"Здоровье");
	
	
	
	
	
	
	
	

	
	// Радио
	
	
}

public MessageSayText() {
	new szMsg[21];
	get_msg_arg_string(2, szMsg, charsmax(szMsg));
	if(equal(szMsg, "#Cstrike_Name_Change")) {
		new szNewName[32], szOldName[32], szNewMessage[512];
		get_msg_arg_string(3, szOldName, charsmax(szOldName));
		get_msg_arg_string(4, szNewName, charsmax(szNewName));
		formatex(szNewMessage, charsmax(szNewMessage), "^1Игрок ^3%s ^1изменил имя на ^3%s", szOldName, szNewName);
		set_msg_arg_string(2, szNewMessage);
	}
}

public MessageTextMsg() {
	new szMsg[512], szArg3[32];
	get_msg_arg_string(2, szMsg, charsmax(szMsg));
	if(TrieGetString(g_tReplaceInfoMsg, szMsg, szMsg, charsmax(szMsg))) {
		if(get_msg_args() > 2) {
			get_msg_arg_string(3, szArg3, charsmax(szArg3));
			replace(szMsg, charsmax(szMsg), "%s", szArg3);
		}
		set_msg_arg_string(2, szMsg);
	}
}

public plugin_end() {
	TrieDestroy(g_tReplaceInfoMsg);
}