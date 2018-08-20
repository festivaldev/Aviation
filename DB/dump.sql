# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 192.168.178.48 (MySQL 5.7.23-0ubuntu0.16.04.1)
# Datenbank: aviation
# Erstellt am: 2018-08-20 20:31:59 +0000
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

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;

INSERT INTO `accounts` (`id`, `firstName`, `lastName`, `email`, `password`, `createdAt`, `updatedAt`)
VALUES
	('87ab77d9b81def85ba3dc773d4887729','test','test','test@test.com','n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=','2018-08-12 17:38:34','2018-08-12 17:38:34');

/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;


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
  `id` varchar(32) NOT NULL DEFAULT '',
  `categoryId` varchar(32) NOT NULL DEFAULT '',
  `location` varchar(255) DEFAULT '',
  `content` text,
  `headerImage` text,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `promo_texts` WRITE;
/*!40000 ALTER TABLE `promo_texts` DISABLE KEYS */;

INSERT INTO `promo_texts` (`id`, `categoryId`, `location`, `content`, `headerImage`, `createdAt`, `updatedAt`)
VALUES
	('69c10bb81b5fe7baa76f26fdec9e17bc','a5be5ea9b91f0e4a8d0312fff3b229fa','Teneriffa, Kanarische Inseln','<p><span class=\"italic\">Teneriffa</span> ist die größte der sieben kanarischen Inseln, die etwa 300 Kilometer westlich des afrikanischen Kontinents im Atlantik liegen – allerdings gehören sie zum spanischen Hoheitsgebiet. Das Besondere an Teneriffa ist, dass es eine Vulkaninsel ist. Egal zu welcher Jahreszeit man auf Teneriffa Urlaub machen möchte – das afrikanische Klima sorgt dafür, dass es selbst in den Wintermonaten angenehm warm auf den Kanaren ist. Daher liegt auch im Winter die Temperatur durchschnittlich bei 20° C. Wer also kein Freund der Kälte ist oder Weihnachten mal im T-Shirt statt in Omas Strickpullover feiern möchte, der ist auf Teneriffa, sowie den umliegenden Inseln sehr gut aufgehoben.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> An der <span class=\"italic\">Südküste Teneriffas</span> reihen sich die Hotels nur so aneinander. Große Hotelanlagen, zahlreiche Pools sowie ein glasklares Meerwasser machen jeden Urlaub zu einem echten Genuss. Das Wasser ist Legenden zufolge so besonders rein, weil der Blick in Richtung Karibik geht. So auch im Hotel <span class=\"italic\">Jardin Caleta</span>, wo man nicht nur entspannen, sondern auch in riesigen Sportanlagen und Schwimmbädern Sport treiben kann. Verbringen auch Sie ihren nächsten Urlaub auf Teneriffa.</p>','https://static.neckermann-reisen.de/data/fileadmin/style/images/region_big/NEC-all-inclusive-spanien-teneriffa-ES_Teneriffa_iStock-525212066.jpg','2018-08-19 00:55:17','2018-08-19 01:34:14'),
	('6f32ca9a1f44acd5f12fd2f56fec80d4','e6f369780453fe3dcb600ecabd1f6e03','London, Vereinigtes Königreich','<p><span class=\"italic\">London</span> – Millionenstadt und Hauptstadt des Vereinigten Königreichs. Für Sightseeing-Urlauber und Städteliebhaber immer eine Reise wert, denn dort gibt es so viel zu besichtigen, dass damit glatt zwei Wochen gefüllt werden könnten. Bei der Menge an Sehenswürdigkeiten ist es eigentlich auch gar nicht so einfach welche zu nennen, die in der Innenstadt Londons herausstechen. Da wären zum Beispiel der weltbekannte <span class=\"italic\">Big Ben</span>, das <span class=\"italic\">London Eye</span>, der historische <span class=\"italic\">Tower of London</span> oder das Anwesen des Oberhaupts der britischen Monarchie, Queen Elizabeth II., der <span class=\"italic\">Buckinham Palace</span>. Jede dieser Sehenswürdigkeiten hat eine große historische, politische oder royale Bedeutung. Wer noch nie in England war, sollte vor allem London einen Besuch abstatten.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> In einer riesgien Gondel mit bis zu 25 Personen für etwa 30 Minuten über der Innenstadt – das ist das <span class=\"italic\">London Eye</span>. Von hier aus hat man einen atemberaubenden Blick auf dutzende Sehenswürdigkeiten der Stadt, egal ob westlich oder östlich der Themse. In etwa 135 Metern Höhe, dem höchsten Punkt der Fahrt, hat man bei gutem Wetter die Chance, den Flughafen Heathrow ganz im Westen Londons zu bestaunen. Aber selbst wenn das Wetter mal nicht so schön sein sollte, kann man immernoch dem Big Ben fast auf Augenhöhe begegnen. Hier wird ein unvergessliches Erlebnis garantiert, und das London Eye sollte bei einem Besuch keinesfalls ausgelassen werden.</p>','https://www.virginexperiencedays.co.uk/content/img/product/large/visit-to-the-coca-07155552.jpg','2018-08-19 17:52:17','2018-08-19 17:52:17'),
	('747c2359fe307888937dfc199761a9ad','a5be5ea9b91f0e4a8d0312fff3b229fa','Cala Rajada, Mallorca','<p>Wenn man die Deutschen fragt, wohin sie in den Urlaub fahren, erhält man meist die selbe Antwort: <span class=\"bold\">Mallorca</span>. Oft auch schon als das 17. Bundesland bezeichnet, liegt die Hauptinsel der Balearen gute 170 km östlich des spanischen Festlandes im Mittelmeer. Neben unzähligen Hotels, in denen man 2 Wochen (oder auch länger) die Seele baumeln lassen kann, gibt es überall Ecken, an denen hemmungslos gefeiert wird, wie beispielsweise an den Küsten im Südwesten der Hauptstadt Palma. Zudem ist Mallorca für seine Berge im Osten bekannt, in denen Fahrrad- und Offroadtouren zu einem echten Erlebnis werden. Mallorca ist also für wirklichen interressant – ob jung oder alt, ruhig oder laut, faul oder aktiv.</p>\n<p><span class=\"bold\">Unser Reisetipp: </span> Die Gemeinde <span class=\"italic\">Cala Rajada</span> ist eine der beliebtesten Ferienorte der Balearen. An der Ostküste der Insel gelegen hat sie sich mittlerweile zu einer der größten ihrer Art entwickelt. Nicht zuletzt durch das türkisblaue Wasser und den 150 Meter langen Sandstrand werden Urlauber wie magisch angezogen. Immer mehr Hotels werden errichtet, um dem wachsenden Ansturm auf die Insel gerecht zu werden. Außerdem bietet Mallorca vielfältige Angebote, wie zum Beispiel Faulenzen am Strand, das Erkunden des Felsreliefs, städtische Aktivitäten in der Hauptstadt Palma bis hin zu ausgelassenem Feiern in einem der Zahlreichen Clubs am Ballermann – vorausgesetzt, Sie sind ein Freund von Schlagermusik. Warum verbringen auch Sie nicht bei nächster Gelegenheit ihren Urlaub auf Mallorca? Erleben Sie die grenzenlose Schönheit dieser Insel.</p>','https://1.bp.blogspot.com/-V6SCR93d224/V3UtsFJihEI/AAAAAAAAEUY/bccW-kUGu2wwg2CdeWOMPKnuAhE0JHZdACKgB/s1600/IMG_20160622_122919%2Bneu.jpg','2018-08-12 00:20:20','2018-08-12 18:10:33'),
	('ea94d174c624bde0cd52566c1b6892be','a5be5ea9b91f0e4a8d0312fff3b229fa','Antalya, Türkei','<p><span class=\"italic\">Antalya</span> ist eines der beliebtesten Reiseziele deutscher Urlauber, im Süden der Türkei und damit schon in Asien gelegen. Während es im Sommer brennend heiß ist, ist es im Winter angenehm kühl. Antalya ist bekannt für seine endlos langen Hotelketten ganz im Osten der Stadt. Aber auch die Stadt selbst hat eine spannende Historie zu bieten. Wenn Sie ein Freund von heißen Temperaturen und gut gebräunter Haut sind, ist ein Besuch im Sommer definitv zu empfehlen, denn das Thermometer erreicht im Sommer gerne mal 40° und mehr. Aber solche hohen Temperaturen bringen auch Vorteile mit sich – Die Freude, sich im glasklaren Meer oder im Pool in einer der Hotelanlagen abzukühlen ist mit steigenden Temperaturen größer.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> <span class=\"italic\">Side</span> ist nicht nur wegen der Größe und der Nähe zu Antalya ein Anreiseort für Urlauber, es bietet auch atemberaubende Wasserparks und Rutschen, wie hier im <span class=\"italic\">Royal Alhambra Palace</span>. Die hohen Temperaturen können hier mit Spaß und Entspannung für die ganze Familie ausgeglichen werden, beispielsweise bei einer Rutschpartie. Wenn man die Strandpromenade entlanggeht, findet man zahlreiche Hotels mit solchen Rutschen. Einen solchen Adrenalinkick bekommt man nur hier. Solch ein großartiges Erlebnis sollten Sie sich auf keinen Fall entgehen lassen!</p>','https://media-cdn.holidaycheck.com/w_1920,h_1080,c_fit,q_80/ugc/images/132a0f9d-78aa-3ae2-aac8-dd0574d9d8ab','2018-08-19 01:18:30','2018-08-19 01:18:30');

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
