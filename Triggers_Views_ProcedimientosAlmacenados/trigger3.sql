-- Trigger: disponible_mesa

-- DROP TRIGGER disponible_mesa ON public.mesasferias;

CREATE TRIGGER disponible_mesa
    AFTER INSERT
    ON public.mesasferias
    FOR EACH ROW
    EXECUTE PROCEDURE public.disponible_mesa();