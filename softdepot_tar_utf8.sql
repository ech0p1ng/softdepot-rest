toc.dat                                                                                             0000600 0004000 0002000 00000071650 14712342602 0014451 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                   
    |         	   softdepot    16.3    16.3 c    "           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         #           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         $           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         %           1262    17725 	   softdepot    DATABASE     }   CREATE DATABASE softdepot WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE softdepot;
                postgres    false         �            1259    17726    administrator    TABLE     �   CREATE TABLE public.administrator (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    administrator_name character varying(50) NOT NULL
);
 !   DROP TABLE public.administrator;
       public         heap    postgres    false         &           0    0    TABLE administrator    ACL     �   GRANT SELECT ON TABLE public.administrator TO customer_role;
GRANT SELECT ON TABLE public.administrator TO developer_role;
GRANT SELECT ON TABLE public.administrator TO unregistered_role;
          public          postgres    false    215         �            1259    17729    administrator_id_seq    SEQUENCE     �   CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.administrator_id_seq;
       public          postgres    false    215         '           0    0    administrator_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;
          public          postgres    false    216         �            1259    17730    cart    TABLE     y   CREATE TABLE public.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false         (           0    0 
   TABLE cart    ACL     I   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cart TO customer_role;
          public          postgres    false    217         �            1259    17733    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          postgres    false    217         )           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          postgres    false    218         �            1259    17734    customer    TABLE     S  CREATE TABLE public.customer (
    id integer NOT NULL,
    customer_name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    profile_img_url character varying(100),
    balance numeric(10,2),
    CONSTRAINT customer_balance_check CHECK ((balance >= (0)::numeric))
);
    DROP TABLE public.customer;
       public         heap    postgres    false         *           0    0    TABLE customer    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer TO customer_role;
GRANT SELECT ON TABLE public.customer TO developer_role;
GRANT SELECT ON TABLE public.customer TO unregistered_role;
          public          postgres    false    219         �            1259    17738    customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.customer_id_seq;
       public          postgres    false    219         +           0    0    customer_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;
          public          postgres    false    220         ,           0    0    SEQUENCE customer_id_seq    ACL     H   GRANT SELECT,USAGE ON SEQUENCE public.customer_id_seq TO customer_role;
          public          postgres    false    220         �            1259    17739    daily_stats    TABLE     
  CREATE TABLE public.daily_stats (
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
    DROP TABLE public.daily_stats;
       public         heap    postgres    false         -           0    0    TABLE daily_stats    ACL     <   GRANT SELECT ON TABLE public.daily_stats TO developer_role;
          public          postgres    false    221         �            1259    17744    daily_stats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.daily_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.daily_stats_id_seq;
       public          postgres    false    221         .           0    0    daily_stats_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.daily_stats_id_seq OWNED BY public.daily_stats.id;
          public          postgres    false    222         �            1259    17745    degree_of_belonging    TABLE       CREATE TABLE public.degree_of_belonging (
    id integer NOT NULL,
    program_id integer NOT NULL,
    tag_id integer NOT NULL,
    degree_value integer NOT NULL,
    CONSTRAINT degree_of_belonging_degree_value_check CHECK (((degree_value >= 0) AND (degree_value <= 10)))
);
 '   DROP TABLE public.degree_of_belonging;
       public         heap    postgres    false         /           0    0    TABLE degree_of_belonging    ACL     Y   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.degree_of_belonging TO developer_role;
          public          postgres    false    223         �            1259    17749    degree_of_belonging_id_seq    SEQUENCE     �   CREATE SEQUENCE public.degree_of_belonging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.degree_of_belonging_id_seq;
       public          postgres    false    223         0           0    0    degree_of_belonging_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.degree_of_belonging_id_seq OWNED BY public.degree_of_belonging.id;
          public          postgres    false    224         �            1259    17750 	   developer    TABLE     �   CREATE TABLE public.developer (
    id integer NOT NULL,
    email character varying(50) NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    profile_img_url character varying(100)
);
    DROP TABLE public.developer;
       public         heap    postgres    false         1           0    0    TABLE developer    ACL     �   GRANT SELECT ON TABLE public.developer TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.developer TO developer_role;
GRANT SELECT ON TABLE public.developer TO unregistered_role;
          public          postgres    false    225         �            1259    17753    developer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.developer_id_seq;
       public          postgres    false    225         2           0    0    developer_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;
          public          postgres    false    226         3           0    0    SEQUENCE developer_id_seq    ACL     J   GRANT SELECT,USAGE ON SEQUENCE public.developer_id_seq TO developer_role;
          public          postgres    false    226         �            1259    17754    program    TABLE     J  CREATE TABLE public.program (
    id integer NOT NULL,
    developer_id integer NOT NULL,
    program_name character varying(50) NOT NULL,
    price numeric(10,2),
    short_description character varying NOT NULL,
    description character varying NOT NULL,
    installer_windows_url character varying(100),
    installer_linux_url character varying(100),
    installer_macos_url character varying(100),
    screenshots_url character varying(100)[],
    header_url character varying,
    logo_url character varying,
    CONSTRAINT program_price_check CHECK ((price >= (0)::numeric))
);
    DROP TABLE public.program;
       public         heap    postgres    false         4           0    0    TABLE program    ACL     �   GRANT SELECT ON TABLE public.program TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.program TO developer_role;
GRANT SELECT ON TABLE public.program TO unregistered_role;
          public          postgres    false    227         �            1259    17760    program_id_seq    SEQUENCE     �   CREATE SEQUENCE public.program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.program_id_seq;
       public          postgres    false    227         5           0    0    program_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.program_id_seq OWNED BY public.program.id;
          public          postgres    false    228         �            1259    17761    purchase    TABLE     �   CREATE TABLE public.purchase (
    id integer NOT NULL,
    purchase_date_time timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.purchase;
       public         heap    postgres    false         6           0    0    TABLE purchase    ACL     M   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.purchase TO customer_role;
          public          postgres    false    229         �            1259    17764    purchase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.purchase_id_seq;
       public          postgres    false    229         7           0    0    purchase_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;
          public          postgres    false    230         �            1259    17765    review    TABLE     I  CREATE TABLE public.review (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL,
    estimation integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    review_text text NOT NULL,
    CONSTRAINT review_estimation_check CHECK (((estimation >= 0) AND (estimation <= 5)))
);
    DROP TABLE public.review;
       public         heap    postgres    false         8           0    0    TABLE review    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review TO customer_role;
GRANT SELECT ON TABLE public.review TO developer_role;
GRANT SELECT ON TABLE public.review TO unregistered_role;
          public          postgres    false    231         �            1259    17771    review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.review_id_seq;
       public          postgres    false    231         9           0    0    review_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;
          public          postgres    false    232         �            1259    17772    tag    TABLE     b   CREATE TABLE public.tag (
    id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);
    DROP TABLE public.tag;
       public         heap    postgres    false         �            1259    17775 
   tag_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.tag_id_seq;
       public          postgres    false    233         :           0    0 
   tag_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;
          public          postgres    false    234         G           2604    17776    administrator id    DEFAULT     t   ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);
 ?   ALTER TABLE public.administrator ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215         H           2604    17777    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217         I           2604    17778    customer id    DEFAULT     j   ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);
 :   ALTER TABLE public.customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219         J           2604    17779    daily_stats id    DEFAULT     p   ALTER TABLE ONLY public.daily_stats ALTER COLUMN id SET DEFAULT nextval('public.daily_stats_id_seq'::regclass);
 =   ALTER TABLE public.daily_stats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221         K           2604    17780    degree_of_belonging id    DEFAULT     �   ALTER TABLE ONLY public.degree_of_belonging ALTER COLUMN id SET DEFAULT nextval('public.degree_of_belonging_id_seq'::regclass);
 E   ALTER TABLE public.degree_of_belonging ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223         L           2604    17781    developer id    DEFAULT     l   ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);
 ;   ALTER TABLE public.developer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225         M           2604    17782 
   program id    DEFAULT     h   ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_id_seq'::regclass);
 9   ALTER TABLE public.program ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227         N           2604    17783    purchase id    DEFAULT     j   ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);
 :   ALTER TABLE public.purchase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    229         O           2604    17784 	   review id    DEFAULT     f   ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
 8   ALTER TABLE public.review ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231         P           2604    17785    tag id    DEFAULT     `   ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);
 5   ALTER TABLE public.tag ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                   0    17726    administrator 
   TABLE DATA           P   COPY public.administrator (id, email, password, administrator_name) FROM stdin;
    public          postgres    false    215       4876.dat           0    17730    cart 
   TABLE DATA           ;   COPY public.cart (id, customer_id, program_id) FROM stdin;
    public          postgres    false    217       4878.dat           0    17734    customer 
   TABLE DATA           `   COPY public.customer (id, customer_name, email, password, profile_img_url, balance) FROM stdin;
    public          postgres    false    219       4880.dat           0    17739    daily_stats 
   TABLE DATA           }   COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
    public          postgres    false    221       4882.dat           0    17745    degree_of_belonging 
   TABLE DATA           S   COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
    public          postgres    false    223       4884.dat           0    17750 	   developer 
   TABLE DATA           Y   COPY public.developer (id, email, developer_name, password, profile_img_url) FROM stdin;
    public          postgres    false    225       4886.dat           0    17754    program 
   TABLE DATA           �   COPY public.program (id, developer_id, program_name, price, short_description, description, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url, header_url, logo_url) FROM stdin;
    public          postgres    false    227       4888.dat           0    17761    purchase 
   TABLE DATA           S   COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
    public          postgres    false    229       4890.dat           0    17765    review 
   TABLE DATA           a   COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
    public          postgres    false    231       4892.dat           0    17772    tag 
   TABLE DATA           +   COPY public.tag (id, tag_name) FROM stdin;
    public          postgres    false    233       4894.dat ;           0    0    administrator_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.administrator_id_seq', 2, true);
          public          postgres    false    216         <           0    0    cart_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.cart_id_seq', 93, true);
          public          postgres    false    218         =           0    0    customer_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.customer_id_seq', 8, true);
          public          postgres    false    220         >           0    0    daily_stats_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, false);
          public          postgres    false    222         ?           0    0    degree_of_belonging_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 18, true);
          public          postgres    false    224         @           0    0    developer_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.developer_id_seq', 2, true);
          public          postgres    false    226         A           0    0    program_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.program_id_seq', 13, true);
          public          postgres    false    228         B           0    0    purchase_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.purchase_id_seq', 1, true);
          public          postgres    false    230         C           0    0    review_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.review_id_seq', 5, true);
          public          postgres    false    232         D           0    0 
   tag_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.tag_id_seq', 15, true);
          public          postgres    false    234         X           2606    17787 %   administrator administrator_email_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_email_key UNIQUE (email);
 O   ALTER TABLE ONLY public.administrator DROP CONSTRAINT administrator_email_key;
       public            postgres    false    215         Z           2606    17789     administrator administrator_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.administrator DROP CONSTRAINT administrator_pkey;
       public            postgres    false    215         \           2606    17791    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    217         ^           2606    17793    customer customer_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_email_key;
       public            postgres    false    219         `           2606    17795    customer customer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    219         b           2606    17797    daily_stats daily_stats_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_pkey;
       public            postgres    false    221         d           2606    17799 ,   degree_of_belonging degree_of_belonging_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_pkey;
       public            postgres    false    223         f           2606    17801    developer developer_email_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_email_key UNIQUE (email);
 G   ALTER TABLE ONLY public.developer DROP CONSTRAINT developer_email_key;
       public            postgres    false    225         h           2606    17803    developer developer_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.developer DROP CONSTRAINT developer_pkey;
       public            postgres    false    225         j           2606    17805    program program_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.program DROP CONSTRAINT program_pkey;
       public            postgres    false    227         l           2606    17807    purchase purchase_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_pkey;
       public            postgres    false    229         n           2606    17809    review review_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public            postgres    false    231         p           2606    17811    tag tag_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public            postgres    false    233         r           2606    17813    tag tag_tag_name_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tag_name_key;
       public            postgres    false    233         s           2606    17814    cart cart_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_customer_id_fkey;
       public          postgres    false    217    219    4704         t           2606    17819    cart cart_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_program_id_fkey;
       public          postgres    false    227    4714    217         u           2606    17824 '   daily_stats daily_stats_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_program_id_fkey;
       public          postgres    false    221    227    4714         v           2606    17829 7   degree_of_belonging degree_of_belonging_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_program_id_fkey;
       public          postgres    false    227    223    4714         w           2606    17834 3   degree_of_belonging degree_of_belonging_tag_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_tag_id_fkey;
       public          postgres    false    233    223    4720         x           2606    17839 !   program program_developer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id);
 K   ALTER TABLE ONLY public.program DROP CONSTRAINT program_developer_id_fkey;
       public          postgres    false    225    227    4712         y           2606    17844 "   purchase purchase_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_customer_id_fkey;
       public          postgres    false    4704    229    219         z           2606    17849 !   purchase purchase_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);
 K   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_program_id_fkey;
       public          postgres    false    4714    227    229         {           2606    17854    review review_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.review DROP CONSTRAINT review_customer_id_fkey;
       public          postgres    false    219    231    4704         |           2606    17859    review review_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.review DROP CONSTRAINT review_program_id_fkey;
       public          postgres    false    4714    231    227                                                                                                4876.dat                                                                                            0000600 0004000 0002000 00000000132 14712342602 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	alexey2003petrov@yandex.ru	adminadmin	alexey2003petrov
2	admin@mail.ru	admin	admin
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                      4878.dat                                                                                            0000600 0004000 0002000 00000000022 14712342602 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	3	1
83	2	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              4880.dat                                                                                            0000600 0004000 0002000 00000000444 14712342602 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        6	customer1	customer1@mail.ru	Customer1	\N	0.00
4	customer	customer@mail.ru	customer1	\N	1650.00
2	new_user	user@user.user	useruser1	\N	1700.00
3	new_user_1	user1@user.user	useruser1	\N	500.00
1	ech0p1ng	alex5.56@yandex.ru	customer1	\N	22600.00
7	kokoko	kokoko@mail.ru	Kokoko222	\N	0.00
\.


                                                                                                                                                                                                                            4882.dat                                                                                            0000600 0004000 0002000 00000000005 14712342602 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4884.dat                                                                                            0000600 0004000 0002000 00000000056 14712342602 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	2	2
2	1	1	3
3	2	3	8
4	2	4	9
5	1	10	8
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  4886.dat                                                                                            0000600 0004000 0002000 00000000157 14712342602 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	lesha2003petrov@gmail.com	SoftDepotDEV	developerdeveloper	\N
2	developer@mail.ru	developer	developer	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                 4888.dat                                                                                            0000600 0004000 0002000 00000003504 14712342602 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	1	Insurgency	360.00	В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.	В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.	\N	\N	\N	\N	program/content/2/header.jpg	\N
1	1	BeamNG.drive	880.00	Основанный на физике мягких объектов автомобильный симулятор, способный практически на всё.	BeamNG.drive - невероятно реалистичный автосимулятор с практически безграничными возможностями. В основе игры лежит система физики мягких объектов, способная правдоподобно моделировать компоненты автомобиля в реальном времени. Благодаря годам кропотливой разработки, исследований и испытаний, BeamNG.drive способен передать весь восторг вождения в реальном мире.	\N	\N	\N	\N	program/content/1/header.jpg	\N
\.


                                                                                                                                                                                            4890.dat                                                                                            0000600 0004000 0002000 00000000164 14712342602 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2024-05-19 19:45:31.749772	1	1
2	2024-05-30 23:26:50	2	2
3	2024-05-27 20:25:30	3	2
4	2024-05-28 19:21:11	4	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                            4892.dat                                                                                            0000600 0004000 0002000 00000000233 14712342602 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	1	5	2024-05-19 19:47:15.489259	Test review for program with id=1
4	2	2	5	2024-05-30 19:59:23	Awesome game!
5	3	2	4	2024-05-30 20:41:17	Good game!
\.


                                                                                                                                                                                                                                                                                                                                                                     4894.dat                                                                                            0000600 0004000 0002000 00000000374 14712342602 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Гонки
2	От третьего лица
3	Шутер
4	От первого лица
8	Головоломка
9	Хоррор
10	Симулятор
13	Для нескольких игроков
14	Аркада
15	Для детей
12	Экшн
\.


                                                                                                                                                                                                                                                                    restore.sql                                                                                         0000600 0004000 0002000 00000056074 14712342602 0015401 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
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

DROP DATABASE softdepot;
--
-- Name: softdepot; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE softdepot WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE softdepot OWNER TO postgres;

\connect softdepot

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
    email character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
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
    email character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    profile_img_url character varying(100),
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
    email character varying(50) NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    profile_img_url character varying(100)
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
    installer_windows_url character varying(100),
    installer_linux_url character varying(100),
    installer_macos_url character varying(100),
    screenshots_url character varying(100)[],
    header_url character varying,
    logo_url character varying,
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

COPY public.administrator (id, email, password, administrator_name) FROM stdin;
\.
COPY public.administrator (id, email, password, administrator_name) FROM '$$PATH$$/4876.dat';

--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, customer_id, program_id) FROM stdin;
\.
COPY public.cart (id, customer_id, program_id) FROM '$$PATH$$/4878.dat';

--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, customer_name, email, password, profile_img_url, balance) FROM stdin;
\.
COPY public.customer (id, customer_name, email, password, profile_img_url, balance) FROM '$$PATH$$/4880.dat';

--
-- Data for Name: daily_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
\.
COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM '$$PATH$$/4882.dat';

--
-- Data for Name: degree_of_belonging; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
\.
COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM '$$PATH$$/4884.dat';

--
-- Data for Name: developer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.developer (id, email, developer_name, password, profile_img_url) FROM stdin;
\.
COPY public.developer (id, email, developer_name, password, profile_img_url) FROM '$$PATH$$/4886.dat';

--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (id, developer_id, program_name, price, short_description, description, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url, header_url, logo_url) FROM stdin;
\.
COPY public.program (id, developer_id, program_name, price, short_description, description, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url, header_url, logo_url) FROM '$$PATH$$/4888.dat';

--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
\.
COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM '$$PATH$$/4890.dat';

--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
\.
COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM '$$PATH$$/4892.dat';

--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (id, tag_name) FROM stdin;
\.
COPY public.tag (id, tag_name) FROM '$$PATH$$/4894.dat';

--
-- Name: administrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.administrator_id_seq', 2, true);


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_id_seq', 93, true);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_id_seq', 8, true);


--
-- Name: daily_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, false);


--
-- Name: degree_of_belonging_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 18, true);


--
-- Name: developer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.developer_id_seq', 2, true);


--
-- Name: program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_id_seq', 13, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_id_seq', 1, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 5, true);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_seq', 15, true);


--
-- Name: administrator administrator_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_email_key UNIQUE (email);


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
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


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
-- Name: developer developer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_email_key UNIQUE (email);


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
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- Name: cart cart_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: daily_stats daily_stats_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: degree_of_belonging degree_of_belonging_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: degree_of_belonging degree_of_belonging_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON DELETE CASCADE;


--
-- Name: program program_developer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id);


--
-- Name: purchase purchase_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- Name: purchase purchase_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- Name: review review_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- Name: review review_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON DELETE CASCADE;


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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    