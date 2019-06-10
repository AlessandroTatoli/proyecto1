-- FUNCTION: public.ver_entradas()

-- DROP FUNCTION public.ver_entradas();

CREATE OR REPLACE FUNCTION public.ver_entradas(
	)
    RETURNS TABLE(acceso integer, entradas bigint) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

BEGIN

RETURN QUERY SELECT accesos.idacceso AS Acceso, COUNT(entradas.horaentrada) AS EntradasTotales 
FROM entradas 
INNER JOIN camaras 
ON entradas.camaraentrada = camaras.id 
INNER JOIN accesos 
ON camaras.accesoid = accesos.idacceso
GROUP BY Acceso;

END
$BODY$;

ALTER FUNCTION public.ver_entradas()
    OWNER TO postgres;
