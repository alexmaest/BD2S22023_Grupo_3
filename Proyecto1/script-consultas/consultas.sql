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
        MAX(v.Fecha_lanzamiento_general) AS 'Fecha de lanzamiento',
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
        v.Nombre LIKE '%' + (SELECT v.Nombre FROM dbo.Videojuego v WHERE v.Id = @Id) + '%'
    GROUP BY
        v.Id,
        v.Nombre,
        v.Descripcion,
        v.Calificacion_general,
        v.Historia,
        p.Nombre
END

-- 4
CREATE VIEW TopVideojuegosPorIdioma AS
	WITH TopVideojuegos AS (
    SELECT TOP 100
        vj.Id AS VideojuegoId,
        vj.Nombre AS NombreVideojuego,
        ISNULL(p.Nombre, '') AS Plataforma,
        vj.Calificacion_general AS Rating,
        COUNT(DISTINCT idi.Id) AS TotalIdiomasSoportados,
		COALESCE((
            SELECT STRING_AGG(Idiomas.Nombre, ', ')
            FROM Videojuego_Idioma vidioma
            INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
            INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
            WHERE vidioma.Videojuego_Id = vj.Id
            AND ts.Tipo = 'Audio'
        ), '') AS IdiomasAudio,
		COALESCE((
            SELECT STRING_AGG(Idiomas.Nombre, ', ')
            FROM Videojuego_Idioma vidioma
            INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
            INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
            WHERE vidioma.Videojuego_Id = vj.Id
            AND ts.Tipo = 'Subtitles'
        ), '') AS IdiomasSubtitulos,
		COALESCE((
            SELECT STRING_AGG(Idiomas.Nombre, ', ')
            FROM Videojuego_Idioma vidioma
            INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
            INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
            WHERE vidioma.Videojuego_Id = vj.Id
            AND ts.Tipo = 'Interface'
        ), '') AS IdiomasInterfaz,
		(
        SELECT COUNT(*) -- Contar todos los idiomas sin DISTINCT
        FROM (
            SELECT vji.Idioma_Id
            FROM Videojuego_Idioma vji
            INNER JOIN Tipo_Soporte ts ON vji.Tipo_Soporte_Id = ts.Id
            WHERE ts.Tipo IN ('Audio', 'Interface', 'Subtitles')
                AND vji.Videojuego_Id = vj.Id
        ) AS TodosLosIdiomas
    ) AS TotalIdiomasEnUso
    FROM
        Videojuego vj
    LEFT JOIN
        Videojuego_Idioma vji ON vj.Id = vji.Videojuego_Id
    LEFT JOIN
        Idioma idi ON vji.Idioma_Id = idi.Id
    LEFT JOIN
        Videojuego_Plataforma vjp ON vj.Id = vjp.Videojuego_Id
    LEFT JOIN
        Plataforma p ON vjp.Plataforma_Id = p.Id
    GROUP BY
        vj.Id, vj.Nombre, p.Nombre, vj.Calificacion_general
    ORDER BY
        TotalIdiomasSoportados DESC,
		TotalIdiomasEnUso DESC,
		Rating DESC
)
SELECT
    VideojuegoId,
    NombreVideojuego,
    Plataforma,
    TotalIdiomasSoportados,
	TotalIdiomasEnUso,
	Rating,
	IdiomasAudio,
	IdiomasSubtitulos,
	IdiomasInterfaz
FROM
    TopVideojuegos;
GO

-- 5
WITH TopJuegosPorGenero AS (
    SELECT
        vj.Id AS VideojuegoId,
        vj.Nombre AS NombreVideojuego,
        g.Tipo AS Genero,
        vj.Calificacion_general AS Rating,
		COALESCE((
			SELECT STRING_AGG(pf.Nombre, ',')
			FROM (
				SELECT DISTINCT pf.Nombre
				FROM Videojuego_Plataforma vpf
				LEFT JOIN Plataforma pf ON vpf.Plataforma_Id = pf.Id
				WHERE vpf.Videojuego_Id = vj.Id
			) AS pf
		), '') AS Plataformas
    FROM
        Videojuego vj
    INNER JOIN
        Videojuego_Genero vjg ON vj.Id = vjg.Videojuego_Id
    INNER JOIN
        Genero g ON vjg.Genero_Id = g.Id
    GROUP BY
        vj.Id, vj.Nombre, g.Tipo, vj.Calificacion_general
)
SELECT
    VideojuegoId,
    NombreVideojuego,
    Genero,
    Rating,
	Plataformas
FROM
    TopJuegosPorGenero
ORDER BY
    Genero,
    Rating DESC;

-- PROCEDIMIENTO ALMACENADO PRINCIPAL
CREATE PROCEDURE ObtenerInformacionJuego
    @idONombre NVARCHAR(200)  -- Puede ser un ID o un nombre
AS
BEGIN
    DECLARE @idJuego INT
    -- Verificar si @idONombre es un número (ID) o una cadena (nombre)
    IF ISNUMERIC(@idONombre) = 1
    BEGIN
        SET @idJuego = CAST(@idONombre AS INT)
    END
    ELSE
    BEGIN
        -- Si no es un número, asumir que es un nombre y buscar el ID
        SELECT @idJuego = Id FROM Videojuego WHERE Nombre = @idONombre;
    END

    IF @idJuego IS NOT NULL
    BEGIN
        -- Obtener información del juego
        SELECT v.id AS 'IGDB ID',
			ISNULL(v.Nombre, '') AS 'Nombre del Juego',
			ISNULL(v.Descripcion, '') AS 'Descripción',
			ISNULL(CONVERT(NVARCHAR(10), v.Fecha_lanzamiento_general), '') AS 'Fecha de Lanzamiento',
			ISNULL(v.Historia, '') AS 'Historia',
			CASE WHEN v.Calificacion_general IS NULL THEN '' ELSE CAST(v.Calificacion_general AS NVARCHAR(10)) END AS 'Calificación General',
			CASE WHEN v.Calificacion_profesional IS NULL THEN '' ELSE CAST(v.Calificacion_profesional AS NVARCHAR(10)) END AS 'Calificación Profesional',
			CASE WHEN v.Member_ratings IS NULL THEN '' ELSE CAST(v.Member_ratings AS NVARCHAR(10)) END AS 'Member Ratings',
			ISNULL(CASE WHEN v.Critic_ratings IS NULL THEN '' ELSE CAST(v.Critic_ratings AS NVARCHAR(10)) END, '') AS 'Critic Ratings',
			(ISNULL(v.Member_ratings, 0) + ISNULL(v.Critic_ratings, 0)) AS 'Total Ratings',
            ISNULL(t.Nombre, '') AS 'Tipo de Juego',
			ISNULL(s.Nombre, '') AS 'Serie del Juego',
			ISNULL(f.Nombre, '') AS 'Franquicia del Juego',

			COALESCE((
				SELECT STRING_AGG(gen.Tipo, ',')
				FROM Videojuego_Genero vgen
				LEFT JOIN Genero gen ON vgen.Genero_Id = gen.Id
				WHERE vgen.Videojuego_Id = v.Id
			), '') AS 'Generos', -- toma la primera expresion no nulla de la lista

			COALESCE((
				SELECT STRING_AGG(emp.Nombre, ',')
				FROM Videojuego_Empresa vemp
				LEFT JOIN Empresa emp ON vemp.Empresa_Id = emp.Id
				WHERE vemp.Videojuego_Id = v.Id
			), '') AS 'Empresas',

			COALESCE((
				SELECT STRING_AGG(pf.Nombre, ',')
				FROM (
					SELECT DISTINCT Nombre
					FROM Videojuego_Plataforma vpf
					LEFT JOIN Plataforma pf ON vpf.Plataforma_Id = pf.Id
					WHERE vpf.Videojuego_Id = v.Id
				) AS pf
			), '') AS 'Plataformas',


			COALESCE((
				SELECT STRING_AGG(mj.Tipo, ',')
				FROM Videojuego_ModoJuego vmj
				LEFT JOIN ModoJuego mj ON vmj.ModoJuego_Id = mj.Id
				WHERE vmj.Videojuego_Id = v.Id
			), '') AS 'Modo de juego',

			COALESCE((
				SELECT STRING_AGG(tm.Tipo, ', ')
				FROM Videojuego_Tema vtm
				LEFT JOIN Tema tm ON vtm.Tema_Id = tm.Id
				WHERE vtm.Videojuego_Id = v.Id
			), '') AS 'Tema',

			COALESCE((
				SELECT STRING_AGG(ce.Tipo, ', ')
				FROM Videojuego_CatEdad vce
				LEFT JOIN Categoria_Edad ce ON vce.Categoria_Edad_Id = ce.Id
				WHERE vce.Videojuego_Id = v.Id
			), '') AS 'Categoría de Edad',

			COALESCE((
				SELECT STRING_AGG(mt.Nombre, ', ')
				FROM Videojuego_Motor vm
				LEFT JOIN Motor mt ON vm.Motor_Id = mt.Id
				WHERE vm.Videojuego_Id = v.Id
			), '') AS 'Motor',

			COALESCE((
				SELECT STRING_AGG(prs.Tipo, ', ')
				FROM Videojuego_Perspectiva vprs
				LEFT JOIN Perspectiva prs ON vprs.Perspectiva_Id = prs.Id
				WHERE vprs.Videojuego_Id = v.Id
			), '') AS 'Perspectiva Jugador',

			COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Audio'
            ), '') AS 'Idiomas de Audio',

            COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Subtitles'
            ), '') AS 'Idiomas de Subtítulos',

            COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Interface'
            ), '') AS 'Idiomas de Interfaz'



        FROM Videojuego v
        LEFT JOIN Tipo t ON v.Tipo_Id = t.Id
        LEFT JOIN Serie s ON v.Serie_Id = s.Id
        LEFT JOIN Franquicia f ON v.Franquicia_Id = f.Id
        
		WHERE v.Id = @idJuego
		GROUP BY v.Id, v.Nombre, v.Descripcion, v.Fecha_lanzamiento_general,
		v.Historia, v.Calificacion_general, v.Calificacion_profesional, v.Member_ratings, 
		v.Critic_ratings, t.Nombre, s.Nombre, f.Nombre;
    END
    ELSE
    BEGIN
        -- Si no se encontró un juego válido, se utiliza el like para una búsqueda parcial pero tarda más
		SELECT v.id AS 'IGDB ID',
			ISNULL(v.Nombre, '') AS 'Nombre del Juego',
			ISNULL(v.Descripcion, '') AS 'Descripción',
			ISNULL(CONVERT(NVARCHAR(10), v.Fecha_lanzamiento_general), '') AS 'Fecha de Lanzamiento',
			ISNULL(v.Historia, '') AS 'Historia',
			CASE WHEN v.Calificacion_general IS NULL THEN '' ELSE CAST(v.Calificacion_general AS NVARCHAR(10)) END AS 'Calificación General',
			CASE WHEN v.Calificacion_profesional IS NULL THEN '' ELSE CAST(v.Calificacion_profesional AS NVARCHAR(10)) END AS 'Calificación Profesional',
			CASE WHEN v.Member_ratings IS NULL THEN '' ELSE CAST(v.Member_ratings AS NVARCHAR(10)) END AS 'Member Ratings',
			ISNULL(CASE WHEN v.Critic_ratings IS NULL THEN '' ELSE CAST(v.Critic_ratings AS NVARCHAR(10)) END, '') AS 'Critic Ratings',
			(ISNULL(v.Member_ratings, 0) + ISNULL(v.Critic_ratings, 0)) AS 'Total Ratings',
            ISNULL(t.Nombre, '') AS 'Tipo de Juego',
			ISNULL(s.Nombre, '') AS 'Serie del Juego',
			ISNULL(f.Nombre, '') AS 'Franquicia del Juego',

			COALESCE((
				SELECT STRING_AGG(gen.Tipo, ',')
				FROM Videojuego_Genero vgen
				LEFT JOIN Genero gen ON vgen.Genero_Id = gen.Id
				WHERE vgen.Videojuego_Id = v.Id
			), '') AS 'Generos', -- toma la primera expresion no nulla de la lista
			
			COALESCE((
				SELECT STRING_AGG(emp.Nombre, ',')
				FROM Videojuego_Empresa vemp
				LEFT JOIN Empresa emp ON vemp.Empresa_Id = emp.Id
				WHERE vemp.Videojuego_Id = v.Id
			), '') AS 'Empresas',
			
			COALESCE((
				SELECT STRING_AGG(pf.Nombre, ',')
				FROM (
					SELECT DISTINCT Nombre
					FROM Videojuego_Plataforma vpf
					LEFT JOIN Plataforma pf ON vpf.Plataforma_Id = pf.Id
					WHERE vpf.Videojuego_Id = v.Id
				) AS pf
			), '') AS 'Plataformas',

			COALESCE((
				SELECT STRING_AGG(mj.Tipo, ',')
				FROM Videojuego_ModoJuego vmj
				LEFT JOIN ModoJuego mj ON vmj.ModoJuego_Id = mj.Id
				WHERE vmj.Videojuego_Id = v.Id
			), '') AS 'Modo de juego',

			COALESCE((
				SELECT STRING_AGG(tm.Tipo, ', ')
				FROM Videojuego_Tema vtm
				LEFT JOIN Tema tm ON vtm.Tema_Id = tm.Id
				WHERE vtm.Videojuego_Id = v.Id
			), '') AS 'Tema',

			COALESCE((
				SELECT STRING_AGG(ce.Tipo, ', ')
				FROM Videojuego_CatEdad vce
				LEFT JOIN Categoria_Edad ce ON vce.Categoria_Edad_Id = ce.Id
				WHERE vce.Videojuego_Id = v.Id
			), '') AS 'Categoría de Edad',

			COALESCE((
				SELECT STRING_AGG(mt.Nombre, ', ')
				FROM Videojuego_Motor vm
				LEFT JOIN Motor mt ON vm.Motor_Id = mt.Id
				WHERE vm.Videojuego_Id = v.Id
			), '') AS 'Motor',

			COALESCE((
				SELECT STRING_AGG(prs.Tipo, ', ')
				FROM Videojuego_Perspectiva vprs
				LEFT JOIN Perspectiva prs ON vprs.Perspectiva_Id = prs.Id
				WHERE vprs.Videojuego_Id = v.Id
			), '') AS 'Perspectiva Jugador',

			COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Audio'
            ), '') AS 'Idiomas de Audio',

            COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Subtitles'
            ), '') AS 'Idiomas de Subtítulos',

            COALESCE((
                SELECT STRING_AGG(Idiomas.Nombre, ', ')
                FROM Videojuego_Idioma vidioma
                INNER JOIN Idioma Idiomas ON vidioma.Idioma_Id = Idiomas.Id
                INNER JOIN Tipo_Soporte ts ON vidioma.Tipo_Soporte_Id = ts.Id
                WHERE vidioma.Videojuego_Id = v.Id
				AND ts.Tipo = 'Interface'
            ), '') AS 'Idiomas de Interfaz'
        FROM Videojuego v
        LEFT JOIN Tipo t ON v.Tipo_Id = t.Id
        LEFT JOIN Serie s ON v.Serie_Id = s.Id
        LEFT JOIN Franquicia f ON v.Franquicia_Id = f.Id
        
		WHERE LOWER(v.Nombre) LIKE '%' + LOWER(@idONombre) + '%'
		GROUP BY v.Id, v.Nombre, v.Descripcion, v.Fecha_lanzamiento_general,
		v.Historia, v.Calificacion_general, v.Calificacion_profesional, v.Member_ratings, 
		v.Critic_ratings, t.Nombre, s.Nombre, f.Nombre;
    END
END;
GO

-- Consulta libre
WITH TopJuegosPorGeneroYPlataforma AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY p.Nombre, g.Tipo ORDER BY vj.Calificacion_general DESC) AS Ranking,
        vj.Nombre AS NombreVideojuego,
        g.Tipo AS Genero,
        p.Nombre AS Plataforma,
        vj.Calificacion_general AS Rating
    FROM
        Videojuego vj
    INNER JOIN
        Videojuego_Genero vjg ON vj.Id = vjg.Videojuego_Id
    INNER JOIN
        Genero g ON vjg.Genero_Id = g.Id
    INNER JOIN
        Videojuego_Plataforma vp ON vj.Id = vp.Videojuego_Id
    INNER JOIN
        Plataforma p ON vp.Plataforma_Id = p.Id
)
SELECT
    Ranking,
    NombreVideojuego,
    Genero,
    Plataforma,
    Rating
FROM
    TopJuegosPorGeneroYPlataforma
WHERE
    Ranking = 1
ORDER BY
	Genero,
    Plataforma;

