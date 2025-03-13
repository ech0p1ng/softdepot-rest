PGDMP                      }         	   softdepot    16.3    16.3 `               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    20393 	   softdepot    DATABASE     }   CREATE DATABASE softdepot WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE softdepot;
                postgres    false            �            1259    20394    administrator    TABLE     �   CREATE TABLE public.administrator (
    id integer NOT NULL,
    password character varying(60) NOT NULL,
    administrator_name character varying(50) NOT NULL
);
 !   DROP TABLE public.administrator;
       public         heap    postgres    false                        0    0    TABLE administrator    ACL     �   GRANT SELECT ON TABLE public.administrator TO customer_role;
GRANT SELECT ON TABLE public.administrator TO developer_role;
GRANT SELECT ON TABLE public.administrator TO unregistered_role;
          public          postgres    false    215            �            1259    20397    administrator_id_seq    SEQUENCE     �   CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.administrator_id_seq;
       public          postgres    false    215            !           0    0    administrator_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;
          public          postgres    false    216            �            1259    20398    cart    TABLE     y   CREATE TABLE public.cart (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.cart;
       public         heap    postgres    false            "           0    0 
   TABLE cart    ACL     I   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cart TO customer_role;
          public          postgres    false    217            �            1259    20401    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public          postgres    false    217            #           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public          postgres    false    218            �            1259    20402    customer    TABLE     )  CREATE TABLE public.customer (
    id integer NOT NULL,
    customer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200),
    balance numeric(10,2),
    CONSTRAINT customer_balance_check CHECK ((balance >= (0)::numeric))
);
    DROP TABLE public.customer;
       public         heap    postgres    false            $           0    0    TABLE customer    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customer TO customer_role;
GRANT SELECT ON TABLE public.customer TO developer_role;
GRANT SELECT ON TABLE public.customer TO unregistered_role;
          public          postgres    false    219            �            1259    20406    customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.customer_id_seq;
       public          postgres    false    219            %           0    0    customer_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;
          public          postgres    false    220            &           0    0    SEQUENCE customer_id_seq    ACL     H   GRANT SELECT,USAGE ON SEQUENCE public.customer_id_seq TO customer_role;
          public          postgres    false    220            �            1259    20407    daily_stats    TABLE     
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
       public         heap    postgres    false            '           0    0    TABLE daily_stats    ACL     <   GRANT SELECT ON TABLE public.daily_stats TO developer_role;
          public          postgres    false    221            �            1259    20412    daily_stats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.daily_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.daily_stats_id_seq;
       public          postgres    false    221            (           0    0    daily_stats_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.daily_stats_id_seq OWNED BY public.daily_stats.id;
          public          postgres    false    222            �            1259    20413    degree_of_belonging    TABLE       CREATE TABLE public.degree_of_belonging (
    id integer NOT NULL,
    program_id integer NOT NULL,
    tag_id integer NOT NULL,
    degree_value integer NOT NULL,
    CONSTRAINT degree_of_belonging_degree_value_check CHECK (((degree_value >= 0) AND (degree_value <= 10)))
);
 '   DROP TABLE public.degree_of_belonging;
       public         heap    postgres    false            )           0    0    TABLE degree_of_belonging    ACL     Y   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.degree_of_belonging TO developer_role;
          public          postgres    false    223            �            1259    20417    degree_of_belonging_id_seq    SEQUENCE     �   CREATE SEQUENCE public.degree_of_belonging_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.degree_of_belonging_id_seq;
       public          postgres    false    223            *           0    0    degree_of_belonging_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.degree_of_belonging_id_seq OWNED BY public.degree_of_belonging.id;
          public          postgres    false    224            �            1259    20418 	   developer    TABLE     �   CREATE TABLE public.developer (
    id integer NOT NULL,
    developer_name character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    profile_img_url character varying(200)
);
    DROP TABLE public.developer;
       public         heap    postgres    false            +           0    0    TABLE developer    ACL     �   GRANT SELECT ON TABLE public.developer TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.developer TO developer_role;
GRANT SELECT ON TABLE public.developer TO unregistered_role;
          public          postgres    false    225            �            1259    20421    developer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.developer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.developer_id_seq;
       public          postgres    false    225            ,           0    0    developer_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.developer_id_seq OWNED BY public.developer.id;
          public          postgres    false    226            -           0    0    SEQUENCE developer_id_seq    ACL     J   GRANT SELECT,USAGE ON SEQUENCE public.developer_id_seq TO developer_role;
          public          postgres    false    226            �            1259    20422    program    TABLE     	  CREATE TABLE public.program (
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
       public         heap    postgres    false            .           0    0    TABLE program    ACL     �   GRANT SELECT ON TABLE public.program TO customer_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.program TO developer_role;
GRANT SELECT ON TABLE public.program TO unregistered_role;
          public          postgres    false    227            �            1259    20428    program_id_seq    SEQUENCE     �   CREATE SEQUENCE public.program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.program_id_seq;
       public          postgres    false    227            /           0    0    program_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.program_id_seq OWNED BY public.program.id;
          public          postgres    false    228            �            1259    20429    purchase    TABLE     �   CREATE TABLE public.purchase (
    id integer NOT NULL,
    purchase_date_time timestamp without time zone NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL
);
    DROP TABLE public.purchase;
       public         heap    postgres    false            0           0    0    TABLE purchase    ACL     M   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.purchase TO customer_role;
          public          postgres    false    229            �            1259    20432    purchase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.purchase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.purchase_id_seq;
       public          postgres    false    229            1           0    0    purchase_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.purchase_id_seq OWNED BY public.purchase.id;
          public          postgres    false    230            �            1259    20433    review    TABLE     I  CREATE TABLE public.review (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    program_id integer NOT NULL,
    estimation integer NOT NULL,
    date_time timestamp without time zone NOT NULL,
    review_text text NOT NULL,
    CONSTRAINT review_estimation_check CHECK (((estimation >= 0) AND (estimation <= 5)))
);
    DROP TABLE public.review;
       public         heap    postgres    false            2           0    0    TABLE review    ACL     �   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.review TO customer_role;
GRANT SELECT ON TABLE public.review TO developer_role;
GRANT SELECT ON TABLE public.review TO unregistered_role;
          public          postgres    false    231            �            1259    20439    review_id_seq    SEQUENCE     �   CREATE SEQUENCE public.review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.review_id_seq;
       public          postgres    false    231            3           0    0    review_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;
          public          postgres    false    232            �            1259    20440    tag    TABLE     b   CREATE TABLE public.tag (
    id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);
    DROP TABLE public.tag;
       public         heap    postgres    false            �            1259    20443 
   tag_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.tag_id_seq;
       public          postgres    false    233            4           0    0 
   tag_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;
          public          postgres    false    234            G           2604    20444    administrator id    DEFAULT     t   ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);
 ?   ALTER TABLE public.administrator ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            H           2604    20445    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            I           2604    20446    customer id    DEFAULT     j   ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);
 :   ALTER TABLE public.customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            J           2604    20447    daily_stats id    DEFAULT     p   ALTER TABLE ONLY public.daily_stats ALTER COLUMN id SET DEFAULT nextval('public.daily_stats_id_seq'::regclass);
 =   ALTER TABLE public.daily_stats ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            K           2604    20448    degree_of_belonging id    DEFAULT     �   ALTER TABLE ONLY public.degree_of_belonging ALTER COLUMN id SET DEFAULT nextval('public.degree_of_belonging_id_seq'::regclass);
 E   ALTER TABLE public.degree_of_belonging ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223            L           2604    20449    developer id    DEFAULT     l   ALTER TABLE ONLY public.developer ALTER COLUMN id SET DEFAULT nextval('public.developer_id_seq'::regclass);
 ;   ALTER TABLE public.developer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            M           2604    20450 
   program id    DEFAULT     h   ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_id_seq'::regclass);
 9   ALTER TABLE public.program ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227            N           2604    20451    purchase id    DEFAULT     j   ALTER TABLE ONLY public.purchase ALTER COLUMN id SET DEFAULT nextval('public.purchase_id_seq'::regclass);
 :   ALTER TABLE public.purchase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    230    229            O           2604    20452 	   review id    DEFAULT     f   ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
 8   ALTER TABLE public.review ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231            P           2604    20453    tag id    DEFAULT     `   ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);
 5   ALTER TABLE public.tag ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233                      0    20394    administrator 
   TABLE DATA           I   COPY public.administrator (id, password, administrator_name) FROM stdin;
    public          postgres    false    215   q                 0    20398    cart 
   TABLE DATA           ;   COPY public.cart (id, customer_id, program_id) FROM stdin;
    public          postgres    false    217   rq       
          0    20402    customer 
   TABLE DATA           Y   COPY public.customer (id, customer_name, password, profile_img_url, balance) FROM stdin;
    public          postgres    false    219   �q                 0    20407    daily_stats 
   TABLE DATA           }   COPY public.daily_stats (id, stats_date, program_id, avg_estimation, earnings, purchases_amount, reviews_amount) FROM stdin;
    public          postgres    false    221   er                 0    20413    degree_of_belonging 
   TABLE DATA           S   COPY public.degree_of_belonging (id, program_id, tag_id, degree_value) FROM stdin;
    public          postgres    false    223   �r                 0    20418 	   developer 
   TABLE DATA           R   COPY public.developer (id, developer_name, password, profile_img_url) FROM stdin;
    public          postgres    false    225   ps                 0    20422    program 
   TABLE DATA           �   COPY public.program (id, developer_id, program_name, price, short_description, description, logo_url, installer_windows_url, installer_linux_url, installer_macos_url, screenshots_url) FROM stdin;
    public          postgres    false    227   �s                 0    20429    purchase 
   TABLE DATA           S   COPY public.purchase (id, purchase_date_time, customer_id, program_id) FROM stdin;
    public          postgres    false    229   ��                 0    20433    review 
   TABLE DATA           a   COPY public.review (id, customer_id, program_id, estimation, date_time, review_text) FROM stdin;
    public          postgres    false    231   ��                 0    20440    tag 
   TABLE DATA           +   COPY public.tag (id, tag_name) FROM stdin;
    public          postgres    false    233   2�       5           0    0    administrator_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);
          public          postgres    false    216            6           0    0    cart_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.cart_id_seq', 45, true);
          public          postgres    false    218            7           0    0    customer_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.customer_id_seq', 3, true);
          public          postgres    false    220            8           0    0    daily_stats_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.daily_stats_id_seq', 1, true);
          public          postgres    false    222            9           0    0    degree_of_belonging_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.degree_of_belonging_id_seq', 96, true);
          public          postgres    false    224            :           0    0    developer_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.developer_id_seq', 1, true);
          public          postgres    false    226            ;           0    0    program_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.program_id_seq', 34, true);
          public          postgres    false    228            <           0    0    purchase_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.purchase_id_seq', 23, true);
          public          postgres    false    230            =           0    0    review_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.review_id_seq', 3, true);
          public          postgres    false    232            >           0    0 
   tag_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.tag_id_seq', 53, true);
          public          postgres    false    234            X           2606    20456     administrator administrator_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT administrator_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.administrator DROP CONSTRAINT administrator_pkey;
       public            postgres    false    215            Z           2606    20458    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public            postgres    false    217            \           2606    20460    customer customer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customer DROP CONSTRAINT customer_pkey;
       public            postgres    false    219            ^           2606    20462    daily_stats daily_stats_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_pkey;
       public            postgres    false    221            `           2606    20464 ,   degree_of_belonging degree_of_belonging_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_pkey;
       public            postgres    false    223            b           2606    20466    developer developer_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.developer
    ADD CONSTRAINT developer_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.developer DROP CONSTRAINT developer_pkey;
       public            postgres    false    225            d           2606    20468    program program_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.program DROP CONSTRAINT program_pkey;
       public            postgres    false    227            f           2606    20470    purchase purchase_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_pkey;
       public            postgres    false    229            h           2606    20472    review review_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public            postgres    false    231            j           2606    20474    tag tag_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_pkey;
       public            postgres    false    233            l           2606    20476    tag tag_tag_name_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);
 >   ALTER TABLE ONLY public.tag DROP CONSTRAINT tag_tag_name_key;
       public            postgres    false    233            m           2606    20477    cart cart_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_customer_id_fkey;
       public          postgres    false    217    4700    219            n           2606    20482    cart cart_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_program_id_fkey;
       public          postgres    false    4708    227    217            o           2606    20487 '   daily_stats daily_stats_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.daily_stats
    ADD CONSTRAINT daily_stats_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.daily_stats DROP CONSTRAINT daily_stats_program_id_fkey;
       public          postgres    false    4708    227    221            p           2606    20492 7   degree_of_belonging degree_of_belonging_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 a   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_program_id_fkey;
       public          postgres    false    223    4708    227            q           2606    20497 3   degree_of_belonging degree_of_belonging_tag_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.degree_of_belonging
    ADD CONSTRAINT degree_of_belonging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.degree_of_belonging DROP CONSTRAINT degree_of_belonging_tag_id_fkey;
       public          postgres    false    223    233    4714            r           2606    20502 !   program program_developer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_developer_id_fkey FOREIGN KEY (developer_id) REFERENCES public.developer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.program DROP CONSTRAINT program_developer_id_fkey;
       public          postgres    false    4706    227    225            s           2606    20507 "   purchase purchase_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_customer_id_fkey;
       public          postgres    false    229    219    4700            t           2606    20512 !   purchase purchase_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;
 K   ALTER TABLE ONLY public.purchase DROP CONSTRAINT purchase_program_id_fkey;
       public          postgres    false    229    4708    227            u           2606    20517    review review_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.review DROP CONSTRAINT review_customer_id_fkey;
       public          postgres    false    231    219    4700            v           2606    20522    review review_program_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.review DROP CONSTRAINT review_program_id_fkey;
       public          postgres    false    227    4708    231               Z   x�3�T1JT14P)1�w�wɉ�0s�s��*�+)-�(M�13s�NtI	r7�J�1q�4�J32O��K1+�LL����,.)J,�/����� �'�            x������ � �      
   �   x�=��B@ �5�a��bK�CIj��fԔӏ~��[q�ʩ*��)��������11�E��mL'��af�;�=t&ɠ�����l]��h��r��#��B~9;�ڝ6��%�������f�m�+w��փl��{�!�C����;'4�?e��'#��Y�輦J����&�p��1£����I!            x������ � �         �   x�-�ɕ1��<��\~�q�}r�Z�E�n�����p��❟�$F���\~n��Q�&y9��a��lF�!$t +�&<lQ��LB��:��8f�(��M��γl��N*�i9.��ˆ�Ҡo��E�	O��&Fz�=�ݐѧF��>u��%'�V�9xN5��|ٰGt�y+!��Z���t���ϲ��/�Z��l_�-�F��N�sj��3���L�         \   x�3��O+qI-�/qq�T1JT14P	����1�pү(07�ʩ���K2II��2��rK4K+2-)��)w)+21OI22������� A��            x��|[�Ǖ��+
�/$��+2"23r�(Q�h��h��v ��%��fWOuS���]W�x�`����>��b��&���T���%{NDdVfUfw� 5����r����s�H򷒷>���[�(�J��ɦ�Mw�������oG�ߝ?]��������	�Y�8�fq8:�^-��1<<<�'��7��sx��=]��//��w'���9��p�t�1Z���tt��ŋ�1�=8
�zt��b{<�������~��_�t�AUm7Z���'�3h�[ĳ��1��>{�#8���;�9���՟b���`��=��
��s��=�_�����wv�uЕ�R��P�Sz�'��6ZJ ��7����?8�vH�ٰ §+s=�&�����%�g�ޞ-^�[?�y\k�����+�.��������^��T���6��8	���
߇�Ƈ~2/��O@6��4���y�]�����?�^�4~�%�w B��O�[_@�����vs��m]�/��Yv�M0h�~R�`��A�G ����Dο��s�ךz⢄|�^�𳃮���|8t�?֓�:��N?���C�U���ڮ�M�[��߿B5@�!��������FQ��ko� ۓ��	_�_�����x�����ryQC��E�k�?�a��	����#�?��3�4�;�S�e�A�^�(�yi-Q�R�Λ�Aƙ��������s�@�QL�z�?{y���
�\8ǥ��G�W����8���?]�J��b�U��7AG`��-^�f jz�5a�����O�6�����?*��鰳���s��4�aS5M�3�qUD��V?��~�-l24�aj���'Ǹ��ܵE�q�?޸&�{��q\Z�(��D^�M�ݡ�ۦ���w�r��%��0��'������Y��Z�(�/���iĥ��]�`�ݜm~�ƣ?Q3w{���w�b�@^��6�#�.��f�� �߅��h7� ���a�+F:̾W�s�a��л����nO���R�<���#<���Vgc����[~�i�p��j))����Gu�'�ƣ;�������~���u0��8ޔ��ن�(�?Dy�0����>������w�� l��L���{㿅����M��w`��ϼM^ݰ���~��2���[�;[Sew';�齙�?I�	M��Ԧ�r��2A���$1��KgӴlV�+W"�*oM�M�4a;�6v����O����QY�'\ӊ�k�L�f)�&��9V�6aO"D��[J���8�+*x�\���q_NS�3i�a��3Mt���B$UΝ0��_τ<�)�j:#7�����p�Y%�������LƉ�0r�]e��l���v�+3؞�R���&%�M+�d�(�f6)�^���}G�/sۻ�L�M�.��R	�A�3D��]TY��IAa�p�%6Z�����t�L��#���ݏ� �e��{���@ڽnP�|��U0������0n���ʛ��@I�	�Z~���F�{�;X�q������:�#9�c���
�9�;r<jz|�j�=?~�!��js\3��a��4� ���@��E�X��(\��ƅ ���:�ú�����t��(a�{��`�<\/�r���W��g��C�{�p�!v�B_�s<�
<A���Xx@���*�Z9�m�����#�:Ù-�*��� �qܨ�C�O��,�|�.G��9l��\�6�u���{��H�\�i\�<À���5�l���ma�Q�Ȓ�����C��O�b3��Ul�q\�|��p|�.�@������+~���;x���`���a�!2�\��(1�C����9��	���b/V)�ҡ��p�%.� �n�b��b�C���:v��a���
��e��8�?�/|kn�\��}�����΃<i�8J3���&�(���Z�o��v��DpÕЖت`D h�XJ��&Je��uv����I��qg�v�o��{��5���K�B.X G��h*s�*.)��0]��ݟ�3h!3�r�UD������J��2M��?�t�$���{lp�q+���$u.
�"�ʒD+��4iU�5N�p��L9J*�6!ڤ��΍�9�J_�<l^J�tNS����!��4Ɋ�JR`��6/�G_{UJtf�V4o�N�LQV1[�*o7o���m7��/;��R�~��kh�w�[��Q��!X���:�Y�Y�U�S�����[������q/�h���ӛoj���������o"�wܯ�nq�C7hj'�y�g��ϰ�y��2��CD��;l�F;����,�
��s�ú��0C�|/�A~����_���u<�o��������$�Mi�:�ꍸ1�Y.B$����t=��wՓ���؃ϟ�~�ps/�S��/¤:���
�:B�U3�W���R�/�CO-~����޶ԽG��z�����ݷo�����}��Fo��M3_{tcggkӨ��������a��Կ�u���#�0��S��=�W�X������$�-�	:�����q܃k�����w�X����I��}��MBSqJ�Xa+N[X�����rkzoz%�N'�;.T�HN�$"Q����3�ZFU�f3�}����js��@�A
 b4�Y�aG
���V	!�JDUn�W��@��6�<��\[� |q������x���ܙrg��b�-e9��q~*4 ��H���a˄���}�(�u�z���M���嶭��E��`M�{��+ސ�a��7��FH�W�c����H�<��V]v�s-8ڱ1G�3�!>�&�G�y0e��u�'��D;�zՉ�S�gކ�f6:b�>���	I�E�5�>��W��~�y��煮x!�4<8�oΖi�?Z���F����ւ�W�%�|�eť�9t��ϿG�+��pr+L���~l��٦�9��q��7ѵ���1�x���hi΢�]_��ȯ�c/���v�'L�RZ�o�jɨ �������Y�w� ���!��5l�������d�$��ʀĞ�u�:wU|:�܇7�6��C�
�o�|)��������+e��?:\�^�򪄸���bR9,e�w�@�q���c��������j�?��09(�s�<#
F�� h���V�F*˸����i���]	���2J���bо���c	%:��&T�:�%�)��4��y�d���V&-�9��9�H��>�i$����iPP�S	���9���+ŧ�[� $�H+����gL�gΉVOW���2%���oj�m����"�	WN��j�9>�%�a��d��[*�R�W�H�V��e!D^�U
OLB+W� �+����ɤ����^L��$>�ѼB7%J�W*9���Ӥ�M�$4M�$M�[��TV�I �����:'h��R�D�K�3=��r@m�5Ar�|�-�E�I���iRV�F��۠�22,0 s�!���*��T��Yz�2�J[����dB�D�&��PV9�8M����T�⸴��V;>%s��~��,���i����#�b���ܛF�������Uˀ�#�1��Nn�	����8b��yD�E�Ѷ��Dw�e~���h�'v�Rh�|�9܍�S�=�����2��R�uaBd֮�z�������������~�^ZO>�%q������Z��A� =�ߩ"��,ѷBu�Z����;C�5�1��.�*$d֠�G}���Q˺0�W7q`�Ǘa~�3�e�Z=�2���ńa�5Z�-j�d�M�f��f����ƣ�wo6ܦ� ��y\O�o"�5�������{�`�KX�Q;Y�Z��zYm��IEY��SOL1�W�~�TK�5>�=��Ւ�/��Q��W+L�����O�v�h-	`,�x�$଴�U	�d�k��r�!�?�h</d�����%D;lX� �������V�YV��%�X%I�ȑBP�W����)��P�7��0�����C�ˮ xC+�p����n0Ƌ̤�d�)�Pc��p�
�[�!1 }��(�SN�D�@�*����!E�vvv7�
���zJ�    ��l2`6Y�rxJ2�XRQH@'\ >��T��YS�U� ���9`$@.x�R�k����lB2�[:+`�� c��:��Fn�LM�)Z�e�A����Z ~}p��V�V�`�D �#��@?@��3J���퇩���~�������'��y�I������V�ͽ_���)������K(����U� VȜ�-�~c��2���o'0ؒy����
��� B��[�'�6���1Lp�b�;k��xW����m���p��Yp���#�|�|�)=�|Sނ�k�$$Ա���~6�!& hiT/];������-��C� ���}�7�sq��L�y�zcR�)�l<ݘ%���yC�:k�z��wǣ�����{�n��}��x�q}c�h� k�����vϦN�dL��z�����u|�.�]!W�oc4�����ŨM=�Qft"i;��~�5�����1l�,�Yr�^F�c����(���+��lb7�`��D"�c� �X�L�
��L�zeB�������s�+��	K*�-���1�H x��gF3��K�QT�����S���6����<|Y��������K	�
K�DFTb�	���+Q��D�FV~x�k�M�Q��v9Ɍ�B.|y�V�iN9��F/�u���r,�`	��uVK�� �0����4HZ#�X >.�o�����w볰�d^����u�R�B��g�;���Z�E�!r�$����$R�k)�
�y0�Sr�,��)ָ�GM0�}c	Th~s���¡������>���N����L0���v˂��i=X<']���Ǽ�C�O����w��ʟ��M|��,Bu8�N����UA�?[;226�F�Ɵ�_�`s���3�Ue�G8i�8�)���Uw����>��֤h;���q.� X��/�y�S��w�����>
?>����Q�Z	}=�R	��e+�~�j�w	���øH��|ؙŐ�"�eј��k��g~�y�e	@�IK��}�.��Vީ}���_��H�)��T��i��<���CJ�4&`���4�u:�u"��X�#��x�s�jszP��X�)s+�8`�P������;	^`B�(�Fm[��|{6}��f妙n_	⊉Iuj����v��䆓L
���U9�m���bR,�9VG���\(��Wˠ��-E?�	�\�gu
�b4`���I���`�Q����9�	x%)Gv 1����B���:O 	U�Z�G��V� �K :?在ʂ+[X!*�\�햆J���J��r�a1�a5x�)���t��B�햆�����Np��Xy�#3U�	V(�n������b�����0&�c�
���EnXGNC�b$�9t�A@�R��lBx&�Lg��Bu���  �x  �L���[��|!X����>�=��s���Z#�C����k;ն<x��t���I��G�b��#���hO����V�{ �p�ڡ;sm�\i;�nԕb�Q��|0�����H����{[G9ץ�����ɦ��|< qO���5ҏ��k2�8� 6�w�S�$M0��|:�5P�(�f}*$,w���,y���<����պ|��6ƌ�WH�6Z�|����V�:"�ʑ��x}��.#���E�z�t�U��v��e{u�/�b�g�cnXSs ��/x���L^/7Ws��w]"���||��s�g������C������{3�(xzk��'{���~1�t¤�%/2�a5�Ȅ&�g)q9��*�̹�����z��ser ]8[��Y��P�05N�;X� ?ҕ;u�d ࡡ`)`"`4�P���$O�UnU�!֏V��R�੐x~PP��F�$�6��<զ�l(�M�ÊJ2Kd� �T�V�����T�+օ��O�@��xɩ����#��e�H�c��� �Ɉ�)e2s��m��l�!�3���64�H�g����Ӊ�X�D�����c@����[�����[ID��I���7o|4�YF�.*\�IR-��S$�Y)��n��:D�E_����f���n�q d;�S��l��~��;��O޿�~4I��`g[�`h��5�z�K���pPۻ��n�.�ʅ��k#�~'W���/��v}�NoS�����=j�W��,�Au-g�,,�dc�"dcd��/�:��
�g��r�yp%�X=S�I��4G_T���L? <ӄ��b�X�n��+p����^�����:�{����}e��_{UD����[`��o�"�x���^Q���"��k��^�/}��~x��m�INm.M~w�N��/F8�ʴ�r-U�Y���>g���Y�\��Ʉ�T9� � =�8R�*��+�'�T�!���_}p���  %�*s&Q��)�%��k Y"�˩I���o����~1��$qB�����&�O�Io�a�"+�ǒkrksە��*�b�,)ߛ=�2��lN�K��7T�`��Yy����j,���%I!R<��@;����Z��uz%��"�W�(�=����H��G�����M5�V� ��C�Ks���Nʟ񻷶���F(79U �T����i�Ϲ��C��_=�Qmݧ���$��P���r�Pv��j@{2ԍ�n���h*&������#�2�����0�ᨳ��XlSy��fw�Ѭ��v�7߄ڗ��-�=b��(��6��3�1����0X�7�.]�cAC0	���c����G��44:��|�� Ԭ�Ea�qw�[;��$����8!�/�O��Ői'�=
NH��1���JO�-��n�Tf�,���N�6x�탣�q�z�2��Ѳ�l^<�΄����u��zEyj�1��Ū��1 ��v��l_���e�|�v�)Jk,�nnے�)�B���+[�l([n��J��>5�<O���/��u+Z2z��#i_��w@G�=a�H�z.dh��YP�M���v6ݴ�Q�O�����QkQ�{Nv�yۍ��w����u��y]�F8Hp3�R���h�I'|�h�����Cd}��&�U<�Fs�O���ʦ�ȩ㞫D�r/�e��;�9�TN
�E�^*�*M�L41@���c<-YF��%�x�e4��&�"�p	�Fa��,'�RxNXRYA�*7Tf\U�3Fhx1�^b3��OO���� 2���r�UUj ��0�HT?�Ifd��US8��2x^�b���4��)/7����mn��VW.�xyN���$����\[Qe�ޗ;3��{8�HB��Bd$W}��X�0�D@����E��X��˽������ ҿ�n*��˞ï���|��hh/x��nN���i��{T��bت��\�Ɏ���M����bÿ��j$�S ph>��s����4_uتӼ 2�v�Uu�l�%�e�uOH�v_�c�}k��0_��,�Z��2���jw}����_-�Pes��-c����Y��{�0�����K��bx�ZϚ�~'�t�ӿ�5�'��m�]C�qP���:��c�{GA��k�����6EWzyN�'�;А/�ӱ_F������ґ׋��������R����]�N�t�z�^�!�x����<^��Ӹ-b�v�|{�!�J�يC�xܶ��b/n�ڜ|��>_��q{��*����(!��:4��
�:w%5���E�<��Z�u����+���9]�:�E��s\����p=濏u��3
 �p$��@�4#EZ�D
���I�	]z����K�|��gYbI�.�P@a�H*�[�<j͊�, �e&/2^��"��B�l�,ORW�T(3P�ݤ6qU!5I��[P�t�1 �FT'�UU��Ϋ¹��INs�p�G*cӔ&"C����1��F1�b�_�����SŤ+��"���BWV��P"D�#�ûSd�e4M�p7�Ryf'�K5��ȓJ�ou��̙�q�����؄���A���FJ��p�1� "-XYe:�rm2�Y�9M�I
#2*�H�Q	O%Н⸃ύ&x�X���ʥ$9n��V��?�m�J�
	���ԁ�p�q'5D�B���%��M�K�moo)�>��~YmM���5����������ỏ��� �  -W�t�����J��.��?4�٨\�
��v0��͜���}os�5)���+ҲUJp��R��X���[.ġ����ˑ�J��(����w�����z����۲�^�o�'WE�[�V��V��B�W=��#"�����ׅ%���l�я�}�;��j�
�Ǟ�,�t���[T뺽Õ��jZh�����E���`]���O�M�w��b��y���@j�[XO�u1K}T!$\������lj�#C���g���NŬ^���)q�^�^��nW!��1FȐ���+�j��ƫ�i�F��W깎��N��ٺ/)�܃�-:��:v���kW�_Q<][c��u^����\��\�j �ej��@�6�pË����}Ռo���&Kc=����ş|g ��S�	�X�HCt�3� w5�U(G~�b(���Y�եdKLdU��hK)V�K@5f�zN�,-T�])W:e�ʭcEES�����'I�˥@�\>�b錨$�#,fQ���S�[�s�J*�D�&�*`mN+
@��S'(^-P�5|@Lx"S&�Pp�g24�D��.����4[`���� �����!4l5�B*�1�!rN$�� ﱦ��򰬬���2�T
���¤bx�p�j��	���<	˩� ��qsM@�	˄V�Tcm�ˀJ�9K�Վ��ť�Y���6t�}�$Yay�Q8�&�A��FÜ�6In5�Yy˩�6P���t��֞񌎖5���������wnZ��딫�c2x"��; �.�VfIz%�÷Ԓ�;`4䖨D��xZ��,���>�q�ކ$���a�bje�g��;
^��*7	3,�B�b�2Fe&*�����<�8��ey���r�ףra���u�p����G�Q
         .   x�32�4202�50�54R00�22�24�34�0�0�Bs�=... ���         d   x���� E��P�a@1Z��]��k0F���#qy������+������q���:�	���qȈW&�Z:�ذ�J#J�b'���X3��J�-         8  x�}S�nA<o��C�wf�#R8p�����yI82�H �$�;�n6��/��Q�{�Vl9\��WUW�d�	���P��=��{�N��+v#Ɣ����%�p�r�e�D�o�Bw����+��5��&�5���]";�8LBA�$|�Z��H��	[aV�aƿ���|�gd���#�>�k��T�-7�޳��d ��M")�^dF���@w|��sa��-�ށh'e�AH+�[�װ;�%�";(�3��W�iN�'�d��0�+���d�Ix�.er3�Fo��R���dU��M\F).R�G-3MΤ�+Yh�c�ܻm�"j�%9�Ff(l�t;C����(��Xݫ��F�tDE"}��z4p��f���|R�_��^qi�1�@��1d�E߭��L����޶�"#��U���qK-���D�>R��Εw�U�"����n����i�i�'�$�+_�����+F8��^�����T:|���Ӭ�l���7^(�\w��w8x��u�5YU~��x�O�L���=Xw� ���DzLbp+�^��f��#"�u��     