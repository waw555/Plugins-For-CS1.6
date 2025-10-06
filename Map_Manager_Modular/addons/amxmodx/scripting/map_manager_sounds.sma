// 0.0.3.1 Добавлены дополнительные звуки

#include <amxmodx>
#include <map_manager>

#define PLUGIN "Map Manager: Sounds"
#define VERSION "0.0.3.1 16.08.2025"
#define AUTHOR "Mistrick"

#pragma semicolon 1

new const SETTINGS_FILE[] = "map_manager_settings.ini";

enum Sections {
    UNUSED_SECTION,
    SOUND_VOTE_STARTED,
    SOUND_VOTE_FINISHED,
	SOUND_VOTE_OK,
	SOUND_VOTE_ERROR,
    SOUND_VOTE_RTV,
    SOUND_VOTE_REPEAT,
	SOUND_LAST_ROUND,
    SOUNDS_COUNTDOWN
}
enum ParserData {
    Sections:SECTION
};
new parser_info[ParserData];

new g_sVoteStarted[128];
new g_sVoteFinished[128];
new g_sVoteOk[128];
new g_sVoteError[128];
new g_sVoteRTV[128];
new g_sVoteRepeat[128];
new g_sLastRound[128];
new Trie:g_tCountdownSounds;

public plugin_precache()
{
    register_plugin(PLUGIN, VERSION + VERSION_HASH, AUTHOR);

    g_tCountdownSounds = TrieCreate();
    load_settings();
}
load_settings()
{
    new configdir[256];
    get_localinfo("amxx_configsdir", configdir, charsmax(configdir));

    new INIParser:parser = INI_CreateParser();

    INI_SetParseEnd(parser, "ini_parse_end");
    INI_SetReaders(parser, "ini_key_value", "ini_new_section");
    new bool:result = INI_ParseFile(parser, fmt("%s/%s", configdir, SETTINGS_FILE));

    if(!result) {
        set_fail_state("Can't read from ini file.");
    }
}
public ini_new_section(INIParser:handle, const section[], bool:invalid_tokens, bool:close_bracket, bool:extra_tokens, curtok, any:data)
{
    if(equal(section, "sound_vote_started")) {
        parser_info[SECTION] = SOUND_VOTE_STARTED;
    } else if(equal(section, "sound_vote_finished")) {
        parser_info[SECTION] = SOUND_VOTE_FINISHED;
    } else if(equal(section, "sound_vote_ok")) {
		parser_info[SECTION] = SOUND_VOTE_OK;
    } else if(equal(section, "sound_vote_error")) {
		parser_info[SECTION] = SOUND_VOTE_ERROR;
    } else if(equal(section, "sound_vote_rtv")) {
        parser_info[SECTION] = SOUND_VOTE_RTV;
    } else if(equal(section, "sound_vote_repeat")) {
        parser_info[SECTION] = SOUND_VOTE_REPEAT;
    } else if(equal(section, "sound_last_round")) {
        parser_info[SECTION] = SOUND_LAST_ROUND;
    } else if(equal(section, "sounds_countdown")) {
        parser_info[SECTION] = SOUNDS_COUNTDOWN;
    } else {
        parser_info[SECTION] = UNUSED_SECTION;
    }
    return true;
}
public ini_key_value(INIParser:handle, const key[], const value[], bool:invalid_tokens, bool:equal_token, bool:quotes, curtok, any:data)
{
    switch(parser_info[SECTION]) {
        case SOUND_VOTE_STARTED: {
            copy(g_sVoteStarted, charsmax(g_sVoteStarted), key);
            remove_quotes(g_sVoteStarted);
            precache_generic(g_sVoteStarted);
        }
        case SOUND_VOTE_FINISHED: {
            copy(g_sVoteFinished, charsmax(g_sVoteFinished), key);
            remove_quotes(g_sVoteFinished);
            precache_generic(g_sVoteFinished);
        }
		case SOUND_VOTE_OK: {
            copy(g_sVoteOk, charsmax(g_sVoteOk), key);
            remove_quotes(g_sVoteOk);
            precache_generic(g_sVoteOk);
        }
        case SOUND_VOTE_ERROR: {
            copy(g_sVoteError, charsmax(g_sVoteError), key);
            remove_quotes(g_sVoteError);
            precache_generic(g_sVoteError);
        }
        case SOUND_VOTE_RTV: {
            copy(g_sVoteRTV, charsmax(g_sVoteRTV), key);
            remove_quotes(g_sVoteRTV);
            precache_generic(g_sVoteRTV);
        }
        case SOUND_VOTE_REPEAT: {
            copy(g_sVoteRepeat, charsmax(g_sVoteRepeat), key);
            remove_quotes(g_sVoteRepeat);
            precache_generic(g_sVoteRepeat);
        }
        case SOUND_LAST_ROUND: {
            copy(g_sLastRound, charsmax(g_sLastRound), key);
            remove_quotes(g_sLastRound);
            precache_generic(g_sLastRound);
        }
        case SOUNDS_COUNTDOWN: {
            new k[16];
            copy(k, charsmax(k), key);
            remove_quotes(k);
            precache_generic(value);
            TrieSetString(g_tCountdownSounds, k, value);
        }
    }
    return true;
}
public ini_parse_end(INIParser:handle, bool:halted, any:data)
{
    INI_DestroyParser(handle);
}
public mapm_countdown(type, time)
{
    if(type == COUNTDOWN_PREPARE) {
        new key[4], sound[128];
        num_to_str(time, key, charsmax(key));
        if(TrieKeyExists(g_tCountdownSounds, key)) {
            TrieGetString(g_tCountdownSounds, key, sound, charsmax(sound));
            play_sound(0, sound);
        }
    }
}
public mapm_vote_started(type)
{
    if(g_sVoteStarted[0]) {
        play_sound(0, g_sVoteStarted);
    }
}
public mapm_vote_finished(const map[], type, total_votes)
{
    if(g_sVoteFinished[0]) {
        play_sound(0, g_sVoteFinished);
    }
}
public mapm_vote_ok(id)
{
    if(g_sVoteOk[0]) {
        play_sound(id, g_sVoteOk);
    }
}
public mapm_vote_error(id)
{
    if(g_sVoteError[0]) {
        play_sound(id, g_sVoteError);
    }
}
public mapm_vote_rtv(id)
{
    if(g_sVoteRTV[0]) {
        play_sound(id, g_sVoteRTV);
    }
}
public mapm_vote_repeat(id)
{
    if(g_sVoteRepeat[0]) {
        play_sound(id, g_sVoteRepeat);
    }
}
public mapm_vote_last_round(id)
{
    if(g_sLastRound[0]) {
        play_sound(id, g_sLastRound);
    }
}
play_sound(id, sound[])
{
    new len = strlen(sound);
    if(equali(sound[len - 3], "wav")) {
        client_cmd(id, "spk ^"%s^"", sound);
        //send_audio(id, sound, PITCH_NORM);
    } else if(equali(sound[len - 3], "mp3")) {
        client_cmd(id, "mp3 play ^"%s^"", sound);
    }
}