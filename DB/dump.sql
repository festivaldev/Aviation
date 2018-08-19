# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 192.168.178.48 (MySQL 5.7.23-0ubuntu0.16.04.1)
# Datenbank: iae_test
# Erstellt am: 2018-08-12 15:13:00 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Export von Tabelle accounts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `id` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `firstName` varchar(255) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `lastName` varchar(255) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `email` varchar(255) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `password` varchar(255) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `password` (`password`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;



# Export von Tabelle promo_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `promo_categories`;

CREATE TABLE `promo_categories` (
  `id` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `title` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

LOCK TABLES `promo_categories` WRITE;
/*!40000 ALTER TABLE `promo_categories` DISABLE KEYS */;

INSERT INTO `promo_categories` (`id`, `title`, `createdAt`, `updatedAt`)
VALUES
	('929174845c73dfa98e6230ce4556f484','Tropen &amp; Abenteuer','2018-08-12 00:12:06','2018-08-12 00:12:06'),
	('a5be5ea9b91f0e4a8d0312fff3b229fa','Sonne &amp; Strand','2018-08-12 00:09:27','2018-08-12 00:10:36'),
	('e6f369780453fe3dcb600ecabd1f6e03','Stadt &amp; Leben','2018-08-12 00:11:31','2018-08-12 00:11:31');

/*!40000 ALTER TABLE `promo_categories` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle promo_texts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `promo_texts`;

CREATE TABLE `promo_texts` (
  `id` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `categoryId` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `location` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `content` text COLLATE latin1_general_cs,
  `headerImage` text COLLATE latin1_general_cs,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `promo_texts_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `promo_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

LOCK TABLES `promo_texts` WRITE;
/*!40000 ALTER TABLE `promo_texts` DISABLE KEYS */;

INSERT INTO `promo_texts` (`id`, `categoryId`, `location`, `content`, `headerImage`, `createdAt`, `updatedAt`)
VALUES
	('747c2359fe307888937dfc199761a9ad','a5be5ea9b91f0e4a8d0312fff3b229fa','Cala Rajada, Mallorca','<p>Der wohl beliebteste Sommerurlaubsort der Deutschen, schon als 17. Bundesland bezeichnet ? Mallorca. Die Hauptinsel der Balearen liegt gute 170 Kilometer östlich des spanischen Festlands im Mittelmeer. Neben unzähligen Hotelketten, in denen die Seele 2 Wochen im Sommer baumeln kann, gibt es auch Ecken, in denen gefeiert wird, wie an den Küsten im Südwesten Palmas. Außerdem ist Mallorca für sein Gebirge im Osten bekannt, in dem Fahrrad- und Geländewagentouren zum echten Erlebnis werden. Mallorca ist also von jung bis alt, von ruhig bis laut, von aktiv bis faul, für jeden interessant.</p>\n        <p>Reisetipp: Cala Ratjada - einer der beliebtesten Ferienorte der Balearen. Er liegt an der Ostküste und hat sich mittlerweile zu einem der größten seiner Art entwickelt. Nicht zuletzt auch durch das türkisblaue Wasser und den 150-Meter langen Sandstrand werden die Urlauber wie von einem Magnet angezogen. Die Hotelketten wachsen stetig. Die Insel bietet vielfältige Angebote. Von Faulenzen am Strand, über Erkunden des Reliefs, über städtische Aktivitäten in der Hauptstadt Palma, bis hin zu grenzenlosem Zelebrieren. Machen auch Sie bei ihrer nächsten Gelegenheit Urlaub auf Mallorca und erleben sie ihre volle Schönheit. Günstige Flüge jetzt im Angebot.</p>','https://1.bp.blogspot.com/-V6SCR93d224/V3UtsFJihEI/AAAAAAAAEUY/bccW-kUGu2wwg2CdeWOMPKnuAhE0JHZdACKgB/s1600/IMG_20160622_122919%2Bneu.jpg','2018-08-12 00:20:20','2018-08-12 00:21:48');

/*!40000 ALTER TABLE `promo_texts` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `accountId` varchar(32) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `accountId` (`accountId`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
