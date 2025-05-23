--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: administrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrator (
    id integer NOT NULL,
    password character varying(60) NOT NULL,
    administrator_name character varying(50) NOT NULL
);


ALTER TABLE public.administrator OWNER TO postgres;

--
-- Name: administrator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.administrator_id_seq OWNER TO postgres;

--
-- Name: administrator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;


--
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_id_seq OWNER TO postgres;

--
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    customer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200),
    balance numeric(10,2),
    CONSTRAINT customer_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_id_seq OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;


--
-- Name: daily_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_stats (
    id integer NOT NULL,
    stats_date timestamp without time zone NOT NULL,
    program_id integer NOT NULL,
    avg_estimation double precision NOT NULL,
    earnings numeric(10,2),
    purchases_amount integer NOT NULL,
    reviews_amount integer NOT NULL,
    CONSTRAINT daily_stats_avg_estimation_check CHECK (((avg_estimation >= (0)::double precision) AND (avg_estimation <= (5)::double precision))),
    CONSTRAINT daily_stats_earnings_check CHECK ((earnings >= (0)::numeric))
);


ALTER TABLE public.daily_stats OWNER TO postgres;

--
-- Name: daily_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_stats_id_seq OWNER TO postgres;

--
-- Name: daily_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.daily_stats_id_seq OWNED BY public.daily_stats.id;


--
-- Name: degree_of_belonging; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.degree_of_belonging (
    id integer NOT NULL,
    program_id integer NOT NULL,
    tag_id integer NOT NULL,
    degree_value integer NOT NULL,
    CONSTRAINT degree_of_belonging_degree_value_check CHECK (((degree_value >= 0) AND (degree_value <= 10)))
);


ALTER TABLE public.degree_of_belonging OWNER TO postgres;

--
-- Name: degree_of_belonging_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.degree_of_belonging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.degree_of_belonging_id_seq OWNER TO postgres;

--
-- Name: degree_of_belonging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.degree_of_belonging_id_seq OWNED BY public.degree_of_belonging.id;


--
-- Name: developer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.developer (
    id integer NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200)
);


ALTER TABLE public.developer OWNER TO postgres;

--
-- Name: developer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.developer_id_seq OWNER TO postgres;

--
-- Name: developer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;


--
-- Name: program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program (
    id integer NOT NULL,
    developer_id integer NOT NULL,
    program_name character varying(50) NOT NULL,
    price numeric(10,2),
    short_description character varying NOT NULL,
    description character varying NOT NULL,
    logo_url text,
    installer_windows_url character varying(100),
    installer_linux_url character varying(100),
    installer_macos_url character varying(100),
    screenshots_url text[],
    CONSTRAINT program_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE public.program OWNER TO postgres;

--
-- Name: program_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_id_seq OWNER TO postgres;

--
-- Name: program_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_id_seq OWNED BY public.program.id;


--
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    id integer NOT NULL,
    purchase_date_time timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- Name: purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchase_id_seq OWNER TO postgres;

--
-- Name: purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;


--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL,
    estimation integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    review_text text NOT NULL,
    CONSTRAINT review_estimation_check CHECK (((estimation >= 0) AND (estimation <= 5)))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_id_seq OWNER TO postgres;

--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_id_seq OWNER TO postgres;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;


--
-- Name: administrator id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);


--
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: daily_stats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_stats ALTER COLUMN id SET DEFAULT nextval('public.daily_stats_id_seq'::regclass);


--
-- Name: degree_of_belonging id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging ALTER COLUMN id SET DEFAULT nextval('public.degree_of_belonging_id_seq'::regclass);


--
-- Name: developer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);


--
-- Name: program id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_id_seq'::regclass);


--
-- Name: purchase id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);


--
-- Name: review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);


--
-- Name: tag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);


--
-- Data for Name: administrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrator (id, password, administrator_name) FROM stdin;
1	$2a$10$t5/BODlYh6END/jpntup8ual66AkaDdRG3ZfL4CY7UJcV27cHnd6q	administrator
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, customer_id, program_id) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM stdin;
1	customer1	$2a$10$YMs3QL44GMSvyQX6F5ZE8ek2PH0dLKLb2nQUSxB8YPNf38MaNIoau	\N	0.00
2	customer2	$2a$10$qGhYdZ27VcRagzSXH.36y.wYNnzea7azEJj5auBTJngyH2bOBJW2K	\N	0.00
3	customer3	$2a$10$0TXfQ2XBFLXKhw2Mqt0b4ekS/0KU74svpwnCtahL/tJAYtXeAbulC	\N	0.00
\.


--
-- Data for Name: daily_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
\.


--
-- Data for Name: degree_of_belonging; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
34	17	16	10
35	17	18	10
36	17	17	5
37	17	35	5
56	24	43	10
57	24	18	10
58	24	36	3
59	25	17	10
60	25	18	10
61	25	44	6
62	26	20	10
63	26	28	5
64	26	30	4
65	27	19	10
66	27	39	2
67	27	28	3
68	28	37	10
69	28	39	10
70	28	40	10
71	28	47	8
72	29	22	10
73	29	48	10
74	29	28	5
75	29	32	3
76	30	39	10
77	30	42	10
78	30	36	5
79	30	40	10
80	31	20	10
81	31	49	10
82	32	23	10
83	32	45	10
89	34	38	10
90	34	52	8
91	34	53	10
92	34	50	10
93	34	51	10
94	34	47	10
95	34	32	10
96	34	19	5
97	33	38	10
98	33	52	8
99	33	53	10
100	33	50	10
101	33	51	10
102	33	47	10
103	33	32	10
104	33	19	5
\.


--
-- Data for Name: developer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.developer (id, developer_name, password, profile_img_url) FROM stdin;
1	SoftDepotDEV	$2a$10$VMRYIXl18B/xp75ZlzikQ.b4dcnJ6JiRFa6fr5tsLlwATvr47db22	\N
\.


--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM stdin;
17	1	Word	1499.00	Microsoft Word — это текстовый редактор, разработанный компанией Microsoft. Он является частью пакета Microsoft Office и используется для создания, редактирования и форматирования текстовых документов.	Microsoft Word — это мощный текстовый редактор, который позволяет пользователям создавать, редактировать и форматировать документы различной сложности. Он входит в состав пакета Microsoft Office и является одной из самых популярных программ для работы с текстом.\n\nОсновные функции:\n1. Создание и редактирование текста:\n2. Поддержка различных шрифтов, размеров и стилей текста.\n3. Возможность выравнивания текста, создания списков и колонок.\n\nФорматирование документов:\n1. Использование стилей для заголовков, подзаголовков и основного текста.\n2. Настройка полей, отступов и интервалов.\n\nРабота с графикой:\n1. Вставка изображений, фигур, диаграмм и SmartArt.\n2. Возможность настройки обтекания текста вокруг графических элементов.\n\nТаблицы и диаграммы:\n1. Создание и форматирование таблиц.\n2. Вставка диаграмм (столбчатых, круговых, линейных и др.).\n\nКоллаборация:\n1. Совместная работа над документами в режиме реального времени через облако (OneDrive, SharePoint).\n2. Возможность комментирования и рецензирования.\n\nИнтеграция с другими программами:\n1. Совместимость с Excel, PowerPoint и другими приложениями Microsoft Office.\n2. Поддержка экспорта документов в форматы PDF, HTML, TXT и другие.\n\nДополнительные инструменты:\n1. Проверка орфографии и грамматики.\n2. Поиск и замена текста.\n3. Автоматическое создание оглавления и сносок.	/uploads/program/17/0128b0d5-d335-4e64-99d7-1c203138ed55_Microsoft_Office_Word_Logo_512px.png	\N	\N	\N	{/uploads/program/17/04fd4a23-3b0f-4a7b-acf6-2d03bc1dcee2_7d129359-4461-47d0-8b82-e0bf043f2e1a.png,/uploads/program/17/eb0a368c-07d7-432b-b169-00941f73e4cc_microsoft-word-for-windows.png,/uploads/program/17/e6f804d8-25e1-4c63-83f6-cbefd2bfd764_microsoft-word-mac.png,/uploads/program/17/cc635c24-4929-41f0-9d5f-3b82949bb2d1_office-home-2024-screenshot-01.png,/uploads/program/17/9ecd8a4a-4e37-47ec-b27d-b9f6777190ce_word_2024_copilot_1024x1024.png}
25	1	Excel	1499.00	Excel — программа для работы с электронными таблицами от Microsoft. Позволяет анализировать данные, создавать графики, выполнять расчеты и автоматизировать задачи. Подходит для бизнеса, учебы и личного использования.	Microsoft Excel — мощный инструмент для работы с электронными таблицами, входящий в пакет Microsoft Office. Программа позволяет организовывать, анализировать и визуализировать данные с помощью таблиц, формул, графиков и диаграмм. Excel поддерживает сложные математические, статистические и финансовые расчеты, а также предоставляет возможности для автоматизации задач с помощью макросов и VBA (Visual Basic for Applications). Широко используется в бизнесе, науке, образовании и личных целях для учета, отчетности, планирования и анализа данных.	/uploads/program/25/70917277-3bc4-43c1-a2a9-eab4d1d4df30_Microsoft_Excel_2013-2019_logo.svg.png	\N	\N	\N	{/uploads/program/25/c3e34a1e-70e8-4749-a5c6-371872a5d20a_arrange-excel-files.png,/uploads/program/25/0ffccb3f-346f-47ee-9db6-b7da444ba14f_images.jpg,/uploads/program/25/5758ede6-d31d-433b-8f24-9db37beeb3ec_print-screen.jpg,/uploads/program/25/672feced-9d4b-4fd6-9b95-c4ca264e398b_maxresdefault.jpg}
28	1	Blender	0.00	Blender — бесплатная программа для 3D-моделирования, анимации, визуализации и создания игр. Поддерживает скульптинг, симуляции, монтаж видео и композитинг.	Blender — это мощное бесплатное программное обеспечение с открытым исходным кодом для 3D-моделирования, анимации, рендеринга, создания игр и визуальных эффектов. Программа включает инструменты для скульптинга, текстурирования, симуляции физики (дым, жидкости, ткани), анимации персонажей, монтажа видео и композитинга. Blender поддерживает множество форматов файлов и предоставляет гибкие настройки рендеринга, включая Cycles и Eevee. Широко используется художниками, дизайнерами, аниматорами и разработчиками игр благодаря своей универсальности и активному сообществу.	/uploads/program/28/fcc9aee9-8c12-403b-961e-bcd6ba37e508_Blender_logo_no_text.svg.png	\N	\N	\N	{/uploads/program/28/96600cbd-7a22-48f4-8210-b538d1047b50_2b5da48c2255771643270fc592273338ee822245.jpeg,/uploads/program/28/f12ffbc9-80e4-4b58-964a-ce6ebef38462_4voL6.png,/uploads/program/28/9f3af6e8-362b-4203-ba63-4db292c821ac_5d421a5d64a95fab9aeb91813aea81db06ec02f0.png,/uploads/program/28/544e0094-6b28-4d08-aa0e-9b79a220f9cd_9447f7f59a2c10fefcb15c6a2777ee2d391fb2e8.png,/uploads/program/28/c95211c1-607f-44d5-a4bc-83285b751f7c_11051915122021_08fda0244b5397e030ee401fd2bea5b24f78a72b.jpg,/uploads/program/28/64ec1514-7d1d-4f1e-8973-f509eb18169b_Blender_3.2.0_screenshot.png,/uploads/program/28/5fd22e1c-1e3d-4514-aa17-e1969e825232_blender_421.png,/uploads/program/28/c824a21b-7a5d-46fe-a301-8bbed5880ee5_snapshot-meshes.jpg}
27	1	VideoPad Video Editor	0.00	VideoPad Video Editor — программа для редактирования видео. Подходит для монтажа, добавления эффектов, переходов, титров и аудиодорожек. Экспорт в различные форматы.	VideoPad Video Editor — это удобный видеоредактор для создания и монтажа видео. Программа позволяет обрезать и склеивать клипы, добавлять эффекты, переходы, текстовые титры, а также накладывать аудиодорожки и звуковые эффекты. VideoPad поддерживает работу с множеством видеоформатов, включая HD и 4K, и предоставляет возможность экспорта готовых проектов для загрузки на YouTube, DVD или других платформ. Подходит как для начинающих, так и для опытных пользователей благодаря интуитивному интерфейсу и широкому набору инструментов.	/uploads/program/27/abe2cbb8-ffb2-4fa8-808d-2f136857b078_Без имени.jpg	\N	\N	\N	{/uploads/program/27/385e15c1-beb2-4a59-820c-1d2e7dbd58ad_78062f44-5347-48f0-ac3a-48e87d2b5742.png,/uploads/program/27/75c44702-9af2-41d0-b477-b9203c0fdffc_aaa.jpg.22396c558282a410cd19c302947dfd24.jpg,/uploads/program/27/73f03753-082b-409a-bcf9-e3b1649ae484_apps.43698.13939617729822645.65531390-8993-4b0f-9801-d944553dccf4.jpg,/uploads/program/27/bcda9daf-644d-4b74-a9eb-b7cfa0672ab6_hq720.jpg,/uploads/program/27/82c59b69-9e8c-40bd-bbde-cb13917dc85c_videopad-video-editor-(free).png,/uploads/program/27/690fbfe4-e939-438e-8447-e8caeaaeca44_vnw546E3uQNAeesQVhkR6W-1200-80.jpg}
26	1	Audacity	0.00	Audacity — бесплатная программа для редактирования аудио. Подходит для записи, монтажа, обработки звука и применения эффектов. Поддерживает множество форматов и плагинов.	Audacity — это бесплатное, кроссплатформенное программное обеспечение с открытым исходным кодом для редактирования и записи аудио. Программа позволяет записывать звук с микрофона или других источников, редактировать дорожки (обрезать, копировать, склеивать), применять эффекты (шумоподавление, эквалайзер, реверберация и др.) и работать с множеством аудиоформатов (WAV, MP3, FLAC и т.д.). Audacity поддерживает VST-плагины, многодорожечную запись и экспорт проектов. Широко используется музыкантами, подкастерами, звукорежиссерами и любителями для создания и обработки аудиоконтента.	/uploads/program/26/c23c63b0-8118-4fa9-8ca9-dd2c929bab85_Audacity_Logo_nofilter.svg.png	\N	\N	\N	{/uploads/program/26/21f8bd3a-ebc4-46b8-b13c-8e36cb23e1bb_a6033853e501a57002e2e1d6d8fbf2c6bef89e73.jpeg,/uploads/program/26/a0a399e5-03a9-4146-a1c2-310b9f3aa4fe_Audacity_3.6_Screenshot.png,/uploads/program/26/b53d9be7-6cdf-4202-aeae-9c5f3eb30320_Audacity_screenshot.png,/uploads/program/26/b1fe26bd-7164-45e0-8bc9-3b1c1e1f72cd_Audacity-Screenshot.jpg}
29	1	Яндекс Браузер	0.00	Яндекс Браузер — быстрый и удобный браузер с интеграцией сервисов Яндекса. Поддержка Turbo-режима, умной строки, голосового поиска и синхронизации данных.	Яндекс Браузер — это современный веб-браузер, разработанный компанией Яндекс. Он отличается высокой скоростью работы, благодаря Turbo-режиму, который ускоряет загрузку страниц при медленном интернете. Браузер интегрирован с сервисами Яндекса, включая поиск, почту, карты и диск. Ключевые функции: умная строка для быстрого поиска и перехода на сайты, голосовой поиск, синхронизация данных между устройствами, встроенный переводчик и защита от вредоносных сайтов. Подходит для пользователей, ценящих удобство и интеграцию с экосистемой Яндекса.	/uploads/program/29/d48f7d8a-7a90-44a5-894d-0a06439a4449_Yandex_Browser_icon.svg.png	\N	\N	\N	{/uploads/program/29/c5b5d17c-0ba3-42d6-a7c3-684dbc04687a_orig.png,/uploads/program/29/f927d79d-57c0-4271-84ab-9e6dbc202afe_orig1.png,/uploads/program/29/0499f36b-ebb5-45cb-81e1-d28e53e510ce_Screenshot_2023_Yandex.png,/uploads/program/29/48ef8030-8184-4369-9e9b-f05b71eaea6e_screenshot-1.jpg,/uploads/program/29/d9aaa389-db17-4533-afdd-49d44f2ae979_screenshot-3.png,/uploads/program/29/a54b6743-8912-4dbe-8547-4438ee1c34b5_screenshot-6.png,/uploads/program/29/7c39099b-f455-4ff4-b277-8e34f96429a3_screenshot-9.jpg,/uploads/program/29/8fc38df2-0574-4f3a-853a-d7fa60e097c2_screenshot-10.png,/uploads/program/29/e732e0bd-7d73-45d5-82d1-368f6b6cf34a_screenshot-13.png}
30	1	Photoshop	3999.00	Photoshop — профессиональный графический редактор для обработки изображений, создания дизайнов и иллюстраций. Поддержка слоев, масок, фильтров и инструментов для точной работы.	Adobe Photoshop — это ведущий профессиональный графический редактор, используемый для обработки фотографий, создания дизайнов, иллюстраций и цифрового искусства. Программа предлагает мощные инструменты для работы со слоями, масками, фильтрами, коррекцией цвета и ретушью. Photoshop поддерживает работу с растровой графикой, а также частично с векторной. Широко применяется фотографами, дизайнерами, художниками и маркетологами благодаря своей универсальности и точности. Интегрируется с другими продуктами Adobe, такими как Illustrator и Lightroom.	/uploads/program/30/28c78396-6b95-464b-b365-e79baa682ee6_Adobe_Photoshop_CC_icon.svg.png	\N	\N	\N	{/uploads/program/30/ed935fa8-651c-430e-b530-a1e533f43ebe_photoshop-1.png,/uploads/program/30/9e3464f9-9853-4373-9c76-b6835d28a7da_photoshop-2.jpg,/uploads/program/30/4649963c-5485-4e40-b1be-715dd6f675bc_photoshop-3.jpg,/uploads/program/30/6d601c73-d415-416d-8721-3a7edb8f03db_photoshop-4.png,/uploads/program/30/55a72676-448a-4816-a9c9-990fc45e5efb_photoshop-5.jpg,/uploads/program/30/e5166ee1-774b-4a43-b686-d850286e587d_photoshop-6.jpg,/uploads/program/30/072a2f72-4aba-4ac4-a963-56ab92b1a374_Photoshop-screenshot.JPG}
31	1	FL Studio	1999.00	FL Studio — мощная DAW для создания музыки. Подходит для начинающих и профессионалов. Включает синтезаторы, сэмплы, эффекты и инструменты для сведения. Поддержка VST, MIDI и многодорожечной записи. Доступна для Windows и macOS.	FL Studio — популярная цифровая аудиостанция (DAW) для создания, аранжировки и сведения музыки. Программа предлагает интуитивный интерфейс, обширную библиотеку звуков, встроенные синтезаторы, сэмплы и эффекты. Поддерживает VST-плагины, MIDI-контроллеры и многодорожечную запись. FL Studio подходит как для начинающих, так и для профессионалов, предоставляя инструменты для создания музыки в различных жанрах. Доступна для Windows и macOS, с регулярными обновлениями и пожизненными апгрейдами.	/uploads/program/31/70d78c1d-0717-4bf5-bc4e-585967b8afb2_edx7m32v5s671.png	\N	\N	\N	{/uploads/program/31/3a5ae212-3d21-4f73-adda-0afc7168adbe_6wyOV9U.png,/uploads/program/31/f6ec1a77-a2b8-440e-99f1-3180e70c12b0_GDqAPgU.jpg,/uploads/program/31/1e48d5dc-8f61-4d14-b12b-7f6151c7b846_Image-Line_FL_Studio_21_Fruity_Edition_01_Aufmacher_Test.jpg,/uploads/program/31/cd3882c5-1945-47d6-bbee-05b4d35b89b6_Image-line-FL-Studio-20-Producer-Edition_Windows.png,/uploads/program/31/ca15db0b-3f63-496d-a34c-ae5731cdaab1_Q3VLlTd.png,/uploads/program/31/c03c70a4-a0a1-4284-98a4-b4f3f0c8f093_ywr0bcxm0ih41.png}
32	1	Telegram	0.00	Telegram — мессенджер с высокой безопасностью, быстрой доставкой сообщений и поддержкой групповых чатов до 200 000 участников. Доступен на всех платформах, с облачным хранением и секретными чатами.	Telegram — это кроссплатформенный мессенджер, ориентированный на скорость и безопасность. Он позволяет отправлять текстовые сообщения, голосовые заметки, фото, видео и файлы любого формата. Telegram поддерживает групповые чаты до 200 000 участников, каналы для широковещательных сообщений и секретные чаты с end-to-end шифрованием. Все данные хранятся в облаке, что обеспечивает доступ к ним с любого устройства. Приложение доступно на iOS, Android, Windows, macOS и Linux. Telegram также предлагает API для разработчиков и ботов, что делает его гибким инструментом для общения и автоматизации задач.	/uploads/program/32/d2f37f23-afba-40c3-9fd5-970b0a17a1a4_telegram.webp	\N	\N	\N	{/uploads/program/32/fe84cb49-5659-45ab-a81b-c5962489e235_260a84021f203c3bc1.jpg,/uploads/program/32/9c735cda-bc9c-48f7-9aa0-f2808fccc71a_a7c0863af9ecc4b3af.jpg,/uploads/program/32/1d6c1ed9-8b7a-4e17-a3b9-3ffe5daf5c93_home-screen.png,/uploads/program/32/6c814964-e996-4efc-b08d-9b7cfbedb853_img3File.png,/uploads/program/32/a3ae73d7-4690-4be8-bab9-c6a7bd4f64e4_preview.png,/uploads/program/32/10083446-7a06-4454-ba57-a14a3a6882aa_telegram-for-desktop-screenshot-01.png}
33	1	Unity	0.00	Unity — мощный движок для разработки 2D/3D игр и приложений. Подходит для indie-разработчиков и крупных студий. Кроссплатформенность, поддержка VR/AR, богатый набор инструментов и активное сообщество.	Unity — это универсальный игровой движок для создания 2D и 3D игр, а также интерактивных приложений. Он широко используется indie-разработчиками и крупными студиями благодаря своей гибкости, кроссплатформенности (поддержка PC, консолей, мобильных устройств, VR/AR) и богатому набору инструментов. Unity предлагает визуальный редактор, мощную физику, анимацию, систему частиц и поддержку скриптинга на C#. Встроенный Asset Store позволяет использовать готовые ресурсы и плагины. Движок также активно применяется в неигровых сферах, таких как архитектура, кино и образование. Unity имеет большое сообщество и регулярно обновляется, что делает его одним из самых популярных инструментов для разработки.	/uploads/program/33/eca8349e-53a1-4e56-95f5-843a2d81664b_Unity_Logo.png	\N	\N	\N	{/uploads/program/33/73b9661d-696d-4ad5-b41f-7d87100bb295_92cfbd2c7963f46fe81748e5e2d3c6715ef504ac.jpeg,/uploads/program/33/5d1ef98b-1386-4101-8ccd-9c890bf28dff_582ca9ee52b72830781322439c73d550146cfbee.jpeg,/uploads/program/33/c0f7120e-c205-4ebd-ab82-a630a28e910a_954c258da9ed801fcc144714c88ebc568666051a.jpeg,/uploads/program/33/0fa76d43-7e5b-43a7-9e2e-f4866b1b56ec_C4PK6.jpg,/uploads/program/33/0fdd3905-362a-4d2d-a0ff-333d41515e92_f6b7f7bc60326b3013c19c4608c41bca1358a7be.jpeg,/uploads/program/33/e3e7becb-5c6a-488f-a788-725cdb9ce12f_maxresdefault.jpg,/uploads/program/33/d82e981d-525e-4a34-995c-8a98c6e28301_PickandPlaceWorkflowInUnity3DUsingROSExample_25.png,/uploads/program/33/eaa588d6-0a14-43a2-9bcb-4afe9a96cfd5_screenshot-1.png}
34	1	Unreal Engine	1999.00	Unreal Engine — мощный движок для создания AAA-игр, VR/AR и визуализаций. Высококачественная графика, Blueprint для визуального скриптинга, кроссплатформенность и открытый исходный код.	Unreal Engine — это профессиональный игровой движок, разработанный Epic Games, для создания AAA-игр, виртуальной и дополненной реальности (VR/AR), а также визуализаций в кино и архитектуре. Движок славится своей продвинутой графикой, включая реалистичное освещение, физику и постобработку. Unreal Engine предлагает инструмент Blueprint для визуального скриптинга, что упрощает разработку без глубоких знаний программирования, а также поддерживает C++ для более сложных задач. Движок является кроссплатформенным (PC, консоли, мобильные устройства) и предоставляет доступ к исходному коду. Unreal Engine активно используется в индустрии благодаря своей гибкости, мощным инструментам и активному сообществу.	/uploads/program/34/47c8b5e3-2855-418c-b7b6-ac19bafc703b_Unreal_Engine-Logo.wine.png	\N	\N	\N	{/uploads/program/34/8ffb512f-bd00-45e8-9b2c-057aa659af3e_4c3ab52ef7de29f05d505dac4b71162d3e5146e7.jpeg,/uploads/program/34/afeec4f8-0896-4c8c-96fe-546c77d037ee_0823c67517a5cddd70f098cea475e40bef3f9d4b.jpg,/uploads/program/34/3185248f-a38f-4263-a6d9-a99c3e60d0a6_clinton-crumpler-step-07.jpg,/uploads/program/34/5348ac62-22de-4473-8675-19cdc9fa1326_fe7aadbffcbf4044a62a7f73d9e28a2c2259edfe.jpeg,/uploads/program/34/06127711-2708-4ef8-a93b-e291264aa7b6_ff0402159e26ebd9af2e8df28f13538e06fa4edd.jpeg,"/uploads/program/34/169d36da-be06-48bc-bc79-86bbc17db206_Learning to Create 360 Screenshots in Unreal Engine 3.png",/uploads/program/34/bb3697ec-f1eb-4c46-a2b6-e9c8e13d8615_maxresdefault.jpg,/uploads/program/34/1de6593f-7cab-466b-a1a8-a3594ae3b3f8_unreal-dev.webp,/uploads/program/34/83baec62-c4c1-4cad-8474-85b7939470ad_Unreal-Engine_1.jpg,/uploads/program/34/2620864f-6722-4863-b234-53279bbb6707_unreal-engine-screenshot-03.png}
24	1	PowerPoint	1499.00	Microsoft PowerPoint — программа для создания презентаций. Позволяет добавлять слайды с текстом, изображениями, графиками и анимацией. Используется для бизнеса, образования и публичных выступлений.	Microsoft PowerPoint — это мощное приложение для создания и проведения презентаций, входящее в пакет Microsoft Office. Оно позволяет пользователям создавать профессиональные слайд-шоу с использованием текста, изображений, графиков, диаграмм, видео и анимации.\r\nСоздание слайдов:\r\n· Шаблоны для быстрого старта.\r\n· Настройка макетов слайдов (заголовки, текст, изображения).\r\nМультимедиа:\r\n· Вставка изображений, аудио и видео.\r\n· Анимация текста и объектов.\r\nДизайн:\r\n· Темы и стили для оформления презентаций.\r\n· Настройка цветов, шрифтов и эффектов.\r\nГрафики и диаграммы:\r\n· Создание визуализаций данных (столбчатые, круговые, линейные диаграммы).\r\nКоллаборация:\r\n· Совместная работа в реальном времени через облако (OneDrive, SharePoint).\r\n· Комментирование и рецензирование.\r\nПрезентация:\r\n· Режим докладчика с заметками.\r\n· Экспорт в PDF или видеоформат.	/uploads/program/24/43c3a4bd-df92-4202-8225-ed8c14aa6edd_Microsoft_Office_PowerPoint_(2019–present).svg.png	\N	\N	\N	{/uploads/program/24/1f7e5ca4-9999-4676-b087-2f3803f6a12b_01EN.png,/uploads/program/24/6c1ae9da-85d4-4dde-bf42-4484851bc851_powerpoint-2023-powerpoint-load.png,/uploads/program/24/d4238c9d-5ee6-4114-86fd-1baa5357df9f_powerpoint-2023-powerpoint-load-2.png,/uploads/program/24/dbe92ae0-f202-44d1-bc56-feb7c4730dab_powerpoint-2023-powerpoint-load-3.png,/uploads/program/24/88a2b705-5ec7-4bbc-a9fb-695f152d1d39_powerpoint-2023-powerpoint-load-4.png,/uploads/program/24/df4464f5-b6ca-4ffc-ad61-26a02f2df5a7_powerpoint-designer.jpg}
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
23	2025-03-12 06:20:15.118681	1	17
24	2025-03-15 10:03:37.186187	3	27
25	2025-03-15 10:03:37.186187	3	29
26	2025-03-15 10:03:37.185186	3	26
27	2025-03-15 10:03:37.186187	3	24
28	2025-03-15 10:03:37.186187	3	28
29	2025-03-15 10:03:37.185186	3	25
30	2025-03-15 10:03:37.201187	3	34
31	2025-03-15 10:03:37.202186	3	32
32	2025-03-15 10:03:37.202186	3	31
33	2025-03-15 10:03:37.202186	3	33
34	2025-03-15 10:03:37.202186	3	30
35	2025-03-15 10:25:03.908005	3	17
36	2025-03-15 11:03:01.791294	2	33
37	2025-03-15 13:58:30.726029	2	25
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
3	1	17	5	2025-03-12 06:21:41.096619	Отличный редактор документов!
4	3	24	5	2025-03-15 10:04:28.370282	Отличная программа для презентаций!
5	3	17	4	2025-03-15 10:25:20.472183	Иногда случаются баги
6	3	25	5	2025-03-15 10:38:20.790126	Хороший редактор таблиц
7	3	26	4	2025-03-15 10:38:56.818675	Хороший аудиоредактор, но интерфейс немного неудобный
8	3	27	3	2025-03-15 10:40:13.40328	Неплохо для маленьких проектов, неудобное редактирование эффектов для видео, которое потребляет слишком много ресурсов ПК
9	3	28	5	2025-03-15 10:40:53.664216	Подходит как для новичков, так и для профессионалов
10	3	29	4	2025-03-15 10:41:20.888897	Неплохой браузер
11	3	30	5	2025-03-15 10:41:46.318574	Лучший редактор изображений
12	3	31	5	2025-03-15 10:42:20.957281	Подходит для написания битов как новичкам, так и профессионалам
13	3	32	5	2025-03-15 10:42:48.20217	Лучший мессенджер
15	3	34	4	2025-03-15 10:46:15.22672	Необходим высокий уровень навыков разработчика, чтобы игры были оптимизированными, иначе даже простейшие проекты требуют много ресурсов. Не рекомендую использовать Lumen, особенно программный, эта технология еще слишком сырая. Лучше использовать аппаратный Ray Tracing.
14	3	33	4	2025-03-15 10:43:45.627284	Этот движок хорош для инди-разработчиков и просто начинающих, в том числе благодаря скриптам на C#, но для больших проектов лучше найти другой движок
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (id, tag_name) FROM stdin;
16	Текстовый редактор
17	Табличный процессор
19	Видеоредактор
20	Аудиоредактор
21	Антивирус
22	Браузер
23	Мессенджер
24	СУБД
25	Среда разработки (IDE)
26	Редактор кода
27	Виртуальная машина
28	Мультимедиа-плеер
29	Запись экрана
30	Утилита
31	Бухгалтерия
32	Разработка ПО
33	Мониторинг состояния ПК
34	Файловый проводник
35	Читалка
36	Дизайн
37	3D-моделирование
38	Игровой движок
39	Графический редактор
40	Растровая графика
41	Векторная графика
42	Фоторедактор
43	Редактор презентаций
18	Офисное ПО
44	Научное ПО
45	Социальное
46	Развлекательное
47	Разработка игр
48	Интернет
49	Музыкальный секвенсор
50	Виртуальная реальность (VR)
51	Дополненная реальность (AR)
52	2D-графика
53	3D-графика
\.


--
-- Name: administrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_id_seq', 59, true);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_id_seq', 3, true);


--
-- Name: daily_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, true);


--
-- Name: degree_of_belonging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 104, true);


--
-- Name: developer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.developer_id_seq', 1, true);


--
-- Name: program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_id_seq', 34, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_id_seq', 37, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 15, true);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_seq', 53, true);


--
-- Name: administrator administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: daily_stats daily_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_pkey PRIMARY KEY (id);


--
-- Name: degree_of_belonging degree_of_belonging_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_pkey PRIMARY KEY (id);


--
-- Name: developer developer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);


--
-- Name: program program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- Name: tag tag_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);


--
-- Name: cart cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: daily_stats daily_stats_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: degree_of_belonging degree_of_belonging_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: degree_of_belonging degree_of_belonging_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: program program_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchase purchase_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchase purchase_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: review review_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: review review_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TABLE administrator; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.administrator TO customer_role;
GRANT SELECT ON TABLE public.administrator TO developer_role;
GRANT SELECT ON TABLE public.administrator TO unregistered_role;


--
-- Name: TABLE cart; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cart TO customer_role;


--
-- Name: TABLE customer; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer TO customer_role;
GRANT SELECT ON TABLE public.customer TO developer_role;
GRANT SELECT ON TABLE public.customer TO unregistered_role;


--
-- Name: SEQUENCE customer_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.customer_id_seq TO customer_role;


--
-- Name: TABLE daily_stats; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.daily_stats TO developer_role;


--
-- Name: TABLE degree_of_belonging; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.degree_of_belonging TO developer_role;


--
-- Name: TABLE developer; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.developer TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.developer TO developer_role;
GRANT SELECT ON TABLE public.developer TO unregistered_role;


--
-- Name: SEQUENCE developer_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.developer_id_seq TO developer_role;


--
-- Name: TABLE program; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.program TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.program TO developer_role;
GRANT SELECT ON TABLE public.program TO unregistered_role;


--
-- Name: TABLE purchase; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.purchase TO customer_role;


--
-- Name: TABLE review; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review TO customer_role;
GRANT SELECT ON TABLE public.review TO developer_role;
GRANT SELECT ON TABLE public.review TO unregistered_role;


--
-- PostgreSQL database dump complete
--

