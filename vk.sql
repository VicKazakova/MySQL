-- Задание 1. Проанализировать структуру БД vk, которую мы создали на занятии, и внести предложения по усовершенствованию
-- (если такие идеи есть). Напишите пожалуйста, всё ли понятно по структуре.

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

USE vk;

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
  last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
  email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
  phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Пользователи";  

CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender CHAR(1) NOT NULL COMMENT "Пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT "Профили"; 


CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (from_user_id) REFERENCES users(id),
  FOREIGN KEY (to_user_id) REFERENCES users(id)
) COMMENT "Сообщения";

CREATE TABLE friendship_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название статуса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Статусы дружбы";

CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ",
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (friend_id) REFERENCES users(id),
  FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
) COMMENT "Таблица дружбы";

CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ",
  FOREIGN KEY (community_id) REFERENCES communities(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT "Участники групп, связь между пользователями и группами";

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (media_type_id) REFERENCES media_types(id)
) COMMENT "Медиафайлы";

-- По структуре все хорошо и понятно. Из дополнительных вещей предложила бы все же объединить 
-- users, proflies в одну таблицу для удобства.

-- Задание 2. Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для медиафайлов, 
-- постов и пользователей.

CREATE TABLE posts(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    body TEXT NOT NULL COMMENT "Текст поста",
    attachment_id INT UNSIGNED COMMENT "Ссылка на медиафайл, прикрепленный к посту (если есть)",
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который сделал пост",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (attachment_id) REFERENCES media(id)
);

CREATE TABLE post_likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    liker_id INT UNSIGNED NOT NULL COMMENT "Кто поставил лайк",
    what_was_liked INT UNSIGNED NOT NULL COMMENT "Чему поставили лайк",
    owner_id INT UNSIGNED NOT NULL COMMENT "Автор поста",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (what_was_liked) REFERENCES posts(id)
) COMMENT "Лайки к постам";

CREATE TABLE media_likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    liker_id INT UNSIGNED NOT NULL COMMENT "Кто поставил лайк",
    what_was_liked INT UNSIGNED NOT NULL COMMENT "Чему поставили лайк",
    owner_id INT UNSIGNED NOT NULL COMMENT "Автор медиафайла",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (owner_id) REFERENCES media(user_id),
    FOREIGN KEY (what_was_liked) REFERENCES media(id)
) COMMENT "Лайки к медиа";

CREATE TABLE user_likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    liker_id INT UNSIGNED NOT NULL COMMENT "Кто поставил лайк",
    who_was_liked INT UNSIGNED NOT NULL COMMENT "Кому поставили лайк",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (who_was_liked) REFERENCES users(id)
) COMMENT "Лайки к пользователям";
