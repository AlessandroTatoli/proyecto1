-- FUNCTION: public.registrar_venta(integer, text, integer, numeric)

-- DROP FUNCTION public.registrar_venta(integer, text, integer, numeric);

CREATE OR REPLACE FUNCTION public.registrar_venta(
	tiendaid integer,
	compramacaddress text,
	comprasid integer,
	itemmonto numeric)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
mac text;
horaEntrada text;

BEGIN

IF compramacaddress <> 'None' THEN
horaEntrada := (SELECT entradas.horaentrada FROM entradas WHERE entradas.macaddress = compramacaddress);
END IF;
RETURN horaEntrada;

END 
$BODY$;

ALTER FUNCTION public.registrar_venta(integer, text, integer, numeric)
    OWNER TO postgres;
