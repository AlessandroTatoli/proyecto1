-- View: public.top_usuarios_recientes

-- DROP VIEW public.top_usuarios_recientes;

CREATE OR REPLACE VIEW public.top_usuarios_recientes AS
 SELECT entradas.macaddress,
    date_part('hour'::text, entradas.horasalida::timestamp with time zone - entradas.horaentrada::timestamp with time zone) AS dif
   FROM entradas
  WHERE entradas.macaddress <> 'None'::text
  ORDER BY (date_part('hour'::text, entradas.horasalida::timestamp with time zone - entradas.horaentrada::timestamp with time zone)) DESC
 LIMIT 5;

ALTER TABLE public.top_usuarios_recientes
    OWNER TO postgres;

