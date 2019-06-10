-- FUNCTION: public.ver_ventas()

-- DROP FUNCTION public.ver_ventas();

CREATE OR REPLACE FUNCTION public.ver_ventas(
	)
    RETURNS TABLE(nombre text, ventas numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN

RETURN QUERY SELECT tiendas.nombre AS Tienda, SUM(compras.itemmonto) AS GananciasTotales 
FROM compras 
INNER JOIN tiendas
ON compras.comprastiendaid = tiendas.id
GROUP BY tiendas.nombre;

END
$BODY$;

ALTER FUNCTION public.ver_ventas()
    OWNER TO postgres;
