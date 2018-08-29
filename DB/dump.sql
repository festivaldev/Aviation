# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 192.168.178.48 (MySQL 5.7.23-0ubuntu0.16.04.1)
# Datenbank: aviation
# Erstellt am: 2018-08-28 14:50:39 +0000
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
  `isAdmin` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;

INSERT INTO `accounts` (`id`, `firstName`, `lastName`, `email`, `password`, `isAdmin`, `createdAt`, `updatedAt`)
VALUES
	('87ab77d9b81def85ba3dc773d4887729','test','test','test@test.com','n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=',0,'2018-08-12 17:38:34','2018-08-28 14:30:50');

/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle airports
# ------------------------------------------------------------

CREATE TABLE `airports` (
  `id` int(6) unsigned NOT NULL,
  `ident` varchar(7) DEFAULT '',
  `type` text,
  `name` text,
  `latitude_deg` float DEFAULT NULL,
  `longitude_deg` float DEFAULT NULL,
  `elevation_ft` float DEFAULT NULL,
  `continent` varchar(2) DEFAULT NULL,
  `iso_country` varchar(2) DEFAULT NULL,
  `iso_region` text,
  `municipality` text,
  `scheduled_service` varchar(10) DEFAULT NULL,
  `gps_code` varchar(4) DEFAULT NULL,
  `iata_code` varchar(4) DEFAULT NULL,
  `local_code` text,
  `home_link` text,
  `wikipedia_link` text,
  `keywords` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Export von Tabelle billing_addresses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `billing_addresses`;

CREATE TABLE `billing_addresses` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `accountId` varchar(32) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT '',
  `prefix` varchar(6) NOT NULL DEFAULT '',
  `firstName` varchar(255) NOT NULL DEFAULT '',
  `lastName` varchar(255) NOT NULL DEFAULT '',
  `street` varchar(255) NOT NULL DEFAULT '',
  `postalCode` varchar(11) NOT NULL DEFAULT '',
  `postalCity` varchar(255) NOT NULL DEFAULT '',
  `country` varchar(10) NOT NULL DEFAULT '',
  `email` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `phoneNumber` varchar(255) NOT NULL DEFAULT '',
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `billing_addresses` WRITE;
/*!40000 ALTER TABLE `billing_addresses` DISABLE KEYS */;

INSERT INTO `billing_addresses` (`id`, `accountId`, `prefix`, `firstName`, `lastName`, `street`, `postalCode`, `postalCity`, `country`, `email`, `phoneNumber`, `createdAt`, `updatedAt`)
VALUES
	('0815997ce23895cff7f18871975b3555','','male','Janik','Schmidt','EichstraÃ?e 43','30880','Laatzen','de','janikschmidt@gmx.de','0511825559','2018-08-28 15:40:38','2018-08-28 15:57:57'),
	('48837ec91332014b2ff18d768b85b403','87ab77d9b81def85ba3dc773d4887729','male','Janik','Schmidt','EichstraÃ?e 43','30880','Laatzen','de','janikschmidt@gmx.de','0511825559','2018-08-27 12:36:46','2018-08-28 15:57:57');

/*!40000 ALTER TABLE `billing_addresses` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle bookings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bookings`;

CREATE TABLE `bookings` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `svid` varchar(13) NOT NULL DEFAULT '',
  `holder` text NOT NULL,
  `flightId` text NOT NULL,
  `fromIATA` varchar(4) NOT NULL DEFAULT '',
  `toIATA` varchar(4) NOT NULL DEFAULT '',
  `departure` datetime NOT NULL,
  `class` text NOT NULL,
  `passengerCount` int(11) NOT NULL,
  `extras` text NOT NULL,
  `price` float NOT NULL,
  `paid` tinyint(1) NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `svid` (`svid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Export von Tabelle cancellations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cancellations`;

CREATE TABLE `cancellations` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `ticketId` varchar(32) NOT NULL DEFAULT '',
  `refundEmail` text NOT NULL,
  `reason` text NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Export von Tabelle contacts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `contacts`;

CREATE TABLE `contacts` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `firstName` varchar(255) NOT NULL DEFAULT '',
  `lastName` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `type` varchar(255) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Export von Tabelle promo_categories
# ------------------------------------------------------------

DROP TABLE IF EXISTS `promo_categories`;

CREATE TABLE `promo_categories` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
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
	('194aa28196c4c49123c17f8727a482ac','929174845c73dfa98e6230ce4556f484','Punta Cana, Dom. Republik','<p>Wer hat nicht schon einmal davon geträumt, mit völlig freiem Kopf, ohne Sorgen und Nöte am weißen Sandstrand mit türkisblauem Karibikwasser zu liegen? Denn nicht nur auf Bildern sehen diese Strände wie gemalt aus – auch vor Ort kann sich der Blick auf Kokospalmen und feinste Sandstrände sehen lassen. Und ein Urlaub in der <span class=\"italic\">Karibik</span> ist ein einzigartiges Erlebnis, das man so schnell nicht vergessen wird. In der Karibik finden sich unzählige Inseln, die nur darauf warten, besucht zu werden. Selbstverständlich haben sich auch die Hotels diese Beliebtheit nicht entgehen lassen, den überall findet man lange Hotelketten.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> <span class=\"italic\">Punta Cana</span> liegt ganz im Osten der Dominikanischen Republik. Im Gegensatz zu den Nachbarinseln und -staaten, wie etwa das angrenzende Haiti, ist die Infrastruktur in der Dominikanischen Republik schon sehr weit fortgeschritten, was größtenteils an den Einnahmen durch Touristen liegt. Urlauber fühlen sich hier sicher und überwiegend zufrieden – sofern man Kundenrezensionen Glauben schenken mag. Die Ostküste der Republik, die beliebteste Touristenpromenade am <span class=\"italic\">Playa Bavaro</span> strotzt nur so vor Hotels. Hier hat man quasi freie Auswahl. Den Träumen von der Karibik wird man hier definitiv gerecht, nicht nur durch z.B. Kokosnüsse am Strand, die man kostenlos aufheben und trinken darf, sondern auch durch die Atmosphäre und der interessanten Fauna, wie beispielsweise riesige Insekten, die man in Europa wohl nie zu Gesicht bekommen würde.</p>','https://media-cdn.holidaycheck.com/w_1280,h_720,c_fit,q_80/ugc/images/ad74e6c5-143b-3d0c-a135-f382c8ec1292','2018-08-22 09:08:33','2018-08-23 21:25:28'),
	('3548a66e5e215ddb50d2c429366ab8d0','929174845c73dfa98e6230ce4556f484','Copacabana, Rio de Janeiro','<p><span class=\"italic\">Rio de Janeiro</span> ist nach São Paulo die zweitgrößte Stadt Brasiliens und liegt an der Guanabara-Bucht im Südosten des Landes. Mit etwa 11,9 Millionen Einwohnern in der Region rund um Rio gehört sie zu den Megametropolen der Welt und ist spätestens Seit der Fußball-WM 2014, als Deutschland nach 24 Jahren endlich mal wieder Weltmeister wurde, überall in Deutschland bekannt. Besonders beliebte Ausflugsziele sind zum einen der <span class=\"italic\">Zuckerhut</span> (Pão de Açúcar), ein etwa 396 Meter hoher Berg am westlichen Eingang zur Bucht gelegen, und die weltberühmte Christus-Figur <span class=\"italic\">Christus, der Erlöser</span> (Christo Redentor), eine 30 Meter hohe monumentale Statue auf dem Corcovado-Berg.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> Die <span class=\"italic\">Copacabana</span> ist einer der bekanntesten und beliebtesten Stadtteile Rios. Das Markenzeichen ist der etwa 4 Kilometer lange, weiße Sandstrand, der direkt zwischen mit Favelas bevölkerten Granitfelsen und dem Atlantik liegt. Auch die Christusstatue auf dem Corcovado ist von hier aus zu sehen. Die idyllische Umgebung rund um die Copacabana vermittelt eine ruhige und besonnene, aber gleichzeitig eine durch den Tourismus aufgeweckte Stimmung. Auch am Abend und gerade bei Nacht ist die <span class=\"italic\">Strandpromenade</span> ein wahres Erlebnis. Die faszinierende Beleuchtung der Promenade lässte den Sand am Strand sogar grün erscheinen.</p>','https://media.urlaubspiraten.at/images/2015/11/copacabana-beach-in-rio-de-janeiro-brazil-1447248700-yfI8.jpg','2018-08-22 08:36:54','2018-08-22 08:36:54'),
	('69c10bb81b5fe7baa76f26fdec9e17bc','a5be5ea9b91f0e4a8d0312fff3b229fa','Teneriffa, Kanarische Inseln','<p><span class=\"italic\">Teneriffa</span> ist die größte der sieben kanarischen Inseln, die etwa 300 Kilometer westlich des afrikanischen Kontinents im Atlantik liegen – allerdings gehören sie zum spanischen Hoheitsgebiet. Das Besondere an Teneriffa ist, dass es eine Vulkaninsel ist. Egal zu welcher Jahreszeit man auf Teneriffa Urlaub machen möchte – das afrikanische Klima sorgt dafür, dass es selbst in den Wintermonaten angenehm warm auf den Kanaren ist. Daher liegt auch im Winter die Temperatur durchschnittlich bei 20° C. Wer also kein Freund der Kälte ist oder Weihnachten mal im T-Shirt statt in Omas Strickpullover feiern möchte, der ist auf Teneriffa, sowie den umliegenden Inseln sehr gut aufgehoben.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> An der <span class=\"italic\">Südküste Teneriffas</span> reihen sich die Hotels nur so aneinander. Große Hotelanlagen, zahlreiche Pools sowie ein glasklares Meerwasser machen jeden Urlaub zu einem echten Genuss. Das Wasser ist Legenden zufolge so besonders rein, weil der Blick in Richtung Karibik geht. So auch im Hotel <span class=\"italic\">Jardin Caleta</span>, wo man nicht nur entspannen, sondern auch in riesigen Sportanlagen und Schwimmbädern Sport treiben kann. Verbringen auch Sie ihren nächsten Urlaub auf Teneriffa.</p>','https://static.neckermann-reisen.de/data/fileadmin/style/images/region_big/NEC-all-inclusive-spanien-teneriffa-ES_Teneriffa_iStock-525212066.jpg','2018-08-19 00:55:17','2018-08-19 01:34:14'),
	('6f32ca9a1f44acd5f12fd2f56fec80d4','e6f369780453fe3dcb600ecabd1f6e03','London, Vereinigtes Königreich','<p><span class=\"italic\">London</span> – Millionenstadt und Hauptstadt des Vereinigten Königreichs. Für Sightseeing-Urlauber und Städteliebhaber immer eine Reise wert, denn dort gibt es so viel zu besichtigen, dass damit glatt zwei Wochen gefüllt werden könnten. Bei der Menge an Sehenswürdigkeiten ist es eigentlich auch gar nicht so einfach welche zu nennen, die in der Innenstadt Londons herausstechen. Da wären zum Beispiel der weltbekannte <span class=\"italic\">Big Ben</span>, das <span class=\"italic\">London Eye</span>, der historische <span class=\"italic\">Tower of London</span> oder das Anwesen des Oberhaupts der britischen Monarchie, Queen Elizabeth II., der <span class=\"italic\">Buckinham Palace</span>. Jede dieser Sehenswürdigkeiten hat eine große historische, politische oder royale Bedeutung. Wer noch nie in England war, sollte vor allem London einen Besuch abstatten.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> In einer riesgien Gondel mit bis zu 25 Personen für etwa 30 Minuten über der Innenstadt – das ist das <span class=\"italic\">London Eye</span>. Von hier aus hat man einen atemberaubenden Blick auf dutzende Sehenswürdigkeiten der Stadt, egal ob westlich oder östlich der Themse. In etwa 135 Metern Höhe, dem höchsten Punkt der Fahrt, hat man bei gutem Wetter die Chance, den Flughafen Heathrow ganz im Westen Londons zu bestaunen. Aber selbst wenn das Wetter mal nicht so schön sein sollte, kann man immernoch dem Big Ben fast auf Augenhöhe begegnen. Hier wird ein unvergessliches Erlebnis garantiert, und das London Eye sollte bei einem Besuch keinesfalls ausgelassen werden.</p>','https://www.virginexperiencedays.co.uk/content/img/product/large/visit-to-the-coca-07155552.jpg','2018-08-19 17:52:17','2018-08-19 17:52:17'),
	('747c2359fe307888937dfc199761a9ad','a5be5ea9b91f0e4a8d0312fff3b229fa','Cala Rajada, Mallorca','<p>Wenn man die Deutschen fragt, wohin sie in den Urlaub fahren, erhält man meist die selbe Antwort: <span class=\"bold\">Mallorca</span>. Oft auch schon als das 17. Bundesland bezeichnet, liegt die Hauptinsel der Balearen gute 170 km östlich des spanischen Festlandes im Mittelmeer. Neben unzähligen Hotels, in denen man 2 Wochen (oder auch länger) die Seele baumeln lassen kann, gibt es überall Ecken, an denen hemmungslos gefeiert wird, wie beispielsweise an den Küsten im Südwesten der Hauptstadt Palma. Zudem ist Mallorca für seine Berge im Osten bekannt, in denen Fahrrad- und Offroadtouren zu einem echten Erlebnis werden. Mallorca ist also für wirklichen interressant – ob jung oder alt, ruhig oder laut, faul oder aktiv.</p>\n<p><span class=\"bold\">Unser Reisetipp: </span> Die Gemeinde <span class=\"italic\">Cala Rajada</span> ist eine der beliebtesten Ferienorte der Balearen. An der Ostküste der Insel gelegen hat sie sich mittlerweile zu einer der größten ihrer Art entwickelt. Nicht zuletzt durch das türkisblaue Wasser und den 150 Meter langen Sandstrand werden Urlauber wie magisch angezogen. Immer mehr Hotels werden errichtet, um dem wachsenden Ansturm auf die Insel gerecht zu werden. Außerdem bietet Mallorca vielfältige Angebote, wie zum Beispiel Faulenzen am Strand, das Erkunden des Felsreliefs, städtische Aktivitäten in der Hauptstadt Palma bis hin zu ausgelassenem Feiern in einem der Zahlreichen Clubs am Ballermann – vorausgesetzt, Sie sind ein Freund von Schlagermusik. Warum verbringen auch Sie nicht bei nächster Gelegenheit ihren Urlaub auf Mallorca? Erleben Sie die grenzenlose Schönheit dieser Insel.</p>','https://1.bp.blogspot.com/-V6SCR93d224/V3UtsFJihEI/AAAAAAAAEUY/bccW-kUGu2wwg2CdeWOMPKnuAhE0JHZdACKgB/s1600/IMG_20160622_122919%2Bneu.jpg','2018-08-12 00:20:20','2018-08-12 18:10:33'),
	('b8800de05a4d653a7b725dbd2bcf04f9','e6f369780453fe3dcb600ecabd1f6e03','Marina Bay Circuit, Singapur','<p>Singapur ist ein tropischer Insel- und Stadtstaat südlich von Malaysia gelegen. Trotz der Tatsache, dass Singapur der kleinste Statt Südostasiens ist, ist hier die Bevölkerungsdichte am höchsten. Singapur ist bekannt als <span class=\"italic\">Ort der reichen Menschen</span>, denn tatsächlich ist es eines der Finanzzentren Asiens und eines der reichsten Länder der Welt. Mit mehr als 11 Millionen ausländischen Touristen im Jahr zählt Singapur zu den zehn meistbesuchten Städten der Welt. In der Innenstadt reihen sich unzählige Wolkenkratzer und architektonisch aufwendige, interessante Bauwerke der Moderne aneinander – auch daher ist Singapur so beliebt bei Touristen aus aller Welt.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> Einmal den <span class=\"italic\">Großen Preis von Singapur</span> (offiziell bekannt als \"Singapore Airlines Singapore Grand Prix\") miterleben – das muss nicht nur für Rennsportbegeisterte ein Traum sein. Seit 2008 ist der 5 Kilometer lange Stadtkurs <span class=\"italic\">Marina Bay Street Ciruit</span> fester Bestandteil des Formel 1-Kalenders. Das besondere an dieser Strecke: Das eigentliche Rennen am Sonntag wird nachts ausgetragen. Zuletzt konnte Lewis Hamilton 2017 im Mercedes vor Sebastian Vettel im Ferrari gewinnen. Auf den Tribünen, die zum Rennen rund um die Strecke errichtet werden, finden bis zu 90.000 Zuschauer platz. Während der Großteil dieser Strecke aus öffentlichen Straßen besteht, wurde die Start-/Ziellinie speziell für das Rennen gebaut. Wenn Sie also sportbegeistert sein sollten, können wir Ihnen einen Besuch des Rennens auf jeden Fall empfehlen.</p>','http://koe-magazin.de/wp-content/uploads/2018/01/singapur-29624.jpg','2018-08-21 13:33:45','2018-08-23 22:53:24'),
	('cb9e0f5bed6e16248f3adb87f035079b','929174845c73dfa98e6230ce4556f484','Malé, Malediven','<p>Die <span class=\"italic\">Malediven</span> sind eine Inselgruppe, die im indischen Ozean südlich von – wer hätte es gedacht – Indien liegt. Bekannt sind sie vor allem für ihre Strände, blauen Lagunen und ausgedehnten Riffe. Ein perfekter Ort also für einen unvergesslichen Abenteuerurlaub. Die verhältnismäßig große Hauptstadt Malé bietet neben den Stränden, an denen man sich entspannen kann, viele Einkaufsmöglichkeiten und Sehenswürdigkeiten, wie beispielsweise den großen <span class=\"italic\">Fischmarkt</span> im Herzen der Stadt, oder die antike <span class=\"italic\">Friday Mosque</span> (Hukuru Miskiy), die gänzlich mit Korallensteinen aus dem Archipel erbaut wurde.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> <span class=\"italic\">Malé</span> – Kaum zu glauben, dass auf so einer kleinen Insel eine riesige Stadt steht – mit Wolkenkratzern, Restaurants, Museen und historischen Denkmählern, wie man sie sonst nur aus ländlicheren Regionen kennt. Dieser Stadt einen Besuch abzustatten ist ein absolutes muss, wenn man seinen Urlaub auf den Malediven verbringt. Mit einer Stadtrundfahrt wird der Tag zu einem einmaligen Erlebnis. Ein wahres Abenteuer im tropischem Paradies also.</p>','https://newsroom.aviator.aero/content/images/2017/11/Male_Island_Maldives-1920x1080.jpg','2018-08-22 08:52:33','2018-08-24 14:05:09'),
	('ea94d174c624bde0cd52566c1b6892be','a5be5ea9b91f0e4a8d0312fff3b229fa','Antalya, Türkei','<p><span class=\"italic\">Antalya</span> ist eines der beliebtesten Reiseziele deutscher Urlauber, im Süden der Türkei und damit schon in Asien gelegen. Während es im Sommer brennend heiß ist, ist es im Winter angenehm kühl. Antalya ist bekannt für seine endlos langen Hotelketten ganz im Osten der Stadt. Aber auch die Stadt selbst hat eine spannende Historie zu bieten. Wenn Sie ein Freund von heißen Temperaturen und gut gebräunter Haut sind, ist ein Besuch im Sommer definitv zu empfehlen, denn das Thermometer erreicht im Sommer gerne mal 40° und mehr. Aber solche hohen Temperaturen bringen auch Vorteile mit sich – Die Freude, sich im glasklaren Meer oder im Pool in einer der Hotelanlagen abzukühlen ist mit steigenden Temperaturen größer.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> <span class=\"italic\">Side</span> ist nicht nur wegen der Größe und der Nähe zu Antalya ein Anreiseort für Urlauber, es bietet auch atemberaubende Wasserparks und Rutschen, wie hier im <span class=\"italic\">Royal Alhambra Palace</span>. Die hohen Temperaturen können hier mit Spaß und Entspannung für die ganze Familie ausgeglichen werden, beispielsweise bei einer Rutschpartie. Wenn man die Strandpromenade entlanggeht, findet man zahlreiche Hotels mit solchen Rutschen. Einen solchen Adrenalinkick bekommt man nur hier. Solch ein großartiges Erlebnis sollten Sie sich auf keinen Fall entgehen lassen!</p>','https://media-cdn.holidaycheck.com/w_1920,h_1080,c_fit,q_80/ugc/images/132a0f9d-78aa-3ae2-aac8-dd0574d9d8ab','2018-08-19 01:18:30','2018-08-19 01:18:30'),
	('fe47068e0076968db9190b8b813d3601','e6f369780453fe3dcb600ecabd1f6e03','Times Square, New York City','<p><span class=\"italic\">New York City</span> liegt an der Ostküste der Vereinigten Staaten von Amerika und ist für viele die wohl bekannteste Stadt der USA. Das liegt wahrscheinlich vor allem daran, dass sie mit 8,5 Millionen Einwohnern eine der bevölkerungsreichsten Städte der Welt ist. Ihrem Status wird sie vor allem dann gerecht, blickt man auf der Sehenswürdigkeiten der Stadt: Neben der weltberühmten <span class=\"italic\">Freiheitsstatue</span> mit ihren 305 Metern Höhe sind auch der <span class=\"italic\">Central Park</span> und das <span class=\"italic\">Empire State Building</span> beliebte Ausflugsziele. Die Innenstadt bietet zudem eine Vielzahl an Wolkenkratzern, weshalb sich ein Besuch dort ohne jeden Zweifel lohnt.</p>\n<p><span class=\"bold\">Unser Reisetipp:</span> Ein ganz besonderer Touristenmagnet ist der <span class=\"italic\">Times Square</span>. Benannt nach der New York Times, dessen Gebäude hier errichtet wurde, liegt der Times Square im Zentrum des Theaterviertels von Manhattan. Gerade nachts zieht es die Touristen hier her, um dieses atemberaubende Feuerwerk an Beleuchtung und riesigen Werbeschildern zu bestaunen. Lassen auch Sie sich New York nicht entgehen!</p>','https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/times-square-at-night-in-new-york-city-lanjee-chee.jpg','2018-08-21 13:46:06','2018-08-21 13:46:06');

/*!40000 ALTER TABLE `promo_texts` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle questions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `questions`;

CREATE TABLE `questions` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `linkId` varchar(255) NOT NULL DEFAULT '',
  `questionText` text,
  `answerText` text,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `linkId` (`linkId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;

INSERT INTO `questions` (`id`, `linkId`, `questionText`, `answerText`, `createdAt`, `updatedAt`)
VALUES
	('308d571b612e85ec27348ab0e9d66081','cancellation-tcs','Welche Bedingungen gelten für Stornierungen?','<p>Jedes Ticket kann kostenfrei bis 24h vor dem Abflug storniert werden. Ab 24 Stunden vor Abflug werden 50% des Ticketpreises erstattet, nach dem Abflug werden nicht eingelöste Tickets nur bei Unfällen, Naturkatastrophen, Inneren Unruhen oder offiziellen Reisewarnungen des Auswärtigen Amtes erstattet. Der erstattete Betrag wird als Gutschein einem Aviation-Konto gutgeschrieben und nur in Ausnahmefällen ausbezahlt. Zur Stornierung über den Support ist sowohl die Ticket-, als auch die Storno-Verifizierungs-ID notwendig.</p>','2018-08-24 19:29:51','2018-08-24 19:29:51'),
	('da0c7f6aec4c15d98d37d3aa6a406f2e','how-to-cancel','Wie kann ich ein Ticket stornieren?','<p>Du kannst dein Ticket jederzeit im Dashboard unter \"Tickets\" stornieren. Wenn du dein Ticket ohne Account erworben hast, oder auf den Account aktuell keinen Zugriff hast, kannst du unter <a href=\"sc-cancellations.html\">Stornierungen</a> dein Ticket ebenfalls stornieren.</p>','2018-08-24 19:30:14','2018-08-25 08:43:50');

/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle services
# ------------------------------------------------------------

DROP TABLE IF EXISTS `services`;

CREATE TABLE `services` (
  `id` varchar(32) NOT NULL DEFAULT '',
  `serviceId` varchar(255) NOT NULL DEFAULT '',
  `title` text NOT NULL,
  `price` float NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;

INSERT INTO `services` (`id`, `serviceId`, `title`, `price`, `createdAt`, `updatedAt`)
VALUES
	('2dde8162fc83ba05cc6e0c70910cb084','luggage','Gepäckmitnahme',15,'2018-08-26 22:28:03','2018-08-26 22:28:06'),
	('66898c79410ab9fa933c4f73cebd3892','children','Kleinkinder',9999,'2018-08-26 22:28:52','2018-08-26 22:28:52'),
	('b783624a19318a402fa66922104c6768','food','Essen &amp; Trinken',24,'2018-08-26 22:28:18','2018-08-26 22:28:31');

/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;


# Export von Tabelle sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
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
