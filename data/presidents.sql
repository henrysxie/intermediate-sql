CREATE DATABASE  IF NOT EXISTS `intermediate_sql` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `intermediate_sql`;
-- MySQL dump 10.13  Distrib 5.7.9, for osx10.9 (x86_64)
--
-- Host: localhost    Database: intermediate_sql
-- ------------------------------------------------------
-- Server version	5.6.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `presidents`
--

DROP TABLE IF EXISTS `presidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `presidents` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `date_of_birth` date NOT NULL,
  `date_of_death` date DEFAULT NULL,
  `home_state` varchar(100) NOT NULL,
  `party` varchar(255) NOT NULL,
  `date_took_office` date DEFAULT NULL,
  `date_left_office` date DEFAULT NULL,
  `assassination_attempt` tinyint(1) DEFAULT '0',
  `assassinated` tinyint(1) DEFAULT '0',
  `religion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presidents`
--

LOCK TABLES `presidents` WRITE;
/*!40000 ALTER TABLE `presidents` DISABLE KEYS */;
INSERT INTO `presidents` VALUES (1,'Washington','George','','1732-02-22','1799-12-14','Virginia','Independent','1789-04-30','1797-03-04',0,0,'Deist/Episcopalian\r'),(2,'Adams','John','','1735-10-30','1826-07-04','Massachusetts','Federalist','1797-03-04','1801-03-04',0,0,'Unitarian\r'),(3,'Jefferson','Thomas','','1743-04-13','1826-07-04','Virginia','Democratic-Republican','1801-03-04','1809-03-04',0,0,'\r'),(4,'Madison','James','','1751-03-16','1836-06-28','Virginia','Democratic-Republican','1809-03-04','1817-03-04',0,0,'Deist/Episcopalian\r'),(5,'Monroe','James','','1758-04-28','1831-07-04','Virginia','Democratic-Republican','1817-03-04','1825-03-04',0,0,'Deist/Episcopalian\r'),(6,'Adams','John','Quincy','1767-07-11','1848-02-23','Massachusetts','Democratic-Republican/National Republican','1825-03-04','1829-03-04',0,0,'Unitarian\r'),(7,'Jackson','Andrew','','1767-03-15','1845-06-08','Tennessee','Democratic','1829-03-04','1837-03-04',1,0,'Presbyterian\r'),(8,'Van Buren','Martin','','1782-12-05','1862-07-24','New York','Democratic','1837-03-04','1841-03-04',0,0,'Dutch Reformed\r'),(9,'Harrison','William','Henry','1773-02-09','1841-04-04','Ohio','Whig','1841-03-04','1841-04-04',0,0,'Episcopalian\r'),(10,'Tyler','John','','1790-03-29','1862-01-18','Virginia','Whig','1841-04-04','1845-03-04',0,0,'Episcopalian\r'),(11,'Polk','James','Knox','1795-11-02','1849-06-15','Tennessee','Democratic','1845-03-04','1849-03-04',0,0,'Methodist\r'),(12,'Taylor','Zachary','','1784-11-24','1850-07-09','Louisiana','Whig','1849-03-04','1850-07-09',0,0,'Episcopalian\r'),(13,'Fillmore','Millard','','1800-01-07','1874-03-08','New York','Whig','1850-07-09','1853-03-04',0,0,'Unitarian\r'),(14,'Pierce','Franklin','','1804-11-03','1869-10-08','New Hampshire','Democratic','1853-03-04','1857-03-04',0,0,'\r'),(15,'Buchanan','James','','1791-04-23','1868-06-01','Pennsylvania','Democratic','1857-03-04','1861-03-04',0,0,'Presbyterian\r'),(16,'Lincoln','Abraham','','1809-02-12','1865-04-15','Illinois','Republican/National Union','1861-03-04','1865-04-15',1,1,'\r'),(17,'Johnson','Andrew','','1808-12-29','1875-07-31','Tennessee','Democratic/National Union','1865-04-15','1869-03-04',0,0,'\r'),(18,'Grant','Ulysses','S','1822-04-27','1885-07-23','Ohio','Republican','1869-03-04','1877-03-04',0,0,'Presbyterian/Methodist\r'),(19,'Hayes','Rutherford','Birchard','1822-10-04','1893-01-17','Ohio','Republican','1877-03-04','1881-03-04',0,0,'\r'),(20,'Garfield','James','Abram','1831-11-19','1881-09-19','Ohio','Republican','1881-03-04','1881-09-19',1,1,'Disciples of Christ\r'),(21,'Arthur','Chester','Alan','1830-10-05','1886-11-18','New York','Republican','1881-09-19','1885-03-04',0,0,'Episcopalian\r'),(22,'Cleveland','Grover','','1837-03-18','1908-06-24','New York','Democratic','1885-03-04','1889-03-04',0,0,'Presbyterian\r'),(23,'Harrison','Benjamin','','1833-08-20','1901-03-13','Indiana','Republican','1889-03-04','1893-03-04',0,0,'Presbyterian\r'),(24,'Cleveland','Grover','','1837-03-18','1908-06-24','New York','Democratic','1893-03-04','1897-03-04',0,0,'Presbyterian\r'),(25,'McKinley','William','','1843-01-29','1901-09-14','Ohio','Republican','1897-03-04','1901-09-14',1,1,'Methodist\r'),(26,'Roosevelt','Theodore','','1858-10-27','1919-01-06','New York','Republican','1901-09-14','1909-03-04',1,0,'Dutch Reformed\r'),(27,'Taft','William','Howard','1857-09-15','1930-03-08','Ohio','Republican','1909-03-04','1913-03-04',0,0,'Unitarian\r'),(28,'Wilson','Woodrow','','1856-12-28','1924-02-03','New Jersey','Democratic','1913-03-04','1921-03-04',0,0,'Presbyterian\r'),(29,'Harding','Warren','Gamaliel','1865-11-02','1923-08-02','Ohio','Republican','1921-03-04','1923-08-02',0,0,'Baptist\r'),(30,'Coolidge','Calvin','','1872-07-04','1933-01-05','Massachusetts','Republican','1923-08-02','1929-03-04',0,0,'Congregationalist\r'),(31,'Hoover','Herbert','Clark','1874-08-10','1964-10-20','Iowa','Republican','1929-03-04','1933-03-04',0,0,'Quaker\r'),(32,'Roosevelt','Franklin','Delano','1882-01-30','1945-04-12','New York','Democratic','1933-03-04','1945-04-12',1,0,'Episcopalian\r'),(33,'Truman','Harry','S','1884-05-08','1972-12-26','Missouri','Democratic','1945-04-12','1953-01-20',1,0,'Baptist\r'),(34,'Eisenhower','Dwight','David','1890-10-14','1969-03-28','Texas','Republican','1953-01-20','1961-01-20',0,0,'Presbyterian\r'),(35,'Kennedy','John','Fitzgerald','1917-05-29','1963-11-22','Massachusetts','Democratic','1961-01-20','1963-11-22',1,1,'Roman Catholic\r'),(36,'Johnson','Lyndon','Baines','1908-08-27','1973-01-22','Texas','Democratic','1963-11-22','1969-01-20',0,0,'Disciples of Christ\r'),(37,'Nixon','Richard','Milhous','1913-01-09','1994-04-22','California','Republican','1969-01-20','1974-08-09',0,0,'Quaker\r'),(38,'Ford','Gerald','Rudolph','1913-07-14','2006-12-26','Michigan','Republican','1974-08-09','1977-01-20',1,0,'Episcopalian\r'),(39,'Carter','Jimmy','','1924-10-01',NULL,'Georgia','Democratic','1977-01-20','1981-01-20',0,0,'Baptist\r'),(40,'Reagan','Ronald','Wilson','1911-02-06','2004-06-05','California','Republican','1981-01-20','1989-01-20',1,0,'Presbyterian\r'),(41,'Bush','George','Herbert Walker','1924-06-12',NULL,'Texas','Republican','1989-01-20','1993-01-20',0,0,'Episcopalian\r'),(42,'Clinton','William','Jefferson','1946-08-19',NULL,'Arkansas','Democratic','1993-01-20','2001-01-20',0,0,'Baptist\r'),(43,'Bush','George','Walker','1946-07-06',NULL,'Texas','Republican','2001-01-20','2009-01-20',0,0,'Methodist\r'),(44,'Obama','Barack','Hussein','1961-08-04',NULL,'Illinois','Democratic','2009-01-20',NULL,0,0,'Unaffiliated Christian');
/*!40000 ALTER TABLE `presidents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-02-15 10:42:18
