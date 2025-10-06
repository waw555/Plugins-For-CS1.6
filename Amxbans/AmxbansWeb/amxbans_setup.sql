-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Авг 17 2025 г., 10:28
-- Версия сервера: 5.5.68-MariaDB
-- Версия PHP: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `cl423643_bans`
--

-- --------------------------------------------------------

--
-- Структура таблицы `amx_admins_servers`
--

CREATE TABLE IF NOT EXISTS `amx_admins_servers` (
  `admin_id` int(11) DEFAULT NULL,
  `server_id` int(11) DEFAULT NULL,
  `custom_flags` varchar(32) NOT NULL,
  `use_static_bantime` enum('yes','no') NOT NULL DEFAULT 'yes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_amxadmins`
--

CREATE TABLE IF NOT EXISTS `amx_amxadmins` (
  `id` int(12) NOT NULL,
  `username` varchar(32) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `access` varchar(32) DEFAULT NULL,
  `flags` varchar(32) DEFAULT NULL,
  `steamid` varchar(32) DEFAULT NULL,
  `nickname` varchar(32) DEFAULT NULL,
  `ashow` int(11) DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `expired` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_bans`
--

CREATE TABLE IF NOT EXISTS `amx_bans` (
  `bid` int(11) NOT NULL,
  `player_ip` varchar(32) DEFAULT NULL,
  `player_id` varchar(35) DEFAULT NULL,
  `player_nick` varchar(100) DEFAULT 'Unknown',
  `admin_ip` varchar(32) DEFAULT NULL,
  `admin_id` varchar(35) DEFAULT NULL,
  `admin_nick` varchar(100) DEFAULT 'Unknown',
  `ban_type` varchar(10) DEFAULT 'S',
  `ban_reason` varchar(100) DEFAULT NULL,
  `ban_created` int(11) DEFAULT NULL,
  `ban_length` int(11) DEFAULT NULL,
  `server_ip` varchar(32) DEFAULT NULL,
  `server_name` varchar(100) DEFAULT 'Unknown',
  `ban_kicks` int(11) NOT NULL DEFAULT '0',
  `expired` int(1) NOT NULL DEFAULT '0',
  `imported` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_bans_edit`
--

CREATE TABLE IF NOT EXISTS `amx_bans_edit` (
  `id` int(11) NOT NULL,
  `bid` int(11) NOT NULL,
  `edit_time` int(11) NOT NULL,
  `admin_nick` varchar(32) NOT NULL DEFAULT 'unknown',
  `edit_reason` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_bbcode`
--

CREATE TABLE IF NOT EXISTS `amx_bbcode` (
  `id` int(11) NOT NULL,
  `open_tag` varchar(32) DEFAULT NULL,
  `close_tag` varchar(32) DEFAULT NULL,
  `url` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_bbcode`
--

INSERT INTO `amx_bbcode` (`id`, `open_tag`, `close_tag`, `url`, `name`) VALUES
(1, '[b]', '[/b]', 'bold.png', 'bold'),
(2, '[i]', '[/i]', 'italic.png', 'italic'),
(3, '[u]', '[/u]', 'underline.png', 'underline'),
(4, '[center]', '[/center]', 'center.png', 'center');

-- --------------------------------------------------------

--
-- Структура таблицы `amx_comments`
--

CREATE TABLE IF NOT EXISTS `amx_comments` (
  `id` int(11) NOT NULL,
  `name` varchar(35) DEFAULT NULL,
  `comment` text,
  `email` varchar(100) DEFAULT NULL,
  `addr` varchar(32) DEFAULT NULL,
  `date` int(11) DEFAULT NULL,
  `bid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_files`
--

CREATE TABLE IF NOT EXISTS `amx_files` (
  `id` int(11) NOT NULL,
  `upload_time` int(11) DEFAULT NULL,
  `down_count` int(11) DEFAULT NULL,
  `bid` int(11) DEFAULT NULL,
  `demo_file` varchar(100) DEFAULT NULL,
  `demo_real` varchar(100) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `comment` text,
  `name` varchar(64) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `addr` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_flagged`
--

CREATE TABLE IF NOT EXISTS `amx_flagged` (
  `fid` int(11) NOT NULL,
  `player_ip` varchar(32) DEFAULT NULL,
  `player_id` varchar(35) DEFAULT NULL,
  `player_nick` varchar(100) DEFAULT 'Unknown',
  `admin_ip` varchar(32) DEFAULT NULL,
  `admin_id` varchar(35) DEFAULT NULL,
  `admin_nick` varchar(100) DEFAULT 'Unknown',
  `reason` varchar(100) DEFAULT NULL,
  `created` int(11) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `server_ip` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_levels`
--

CREATE TABLE IF NOT EXISTS `amx_levels` (
  `level` int(12) NOT NULL DEFAULT '0',
  `bans_add` enum('yes','no') DEFAULT 'no',
  `bans_edit` enum('yes','no','own') DEFAULT 'no',
  `bans_delete` enum('yes','no','own') DEFAULT 'no',
  `bans_unban` enum('yes','no','own') DEFAULT 'no',
  `bans_import` enum('yes','no') DEFAULT 'no',
  `bans_export` enum('yes','no') DEFAULT 'no',
  `amxadmins_view` enum('yes','no') DEFAULT 'no',
  `amxadmins_edit` enum('yes','no') DEFAULT 'no',
  `webadmins_view` enum('yes','no') DEFAULT 'no',
  `webadmins_edit` enum('yes','no') DEFAULT 'no',
  `websettings_view` enum('yes','no') DEFAULT 'no',
  `websettings_edit` enum('yes','no') DEFAULT 'no',
  `permissions_edit` enum('yes','no') DEFAULT 'no',
  `prune_db` enum('yes','no') DEFAULT 'no',
  `servers_edit` enum('yes','no') DEFAULT 'no',
  `ip_view` enum('yes','no') DEFAULT 'no'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_levels`
--

INSERT INTO `amx_levels` (`level`, `bans_add`, `bans_edit`, `bans_delete`, `bans_unban`, `bans_import`, `bans_export`, `amxadmins_view`, `amxadmins_edit`, `webadmins_view`, `webadmins_edit`, `websettings_view`, `websettings_edit`, `permissions_edit`, `prune_db`, `servers_edit`, `ip_view`) VALUES
(1, 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes', 'yes');

-- --------------------------------------------------------

--
-- Структура таблицы `amx_logs`
--

CREATE TABLE IF NOT EXISTS `amx_logs` (
  `id` int(11) NOT NULL,
  `timestamp` int(11) DEFAULT NULL,
  `ip` varchar(32) DEFAULT NULL,
  `username` varchar(32) DEFAULT NULL,
  `action` varchar(64) DEFAULT NULL,
  `remarks` varchar(256) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_logs`
--

INSERT INTO `amx_logs` (`id`, `timestamp`, `ip`, `username`, `action`, `remarks`) VALUES
(1, 1755415682, '212.119.242.137', 'waw555', 'Install', 'Installation AMXBans v6.14.5');

-- --------------------------------------------------------

--
-- Структура таблицы `amx_modulconfig`
--

CREATE TABLE IF NOT EXISTS `amx_modulconfig` (
  `id` int(11) NOT NULL,
  `menuname` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `index` varchar(32) DEFAULT NULL,
  `activ` int(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_modulconfig`
--

INSERT INTO `amx_modulconfig` (`id`, `menuname`, `name`, `index`, `activ`) VALUES
(1, '_MENUIMPORTEXPORT', 'iexport', '', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `amx_reasons`
--

CREATE TABLE IF NOT EXISTS `amx_reasons` (
  `id` int(11) NOT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `static_bantime` int(11) NOT NULL DEFAULT '0',
  `pos` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_reasons_set`
--

CREATE TABLE IF NOT EXISTS `amx_reasons_set` (
  `id` int(11) NOT NULL,
  `setname` varchar(32) DEFAULT NULL,
  `default_set` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_reasons_to_set`
--

CREATE TABLE IF NOT EXISTS `amx_reasons_to_set` (
  `id` int(11) NOT NULL,
  `setid` int(11) NOT NULL,
  `reasonid` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_serverinfo`
--

CREATE TABLE IF NOT EXISTS `amx_serverinfo` (
  `id` int(11) NOT NULL,
  `timestamp` int(11) DEFAULT NULL,
  `hostname` varchar(100) DEFAULT 'Unknown',
  `address` varchar(100) DEFAULT NULL,
  `gametype` varchar(32) DEFAULT NULL,
  `rcon` varchar(32) DEFAULT NULL,
  `amxban_version` varchar(32) DEFAULT NULL,
  `amxban_motd` varchar(250) DEFAULT NULL,
  `motd_delay` int(10) DEFAULT '10',
  `amxban_menu` int(10) NOT NULL DEFAULT '1',
  `reasons` int(10) DEFAULT NULL,
  `timezone_fixx` int(11) NOT NULL DEFAULT '0',
  `timeout` int(10) NOT NULL DEFAULT '3'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `amx_smilies`
--

CREATE TABLE IF NOT EXISTS `amx_smilies` (
  `id` int(5) NOT NULL,
  `code` varchar(32) DEFAULT NULL,
  `url` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_smilies`
--

INSERT INTO `amx_smilies` (`id`, `code`, `url`, `name`) VALUES
(1, ':D', 'big_smile.png', 'Big Grin'),
(2, '8)', 'cool.png', 'Cool'),
(3, ':S', 'hmm.png', 'Hmm'),
(4, 'lol', 'lol.png', 'lol'),
(5, ':(', 'mad.png', 'Mad'),
(6, ':|', 'neutral.png', 'Neutral'),
(7, ':roll:', 'roll.png', 'RollEyes'),
(8, ':*(', 'sad.png', 'Sad'),
(9, ':)', 'smile.png', 'Smilie'),
(10, ':P', 'tongue.png', 'Tongue'),
(11, ';)', 'wink.png', 'Wink'),
(12, ':O', 'yikes.png', 'Yikes');

-- --------------------------------------------------------

--
-- Структура таблицы `amx_usermenu`
--

CREATE TABLE IF NOT EXISTS `amx_usermenu` (
  `id` int(11) NOT NULL,
  `pos` int(11) DEFAULT NULL,
  `activ` tinyint(1) NOT NULL DEFAULT '1',
  `lang_key` varchar(64) DEFAULT NULL,
  `url` varchar(64) DEFAULT NULL,
  `lang_key2` varchar(64) DEFAULT NULL,
  `url2` varchar(64) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_usermenu`
--

INSERT INTO `amx_usermenu` (`id`, `pos`, `activ`, `lang_key`, `url`, `lang_key2`, `url2`) VALUES
(1, 0, 1, '_HOME', 'index.php', '_HOME', 'index.php'),
(2, 1, 1, '_BANLIST', 'ban_list.php', '_BANLIST', 'ban_list.php'),
(3, 2, 1, '_ADMLIST', 'admin_list.php', '_ADMLIST', 'admin_list.php'),
(4, 3, 1, '_SEARCH', 'search.php', '_SEARCH', 'search.php'),
(5, 4, 1, '_SERVER', 'view.php', '_SERVER', 'view.php'),
(6, 5, 1, '_LOGIN', 'login.php', '_LOGOUT', 'logout.php');

-- --------------------------------------------------------

--
-- Структура таблицы `amx_webadmins`
--

CREATE TABLE IF NOT EXISTS `amx_webadmins` (
  `id` int(12) NOT NULL,
  `username` varchar(32) DEFAULT NULL,
  `password` varchar(32) DEFAULT NULL,
  `level` int(11) DEFAULT '99',
  `logcode` varchar(64) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `last_action` int(11) DEFAULT NULL,
  `try` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_webadmins`
--

INSERT INTO `amx_webadmins` (`id`, `username`, `password`, `level`, `logcode`, `email`, `last_action`, `try`) VALUES
(1, 'waw555', 'af883d8a1c3968fab52429239d051caa', 1, NULL, 'waw555@yandex.ru', NULL, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `amx_webconfig`
--

CREATE TABLE IF NOT EXISTS `amx_webconfig` (
  `id` int(11) NOT NULL,
  `cookie` varchar(32) DEFAULT NULL,
  `bans_per_page` int(11) DEFAULT NULL,
  `design` varchar(32) DEFAULT NULL,
  `banner` varchar(64) DEFAULT NULL,
  `banner_url` varchar(128) NOT NULL,
  `default_lang` varchar(32) DEFAULT NULL,
  `start_page` varchar(64) DEFAULT NULL,
  `show_comment_count` int(1) DEFAULT '1',
  `show_demo_count` int(1) DEFAULT '1',
  `show_kick_count` int(1) DEFAULT '1',
  `demo_all` int(1) NOT NULL DEFAULT '0',
  `comment_all` int(1) DEFAULT '0',
  `use_capture` int(1) DEFAULT '1',
  `max_file_size` int(11) DEFAULT '2',
  `file_type` varchar(64) DEFAULT 'dem,zip,rar,jpg,gif',
  `auto_prune` int(1) NOT NULL DEFAULT '0',
  `max_offences` smallint(6) NOT NULL DEFAULT '10',
  `max_offences_reason` varchar(128) NOT NULL DEFAULT 'max offences reached',
  `use_demo` int(1) DEFAULT '1',
  `use_comment` int(1) DEFAULT '1',
  `email_host` varchar(255) DEFAULT NULL,
  `email_host_port` int(11) DEFAULT NULL,
  `email_security` varchar(10) DEFAULT 'STARTTLS',
  `email_username` varchar(255) DEFAULT NULL,
  `email_password` varchar(255) DEFAULT NULL,
  `email_from` varchar(255) DEFAULT NULL,
  `email_from_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `amx_webconfig`
--

INSERT INTO `amx_webconfig` (`id`, `cookie`, `bans_per_page`, `design`, `banner`, `banner_url`, `default_lang`, `start_page`, `show_comment_count`, `show_demo_count`, `show_kick_count`, `demo_all`, `comment_all`, `use_capture`, `max_file_size`, `file_type`, `auto_prune`, `max_offences`, `max_offences_reason`, `use_demo`, `use_comment`, `email_host`, `email_host_port`, `email_security`, `email_username`, `email_password`, `email_from`, `email_from_name`) VALUES
(1, 'amxbans', 50, 'default', 'amxbans.png', 'http://www.amxbans.net', 'english', 'view.php', 1, 1, 1, 0, 0, 1, 2, 'dem,zip,rar,jpg,gif,png', 0, 10, 'max offences reached', 1, 1, NULL, NULL, 'STARTTLS', NULL, NULL, NULL, NULL);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `amx_amxadmins`
--
ALTER TABLE `amx_amxadmins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `steamid` (`steamid`);

--
-- Индексы таблицы `amx_bans`
--
ALTER TABLE `amx_bans`
  ADD PRIMARY KEY (`bid`),
  ADD KEY `player_id` (`player_id`);

--
-- Индексы таблицы `amx_bans_edit`
--
ALTER TABLE `amx_bans_edit`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_bbcode`
--
ALTER TABLE `amx_bbcode`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_comments`
--
ALTER TABLE `amx_comments`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_files`
--
ALTER TABLE `amx_files`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_flagged`
--
ALTER TABLE `amx_flagged`
  ADD PRIMARY KEY (`fid`),
  ADD KEY `player_id` (`player_id`);

--
-- Индексы таблицы `amx_levels`
--
ALTER TABLE `amx_levels`
  ADD PRIMARY KEY (`level`);

--
-- Индексы таблицы `amx_logs`
--
ALTER TABLE `amx_logs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_modulconfig`
--
ALTER TABLE `amx_modulconfig`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_reasons`
--
ALTER TABLE `amx_reasons`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_reasons_set`
--
ALTER TABLE `amx_reasons_set`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_reasons_to_set`
--
ALTER TABLE `amx_reasons_to_set`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_serverinfo`
--
ALTER TABLE `amx_serverinfo`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_smilies`
--
ALTER TABLE `amx_smilies`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_usermenu`
--
ALTER TABLE `amx_usermenu`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `amx_webadmins`
--
ALTER TABLE `amx_webadmins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`,`email`);

--
-- Индексы таблицы `amx_webconfig`
--
ALTER TABLE `amx_webconfig`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `amx_amxadmins`
--
ALTER TABLE `amx_amxadmins`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_bans`
--
ALTER TABLE `amx_bans`
  MODIFY `bid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_bans_edit`
--
ALTER TABLE `amx_bans_edit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_bbcode`
--
ALTER TABLE `amx_bbcode`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT для таблицы `amx_comments`
--
ALTER TABLE `amx_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_files`
--
ALTER TABLE `amx_files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_flagged`
--
ALTER TABLE `amx_flagged`
  MODIFY `fid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_logs`
--
ALTER TABLE `amx_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT для таблицы `amx_modulconfig`
--
ALTER TABLE `amx_modulconfig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT для таблицы `amx_reasons`
--
ALTER TABLE `amx_reasons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_reasons_set`
--
ALTER TABLE `amx_reasons_set`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_reasons_to_set`
--
ALTER TABLE `amx_reasons_to_set`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_serverinfo`
--
ALTER TABLE `amx_serverinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT для таблицы `amx_smilies`
--
ALTER TABLE `amx_smilies`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT для таблицы `amx_usermenu`
--
ALTER TABLE `amx_usermenu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT для таблицы `amx_webadmins`
--
ALTER TABLE `amx_webadmins`
  MODIFY `id` int(12) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT для таблицы `amx_webconfig`
--
ALTER TABLE `amx_webconfig`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
