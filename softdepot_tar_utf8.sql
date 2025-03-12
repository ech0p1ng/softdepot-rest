toc.dat                                                                                             0000600 0004000 0002000 00000067730 14764320744 0014467 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   8                    }         	   softdepot    16.3    16.3 `               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                    0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                    0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                    1262    44154 	   softdepot    DATABASE     }   CREATE DATABASE softdepot WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE softdepot;
                postgres    false         �            1259    44155    administrator    TABLE     �   CREATE TABLE public.administrator (
    id integer NOT NULL,
    password character varying(60) NOT NULL,
    administrator_name character varying(50) NOT NULL
);
 !   DROP TABLE public.administrator;
       public         heap    postgres    false                     0    0    TABLE administrator    ACL     �   GRANT SELECT ON TABLE public.administrator TO customer_role;
GRANT SELECT ON TABLE public.administrator TO developer_role;
GRANT SELECT ON TABLE public.administrator TO unregistered_role;
          public          postgres    false    215         �            1259    44158    administrator_id_seq    SEQUENCE     �   CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.administrator_id_seq;
       public          postgres    false    215         !           0    0    administrator_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;
          public          postgres    false    216         �            1259    44159    cart    TABLE     y   CREATE TABLE public.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false         "           0    0 
   TABLE cart    ACL     I   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cart TO customer_role;
          public          postgres    false    217         �            1259    44162    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          postgres    false    217         #           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          postgres    false    218         �            1259    44163    customer    TABLE     )  CREATE TABLE public.customer (
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
          public          postgres    false    219         �            1259    44167    customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.customer_id_seq;
       public          postgres    false    219         %           0    0    customer_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;
          public          postgres    false    220         &           0    0    SEQUENCE customer_id_seq    ACL     H   GRANT SELECT,USAGE ON SEQUENCE public.customer_id_seq TO customer_role;
          public          postgres    false    220         �            1259    44168    daily_stats    TABLE     
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
          public          postgres    false    221         �            1259    44173    daily_stats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.daily_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.daily_stats_id_seq;
       public          postgres    false    221         (           0    0    daily_stats_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.daily_stats_id_seq OWNED BY public.daily_stats.id;
          public          postgres    false    222         �            1259    44174    degree_of_belonging    TABLE       CREATE TABLE public.degree_of_belonging (
    id integer NOT NULL,
    program_id integer NOT NULL,
    tag_id integer NOT NULL,
    degree_value integer NOT NULL,
    CONSTRAINT degree_of_belonging_degree_value_check CHECK (((degree_value >= 0) AND (degree_value <= 10)))
);
 '   DROP TABLE public.degree_of_belonging;
       public         heap    postgres    false         )           0    0    TABLE degree_of_belonging    ACL     Y   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.degree_of_belonging TO developer_role;
          public          postgres    false    223         �            1259    44178    degree_of_belonging_id_seq    SEQUENCE     �   CREATE SEQUENCE public.degree_of_belonging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.degree_of_belonging_id_seq;
       public          postgres    false    223         *           0    0    degree_of_belonging_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.degree_of_belonging_id_seq OWNED BY public.degree_of_belonging.id;
          public          postgres    false    224         �            1259    44179 	   developer    TABLE     �   CREATE TABLE public.developer (
    id integer NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200)
);
    DROP TABLE public.developer;
       public         heap    postgres    false         +           0    0    TABLE developer    ACL     �   GRANT SELECT ON TABLE public.developer TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.developer TO developer_role;
GRANT SELECT ON TABLE public.developer TO unregistered_role;
          public          postgres    false    225         �            1259    44182    developer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.developer_id_seq;
       public          postgres    false    225         ,           0    0    developer_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;
          public          postgres    false    226         -           0    0    SEQUENCE developer_id_seq    ACL     J   GRANT SELECT,USAGE ON SEQUENCE public.developer_id_seq TO developer_role;
          public          postgres    false    226         �            1259    44183    program    TABLE     	  CREATE TABLE public.program (
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
    DROP TABLE public.program;
       public         heap    postgres    false         .           0    0    TABLE program    ACL     �   GRANT SELECT ON TABLE public.program TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.program TO developer_role;
GRANT SELECT ON TABLE public.program TO unregistered_role;
          public          postgres    false    227         �            1259    44189    program_id_seq    SEQUENCE     �   CREATE SEQUENCE public.program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.program_id_seq;
       public          postgres    false    227         /           0    0    program_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.program_id_seq OWNED BY public.program.id;
          public          postgres    false    228         �            1259    44190    purchase    TABLE     �   CREATE TABLE public.purchase (
    id integer NOT NULL,
    purchase_date_time timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.purchase;
       public         heap    postgres    false         0           0    0    TABLE purchase    ACL     M   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.purchase TO customer_role;
          public          postgres    false    229         �            1259    44193    purchase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.purchase_id_seq;
       public          postgres    false    229         1           0    0    purchase_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;
          public          postgres    false    230         �            1259    44194    review    TABLE     I  CREATE TABLE public.review (
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
          public          postgres    false    231         �            1259    44200    review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.review_id_seq;
       public          postgres    false    231         3           0    0    review_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;
          public          postgres    false    232         �            1259    44201    tag    TABLE     b   CREATE TABLE public.tag (
    id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);
    DROP TABLE public.tag;
       public         heap    postgres    false         �            1259    44204 
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
          public          postgres    false    234         G           2604    44205    administrator id    DEFAULT     t   ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);
 ?   ALTER TABLE public.administrator ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215         H           2604    44206    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217         I           2604    44207    customer id    DEFAULT     j   ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);
 :   ALTER TABLE public.customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219         J           2604    44208    daily_stats id    DEFAULT     p   ALTER TABLE ONLY public.daily_stats ALTER COLUMN id SET DEFAULT nextval('public.daily_stats_id_seq'::regclass);
 =   ALTER TABLE public.daily_stats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221         K           2604    44209    degree_of_belonging id    DEFAULT     �   ALTER TABLE ONLY public.degree_of_belonging ALTER COLUMN id SET DEFAULT nextval('public.degree_of_belonging_id_seq'::regclass);
 E   ALTER TABLE public.degree_of_belonging ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223         L           2604    44210    developer id    DEFAULT     l   ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);
 ;   ALTER TABLE public.developer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225         M           2604    44211 
   program id    DEFAULT     h   ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_id_seq'::regclass);
 9   ALTER TABLE public.program ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227         N           2604    44212    purchase id    DEFAULT     j   ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);
 :   ALTER TABLE public.purchase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    229         O           2604    44213 	   review id    DEFAULT     f   ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
 8   ALTER TABLE public.review ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231         P           2604    44214    tag id    DEFAULT     `   ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);
 5   ALTER TABLE public.tag ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                   0    44155    administrator 
   TABLE DATA           I   COPY public.administrator (id, password, administrator_name) FROM stdin;
    public          postgres    false    215       4870.dat           0    44159    cart 
   TABLE DATA           ;   COPY public.cart (id, customer_id, program_id) FROM stdin;
    public          postgres    false    217       4872.dat 
          0    44163    customer 
   TABLE DATA           Y   COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM stdin;
    public          postgres    false    219       4874.dat           0    44168    daily_stats 
   TABLE DATA           }   COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
    public          postgres    false    221       4876.dat           0    44174    degree_of_belonging 
   TABLE DATA           S   COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
    public          postgres    false    223       4878.dat           0    44179 	   developer 
   TABLE DATA           R   COPY public.developer (id, developer_name, password, profile_img_url) FROM stdin;
    public          postgres    false    225       4880.dat           0    44183    program 
   TABLE DATA           �   COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM stdin;
    public          postgres    false    227       4882.dat           0    44190    purchase 
   TABLE DATA           S   COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
    public          postgres    false    229       4884.dat           0    44194    review 
   TABLE DATA           a   COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
    public          postgres    false    231       4886.dat           0    44201    tag 
   TABLE DATA           +   COPY public.tag (id, tag_name) FROM stdin;
    public          postgres    false    233       4888.dat 5           0    0    administrator_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);
          public          postgres    false    216         6           0    0    cart_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.cart_id_seq', 45, true);
          public          postgres    false    218         7           0    0    customer_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.customer_id_seq', 3, true);
          public          postgres    false    220         8           0    0    daily_stats_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, true);
          public          postgres    false    222         9           0    0    degree_of_belonging_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 79, true);
          public          postgres    false    224         :           0    0    developer_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.developer_id_seq', 1, true);
          public          postgres    false    226         ;           0    0    program_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.program_id_seq', 30, true);
          public          postgres    false    228         <           0    0    purchase_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.purchase_id_seq', 23, true);
          public          postgres    false    230         =           0    0    review_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.review_id_seq', 3, true);
          public          postgres    false    232         >           0    0 
   tag_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.tag_id_seq', 48, true);
          public          postgres    false    234         X           2606    44217     administrator administrator_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.administrator DROP CONSTRAINT administrator_pkey;
       public            postgres    false    215         Z           2606    44219    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    217         \           2606    44221    customer customer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    219         ^           2606    44223    daily_stats daily_stats_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_pkey;
       public            postgres    false    221         `           2606    44225 ,   degree_of_belonging degree_of_belonging_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_pkey;
       public            postgres    false    223         b           2606    44227    developer developer_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.developer DROP CONSTRAINT developer_pkey;
       public            postgres    false    225         d           2606    44229    program program_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.program DROP CONSTRAINT program_pkey;
       public            postgres    false    227         f           2606    44231    purchase purchase_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_pkey;
       public            postgres    false    229         h           2606    44233    review review_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public            postgres    false    231         j           2606    44235    tag tag_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public            postgres    false    233         l           2606    44237    tag tag_tag_name_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tag_name_key;
       public            postgres    false    233         m           2606    44238    cart cart_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_customer_id_fkey;
       public          postgres    false    217    4700    219         n           2606    44243    cart cart_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_program_id_fkey;
       public          postgres    false    217    227    4708         o           2606    44248 '   daily_stats daily_stats_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_program_id_fkey;
       public          postgres    false    221    4708    227         p           2606    44253 7   degree_of_belonging degree_of_belonging_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_program_id_fkey;
       public          postgres    false    4708    223    227         q           2606    44258 3   degree_of_belonging degree_of_belonging_tag_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_tag_id_fkey;
       public          postgres    false    4714    223    233         r           2606    44263 !   program program_developer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.program DROP CONSTRAINT program_developer_id_fkey;
       public          postgres    false    227    4706    225         s           2606    44268 "   purchase purchase_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_customer_id_fkey;
       public          postgres    false    4700    229    219         t           2606    44273 !   purchase purchase_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_program_id_fkey;
       public          postgres    false    227    229    4708         u           2606    44278    review review_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.review DROP CONSTRAINT review_customer_id_fkey;
       public          postgres    false    231    219    4700         v           2606    44283    review review_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.review DROP CONSTRAINT review_program_id_fkey;
       public          postgres    false    227    4708    231                                                4870.dat                                                                                            0000600 0004000 0002000 00000000122 14764320744 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	$2a$10$t5/BODlYh6END/jpntup8ual66AkaDdRG3ZfL4CY7UJcV27cHnd6q	administrator
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                              4872.dat                                                                                            0000600 0004000 0002000 00000000005 14764320744 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4874.dat                                                                                            0000600 0004000 0002000 00000000370 14764320744 0014273 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	customer1	$2a$10$YMs3QL44GMSvyQX6F5ZE8ek2PH0dLKLb2nQUSxB8YPNf38MaNIoau	\N	0.00
2	customer2	$2a$10$qGhYdZ27VcRagzSXH.36y.wYNnzea7azEJj5auBTJngyH2bOBJW2K	\N	0.00
3	customer3	$2a$10$0TXfQ2XBFLXKhw2Mqt0b4ekS/0KU74svpwnCtahL/tJAYtXeAbulC	\N	0.00
\.


                                                                                                                                                                                                                                                                        4876.dat                                                                                            0000600 0004000 0002000 00000000005 14764320744 0014270 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           4878.dat                                                                                            0000600 0004000 0002000 00000000511 14764320744 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        34	17	16	10
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
\.


                                                                                                                                                                                       4880.dat                                                                                            0000600 0004000 0002000 00000000124 14764320744 0014265 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	SoftDepotDEV	$2a$10$VMRYIXl18B/xp75ZlzikQ.b4dcnJ6JiRFa6fr5tsLlwATvr47db22	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                            4882.dat                                                                                            0000600 0004000 0002000 00000042123 14764320744 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        17	1	Word	1499.00	Microsoft Word — это текстовый редактор, разработанный компанией Microsoft. Он является частью пакета Microsoft Office и используется для создания, редактирования и форматирования текстовых документов.	Microsoft Word — это мощный текстовый редактор, который позволяет пользователям создавать, редактировать и форматировать документы различной сложности. Он входит в состав пакета Microsoft Office и является одной из самых популярных программ для работы с текстом.\n\nОсновные функции:\n1. Создание и редактирование текста:\n2. Поддержка различных шрифтов, размеров и стилей текста.\n3. Возможность выравнивания текста, создания списков и колонок.\n\nФорматирование документов:\n1. Использование стилей для заголовков, подзаголовков и основного текста.\n2. Настройка полей, отступов и интервалов.\n\nРабота с графикой:\n1. Вставка изображений, фигур, диаграмм и SmartArt.\n2. Возможность настройки обтекания текста вокруг графических элементов.\n\nТаблицы и диаграммы:\n1. Создание и форматирование таблиц.\n2. Вставка диаграмм (столбчатых, круговых, линейных и др.).\n\nКоллаборация:\n1. Совместная работа над документами в режиме реального времени через облако (OneDrive, SharePoint).\n2. Возможность комментирования и рецензирования.\n\nИнтеграция с другими программами:\n1. Совместимость с Excel, PowerPoint и другими приложениями Microsoft Office.\n2. Поддержка экспорта документов в форматы PDF, HTML, TXT и другие.\n\nДополнительные инструменты:\n1. Проверка орфографии и грамматики.\n2. Поиск и замена текста.\n3. Автоматическое создание оглавления и сносок.	/uploads/program/17/0128b0d5-d335-4e64-99d7-1c203138ed55_Microsoft_Office_Word_Logo_512px.png	\N	\N	\N	{/uploads/program/17/04fd4a23-3b0f-4a7b-acf6-2d03bc1dcee2_7d129359-4461-47d0-8b82-e0bf043f2e1a.png,/uploads/program/17/eb0a368c-07d7-432b-b169-00941f73e4cc_microsoft-word-for-windows.png,/uploads/program/17/e6f804d8-25e1-4c63-83f6-cbefd2bfd764_microsoft-word-mac.png,/uploads/program/17/cc635c24-4929-41f0-9d5f-3b82949bb2d1_office-home-2024-screenshot-01.png,/uploads/program/17/9ecd8a4a-4e37-47ec-b27d-b9f6777190ce_word_2024_copilot_1024x1024.png}
24	1	PowerPoint	1499.00	Microsoft PowerPoint — программа для создания презентаций. Позволяет добавлять слайды с текстом, изображениями, графиками и анимацией. Используется для бизнеса, образования и публичных выступлений.	Microsoft PowerPoint — это мощное приложение для создания и проведения презентаций, входящее в пакет Microsoft Office. Оно позволяет пользователям создавать профессиональные слайд-шоу с использованием текста, изображений, графиков, диаграмм, видео и анимации.\\n\r\nСоздание слайдов:\r\n· Шаблоны для быстрого старта.\r\n· Настройка макетов слайдов (заголовки, текст, изображения).\r\nМультимедиа:\r\n· Вставка изображений, аудио и видео.\r\n· Анимация текста и объектов.\r\nДизайн:\r\n· Темы и стили для оформления презентаций.\r\n· Настройка цветов, шрифтов и эффектов.\r\nГрафики и диаграммы:\r\n· Создание визуализаций данных (столбчатые, круговые, линейные диаграммы).\r\nКоллаборация:\r\n· Совместная работа в реальном времени через облако (OneDrive, SharePoint).\r\n· Комментирование и рецензирование.\r\nПрезентация:\r\n· Режим докладчика с заметками.\r\n· Экспорт в PDF или видеоформат.	/uploads/program/24/43c3a4bd-df92-4202-8225-ed8c14aa6edd_Microsoft_Office_PowerPoint_(2019–present).svg.png	\N	\N	\N	{/uploads/program/24/1f7e5ca4-9999-4676-b087-2f3803f6a12b_01EN.png,/uploads/program/24/6c1ae9da-85d4-4dde-bf42-4484851bc851_powerpoint-2023-powerpoint-load.png,/uploads/program/24/d4238c9d-5ee6-4114-86fd-1baa5357df9f_powerpoint-2023-powerpoint-load-2.png,/uploads/program/24/dbe92ae0-f202-44d1-bc56-feb7c4730dab_powerpoint-2023-powerpoint-load-3.png,/uploads/program/24/88a2b705-5ec7-4bbc-a9fb-695f152d1d39_powerpoint-2023-powerpoint-load-4.png,/uploads/program/24/df4464f5-b6ca-4ffc-ad61-26a02f2df5a7_powerpoint-designer.jpg}
25	1	Excel	1499.00	Excel — программа для работы с электронными таблицами от Microsoft. Позволяет анализировать данные, создавать графики, выполнять расчеты и автоматизировать задачи. Подходит для бизнеса, учебы и личного использования.	Microsoft Excel — мощный инструмент для работы с электронными таблицами, входящий в пакет Microsoft Office. Программа позволяет организовывать, анализировать и визуализировать данные с помощью таблиц, формул, графиков и диаграмм. Excel поддерживает сложные математические, статистические и финансовые расчеты, а также предоставляет возможности для автоматизации задач с помощью макросов и VBA (Visual Basic for Applications). Широко используется в бизнесе, науке, образовании и личных целях для учета, отчетности, планирования и анализа данных.	/uploads/program/25/70917277-3bc4-43c1-a2a9-eab4d1d4df30_Microsoft_Excel_2013-2019_logo.svg.png	\N	\N	\N	{/uploads/program/25/c3e34a1e-70e8-4749-a5c6-371872a5d20a_arrange-excel-files.png,/uploads/program/25/0ffccb3f-346f-47ee-9db6-b7da444ba14f_images.jpg,/uploads/program/25/5758ede6-d31d-433b-8f24-9db37beeb3ec_print-screen.jpg,/uploads/program/25/672feced-9d4b-4fd6-9b95-c4ca264e398b_maxresdefault.jpg}
28	1	Blender	0.00	Blender — бесплатная программа для 3D-моделирования, анимации, визуализации и создания игр. Поддерживает скульптинг, симуляции, монтаж видео и композитинг.	Blender — это мощное бесплатное программное обеспечение с открытым исходным кодом для 3D-моделирования, анимации, рендеринга, создания игр и визуальных эффектов. Программа включает инструменты для скульптинга, текстурирования, симуляции физики (дым, жидкости, ткани), анимации персонажей, монтажа видео и композитинга. Blender поддерживает множество форматов файлов и предоставляет гибкие настройки рендеринга, включая Cycles и Eevee. Широко используется художниками, дизайнерами, аниматорами и разработчиками игр благодаря своей универсальности и активному сообществу.	/uploads/program/28/fcc9aee9-8c12-403b-961e-bcd6ba37e508_Blender_logo_no_text.svg.png	\N	\N	\N	{/uploads/program/28/96600cbd-7a22-48f4-8210-b538d1047b50_2b5da48c2255771643270fc592273338ee822245.jpeg,/uploads/program/28/f12ffbc9-80e4-4b58-964a-ce6ebef38462_4voL6.png,/uploads/program/28/9f3af6e8-362b-4203-ba63-4db292c821ac_5d421a5d64a95fab9aeb91813aea81db06ec02f0.png,/uploads/program/28/544e0094-6b28-4d08-aa0e-9b79a220f9cd_9447f7f59a2c10fefcb15c6a2777ee2d391fb2e8.png,/uploads/program/28/c95211c1-607f-44d5-a4bc-83285b751f7c_11051915122021_08fda0244b5397e030ee401fd2bea5b24f78a72b.jpg,/uploads/program/28/64ec1514-7d1d-4f1e-8973-f509eb18169b_Blender_3.2.0_screenshot.png,/uploads/program/28/5fd22e1c-1e3d-4514-aa17-e1969e825232_blender_421.png,/uploads/program/28/c824a21b-7a5d-46fe-a301-8bbed5880ee5_snapshot-meshes.jpg}
27	1	VideoPad Video Editor	0.00	VideoPad Video Editor — программа для редактирования видео. Подходит для монтажа, добавления эффектов, переходов, титров и аудиодорожек. Экспорт в различные форматы.	VideoPad Video Editor — это удобный видеоредактор для создания и монтажа видео. Программа позволяет обрезать и склеивать клипы, добавлять эффекты, переходы, текстовые титры, а также накладывать аудиодорожки и звуковые эффекты. VideoPad поддерживает работу с множеством видеоформатов, включая HD и 4K, и предоставляет возможность экспорта готовых проектов для загрузки на YouTube, DVD или других платформ. Подходит как для начинающих, так и для опытных пользователей благодаря интуитивному интерфейсу и широкому набору инструментов.	/uploads/program/27/abe2cbb8-ffb2-4fa8-808d-2f136857b078_Без имени.jpg	\N	\N	\N	{/uploads/program/27/385e15c1-beb2-4a59-820c-1d2e7dbd58ad_78062f44-5347-48f0-ac3a-48e87d2b5742.png,/uploads/program/27/75c44702-9af2-41d0-b477-b9203c0fdffc_aaa.jpg.22396c558282a410cd19c302947dfd24.jpg,/uploads/program/27/73f03753-082b-409a-bcf9-e3b1649ae484_apps.43698.13939617729822645.65531390-8993-4b0f-9801-d944553dccf4.jpg,/uploads/program/27/bcda9daf-644d-4b74-a9eb-b7cfa0672ab6_hq720.jpg,/uploads/program/27/82c59b69-9e8c-40bd-bbde-cb13917dc85c_videopad-video-editor-(free).png,/uploads/program/27/690fbfe4-e939-438e-8447-e8caeaaeca44_vnw546E3uQNAeesQVhkR6W-1200-80.jpg}
26	1	Audacity	0.00	Audacity — бесплатная программа для редактирования аудио. Подходит для записи, монтажа, обработки звука и применения эффектов. Поддерживает множество форматов и плагинов.	Audacity — это бесплатное, кроссплатформенное программное обеспечение с открытым исходным кодом для редактирования и записи аудио. Программа позволяет записывать звук с микрофона или других источников, редактировать дорожки (обрезать, копировать, склеивать), применять эффекты (шумоподавление, эквалайзер, реверберация и др.) и работать с множеством аудиоформатов (WAV, MP3, FLAC и т.д.). Audacity поддерживает VST-плагины, многодорожечную запись и экспорт проектов. Широко используется музыкантами, подкастерами, звукорежиссерами и любителями для создания и обработки аудиоконтента.	/uploads/program/26/c23c63b0-8118-4fa9-8ca9-dd2c929bab85_Audacity_Logo_nofilter.svg.png	\N	\N	\N	{/uploads/program/26/21f8bd3a-ebc4-46b8-b13c-8e36cb23e1bb_a6033853e501a57002e2e1d6d8fbf2c6bef89e73.jpeg,/uploads/program/26/a0a399e5-03a9-4146-a1c2-310b9f3aa4fe_Audacity_3.6_Screenshot.png,/uploads/program/26/b53d9be7-6cdf-4202-aeae-9c5f3eb30320_Audacity_screenshot.png,/uploads/program/26/b1fe26bd-7164-45e0-8bc9-3b1c1e1f72cd_Audacity-Screenshot.jpg}
29	1	Яндекс Браузер	0.00	Яндекс Браузер — быстрый и удобный браузер с интеграцией сервисов Яндекса. Поддержка Turbo-режима, умной строки, голосового поиска и синхронизации данных.	Яндекс Браузер — это современный веб-браузер, разработанный компанией Яндекс. Он отличается высокой скоростью работы, благодаря Turbo-режиму, который ускоряет загрузку страниц при медленном интернете. Браузер интегрирован с сервисами Яндекса, включая поиск, почту, карты и диск. Ключевые функции: умная строка для быстрого поиска и перехода на сайты, голосовой поиск, синхронизация данных между устройствами, встроенный переводчик и защита от вредоносных сайтов. Подходит для пользователей, ценящих удобство и интеграцию с экосистемой Яндекса.	/uploads/program/29/d48f7d8a-7a90-44a5-894d-0a06439a4449_Yandex_Browser_icon.svg.png	\N	\N	\N	{/uploads/program/29/c5b5d17c-0ba3-42d6-a7c3-684dbc04687a_orig.png,/uploads/program/29/f927d79d-57c0-4271-84ab-9e6dbc202afe_orig1.png,/uploads/program/29/0499f36b-ebb5-45cb-81e1-d28e53e510ce_Screenshot_2023_Yandex.png,/uploads/program/29/48ef8030-8184-4369-9e9b-f05b71eaea6e_screenshot-1.jpg,/uploads/program/29/d9aaa389-db17-4533-afdd-49d44f2ae979_screenshot-3.png,/uploads/program/29/a54b6743-8912-4dbe-8547-4438ee1c34b5_screenshot-6.png,/uploads/program/29/7c39099b-f455-4ff4-b277-8e34f96429a3_screenshot-9.jpg,/uploads/program/29/8fc38df2-0574-4f3a-853a-d7fa60e097c2_screenshot-10.png,/uploads/program/29/e732e0bd-7d73-45d5-82d1-368f6b6cf34a_screenshot-13.png}
30	1	Photoshop	3999.00	Photoshop — профессиональный графический редактор для обработки изображений, создания дизайнов и иллюстраций. Поддержка слоев, масок, фильтров и инструментов для точной работы.	Adobe Photoshop — это ведущий профессиональный графический редактор, используемый для обработки фотографий, создания дизайнов, иллюстраций и цифрового искусства. Программа предлагает мощные инструменты для работы со слоями, масками, фильтрами, коррекцией цвета и ретушью. Photoshop поддерживает работу с растровой графикой, а также частично с векторной. Широко применяется фотографами, дизайнерами, художниками и маркетологами благодаря своей универсальности и точности. Интегрируется с другими продуктами Adobe, такими как Illustrator и Lightroom.	/uploads/program/30/28c78396-6b95-464b-b365-e79baa682ee6_Adobe_Photoshop_CC_icon.svg.png	\N	\N	\N	{/uploads/program/30/ed935fa8-651c-430e-b530-a1e533f43ebe_photoshop-1.png,/uploads/program/30/9e3464f9-9853-4373-9c76-b6835d28a7da_photoshop-2.jpg,/uploads/program/30/4649963c-5485-4e40-b1be-715dd6f675bc_photoshop-3.jpg,/uploads/program/30/6d601c73-d415-416d-8721-3a7edb8f03db_photoshop-4.png,/uploads/program/30/55a72676-448a-4816-a9c9-990fc45e5efb_photoshop-5.jpg,/uploads/program/30/e5166ee1-774b-4a43-b686-d850286e587d_photoshop-6.jpg,/uploads/program/30/072a2f72-4aba-4ac4-a963-56ab92b1a374_Photoshop-screenshot.JPG}
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                             4884.dat                                                                                            0000600 0004000 0002000 00000000050 14764320744 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        23	2025-03-12 06:20:15.118681	1	17
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        4886.dat                                                                                            0000600 0004000 0002000 00000000141 14764320744 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	1	17	5	2025-03-12 06:21:41.096619	Отличный редактор документов!
\.


                                                                                                                                                                                                                                                                                                                                                                                                                               4888.dat                                                                                            0000600 0004000 0002000 00000001745 14764320744 0014307 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        16	Текстовый редактор
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
\.


                           restore.sql                                                                                         0000600 0004000 0002000 00000054735 14764320744 0015415 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
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

SELECT pg_catalog.setval('public.cart_id_seq', 45, true);


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

SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 79, true);


--
-- Name: developer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.developer_id_seq', 1, true);


--
-- Name: program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_id_seq', 30, true);


--
-- Name: purchase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_id_seq', 23, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 3, true);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_id_seq', 48, true);


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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   