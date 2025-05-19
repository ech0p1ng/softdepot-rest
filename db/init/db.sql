--администратор
CREATE TABLE administrator
(
    id                 SERIAL PRIMARY KEY,
    password           varchar(60) NOT NULL,
    administrator_name varchar(50) NOT NULL,
    registration_date_time timestamp   NOT NULL
);

--покупатель
CREATE TABLE customer
(
    id                     SERIAL PRIMARY KEY,
    customer_name          varchar(50) NOT NULL,
    password               varchar(60) NOT NULL,
    profile_img_url        varchar(200),
    registration_date_time timestamp   NOT NULL
);

--разработчик
CREATE TABLE developer
(
    id                     SERIAL PRIMARY KEY,
    developer_name         varchar(50) NOT NULL,
    password               varchar(60) NOT NULL,
    profile_img_url        varchar(200),
    registration_date_time timestamp   NOT NULL
);

--единица измерения
CREATE TABLE measure_unit
(
    id         SERIAL PRIMARY KEY,
    name       varchar(50) NOT NULL UNIQUE,
    short_name varchar(50) NOT NULL UNIQUE
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
    short_description     TEXT        NOT NULL,
    description           TEXT        NOT NULL,
    logo_url              varchar(500),
    installer_windows_url varchar(100),
    installer_linux_url   varchar(100),
    installer_macos_url   varchar(100),
    screenshots_url       varchar(500)[],
    upload_date_time      timestamp   NOT NULL,
    update_date_time      timestamp,
    currency              int         NOT NULL REFERENCES measure_unit (id) ON UPDATE CASCADE
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
    program_id         int       NOT NULL REFERENCES program (id) ON UPDATE CASCADE ON DELETE CASCADE,
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
    reviews_amount   int       NOT NULL,
    currency         int       NOT NULL REFERENCES measure_unit (id) ON UPDATE CASCADE
);

--отзыв
CREATE TABLE review
(
    id               SERIAL PRIMARY KEY,
    customer_id      int       NOT NULL REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_id       int       NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE,
    estimation       int       NOT NULL CHECK (estimation >= 0 AND estimation <= 5),
    date_time        timestamp NOT NULL,
    update_date_time timestamp,
    review_text      TEXT      NOT NULL
);

--корзина
CREATE TABLE cart
(
    id          SERIAL PRIMARY KEY,
    customer_id int NOT NULL REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE,
    program_id  int NOT NULL REFERENCES program (id) ON DELETE CASCADE ON UPDATE CASCADE
);

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

INSERT INTO measure_unit
VALUES (1, 'Рубль', 'руб.');

INSERT INTO tag (id, tag_name) VALUES 
(16, 'Текстовый редактор'),
(17, 'Табличный процессор'),
(19, 'Видеоредактор'),
(20, 'Аудиоредактор'),
(21, 'Антивирус'),
(22, 'Браузер'),
(23, 'Мессенджер'),
(24, 'СУБД'),
(25, 'Среда разработки (IDE)'),
(26, 'Редактор кода'),
(27, 'Виртуальная машина'),
(28, 'Мультимедиа-плеер'),
(29, 'Запись экрана'),
(30, 'Утилита'),
(31, 'Бухгалтерия'),
(32, 'Разработка ПО'),
(33, 'Мониторинг состояния ПК'),
(34, 'Файловый проводник'),
(35, 'Читалка'),
(36, 'Дизайн'),
(37, '3D-моделирование'),
(38, 'Игровой движок'),
(39, 'Графический редактор'),
(40, 'Растровая графика'),
(41, 'Векторная графика'),
(42, 'Фоторедактор'),
(43, 'Редактор презентаций'),
(18, 'Офисное ПО'),
(44, 'Научное ПО'),
(45, 'Социальное'),
(46, 'Развлекательное'),
(47, 'Разработка игр'),
(48, 'Интернет'),
(49, 'Музыкальный секвенсор'),
(50, 'Виртуальная реальность (VR)'),
(51, 'Дополненная реальность (AR)'),
(52, '2D-графика'),
(53, '3D-графика');

INSERT INTO administrator VALUES
(1, '$2a$10$t5/BODlYh6END/jpntup8ual66AkaDdRG3ZfL4CY7UJcV27cHnd6q', 'administrator', '2024-12-01 14:28'); --administrator

INSERT INTO developer VALUES
(1, 'SoftDepotDEV', '$2a$10$cyKOCmbGqlTWh6xxuyJEhuzM6sNZ0aJq5hqPpzVov0jyVA60uDA9u', NULL, '2024-12-01 14:29'); --SoftDepotDEV

INSERT INTO customer VALUES 
(1, 'customer1', '$2a$10$YMs3QL44GMSvyQX6F5ZE8ek2PH0dLKLb2nQUSxB8YPNf38MaNIoau', NULL, '2024-12-01 14:30'), --customer1
(2, 'customer2', '$2a$10$qGhYdZ27VcRagzSXH.36y.wYNnzea7azEJj5auBTJngyH2bOBJW2K', NULL, '2024-12-01 14:31'), --customer2
(3, 'customer3', '$2a$10$0TXfQ2XBFLXKhw2Mqt0b4ekS/0KU74svpwnCtahL/tJAYtXeAbulC', NULL, '2024-12-01 14:32'); --customer3

INSERT INTO program VALUES
(17, 1, 'Word', 1499.00, 'Microsoft Word — это текстовый редактор, разработанный компанией Microsoft. Он является частью пакета Microsoft Office и используется для создания, редактирования и форматирования текстовых документов.', 'Microsoft Word — это мощный текстовый редактор, который позволяет пользователям создавать, редактировать и форматировать документы различной сложности. Он входит в состав пакета Microsoft Office и является одной из самых популярных программ для работы с текстом.\n\nОсновные функции:\n1. Создание и редактирование текста:\n2. Поддержка различных шрифтов, размеров и стилей текста.\n3. Возможность выравнивания текста, создания списков и колонок.\n\nФорматирование документов:\n1. Использование стилей для заголовков, подзаголовков и основного текста.\n2. Настройка полей, отступов и интервалов.\n\nРабота с графикой:\n1. Вставка изображений, фигур, диаграмм и SmartArt.\n2. Возможность настройки обтекания текста вокруг графических элементов.\n\nТаблицы и диаграммы:\n1. Создание и форматирование таблиц.\n2. Вставка диаграмм (столбчатых, круговых, линейных и др.).\n\nКоллаборация:\n1. Совместная работа над документами в режиме реального времени через облако (OneDrive, SharePoint).\n2. Возможность комментирования и рецензирования.\n\nИнтеграция с другими программами:\n1. Совместимость с Excel, PowerPoint и другими приложениями Microsoft Office.\n2. Поддержка экспорта документов в форматы PDF, HTML, TXT и другие.\n\nДополнительные инструменты:\n1. Проверка орфографии и грамматики.\n2. Поиск и замена текста.\n3. Автоматическое создание оглавления и сносок.', '/uploads/program/17/0128b0d5-d335-4e64-99d7-1c203138ed55_Microsoft_Office_Word_Logo_512px.png', null, null, null, ARRAY['/uploads/program/17/04fd4a23-3b0f-4a7b-acf6-2d03bc1dcee2_7d129359-4461-47d0-8b82-e0bf043f2e1a.png', '/uploads/program/17/eb0a368c-07d7-432b-b169-00941f73e4cc_microsoft-word-for-windows.png', '/uploads/program/17/e6f804d8-25e1-4c63-83f6-cbefd2bfd764_microsoft-word-mac.png', '/uploads/program/17/cc635c24-4929-41f0-9d5f-3b82949bb2d1_office-home-2024-screenshot-01.png', '/uploads/program/17/9ecd8a4a-4e37-47ec-b27d-b9f6777190ce_word_2024_copilot_1024x1024.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(25, 1, 'Excel', 1499.00, 'Excel — программа для работы с электронными таблицами от Microsoft. Позволяет анализировать данные, создавать графики, выполнять расчеты и автоматизировать задачи. Подходит для бизнеса, учебы и личного использования.', 'Microsoft Excel — мощный инструмент для работы с электронными таблицами, входящий в пакет Microsoft Office. Программа позволяет организовывать, анализировать и визуализировать данные с помощью таблиц, формул, графиков и диаграмм. Excel поддерживает сложные математические, статистические и финансовые расчеты, а также предоставляет возможности для автоматизации задач с помощью макросов и VBA (Visual Basic for Applications). Широко используется в бизнесе, науке, образовании и личных целях для учета, отчетности, планирования и анализа данных.', '/uploads/program/25/70917277-3bc4-43c1-a2a9-eab4d1d4df30_Microsoft_Excel_2013-2019_logo.svg.png', null, null, null, ARRAY['/uploads/program/25/c3e34a1e-70e8-4749-a5c6-371872a5d20a_arrange-excel-files.png' , '/uploads/program/25/0ffccb3f-346f-47ee-9db6-b7da444ba14f_images.jpg' , '/uploads/program/25/5758ede6-d31d-433b-8f24-9db37beeb3ec_print-screen.jpg' , '/uploads/program/25/672feced-9d4b-4fd6-9b95-c4ca264e398b_maxresdefault.jpg'], '2025-03-12 06:21:41.096619', NULL, 1),
(28, 1, 'Blender', 0.00, 'Blender — бесплатная программа для 3D-моделирования, анимации, визуализации и создания игр. Поддерживает скульптинг, симуляции, монтаж видео и композитинг.', 'Blender — это мощное бесплатное программное обеспечение с открытым исходным кодом для 3D-моделирования, анимации, рендеринга, создания игр и визуальных эффектов. Программа включает инструменты для скульптинга, текстурирования, симуляции физики (дым, жидкости, ткани), анимации персонажей, монтажа видео и композитинга. Blender поддерживает множество форматов файлов и предоставляет гибкие настройки рендеринга, включая Cycles и Eevee. Широко используется художниками, дизайнерами, аниматорами и разработчиками игр благодаря своей универсальности и активному сообществу.', '/uploads/program/28/fcc9aee9-8c12-403b-961e-bcd6ba37e508_Blender_logo_no_text.svg.png', null, null, null, ARRAY['/uploads/program/28/96600cbd-7a22-48f4-8210-b538d1047b50_2b5da48c2255771643270fc592273338ee822245.jpeg' , '/uploads/program/28/f12ffbc9-80e4-4b58-964a-ce6ebef38462_4voL6.png' , '/uploads/program/28/9f3af6e8-362b-4203-ba63-4db292c821ac_5d421a5d64a95fab9aeb91813aea81db06ec02f0.png' , '/uploads/program/28/544e0094-6b28-4d08-aa0e-9b79a220f9cd_9447f7f59a2c10fefcb15c6a2777ee2d391fb2e8.png' , '/uploads/program/28/c95211c1-607f-44d5-a4bc-83285b751f7c_11051915122021_08fda0244b5397e030ee401fd2bea5b24f78a72b.jpg' , '/uploads/program/28/64ec1514-7d1d-4f1e-8973-f509eb18169b_Blender_3.2.0_screenshot.png' , '/uploads/program/28/5fd22e1c-1e3d-4514-aa17-e1969e825232_blender_421.png' , '/uploads/program/28/c824a21b-7a5d-46fe-a301-8bbed5880ee5_snapshot-meshes.jpg'], '2025-03-12 06:21:41.096619', NULL, 1),
(27, 1, 'VideoPad Video Editor', 0.00, 'VideoPad Video Editor — программа для редактирования видео. Подходит для монтажа, добавления эффектов, переходов, титров и аудиодорожек. Экспорт в различные форматы.', 'VideoPad Video Editor — это удобный видеоредактор для создания и монтажа видео. Программа позволяет обрезать и склеивать клипы, добавлять эффекты, переходы, текстовые титры, а также накладывать аудиодорожки и звуковые эффекты. VideoPad поддерживает работу с множеством видеоформатов, включая HD и 4K, и предоставляет возможность экспорта готовых проектов для загрузки на YouTube, DVD или других платформ. Подходит как для начинающих, так и для опытных пользователей благодаря интуитивному интерфейсу и широкому набору инструментов.', '/uploads/program/27/abe2cbb8-ffb2-4fa8-808d-2f136857b078_Без имени.jpg', null, null, null, ARRAY['/uploads/program/27/385e15c1-beb2-4a59-820c-1d2e7dbd58ad_78062f44-5347-48f0-ac3a-48e87d2b5742.png' , '/uploads/program/27/75c44702-9af2-41d0-b477-b9203c0fdffc_aaa.jpg.22396c558282a410cd19c302947dfd24.jpg' , '/uploads/program/27/73f03753-082b-409a-bcf9-e3b1649ae484_apps.43698.13939617729822645.65531390-8993-4b0f-9801-d944553dccf4.jpg' , '/uploads/program/27/bcda9daf-644d-4b74-a9eb-b7cfa0672ab6_hq720.jpg' , '/uploads/program/27/82c59b69-9e8c-40bd-bbde-cb13917dc85c_videopad-video-editor-(free).png' , '/uploads/program/27/690fbfe4-e939-438e-8447-e8caeaaeca44_vnw546E3uQNAeesQVhkR6W-1200-80.jpg'], '2025-03-12 06:21:41.096619', NULL, 1),
(26, 1, 'Audacity', 0.00, 'Audacity — бесплатная программа для редактирования аудио. Подходит для записи, монтажа, обработки звука и применения эффектов. Поддерживает множество форматов и плагинов.', 'Audacity — это бесплатное, кроссплатформенное программное обеспечение с открытым исходным кодом для редактирования и записи аудио. Программа позволяет записывать звук с микрофона или других источников, редактировать дорожки (обрезать, копировать, склеивать), применять эффекты (шумоподавление, эквалайзер, реверберация и др.) и работать с множеством аудиоформатов (WAV, MP3, FLAC и т.д.). Audacity поддерживает VST-плагины, многодорожечную запись и экспорт проектов. Широко используется музыкантами, подкастерами, звукорежиссерами и любителями для создания и обработки аудиоконтента.', '/uploads/program/26/c23c63b0-8118-4fa9-8ca9-dd2c929bab85_Audacity_Logo_nofilter.svg.png', null, null, null, ARRAY['/uploads/program/26/21f8bd3a-ebc4-46b8-b13c-8e36cb23e1bb_a6033853e501a57002e2e1d6d8fbf2c6bef89e73.jpeg' , '/uploads/program/26/a0a399e5-03a9-4146-a1c2-310b9f3aa4fe_Audacity_3.6_Screenshot.png' , '/uploads/program/26/b53d9be7-6cdf-4202-aeae-9c5f3eb30320_Audacity_screenshot.png' , '/uploads/program/26/b1fe26bd-7164-45e0-8bc9-3b1c1e1f72cd_Audacity-Screenshot.jpg'], '2025-03-12 06:21:41.096619', NULL, 1),
(29, 1, 'Яндекс Браузер', 0.00, 'Яндекс Браузер — быстрый и удобный браузер с интеграцией сервисов Яндекса. Поддержка Turbo-режима, умной строки, голосового поиска и синхронизации данных.', 'Яндекс Браузер — это современный веб-браузер, разработанный компанией Яндекс. Он отличается высокой скоростью работы, благодаря Turbo-режиму, который ускоряет загрузку страниц при медленном интернете. Браузер интегрирован с сервисами Яндекса, включая поиск, почту, карты и диск. Ключевые функции: умная строка для быстрого поиска и перехода на сайты, голосовой поиск, синхронизация данных между устройствами, встроенный переводчик и защита от вредоносных сайтов. Подходит для пользователей, ценящих удобство и интеграцию с экосистемой Яндекса.', '/uploads/program/29/d48f7d8a-7a90-44a5-894d-0a06439a4449_Yandex_Browser_icon.svg.png', null, null, null, ARRAY['/uploads/program/29/c5b5d17c-0ba3-42d6-a7c3-684dbc04687a_orig.png' , '/uploads/program/29/f927d79d-57c0-4271-84ab-9e6dbc202afe_orig1.png' , '/uploads/program/29/0499f36b-ebb5-45cb-81e1-d28e53e510ce_Screenshot_2023_Yandex.png' , '/uploads/program/29/48ef8030-8184-4369-9e9b-f05b71eaea6e_screenshot-1.jpg' , '/uploads/program/29/d9aaa389-db17-4533-afdd-49d44f2ae979_screenshot-3.png' , '/uploads/program/29/a54b6743-8912-4dbe-8547-4438ee1c34b5_screenshot-6.png' , '/uploads/program/29/7c39099b-f455-4ff4-b277-8e34f96429a3_screenshot-9.jpg' , '/uploads/program/29/8fc38df2-0574-4f3a-853a-d7fa60e097c2_screenshot-10.png' , '/uploads/program/29/e732e0bd-7d73-45d5-82d1-368f6b6cf34a_screenshot-13.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(30, 1, 'Photoshop', 3999.00, 'Photoshop — профессиональный графический редактор для обработки изображений, создания дизайнов и иллюстраций. Поддержка слоев, масок, фильтров и инструментов для точной работы.', 'Adobe Photoshop — это ведущий профессиональный графический редактор, используемый для обработки фотографий, создания дизайнов, иллюстраций и цифрового искусства. Программа предлагает мощные инструменты для работы со слоями, масками, фильтрами, коррекцией цвета и ретушью. Photoshop поддерживает работу с растровой графикой, а также частично с векторной. Широко применяется фотографами, дизайнерами, художниками и маркетологами благодаря своей универсальности и точности. Интегрируется с другими продуктами Adobe, такими как Illustrator и Lightroom.', '/uploads/program/30/28c78396-6b95-464b-b365-e79baa682ee6_Adobe_Photoshop_CC_icon.svg.png', null, null, null, ARRAY['/uploads/program/30/ed935fa8-651c-430e-b530-a1e533f43ebe_photoshop-1.png' , '/uploads/program/30/9e3464f9-9853-4373-9c76-b6835d28a7da_photoshop-2.jpg' , '/uploads/program/30/4649963c-5485-4e40-b1be-715dd6f675bc_photoshop-3.jpg' , '/uploads/program/30/6d601c73-d415-416d-8721-3a7edb8f03db_photoshop-4.png' , '/uploads/program/30/55a72676-448a-4816-a9c9-990fc45e5efb_photoshop-5.jpg' , '/uploads/program/30/e5166ee1-774b-4a43-b686-d850286e587d_photoshop-6.jpg' , '/uploads/program/30/072a2f72-4aba-4ac4-a963-56ab92b1a374_Photoshop-screenshot.JPg'], '2025-03-12 06:21:41.096619', NULL, 1),
(31, 1, 'FL Studio', 1999.00, 'FL Studio — мощная DAW для создания музыки. Подходит для начинающих и профессионалов. Включает синтезаторы, сэмплы, эффекты и инструменты для сведения. Поддержка VST, MIDI и многодорожечной записи. Доступна для Windows и macOS.', 'FL Studio — популярная цифровая аудиостанция (DAW) для создания, аранжировки и сведения музыки. Программа предлагает интуитивный интерфейс, обширную библиотеку звуков, встроенные синтезаторы, сэмплы и эффекты. Поддерживает VST-плагины, MIDI-контроллеры и многодорожечную запись. FL Studio подходит как для начинающих, так и для профессионалов, предоставляя инструменты для создания музыки в различных жанрах. Доступна для Windows и macOS, с регулярными обновлениями и пожизненными апгрейдами.', '/uploads/program/31/70d78c1d-0717-4bf5-bc4e-585967b8afb2_edx7m32v5s671.png', null, null, null, ARRAY['/uploads/program/31/3a5ae212-3d21-4f73-adda-0afc7168adbe_6wyOV9U.png' , '/uploads/program/31/f6ec1a77-a2b8-440e-99f1-3180e70c12b0_GDqAPgU.jpg' , '/uploads/program/31/1e48d5dc-8f61-4d14-b12b-7f6151c7b846_Image-Line_FL_Studio_21_Fruity_Edition_01_Aufmacher_Test.jpg' , '/uploads/program/31/cd3882c5-1945-47d6-bbee-05b4d35b89b6_Image-line-FL-Studio-20-Producer-Edition_Windows.png' , '/uploads/program/31/ca15db0b-3f63-496d-a34c-ae5731cdaab1_Q3VLlTd.png' , '/uploads/program/31/c03c70a4-a0a1-4284-98a4-b4f3f0c8f093_ywr0bcxm0ih41.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(32, 1, 'Telegram', 0.00, 'Telegram — мессенджер с высокой безопасностью, быстрой доставкой сообщений и поддержкой групповых чатов до 200 000 участников. Доступен на всех платформах, с облачным хранением и секретными чатами.', 'Telegram — это кроссплатформенный мессенджер, ориентированный на скорость и безопасность. Он позволяет отправлять текстовые сообщения, голосовые заметки, фото, видео и файлы любого формата. Telegram поддерживает групповые чаты до 200 000 участников, каналы для широковещательных сообщений и секретные чаты с end-to-end шифрованием. Все данные хранятся в облаке, что обеспечивает доступ к ним с любого устройства. Приложение доступно на iOS, Android, Windows, macOS и Linux. Telegram также предлагает API для разработчиков и ботов, что делает его гибким инструментом для общения и автоматизации задач.', '/uploads/program/32/d2f37f23-afba-40c3-9fd5-970b0a17a1a4_telegram.webp', null, null, null, ARRAY['/uploads/program/32/fe84cb49-5659-45ab-a81b-c5962489e235_260a84021f203c3bc1.jpg' , '/uploads/program/32/9c735cda-bc9c-48f7-9aa0-f2808fccc71a_a7c0863af9ecc4b3af.jpg' , '/uploads/program/32/1d6c1ed9-8b7a-4e17-a3b9-3ffe5daf5c93_home-screen.png' , '/uploads/program/32/6c814964-e996-4efc-b08d-9b7cfbedb853_img3File.png' , '/uploads/program/32/a3ae73d7-4690-4be8-bab9-c6a7bd4f64e4_preview.png' , '/uploads/program/32/10083446-7a06-4454-ba57-a14a3a6882aa_telegram-for-desktop-screenshot-01.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(33, 1, 'Unity', 0.00, 'Unity — мощный движок для разработки 2D/3D игр и приложений. Подходит для indie-разработчиков и крупных студий. Кроссплатформенность, поддержка VR/AR, богатый набор инструментов и активное сообщество.', 'Unity — это универсальный игровой движок для создания 2D и 3D игр, а также интерактивных приложений. Он широко используется indie-разработчиками и крупными студиями благодаря своей гибкости, кроссплатформенности (поддержка PC, консолей, мобильных устройств, VR/AR) и богатому набору инструментов. Unity предлагает визуальный редактор, мощную физику, анимацию, систему частиц и поддержку скриптинга на C#. Встроенный Asset Store позволяет использовать готовые ресурсы и плагины. Движок также активно применяется в неигровых сферах, таких как архитектура, кино и образование. Unity имеет большое сообщество и регулярно обновляется, что делает его одним из самых популярных инструментов для разработки.', '/uploads/program/33/eca8349e-53a1-4e56-95f5-843a2d81664b_Unity_Logo.png', null, null, null, ARRAY['/uploads/program/33/73b9661d-696d-4ad5-b41f-7d87100bb295_92cfbd2c7963f46fe81748e5e2d3c6715ef504ac.jpeg' , '/uploads/program/33/5d1ef98b-1386-4101-8ccd-9c890bf28dff_582ca9ee52b72830781322439c73d550146cfbee.jpeg' , '/uploads/program/33/c0f7120e-c205-4ebd-ab82-a630a28e910a_954c258da9ed801fcc144714c88ebc568666051a.jpeg' , '/uploads/program/33/0fa76d43-7e5b-43a7-9e2e-f4866b1b56ec_C4PK6.jpg' , '/uploads/program/33/0fdd3905-362a-4d2d-a0ff-333d41515e92_f6b7f7bc60326b3013c19c4608c41bca1358a7be.jpeg' , '/uploads/program/33/e3e7becb-5c6a-488f-a788-725cdb9ce12f_maxresdefault.jpg' , '/uploads/program/33/d82e981d-525e-4a34-995c-8a98c6e28301_PickandPlaceWorkflowInUnity3DUsingROSExample_25.png' , '/uploads/program/33/eaa588d6-0a14-43a2-9bcb-4afe9a96cfd5_screenshot-1.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(34, 1, 'Unreal Engine', 1999.00, 'Unreal Engine — мощный движок для создания AAA-игр, VR/AR и визуализаций. Высококачественная графика, Blueprint для визуального скриптинга, кроссплатформенность и открытый исходный код.', 'Unreal Engine — это профессиональный игровой движок, разработанный Epic Games, для создания AAA-игр, виртуальной и дополненной реальности (VR/AR), а также визуализаций в кино и архитектуре. Движок славится своей продвинутой графикой, включая реалистичное освещение, физику и постобработку. Unreal Engine предлагает инструмент Blueprint для визуального скриптинга, что упрощает разработку без глубоких знаний программирования, а также поддерживает C++ для более сложных задач. Движок является кроссплатформенным (PC, консоли, мобильные устройства) и предоставляет доступ к исходному коду. Unreal Engine активно используется в индустрии благодаря своей гибкости, мощным инструментам и активному сообществу.', '/uploads/program/34/47c8b5e3-2855-418c-b7b6-ac19bafc703b_Unreal_Engine-Logo.wine.png', null, null, null, ARRAY['/uploads/program/34/8ffb512f-bd00-45e8-9b2c-057aa659af3e_4c3ab52ef7de29f05d505dac4b71162d3e5146e7.jpeg' , '/uploads/program/34/afeec4f8-0896-4c8c-96fe-546c77d037ee_0823c67517a5cddd70f098cea475e40bef3f9d4b.jpg' , '/uploads/program/34/3185248f-a38f-4263-a6d9-a99c3e60d0a6_clinton-crumpler-step-07.jpg' , '/uploads/program/34/5348ac62-22de-4473-8675-19cdc9fa1326_fe7aadbffcbf4044a62a7f73d9e28a2c2259edfe.jpeg' , '/uploads/program/34/06127711-2708-4ef8-a93b-e291264aa7b6_ff0402159e26ebd9af2e8df28f13538e06fa4edd.jpeg','/uploads/program/34/169d36da-be06-48bc-bc79-86bbc17db206_Learning to Create 360 Screenshots in Unreal Engine 3.png",/uploads/program/34/bb3697ec-f1eb-4c46-a2b6-e9c8e13d8615_maxresdefault.jpg' , '/uploads/program/34/1de6593f-7cab-466b-a1a8-a3594ae3b3f8_unreal-dev.webp' , '/uploads/program/34/83baec62-c4c1-4cad-8474-85b7939470ad_Unreal-Engine_1.jpg' , '/uploads/program/34/2620864f-6722-4863-b234-53279bbb6707_unreal-engine-screenshot-03.png'], '2025-03-12 06:21:41.096619', NULL, 1),
(24, 1, 'PowerPoint', 1499.00, 'Microsoft PowerPoint — программа для создания презентаций. Позволяет добавлять слайды с текстом, изображениями, графиками и анимацией. Используется для бизнеса, образования и публичных выступлений.', 'Microsoft PowerPoint — это мощное приложение для создания и проведения презентаций, входящее в пакет Microsoft Office. Оно позволяет пользователям создавать профессиональные слайд-шоу с использованием текста, изображений, графиков, диаграмм, видео и анимации.\r\nСоздание слайдов:\r\n· Шаблоны для быстрого старта.\r\n· Настройка макетов слайдов (заголовки, текст, изображения).\r\nМультимедиа:\r\n· Вставка изображений, аудио и видео.\r\n· Анимация текста и объектов.\r\nДизайн:\r\n· Темы и стили для оформления презентаций.\r\n· Настройка цветов, шрифтов и эффектов.\r\nГрафики и диаграммы:\r\n· Создание визуализаций данных (столбчатые, круговые, линейные диаграммы).\r\nКоллаборация:\r\n· Совместная работа в реальном времени через облако (OneDrive, SharePoint).\r\n· Комментирование и рецензирование.\r\nПрезентация:\r\n· Режим докладчика с заметками.\r\n· Экспорт в PDF или видеоформат.', '/uploads/program/24/43c3a4bd-df92-4202-8225-ed8c14aa6edd_Microsoft_Office_PowerPoint_(2019–present).svg.png', null, null, null, ARRAY['/uploads/program/24/1f7e5ca4-9999-4676-b087-2f3803f6a12b_01EN.png' , '/uploads/program/24/6c1ae9da-85d4-4dde-bf42-4484851bc851_powerpoint-2023-powerpoint-load.png' , '/uploads/program/24/d4238c9d-5ee6-4114-86fd-1baa5357df9f_powerpoint-2023-powerpoint-load-2.png' , '/uploads/program/24/dbe92ae0-f202-44d1-bc56-feb7c4730dab_powerpoint-2023-powerpoint-load-3.png' , '/uploads/program/24/88a2b705-5ec7-4bbc-a9fb-695f152d1d39_powerpoint-2023-powerpoint-load-4.png' , '/uploads/program/24/df4464f5-b6ca-4ffc-ad61-26a02f2df5a7_powerpoint-designer.jpg'], '2025-03-12 06:21:41.096619', NULL, 1);


INSERT INTO degree_of_belonging VALUES 
(34, 17, 16, 10),
(35, 17, 18, 10),
(36, 17, 17, 5),
(37, 17, 35, 5),
(56, 24, 43, 10),
(57, 24, 18, 10),
(58, 24, 36, 3),
(59, 25, 17, 10),
(60, 25, 18, 10),
(61, 25, 44, 6),
(62, 26, 20, 10),
(63, 26, 28, 5),
(64, 26, 30, 4),
(65, 27, 19, 10),
(66, 27, 39, 2),
(67, 27, 28, 3),
(68, 28, 37, 10),
(69, 28, 39, 10),
(70, 28, 40, 10),
(71, 28, 47, 8),
(72, 29, 22, 10),
(73, 29, 48, 10),
(74, 29, 28, 5),
(75, 29, 32, 3),
(76, 30, 39, 10),
(77, 30, 42, 10),
(78, 30, 36, 5),
(79, 30, 40, 10),
(80, 31, 20, 10),
(81, 31, 49, 10),
(82, 32, 23, 10),
(83, 32, 45, 10),
(89, 34, 38, 10),
(90, 34, 52, 8),
(91, 34, 53, 10),
(92, 34, 50, 10),
(93, 34, 51, 10),
(94, 34, 47, 10),
(95, 34, 32, 10),
(96, 34, 19, 5),
(97, 33, 38, 10),
(98, 33, 52, 8),
(99, 33, 53, 10),
(100, 33, 50, 10),
(101, 33, 51, 10),
(102, 33, 47, 10),
(103, 33, 32, 10),
(104, 33, 19, 5);

INSERT INTO purchase VALUES 
(23, '2025-03-12 06:20:15.118681', 1, 17, 1),
(24, '2025-03-15 10:03:37.186187', 3, 27, 1),
(25, '2025-03-15 10:03:37.186187', 3, 29, 1),
(26, '2025-03-15 10:03:37.185186', 3, 26, 1),
(27, '2025-03-15 10:03:37.186187', 3, 24, 1),
(28, '2025-03-15 10:03:37.186187', 3, 28, 1),
(29, '2025-03-15 10:03:37.185186', 3, 25, 1),
(30, '2025-03-15 10:03:37.201187', 3, 34, 1),
(31, '2025-03-15 10:03:37.202186', 3, 32, 1),
(32, '2025-03-15 10:03:37.202186', 3, 31, 1),
(33, '2025-03-15 10:03:37.202186', 3, 33, 1),
(34, '2025-03-15 10:03:37.202186', 3, 30, 1),
(35, '2025-03-15 10:25:03.908005', 3, 17, 1),
(36, '2025-03-15 11:03:01.791294', 2, 33, 1),
(37, '2025-03-15 13:58:30.726029', 2, 25, 1);

INSERT INTO review (id, customer_id, program_id, estimation, date_time, review_text) VALUES 
(3, 1, 17, 5, '2025-03-12 06:21:41.096619', 'Отличный редактор документов!'),
(4, 3, 24, 5, '2025-03-15 10:04:28.370282', 'Отличная программа для презентаций!'),
(5, 3, 17, 4, '2025-03-15 10:25:20.472183', 'Иногда случаются баги'),
(6, 3, 25, 5, '2025-03-15 10:38:20.790126', 'Хороший редактор таблиц'),
(7, 3, 26, 4, '2025-03-15 10:38:56.818675', 'Хороший аудиоредактор, но интерфейс немного неудобный'),
(8, 3, 27, 3, '2025-03-15 10:40:13.40328', 'Неплохо для маленьких проектов, неудобное редактирование эффектов для видео, которое потребляет слишком много ресурсов ПК'),
(9, 3, 28, 5, '2025-03-15 10:40:53.664216', 'Подходит как для новичков, так и для профессионалов'),
(10, 3, 29, 4, '2025-03-15 10:41:20.888897', 'Неплохой браузер'),
(11, 3, 30, 5, '2025-03-15 10:41:46.318574', 'Лучший редактор изображений'),
(12, 3, 31, 5, '2025-03-15 10:42:20.957281', 'Подходит для написания битов как новичкам, так и профессионалам'),
(13, 3, 32, 5, '2025-03-15 10:42:48.20217', 'Лучший мессенджер'),
(15, 3, 34, 4, '2025-03-15 10:46:15.22672', 'Необходим высокий уровень навыков разработчика, чтобы игры были оптимизированными, иначе даже простейшие проекты требуют много ресурсов. Не рекомендую использовать Lumen, особенно программный, эта технология еще слишком сырая. Лучше использовать аппаратный Ray Tracing.'),
(14, 3, 33, 4, '2025-03-15 10:43:45.627284', 'Этот движок хорош для инди-разработчиков и просто начинающих, в том числе благодаря скриптам на C#, но для больших проектов лучше найти другой движок');


SELECT setval(pg_get_serial_sequence('administrator', 'id'), coalesce(max(id), 1))
FROM administrator;
SELECT setval(pg_get_serial_sequence('cart', 'id'), coalesce(max(id), 1))
FROM cart;
SELECT setval(pg_get_serial_sequence('customer', 'id'), coalesce(max(id), 1))
FROM customer;
SELECT setval(pg_get_serial_sequence('daily_stats', 'id'), coalesce(max(id), 1))
FROM daily_stats;
SELECT setval(pg_get_serial_sequence('degree_of_belonging', 'id'), coalesce(max(id), 1))
FROM degree_of_belonging;
SELECT setval(pg_get_serial_sequence('developer', 'id'), coalesce(max(id), 1))
FROM developer;
SELECT setval(pg_get_serial_sequence('program', 'id'), coalesce(max(id), 1))
FROM program;
SELECT setval(pg_get_serial_sequence('purchase', 'id'), coalesce(max(id), 1))
FROM purchase;
SELECT setval(pg_get_serial_sequence('review', 'id'), coalesce(max(id), 1))
FROM review;
SELECT setval(pg_get_serial_sequence('tag', 'id'), coalesce(max(id), 1))
FROM tag;
