-- Задание 1. Доработать БД Vk.
-- Задание 2. Заполнить новые таблицы.
-- Задание 3. Повторить все действия CRUD.

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

SHOW tables;

SELECT * FROM users LIMIT 10;

DESC users;

UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;

SELECT * FROM profiles LIMIT 10;

CREATE TEMPORARY TABLE genders (name CHAR(1));

INSERT INTO genders VALUES ('M'), ('F');

UPDATE profiles SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);

CREATE TABLE user_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    name VARCHAR(100) NOT NULL COMMENT "Название статуса (уникально)",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Справочник статусов";

INSERT INTO user_statuses (name) VALUES
	('single'),
	('married');
SELECT * FROM user_statuses;

UPDATE profiles SET status = null;

ALTER TABLE profiles RENAME COLUMN status TO user_status_id; 

ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED; 

UPDATE profiles SET user_status_id = (SELECT id FROM user_statuses ORDER BY RAND() LIMIT 1);

SHOW TABLES;

DESC messages;

ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body; 

SELECT * FROM messages LIMIT 10;

UPDATE messages SET 
	from_user_id = FLOOR(1 + RAND() * 100),
	to_user_id = FLOOR(1 + RAND() * 100);

UPDATE messages SET  media_id = FLOOR(1 + RAND() * 100);

UPDATE messages SET updated_at = NOW() WHERE updated_at < created_at;   

DESC media;

SELECT * FROM media LIMIT 20;

UPDATE media SET user_id = FLOOR(1 + RAND() * 100);
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

DROP TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

SELECT * FROM extensions;

UPDATE media SET filename = CONCAT(
	'http://dropbox.net/vk/',
	filename,
	'.',
	(SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

UPDATE media SET metadata = CONCAT('{"owner":"', 
	(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
	'"}');  

ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM media_types;

TRUNCATE media_types;

INSERT INTO media_types SET name = 'photo';
INSERT INTO media_types SET name = 'video';
INSERT INTO media_types SET name = 'audio';

SELECT * FROM media LIMIT 10;

UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

SELECT * FROM friendship LIMIT 10;

/*!40000 ALTER TABLE `friendship` DISABLE KEYS */;
UPDATE friendship SET 
	user_id = FLOOR(1 + RAND() * 100),
	friend_id = FLOOR(1 + RAND() * 100);

UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;
/*!40000 ALTER TABLE `friendship` ENABLE KEYS */;
 
SELECT * FROM friendship_statuses;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
	('Requested'),
	('Confirmed'),
	('Rejected');

UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 

SELECT * FROM communities;

DELETE FROM communities WHERE id > 20;

SELECT * FROM communities_users;

UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);
DELETE FROM communities_users WHERE community_id > 100;

/* CREATE TABLE friendship_statuses_new LIKE friendship_statuses; 
INSERT INTO friendship_statuses_new SELECT * FROM friendship_statuses;
SELECT * FROM friendship_statuses_new;

CREATE TABLE friendship_statuses_new2 AS SELECT * FROM friendship_statuses;
SELECT * FROM friendship_statuses_new2; */

-- Задание 1. Доработать БД Vk.
-- Задание 2. Заполнить новые таблицы.
-- Задание 3. Повторить все действия CRUD.

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Текст поста',
  `attachment_id` int(10) unsigned DEFAULT NULL COMMENT 'Ссылка на медиафайл, прикрепленный к посту (если есть)',
  `user_id` int(10) unsigned NOT NULL COMMENT 'Ссылка на пользователя, который сделал пост',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `attachment_id` (`attachment_id`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'Aut sit necessitatibus aut qui. Enim nihil officiis rerum inventore recusandae aperiam fuga quas.',1,1,'1999-03-11 04:22:43','1994-09-21 06:07:15'),(2,'Rerum in fuga illum molestiae pariatur eveniet. Animi aut dolorum animi similique ut nulla alias nisi.',2,2,'1998-03-01 20:04:50','2015-03-22 20:00:13'),(3,'Odit suscipit atque dolorem sunt sequi. Ipsum commodi ratione explicabo doloribus ducimus explicabo. Sint ut eos voluptatem et cum eveniet libero.',3,3,'1996-10-19 12:56:51','1975-12-03 23:32:06'),(4,'Praesentium ex ipsam corrupti modi aliquid occaecati. Rerum et quo dolorem magni facilis consequuntur. Est aut quae sint rem est est. Hic aliquam quibusdam totam cum quia reprehenderit.',4,4,'2008-02-19 18:15:41','1992-08-07 04:51:28'),(5,'Fuga neque qui placeat assumenda voluptas sunt id. Tenetur molestias voluptatibus rem vero est quas alias. Quisquam nemo debitis ex voluptas optio similique.',5,5,'1980-05-28 09:36:47','1999-11-23 03:28:27'),(6,'Voluptatum perferendis autem amet nihil laborum nisi est illo. Et sed maxime sit voluptatem animi velit a cum. Debitis neque non non molestiae illum quo. Similique explicabo aperiam eos consequatur voluptate cum.',6,6,'1983-07-14 09:00:43','2021-01-05 14:07:50'),(7,'Et quia nulla sed vero dolor. Officia omnis mollitia error dignissimos reiciendis tenetur.',7,7,'1998-12-02 20:16:43','1986-05-23 22:34:11'),(8,'Unde quo est iure ut ratione ut qui molestiae. Cupiditate eum eum soluta est ut suscipit rerum et. Soluta quia vel quia doloribus. Et quibusdam qui aut sint. Ut error mollitia quia aliquid quasi voluptas sunt.',8,8,'2008-12-08 06:55:22','1990-05-13 20:04:44'),(9,'Voluptas sed in eius qui. Cumque qui temporibus dignissimos totam earum dicta et. Incidunt delectus doloribus consequatur architecto.',9,9,'1978-03-05 17:29:00','1989-11-05 06:09:22'),(10,'Sint reprehenderit doloribus aliquam qui. Qui voluptas quia commodi veritatis corrupti deserunt vero. Eos nesciunt animi qui impedit dolorum laboriosam.',10,10,'1976-02-23 21:32:59','1998-07-30 03:45:06'),(11,'Fugiat voluptas beatae temporibus dolor. Error modi omnis perferendis at est corporis vel. In non voluptatem voluptatum vitae. Architecto aut placeat quidem voluptatibus molestiae in autem accusantium. Est quam nesciunt fuga aut nobis itaque rerum quia.',11,11,'1998-12-03 13:07:48','2001-05-04 11:21:37'),(12,'Asperiores qui repellat omnis dolor quia et quasi. Molestiae et et sint velit. Quod laudantium a sunt quidem tempore.',12,12,'2017-10-12 13:57:45','1979-06-18 04:36:54'),(13,'Fuga minus velit ipsa corrupti velit. Tempora laboriosam unde vero vel tempore ut. Eius non odio saepe iste harum aperiam sed magnam.',13,13,'1979-09-12 22:04:06','1972-09-06 04:20:29'),(14,'Eum eveniet atque quo accusamus. Omnis aperiam voluptate in. Sed corrupti est ullam assumenda non.',14,14,'2012-01-27 04:28:44','2008-07-13 11:29:21'),(15,'Eos assumenda quo hic doloribus harum quia saepe quo. Temporibus et voluptatum aliquam.',15,15,'2000-10-24 04:57:24','1992-01-28 22:48:28'),(16,'Vero debitis distinctio qui blanditiis provident sunt ab. Ut esse reprehenderit dignissimos aliquam nobis iure quia. Ad aut iste enim molestias praesentium sint.',16,16,'1975-11-03 03:01:19','2007-07-08 16:13:29'),(17,'Ut id atque doloribus. Eveniet reprehenderit quia animi explicabo. Recusandae rerum ut assumenda possimus adipisci cumque et.',17,17,'2010-02-18 14:34:41','1985-04-20 21:32:23'),(18,'Voluptatem rem nostrum expedita ea itaque tempore. Aut non quibusdam non sit sint ipsam vel unde. Nihil consequatur asperiores sint nemo.',18,18,'1972-12-08 18:42:52','1972-02-11 20:37:20'),(19,'Voluptatibus sint quia cupiditate et voluptatum. Aut debitis quia tempore quasi nemo. Earum voluptatibus sed quia harum repellat voluptas aut. Ex vel enim quos sequi ullam iure.',19,19,'1998-01-26 11:06:25','2020-11-14 20:47:26'),(20,'Quo occaecati et quia libero at aut. Fuga soluta asperiores est ad minima eaque. Veniam distinctio quas facilis rerum nesciunt dolores suscipit unde.',20,20,'1983-12-08 10:16:29','2012-05-10 17:03:48'),(21,'Fuga eos quis ea et assumenda quibusdam accusamus. Aut nemo quae sed dolores est sit placeat.',21,21,'1991-01-20 23:07:20','1992-10-15 18:58:52'),(22,'Alias praesentium minima quia porro accusantium amet. Asperiores ipsa voluptas impedit porro eos mollitia rerum. Similique sit inventore eius iusto molestiae labore. Non assumenda at molestias in ex minima.',22,22,'1990-09-15 12:49:01','1993-10-16 18:30:15'),(23,'Ut voluptatem ratione et occaecati. Non eos illum molestiae. Veniam quos voluptate sint ab. Perspiciatis velit aut nostrum blanditiis dolores nostrum sit.',23,23,'1977-05-02 20:37:18','2006-06-02 21:11:30'),(24,'Eveniet aspernatur at non quis. Quis consequatur perspiciatis perferendis. Ut voluptas expedita molestias delectus quis cupiditate. Velit in placeat recusandae perspiciatis et. Consequuntur eum pariatur quasi est molestiae ipsam voluptates.',24,24,'1997-09-24 08:07:16','2018-05-11 16:45:26'),(25,'Hic voluptatem commodi dolores tenetur. Rerum id veritatis iure qui provident a est. Et ipsam natus aut numquam dolores optio quia. Non sequi accusamus non numquam.',25,25,'1984-12-08 00:32:50','2000-06-30 23:35:49'),(26,'Dolores magni molestiae dolore quasi. Qui laboriosam doloremque autem ratione qui sit. Nemo cumque nam minima dolor corporis quibusdam. Totam atque voluptatem deleniti et autem neque deleniti.',26,26,'2012-01-08 19:40:21','2013-03-29 00:17:51'),(27,'Sit animi alias alias sed quae eos soluta. Soluta ex ut sequi est error doloribus dolorem id. Ab quam qui temporibus aut temporibus repudiandae sed.',27,27,'2008-09-15 02:54:40','1993-06-30 10:44:24'),(28,'Itaque doloribus consectetur eius itaque aut. Ullam ut veniam est officiis non eligendi.',28,28,'1977-10-29 05:02:20','1975-11-28 23:22:35'),(29,'Officia debitis quaerat blanditiis eos quos voluptatem. Dolor autem soluta in natus occaecati quam.',29,29,'2012-12-06 12:28:37','2016-02-04 11:07:55'),(30,'Consectetur maxime assumenda et autem. Incidunt consequatur unde aperiam aut eaque a modi occaecati. Atque natus eius est.',30,30,'2010-05-13 09:52:49','2020-04-06 03:19:56'),(31,'Est aliquid aut omnis iure et eius impedit. Distinctio quia earum distinctio magni alias accusamus suscipit. Rerum incidunt iure sint cum pariatur et aut.',31,31,'2002-06-01 23:29:38','1994-08-12 23:43:15'),(32,'Itaque ut est ut a eveniet rerum vitae harum. Et quaerat rerum recusandae quo. Eius optio ut eveniet assumenda id sapiente. Et itaque soluta sequi cum et qui. Non voluptatem mollitia sint voluptas ullam enim vitae voluptatem.',32,32,'1974-07-14 16:32:40','1995-06-25 13:50:43'),(33,'Voluptatem fuga ipsa odit cupiditate voluptatem cum provident. Ab amet fuga similique et et atque fugiat. Ea exercitationem fuga voluptatibus autem est. Est mollitia doloremque dolor repellendus.',33,33,'2020-03-22 03:16:25','1983-11-26 01:40:31'),(34,'Officiis voluptate cupiditate illo non. Dolores illo corporis error occaecati perferendis aut assumenda. Velit et ullam quidem voluptatem libero tempore qui. Voluptatem fugiat accusantium et in est velit maiores.',34,34,'1996-04-13 17:39:41','1974-09-03 14:22:18'),(35,'Id assumenda est et amet tenetur ea. Aut nisi aut vero in. Quasi delectus molestiae sunt nemo. Qui qui eum est dolor omnis ut fuga.',35,35,'2012-09-22 01:18:33','1981-02-10 20:08:52'),(36,'Facere deleniti quo et repellendus. Consequatur sunt sunt ut assumenda. Magnam cum minus sed beatae.',36,36,'1996-03-23 03:27:23','2006-08-01 19:16:10'),(37,'Repellendus veritatis temporibus quo officia iste mollitia sint. Assumenda nobis aut et accusantium ut. Non recusandae neque consequatur harum temporibus sequi. Totam temporibus quos aut rerum dignissimos.',37,37,'1978-12-11 09:49:27','2014-01-27 02:35:55'),(38,'Delectus eum ullam ut omnis impedit. Ut quia earum ut dicta animi unde. Maxime sit quia quia sit sit. Unde soluta cumque autem impedit nihil.',38,38,'1983-05-22 01:20:03','1977-02-15 18:05:15'),(39,'Sit aut enim deserunt incidunt nesciunt est iusto. Aut dicta quo necessitatibus voluptatibus. Consequatur reiciendis totam et enim consectetur sit. Ut ipsa necessitatibus consectetur repudiandae pariatur ipsam deleniti.',39,39,'1974-05-12 20:58:13','2005-10-23 18:09:49'),(40,'Ea modi quia magni repellendus qui. Ut quas consequuntur maxime sed corrupti adipisci. Culpa dolorem quisquam accusantium eligendi et rerum.',40,40,'1993-12-21 09:05:34','1985-12-31 17:43:10'),(41,'Qui reprehenderit autem maxime accusamus eum amet. Magnam aut quis est reprehenderit. Quam est quas rerum qui dolore. Dolores numquam quam modi voluptas et iusto.',41,41,'1989-05-08 21:15:03','2012-05-19 23:15:32'),(42,'Error hic quis voluptatem iste. Eligendi cupiditate et dolorem excepturi. Enim qui ea dolore voluptates ducimus est. Quis qui labore ipsam delectus necessitatibus sunt.',42,42,'1975-04-13 08:34:16','1985-06-09 04:23:54'),(43,'Quos possimus unde adipisci at rem laudantium quidem. Corrupti sequi et excepturi.',43,43,'1974-03-28 21:34:41','1989-01-07 14:34:54'),(44,'Nihil eveniet aut expedita qui quas. Harum quia quod quas libero quis voluptatem. Et ut id corrupti impedit aliquid vel vel. Excepturi aliquam blanditiis omnis quis rerum.',44,44,'1976-06-05 07:01:43','2012-01-22 16:06:11'),(45,'At quibusdam expedita ut perspiciatis sed autem architecto et. Vero sunt libero velit quod odit. Modi ut distinctio saepe consequuntur. Sed animi tempora cumque quod error et doloribus.',45,45,'2002-08-12 02:33:21','2002-03-18 05:43:45'),(46,'Velit voluptatum sed unde dolor quae dolorem deserunt. Ea blanditiis enim assumenda ut adipisci aspernatur cumque corporis. Alias soluta qui delectus rem est itaque. Doloremque amet et voluptatem adipisci ipsum totam.',46,46,'1972-04-24 10:40:36','2018-10-02 07:38:01'),(47,'Optio praesentium ex vel quibusdam vitae tempora ut. Eum quis aut minus rem consequuntur et reiciendis. Eum et placeat blanditiis doloremque.',47,47,'1985-09-21 18:33:42','2009-02-27 13:25:15'),(48,'Qui molestiae et totam harum earum. Et voluptas et omnis illum distinctio pariatur.',48,48,'1971-05-30 10:07:09','1970-10-31 03:10:45'),(49,'Et corporis est reprehenderit ipsa. Laudantium voluptatem quaerat non recusandae vel repudiandae veniam. Molestiae laborum non odio nostrum dolor voluptatem aut. Enim eum numquam voluptas ipsum magnam impedit necessitatibus.',49,49,'1973-07-15 08:03:36','1981-02-06 23:20:19'),(50,'Atque ut quia laudantium expedita consequatur fuga alias. Quas ea alias similique tempora voluptatibus odio. Quia enim dicta at omnis eum.',50,50,'1973-06-25 02:52:57','1981-12-30 04:02:44'),(51,'Facilis omnis ratione itaque officia asperiores aut. Aliquam modi consequatur provident sint saepe ut quis. Pariatur dolorem veritatis aut ut esse et illum.',51,51,'1980-09-01 07:08:22','1986-09-30 19:24:29'),(52,'In sit vero et ut deserunt. Ea aut ipsam sunt aut. Voluptatem neque mollitia provident enim quo voluptas.',52,52,'2011-11-19 22:31:03','1982-02-17 12:52:46'),(53,'Deleniti tenetur accusamus quia dolore qui sunt non quasi. Voluptas nihil ex a. Omnis eveniet eum qui sapiente repellendus. Accusantium nostrum voluptatibus corporis eos iure.',53,53,'1974-08-05 04:13:18','2016-11-04 13:21:14'),(54,'Quam sed veritatis et ut. Cupiditate blanditiis sit laboriosam est laudantium quas. Veniam explicabo tenetur magnam aspernatur. Enim repellat quidem occaecati deleniti.',54,54,'1977-03-08 14:07:53','1972-03-28 19:07:40'),(55,'Unde numquam corporis quaerat. Nihil quisquam rem ipsum ad illo omnis consectetur. Ducimus quibusdam magni culpa dignissimos non at ut. Voluptatem ullam autem adipisci quod.',55,55,'1982-05-07 09:54:10','1971-04-18 14:59:50'),(56,'Fuga consequatur voluptas consequatur voluptate nemo voluptatem. Eum sed delectus non ullam. Minima est aut quibusdam praesentium.',56,56,'2019-01-27 21:32:31','1995-08-14 08:28:07'),(57,'Nesciunt nesciunt doloribus culpa est eos qui impedit quia. Ab dolor molestias in. Aspernatur velit repellat suscipit omnis ducimus. Blanditiis nam hic quisquam et quo cumque.',57,57,'1992-03-12 10:46:43','2000-11-18 07:16:09'),(58,'Iste repellat illo eos quis ipsam vel. Qui qui et qui et quae aut. Nobis minus explicabo fugit unde. Ad enim sit incidunt eligendi enim aut assumenda. Perferendis non quidem et sint reprehenderit facere ad.',58,58,'1976-07-30 04:29:11','1975-11-02 15:57:11'),(59,'Minima in sit voluptates excepturi quos. Nulla veritatis reprehenderit explicabo. Libero odio aliquid veritatis qui.',59,59,'1979-09-27 03:23:40','1981-10-13 02:43:32'),(60,'Quam rerum nihil porro consectetur voluptas. Odit eum magnam sit quod. Nisi accusamus enim vel sunt pariatur voluptatem. Eaque asperiores consequatur at accusamus ab.',60,60,'1985-01-27 21:57:46','1986-07-26 23:03:00'),(61,'Aperiam sint aperiam sequi blanditiis et praesentium. Tempore ut non error eos repudiandae et. Repellat qui iusto reiciendis qui neque in. Temporibus ratione cupiditate tenetur qui et sequi. Nihil nobis quod delectus quam voluptatibus et.',61,61,'1994-02-11 20:19:05','1999-04-25 12:01:32'),(62,'Itaque eos quae culpa facilis. Dolor nihil eius vitae sapiente ut. Illum quas aut ratione ea et veniam neque quos.',62,62,'1983-03-24 15:39:41','2020-08-28 01:47:54'),(63,'Deserunt provident necessitatibus et architecto voluptatem. Laborum aut eos autem maxime. Et eos quos beatae ex aliquid delectus sequi. Quia voluptatem ut explicabo magni sit.',63,63,'2020-08-09 05:17:51','1976-01-09 17:47:27'),(64,'Autem et aut distinctio nam. Voluptatibus quos vel sit qui tempore consequatur ea. Quo fuga autem numquam hic. Aut similique hic quo reiciendis tempore et aperiam ab.',64,64,'2015-01-23 19:13:57','2017-03-22 07:24:00'),(65,'Doloribus consectetur cupiditate magnam consequuntur. Veniam commodi reiciendis odio aut libero. Iste provident consequatur voluptas nihil aliquid sed enim.',65,65,'1992-06-09 13:04:40','1993-07-02 04:57:16'),(66,'Aut ut dolore tenetur voluptatem minus harum. Voluptatem beatae magni cumque consequatur reiciendis. Dolores provident explicabo facere porro id error. Molestias qui illo ad velit fugit qui. Dolores omnis maxime aut.',66,66,'1991-06-18 23:48:35','2016-09-24 01:11:21'),(67,'Impedit ullam hic optio dolor soluta suscipit maxime. Velit ut et impedit quae dolorum dicta. Accusamus nihil rem ipsam tempora repudiandae atque sed.',67,67,'1971-11-16 13:11:44','1991-10-12 01:04:45'),(68,'Accusamus sint reiciendis vel quod consequatur. Quae qui ipsam possimus.',68,68,'1980-01-02 04:52:44','2012-12-01 11:39:23'),(69,'Est aliquam aut officiis minus eos. Ipsa cupiditate id earum dolorum numquam veniam. Consequuntur consequuntur in incidunt mollitia quis adipisci.',69,69,'1990-04-28 03:36:44','2000-05-10 22:16:19'),(70,'Facilis beatae et molestias consequatur. Omnis aut tempora facilis et rerum et. Doloribus perferendis consectetur autem. Natus placeat quisquam natus placeat.',70,70,'2016-09-20 22:31:33','2006-05-13 12:59:50'),(71,'Inventore suscipit enim molestias eum. Ex accusamus qui fugit quia deleniti est autem. Nisi perferendis non ut illum quis omnis qui.',71,71,'1973-10-29 04:31:23','1982-07-16 03:24:56'),(72,'Dolorem voluptates nihil ratione modi voluptates aut. Nobis labore saepe ipsum. Qui quisquam culpa ea necessitatibus placeat.',72,72,'2003-12-20 02:44:17','2003-03-16 12:17:33'),(73,'Perspiciatis provident fugiat fugit molestias vero cum. Quo qui hic consequatur debitis veniam ducimus quisquam.',73,73,'1989-03-24 22:31:51','2017-09-27 00:06:12'),(74,'Nulla rem iste atque beatae. Excepturi necessitatibus ut maiores sit et quibusdam itaque. Error sint ipsum natus corporis rerum hic. Quae quas provident voluptas fuga qui aliquam.',74,74,'1977-06-11 00:40:07','2010-03-26 15:23:54'),(75,'Iusto eligendi reprehenderit itaque occaecati aut. Et suscipit illo et ut tempore. Porro ea recusandae minima.',75,75,'2010-12-12 20:44:20','1994-11-08 05:19:33'),(76,'Ipsa consequatur aut fuga repellat. Minima odio iste praesentium earum harum.',76,76,'1973-07-12 22:32:37','1988-07-14 03:11:10'),(77,'Tempore neque minima itaque. Recusandae tenetur nam natus velit ex. Ad eaque ipsam eaque molestias. Sunt et fugiat maxime fugiat quia.',77,77,'1985-04-11 07:58:03','1996-04-24 05:45:48'),(78,'Sit unde consequuntur odio reiciendis. Vitae eos consequatur eos esse laborum rerum at. A nam porro voluptatem. Nesciunt et iure earum quae.',78,78,'2011-07-12 10:35:56','1993-03-13 19:23:33'),(79,'Nostrum fuga sed perferendis id aut et hic. Dolore iure consectetur voluptatibus quibusdam. Atque placeat et aut et.',79,79,'1975-06-11 02:14:42','1978-06-15 12:12:55'),(80,'Asperiores ea quos quae occaecati est corrupti. Deserunt praesentium saepe sit sunt sit pariatur quia. Dicta minima magni minus occaecati sed consequatur. Dolore laborum ut in doloribus autem deserunt ut.',80,80,'2004-05-22 06:05:58','1977-12-31 00:56:31'),(81,'Mollitia cumque quo adipisci nam. Aut molestias optio recusandae excepturi sit commodi. Mollitia molestias non eius ipsa deleniti. Quia deleniti cumque temporibus ea aspernatur.',81,81,'1972-12-25 17:28:17','2006-08-04 19:56:23'),(82,'Eum reiciendis veniam explicabo doloribus et aut alias placeat. Ut consequatur incidunt voluptatem ipsam ea. Explicabo tempore nesciunt natus voluptatum nihil. Aut modi ut et qui cupiditate.',82,82,'2014-05-28 23:51:41','1974-07-05 08:05:47'),(83,'Eius deserunt voluptatum autem vitae doloremque commodi. Officiis eum recusandae autem adipisci aut est. Molestiae perferendis a qui maiores iure quo.',83,83,'1971-08-16 13:38:49','1987-10-19 20:24:33'),(84,'Quam cumque mollitia ipsa sit. Occaecati autem exercitationem ab officiis voluptates corporis. Et ex ex assumenda atque.',84,84,'1978-12-12 22:08:38','2009-01-23 03:19:21'),(85,'Alias et vitae quos ex. Id ipsum perferendis recusandae commodi dolor nobis dolore officia. Recusandae occaecati nisi voluptatibus. Et ea provident nostrum.',85,85,'1979-08-20 11:35:51','2016-06-07 08:07:40'),(86,'Aut fugiat sit quod a temporibus et nobis. Atque optio debitis iusto ea qui odio dolore. Mollitia voluptates quaerat nihil hic. Natus minima impedit nesciunt mollitia neque blanditiis sed.',86,86,'1994-05-04 00:34:23','1972-01-29 00:15:34'),(87,'Aperiam ratione ipsam et cupiditate consequatur harum accusamus. Ut et et accusantium. Mollitia cumque consequuntur velit at ipsa quod aliquid.',87,87,'2008-06-11 16:35:31','2001-02-10 12:43:12'),(88,'Rem veritatis vero fugiat beatae vero. Aut qui eius inventore nam. Doloribus modi voluptates alias laboriosam sit.',88,88,'2020-03-30 15:42:48','2010-02-13 00:05:18'),(89,'Inventore ut alias sed voluptatem officiis delectus voluptas. Sit enim et id. Sapiente non alias facere laudantium. Ratione sed nihil sapiente ut.',89,89,'1974-10-07 05:18:43','1989-06-22 04:25:29'),(90,'Dolorem totam quis saepe rem ratione qui iusto. In voluptates occaecati non quia. Facere aut nobis saepe vero voluptatem est.',90,90,'1992-12-22 16:26:40','1984-09-13 21:21:42'),(91,'Et voluptates tempora mollitia sunt facere. Sed voluptatem voluptatem ut vel ipsum nulla inventore. Eum assumenda cupiditate cum voluptatem nihil quia.',91,91,'1985-06-24 04:06:00','2020-01-29 11:14:50'),(92,'Officiis voluptatem accusamus veritatis quia sed iure. Cum adipisci et sed consequatur. Eos quis iste vitae.',92,92,'2005-04-16 07:42:26','1986-09-21 14:48:41'),(93,'Incidunt magni veritatis est ut quidem et consequuntur. Qui occaecati quis aliquam et mollitia cupiditate non.',93,93,'2006-05-15 20:41:26','2013-05-18 07:14:10'),(94,'Debitis vitae aut autem magni. Ea nesciunt et excepturi ut officiis. Officia vel quo culpa corporis maxime est.',94,94,'2010-05-02 11:23:20','1979-09-18 20:49:15'),(95,'Voluptas porro repudiandae nihil esse. Aliquam modi ducimus modi ducimus atque. Iste iure tempora et et iusto.',95,95,'1996-04-08 18:26:10','2009-11-23 09:58:46'),(96,'Sunt consequuntur ut sapiente quia modi est. Maiores quo aut sed corrupti. Placeat molestiae recusandae natus hic velit.',96,96,'1974-09-12 07:00:25','1973-08-25 17:38:23'),(97,'At corporis minima fuga totam aspernatur occaecati molestiae sapiente. Sint neque doloribus quae ut. Et ipsa optio dolorum aspernatur culpa.',97,97,'2016-07-18 14:07:19','2000-04-23 04:07:20'),(98,'Dolorem molestiae consequatur autem qui quia perferendis. Incidunt recusandae rem ab esse. Beatae qui accusamus consectetur repellat quis.',98,98,'2017-12-05 18:13:06','1973-01-16 06:23:41'),(99,'Est sunt aut cum enim eum totam. Et quia fugit molestias enim provident fuga. Incidunt quis accusantium saepe eum sit. Eum tenetur cupiditate exercitationem voluptatem aliquam.',99,99,'2015-01-02 12:39:39','2008-04-01 00:07:39'),(100,'Sunt eum dolor quam ab. Unde reiciendis esse necessitatibus mollitia porro saepe. Et porro eum eum sunt ut neque doloribus.',100,100,'2020-06-21 03:01:22','2007-03-22 09:27:26');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

SELECT * FROM posts LIMIT 10;

UPDATE posts SET 
	user_id = FLOOR(1 + RAND() * 100);

ALTER TABLE posts ADD COLUMN media_filename VARCHAR(100) AFTER attachment_id; 

UPDATE posts SET media_filename = (SELECT filename FROM media ORDER BY RAND() LIMIT 1);

ALTER TABLE posts DROP COLUMN attachment_id;

DROP TABLE IF EXISTS `post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post_likes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `liker_id` int(10) unsigned NOT NULL COMMENT 'Кто поставил лайк',
  `what_was_liked` int(10) unsigned NOT NULL COMMENT 'Чему поставили лайк',
  `owner_id` int(10) unsigned NOT NULL COMMENT 'Автор поста',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `liker_id` (`liker_id`),
  KEY `owner_id` (`owner_id`),
  KEY `what_was_liked` (`what_was_liked`),
  CONSTRAINT `post_likes_ibfk_1` FOREIGN KEY (`liker_id`) REFERENCES `users` (`id`),
  CONSTRAINT `post_likes_ibfk_3` FOREIGN KEY (`what_was_liked`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Лайки к постам';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `post_likes` WRITE;
/*!40000 ALTER TABLE `post_likes` DISABLE KEYS */;
INSERT INTO `post_likes` VALUES (1,1,1,1,'1978-10-19 23:27:25','1982-02-02 13:17:07'),(2,2,2,2,'2021-05-09 19:30:26','2020-06-13 11:49:10'),(3,3,3,3,'1978-10-10 05:39:31','2002-11-02 21:04:40'),(4,4,4,4,'2019-10-11 23:49:00','2002-12-23 22:30:41'),(5,5,5,5,'1986-05-30 05:34:55','2020-07-02 07:17:22'),(6,6,6,6,'2014-06-23 05:25:18','2016-12-12 12:45:39'),(7,7,7,7,'2011-05-05 10:59:32','2020-01-02 05:53:37'),(8,8,8,8,'2014-02-02 04:18:42','2008-07-29 09:32:50'),(9,9,9,9,'2011-09-22 20:39:39','1989-09-30 12:49:38'),(10,10,10,10,'2018-12-01 20:15:34','1991-06-17 18:04:15'),(11,11,11,11,'2019-10-14 07:07:08','2005-11-10 11:47:03'),(12,12,12,12,'2003-04-17 01:28:43','1987-08-25 02:44:58'),(13,13,13,13,'2019-05-18 20:49:51','2018-11-08 02:43:48'),(14,14,14,14,'1993-10-17 05:45:29','1978-04-16 05:21:53'),(15,15,15,15,'1970-03-06 21:54:15','1988-04-12 00:38:57'),(16,16,16,16,'2017-12-27 12:28:39','1992-06-26 01:34:59'),(17,17,17,17,'1984-09-09 13:41:05','2000-01-09 17:25:04'),(18,18,18,18,'1983-02-19 19:17:09','2013-06-01 01:40:40'),(19,19,19,19,'2002-07-22 22:55:11','1980-03-20 11:06:37'),(20,20,20,20,'1971-12-09 03:47:29','1993-08-15 04:32:51'),(21,21,21,21,'1990-04-10 22:26:09','2015-09-21 10:59:45'),(22,22,22,22,'1998-01-11 14:23:24','1988-09-02 17:22:55'),(23,23,23,23,'2011-01-18 04:58:48','2017-08-09 00:55:11'),(24,24,24,24,'1978-07-01 19:18:03','1995-12-03 21:46:11'),(25,25,25,25,'2010-10-21 23:42:38','2007-01-17 09:14:06'),(26,26,26,26,'1978-07-21 19:49:39','2019-12-08 08:08:04'),(27,27,27,27,'2019-05-08 17:40:38','1980-12-20 04:42:18'),(28,28,28,28,'2005-08-04 12:44:06','1999-02-23 18:23:58'),(29,29,29,29,'1998-06-22 14:44:19','2018-02-21 01:28:40'),(30,30,30,30,'1978-10-09 20:40:14','1982-07-16 04:03:13'),(31,31,31,31,'2016-04-24 00:11:58','1973-02-26 11:08:44'),(32,32,32,32,'2002-04-01 09:13:15','1995-10-27 18:30:18'),(33,33,33,33,'2005-04-17 02:50:01','2019-11-25 02:14:31'),(34,34,34,34,'2016-09-21 10:18:49','2020-05-30 14:18:21'),(35,35,35,35,'2000-08-20 04:05:10','2002-12-12 14:48:34'),(36,36,36,36,'1973-09-21 04:56:05','1973-03-22 16:30:15'),(37,37,37,37,'1970-12-01 22:58:30','2020-01-09 10:33:15'),(38,38,38,38,'1992-04-25 08:07:25','2009-07-31 13:14:02'),(39,39,39,39,'1980-07-20 16:56:22','1981-02-06 13:09:19'),(40,40,40,40,'1986-12-25 03:14:11','1987-01-04 06:50:03'),(41,41,41,41,'2006-10-24 23:54:35','1972-05-23 18:50:37'),(42,42,42,42,'1997-11-05 01:20:21','2011-03-03 01:52:15'),(43,43,43,43,'2013-03-15 02:33:22','1996-06-18 17:23:49'),(44,44,44,44,'1977-06-02 14:58:09','2018-03-01 10:35:55'),(45,45,45,45,'2006-10-29 05:46:19','1974-02-09 18:55:49'),(46,46,46,46,'1993-04-17 20:17:22','2011-03-10 13:01:10'),(47,47,47,47,'1996-06-28 06:49:30','2014-10-22 10:51:21'),(48,48,48,48,'1987-06-20 02:27:19','1996-12-06 09:29:18'),(49,49,49,49,'1977-01-03 03:39:27','1989-12-12 19:39:20'),(50,50,50,50,'2016-08-18 10:50:57','2005-03-01 00:20:44'),(51,51,51,51,'1991-11-06 18:22:42','1983-09-03 15:47:28'),(52,52,52,52,'1977-09-29 01:20:09','1997-06-21 21:51:10'),(53,53,53,53,'1990-03-06 22:23:19','1993-04-28 18:59:52'),(54,54,54,54,'1980-09-13 14:27:20','1975-06-14 10:26:27'),(55,55,55,55,'2019-11-09 09:36:30','1973-01-06 15:01:31'),(56,56,56,56,'1974-07-15 23:15:00','1986-06-09 06:08:55'),(57,57,57,57,'2002-08-19 12:55:23','1975-09-18 03:37:27'),(58,58,58,58,'2004-02-16 15:27:46','1976-04-25 12:03:04'),(59,59,59,59,'1999-04-28 12:07:31','1990-07-06 18:22:11'),(60,60,60,60,'1994-03-19 06:27:11','2007-09-23 11:33:08'),(61,61,61,61,'2000-02-17 19:18:12','1978-07-23 15:54:51'),(62,62,62,62,'1985-01-29 08:48:43','2007-12-02 15:52:58'),(63,63,63,63,'1995-10-24 14:16:12','2018-01-09 02:16:26'),(64,64,64,64,'1998-08-05 10:02:20','1989-02-28 13:40:06'),(65,65,65,65,'1983-06-04 12:00:09','1992-01-17 19:40:28'),(66,66,66,66,'2005-11-13 09:57:53','1975-06-07 14:50:51'),(67,67,67,67,'2007-09-26 03:36:22','1991-08-21 17:47:48'),(68,68,68,68,'2009-12-22 14:50:44','2015-09-26 15:24:36'),(69,69,69,69,'1990-04-29 03:21:57','1994-12-23 09:54:30'),(70,70,70,70,'1986-10-22 11:51:43','2018-02-06 20:50:50'),(71,71,71,71,'1976-02-06 10:09:18','1970-10-07 22:30:02'),(72,72,72,72,'1997-01-20 22:20:55','2016-11-02 22:08:06'),(73,73,73,73,'2018-10-22 15:24:22','2012-09-28 17:21:50'),(74,74,74,74,'1997-04-22 01:20:02','1982-08-24 13:41:44'),(75,75,75,75,'1991-03-21 09:31:53','1989-12-13 00:04:56'),(76,76,76,76,'2021-01-05 11:18:21','2020-12-19 03:18:40'),(77,77,77,77,'1977-06-13 22:32:04','1999-12-17 16:21:53'),(78,78,78,78,'2012-08-28 00:03:46','2003-06-28 10:31:05'),(79,79,79,79,'2020-04-09 17:19:47','1999-08-15 10:27:48'),(80,80,80,80,'2019-03-05 22:58:58','1985-01-21 19:12:24'),(81,81,81,81,'1982-09-10 07:28:06','2016-03-13 03:30:25'),(82,82,82,82,'2008-02-01 07:45:09','1981-09-07 11:14:28'),(83,83,83,83,'2003-08-23 13:04:20','2000-11-18 13:37:13'),(84,84,84,84,'1978-06-23 17:46:01','1989-12-26 08:47:58'),(85,85,85,85,'2018-10-06 13:40:17','1990-12-17 02:16:22'),(86,86,86,86,'1996-05-20 21:52:17','1991-05-22 21:42:38'),(87,87,87,87,'1995-04-05 21:40:59','2006-01-18 12:27:59'),(88,88,88,88,'1992-11-09 15:29:42','1987-08-24 22:07:59'),(89,89,89,89,'2016-08-18 13:28:55','2018-03-16 14:13:52'),(90,90,90,90,'1977-06-11 01:59:03','1979-11-03 13:30:15'),(91,91,91,91,'2019-04-15 10:02:08','2018-10-01 07:59:47'),(92,92,92,92,'2000-02-20 10:19:01','2015-11-28 17:26:54'),(93,93,93,93,'1989-05-26 09:54:10','2021-03-23 10:52:29'),(94,94,94,94,'1976-06-27 18:25:31','1974-11-18 02:34:21'),(95,95,95,95,'2019-11-13 16:45:40','2016-09-19 23:25:57'),(96,96,96,96,'2001-12-28 17:29:31','1975-08-13 09:51:17'),(97,97,97,97,'1972-12-18 18:42:59','2014-09-06 01:12:42'),(98,98,98,98,'1994-09-16 18:39:32','2004-02-04 02:12:19'),(99,99,99,99,'1987-10-24 05:30:08','2005-05-28 09:20:37'),(100,100,100,100,'2020-02-09 11:57:06','1997-12-10 18:12:54');
/*!40000 ALTER TABLE `post_likes` ENABLE KEYS */;
UNLOCK TABLES;

SELECT * FROM post_likes LIMIT 10;

ALTER TABLE post_likes DROP COLUMN owner_id;

UPDATE post_likes SET 
	liker_id = FLOOR(1 + RAND() * 100),
    what_was_liked = FLOOR(1 + RAND() * 100);

DROP TABLE IF EXISTS `user_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_likes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `liker_id` int(10) unsigned NOT NULL COMMENT 'Кто поставил лайк',
  `who_was_liked` int(10) unsigned NOT NULL COMMENT 'Кому поставили лайк',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `liker_id` (`liker_id`),
  KEY `who_was_liked` (`who_was_liked`),
  CONSTRAINT `user_likes_ibfk_1` FOREIGN KEY (`liker_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_likes_ibfk_2` FOREIGN KEY (`who_was_liked`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Лайки к пользователям';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `user_likes` WRITE;
/*!40000 ALTER TABLE `user_likes` DISABLE KEYS */;
INSERT INTO `user_likes` VALUES (1,1,1,'1990-03-22 19:12:38','2016-01-16 19:39:34'),(2,2,2,'2016-11-04 12:24:10','2007-08-03 04:42:38'),(3,3,3,'1971-04-18 15:59:18','2015-11-09 12:37:49'),(4,4,4,'2003-01-22 20:18:49','2018-02-27 14:55:03'),(5,5,5,'1983-04-16 21:01:06','1992-11-06 15:17:37'),(6,6,6,'1995-01-25 09:25:03','2017-04-25 14:57:52'),(7,7,7,'1992-10-07 06:37:15','1986-01-01 02:04:25'),(8,8,8,'2011-12-22 01:11:28','2020-02-21 10:31:51'),(9,9,9,'1991-10-19 20:15:58','1997-12-25 15:15:39'),(10,10,10,'1981-11-14 07:40:10','1981-08-26 04:00:39'),(11,11,11,'1985-06-22 17:37:11','1995-05-26 16:42:19'),(12,12,12,'1994-06-14 21:45:39','1988-02-10 12:35:29'),(13,13,13,'2006-09-14 16:34:41','1978-06-03 13:11:00'),(14,14,14,'2018-06-27 23:45:30','1986-08-10 02:29:39'),(15,15,15,'1991-08-15 18:31:53','1992-03-11 14:08:38'),(16,16,16,'2016-01-06 15:46:07','2020-12-11 11:12:18'),(17,17,17,'1985-09-07 02:48:17','2005-12-29 00:10:11'),(18,18,18,'2008-05-06 22:32:32','2003-09-13 14:39:18'),(19,19,19,'1977-06-24 07:16:01','2001-01-03 17:26:39'),(20,20,20,'1975-11-07 14:42:22','1998-08-16 04:33:58'),(21,21,21,'1970-03-20 20:34:01','2008-12-30 18:28:55'),(22,22,22,'1995-08-19 17:46:09','1983-02-09 17:24:45'),(23,23,23,'1992-03-19 18:08:19','2009-07-18 12:17:55'),(24,24,24,'1972-06-08 18:48:58','2001-08-20 13:34:13'),(25,25,25,'1984-02-05 01:13:02','1990-10-05 12:58:44'),(26,26,26,'1985-03-03 16:01:04','1994-02-28 06:28:05'),(27,27,27,'2016-03-15 04:02:15','1987-03-09 16:57:24'),(28,28,28,'1970-06-11 22:20:40','2015-05-29 21:59:33'),(29,29,29,'1998-02-17 17:07:23','1974-11-05 14:18:39'),(30,30,30,'1971-06-30 07:22:51','1975-12-08 19:06:56'),(31,31,31,'1993-09-05 19:22:56','1997-10-02 08:17:20'),(32,32,32,'2016-08-21 03:27:12','1991-04-27 22:53:32'),(33,33,33,'1987-07-08 20:14:26','1982-07-05 08:55:14'),(34,34,34,'2004-06-06 07:43:56','1972-08-20 20:26:53'),(35,35,35,'2009-04-09 23:09:24','1981-04-06 10:01:20'),(36,36,36,'1990-01-09 11:23:12','2014-08-12 16:45:58'),(37,37,37,'2000-08-12 16:07:38','2007-06-27 05:30:54'),(38,38,38,'2016-07-16 13:11:57','2013-07-14 11:46:56'),(39,39,39,'1994-07-17 04:45:19','1989-07-11 23:49:11'),(40,40,40,'2001-11-04 17:42:11','1975-05-06 11:05:14'),(41,41,41,'1996-03-02 07:06:27','1996-12-06 17:21:52'),(42,42,42,'1985-04-09 19:40:36','1977-04-10 04:00:29'),(43,43,43,'1983-03-02 07:06:38','1982-09-14 10:02:25'),(44,44,44,'2000-05-14 03:37:17','1980-07-10 01:21:36'),(45,45,45,'2020-04-04 16:32:43','2006-02-15 17:55:58'),(46,46,46,'1981-11-03 02:25:16','2000-08-20 02:35:27'),(47,47,47,'1996-11-29 03:10:53','1977-03-13 01:49:48'),(48,48,48,'2014-11-10 06:38:48','2010-12-27 08:07:01'),(49,49,49,'2019-03-27 15:39:13','2013-02-08 00:50:04'),(50,50,50,'1998-11-19 07:51:49','1973-02-07 00:05:32'),(51,51,51,'1988-05-01 11:22:23','1997-12-29 06:12:20'),(52,52,52,'1999-11-19 09:47:26','1986-12-23 07:02:07'),(53,53,53,'1984-07-01 12:28:09','2015-05-04 22:18:52'),(54,54,54,'1986-03-16 07:52:44','2002-01-25 06:55:22'),(55,55,55,'2004-01-15 01:13:34','2012-01-14 16:05:32'),(56,56,56,'1975-10-21 04:45:08','2020-07-27 16:05:07'),(57,57,57,'1979-11-27 09:30:51','1989-11-27 15:01:21'),(58,58,58,'1991-12-30 09:01:24','2016-11-07 14:46:47'),(59,59,59,'2012-11-11 23:55:25','1978-08-16 15:07:29'),(60,60,60,'1982-09-20 12:51:36','2011-10-06 11:48:26'),(61,61,61,'1979-02-09 21:01:41','2003-02-02 07:20:00'),(62,62,62,'2018-05-23 19:08:25','2006-09-16 19:23:51'),(63,63,63,'2005-07-05 02:44:51','2002-08-31 12:15:56'),(64,64,64,'1983-08-04 05:11:10','2011-02-03 07:03:36'),(65,65,65,'1998-07-24 05:24:15','1977-02-22 12:54:26'),(66,66,66,'1995-11-22 18:02:39','1980-02-11 03:38:33'),(67,67,67,'2000-12-23 21:00:27','1993-08-07 05:00:45'),(68,68,68,'1992-08-10 09:12:59','2007-03-29 06:09:06'),(69,69,69,'1999-07-19 01:57:32','1987-07-02 05:27:23'),(70,70,70,'2009-12-04 21:03:59','1977-07-15 07:30:27'),(71,71,71,'1988-06-15 17:32:37','1991-01-30 15:22:29'),(72,72,72,'1971-05-21 00:22:07','2000-04-26 17:57:26'),(73,73,73,'2017-12-08 19:57:40','2020-02-18 16:48:15'),(74,74,74,'2019-08-14 02:57:00','2021-02-13 21:35:23'),(75,75,75,'1979-11-29 23:25:42','1995-07-27 13:12:28'),(76,76,76,'1998-12-24 19:01:23','2017-04-10 13:06:49'),(77,77,77,'1998-02-28 11:04:54','1988-05-09 05:59:23'),(78,78,78,'2010-05-03 05:59:35','1971-10-20 23:10:15'),(79,79,79,'1987-11-29 15:04:46','1979-09-29 01:03:45'),(80,80,80,'1979-07-03 00:27:00','1973-09-04 11:51:35'),(81,81,81,'2013-12-22 20:15:39','2020-12-03 22:12:25'),(82,82,82,'2015-11-22 01:37:11','1987-05-14 22:49:46'),(83,83,83,'1986-10-24 17:07:48','2001-01-22 02:38:02'),(84,84,84,'1996-03-13 01:17:45','1980-11-16 18:48:55'),(85,85,85,'1982-03-29 04:02:17','2012-04-08 18:54:08'),(86,86,86,'1976-08-13 19:41:50','1976-02-25 08:50:23'),(87,87,87,'2010-03-01 18:41:28','2014-01-02 14:16:28'),(88,88,88,'1992-09-16 23:22:11','1972-12-26 06:24:41'),(89,89,89,'1989-05-03 10:55:41','2005-11-21 05:06:21'),(90,90,90,'1987-10-23 05:25:42','1992-11-20 06:54:52'),(91,91,91,'1983-07-08 09:25:59','1970-08-27 13:10:20'),(92,92,92,'2002-04-14 04:26:21','2018-03-12 11:18:58'),(93,93,93,'2002-05-12 10:59:04','1986-03-03 11:35:51'),(94,94,94,'1984-10-03 14:59:20','1990-06-03 09:44:56'),(95,95,95,'1999-11-19 19:03:11','1970-04-24 18:31:53'),(96,96,96,'1972-01-22 19:39:11','1986-10-29 15:28:07'),(97,97,97,'1970-05-16 23:30:17','2014-05-06 01:03:39'),(98,98,98,'1979-01-10 14:04:45','1998-11-06 15:58:58'),(99,99,99,'1980-05-04 14:11:10','2018-10-17 17:46:14'),(100,100,100,'1990-09-28 08:22:16','2013-06-28 22:43:33');
/*!40000 ALTER TABLE `user_likes` ENABLE KEYS */;
UNLOCK TABLES;

SELECT * FROM user_likes LIMIT 10;

UPDATE user_likes SET 
	liker_id = FLOOR(1 + RAND() * 100),
    who_was_liked = FLOOR(1 + RAND() * 100);

DROP TABLE IF EXISTS `media_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_likes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `liker_id` int(10) unsigned NOT NULL COMMENT 'Кто поставил лайк',
  `what_was_liked` int(10) unsigned NOT NULL COMMENT 'Чему поставили лайк',
  `owner_id` int(10) unsigned NOT NULL COMMENT 'Автор медиафайла',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `liker_id` (`liker_id`),
  KEY `owner_id` (`owner_id`),
  KEY `what_was_liked` (`what_was_liked`),
  CONSTRAINT `media_likes_ibfk_1` FOREIGN KEY (`liker_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_likes_ibfk_3` FOREIGN KEY (`what_was_liked`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Лайки к медиа';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `media_likes` WRITE;
/*!40000 ALTER TABLE `media_likes` DISABLE KEYS */;
INSERT INTO `media_likes` VALUES (1,1,1,1,'1996-02-11 06:52:22','2002-04-10 10:45:21'),(2,2,2,2,'2010-01-14 06:29:48','1971-08-21 23:25:32'),(3,3,3,3,'1995-10-12 18:09:53','1999-04-20 02:30:11'),(4,4,4,4,'1998-05-15 02:36:17','2014-12-12 08:18:28'),(5,5,5,5,'2010-03-22 08:12:48','2009-01-18 19:49:15'),(6,6,6,6,'2016-02-03 21:55:11','2003-07-05 03:12:12'),(7,7,7,7,'1988-12-02 19:17:20','2013-04-30 16:52:50'),(8,8,8,8,'1973-01-02 16:46:55','2009-04-03 13:23:31'),(9,9,9,9,'1973-08-02 13:53:23','1970-09-28 07:36:16'),(10,10,10,10,'2020-03-24 17:27:35','2018-11-01 01:02:57'),(11,11,11,11,'1983-09-27 03:15:49','2000-04-05 00:23:44'),(12,12,12,12,'2019-10-17 17:47:54','1970-12-04 17:43:06'),(13,13,13,13,'1971-12-25 21:17:21','1977-11-14 21:58:23'),(14,14,14,14,'1990-07-27 18:33:40','2013-11-30 06:38:17'),(15,15,15,15,'1982-11-30 07:00:56','1972-03-14 21:18:52'),(16,16,16,16,'1982-06-12 02:35:42','1982-06-20 09:49:48'),(17,17,17,17,'1990-01-03 21:57:37','1986-01-30 05:43:55'),(18,18,18,18,'1992-05-29 23:51:59','1986-07-31 17:51:48'),(19,19,19,19,'1978-02-27 18:58:49','2006-10-31 21:24:03'),(20,20,20,20,'2016-02-14 08:39:55','1978-04-15 17:54:48'),(21,21,21,21,'2002-03-02 23:06:06','1993-10-29 05:10:42'),(22,22,22,22,'1972-04-14 09:42:41','1992-12-17 15:52:04'),(23,23,23,23,'1992-05-25 12:33:43','1974-09-08 09:42:58'),(24,24,24,24,'2020-12-10 14:49:24','2013-02-25 21:30:28'),(25,25,25,25,'1973-10-11 01:46:18','2007-04-26 20:04:35'),(26,26,26,26,'2016-08-15 00:28:59','1983-03-13 02:19:50'),(27,27,27,27,'1988-10-23 19:01:42','2011-04-05 02:42:35'),(28,28,28,28,'2000-09-17 17:46:57','1976-08-28 01:14:55'),(29,29,29,29,'2003-02-07 11:28:25','2010-09-08 21:21:02'),(30,30,30,30,'1982-11-07 10:18:58','2014-01-16 07:36:12'),(31,31,31,31,'1994-12-13 10:30:40','1974-12-21 12:43:34'),(32,32,32,32,'2017-08-03 13:43:37','2012-02-22 08:59:23'),(33,33,33,33,'2018-06-10 13:38:59','1998-02-03 21:25:21'),(34,34,34,34,'2019-09-23 17:05:35','1998-11-10 13:26:59'),(35,35,35,35,'2007-05-13 04:19:52','1992-07-16 00:05:34'),(36,36,36,36,'1989-01-12 14:04:32','2015-07-15 11:03:41'),(37,37,37,37,'1983-05-19 08:23:52','2008-06-10 18:23:54'),(38,38,38,38,'1971-06-21 05:35:37','2001-04-08 14:14:41'),(39,39,39,39,'1999-03-05 10:19:01','2004-02-17 20:20:10'),(40,40,40,40,'1973-09-05 05:15:02','1984-04-05 05:50:03'),(41,41,41,41,'1998-03-14 02:24:57','1993-05-25 21:35:18'),(42,42,42,42,'1977-12-16 18:23:17','2018-08-16 18:41:40'),(43,43,43,43,'1978-10-01 13:21:31','2002-10-20 21:19:00'),(44,44,44,44,'1980-07-06 10:41:22','1992-08-26 23:48:35'),(45,45,45,45,'2003-09-12 15:36:20','2015-05-01 23:07:02'),(46,46,46,46,'1973-09-28 10:38:57','1979-09-14 05:41:28'),(47,47,47,47,'1978-09-20 22:28:11','1999-10-27 22:28:53'),(48,48,48,48,'2004-02-09 07:47:30','1991-09-26 07:59:14'),(49,49,49,49,'1974-06-21 14:40:42','1979-03-21 16:43:09'),(50,50,50,50,'2009-09-26 19:16:46','1972-07-04 21:58:35'),(51,51,51,51,'2003-09-22 19:48:52','2014-04-25 07:23:16'),(52,52,52,52,'2008-06-17 10:42:47','2004-11-07 12:40:53'),(53,53,53,53,'1993-05-22 08:39:11','2012-05-28 22:42:45'),(54,54,54,54,'2009-05-10 19:06:12','1995-05-16 19:08:20'),(55,55,55,55,'1990-03-19 23:34:27','1979-05-13 23:49:00'),(56,56,56,56,'1984-12-06 21:34:05','1991-06-23 14:05:26'),(57,57,57,57,'2016-10-08 03:17:05','1982-07-07 07:55:56'),(58,58,58,58,'1991-10-03 09:55:05','1990-02-27 10:41:29'),(59,59,59,59,'2003-11-05 11:00:16','1981-02-09 06:15:34'),(60,60,60,60,'1996-10-17 18:53:58','1991-12-29 00:54:34'),(61,61,61,61,'1988-03-25 17:38:07','1987-04-27 17:39:31'),(62,62,62,62,'1994-12-02 14:31:51','1984-02-07 08:30:48'),(63,63,63,63,'1971-09-15 21:04:23','1981-01-23 19:26:28'),(64,64,64,64,'1988-02-24 12:24:03','1979-10-29 12:56:37'),(65,65,65,65,'1986-03-21 11:10:06','2006-04-26 10:33:41'),(66,66,66,66,'2010-10-28 22:10:12','2001-02-18 05:21:37'),(67,67,67,67,'1986-02-05 15:13:30','1970-04-24 04:52:23'),(68,68,68,68,'1978-01-25 16:02:03','1997-11-19 21:22:50'),(69,69,69,69,'2018-06-12 23:15:09','1991-11-02 15:01:16'),(70,70,70,70,'2010-11-13 22:09:25','1975-04-25 11:49:39'),(71,71,71,71,'1972-02-07 21:31:29','2007-03-01 15:18:01'),(72,72,72,72,'2003-11-05 18:26:51','1974-06-03 23:29:16'),(73,73,73,73,'1971-03-13 01:56:46','1984-09-24 00:10:56'),(74,74,74,74,'1998-06-09 18:11:01','1987-01-08 02:39:00'),(75,75,75,75,'2017-04-08 00:43:52','1989-11-22 22:12:21'),(76,76,76,76,'1987-02-03 13:25:11','2018-08-30 01:47:03'),(77,77,77,77,'2001-02-05 19:11:18','2012-05-07 06:50:08'),(78,78,78,78,'1973-10-27 17:23:58','1995-09-17 18:03:13'),(79,79,79,79,'1988-10-24 19:37:48','1995-09-21 12:56:47'),(80,80,80,80,'1995-08-22 09:04:23','1994-01-21 01:35:35'),(81,81,81,81,'1970-08-15 00:28:57','2018-10-22 03:26:38'),(82,82,82,82,'1973-05-19 18:20:06','2018-10-13 21:13:53'),(83,83,83,83,'1983-06-22 12:26:58','2010-05-06 14:42:24'),(84,84,84,84,'1993-12-24 01:30:41','2002-03-02 18:47:35'),(85,85,85,85,'2014-06-11 13:19:36','2000-06-18 10:09:20'),(86,86,86,86,'2000-11-05 01:18:20','1983-11-18 13:37:17'),(87,87,87,87,'1978-09-04 05:03:01','2019-04-25 13:58:32'),(88,88,88,88,'2005-01-19 07:40:59','1975-04-24 18:35:36'),(89,89,89,89,'2013-09-30 21:51:34','1972-05-26 15:23:11'),(90,90,90,90,'2006-05-22 16:09:09','2006-10-31 15:30:35'),(91,91,91,91,'1990-06-21 15:17:22','1984-09-07 17:20:58'),(92,92,92,92,'2005-02-20 01:04:41','2006-06-25 20:29:27'),(93,93,93,93,'1997-03-26 01:42:32','1991-08-23 03:21:51'),(94,94,94,94,'1996-08-02 14:46:49','2000-03-09 03:37:48'),(95,95,95,95,'2008-12-05 04:13:34','1990-09-16 04:20:13'),(96,96,96,96,'2020-10-18 18:16:53','1980-07-02 14:00:40'),(97,97,97,97,'1995-12-03 06:34:15','2018-08-06 17:52:23'),(98,98,98,98,'1982-05-24 01:24:20','1979-05-19 23:57:47'),(99,99,99,99,'1976-12-02 06:09:55','2016-11-18 06:14:34'),(100,100,100,100,'1978-06-03 03:48:09','1972-01-07 17:09:55');
/*!40000 ALTER TABLE `media_likes` ENABLE KEYS */;
UNLOCK TABLES;

SELECT * FROM media_likes LIMIT 10;

UPDATE media_likes SET
	liker_id = FLOOR(1 + RAND() * 100),
    what_was_liked = FLOOR(1 + RAND() * 100);

ALTER TABLE media_likes DROP COLUMN owner_id;

SELECT * FROM profiles LIMIT 10;

DROP TABLE IF EXISTS geogr;
CREATE TABLE geogr (
	place VARCHAR(20)
);

SELECT * from geogr;

INSERT IGNORE INTO geogr VALUES ('Minsk, Belarus'), ('Chishinau, Moldova'), ('Dubai, UAE'), ('Tolliatti,  Russia'), ('Syzran, Russia'), ('Chita, Russia'), ('Baranovichi, Belarus'), ('Cheboksary, Russia'), ('Khimki, Russia'), ('Prokhorovka, Russia');

ALTER TABLE profiles DROP COLUMN city;
ALTER TABLE profiles RENAME COLUMN country TO place;

UPDATE profiles SET country = (SELECT place FROM geogr ORDER BY RAND() LIMIT 1);

-- Задание 4. Подобрать сервис для курсовой работы.
-- Для КР выбран сервис https://www.postcrossing.com/, сервис для обмена почтовыми открытками с людьми по всему миру.