-- 1
CREATE VIEW AS TopJuegosEvaluadosPorRating
SELECT TOP 100
    v.Id,
    v.Nombre AS 'Nombre del videojuego',
    (SELECT  STRING_AGG(p.Nombre, ', ')
     FROM dbo.Videojuego_Plataforma vp
     INNER JOIN dbo.Plataforma p ON p.Id = vp.Plataforma_Id
     WHERE vp.Videojuego_Id = v.Id) AS 'Plataformas',
    v.Calificacion_general AS 'Rating general',
    (SELECT STRING_AGG(g.Tipo, ', ')
     FROM dbo.Videojuego_Genero vg
     INNER JOIN dbo.Genero g ON g.Id = vg.Genero_Id
     WHERE vg.Videojuego_Id = v.Id) AS 'Generos'
FROM dbo.Videojuego v
ORDER BY v.Calificacion_general desc

-- 2
CREATE PROCEDURE BuscarJuegoPorNombre
    @Nombre VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    IF len(@Nombre) < 4
        BEGIN
            SELECT 'El nombre debe tener mas de 4 caracteres' AS 'Error';
            RETURN;
        END 
    
    SELECT
        v.Nombre AS 'Nombre del videojuego',
        v.Descripcion AS 'Descripcion',
        v.Fecha_lanzamiento_general AS 'Fecha de lanzamiento',
        v.Calificacion_general AS 'Rating general'
    FROM dbo.Videojuego v
    WHERE v.Nombre LIKE '%' + @Nombre + '%';
END

-- 3
CREATE PROCEDURE ObtenerInformacionJuegoAgruparPorPlataforma
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
    v.Id,
    v.Nombre AS 'Nombre del videojuego',
    v.Descripcion AS 'Descripcion',
    v.Fecha_lanzamiento_general AS 'Fecha de lanzamiento',
    v.Calificacion_general AS 'Rating general',
    v.Historia AS 'Historia',
    p.Nombre AS 'Nombre de la Plataforma'
    FROM
        dbo.Videojuego v
    INNER JOIN
        dbo.Videojuego_Plataforma vp ON v.ID = vp.Videojuego_Id
    INNER JOIN
        dbo.Plataforma p ON vp.Plataforma_Id = p.ID
    WHERE
        v.Nombre LIKE '%' + (SELECT v.Nombre FROM dbo.Videojuego v WHERE v.Id = @Id) + '%';
END