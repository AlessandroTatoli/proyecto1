-- Trigger: registrar_usuario

-- DROP TRIGGER registrar_usuario ON public.usuarios;

CREATE TRIGGER registrar_usuario
    BEFORE INSERT
    ON public.usuarios
    FOR EACH ROW
    EXECUTE PROCEDURE public.registrar_usuario();