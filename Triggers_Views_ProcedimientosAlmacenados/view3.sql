-- View: public.ver_mesas_mas_tiempo_usado

-- DROP VIEW public.ver_mesas_mas_tiempo_usado;

CREATE OR REPLACE VIEW public.ver_mesas_mas_tiempo_usado AS
 SELECT mesasferias.usuariomacaddress,
    mesasferias.mesa,
    mesasferias.minutos
   FROM mesasferias
  ORDER BY mesasferias.minutos DESC
 LIMIT 5;

ALTER TABLE public.ver_mesas_mas_tiempo_usado
    OWNER TO postgres;

