-- Trigger: registrar_venta

-- DROP TRIGGER registrar_venta ON public.compras;

CREATE TRIGGER registrar_venta
    BEFORE INSERT
    ON public.compras
    FOR EACH ROW
    EXECUTE PROCEDURE public.realizar_venta();