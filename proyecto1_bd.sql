PGDMP     :            	        w            pruebas    10.7    10.7 J    b           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            c           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            d           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            e           1262    16542    pruebas    DATABASE     �   CREATE DATABASE pruebas WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Spain.1252' LC_CTYPE = 'Spanish_Spain.1252';
    DROP DATABASE pruebas;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            f           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            g           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    33042    disponible_mesa()    FUNCTION     �   CREATE FUNCTION public.disponible_mesa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

UPDATE mesas
SET disponible = 'false'
WHERE mesa = new.mesa;

RETURN NEW;

END 
$$;
 (   DROP FUNCTION public.disponible_mesa();
       public       postgres    false    3    1            �            1255    33012    entrar_tienda()    FUNCTION     �  CREATE FUNCTION public.entrar_tienda() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE 
estaDentro text;

BEGIN

IF new.macaddress <> 'None' THEN
	estaDentro := (SELECT entradas.horaentrada FROM entradas WHERE entradas.macaddress = new.macaddress);
	IF estaDentro LIKE new.horaentrada THEN
	RAISE EXCEPTION 'Error';
	ELSE
	RAISE NOTICE 'El usuario se ha registrado';
	END IF;
ELSE
RAISE NOTICE 'El usuario no posee macaddress';
END IF;

RETURN NEW;

END
$$;
 &   DROP FUNCTION public.entrar_tienda();
       public       postgres    false    3    1            �            1255    33014    realizar_venta()    FUNCTION     �  CREATE FUNCTION public.realizar_venta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
mac text;

BEGIN 

IF new.comprasusuariomacaddress <> 'None' THEN
	mac := (SELECT usuarios.macaddress FROM usuarios WHERE usuarios.macaddress = new.comprasusuariomacaddress);
	IF mac IS NULL THEN
	RAISE EXCEPTION 'El usuario no se encuentra registrado en el centro comercial';
	ELSE
	RAISE NOTICE 'La compra se ha registrado';	
	END IF;
ELSE
RAISE NOTICE 'La compra se ha registrado';
END IF;

RETURN NEW;

END
$$;
 '   DROP FUNCTION public.realizar_venta();
       public       postgres    false    3    1            �            1255    32948    registrar_usuario()    FUNCTION     X  CREATE FUNCTION public.registrar_usuario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
mac text;
cedula numeric;

BEGIN

IF new.macaddress <> 'None' THEN
mac := (SELECT usuarios.macaddress FROM usuarios WHERE usuarios.macaddress = new.macaddress);
END IF;

cedula := (SELECT usuarios.cedula FROM usuarios WHERE usuarios.cedula = new.cedula);

IF mac IS NULL THEN
	IF cedula IS NULL THEN
	RAISE NOTICE 'El usuario se ha registrado';
	ELSE
	RAISE EXCEPTION 'El usuario se encuentra registrado';
	END IF;
ELSE
RAISE EXCEPTION 'El usuario se encuentra registrado';
END IF;
RETURN NEW;

END
$$;
 *   DROP FUNCTION public.registrar_usuario();
       public       postgres    false    3    1            �            1255    33024 0   registrar_venta(integer, text, integer, numeric)    FUNCTION     �  CREATE FUNCTION public.registrar_venta(tiendaid integer, compramacaddress text, comprasid integer, itemmonto numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
mac text;
horaEntrada text;

BEGIN

IF compramacaddress <> 'None' THEN
horaEntrada := (SELECT entradas.horaentrada FROM entradas WHERE entradas.macaddress = compramacaddress);
END IF;
RETURN horaEntrada;

END 
$$;
 u   DROP FUNCTION public.registrar_venta(tiendaid integer, compramacaddress text, comprasid integer, itemmonto numeric);
       public       postgres    false    3    1            �            1255    33052    setear_mesa()    FUNCTION     �   CREATE FUNCTION public.setear_mesa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

UPDATE mesas
SET disponible = 'true';

RETURN NEW;

END 
$$;
 $   DROP FUNCTION public.setear_mesa();
       public       postgres    false    3    1            �            1255    33017    ver_entradas()    FUNCTION     |  CREATE FUNCTION public.ver_entradas() RETURNS TABLE(acceso integer, entradas bigint)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY SELECT accesos.idacceso AS Acceso, COUNT(entradas.horaentrada) AS EntradasTotales 
FROM entradas 
INNER JOIN camaras 
ON entradas.camaraentrada = camaras.id 
INNER JOIN accesos 
ON camaras.accesoid = accesos.idacceso
GROUP BY Acceso;

END
$$;
 %   DROP FUNCTION public.ver_entradas();
       public       postgres    false    3    1            �            1255    33018    ver_salidas()    FUNCTION     w  CREATE FUNCTION public.ver_salidas() RETURNS TABLE(acceso integer, salidas bigint)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY SELECT accesos.idacceso AS Acceso, COUNT(entradas.horasalida) AS SalidasTotales 
FROM entradas 
INNER JOIN camaras 
ON entradas.camarasalida = camaras.id 
INNER JOIN accesos 
ON camaras.accesoid = accesos.idacceso
GROUP BY Acceso;

END
$$;
 $   DROP FUNCTION public.ver_salidas();
       public       postgres    false    1    3            �            1255    33016    ver_ventas()    FUNCTION     :  CREATE FUNCTION public.ver_ventas() RETURNS TABLE(nombre text, ventas numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN

RETURN QUERY SELECT tiendas.nombre AS Tienda, SUM(compras.itemmonto) AS GananciasTotales 
FROM compras 
INNER JOIN tiendas
ON compras.comprastiendaid = tiendas.id
GROUP BY tiendas.nombre;

END
$$;
 #   DROP FUNCTION public.ver_ventas();
       public       postgres    false    3    1            �            1259    32949    accesos    TABLE     Z   CREATE TABLE public.accesos (
    idacceso integer NOT NULL,
    numerocamaras numeric
);
    DROP TABLE public.accesos;
       public         postgres    false    3            �            1259    32955    accesos_id_acceso_seq    SEQUENCE     �   CREATE SEQUENCE public.accesos_id_acceso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.accesos_id_acceso_seq;
       public       postgres    false    199    3            h           0    0    accesos_id_acceso_seq    SEQUENCE OWNED BY     N   ALTER SEQUENCE public.accesos_id_acceso_seq OWNED BY public.accesos.idacceso;
            public       postgres    false    200            �            1259    32957    camaras    TABLE     O   CREATE TABLE public.camaras (
    id integer NOT NULL,
    accesoid integer
);
    DROP TABLE public.camaras;
       public         postgres    false    3            �            1259    32960    camaras_id_seq    SEQUENCE     �   CREATE SEQUENCE public.camaras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.camaras_id_seq;
       public       postgres    false    201    3            i           0    0    camaras_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.camaras_id_seq OWNED BY public.camaras.id;
            public       postgres    false    202            �            1259    32930    compras    TABLE     �   CREATE TABLE public.compras (
    id integer NOT NULL,
    comprastiendaid integer,
    usuariocedula integer,
    itemmonto numeric,
    itemid integer,
    comprasusuariomacaddress text
);
    DROP TABLE public.compras;
       public         postgres    false    3            �            1259    32928    compras_id_seq    SEQUENCE     �   CREATE SEQUENCE public.compras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.compras_id_seq;
       public       postgres    false    198    3            j           0    0    compras_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.compras_id_seq OWNED BY public.compras.id;
            public       postgres    false    197            �            1259    32962    entradas    TABLE     �   CREATE TABLE public.entradas (
    macaddress text,
    horaentrada text,
    horasalida text,
    camaraentrada integer,
    camarasalida integer
);
    DROP TABLE public.entradas;
       public         postgres    false    3            �            1259    33044    mesas    TABLE     N   CREATE TABLE public.mesas (
    mesa integer NOT NULL,
    disponible text
);
    DROP TABLE public.mesas;
       public         postgres    false    3            �            1259    32968    mesasferias    TABLE     g   CREATE TABLE public.mesasferias (
    usuariomacaddress text,
    mesa integer,
    minutos numeric
);
    DROP TABLE public.mesasferias;
       public         postgres    false    3            �            1259    33058    porcentaje_ventas_tlf    VIEW     �  CREATE VIEW public.porcentaje_ventas_tlf AS
 SELECT ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1
          WHERE (compras_1.comprasusuariomacaddress = 'None'::text)) * 100) / ( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1)) AS sintlf,
    ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1
          WHERE (compras_1.comprasusuariomacaddress <> 'None'::text)) * 100) / ( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1)) AS contlf
   FROM public.compras
  GROUP BY ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1
          WHERE (compras_1.comprasusuariomacaddress = 'None'::text)) * 100) / ( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1)), ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1
          WHERE (compras_1.comprasusuariomacaddress <> 'None'::text)) * 100) / ( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM public.compras compras_1));
 (   DROP VIEW public.porcentaje_ventas_tlf;
       public       postgres    false    198    3            �            1259    32974    tiendas    TABLE     J   CREATE TABLE public.tiendas (
    id integer NOT NULL,
    nombre text
);
    DROP TABLE public.tiendas;
       public         postgres    false    3            �            1259    32980    tiendas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tiendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.tiendas_id_seq;
       public       postgres    false    3    205            k           0    0    tiendas_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.tiendas_id_seq OWNED BY public.tiendas.id;
            public       postgres    false    206            �            1259    32982    tiendausuarios    TABLE     }   CREATE TABLE public.tiendausuarios (
    tiendaid integer,
    macaddress text,
    horaentrada text,
    horasalida text
);
 "   DROP TABLE public.tiendausuarios;
       public         postgres    false    3            �            1259    33063    top_usuarios_recientes    VIEW     �  CREATE VIEW public.top_usuarios_recientes AS
 SELECT entradas.macaddress,
    date_part('hour'::text, ((entradas.horasalida)::timestamp with time zone - (entradas.horaentrada)::timestamp with time zone)) AS dif
   FROM public.entradas
  WHERE (entradas.macaddress <> 'None'::text)
  ORDER BY (date_part('hour'::text, ((entradas.horasalida)::timestamp with time zone - (entradas.horaentrada)::timestamp with time zone))) DESC
 LIMIT 5;
 )   DROP VIEW public.top_usuarios_recientes;
       public       postgres    false    203    203    203    3            �            1259    16543    usuarios    TABLE     �   CREATE TABLE public.usuarios (
    id numeric NOT NULL,
    cedula numeric,
    edad numeric,
    sexo text,
    macaddress text
);
    DROP TABLE public.usuarios;
       public         postgres    false    3            �            1259    32988    usuarios_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.usuarios_id_seq;
       public       postgres    false    3    196            l           0    0    usuarios_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;
            public       postgres    false    208            �            1259    33038    ver_mesas_mas_tiempo_usado    VIEW     �   CREATE VIEW public.ver_mesas_mas_tiempo_usado AS
 SELECT mesasferias.usuariomacaddress,
    mesasferias.mesa,
    mesasferias.minutos
   FROM public.mesasferias
  ORDER BY mesasferias.minutos DESC
 LIMIT 5;
 -   DROP VIEW public.ver_mesas_mas_tiempo_usado;
       public       postgres    false    204    204    204    3            �            1259    33034    ver_tiendas_mas_items_vendidos    VIEW     �   CREATE VIEW public.ver_tiendas_mas_items_vendidos AS
 SELECT tiendas.nombre AS tienda,
    count(compras.id) AS ventastotales
   FROM (public.compras
     JOIN public.tiendas ON ((compras.comprastiendaid = tiendas.id)))
  GROUP BY tiendas.nombre;
 1   DROP VIEW public.ver_tiendas_mas_items_vendidos;
       public       postgres    false    205    198    198    205    3            �            1259    33030    ver_usuarios_mas_compras    VIEW     1  CREATE VIEW public.ver_usuarios_mas_compras AS
 SELECT count(compras.id) AS compras,
    compras.comprasusuariomacaddress AS usuario
   FROM public.compras
  WHERE (compras.comprasusuariomacaddress <> 'None'::text)
  GROUP BY compras.comprasusuariomacaddress
  ORDER BY (count(compras.id)) DESC
 LIMIT 5;
 +   DROP VIEW public.ver_usuarios_mas_compras;
       public       postgres    false    198    198    3            �
           2604    32990    accesos idacceso    DEFAULT     u   ALTER TABLE ONLY public.accesos ALTER COLUMN idacceso SET DEFAULT nextval('public.accesos_id_acceso_seq'::regclass);
 ?   ALTER TABLE public.accesos ALTER COLUMN idacceso DROP DEFAULT;
       public       postgres    false    200    199            �
           2604    32991 
   camaras id    DEFAULT     h   ALTER TABLE ONLY public.camaras ALTER COLUMN id SET DEFAULT nextval('public.camaras_id_seq'::regclass);
 9   ALTER TABLE public.camaras ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    201            �
           2604    32992 
   compras id    DEFAULT     h   ALTER TABLE ONLY public.compras ALTER COLUMN id SET DEFAULT nextval('public.compras_id_seq'::regclass);
 9   ALTER TABLE public.compras ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    197    198            �
           2604    32993 
   tiendas id    DEFAULT     h   ALTER TABLE ONLY public.tiendas ALTER COLUMN id SET DEFAULT nextval('public.tiendas_id_seq'::regclass);
 9   ALTER TABLE public.tiendas ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    206    205            �
           2604    32994    usuarios id    DEFAULT     j   ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);
 :   ALTER TABLE public.usuarios ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    208    196            U          0    32949    accesos 
   TABLE DATA               :   COPY public.accesos (idacceso, numerocamaras) FROM stdin;
    public       postgres    false    199   �^       W          0    32957    camaras 
   TABLE DATA               /   COPY public.camaras (id, accesoid) FROM stdin;
    public       postgres    false    201   �^       T          0    32930    compras 
   TABLE DATA               r   COPY public.compras (id, comprastiendaid, usuariocedula, itemmonto, itemid, comprasusuariomacaddress) FROM stdin;
    public       postgres    false    198   "_       Y          0    32962    entradas 
   TABLE DATA               d   COPY public.entradas (macaddress, horaentrada, horasalida, camaraentrada, camarasalida) FROM stdin;
    public       postgres    false    203   dj       _          0    33044    mesas 
   TABLE DATA               1   COPY public.mesas (mesa, disponible) FROM stdin;
    public       postgres    false    212   �p       Z          0    32968    mesasferias 
   TABLE DATA               G   COPY public.mesasferias (usuariomacaddress, mesa, minutos) FROM stdin;
    public       postgres    false    204   q       [          0    32974    tiendas 
   TABLE DATA               -   COPY public.tiendas (id, nombre) FROM stdin;
    public       postgres    false    205   �q       ]          0    32982    tiendausuarios 
   TABLE DATA               W   COPY public.tiendausuarios (tiendaid, macaddress, horaentrada, horasalida) FROM stdin;
    public       postgres    false    207   r       R          0    16543    usuarios 
   TABLE DATA               F   COPY public.usuarios (id, cedula, edad, sexo, macaddress) FROM stdin;
    public       postgres    false    196   �       m           0    0    accesos_id_acceso_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.accesos_id_acceso_seq', 1, false);
            public       postgres    false    200            n           0    0    camaras_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.camaras_id_seq', 1, false);
            public       postgres    false    202            o           0    0    compras_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.compras_id_seq', 201, true);
            public       postgres    false    197            p           0    0    tiendas_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.tiendas_id_seq', 1, false);
            public       postgres    false    206            q           0    0    usuarios_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.usuarios_id_seq', 279, true);
            public       postgres    false    208            �
           2606    32996    accesos accesos_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.accesos
    ADD CONSTRAINT accesos_pkey PRIMARY KEY (idacceso);
 >   ALTER TABLE ONLY public.accesos DROP CONSTRAINT accesos_pkey;
       public         postgres    false    199            �
           2606    32998    camaras camaras_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.camaras
    ADD CONSTRAINT camaras_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.camaras DROP CONSTRAINT camaras_pkey;
       public         postgres    false    201            �
           2606    32938    compras compras_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.compras
    ADD CONSTRAINT compras_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.compras DROP CONSTRAINT compras_pkey;
       public         postgres    false    198            �
           2606    33051    mesas mesas_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.mesas
    ADD CONSTRAINT mesas_pkey PRIMARY KEY (mesa);
 :   ALTER TABLE ONLY public.mesas DROP CONSTRAINT mesas_pkey;
       public         postgres    false    212            �
           2606    33000    tiendas tiendas_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.tiendas
    ADD CONSTRAINT tiendas_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.tiendas DROP CONSTRAINT tiendas_pkey;
       public         postgres    false    205            �
           2606    16550    usuarios usuarios_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public         postgres    false    196            �
           2620    33043    mesasferias disponible_mesa    TRIGGER     {   CREATE TRIGGER disponible_mesa AFTER INSERT ON public.mesasferias FOR EACH ROW EXECUTE PROCEDURE public.disponible_mesa();
 4   DROP TRIGGER disponible_mesa ON public.mesasferias;
       public       postgres    false    204    215            �
           2620    33013    tiendausuarios entrar_tienda    TRIGGER     {   CREATE TRIGGER entrar_tienda BEFORE INSERT ON public.tiendausuarios FOR EACH ROW EXECUTE PROCEDURE public.entrar_tienda();
 5   DROP TRIGGER entrar_tienda ON public.tiendausuarios;
       public       postgres    false    207    232            �
           2620    33001    usuarios registrar_usuario    TRIGGER     }   CREATE TRIGGER registrar_usuario BEFORE INSERT ON public.usuarios FOR EACH ROW EXECUTE PROCEDURE public.registrar_usuario();
 3   DROP TRIGGER registrar_usuario ON public.usuarios;
       public       postgres    false    196    229            �
           2620    33015    compras registrar_venta    TRIGGER     w   CREATE TRIGGER registrar_venta BEFORE INSERT ON public.compras FOR EACH ROW EXECUTE PROCEDURE public.realizar_venta();
 0   DROP TRIGGER registrar_venta ON public.compras;
       public       postgres    false    233    198            �
           2620    33053    entradas setear_mesa    TRIGGER     p   CREATE TRIGGER setear_mesa AFTER INSERT ON public.entradas FOR EACH ROW EXECUTE PROCEDURE public.setear_mesa();
 -   DROP TRIGGER setear_mesa ON public.entradas;
       public       postgres    false    203    216            �
           2606    33002    camaras acceso_id    FK CONSTRAINT     y   ALTER TABLE ONLY public.camaras
    ADD CONSTRAINT acceso_id FOREIGN KEY (accesoid) REFERENCES public.accesos(idacceso);
 ;   ALTER TABLE ONLY public.camaras DROP CONSTRAINT acceso_id;
       public       postgres    false    2757    201    199            �
           2606    33025    compras comprastiendaid    FK CONSTRAINT     �   ALTER TABLE ONLY public.compras
    ADD CONSTRAINT comprastiendaid FOREIGN KEY (comprastiendaid) REFERENCES public.tiendas(id);
 A   ALTER TABLE ONLY public.compras DROP CONSTRAINT comprastiendaid;
       public       postgres    false    2761    198    205            �
           2606    33007    tiendausuarios tienda_id    FK CONSTRAINT     z   ALTER TABLE ONLY public.tiendausuarios
    ADD CONSTRAINT tienda_id FOREIGN KEY (tiendaid) REFERENCES public.tiendas(id);
 B   ALTER TABLE ONLY public.tiendausuarios DROP CONSTRAINT tienda_id;
       public       postgres    false    207    2761    205            U      x�3�4�2bc ����� j      W   (   x�3�4�2bc 6�4�2b3 6�4� bK ����� h�      T   2  x�u�I�$�Dב�|����&�����wzƌ��B��F�P��p�`4��ֶRR�澹���a[��Ӫy���˞7��Vz�V<o=���^7k+�+�z��ʷ����M�z�W���R���a�e�[�����i��~o��nul=�+`��8-�m���>=��^�^���_������r�!��F�Qw����'�+�ی[�Rr͉����m�|�4����e�6���m�j���m+i��w��H�IΫ��U˺D�Z��W�Y��s����[):�N�Yy��r��Z5�Y�81�����5���V'�b�%2�'�?7<��JU��k��l�y�m#'�?����9��i{���S�N�|L��+�}�،<۬g�o/ȭ�mUY���<���H�>�/�,'0�n��Al)�Ϋz�<�ר��4���~�J(��Y{�L�n��a�Q`����	��ۦ�+���J���5�Ny�� 溜ľ�Ȟ�$䦄�8�819A �/��Ri���丘�B�ԟ=�Z8x摝*6Q��+y���m=��.>�=�Û�����|�X���^5�����0^�� ����[�2�lN��.yZz̽������O���*�@�G���T�ĥ�m�+�jO��H��l!0fPS'y��J}��(ه޳
��=��g��0uK����.g�6��]���K��@������-q����m�i�#%�)6y�<� ��Vn]�;�}�>�0J�6#�p�7N`�J�<ѿ���Ǯ��$0��6����*�+`�k<���?���m��J��BG�|{n�su�I���~�k���%�U�7���莥�+������!���q��kjQY$��At�e���2���O{���� �N�] E'���ȗ\$��@%r�������I���
>i-�}*��߸w� Ua�+��n�m�UG��o|��~_wJ�oV� ��q�\�B�q&����f�`Dl����]f�XP�������+�r�Y���DYx���B�r�Q'��\U�ϲ���n&�q�+<�O_ �J�s�����wV�n�+g>2�nR'Y}�
�c���T!��9�.�(�wL��_<xh�w_y�&�������O���T0b��FF�oM���e�G���P��%
�r41Vi�E��T$�k��8l����;�h�֝�#T|f�������$�v�T"�����*��j�5ϧ�T���z�u�7��>�=�>����l��PQ-Y�Д&�6?n.w;��mW@�xN(y���z�S��ZI�ǻ��w�����?˚ʞ���8m��KS��4t��!#�1Ă����S���0�)��è�,(�&�H�!ֆ��G�&�߾�O�����.�!�Ǩ����	���ǜS*��W�r��UG/h�"���%��w��e�e��1]?$�*��i�R�p"M�T!�U�(�u�\([�ޯ��F	0�a�A�kS��e��$7.1�ךd�ڽ�����S�$fH���ͫ3w��?Ƞ�a��?�C���k�آ4������椾?F&��ߍ#��s�t1�*k;�!IPAH$�z�DmH��*u=_�Eز�tKU�B�Q��/�p�ٚ��η6I�}��GNw�1�@k`�^E��T��t-k�׿VK�s	�-��n�V�lp��&:ʼ�����gz/c����P��' O� �n�Ge��`���l�)䓋tIu�s�3U�t�Gݕ�z��Bu#��P��Z�Q��5�v�%�ȁ�m���%R�\�F��02���n5Ƶ�-i��A����Y���$E.�AJ��u,�^j��Kث/�9r�8R��C�W�Դ��M�q��U[�c��;j�FnF&f5;rk��Wu�Ռ߆��#U�����F����W�(�n��"�m�2��B1����	U_�7�����12D\ԓk�>�3��:;�������,vc�FZ���p[+�Ƙb��$N�#Y��|�2|
g�Nǘj�s�ߔOk+uH�w�W#��K�;��z�|�f�J��RPz3����	#��E��8����z���o�J=�����O�J���cц��O&Jmot��4NE�N��5��},���'ӄR��]��O3�y���f��4���e���hQ�~^(�a�>d��q~���|�rXz�j��X�(z��V\����	�I�z	��V�M��n���
��/��L�� x"C�CїH妦:�g&���CT���b�`��C�{ IG�%1��1x�q�&�)a��Ov5jع?��8��#y
��j��kט���j/:�6�'��~ķ����Iw�Y�͉E�����Q({��Kߓ_����EC�|�fk�-���sHB��Ҭ���]�~�t���u=���H�i��|��j�B�#E��t�Ƥ�Lrx@�Ϙ��F-j��p\L���>=���k,���ihH8d7�2��/ݥ<���&J���*1��=�Q:�?lS_P��[��e�����bfC]��m�U��1�������ܞ��៫����|ͦaX��;Eb��^5J�R,���L�1����%�kȝ�zq���d�ќ�f�>���sy�@��YX���vvOɵ��>�c\��.5�`w��u�=�fҎ���X��f�U-kɍ��/`ԟ�����tXi��i�8���Z��I����*��Em_�A"�$���a��}��#	?il�����`",��L�7��&f��s
j�8�.	�
�6ܗbDhI��zӶ�������F܏o���ޚt8��p)����������5\#����ꩡ���Yc�J�-���-Eh�����v��5\?�      Y   z  x��X]��6|NN��!��D�{��8�yl��֡��2,��b����3���m���~D��1kX�W����n)��#�A��I�h�S)�%���Q�����X4���S��Е�)k,S�E8� Q��ߩhxh�4�J����i"�q��
7�V�b���,�D�t��a$������G(��=ghZ4/�V��-��$�Q&�@�V���Yy�9jkn-��a"i�M?� 	.�"a窛�A�|Z�n���Rj�t���G\�*mZg�\ݹ�LS�!����a�p��	��2�TT\㡴����T9T��j�p@�F�7@�VB~v�Q��G��gE��|�����[���o>�Ū!��D���� PS�cf�>�2@8����Tb��pw�X�����3Bk���jufa/v��hV�i�9��v����+���rĠ;벸 ��K�%�d��e5I2)�L('xD���J&Vf)no!����1�����p�|�p��Ό���µpB0�x��.���h+M�	J��U?�/�l
U�����ֲ1A��P��Ȥ��]=�&�tG�Z�Cյ �D_�0w�aW�뱾Sb��DYʹK��`�ū]Q ��445����U&�y��5�NH��ۗ�e]sւ5V_~8�SK�i^��d�"1�P���}+xv�L%pq�����+��ɺ�
�ZPZ�q��~Fѧ�<�S ��Y�;#�˪��ݰMIr!qe� ���꺣�|���o�����T��Q;���i�|���Lg�:���R�ŷnVX]���֔(���S�h��)Z�ڢ���.��B�:qL��e���+�ѐ�7ϠԴy5-�j���L �jM���}�k��ͷ���7v>���Y����֦�_|Iu�Q�%�Æ0@�р��y�-��r箟��@�ՙm�� M�L=cbj |���'�ވ3�2�#��}�V�J� �l~hK.�l䝘 Jޱ[ɿ�x5^��Uj3ih�߂ٽ:�,�z	k#�̛D�	��m��O�H%o��ի���1���j�d�q�3(Ȕ���"� ��ȗ���Vӑ��u��{[o%U��r��i��٠��Z��Y+h}/�,S	����d��pw�т�ev�!,N�����#/���=��� �����[ ��k�n���V���r���)o�/61'� ^�m6?�+Q��c��aZ
~�����Rk\�EP�j �܀¿#_֙���l�*��y�D�> �E�W��ZA��c�F�Ҝ�>� �{Z�G�f�
4,���;�<����\T�(������	NޯBݸ�Jt�_+�4@�+��ގ����Lc/S	�M�f(� Y��W6�q'�����;ńg�6�ل��.C�٪=g�͘^w��G��b���Ai�.��������'#�^��������o�2BH�j�2� �X�en�}Ġ�g,>�y�.�\��d�����ߤ�n�":3��r��l� }L��u7�S�!%O%!|��(��i�L%Y�`��E��v���1�"�T�d
c��9t
��G�|39��1��,��l_�_Z�t����q&|�Bb
)��]�ԯ?���4P�mG'9�ק�D��`�	�>�� L~��b�(J�i��}��ш��P1'}@�L�s���� c�t      _      x�3�,)*M�2�PF�BC�=... �O
�      Z   �   x�=�;�0k�.0�>���	hb;)��J�to<�ZKd�WH��dɕtw�/��'O����ڒ�[��|-=�:x,�0[ �/�\Y�N�Y��j���dz�x���<;�e���>��J.T«�^1v��)�x��� �-��b���Yt4�      [   6   x�3�J,J�2�tO�M.�/�2�tJM��2����N�2�tL�LI,����� '�      ]   l  x���I���E׬S���c:�}��p\�V���;��U�4�2�,�,YN>�d>�ǌa�6�1s�����?��G����g3���e�dj�)�O)�Xf�S�L��(����u�4�}�>��o-�Z�49��	�z�r���9�"�?�����m��c�M�|�����q�A�>�r����%0K9������r���|����������,��C�Q���ބ6����E�%�D�+�Tgj�벼~�Ʒ-�׋�m�"}�N�e��S��U�?-�Vp����c��0K��tj�"EL�%�[��z��+���o����ZUĒ�%����_�N���;<A�b���'�Y�7>S,m�f�Y#\B�e���~�e��5���M=�׭'��g[�a�2K���9=��$�$��:��:b)g]c����=Ē�%QK9����˯�ħ��np��2%�������쾋N���%S��k�&��e�vP�3hWU�d�+z�RVo:t�?��?S�hW�,W�+�o-��<�A��bzua�x���:�Ov�`񽿔9���������Kf8�s�KI��%I�U~���?�������)�̙Y}^�c�<}O�<�xzb��CT�񽸿Z�����.��iQQ�Қ����Lf����Ĝ�	�<�W�xz��μ3䨺�K;��K'r�Qb�_�zS=+<��W qx�(��b#��ۋ�Ē0r����$#$g�Ԫ3�����Է3^�x�%My���x��U�$ʫPo��-��mJ�L�����d��I�'��-%���3/���������x���O�z�_=��:�+��(�`��Oof[�0ť�*}� 2�:�2o�+�
0�x<�fʓ��tjĮ�_�]!�/�&��t�ץ��%�"з�<u�'�� <�x]NyK��T�Uh{�����ݶ��G�2��M'�X}^9�	��E�g��U���W��)��j#�#������B�0������,���m�\��t1�|E�F�H���-��\����a��g���/��S|����9ϳj���t�%���Nh�Eb�y�K�<l�K�v���a���l�Q�����Ww����'w$������i�z�tHz�����X�������ڌ'Oσ�y��ǳ�;�����3�3r��� �ﳝ�Φh1�yi%�����cV��=Ol�3^��Kx��UK3���x�נ�)��M����Eg���~�����ߡ�M.3?,DH3���w�Y6Ե���g�-��pދ�ԧk������8,�&$MuU)n�E�(�ybr��Ă!�+��+��6�����>�u�(����k"/�ʫ�~�4� H��y�&Q�q+E�s�`V�����e\|�l�����ʫ�{��<�zl2^�z�d�Z�U��x��E���k�3�Οë8�)�!�g<�r��~?�{�y��a�f���8��Km��#��ޚfa<;O<�>���x<�m��z4>�W��,!ǯ����a�C�;̇��u��ҖXK�N�(Q+�Ϟ�.R8�Z>����U�׎x���/�\��x5�i�5�a�Il"�:�{c�C��Rʪ�j���;��Sڋü���+SC�ٮ�n�9�P��>�p�p,�bs�C��y�0ދ�>a��{���A/�3�rۼ��ǩ-���K���'�z��ֳ�b����!���C��Y�
q��Y�����zPq9z�ǟNU�p�͞77�q�H�u�90+�7�*������âx�,%� �-d˔XQ����Ay���[<9�!eAy���Ly9�;j�xi�<f�2��6o�fT^ű�^jvr��o����%ƳV �s�gb��l0������w���:g;�u*�FȞ8D·B��ykL�x�#�����g���b�e�ׁ膜���T���� ��N�~׊�ߞW0��n1ƋOy�E�x��Y2���c�5����n�[�j�HW�,)�ؼTlcֵ�噷n#Ƴ��ǓC����_5=�xՔ3�E���U�kG�����X�C�D�K����-�
ź�Y*���i(o4Vd�U�h�M��	a��[l�Yѧ��e+S0^9����H��Y�[�n�{�2dx	�����J=�(֝��CG�Ns�߬����`b��h����2^ۺ\�;������2�ϋ�o}>ol�(./�t_bEw�;�w˺��\z�5:z�ߊ��=�Z]����/���8�Y�I���k��&�0R��e��>�4ɪf�zF�V����O���=O�V)��������t���w����m;HT�K-=95�5V��m{^�����U�\^�y�s^C��[���s^�D�M���Z����7"K��e�F3��;{�ջ)�Z���3�xk*���7��-�Dy�e����:�K��d�8����(TӃ�X@K�P��ReZ�ӵb-�y&�)�v"��gi7ʫ�/@x��V�By�N�'�d�|������엋]/F_/%�����p��{l��G�RMR��޾9i����mT�D���-ƁJj���eJK_jhy8
.·n��W��(o�	��X��x&/{�����L2^�xͺo-n��U�y���a]��X����B���XQ��,1Cy�����C�'�AGQ^>YպQ��ڭեd1|���N&[B�X�0�*0���mV���@��%�������;;�����_�u�nk�!�b�Ɛ�d��0+�{���xk�E�W筂���������[+��׎���#<��A#|ԙ�<�y�și��C����k��Y}�luk�WM�^�x��׎�'���Ⱥ�tJW��4���
v��f�^,=ƴ��V1'���A��ts�e��֍�.Ǹ����¬�����s��La3�;��i��~`E���p��7������C�,��}1�r�o�x�D�~���j��-�1�����VTk�<�o�W����ǳ���L�0ދE�#������=�L�ZPA�b����X�oEBzϳ.n�[�"�bq�0!2Л�?��i4';	U�Bp�[^�g��P����Ϝ1�Y��YU���z��Q� �?y�D}�xu���k�s��S>�W�����R�X���~�~�-�Pz���G��LRu����t�ĊjОg�ϔg��E�'#��=�7��2,�5{`��Y�By�V�x���\�.U�*���F�R��t�:կP���=om��<Ģ��,�Byk,@x�?d��Z�|\�`���C\��??1��'��c=@��2��OuB[B�X�3��|�G���:ƫ�	����S�	���fg���'#��L�SF(�c?x�=��E���a���!��=���}�{޺�O,�@x���k��,��x����f��{)�����ٞ�Og��/�Y;��5h�����1�d��u{��gY��ۓ�.���S�,�+Ϻ�)O�������\~���`M�<      R   �
  x�m�M�$���Y�1$R?����	ަ~������u{:�����L'3%����&oֽ�dm��_�ZX�(??�����c+f�G����������?����ׯ祏�S��k���|��L��t�w��/�63b�[ϻP�3��yZ������ �Z�6������D\�i̛�G���yIm�h[+��u+������ߟ�~���2f*�����fy]F�J��8�f�'��3������"oIA��;���ݹl��Ǵ�,��KNi˭�V{�l��V��4k��2_Al�r*�{Z�����^3_g˳?g���[����)CybD�׼W"�j�())o���f"�z{��$�l9@��~B�8K��Y�|h��z�ԩ�+�L�id��W�/�<����A`Ȁ�Y��K�d��0϶�;����`(���F�����h���V��9u$������\�Q�<Jl��Cho��V��]��4ʴ�}w��Li�mV_�V���%r�.߯3�p�J*Y"��V�	�p�Ӟ����J��OIF�5�꿟���k9���R  ӛ��@�~J^;�hӁ&hS�A�\�����׾G���E�]�D(�/ѭ)�~�_w���]�S:fnJ �}��Ī1)���u�1�B��c��3�~+�����p��x�a���
Q�Xs`��\�Vw'5x�Tl^���p�����=m�%�����d��C�ݷuP���_^�y�O:����(pP��u����]̻�#��T<ԣ�B(p�K�||@;M�5Yj����᱕Zk� �웁l@��VD*W������8?�{)}pV�[�6��ع���,��0q��qy�Tu:�:�^!�5
\%|?]��beqȻ�B�������]����L+U��ޫ���!��{$vX����+|�$�(+�AM��̞�͏(x�. �������� �J����-�#hi���6{���J�;�B�Z�m�,TܛGb��=��т��j~��C�zZ�sb!�&�HqP��/A(�	�����i!	�����&��T���=O5�O~�U �� ��P\ŝqZF��fK�M�Ii,%O��"V|> ��:��E���]��l� /�����D�_k�u�뼂S&�#��������9보�i�s������O(T+@>g�j�W��("h��S�`lcլ��)�,���`�ަs춈>�';����D6�F�Sھ�sҌ��Pw���s$h�d�2TR 6��АN�����1}Zz�t���os�����}w�XL�[�;���Ͱ��N�y��}]D_dG��ػ���G	˙�qMF:�C�������8:��Ǎ/����,^�h��ȄB�ꛪwΤ�er�Ou��j�֡S���*(5O�?�Å:d�c�H��S���Fi{$�}X�Yq{PA��bIک+�,CwH^?x���O^"�_���Q���G<*4؋S&Y�]#&���� Q%�L�IĠZ'���)��sH�����_&a������񧨭��}.�Xy-־T�k8�#4�0�(��#�ij�s�k�4�470�AI�����2��[|9��㺶����#�R�ֈ�B]��a�pu�'��IlR�Z�n���l~��2(!j,V���S�I�z�(��i��������l�ր�C'��:��E�c��!=zi�"��1n��we`�nu9��4��!��G��#�ǼS�D(_�5��C��pd>���]l�g��V�g�&�"����x��	%��E Es���b>"۝w����c��CU�@�&�<*2c.G�����4.��{��"� �z���\FB���'3�(�ˊѰ�rԿw8Ʋ��k�`*�YjH:!�5��6��,{��Ja�`����JE�	3�9YNv�$+��gT�6�o�ƶ�ɧ���w"l2	�0KS*\�i�l�Z@{�^|e*�]���J(:���J>�T�&�M*�-!E���,��T^�m4y�s5LS¨�8ϡc��h�ټ��0b������IC�`ͬjĝ�)Mg�߁z��+�1yA�
�A�&��8s &:����?O�gډ
Gh��p:�K����ǈ�#�P�����H�3�O���@��?x��)6>1W���z�6X`��-�p� ��F�zN�k w_F����Ũ���2�1_�欄��������cJ�C�1?�(j��h�i[�uЫ��cQ r�CK�_t#�-uԲ�~e��fc����`]�-$�0蚠�_u�3&�օ��úa��&� ��XK��w��k�Pv�:�c]%��w��Xk�
$> G��H�yv�Ӏ��ob!����qP&P�B��� db�stu�x�;I�R@^;c�Ըͮn�w�H���e^}�ˑ�p�=���5~�2��J%2��{�E�o� )��pN���n	��H���m?��2D��2731�jx*\�)���G[��g�k�L�P��K>"Q\FC�o����,}*˺n:!�R��%��t�/���8�0h���@�A���}Ꞓ�,���rc\-�:�z�]��_��2ꂡ�4��]�I�������y��Q�rM)�f?u�2юa\W�?��.�O�1w6�t�N��ma��3���ޓ
k2���.d^^����u��i`@W%DeE��i�#*����wH�IȁsӺ���+��"�U�$��P��%�{1�Y�5�eM��Z��.�NU���\/�ӝ}��<E���N/���2�7��s6e	�'��j}7U��r����~q     