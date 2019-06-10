-- Trigger: entrar_tienda

-- DROP TRIGGER entrar_tienda ON public.tiendausuarios;

CREATE TRIGGER entrar_tienda
    BEFORE INSERT
    ON public.tiendausuarios
    FOR EACH ROW
    EXECUTE PROCEDURE public.entrar_tienda();