#include <amxmodx>
#include <amxmisc>
#include <cstrike>

#define PLUGIN "Masks-Show Models"
#define VERSION "1.0.0.0-28.09.2025"
#define AUTHOR "WAW555"
#define URL "www.masks-show.ru"
#define DESCRIPTION "Plugin for set player model"

#pragma semicolon 1

#define MAX_PARSE_TEXT 1024	//	Максимальное количество символов в файле для парсинга
#define MAX_MODEL_COUNT 128	//	Максимальное количетсво загружаемых моделей
#define MAX_MODEL_NAME 256	//	Максимальное количество символов в названии модели
#define MAX_MODEL_FILE 256	//	Максимальное количество символов в названии файла модели
#define MAX_MODEL_TEAM 5	//	Максимальное количество символов в названии команды (Пример: CT, T, ANY)
#define MAX_MODEL_ACCESS 32	//	Максимальное количество символов в правах доступа к модели (Пример: abcd или ghtuvz или a)
#define MAX_MODEL_PATH 256	//	Максимальная длина пути к файлу модели
#define MAX_PLAYER 32		//	Максимальное количество игроков

#pragma semicolon 1

new const SETTINGS_FILE[] = "ms_models.ini";				//	Файл со списком моделей

new g_iLoadModelCount;										//	Количество загруженных моделей
new g_aModelName[MAX_MODEL_COUNT][MAX_MODEL_NAME];			//	Название модели для меню
new g_aModelFile[MAX_MODEL_COUNT][MAX_MODEL_FILE];			//	Имя файла модели без расширения
new g_aModelTeam[MAX_MODEL_COUNT][MAX_MODEL_TEAM];			//	Команда для которой доступна модель: CT или T или ANY
new g_aModelAccess[MAX_MODEL_COUNT][MAX_MODEL_ACCESS];		//	Уровень доступа к модели (Флаги)
new g_aModelPath[MAX_MODEL_COUNT][MAX_MODEL_PATH];			//	Полный путь к модели /models/player/название папки как название файла/файл модели с расширением .mdl
new g_sCurrentModelName[MAX_PLAYER][MAX_MODEL_NAME];		//	Название текущей модели игрока
new g_sCurrentModelFile[MAX_PLAYER][MAX_MODEL_FILE];		//	Имя файла текущей модели игрока
new g_i_MessageIDSayText; 									// 	Функция цветного чата

// ------------------------------------------------------------------------------------------
// --ИНИЦИАЛИЗАЦИЯ ПЛАГИНА-------------------------------------------------------------------
// ------------------------------------------------------------------------------------------
public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR, URL, DESCRIPTION);
	
	register_dictionary("ms_models.txt");
	
	register_clcmd ( "say /model" , "Create_Model_Menu" , ADMIN_ALL , "- Показать меню моделей" );
	register_clcmd ( "say /models" , "Create_Model_Menu" , ADMIN_ALL , "- Показать меню моделей" );
	register_clcmd ( "say_team /model" , "Create_Model_Menu" , ADMIN_ALL , "- Показать меню моделей" );
	register_clcmd ( "say_team /models" , "Create_Model_Menu" , ADMIN_ALL , "- Показать меню моделей" );
	register_concmd ("ms_models", "Create_Model_Menu", ADMIN_ALL);
	
	//РЕГИСТРАЦИЯ СОБЫТИЙ   
	register_event("TextMsg", "player_change_team", "a", "1=1", "2&Game_join_terrorist", "2&Game_join_ct", "2&Game_join_terrorist_auto", "2&Game_join_ct_auto"); //Регистрируем событие Смена Команды
	register_clcmd("joinclass", "player_chose_class");	// Игрок выбрал персонажа и вошел в игру
	
	
	g_i_MessageIDSayText = get_user_msgid("SayText");								//	Функция цветного чата
}

// ------------------------------------------------------------------------------------------
// --ЗАГРУЗКА МОДЕЛЕЙ------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------
public plugin_precache()
{

    // Загрузка моделей
	
	new sConfigsDir[MAX_MODEL_PATH];
	get_localinfo("amxx_configsdir", sConfigsDir, charsmax(sConfigsDir));
	get_configsdir(sConfigsDir, charsmax(sConfigsDir));
	
	format(sConfigsDir, MAX_MODEL_PATH-1, "%s/%s", sConfigsDir, SETTINGS_FILE);
	if(file_exists(sConfigsDir))	//	Если файл с настройками существует
	{
		log_amx("Загружен файл с моделями = %s", sConfigsDir);
		loadSettings(sConfigsDir);					// Загрузка списка моделей
	}
	else
	{
		log_amx("Не найден файл с моделями - %s", sConfigsDir);
	}
	
	
	for(new i=0;i<g_iLoadModelCount;i++) {
		new s_ModelNameWithT[MAX_MODEL_PATH];	//	Переменная для хранения пути к дополнительной файлу модели.
		new sModelFileName[MAX_MODEL_FILE];
		copyc(sModelFileName,MAX_MODEL_FILE-1,g_aModelFile[i],'.');
		format(s_ModelNameWithT,MAX_MODEL_PATH-1,"models/player/%s/%sT.mdl",sModelFileName,sModelFileName);	//	Добавляем к имени файла букву Т
		
		if(file_exists(s_ModelNameWithT))	//	Если файл с буквой Т существует, то загружаем его
		{
			log_amx("Обнаружен дополнительный файл модели %s. Файл будет загружен.", s_ModelNameWithT);
			precache_model(s_ModelNameWithT);
		}
		
		log_amx("Загружается файл %s.", g_aModelPath[i]);
		precache_model(g_aModelPath[i]);
	}
	
	//precache_sound("events/friend_died.wav");
	//precache_sound("events/tutor_msg.wav");
}

// ------------------------------------------------------------------------------------------
// --ЗАГРУЗКА ФАЙЛА С МОДЕЛЯМИ---------------------------------------------------------------
// ------------------------------------------------------------------------------------------
loadSettings(szFilename[])
{
	new File=fopen(szFilename,"r");	//Открываем файл для чтения
	
	if (File)
	{
		new sParseText[MAX_PARSE_TEXT];		//	Строка для парсинга
		new sModelName[MAX_MODEL_NAME];		//	Название модели
		new sModelFile[MAX_MODEL_FILE];		//	Файл модели
		new sModelTeam[MAX_MODEL_TEAM];		//	Команда модели
		new sModelAccess[MAX_MODEL_ACCESS];	//	Уровень доступа к модели

		while (fgets(File, sParseText, charsmax(sParseText)))
		{
			trim(sParseText);
			
			// Пустые строки и строки с комментариями
			if (sParseText[0]== ' ' || sParseText[0]==';' || sParseText[0] == '/' || sParseText[0] == '#' || ( sParseText[0] == '/' && sParseText[1] == '/')) 
			{
				continue;
			}
			
			sModelName[0]=0;
			sModelFile[0]=0;
			sModelTeam[0]=0;
			sModelAccess[0]=0;
			
			// Парсим текст
			if (parse(sParseText,sModelName,charsmax(sModelName),sModelFile,charsmax(sModelFile),sModelTeam,charsmax(sModelTeam),sModelAccess,charsmax(sModelAccess))<2)
			{
				continue;
			}
			
			new sModelPath[MAX_MODEL_PATH];																	//	Полный путь к файлу модели
			new sModelFileName[MAX_MODEL_FILE];																//	Имя файла модели без расширения
			copyc(sModelFileName,MAX_MODEL_FILE-1,sModelFile,'.');											//	Убираем расширение файла
			format(sModelPath,MAX_MODEL_PATH-1,"models/player/%s/%s.mdl",sModelFileName,sModelFileName);	//	Создаем полный путь к модели
			
			//	Проверяем наличие файла в папке
			if(file_exists(sModelPath))	// Если файл существует, добавляем в массив
			{
				g_aModelName[g_iLoadModelCount] = sModelName;			//	Название модели для меню
				g_aModelPath[g_iLoadModelCount] = sModelPath; 			//	Путь к файлу модели
				g_aModelFile[g_iLoadModelCount] = sModelFileName;		//	Имя файла модели без расширения
				g_aModelTeam[g_iLoadModelCount] = sModelTeam;			//	Команда модели
				g_aModelAccess[g_iLoadModelCount] = sModelAccess;		//	Уровень доступа к модели
				
				g_iLoadModelCount++;
			}else{
				log_amx("Не найден файл %s. Загрузите файл на сервер или проверьте правильно ли заполнен файл с моделями - %s", sModelPath, SETTINGS_FILE );
			}
		}

		fclose(File);
	}

	if (g_iLoadModelCount == 0)
	{
		log_amx("Не загружено ни одной модели. Проверьте правильность заполнения файла с моделями - %s", SETTINGS_FILE);
	}
	else
	{
		log_amx("Загружено %d моделей", g_iLoadModelCount);
	}
	
	return PLUGIN_HANDLED;
}

public Create_Model_Menu(id)
{
	//	Если игрок не подключен, не продолжаем
	if(!is_user_connected(id) || is_user_hltv(id) || is_user_bot(id)){
		log_amx("Игрок %d не подключен", id);
		return PLUGIN_HANDLED;
	}
	strtoupper(g_sCurrentModelName[id]);	//	Переводим имя модели в верхний регистр
	new sMenuName[MAX_PARSE_TEXT];
	formatex(sMenuName, charsmax(sMenuName), "\w%L \r%s ^n^n\y%L", LANG_PLAYER, "MS_MODEL_CURRENT_MODEL_NAME", g_sCurrentModelName[id], LANG_PLAYER, "MS_MODEL_MENU_NAME");	//	Текущая модель игрока и заголовок меню
	
	new ModelMenu = menu_create(sMenuName, "ModelMenu_handler");
	new iUserModelCount = 0;
	
	if (get_user_team(id) == 1)	//	Команда Террористы
	{
		for(new i=0; i <= g_iLoadModelCount; i++)
		{			
			if((equal(g_aModelTeam[i], "T") || equal(g_aModelTeam[i], "ANY")) && (get_user_flags(id) & read_flags(g_aModelAccess[i])))	//	Если команда модели T или ANY и у пользователя есть соответствующий флаг в правах доступа.
			{
				menu_additem(ModelMenu, g_aModelName[i], g_aModelFile[i]);
				iUserModelCount++;
			}else if(i==g_iLoadModelCount && iUserModelCount){
				// Если модели закончились, добавить кнопку сброса
				formatex(sMenuName, charsmax(sMenuName), "%L", id, "MS_MODEL_MENU_RESET_MODEL");
				menu_additem(ModelMenu, sMenuName, "reset");
				client_cmd(id, "spk sound/events/tutor_msg.wav");
			}
		}
	} 
	else if (get_user_team(id) == 2)	//	Команда Контр-Террористы
	{
		for(new i=0; i <= g_iLoadModelCount; i++)
		{			
			if((equal(g_aModelTeam[i], "CT") || equal(g_aModelTeam[i], "ANY")) && (get_user_flags(id) & read_flags(g_aModelAccess[i])))	//	Если команда модели CT или ANY и у пользователя есть соответствующий флаг в правах доступа.
			{
				menu_additem(ModelMenu, g_aModelName[i], g_aModelFile[i]);
				iUserModelCount++;
			}else if(i==g_iLoadModelCount && iUserModelCount){
				// Если модели закончились, добавить кнопку сброса
				formatex(sMenuName, charsmax(sMenuName), "%L", id, "MS_MODEL_MENU_RESET_MODEL");
				menu_additem(ModelMenu, sMenuName, "reset");
				client_cmd(id, "spk sound/events/tutor_msg.wav");
			}
		}
	} 
	else if (get_user_team(id) == 3)	//	Команда Наблюдатель
	{
		log_amx("Команда игрока Наблюдатель");
		client_cmd(id, "spk sound/events/friend_died.wav");
		return PLUGIN_HANDLED;
	}
	else
	{
		log_amx("Команда игрока еще не выбрана");
		return PLUGIN_HANDLED;
	}

	formatex(sMenuName, charsmax(sMenuName), "%L", id, "MS_MODEL_MENU_BACK");
	menu_setprop(ModelMenu, MPROP_BACKNAME, sMenuName);
	formatex(sMenuName, charsmax(sMenuName), "%L", id, "MS_MODEL_MENU_NEXT");
	menu_setprop(ModelMenu, MPROP_NEXTNAME, sMenuName);
	formatex(sMenuName, charsmax(sMenuName), "%L", id, "MS_MODEL_MENU_EXIT");
	menu_setprop(ModelMenu, MPROP_EXITNAME, sMenuName);
	menu_setprop(ModelMenu, MPROP_PAGE_CALLBACK, "menu_page_more_back");

	menu_display(id, ModelMenu);
	if(iUserModelCount)
	{
		set_task(10.0, "player_cancel_menu", id + 5987,_,_,"a", 1);	// Закрыть меню через 10 секунд
	}
	
	return PLUGIN_HANDLED;
}

public ModelMenu_handler(id, ModelMenu, item)
{
	if(item == MENU_EXIT) {
		client_cmd(id, "spk sound/events/friend_died.wav");
		remove_task(id+5987);
		menu_destroy(ModelMenu);
		return PLUGIN_HANDLED;
	}		
	
	new sModelFile[MAX_MODEL_FILE], sModelName[MAX_MODEL_NAME], callback;
	menu_item_getinfo(ModelMenu, item, _, sModelFile, charsmax(sModelFile), sModelName, charsmax(sModelName), callback);
	if(equal(sModelFile, "reset"))
	{
		remove_task(id+5987);
		cs_reset_user_model(id);
		
		new s_ModelFile[MAX_MODEL_FILE];
		cs_get_user_model(id, s_ModelFile, charsmax(s_ModelFile));	//	Получаем текущую модель игрока
		g_sCurrentModelFile[id] = s_ModelFile;
		g_sCurrentModelName[id] = s_ModelFile;
		client_printc(id, "\g%L \d%L \g%s", id, "MS_MODEL_ATTENTION",id, "MS_MODEL_PLAYER_SET_MODEL", g_sCurrentModelName[id]);
		client_cmd(id, "spk sound/events/tutor_msg.wav");
	}
	else
	{
		remove_task(id+5987);
		g_sCurrentModelName[id] = sModelName;
		g_sCurrentModelFile[id] = sModelFile;
		cs_set_user_model(id, sModelFile);
		client_printc(id, "\g%L \d%L \g%s", id, "MS_MODEL_ATTENTION",id, "MS_MODEL_PLAYER_SET_MODEL", g_sCurrentModelName[id]);
		client_cmd(id, "spk sound/events/tutor_msg.wav");
	}
	return PLUGIN_HANDLED;
}

public menu_page_more_back(id)
{
	client_cmd(id, "spk sound/events/tutor_msg.wav");
}

// Игрок выбрал персонажа
public player_chose_class(id)
{
	if(is_user_connected(id) && !is_user_bot(id))	//	Если игрок подключен и не бот
	{
		cs_reset_user_model(id);	//	Сбрасываем модель игрока
		new s_ModelFile[MAX_MODEL_FILE];
		cs_get_user_model(id, s_ModelFile, charsmax(s_ModelFile));	//	Получаем текущую модель игрока
		g_sCurrentModelFile[id] = s_ModelFile;	//	Записываем в глобавльную переменную текущую модель игрока
		g_sCurrentModelName[id] = s_ModelFile;	//	Записываем в глобавльную переменную текущую модель игрока
	}
	remove_task(id);
	set_task( 5.0, "Create_Model_Menu", id );//Открываем меню для смены модели	
}

// Игрок поменял команду
public player_change_team()
{
	
	new s_Name[64], index, id; // Имя игрока, Ник игрока и ID игрока
	read_data(3, s_Name, charsmax(s_Name)); //Считываем данные игрока
	index = get_user_index(s_Name); // получаем индекс игрока
	id = get_user_userid(index);	//получаем id игрока
	
	if(is_user_connected(id) && !is_user_bot(id))	//	Если игрок подключен и не бот
	{
		cs_reset_user_model(id);	//	Сбрасываем модель игрока
		new s_ModelFile[MAX_MODEL_FILE];
		cs_get_user_model(id, s_ModelFile, charsmax(s_ModelFile));	//	Получаем текущую модель игрока
		g_sCurrentModelFile[id] = s_ModelFile;	//	Записываем в глобавльную переменную текущую модель игрока
		g_sCurrentModelName[id] = s_ModelFile;	//	Записываем в глобавльную переменную текущую модель игрока
	}
	remove_task(id);
	set_task( 5.0, "Create_Model_Menu", id );//Открываем меню для смены модели
}
//	Отмена меню
public player_cancel_menu(task_id)
{
	new id = task_id - 5987;
	remove_task(task_id);
	show_menu(id, 0, "^n", 1);
}

//	Цветной чат
stock client_printc(id, const text[], any:...)
{
	
	new szMsg[MAX_MODEL_NAME], iPlayers[MAX_PLAYER], iCount = 1;
	vformat(szMsg, charsmax(szMsg), text, 3);
	
	replace_all(szMsg, charsmax(szMsg), "\g","^x04");										//	Зеленый цвет
	replace_all(szMsg, charsmax(szMsg), "\d","^x01");										//	Цвет по умолчанию
	replace_all(szMsg, charsmax(szMsg), "\t","^x03");										//	Цвет команды
	
	if(id)
		iPlayers[0] = id;
	else
		get_players(iPlayers, iCount, "ch");
	
	for(new i = 0 ; i < iCount ; i++)
	{
		if(!is_user_connected(iPlayers[i]))
			continue;
		
		message_begin(MSG_ONE_UNRELIABLE, g_i_MessageIDSayText, _, iPlayers[i]);
		write_byte(iPlayers[i]);
		write_string(szMsg);
		message_end();
	}
}