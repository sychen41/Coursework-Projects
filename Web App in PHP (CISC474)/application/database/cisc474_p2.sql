-- --------------------------------------------------------
-- Host:                         iceball
-- Server version:               5.1.66-0+squeeze1 - (Debian)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             8.0.0.4396
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table cisc474_p2.auditlogs
CREATE TABLE IF NOT EXISTS `auditlogs` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `action_name` varchar(200) NOT NULL,
  `action_date` datetime NOT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

-- Dumping data for table cisc474_p2.auditlogs: ~2 rows (approximately)
/*!40000 ALTER TABLE `auditlogs` DISABLE KEYS */;
INSERT INTO `auditlogs` (`log_id`, `user_id`, `action_name`, `action_date`) VALUES
	(1, 1, 'User admin set a new pen width.', '2014-03-06 18:58:17'),
	(2, 1, 'User admin set a new pen width.', '2014-03-06 19:10:46'),
	(3, 1, 'User admin set a new pen width.', '2014-03-06 19:22:42'),
	(4, 1, 'User test has been saved.', '2014-03-06 19:25:13'),
	(5, 1, 'User becomes user_id 2', '2014-03-06 19:25:25'),
	(6, 2, 'User becomes user_id 2', '2014-03-06 19:25:56'),
	(7, 2, 'User becomes user_id 2', '2014-03-06 19:26:21'),
	(8, 2, 'User test set a new pen width.', '2014-03-06 19:26:24'),
	(9, 2, 'User test set a new pen width.', '2014-03-06 19:27:00'),
	(10, 2, 'User test set a new pen width.', '2014-03-06 19:27:02'),
	(11, 2, 'Log Out', '2014-03-06 19:27:37'),
	(12, 1, 'Log in by admin from 198.168.1.13', '2014-03-06 19:27:41'),
	(13, 1, 'Deleted User with ID 2', '2014-03-06 19:28:29'),
	(14, 1, 'User mega has been saved.', '2014-03-06 19:28:36'),
	(15, 1, 'User becomes user_id 3', '2014-03-06 19:28:45'),
	(16, 3, 'User mega set a new pen width.', '2014-03-06 19:28:50'),
	(17, 1, 'User admin set a new pen width.', '2014-03-06 19:50:37'),
	(18, 1, 'User admin set a new pen width.', '2014-03-06 19:57:37'),
	(19, 1, 'User admin set a new pen width.', '2014-03-06 19:58:01'),
	(20, 1, 'User admin set a new pen width.', '2014-03-06 19:58:17'),
	(21, 1, 'admin added a new document gtrf', '2014-03-06 20:09:23'),
	(22, 1, 'admin added a new document NewDoc', '2014-03-06 20:09:41');
/*!40000 ALTER TABLE `auditlogs` ENABLE KEYS */;


-- Dumping structure for table cisc474_p2.documents
CREATE TABLE IF NOT EXISTS `documents` (
  `document_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` text NOT NULL,
  `content` text,
  `signature` text,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`document_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table cisc474_p2.documents: 0 rows
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` (`document_id`, `user_id`, `title`, `content`, `signature`, `date_added`) VALUES
	(1, 1, 'gtrf', '', '[{"lx":49,"ly":18,"mx":49,"my":17},{"lx":49,"ly":19,"mx":49,"my":18},{"lx":50,"ly":20,"mx":49,"my":19},{"lx":51,"ly":21,"mx":50,"my":20},{"lx":55,"ly":22,"mx":51,"my":21},{"lx":57,"ly":24,"mx":55,"my":22},{"lx":63,"ly":25,"mx":57,"my":24},{"lx":65,"ly":25,"mx":63,"my":25},{"lx":69,"ly":26,"mx":65,"my":25},{"lx":71,"ly":26,"mx":69,"my":26},{"lx":72,"ly":26,"mx":71,"my":26},{"lx":73,"ly":26,"mx":72,"my":26},{"lx":74,"ly":26,"mx":73,"my":26},{"lx":63,"ly":23,"mx":63,"my":22},{"lx":60,"ly":22,"mx":63,"my":23},{"lx":56,"ly":22,"mx":60,"my":22},{"lx":48,"ly":22,"mx":56,"my":22},{"lx":46,"ly":22,"mx":48,"my":22},{"lx":43,"ly":22,"mx":46,"my":22},{"lx":41,"ly":23,"mx":43,"my":22},{"lx":38,"ly":24,"mx":41,"my":23},{"lx":37,"ly":25,"mx":38,"my":24},{"lx":36,"ly":26,"mx":37,"my":25},{"lx":34,"ly":27,"mx":36,"my":26},{"lx":33,"ly":29,"mx":34,"my":27},{"lx":33,"ly":30,"mx":33,"my":29},{"lx":32,"ly":31,"mx":33,"my":30},{"lx":32,"ly":32,"mx":32,"my":31},{"lx":31,"ly":33,"mx":32,"my":32},{"lx":30,"ly":34,"mx":31,"my":33},{"lx":29,"ly":34,"mx":30,"my":34},{"lx":29,"ly":35,"mx":29,"my":34},{"lx":28,"ly":35,"mx":29,"my":35}]', '2014-03-06 20:09:23'),
	(2, 1, 'NewDoc', 'Some Content!', '[{"lx":59,"ly":37,"mx":59,"my":36},{"lx":57,"ly":35,"mx":59,"my":37},{"lx":55,"ly":34,"mx":57,"my":35},{"lx":51,"ly":33,"mx":55,"my":34},{"lx":43,"ly":30,"mx":51,"my":33},{"lx":40,"ly":29,"mx":43,"my":30},{"lx":38,"ly":29,"mx":40,"my":29},{"lx":37,"ly":29,"mx":38,"my":29},{"lx":36,"ly":29,"mx":37,"my":29},{"lx":35,"ly":29,"mx":36,"my":29},{"lx":34,"ly":29,"mx":35,"my":29},{"lx":33,"ly":29,"mx":34,"my":29},{"lx":32,"ly":29,"mx":33,"my":29},{"lx":31,"ly":29,"mx":32,"my":29},{"lx":30,"ly":29,"mx":31,"my":29},{"lx":29,"ly":29,"mx":30,"my":29},{"lx":29,"ly":31,"mx":29,"my":29},{"lx":29,"ly":35,"mx":29,"my":31},{"lx":28,"ly":37,"mx":29,"my":35},{"lx":28,"ly":38,"mx":28,"my":37},{"lx":28,"ly":39,"mx":28,"my":38},{"lx":28,"ly":40,"mx":28,"my":39},{"lx":29,"ly":41,"mx":28,"my":40},{"lx":30,"ly":43,"mx":29,"my":41},{"lx":31,"ly":43,"mx":30,"my":43},{"lx":35,"ly":44,"mx":31,"my":43},{"lx":36,"ly":44,"mx":35,"my":44},{"lx":39,"ly":44,"mx":36,"my":44},{"lx":40,"ly":44,"mx":39,"my":44},{"lx":42,"ly":44,"mx":40,"my":44},{"lx":43,"ly":44,"mx":42,"my":44},{"lx":44,"ly":44,"mx":43,"my":44},{"lx":46,"ly":44,"mx":44,"my":44},{"lx":49,"ly":44,"mx":46,"my":44},{"lx":51,"ly":43,"mx":49,"my":44},{"lx":52,"ly":42,"mx":51,"my":43},{"lx":54,"ly":41,"mx":52,"my":42},{"lx":55,"ly":40,"mx":54,"my":41},{"lx":58,"ly":38,"mx":55,"my":40},{"lx":59,"ly":37,"mx":58,"my":38},{"lx":60,"ly":34,"mx":59,"my":37},{"lx":61,"ly":32,"mx":60,"my":34},{"lx":61,"ly":29,"mx":61,"my":32},{"lx":61,"ly":27,"mx":61,"my":29},{"lx":61,"ly":26,"mx":61,"my":27},{"lx":61,"ly":25,"mx":61,"my":26},{"lx":60,"ly":24,"mx":61,"my":25},{"lx":59,"ly":24,"mx":60,"my":24},{"lx":58,"ly":23,"mx":59,"my":24},{"lx":53,"ly":22,"mx":58,"my":23},{"lx":51,"ly":22,"mx":53,"my":22},{"lx":48,"ly":20,"mx":51,"my":22},{"lx":44,"ly":20,"mx":48,"my":20},{"lx":41,"ly":20,"mx":44,"my":20},{"lx":37,"ly":20,"mx":41,"my":20},{"lx":34,"ly":20,"mx":37,"my":20},{"lx":32,"ly":20,"mx":34,"my":20},{"lx":27,"ly":20,"mx":32,"my":20},{"lx":26,"ly":20,"mx":27,"my":20},{"lx":25,"ly":20,"mx":26,"my":20},{"lx":24,"ly":20,"mx":25,"my":20},{"lx":23,"ly":20,"mx":24,"my":20},{"lx":22,"ly":21,"mx":23,"my":20},{"lx":21,"ly":23,"mx":22,"my":21},{"lx":19,"ly":24,"mx":21,"my":23},{"lx":18,"ly":25,"mx":19,"my":24},{"lx":14,"ly":28,"mx":18,"my":25},{"lx":13,"ly":29,"mx":14,"my":28},{"lx":12,"ly":30,"mx":13,"my":29},{"lx":11,"ly":31,"mx":12,"my":30},{"lx":11,"ly":32,"mx":11,"my":31},{"lx":11,"ly":33,"mx":11,"my":32},{"lx":11,"ly":34,"mx":11,"my":33},{"lx":12,"ly":35,"mx":11,"my":34},{"lx":15,"ly":35,"mx":12,"my":35},{"lx":16,"ly":36,"mx":15,"my":35},{"lx":18,"ly":36,"mx":16,"my":36},{"lx":19,"ly":37,"mx":18,"my":36},{"lx":23,"ly":38,"mx":19,"my":37},{"lx":27,"ly":38,"mx":23,"my":38},{"lx":28,"ly":38,"mx":27,"my":38},{"lx":30,"ly":38,"mx":28,"my":38},{"lx":32,"ly":38,"mx":30,"my":38},{"lx":34,"ly":38,"mx":32,"my":38},{"lx":35,"ly":38,"mx":34,"my":38},{"lx":37,"ly":37,"mx":35,"my":38},{"lx":40,"ly":35,"mx":37,"my":37},{"lx":41,"ly":33,"mx":40,"my":35},{"lx":42,"ly":32,"mx":41,"my":33},{"lx":42,"ly":31,"mx":42,"my":32},{"lx":42,"ly":29,"mx":42,"my":31},{"lx":42,"ly":28,"mx":42,"my":29},{"lx":42,"ly":27,"mx":42,"my":28},{"lx":42,"ly":26,"mx":42,"my":27},{"lx":42,"ly":25,"mx":42,"my":26},{"lx":42,"ly":24,"mx":42,"my":25},{"lx":42,"ly":23,"mx":42,"my":24},{"lx":41,"ly":23,"mx":42,"my":23},{"lx":40,"ly":23,"mx":41,"my":23},{"lx":39,"ly":23,"mx":40,"my":23},{"lx":37,"ly":23,"mx":39,"my":23},{"lx":35,"ly":23,"mx":37,"my":23},{"lx":28,"ly":23,"mx":35,"my":23},{"lx":26,"ly":23,"mx":28,"my":23},{"lx":23,"ly":23,"mx":26,"my":23},{"lx":21,"ly":24,"mx":23,"my":23},{"lx":19,"ly":24,"mx":21,"my":24},{"lx":17,"ly":24,"mx":19,"my":24}]', '2014-03-06 20:09:41');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;


-- Dumping structure for table cisc474_p2.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `password` text NOT NULL,
  `email` varchar(200) NOT NULL,
  `group` int(11) NOT NULL,
  `last_login` datetime NOT NULL,
  `created_on` datetime NOT NULL,
  `pen_thickness` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table cisc474_p2.users: ~1 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`user_id`, `name`, `password`, `email`, `group`, `last_login`, `created_on`, `pen_thickness`) VALUES
	(1, 'admin', 'test', 'test@test.com', 100, '2014-03-06 19:27:40', '2014-03-14 15:21:31', '5'),
	(3, 'mega', 'test', 'test@test.com', 1, '0000-00-00 00:00:00', '2014-03-06 19:28:36', '18');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
