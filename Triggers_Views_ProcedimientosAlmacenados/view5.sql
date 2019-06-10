-- View: public.ver_usuarios_mas_compras

-- DROP VIEW public.ver_usuarios_mas_compras;

CREATE OR REPLACE VIEW public.ver_usuarios_mas_compras AS
 SELECT count(compras.id) AS compras,
    compras.comprasusuariomacaddress AS usuario
   FROM compras
  WHERE compras.comprasusuariomacaddress <> 'None'::text
  GROUP BY compras.comprasusuariomacaddress
  ORDER BY (count(compras.id)) DESC
 LIMIT 5;

ALTER TABLE public.ver_usuarios_mas_compras
    OWNER TO postgres;

