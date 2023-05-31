--
-- Структура таблиці `ACCESS_PORT`
--

CREATE TABLE `ACCESS_PORT` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'Просто індекс',
  `ipsw` varchar(42) NOT NULL DEFAULT '' COMMENT 'IP світча',
  `port` varchar(8) NOT NULL DEFAULT '0' COMMENT 'номер або назва порта',
  `vid` smallint(5) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Vlan ID',
  `mbamode` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'режим MAC-based autorizatin',
  `dhcpmode` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'режим DHCP',
  `ip4` varchar(20) NOT NULL DEFAULT '' COMMENT 'прив''язана до порта IPv4',
  `ip4bitmask` tinyint(3) UNSIGNED NOT NULL DEFAULT 24 COMMENT 'As described',
  `comment` varchar(254) NOT NULL DEFAULT '' COMMENT 'Just comment'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `ACCESS_PORT`
--
ALTER TABLE `ACCESS_PORT`
  ADD PRIMARY KEY (`id`),
  ADD KEY `switch-port` (`port`),
  ADD KEY `switch` (`ipsw`);

--
-- Структура таблиці `IPSESSION`
--

CREATE TABLE `IPSESSION` (
  `cnt` int(10) UNSIGNED NOT NULL COMMENT 'just counter',
  `mac` varchar(17) NOT NULL DEFAULT '' COMMENT 'MAC адреса юзера',
  `switch` varchar(49) NOT NULL DEFAULT '' COMMENT 'IP світча, на якому авторизувався юзер',
  `port` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'порт світча, на якому авторизувався юзер',
  `vid` smallint(5) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'VID, який назначено юзеру',
  `dhcp_relay` varchar(49) NOT NULL DEFAULT '' COMMENT 'IP адреса DHCP relay',
  `port_relay` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'номер порту на DHCP relay ( якщо є)',
  `ip4` varchar(17) NOT NULL DEFAULT '' COMMENT 'IPv4 адреса, яку юзер отримав по DHCP',
  `ip6` varchar(49) NOT NULL DEFAULT '' COMMENT 'IPv6 адреса, яку юзер отримав по DHCP',
  `begin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'початок сессії',
  `last_upd` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'час останнього оновлення, неважливо ким',
  `bytein` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'лічильник даних, отриманих від юзер',
  `byteout` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'лічильник даних, відправлених юзеру',
  `updbymba` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'час оновлення mba',
  `updbydhcp` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'час оновлення DHCP',
  `updbytraf` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'час оновлення лічильником трафіку'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `IPSESSION`
--
ALTER TABLE `IPSESSION`
  ADD PRIMARY KEY (`cnt`),
  ADD UNIQUE KEY `MSPV` (`mac`,`vid`) USING BTREE,
  ADD KEY `IP` (`ip4`,`ip6`),
  ADD KEY `STATE` (`begin`);

