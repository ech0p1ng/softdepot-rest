--администратор
CREATE TABLE administrator
(
    id                 SERIAL PRIMARY KEY,
    password           varchar(60) NOT NULL,
    administrator_name varchar(50) NOT NULL
);

--покупатель
CREATE TABLE customer
(
    id                     SERIAL PRIMARY KEY,
    customer_name          varchar(50) NOT NULL,
    password               varchar(60) NOT NULL,
    profile_img_url        varchar(200),
	registration_date_time timestamp NOT NULL
);

--разработчик
CREATE TABLE developer
(
    id              SERIAL PRIMARY KEY,
    developer_name  varchar(50) NOT NULL,
    password        varchar(60) NOT NULL,
    profile_img_url varchar(200),
	registration_date_time timestamp NOT NULL
);

--ключевое слово
CREATE TABLE tag
(
    id       SERIAL PRIMARY KEY,
    tag_name varchar(50) NOT NULL UNIQUE
);

--программа
CREATE TABLE program
(
    id                    SERIAL PRIMARY KEY,
    developer_id          int         NOT NULL REFERENCES developer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_name          varchar(50) NOT NULL,
    price                 numeric(10, 2) CHECK (price >= 0),
    short_description     varchar     NOT NULL,
    description           varchar     NOT NULL,
    logo_url              varchar(100),
    installer_windows_url varchar(100),
    installer_linux_url   varchar(100),
    installer_macos_url   varchar(100),
    screenshots_url       varchar(100)[],
	upload_date_time timestamp NOT NULL,
	update_date_time timestamp,
	currency              int       NOT NULL REFERENCES measure_unit (id) ON UPDATE CASCADE
);

--степень принадлежности к ключевому слову
CREATE TABLE degree_of_belonging
(
    id           SERIAL PRIMARY KEY,
    program_id   int NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE,
    tag_id       int NOT NULL REFERENCES tag (id) ON DELETE CASCADE ON UPDATE CASCADE,
    degree_value int NOT NULL CHECK (degree_value >= 0 AND degree_value <= 10)
);

--покупка
CREATE TABLE purchase
(
    id                 SERIAL PRIMARY KEY,
    purchase_date_time timestamp NOT NULL,
    customer_id        int       NOT NULL REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_id         int       NOT NULL REFERENCES program (id) ON UPDATE CASCADE,
	currency           int       NOT NULL REFERENCES measure_unit (id) ON UPDATE CASCADE
);

--ежедневная статистика
CREATE TABLE daily_stats
(
    id               SERIAL PRIMARY KEY,
    stats_date       timestamp NOT NULL,
    program_id       int       NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE,
    avg_estimation   FLOAT     NOT NULL CHECK (avg_estimation >= 0 AND avg_estimation <= 5),
    earnings         numeric(10, 2) CHECK (earnings >= 0),
    purchases_amount int       NOT NULL,
    reviews_amount   int       NOT NULL
	currency         int       NOT NULL REFERENCES measure_unit (id) ON UPDATE CASCADE
);

--отзыв
CREATE TABLE review
(
    id          SERIAL PRIMARY KEY,
    customer_id int       NOT NULL REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_id  int       NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE,
    estimation  int       NOT NULL CHECK (estimation >= 0 AND estimation <= 5),
    date_time   timestamp NOT NULL,
	update_date_time   timestamp NOT NULL,
    review_text TEXT      NOT NULL
);

--корзина
CREATE TABLE cart
(
    id          SERIAL PRIMARY KEY,
    customer_id int NOT NULL REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_id  int NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE
);

--единица измерения
CREATE TABLE measure_unit
{
	id          SERIAL PRIMARY KEY,
	name        varchar(50) NOT NULL UNIQUE
};

--роли
CREATE ROLE administrator_role WITH LOGIN PASSWORD '9QrlLHkwMJah3hNoMRlW' SUPERUSER;
CREATE ROLE customer_role WITH LOGIN PASSWORD 'at7DcsAixTk4Eqs7zdp3' NOCREATEDB NOCREATEROLE NOBYPASSRLS;
CREATE ROLE developer_role WITH LOGIN PASSWORD '32BItzvBNem4vEaXxjBb' NOCREATEDB NOCREATEROLE NOBYPASSRLS;
CREATE ROLE unregistered_role WITH LOGIN PASSWORD 'WqQMglB97jPxKw7TCiFc' NOCREATEDB NOCREATEROLE NOBYPASSRLS;

--покупатель
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE purchase TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE customer TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE review TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE cart TO customer_role;
GRANT SELECT ON TABLE administrator TO customer_role;
GRANT SELECT ON TABLE measure_unit TO customer_role;
GRANT SELECT ON TABLE developer TO customer_role;
GRANT SELECT ON TABLE program TO customer_role;
GRANT USAGE, SELECT ON SEQUENCE customer_id_seq TO customer_role;

--разработчик
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE degree_of_belonging TO developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE developer TO developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE program TO developer_role;
GRANT SELECT ON TABLE administrator TO developer_role;
GRANT SELECT ON TABLE measure_unit TO developer_role;
GRANT SELECT ON TABLE daily_stats TO developer_role;
GRANT SELECT ON TABLE customer TO developer_role;
GRANT SELECT ON TABLE review TO developer_role;
GRANT USAGE, SELECT ON SEQUENCE developer_id_seq TO developer_role;

--неавторизованный пользователь
GRANT SELECT ON TABLE administrator TO unregistered_role;
GRANT SELECT ON TABLE customer TO unregistered_role;
GRANT SELECT ON TABLE review TO unregistered_role;
GRANT SELECT ON TABLE developer TO unregistered_role;
GRANT SELECT ON TABLE program TO unregistered_role;
GRANT SELECT ON TABLE measure_unit TO unregistered_role;

INSERT INTO tag
VALUES (1, 'Гонки'),
       (2, 'От третьего лица'),
       (3, 'Шутер'),
       (4, 'От первого лица'),
       (8, 'Головоломка'),
       (9, 'Хоррор'),
       (10, 'Симулятор'),
       (13, 'Для нескольких игроков'),
       (14, 'Аркада'),
       (15, 'Для детей'),
       (12, 'Экшн');

INSERT INTO developer
VALUES (1, NULL, 'SoftDepotDEV', '$2a$10$cyKOCmbGqlTWh6xxuyJEhuzM6sNZ0aJq5hqPpzVov0jyVA60uDA9u', NULL);

INSERT INTO customer
VALUES (1, 'customer1', '$2a$10$YMs3QL44GMSvyQX6F5ZE8ek2PH0dLKLb2nQUSxB8YPNf38MaNIoau', NULL, '2024-12-01 14:30'),
       (2, 'customer2', '$2a$10$qGhYdZ27VcRagzSXH.36y.wYNnzea7azEJj5auBTJngyH2bOBJW2K', NULL, '2024-12-01 14:31'),
       (3, 'customer3', '$2a$10$0TXfQ2XBFLXKhw2Mqt0b4ekS/0KU74svpwnCtahL/tJAYtXeAbulC', NULL, '2024-12-01 14:32');

INSERT INTO program
VALUES (1, 1, 'BeamNG.drive', 880.00, 'Основанный на физике мягких объектов автомобильный симулятор, способный практически на всё.', 'BeamNG.drive - невероятно реалистичный автосимулятор с практически безграничными возможностями. В основе игры лежит система физики мягких объектов, способная правдоподобно моделировать компоненты автомобиля в реальном времени. Благодаря годам кропотливой разработки, исследований и испытаний, BeamNG.drive способен передать весь восторг вождения в реальном мире.', null, null, null, null, null,'2024-12-01 14:33','2024-12-01 14:34'),
       (2, 1, 'Insurgency', 360.00, 'В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.', 'В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.', null, null, null, null, null, '2024-12-01 14:35', null);

INSERT INTO degree_of_belonging
VALUES (1, 1, 2, 2),
       (2, 1, 1, 3),
       (3, 2, 3, 8),
       (4, 2, 4, 9),
       (5, 1, 10, 8);

INSERT INTO purchase VALUES (3, '2024-11-05 13:00:07.000000'),
                            (4, '2024-11-05 13:00:07.000000');

INSERT INTO review VALUES (1, 1, 1, 5, '2024-11-08 10:10:16.000000', '2024-11-08 12:52:04.000000', 'Отличная физика мягких тел, лучшая физика управления автомобилями!'),
                          (2, 2, 1, 4, '2024-11-08 10:10:16.000000', null, 'Не ну мед');
