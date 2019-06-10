-- FUNCTION: public.disponible_mesa()

-- DROP FUNCTION public.disponible_mesa();

CREATE FUNCTION public.disponible_mesa()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$

BEGIN

UPDATE mesas
SET disponible = 'false'
WHERE mesa = new.mesa;

RETURN NEW;

END 
$BODY$;

ALTER FUNCTION public.disponible_mesa()
    OWNER TO postgres;
