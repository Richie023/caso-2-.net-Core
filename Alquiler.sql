-- Crear la base de datos
CREATE DATABASE CasoEstudioSM;
GO

-- Seleccionar la base de datos
USE CasoEstudioSM;
GO

-- Crear la tabla CasasSistema
CREATE TABLE CasasSistema (
    IdCasa BIGINT IDENTITY(1,1) PRIMARY KEY, -- Clave primaria auto-incremental
    DescripcionCasa VARCHAR(30) NOT NULL, -- Descripción de la casa, no acepta valores nulos
    PrecioCasa DECIMAL(10,2) NOT NULL, -- Precio mensual de la casa, no acepta valores nulos
    UsuarioAlquiler VARCHAR(30) NULL, -- Usuario que alquila la casa, acepta valores nulos
    FechaAlquiler DATETIME NULL -- Fecha del alquiler, acepta valores nulos
);
GO
INSERT INTO [dbo].[CasasSistema] ([DescripcionCasa],[PrecioCasa],[UsuarioAlquiler],[FechaAlquiler])
VALUES ('Casa en San José',190000,null,null)
INSERT INTO [dbo].[CasasSistema] ([DescripcionCasa],[PrecioCasa],[UsuarioAlquiler],[FechaAlquiler])
VALUES ('Casa en Alajuela',145000,null,null)
INSERT INTO [dbo].[CasasSistema] ([DescripcionCasa],[PrecioCasa],[UsuarioAlquiler],[FechaAlquiler])
VALUES ('Casa en Cartago',115000,null,null)
INSERT INTO [dbo].[CasasSistema] ([DescripcionCasa],[PrecioCasa],[UsuarioAlquiler],[FechaAlquiler])
VALUES ('Casa en Heredia',122000,null,null)
INSERT INTO [dbo].[CasasSistema] ([DescripcionCasa],[PrecioCasa],[UsuarioAlquiler],[FechaAlquiler])
VALUES ('Casa en Guanacaste',105000,null,null)
 -- Este último registro está fuera del rango solicitado, pero puede ser útil para pruebas.
GO


-- Procedimiento para consultar casas
CREATE PROCEDURE ConsultarCasas
AS
BEGIN
    SELECT 
        IdCasa,
        DescripcionCasa,
        PrecioCasa,
        UsuarioAlquiler AS Usuario, 
        CASE 
            WHEN UsuarioAlquiler IS NULL THEN 'Disponible' 
            ELSE 'Reservada' 
        END AS Estado,
        FechaAlquiler
    FROM 
        CasasSistema
    WHERE 
        PrecioCasa BETWEEN 115000 AND 180000
    ORDER BY 
        CASE WHEN UsuarioAlquiler IS NULL THEN 0 ELSE 1 END, -- Primero las casas disponibles
        DescripcionCasa; 
END;
GO

-- Procedimiento para alquilar una casa
CREATE PROCEDURE AlquilarCasa
    @IdCasa BIGINT,
    @UsuarioAlquiler VARCHAR(30)
AS
BEGIN
    -- Verificar si la casa está disponible
    IF EXISTS (SELECT 1 FROM CasasSistema WHERE IdCasa = @IdCasa AND UsuarioAlquiler IS NULL)
    BEGIN
        -- Actualizar la casa con el usuario y la fecha de alquiler
        UPDATE CasasSistema
        SET 
            UsuarioAlquiler = @UsuarioAlquiler,
            FechaAlquiler = GETDATE() -- Usa la fecha actual del sistema
        WHERE 
            IdCasa = @IdCasa;
        
        PRINT 'Casa alquilada exitosamente.';
    END
    ELSE
    BEGIN
        PRINT 'Error: La casa seleccionada no está disponible para alquilar.';
    END
END;
GO

-- Eliminar el procedimiento existente si es necesario
DROP PROCEDURE IF EXISTS ConsultarCasasDisponibles;
GO

-- Crear el procedimiento para consultar casas disponibles
CREATE PROCEDURE ConsultarCasasDisponibles
AS
BEGIN
    SELECT 
        IdCasa,
        DescripcionCasa,
        PrecioCasa
    FROM 
        CasasSistema
    WHERE 
        UsuarioAlquiler IS NULL;
END;
GO
