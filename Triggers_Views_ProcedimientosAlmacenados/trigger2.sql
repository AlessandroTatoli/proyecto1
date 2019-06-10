-- Trigger: setear_mesa

-- DROP TRIGGER setear_mesa ON public.entradas;

CREATE TRIGGER setear_mesa
    AFTER INSERT
    ON public.entradas
    FOR EACH ROW
    EXECUTE PROCEDURE public.setear_mesa();