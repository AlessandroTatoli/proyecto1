-- FUNCTION: public.ver_salidas()

-- DROP FUNCTION public.ver_salidas();

CREATE OR REPLACE FUNCTION public.ver_salidas(
	)
    RETURNS TABLE(acceso integer, salidas bigint) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

BEGIN

RETURN QUERY SELECT accesos.idacceso AS Acceso, COUNT(entradas.horasalida) AS SalidasTotales 
FROM entradas 
INNER JOIN camaras 
ON entradas.camarasalida = camaras.id 
INNER JOIN accesos 
ON camaras.accesoid = accesos.idacceso
GROUP BY Acceso;

END
$BODY$;

ALTER FUNCTION public.ver_salidas()
    OWNER TO postgres;
