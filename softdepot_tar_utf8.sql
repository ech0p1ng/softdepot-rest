toc.dat                                                                                             0000600 0004000 0002000 00000067774 14761372516 0014500 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   &                    }         	   softdepot    16.3    16.3 `               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                    0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                    0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                    1262    44005 	   softdepot    DATABASE     }   CREATE DATABASE softdepot WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE softdepot;
                postgres    false         �            1259    44006    administrator    TABLE     �   CREATE TABLE public.administrator (
    id integer NOT NULL,
    password character varying(60) NOT NULL,
    administrator_name character varying(50) NOT NULL
);
 !   DROP TABLE public.administrator;
       public         heap    postgres    false                     0    0    TABLE administrator    ACL     �   GRANT SELECT ON TABLE public.administrator TO customer_role;
GRANT SELECT ON TABLE public.administrator TO developer_role;
GRANT SELECT ON TABLE public.administrator TO unregistered_role;
          public          postgres    false    215         �            1259    44009    administrator_id_seq    SEQUENCE     �   CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.administrator_id_seq;
       public          postgres    false    215         !           0    0    administrator_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;
          public          postgres    false    216         �            1259    44010    cart    TABLE     y   CREATE TABLE public.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false         "           0    0 
   TABLE cart    ACL     I   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cart TO customer_role;
          public          postgres    false    217         �            1259    44013    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          postgres    false    217         #           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          postgres    false    218         �            1259    44014    customer    TABLE     )  CREATE TABLE public.customer (
    id integer NOT NULL,
    customer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200),
    balance numeric(10,2),
    CONSTRAINT customer_balance_check CHECK ((balance >= (0)::numeric))
);
    DROP TABLE public.customer;
       public         heap    postgres    false         $           0    0    TABLE customer    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer TO customer_role;
GRANT SELECT ON TABLE public.customer TO developer_role;
GRANT SELECT ON TABLE public.customer TO unregistered_role;
          public          postgres    false    219         �            1259    44018    customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.customer_id_seq;
       public          postgres    false    219         %           0    0    customer_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;
          public          postgres    false    220         &           0    0    SEQUENCE customer_id_seq    ACL     H   GRANT SELECT,USAGE ON SEQUENCE public.customer_id_seq TO customer_role;
          public          postgres    false    220         �            1259    44019    daily_stats    TABLE     
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
       public         heap    postgres    false         '           0    0    TABLE daily_stats    ACL     <   GRANT SELECT ON TABLE public.daily_stats TO developer_role;
          public          postgres    false    221         �            1259    44024    daily_stats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.daily_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.daily_stats_id_seq;
       public          postgres    false    221         (           0    0    daily_stats_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.daily_stats_id_seq OWNED BY public.daily_stats.id;
          public          postgres    false    222         �            1259    44025    degree_of_belonging    TABLE       CREATE TABLE public.degree_of_belonging (
    id integer NOT NULL,
    program_id integer NOT NULL,
    tag_id integer NOT NULL,
    degree_value integer NOT NULL,
    CONSTRAINT degree_of_belonging_degree_value_check CHECK (((degree_value >= 0) AND (degree_value <= 10)))
);
 '   DROP TABLE public.degree_of_belonging;
       public         heap    postgres    false         )           0    0    TABLE degree_of_belonging    ACL     Y   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.degree_of_belonging TO developer_role;
          public          postgres    false    223         �            1259    44029    degree_of_belonging_id_seq    SEQUENCE     �   CREATE SEQUENCE public.degree_of_belonging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.degree_of_belonging_id_seq;
       public          postgres    false    223         *           0    0    degree_of_belonging_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.degree_of_belonging_id_seq OWNED BY public.degree_of_belonging.id;
          public          postgres    false    224         �            1259    44030 	   developer    TABLE     �   CREATE TABLE public.developer (
    id integer NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200)
);
    DROP TABLE public.developer;
       public         heap    postgres    false         +           0    0    TABLE developer    ACL     �   GRANT SELECT ON TABLE public.developer TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.developer TO developer_role;
GRANT SELECT ON TABLE public.developer TO unregistered_role;
          public          postgres    false    225         �            1259    44033    developer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.developer_id_seq;
       public          postgres    false    225         ,           0    0    developer_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;
          public          postgres    false    226         -           0    0    SEQUENCE developer_id_seq    ACL     J   GRANT SELECT,USAGE ON SEQUENCE public.developer_id_seq TO developer_role;
          public          postgres    false    226         �            1259    44034    program    TABLE     -  CREATE TABLE public.program (
    id integer NOT NULL,
    developer_id integer NOT NULL,
    program_name character varying(50) NOT NULL,
    price numeric(10,2),
    short_description character varying NOT NULL,
    description character varying NOT NULL,
    logo_url character varying(100),
    installer_windows_url character varying(100),
    installer_linux_url character varying(100),
    installer_macos_url character varying(100),
    screenshots_url character varying(100)[],
    CONSTRAINT program_price_check CHECK ((price >= (0)::numeric))
);
    DROP TABLE public.program;
       public         heap    postgres    false         .           0    0    TABLE program    ACL     �   GRANT SELECT ON TABLE public.program TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.program TO developer_role;
GRANT SELECT ON TABLE public.program TO unregistered_role;
          public          postgres    false    227         �            1259    44040    program_id_seq    SEQUENCE     �   CREATE SEQUENCE public.program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.program_id_seq;
       public          postgres    false    227         /           0    0    program_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.program_id_seq OWNED BY public.program.id;
          public          postgres    false    228         �            1259    44041    purchase    TABLE     �   CREATE TABLE public.purchase (
    id integer NOT NULL,
    purchase_date_time timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.purchase;
       public         heap    postgres    false         0           0    0    TABLE purchase    ACL     M   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.purchase TO customer_role;
          public          postgres    false    229         �            1259    44044    purchase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.purchase_id_seq;
       public          postgres    false    229         1           0    0    purchase_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;
          public          postgres    false    230         �            1259    44045    review    TABLE     I  CREATE TABLE public.review (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL,
    estimation integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    review_text text NOT NULL,
    CONSTRAINT review_estimation_check CHECK (((estimation >= 0) AND (estimation <= 5)))
);
    DROP TABLE public.review;
       public         heap    postgres    false         2           0    0    TABLE review    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review TO customer_role;
GRANT SELECT ON TABLE public.review TO developer_role;
GRANT SELECT ON TABLE public.review TO unregistered_role;
          public          postgres    false    231         �            1259    44051    review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.review_id_seq;
       public          postgres    false    231         3           0    0    review_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;
          public          postgres    false    232         �            1259    44052    tag    TABLE     b   CREATE TABLE public.tag (
    id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);
    DROP TABLE public.tag;
       public         heap    postgres    false         �            1259    44055 
   tag_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.tag_id_seq;
       public          postgres    false    233         4           0    0 
   tag_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;
          public          postgres    false    234         G           2604    44056    administrator id    DEFAULT     t   ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);
 ?   ALTER TABLE public.administrator ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215         H           2604    44057    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217         I           2604    44058    customer id    DEFAULT     j   ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);
 :   ALTER TABLE public.customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219         J           2604    44059    daily_stats id    DEFAULT     p   ALTER TABLE ONLY public.daily_stats ALTER COLUMN id SET DEFAULT nextval('public.daily_stats_id_seq'::regclass);
 =   ALTER TABLE public.daily_stats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221         K           2604    44060    degree_of_belonging id    DEFAULT     �   ALTER TABLE ONLY public.degree_of_belonging ALTER COLUMN id SET DEFAULT nextval('public.degree_of_belonging_id_seq'::regclass);
 E   ALTER TABLE public.degree_of_belonging ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223         L           2604    44061    developer id    DEFAULT     l   ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);
 ;   ALTER TABLE public.developer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225         M           2604    44062 
   program id    DEFAULT     h   ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_id_seq'::regclass);
 9   ALTER TABLE public.program ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227         N           2604    44063    purchase id    DEFAULT     j   ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);
 :   ALTER TABLE public.purchase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    229         O           2604    44064 	   review id    DEFAULT     f   ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
 8   ALTER TABLE public.review ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231         P           2604    44065    tag id    DEFAULT     `   ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);
 5   ALTER TABLE public.tag ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                   0    44006    administrator 
   TABLE DATA           I   COPY public.administrator (id, password, administrator_name) FROM stdin;
    public          postgres    false    215       4870.dat           0    44010    cart 
   TABLE DATA           ;   COPY public.cart (id, customer_id, program_id) FROM stdin;
    public          postgres    false    217       4872.dat 
          0    44014    customer 
   TABLE DATA           Y   COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM stdin;
    public          postgres    false    219       4874.dat           0    44019    daily_stats 
   TABLE DATA           }   COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
    public          postgres    false    221       4876.dat           0    44025    degree_of_belonging 
   TABLE DATA           S   COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
    public          postgres    false    223       4878.dat           0    44030 	   developer 
   TABLE DATA           R   COPY public.developer (id, developer_name, password, profile_img_url) FROM stdin;
    public          postgres    false    225       4880.dat           0    44034    program 
   TABLE DATA           �   COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM stdin;
    public          postgres    false    227       4882.dat           0    44041    purchase 
   TABLE DATA           S   COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
    public          postgres    false    229       4884.dat           0    44045    review 
   TABLE DATA           a   COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
    public          postgres    false    231       4886.dat           0    44052    tag 
   TABLE DATA           +   COPY public.tag (id, tag_name) FROM stdin;
    public          postgres    false    233       4888.dat 5           0    0    administrator_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);
          public          postgres    false    216         6           0    0    cart_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.cart_id_seq', 44, true);
          public          postgres    false    218         7           0    0    customer_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.customer_id_seq', 3, true);
          public          postgres    false    220         8           0    0    daily_stats_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, true);
          public          postgres    false    222         9           0    0    degree_of_belonging_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 33, true);
          public          postgres    false    224         :           0    0    developer_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.developer_id_seq', 1, true);
          public          postgres    false    226         ;           0    0    program_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.program_id_seq', 16, true);
          public          postgres    false    228         <           0    0    purchase_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.purchase_id_seq', 22, true);
          public          postgres    false    230         =           0    0    review_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.review_id_seq', 2, true);
          public          postgres    false    232         >           0    0 
   tag_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.tag_id_seq', 15, true);
          public          postgres    false    234         X           2606    44069     administrator administrator_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.administrator DROP CONSTRAINT administrator_pkey;
       public            postgres    false    215         Z           2606    44071    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    217         \           2606    44075    customer customer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    219         ^           2606    44077    daily_stats daily_stats_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_pkey;
       public            postgres    false    221         `           2606    44079 ,   degree_of_belonging degree_of_belonging_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_pkey;
       public            postgres    false    223         b           2606    44083    developer developer_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.developer DROP CONSTRAINT developer_pkey;
       public            postgres    false    225         d           2606    44085    program program_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.program DROP CONSTRAINT program_pkey;
       public            postgres    false    227         f           2606    44087    purchase purchase_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_pkey;
       public            postgres    false    229         h           2606    44089    review review_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public            postgres    false    231         j           2606    44091    tag tag_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public            postgres    false    233         l           2606    44093    tag tag_tag_name_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tag_name_key;
       public            postgres    false    233         m           2606    44094    cart cart_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_customer_id_fkey;
       public          postgres    false    217    4700    219         n           2606    44099    cart cart_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_program_id_fkey;
       public          postgres    false    4708    227    217         o           2606    44104 '   daily_stats daily_stats_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_program_id_fkey;
       public          postgres    false    4708    227    221         p           2606    44109 7   degree_of_belonging degree_of_belonging_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_program_id_fkey;
       public          postgres    false    223    4708    227         q           2606    44114 3   degree_of_belonging degree_of_belonging_tag_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_tag_id_fkey;
       public          postgres    false    223    233    4714         r           2606    44119 !   program program_developer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.program DROP CONSTRAINT program_developer_id_fkey;
       public          postgres    false    4706    227    225         s           2606    44124 "   purchase purchase_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_customer_id_fkey;
       public          postgres    false    229    219    4700         t           2606    44149 !   purchase purchase_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_program_id_fkey;
       public          postgres    false    227    4708    229         u           2606    44134    review review_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.review DROP CONSTRAINT review_customer_id_fkey;
       public          postgres    false    231    4700    219         v           2606    44139    review review_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.review DROP CONSTRAINT review_program_id_fkey;
       public          postgres    false    231    227    4708            4870.dat                                                                                            0000600 0004000 0002000 00000000122 14761372516 0014263 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	$2a$10$t5/BODlYh6END/jpntup8ual66AkaDdRG3ZfL4CY7UJcV27cHnd6q	administrator
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                              4872.dat                                                                                            0000600 0004000 0002000 00000000005 14761372516 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4874.dat                                                                                            0000600 0004000 0002000 00000000370 14761372516 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	customer1	$2a$10$YMs3QL44GMSvyQX6F5ZE8ek2PH0dLKLb2nQUSxB8YPNf38MaNIoau	\N	0.00
2	customer2	$2a$10$qGhYdZ27VcRagzSXH.36y.wYNnzea7azEJj5auBTJngyH2bOBJW2K	\N	0.00
3	customer3	$2a$10$0TXfQ2XBFLXKhw2Mqt0b4ekS/0KU74svpwnCtahL/tJAYtXeAbulC	\N	0.00
\.


                                                                                                                                                                                                                                                                        4876.dat                                                                                            0000600 0004000 0002000 00000000005 14761372516 0014271 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4878.dat                                                                                            0000600 0004000 0002000 00000000056 14761372516 0014301 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	2	2
2	1	1	3
3	2	3	8
4	2	4	9
5	1	10	8
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  4880.dat                                                                                            0000600 0004000 0002000 00000000124 14761372516 0014266 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	SoftDepotDEV	$2a$10$VMRYIXl18B/xp75ZlzikQ.b4dcnJ6JiRFa6fr5tsLlwATvr47db22	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                            4882.dat                                                                                            0000600 0004000 0002000 00000004552 14761372516 0014301 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	1	Insurgency	360.00	В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.	В этой многопользовательской и кооперавтивной игре Вы сражаетесь в кровавых боях на улицах, лицом к лицу с врагом, где выживание Вашей команды зависит от контроля важных точек и уничтожения вражеских боеприпасов, все оперирующее на движке Source.	/uploads/program/2/logo.png	\N	\N	\N	{/uploads/program/2/sh01.jpg,/uploads/program/2/sh02.jpg,/uploads/program/2/sh03.jpg,/uploads/program/2/sh04.jpg,/uploads/program/2/sh05.jpg,/uploads/program/2/sh06.jpg,/uploads/program/2/sh07.jpg,/uploads/program/2/sh08.jpg,/uploads/program/2/sh09.jpg,/uploads/program/2/sh10.jpg}
1	1	BeamNG.drive	880.00	Основанный на физике мягких объектов автомобильный симулятор, способный практически на всё.	BeamNG.drive - невероятно реалистичный автосимулятор с практически безграничными возможностями. В основе игры лежит система физики мягких объектов, способная правдоподобно моделировать компоненты автомобиля в реальном времени. Благодаря годам кропотливой разработки, исследований и испытаний, BeamNG.drive способен передать весь восторг вождения в реальном мире.	/uploads/program/1/logo.png	\N	\N	\N	{/uploads/program/1/sh01.jpg,/uploads/program/1/sh02.jpg,/uploads/program/1/sh03.jpg,/uploads/program/1/sh04.jpg,/uploads/program/1/sh05.jpg,/uploads/program/1/sh06.jpg,/uploads/program/1/sh07.jpg,/uploads/program/1/sh08.jpg,/uploads/program/1/sh09.jpg,/uploads/program/1/sh10.jpg}
\.


                                                                                                                                                      4884.dat                                                                                            0000600 0004000 0002000 00000000071 14761372516 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	2024-11-05 13:00:07	1	1
4	2024-11-05 13:00:07	2	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                       4886.dat                                                                                            0000600 0004000 0002000 00000000312 14761372516 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	1	5	2024-11-08 10:10:16	Отличная физика мягких тел, лучшая физика управления автомобилями!
2	2	1	4	2024-11-08 10:10:16	Не ну мед
\.


                                                                                                                                                                                                                                                                                                                      4888.dat                                                                                            0000600 0004000 0002000 00000000374 14761372516 0014305 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Гонки
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


                                                                                                                                                                                                                                                                    restore.sql                                                                                         0000600 0004000 0002000 00000055001 14761372516 0015401 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
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
    logo_url character varying(100),
    installer_windows_url character varying(100),
    installer_linux_url character varying(100),
    installer_macos_url character varying(100),
    screenshots_url character varying(100)[],
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
\.
COPY public.administrator (id, password, administrator_name) FROM '$$PATH$$/4870.dat';

--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, customer_id, program_id) FROM stdin;
\.
COPY public.cart (id, customer_id, program_id) FROM '$$PATH$$/4872.dat';

--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM stdin;
\.
COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM '$$PATH$$/4874.dat';

--
-- Data for Name: daily_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
\.
COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM '$$PATH$$/4876.dat';

--
-- Data for Name: degree_of_belonging; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
\.
COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM '$$PATH$$/4878.dat';

--
-- Data for Name: developer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.developer (id, developer_name, password, profile_img_url) FROM stdin;
\.
COPY public.developer (id, developer_name, password, profile_img_url) FROM '$$PATH$$/4880.dat';

--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM stdin;
\.
COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM '$$PATH$$/4882.dat';

--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
\.
COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM '$$PATH$$/4884.dat';

--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
\.
COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM '$$PATH$$/4886.dat';

--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (id, tag_name) FROM stdin;
\.
COPY public.tag (id, tag_name) FROM '$$PATH$$/4888.dat';

--
-- Name: administrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);


--
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_id_seq', 44, true);


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

SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 33, true);


--
-- Name: developer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.developer_id_seq', 1, true);


--
-- Name: program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_id_seq', 16, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_id_seq', 22, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 2, true);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_seq', 15, true);


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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               