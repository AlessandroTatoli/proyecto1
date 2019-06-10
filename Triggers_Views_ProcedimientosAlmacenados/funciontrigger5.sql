funciontrigger1-- FUNCTION: public.setear_mesa()

-- DROP FUNCTION public.setear_mesa();

CREATE FUNCTION public.setear_mesa()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$

BEGIN

UPDATE mesas
SET disponible = 'true';

RETURN NEW;

END 
$BODY$;

ALTER FUNCTION public.setear_mesa()
    OWNER TO postgres;
