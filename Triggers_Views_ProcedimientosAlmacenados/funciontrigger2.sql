-- FUNCTION: public.entrar_tienda()

-- DROP FUNCTION public.entrar_tienda();

CREATE FUNCTION public.entrar_tienda()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$

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
$BODY$;

ALTER FUNCTION public.entrar_tienda()
    OWNER TO postgres;
