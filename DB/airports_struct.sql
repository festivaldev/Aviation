# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 192.168.178.48 (MySQL 5.7.23-0ubuntu0.16.04.1)
# Datenbank: aviation
# Erstellt am: 2018-08-19 15:54:35 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Export von Tabelle airports
# ------------------------------------------------------------

CREATE TABLE `airports` (
  `ident` varchar(7) COLLATE latin1_general_cs NOT NULL DEFAULT '',
  `type` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `name` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `coordinates` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `elevation_ft` float DEFAULT NULL,
  `continent` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `iso_country` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `iso_region` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `municipality` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `gps_code` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `iata_code` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  `local_code` varchar(255) COLLATE latin1_general_cs DEFAULT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
