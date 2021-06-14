DROP DATABASE IF EXISTS postcrossing;

CREATE DATABASE postcrossing;

USE postcrossing;

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    country_name VARCHAR(225) NOT NULL UNIQUE COMMENT "Название страны",
    short_name VARCHAR(2) NOT NULL UNIQUE COMMENT "Код страны",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'таблица стран'; 

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    city_name VARCHAR(225) NOT NULL COMMENT "Название города",
    location INT UNSIGNED NOT NULL COMMENT "В какой стране находится",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (location) REFERENCES countries(id) ON UPDATE CASCADE
) COMMENT 'таблица городов';

DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    language_name VARCHAR(225) NOT NULL UNIQUE COMMENT "Язык",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'таблица с языками';

DROP TABLE IF EXISTS pronouns;
CREATE TABLE pronouns (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    pronoun VARCHAR(225) NOT NULL UNIQUE COMMENT "Местоимения",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'таблица с местоимениями';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    nickname VARCHAR(25) NOT NULL UNIQUE COMMENT "Никнейм пользователя на сайте",
    user_name VARCHAR(25) NOT NULL COMMENT "Имя пользователя",
    country INT UNSIGNED NOT NULL COMMENT "ссылка на страну проживания",
    city INT UNSIGNED NOT NULL COMMENT "Ссылка на город проживания",
    email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
    birthday DATE COMMENT "Дата рождения",
    native_language INT UNSIGNED NOT NULL COMMENT "Ссылка на родной язык",
    pronouns INT UNSIGNED NOT NULL COMMENT "Ссылка на местоимения",
    info_about TEXT NOT NULL COMMENT "Текст профиля, о себе",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (country) REFERENCES countries(id) ON UPDATE CASCADE,
    FOREIGN KEY (city) REFERENCES cities(id) ON UPDATE CASCADE,
    FOREIGN KEY (native_language) REFERENCES languages(id),
    FOREIGN KEY (pronouns) REFERENCES pronouns(id) ON UPDATE CASCADE
) COMMENT 'таблица пользователей';

DROP TABLE IF EXISTS postcard_status;
CREATE TABLE postcard_status (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    status_name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название статуса",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'таблица со статусом открыток';

DROP TABLE IF EXISTS postcards;
CREATE TABLE postcards (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    card_status INT UNSIGNED NOT NULL COMMENT "Статус открытки",
    metadata JSON COMMENT "Метаданные открытки",
    sender INT UNSIGNED NOT NULL COMMENT "Отправитель",
    receiver INT UNSIGNED NOT NULL COMMENT "Получатель",
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Когда открытка была отправлена", 
    received_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Когда открытка была получена",
    FOREIGN KEY (sender) REFERENCES users(id),
    FOREIGN KEY (receiver) REFERENCES users(id),
    FOREIGN KEY (card_status) REFERENCES postcard_status(id)
) COMMENT 'таблица открыток';

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    liker_id INT UNSIGNED NOT NULL COMMENT "Кто поставил лайк",
    target_id INT UNSIGNED NOT NULL COMMENT "Кому поставили лайк",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (liker_id) REFERENCES users(id),
    FOREIGN KEY (target_id) REFERENCES postcards(id)
) COMMENT 'таблица с лайками к открыткам';

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    m_header VARCHAR(255) NOT NULL COMMENT "Заголовок (тема) сообщения",
    message TEXT NOT NULL COMMENT "Текст сообщения",
    sender_id INT UNSIGNED NOT NULL COMMENT "Кто отправил сообщение",
    receiver_id INT UNSIGNED NOT NULL COMMENT "Кому отправили сообщение",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
) COMMENT 'таблица с сообщениями';

DROP TABLE IF EXISTS people_bookmarks;
CREATE TABLE people_bookmarks (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    user_id INT UNSIGNED NOT NULL COMMENT "Кто сохранил профиль пользователя как закладку",
    target_id INT UNSIGNED NOT NULL COMMENT "Чей профиль сохранили как закладку",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (target_id) REFERENCES users(id)
) COMMENT "Таблица с закладками интересных пользователей";

DROP TABLE IF EXISTS event_type;
CREATE TABLE event_type (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    event_name VARCHAR(50) NOT NULL UNIQUE COMMENT "Название типа мероприятия",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'таблица с типами мероприятий';

DROP TABLE IF EXISTS community_events;
CREATE TABLE community_events (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    event_type INT UNSIGNED NOT NULL COMMENT "Тип мероприятия",
    event_name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название мероприятия",
    country INT UNSIGNED NOT NULL COMMENT "Ссылка на страну, где проходит мероприятие",
    city INT UNSIGNED NOT NULL COMMENT "Ссылка на город, где проходит мероприятие",
    organiser INT UNSIGNED NOT NULL COMMENT "Кто организовал мероприятие",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (organiser) REFERENCES users(id),
    FOREIGN KEY (country) REFERENCES countries(id),
    FOREIGN KEY (city) REFERENCES cities(id),
    FOREIGN KEY (event_type) REFERENCES event_type(id)
) COMMENT 'таблица с мероприятиями сообщества';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  type_name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название типа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Типы медиафайлов";

DROP TABLE IF EXISTS media;
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  author_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который загрузил файл",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  size INT NOT NULL COMMENT "Размер файла",
  metadata JSON COMMENT "Метаданные файла",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  FOREIGN KEY (author_id) REFERENCES users(id),
  FOREIGN KEY (media_type_id) REFERENCES media_types(id)
) COMMENT "Медиафайлы";

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    commenter_id INT UNSIGNED NOT NULL COMMENT "Кто оставил комментарий",
    target_id INT UNSIGNED NOT NULL COMMENT "Где и чему оставили комментарий",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (commenter_id) REFERENCES users(id),
    FOREIGN KEY (target_id) REFERENCES postcards(id)
) COMMENT 'таблица с комментариями';

DROP TABLE IF EXISTS forum;
CREATE TABLE forum (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    forum_text TEXT NOT NULL COMMENT "Пост на форуме",
    author INT UNSIGNED NOT NULL COMMENT "Кто написал пост",
    media INT UNSIGNED NOT NULL COMMENT "Ссылка на медиафайл в посте",
    comments INT UNSIGNED NOT NULL COMMENT "Ссылка на комментарий к соотв. открытке",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
    FOREIGN KEY (author) REFERENCES users(id),
    FOREIGN KEY (media) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (comments) REFERENCES comments(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT 'таблица, описывающая структуру форума';
