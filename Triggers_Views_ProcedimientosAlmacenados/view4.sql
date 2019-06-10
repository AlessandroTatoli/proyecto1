-- View: public.ver_tiendas_mas_items_vendidos

-- DROP VIEW public.ver_tiendas_mas_items_vendidos;

CREATE OR REPLACE VIEW public.ver_tiendas_mas_items_vendidos AS
 SELECT tiendas.nombre AS tienda,
    count(compras.id) AS ventastotales
   FROM compras
     JOIN tiendas ON compras.comprastiendaid = tiendas.id
  GROUP BY tiendas.nombre;

ALTER TABLE public.ver_tiendas_mas_items_vendidos
    OWNER TO postgres;

