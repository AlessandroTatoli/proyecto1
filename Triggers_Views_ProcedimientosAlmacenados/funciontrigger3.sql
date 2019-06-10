funciontrigger1-- FUNCTION: public.realizar_venta()

-- DROP FUNCTION public.realizar_venta();

CREATE FUNCTION public.realizar_venta()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$

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
$BODY$;

ALTER FUNCTION public.realizar_venta()
    OWNER TO postgres;
