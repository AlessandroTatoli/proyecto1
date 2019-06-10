-- View: public.porcentaje_ventas_tlf

-- DROP VIEW public.porcentaje_ventas_tlf;

CREATE OR REPLACE VIEW public.porcentaje_ventas_tlf AS
 SELECT (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1
          WHERE compras_1.comprasusuariomacaddress = 'None'::text)) * 100 / (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1)) AS sintlf,
    (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1
          WHERE compras_1.comprasusuariomacaddress <> 'None'::text)) * 100 / (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1)) AS contlf
   FROM compras
  GROUP BY ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1
          WHERE compras_1.comprasusuariomacaddress = 'None'::text)) * 100 / (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1))), ((( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1
          WHERE compras_1.comprasusuariomacaddress <> 'None'::text)) * 100 / (( SELECT count(compras_1.comprasusuariomacaddress) AS count
           FROM compras compras_1)));

ALTER TABLE public.porcentaje_ventas_tlf
    OWNER TO postgres;

