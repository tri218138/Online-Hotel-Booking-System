-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: hotelbooking
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `admin_id` varchar(36) NOT NULL,
  `cluster_no` int unsigned NOT NULL,
  PRIMARY KEY (`admin_id`),
  KEY `idx_admin` (`admin_id`,`cluster_no`),
  CONSTRAINT `admins_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `booking_id` varchar(36) DEFAULT NULL,
  `admin_id` varchar(36) DEFAULT NULL,
  `expected_payment_type` varchar(10) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` int unsigned NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bills_chk_1` CHECK (regexp_like(`id`,_utf8mb3'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')),
  CONSTRAINT `bills_chk_2` CHECK ((`expected_payment_type` in (_utf8mb3'CASH',_utf8mb3'CREDIT'))),
  CONSTRAINT `bills_chk_3` CHECK ((`status` in (_utf8mb3'PENDING',_utf8mb3'PAID',_utf8mb3'EXPIRED')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_revision`
--

DROP TABLE IF EXISTS `booking_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_revision` (
  `booking_id` varchar(36) NOT NULL,
  `admin_id` varchar(36) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(10) NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`booking_id`,`admin_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `booking_revision_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `booking_revision_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`),
  CONSTRAINT `booking_revision_chk_1` CHECK ((`status` in (_utf8mb3'PENDING',_utf8mb3'APPROVED',_utf8mb3'REJECTED')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_revision`
--

LOCK TABLES `booking_revision` WRITE;
/*!40000 ALTER TABLE `booking_revision` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_rooms`
--

DROP TABLE IF EXISTS `booking_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_rooms` (
  `booking_id` varchar(36) NOT NULL,
  `room_no` varchar(10) NOT NULL,
  `hotel_id` varchar(36) NOT NULL,
  PRIMARY KEY (`booking_id`,`room_no`,`hotel_id`),
  KEY `room_no` (`room_no`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `booking_rooms_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `booking_rooms_ibfk_2` FOREIGN KEY (`room_no`) REFERENCES `rooms` (`room_no`),
  CONSTRAINT `booking_rooms_ibfk_3` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_rooms`
--

LOCK TABLES `booking_rooms` WRITE;
/*!40000 ALTER TABLE `booking_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `user_id` varchar(36) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reward_points` int unsigned NOT NULL DEFAULT '0',
  `people` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `bookings_chk_1` CHECK (regexp_like(`id`,_utf8mb3'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')),
  CONSTRAINT `bookings_chk_2` CHECK ((`check_in` < `check_out`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES ('d41be4e1-7654-11ed-9cef-e454e8252f5c','2dadba14-7650-11ed-9cef-e454e8252f5c','2022-12-08','2022-12-20','2022-12-07 17:30:22',0,4),('f0c3fd21-7654-11ed-9cef-e454e8252f5c','42c38312-7650-11ed-9cef-e454e8252f5c','2022-12-08','2022-12-10','2022-12-07 17:31:10',1,3);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `city_id` varchar(10) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES ('0','Đà Lạt'),('1','Vũng Tàu'),('2','Nha Trang'),('3','Phú Quốc');
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `cid` varchar(36) NOT NULL,
  `points` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`cid`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_phone`
--

DROP TABLE IF EXISTS `hotel_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_phone` (
  `hotel_id` varchar(36) NOT NULL,
  `phone_number` varchar(10) NOT NULL,
  PRIMARY KEY (`hotel_id`,`phone_number`),
  CONSTRAINT `hotel_phone_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`),
  CONSTRAINT `hotel_phone_chk_1` CHECK (regexp_like(`phone_number`,_utf8mb3'^0[0-9]{9}$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_phone`
--

LOCK TABLES `hotel_phone` WRITE;
/*!40000 ALTER TABLE `hotel_phone` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_timing`
--

DROP TABLE IF EXISTS `hotel_timing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_timing` (
  `hotel_id` varchar(36) NOT NULL,
  `open` time NOT NULL,
  `close` time NOT NULL,
  PRIMARY KEY (`hotel_id`,`open`,`close`),
  CONSTRAINT `hotel_timing_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`),
  CONSTRAINT `hotel_timing_chk_1` CHECK ((`open` < `close`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_timing`
--

LOCK TABLES `hotel_timing` WRITE;
/*!40000 ALTER TABLE `hotel_timing` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotel_timing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotels` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `name` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  `desc` varchar(200) NOT NULL,
  `email` varchar(254) NOT NULL,
  `rating` int unsigned NOT NULL,
  `city_id` varchar(10) NOT NULL,
  `urlImageId` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `hotels_chk_1` CHECK (regexp_like(`id`,_utf8mb3'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')),
  CONSTRAINT `hotels_chk_2` CHECK ((`rating` between 1 and 5)),
  CONSTRAINT `hotels_chk_3` CHECK (regexp_like(`email`,_utf8mb3'^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotels`
--

LOCK TABLES `hotels` WRITE;
/*!40000 ALTER TABLE `hotels` DISABLE KEYS */;
INSERT INTO `hotels` VALUES ('08c701ba-7651-11ed-9cef-e454e8252f5c','Boton Blue Hotel & Spa','62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam','dd','d@c.com',5,'2','12ErGeQbcynlEMSYmZLsuD2larYZb7-_X'),('b47da5e5-764e-11ed-9cef-e454e8252f5c','Citadines Bayfront','62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam','aa','a@b.com',5,'2','15jX1xXlCnIOmpNOQIlKvzUz7WUQQj051'),('d73d4d04-764e-11ed-9cef-e454e8252f5c','Virgo Hotel','62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Đà Lạt, Việt Nam','bb','b@c.com',5,'0','173okLB1DJHIDra_DisuaB-7fpBrDoqyT'),('d73de9d9-764e-11ed-9cef-e454e8252f5c','Mường Thanh Luxury','62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Đà Lạt, Khánh Hòa, Việt Nam','cc','c@d.com',5,'0','1lwEa6NwurxPFaOy5MUcEXqrMIv0I2-O0');
/*!40000 ALTER TABLE `hotels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `url` varchar(100) NOT NULL,
  `hotel_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES ('12ErGeQbcynlEMSYmZLsuD2larYZb7-_X','08c701ba-7651-11ed-9cef-e454e8252f5c'),('15jX1xXlCnIOmpNOQIlKvzUz7WUQQj051','d73de9d9-764e-11ed-9cef-e454e8252f5c'),('173okLB1DJHIDra_DisuaB-7fpBrDoqyT','d73d4d04-764e-11ed-9cef-e454e8252f5c'),('1lwEa6NwurxPFaOy5MUcEXqrMIv0I2-O0','b47da5e5-764e-11ed-9cef-e454e8252f5c');
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `id` varchar(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `hashed_password` varchar(512) NOT NULL,
  `salt` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `login_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('2dadba14-7650-11ed-9cef-e454e8252f5c','customer0','customer0','0'),('42c38312-7650-11ed-9cef-e454e8252f5c','manager0','manager0','0'),('93cf8fe7-764d-11ed-9cef-e454e8252f5c','customer1','customer1','0');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `booking_id` varchar(36) NOT NULL,
  `cid` varchar(36) DEFAULT NULL,
  `actual_payment_type` varchar(10) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`booking_id`),
  KEY `cid` (`cid`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `customers` (`cid`),
  CONSTRAINT `payment_chk_1` CHECK ((`actual_payment_type` in (_utf8mb3'CASH',_utf8mb3'CREDIT')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_acc_customer`
--

DROP TABLE IF EXISTS `payment_acc_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_acc_customer` (
  `cid` varchar(36) DEFAULT NULL,
  `payment_provider` varchar(100) NOT NULL,
  `payment_acc` varchar(35) NOT NULL,
  PRIMARY KEY (`payment_provider`,`payment_acc`),
  KEY `cid` (`cid`),
  CONSTRAINT `payment_acc_customer_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `customers` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_acc_customer`
--

LOCK TABLES `payment_acc_customer` WRITE;
/*!40000 ALTER TABLE `payment_acc_customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_acc_customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_acc_hotel`
--

DROP TABLE IF EXISTS `payment_acc_hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_acc_hotel` (
  `hotel_id` varchar(36) DEFAULT NULL,
  `payment_provider` varchar(100) NOT NULL,
  `payment_acc` varchar(35) NOT NULL,
  PRIMARY KEY (`payment_provider`,`payment_acc`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `payment_acc_hotel_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_acc_hotel`
--

LOCK TABLES `payment_acc_hotel` WRITE;
/*!40000 ALTER TABLE `payment_acc_hotel` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_acc_hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_no` varchar(10) NOT NULL,
  `hotel_id` varchar(36) NOT NULL,
  `desc` varchar(200) NOT NULL,
  `capacity` int unsigned NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'AVAILABLE',
  `price` int unsigned NOT NULL,
  PRIMARY KEY (`room_no`,`hotel_id`),
  KEY `hotel_id` (`hotel_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`),
  CONSTRAINT `rooms_chk_1` CHECK ((`status` in (_utf8mb3'AVAILABLE',_utf8mb3'BOOKED',_utf8mb3'MAINTENANCE')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES ('room0','b47da5e5-764e-11ed-9cef-e454e8252f5c','đẹp',100,'AVAILABLE',1632958),('room1','d73d4d04-764e-11ed-9cef-e454e8252f5c','đẹp',100,'AVAILABLE',1000000),('room2','d73de9d9-764e-11ed-9cef-e454e8252f5c','tiện nghi',100,'AVAILABLE',1000000),('room3','d73de9d9-764e-11ed-9cef-e454e8252f5c','tuyệt',100,'AVAILABLE',1321333),('room4','08c701ba-7651-11ed-9cef-e454e8252f5c','ok',100,'AVAILABLE',1231231);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(36) NOT NULL DEFAULT (uuid()),
  `sex` char(1) NOT NULL DEFAULT 'M',
  `email` varchar(254) NOT NULL,
  `birth_year` int unsigned NOT NULL,
  `phone_number` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `citizen_id` varchar(12) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `citizen_id` (`citizen_id`),
  CONSTRAINT `users_chk_1` CHECK (regexp_like(`id`,_utf8mb4'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')),
  CONSTRAINT `users_chk_2` CHECK ((`sex` in (_utf8mb4'M',_utf8mb4'F'))),
  CONSTRAINT `users_chk_3` CHECK ((`birth_year` between 1900 and 2100)),
  CONSTRAINT `users_chk_4` CHECK (regexp_like(`phone_number`,_utf8mb4'^0[0-9]{9}$')),
  CONSTRAINT `users_chk_5` CHECK (regexp_like(`citizen_id`,_utf8mb4'^[0-9]{12}$')),
  CONSTRAINT `users_chk_6` CHECK (regexp_like(`email`,_utf8mb4'^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('2dadba14-7650-11ed-9cef-e454e8252f5c','M','a@gmail.com',2002,'0123123134','Thái','Trần','123456789013'),('42c38312-7650-11ed-9cef-e454e8252f5c','F','ac@ga.com',2001,'0123456788','Ty','Hym','123456713131'),('93cf8fe7-764d-11ed-9cef-e454e8252f5c','M','abc@example.com',2010,'0123456789','Trí','Cao','123456789012');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-08  1:14:54
