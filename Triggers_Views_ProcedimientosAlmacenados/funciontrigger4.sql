-- FUNCTION: public.registrar_usuario()

-- DROP FUNCTION public.registrar_usuario();

CREATE FUNCTION public.registrar_usuario()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$DECLARE
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
$BODY$;

ALTER FUNCTION public.registrar_usuario()
    OWNER TO postgres;
