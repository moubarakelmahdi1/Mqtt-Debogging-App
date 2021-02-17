-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  lun. 03 juin 2019 à 10:02
-- Version du serveur :  10.1.38-MariaDB
-- Version de PHP :  7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `wlddmq`
--

-- --------------------------------------------------------

--
-- Structure de la table `action`
--

CREATE TABLE `action` (
  `id` int(11) NOT NULL,
  `message` text,
  `name` varchar(255) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `topic` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `action`
--

INSERT INTO `action` (`id`, `message`, `name`, `sort`, `topic`) VALUES
(8, '', 'Scan Poster', 0, 'wldd/demokit/dks/{{demoId}}/scanPoster'),
(13, '{\n\"productSize\" : \"{{ProductSize}}\",\n\"productPrice\" : {{ProductPrice}},\n\"isCrossSell\" : \"{{crossSell}}\"\n}', 'Scan Product', 1, 'wldd/demokit/dks/{{demoId}}/scanProduct'),
(15, '', 'Post Cross Sell', 2, 'wldd/demokit/dks/{{demoId}}/postCrossSell'),
(17, '', 'Scan Room', 3, 'wldd/demokit/dks/{{demoId}}/scanRoom'),
(20, '{\n\"method\" : \"{{method}}\"\n}', 'Payment Valina', 4, 'wldd/demokit/dks/{{demoId}}/selectPayment'),
(24, '{\n\"basketPrice\" : {{basketPrice}},\n\"terminalId\" : \"{{terminalId}}\"\n}', 'Scan Valina', 5, 'wldd/demokit/dks/{{demoId}}/scanValina'),
(26, '', 'Valina Success', 6, 'wldd/demokit/dks/{{demoId}}/valinaSuccess'),
(29, '{\n\"method\" : \"{{method}}\"\n}', 'Payment Sips', 7, 'wldd/demokit/dks/{{demoId}}/selectPayment'),
(31, '', 'Reset Demo', 8, 'wldd/demokit/dks/{{demoId}}/resetDemo'),
(33, '', 'Payment Waiting', 0, 'rd/chatbot/connectedKitchenBot/payment/waiting/{{complexId}}'),
(34, '', 'Text', 1, 'rd/chatbot/connectedKitchenBot/text'),
(35, '', 'Payment Terminal', 2, 'rd/chatbot/connectedKitchenBot/payment/terminal/'),
(41, '{\n\"terminalId\" : \"{{valinaId}}\",\n\"userId\" : \"{{complexId}}\",\n\"basketPrice\" : \"{{basketPrice}}\",\n\"merchantRef\" : \"{{merchantRef}}\",\n\"orderId\" : \"{{orderId}}\"\n}', 'Launch Reservation', 3, 'rd/chatbot/connectedKitchenBot/payment/scanYomani/launchReservation'),
(42, '', 'C4P Payments', 4, 'rd/chatbot/connectedKitchenBot/c4p/payments'),
(44, '', 'User', 5, 'rd/chatbot/connectedKitchenBot/user/{{uniqueId}}'),
(46, '', 'Payment Ticket', 6, 'rd/chatbot/connectedKitchenBot/payment/ticket/{{complexId}}'),
(48, '', 'Washing Animation', 0, 'ePump/totalcarwash/washinganimation/{{client}}'),
(57, '{\"userID\" : \"{{userID}}\", \"licensePlate\" : \"{{licensePlate}}\",  \"fuelType\" : {{fuelType}}, \"stationName\" : \"{{nameStation}}\", \"stationStreet\" : \"{{stationStreet}}\" , \"stationZipcode\" :\"{{stationZipcode}}\" , \"stationCity\" :\"{{stationCity}}\", \"pumpNumber\":\"{{pumpNumber}}\",\"state\" : \"END_AUTH_WALLET\"}', 'Validate From Dw To Valina', 1, 'rd/chatbot/BotMobaaS/gasStation'),
(58, '', 'Valina Game Start', 2, 'smartVending/valinagame/start'),
(62, '{\"program\":\"{{program}}\",\"amount\":{{amount}}}', 'Launch Carwash Dw', 3, 'ePump/totalcarwash/washingticket/{{plateNumber}}'),
(71, '{\"userID\" : \"{{userID}}\", \"licensePlate\" : \"{{licensePlate}}\",  \"fuelType\" : {{fuelType}}, \"stationName\" : \"{{nameStation}}\", \"stationStreet\" : \"{{stationStreet}}\" , \"stationZipcode\" :\"{{stationZipcode}}\" , \"stationCity\" :\"{{stationCity}}\", \"pumpNumber\":\"{{pumpNumber}}\",\"state\" : \"PLATE_RECO\"}', 'Plaque Valina', 4, 'rd/chatbot/BotMobaaS/gasStation'),
(80, '{\"userID\" : \"{{userID}}\", \"licensePlate\" : \"{{licensePlate}}\",  \"fuelType\" : {{fuelType}}, \"stationName\" : \"{{nameStation}}\", \"stationStreet\" : \"{{stationStreet}}\" , \"stationZipcode\" :\"{{stationZipcode}}\" , \"stationCity\" :\"{{stationCity}}\", \"pumpNumber\":\"{{pumpNumber}}\",\"state\" : \"END_TRANSACTION\"}', 'End Transaction From Valina To Dw', 5, 'rd/chatbot/BotMobaaS/gasStation'),
(82, '', 'Test', 0, 'wldd/demokit/dks/{{demoId}}/selectFuel'),
(85, '', 'TestCyril', 0, '/RD/Cyril/{{param}}'),
(88, 'volume_up', 'Volume Up', 0, 'payggybot/p013'),
(89, 'volume_down', 'Volume Down', 1, 'payggybot/p013'),
(90, 'led_blue_on', 'Led Blue On', 2, 'payggybot/p013'),
(91, 'led_blue_off', 'Led Blue Off', 3, 'payggybot/p013'),
(92, 'led_red_on', 'Led Red On', 4, 'payggybot/p013'),
(93, 'led_red_off', 'Led Red Off', 5, 'payggybot/p013'),
(94, 'led_green_on', 'Led Green On', 6, 'payggybot/p013'),
(95, 'led_green_off', 'Led Green Off', 7, 'payggybot/p013'),
(96, 'set_input_external', 'Use External Mic', 8, 'payggybot/p013/'),
(97, 'set_input_internal', 'Use Internal Mic', 9, 'payggybot/p013/'),
(98, 'set_output_internal', 'Use Internal Speaker', 10, 'payggybot/p013/'),
(101, 'http://rd.atosworldline.com/shareit/yumi/worldline.png', 'Change Logo Worldline', 0, 'bootcamplugano/configuration/CHANGE_LOGO');

-- --------------------------------------------------------

--
-- Structure de la table `action_parameters_messages`
--

CREATE TABLE `action_parameters_messages` (
  `action_id` int(11) NOT NULL,
  `parameters_messages_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `action_parameters_messages`
--

INSERT INTO `action_parameters_messages` (`action_id`, `parameters_messages_id`) VALUES
(13, 10),
(13, 11),
(13, 12),
(20, 19),
(24, 22),
(24, 23),
(29, 28),
(41, 36),
(41, 37),
(41, 38),
(41, 39),
(41, 40),
(57, 49),
(57, 50),
(57, 51),
(57, 52),
(57, 53),
(57, 54),
(57, 55),
(57, 56),
(62, 60),
(62, 61),
(71, 63),
(71, 64),
(71, 65),
(71, 66),
(71, 67),
(71, 68),
(71, 69),
(71, 70),
(80, 72),
(80, 73),
(80, 74),
(80, 75),
(80, 76),
(80, 77),
(80, 78),
(80, 79);

-- --------------------------------------------------------

--
-- Structure de la table `action_parameters_topics`
--

CREATE TABLE `action_parameters_topics` (
  `action_id` int(11) NOT NULL,
  `parameters_topics_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `action_parameters_topics`
--

INSERT INTO `action_parameters_topics` (`action_id`, `parameters_topics_id`) VALUES
(8, 7),
(13, 9),
(15, 14),
(17, 16),
(20, 18),
(24, 21),
(26, 25),
(29, 27),
(31, 30),
(33, 32),
(44, 43),
(46, 45),
(48, 47),
(62, 59),
(82, 81),
(85, 84);

-- --------------------------------------------------------

--
-- Structure de la table `demo`
--

CREATE TABLE `demo` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `demo`
--

INSERT INTO `demo` (`id`, `name`) VALUES
(3, 'DemoKit Fashion'),
(4, 'WeShop'),
(5, 'Driver\'s Wallet'),
(6, 'DemoKit Fuel'),
(83, 'test'),
(86, 'WeLunch'),
(87, 'Payggy'),
(99, 'YUMI sale screen miroring');

-- --------------------------------------------------------

--
-- Structure de la table `demo_action`
--

CREATE TABLE `demo_action` (
  `demo_id` int(11) NOT NULL,
  `action_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `demo_action`
--

INSERT INTO `demo_action` (`demo_id`, `action_id`) VALUES
(3, 29),
(3, 26),
(3, 24),
(3, 20),
(3, 17),
(3, 15),
(3, 13),
(3, 8),
(3, 31),
(4, 44),
(4, 42),
(4, 41),
(4, 35),
(4, 34),
(4, 33),
(4, 46),
(5, 71),
(5, 62),
(5, 58),
(5, 57),
(5, 48),
(5, 80),
(6, 82),
(83, 85),
(87, 98),
(87, 97),
(87, 96),
(87, 95),
(87, 94),
(87, 93),
(87, 92),
(87, 91),
(87, 90),
(87, 89),
(87, 88),
(87, 100),
(99, 101);

-- --------------------------------------------------------

--
-- Structure de la table `demo_user`
--

CREATE TABLE `demo_user` (
  `demo_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `demo_user`
--

INSERT INTO `demo_user` (`demo_id`, `user_id`) VALUES
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(83, 2),
(86, 2),
(87, 2),
(99, 2);

-- --------------------------------------------------------

--
-- Structure de la table `hibernate_sequence`
--

CREATE TABLE `hibernate_sequence` (
  `next_val` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `hibernate_sequence`
--

INSERT INTO `hibernate_sequence` (`next_val`) VALUES
(102),
(102),
(102),
(102);

-- --------------------------------------------------------

--
-- Structure de la table `parameters`
--

CREATE TABLE `parameters` (
  `id` int(11) NOT NULL,
  `parameter` varchar(255) DEFAULT NULL,
  `parameter_default_value` text,
  `type` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `parameters`
--

INSERT INTO `parameters` (`id`, `parameter`, `parameter_default_value`, `type`) VALUES
(7, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(9, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(10, '{{ProductSize}}', 'L', 'MESSAGE'),
(11, '{{ProductPrice}}', '24.99', 'MESSAGE'),
(12, '{{crossSell}}', 'false', 'MESSAGE'),
(14, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(16, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(18, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(19, '{{method}}', 'SIPS', 'MESSAGE'),
(21, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(22, '{{basketPrice}}', '53.99', 'MESSAGE'),
(23, '{{terminalId}}', '1', 'MESSAGE'),
(25, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(27, '{{demoId}}', 'no default value', 'TOPIC'),
(28, '{{method}}', 'no default value', 'MESSAGE'),
(30, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(32, '{{complexId}}', '31c2a8f6d607472bab9e59cd3975b2c1', 'TOPIC'),
(36, '{{valinaId}}', '1', 'MESSAGE'),
(37, '{{complexId}}', '31c2a8f6d607472bab9e59cd3975b2c1', 'MESSAGE'),
(38, '{{basketPrice}}', '53.99', 'MESSAGE'),
(39, '{{merchantRef}}', ' ', 'MESSAGE'),
(40, '{{orderId}}', '1001', 'MESSAGE'),
(43, '{{uniqueId}}', '100', 'TOPIC'),
(45, '{{complexId}}', '31c2a8f6d607472bab9e59cd3975b2c1', 'TOPIC'),
(47, '{{client}}', 'wallet', 'TOPIC'),
(49, '{{userID}}', 'test', 'MESSAGE'),
(50, '{{licensePlate}}', 'AA-059-BB', 'MESSAGE'),
(51, '{{fuelType}}', '0', 'MESSAGE'),
(52, '{{nameStation}}', 'Station Seclin', 'MESSAGE'),
(53, '{{stationStreet}}', '1 rue de la pointe', 'MESSAGE'),
(54, '{{stationZipcode}}', '59113', 'MESSAGE'),
(55, '{{stationCity}}', 'Seclin', 'MESSAGE'),
(56, '{{pumpNumber}}', '2', 'MESSAGE'),
(59, '{{plateNumber}}', 'AA059BB', 'TOPIC'),
(60, '{{program}}', 'Program 1', 'MESSAGE'),
(61, '{{amount}}', '4.00', 'MESSAGE'),
(63, '{{userID}}', 'test', 'MESSAGE'),
(64, '{{licensePlate}}', 'AA-059-BB', 'MESSAGE'),
(65, '{{fuelType}}', '0', 'MESSAGE'),
(66, '{{nameStation}}', 'Station Seclin', 'MESSAGE'),
(67, '{{stationStreet}}', '1 rue de la pointe', 'MESSAGE'),
(68, '{{stationZipcode}}', '59113', 'MESSAGE'),
(69, '{{stationCity}}', 'Seclin', 'MESSAGE'),
(70, '{{pumpNumber}}', '2', 'MESSAGE'),
(72, '{{userID}}', 'test', 'MESSAGE'),
(73, '{{licensePlate}}', 'AA-059-BB', 'MESSAGE'),
(74, '{{fuelType}}', '0', 'MESSAGE'),
(75, '{{nameStation}}', 'Station Seclin', 'MESSAGE'),
(76, '{{stationStreet}}', '1 rue de la pointe', 'MESSAGE'),
(77, '{{stationZipcode}}', '59113', 'MESSAGE'),
(78, '{{stationCity}}', 'Seclin', 'MESSAGE'),
(79, '{{pumpNumber}}', '2', 'MESSAGE'),
(81, '{{demoId}}', 'f1cb219dc49b422c9d637c9b01367ffa', 'TOPIC'),
(84, '{{param}}', 'toto', 'TOPIC');

-- --------------------------------------------------------

--
-- Structure de la table `user_groups`
--

CREATE TABLE `user_groups` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `user_groups`
--

INSERT INTO `user_groups` (`id`, `name`) VALUES
(1, 'WLDD'),
(2, 'R&D');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `action`
--
ALTER TABLE `action`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `action_parameters_messages`
--
ALTER TABLE `action_parameters_messages`
  ADD UNIQUE KEY `UK_s57fkjgw58ddspwm7p6dgmxtw` (`parameters_messages_id`),
  ADD KEY `FKc8u7wsfp4raiwag4g2a7o61s7` (`action_id`);

--
-- Index pour la table `action_parameters_topics`
--
ALTER TABLE `action_parameters_topics`
  ADD UNIQUE KEY `UK_8pd0y2r72ftiv3mcqduqsrygw` (`parameters_topics_id`),
  ADD KEY `FKrewp3p500dfccbmr27xp4wlqs` (`action_id`);

--
-- Index pour la table `demo`
--
ALTER TABLE `demo`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `demo_action`
--
ALTER TABLE `demo_action`
  ADD UNIQUE KEY `UK_o8phbo6ocqteqjvxum30qmcop` (`action_id`),
  ADD KEY `FKc2ss2a40qvj0g9qh1kia7j58y` (`demo_id`);

--
-- Index pour la table `demo_user`
--
ALTER TABLE `demo_user`
  ADD KEY `FKmcwe3b7j3ocfqlvfv6nh9svpj` (`user_id`),
  ADD KEY `FK7vt61k58lljfxxv6h64uahyjt` (`demo_id`);

--
-- Index pour la table `parameters`
--
ALTER TABLE `parameters`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_groups`
--
ALTER TABLE `user_groups`
  ADD PRIMARY KEY (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
