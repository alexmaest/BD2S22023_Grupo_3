-- DROP SCHEMA practica1;

CREATE SCHEMA practica1;
-- BD2.practica1.Course definition

-- Drop table

-- DROP TABLE BD2.practica1.Course;

CREATE TABLE BD2.practica1.Course (
	CodCourse int NOT NULL,
	Name nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CreditsRequired int NOT NULL,
	CONSTRAINT PK_Course PRIMARY KEY (CodCourse)
);


-- BD2.practica1.HistoryLog definition

-- Drop table

-- DROP TABLE BD2.practica1.HistoryLog;

CREATE TABLE BD2.practica1.HistoryLog (
	Id int IDENTITY(1,1) NOT NULL,
	[Date] datetime2 NOT NULL,
	Description nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_HistoryLog PRIMARY KEY (Id)
);


-- BD2.practica1.Roles definition

-- Drop table

-- DROP TABLE BD2.practica1.Roles;

CREATE TABLE BD2.practica1.Roles (
	Id uniqueidentifier NOT NULL,
	RoleName nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_Roles PRIMARY KEY (Id)
);


-- BD2.practica1.Usuarios definition

-- Drop table

-- DROP TABLE BD2.practica1.Usuarios;

CREATE TABLE BD2.practica1.Usuarios (
	Id uniqueidentifier NOT NULL,
	Firstname nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Lastname nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Email nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DateOfBirth datetime2 NOT NULL,
	Password nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	LastChanges datetime2 NOT NULL,
	EmailConfirmed bit NOT NULL,
	CONSTRAINT PK_Usuarios PRIMARY KEY (Id)
);


-- BD2.practica1.CourseAssignment definition

-- Drop table

-- DROP TABLE BD2.practica1.CourseAssignment;

CREATE TABLE BD2.practica1.CourseAssignment (
	Id int IDENTITY(1,1) NOT NULL,
	StudentId uniqueidentifier NOT NULL,
	CourseCodCourse int NOT NULL,
	CONSTRAINT PK_CourseAssignment PRIMARY KEY (Id),
	CONSTRAINT FK_CourseAssignment_Course_CourseCodCourse FOREIGN KEY (CourseCodCourse) REFERENCES BD2.practica1.Course(CodCourse) ON DELETE CASCADE,
	CONSTRAINT FK_CourseAssignment_Usuarios_StudentId FOREIGN KEY (StudentId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_CourseAssignment_CourseCodCourse ON BD2.practica1.CourseAssignment (CourseCodCourse);
CREATE NONCLUSTERED INDEX IX_CourseAssignment_StudentId ON BD2.practica1.CourseAssignment (StudentId);


-- BD2.practica1.CourseTutor definition

-- Drop table

-- DROP TABLE BD2.practica1.CourseTutor;

CREATE TABLE BD2.practica1.CourseTutor (
	Id int IDENTITY(1,1) NOT NULL,
	TutorId uniqueidentifier NOT NULL,
	CourseCodCourse int NOT NULL,
	CONSTRAINT PK_CourseTutor PRIMARY KEY (Id),
	CONSTRAINT FK_CourseTutor_Course_CourseCodCourse FOREIGN KEY (CourseCodCourse) REFERENCES BD2.practica1.Course(CodCourse) ON DELETE CASCADE,
	CONSTRAINT FK_CourseTutor_Usuarios_TutorId FOREIGN KEY (TutorId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_CourseTutor_CourseCodCourse ON BD2.practica1.CourseTutor (CourseCodCourse);
CREATE NONCLUSTERED INDEX IX_CourseTutor_TutorId ON BD2.practica1.CourseTutor (TutorId);


-- BD2.practica1.Notification definition

-- Drop table

-- DROP TABLE BD2.practica1.Notification;

CREATE TABLE BD2.practica1.Notification (
	Id int IDENTITY(1,1) NOT NULL,
	UserId uniqueidentifier NOT NULL,
	Message nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Date] datetime2 NOT NULL,
	CONSTRAINT PK_Notification PRIMARY KEY (Id),
	CONSTRAINT FK_Notification_Usuarios_UserId FOREIGN KEY (UserId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_Notification_UserId ON BD2.practica1.Notification (UserId);


-- BD2.practica1.ProfileStudent definition

-- Drop table

-- DROP TABLE BD2.practica1.ProfileStudent;

CREATE TABLE BD2.practica1.ProfileStudent (
	Id int IDENTITY(1,1) NOT NULL,
	UserId uniqueidentifier NOT NULL,
	Credits int NOT NULL,
	CONSTRAINT PK_ProfileStudent PRIMARY KEY (Id),
	CONSTRAINT FK_ProfileStudent_Usuarios_UserId FOREIGN KEY (UserId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_ProfileStudent_UserId ON BD2.practica1.ProfileStudent (UserId);


-- BD2.practica1.TFA definition

-- Drop table

-- DROP TABLE BD2.practica1.TFA;

CREATE TABLE BD2.practica1.TFA (
	Id int IDENTITY(1,1) NOT NULL,
	UserId uniqueidentifier NOT NULL,
	Status bit NOT NULL,
	LastUpdate datetime2 NOT NULL,
	CONSTRAINT PK_TFA PRIMARY KEY (Id),
	CONSTRAINT FK_TFA_Usuarios_UserId FOREIGN KEY (UserId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_TFA_UserId ON BD2.practica1.TFA (UserId);


-- BD2.practica1.TutorProfile definition

-- Drop table

-- DROP TABLE BD2.practica1.TutorProfile;

CREATE TABLE BD2.practica1.TutorProfile (
	Id int IDENTITY(1,1) NOT NULL,
	UserId uniqueidentifier NOT NULL,
	TutorCode nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK_TutorProfile PRIMARY KEY (Id),
	CONSTRAINT FK_TutorProfile_Usuarios_UserId FOREIGN KEY (UserId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_TutorProfile_UserId ON BD2.practica1.TutorProfile (UserId);


-- BD2.practica1.UsuarioRole definition

-- Drop table

-- DROP TABLE BD2.practica1.UsuarioRole;

CREATE TABLE BD2.practica1.UsuarioRole (
	Id int IDENTITY(1,1) NOT NULL,
	RoleId uniqueidentifier NOT NULL,
	UserId uniqueidentifier NOT NULL,
	IsLatestVersion bit NOT NULL,
	CONSTRAINT PK_UsuarioRole PRIMARY KEY (Id),
	CONSTRAINT FK_UsuarioRole_Roles_RoleId FOREIGN KEY (RoleId) REFERENCES BD2.practica1.Roles(Id) ON DELETE CASCADE,
	CONSTRAINT FK_UsuarioRole_Usuarios_UserId FOREIGN KEY (UserId) REFERENCES BD2.practica1.Usuarios(Id) ON DELETE CASCADE
);
CREATE NONCLUSTERED INDEX IX_UsuarioRole_RoleId ON BD2.practica1.UsuarioRole (RoleId);
CREATE NONCLUSTERED INDEX IX_UsuarioRole_UserId ON BD2.practica1.UsuarioRole (UserId);

CREATE PROCEDURE practica1.PR1
	@Firstname		VARCHAR(60),
	@Lastname		VARCHAR(60),
	@Email			VARCHAR(60),
	@DateOfBirth	DATETIME2,
	@Password		VARCHAR(60),
	@Credits		INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
	
		-- Validación del primer nombre
		IF LEN(@Firstname) = 0 OR @Firstname LIKE '%[0-9]%'
		BEGIN
			THROW 50000, 'El nombre no es válido', 1;
		END

		-- Validación del apellido
		IF LEN(@Lastname) = 0 OR @Lastname LIKE '%[0-9]%'
		BEGIN
			THROW 50000, 'El apellido no es válido', 1;
		END
		
		-- Validación del email
		IF @Email IS NULL OR @Email NOT LIKE '%_@__%.__%'
		BEGIN
			THROW 50000, 'El email no es válido', 1;
		END
		
		-- Validación de los créditos
		IF @Credits IS NULL
		BEGIN
			THROW 50000, 'Los créditos no son válidos', 1;
		END
		
		-- Validación del correo repetido
		IF EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email)
		BEGIN
			THROW 50000, 'El correo ya está registrado', 1;
		END

		-- Si todas las validaciones han sido exitosas, realizar las inserciones
		DECLARE @UserId NVARCHAR(36) = NEWID();

		-- Configuración de fecha y hora de Guatemala
		DECLARE @GuatemalaTime DATETIMEOFFSET;
		SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
	
		-- Insertar en la tabla Usuarios
		INSERT INTO practica1.Usuarios (Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
		VALUES (@UserId, @Firstname, @Lastname, @Email, @DateOfBirth, @Password, @GuatemalaTime, 1);

		-- Insertar en la tabla Notification
		INSERT INTO practica1.Notification (UserId, Message, Date)
		VALUES (@UserId, 'Bienvenido, has sido registrado', @GuatemalaTime);

		-- Insertar en la tabla UsuarioRole
		INSERT INTO practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
		VALUES ('F4E6D8FB-DF45-4C91-9794-38E043FD5ACD', @UserId, 1);

		-- Insertar en la tabla ProfileStudent
		INSERT INTO practica1.ProfileStudent (UserId, Credits)
		VALUES (@UserId, @Credits);

		-- Insertar en la tabla TFA
		INSERT INTO practica1.TFA (UserId, Status, LastUpdate)
		VALUES (@UserId, 0, @GuatemalaTime);

		SELECT 'El usuario ha sido creado' AS Success;

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
	END CATCH
END;

CREATE PROCEDURE practica1.PR2
	@Email			NVARCHAR(60),
	@CodCourse		INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION
	
		-- Validación del email
		IF @Email IS NULL OR @Email NOT LIKE '%_@__%.__%'
		BEGIN
			THROW 50000, 'El email no es válido', 1;
		END
		
		-- Validación de los créditos
		IF @CodCourse IS NULL
		BEGIN
			THROW 50000, 'El código de curso no es válido', 1;
		END
		
		-- Validación que exista el correo
		IF NOT EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email)
		BEGIN
			THROW 50000, 'El correo no existe', 1;
		END

		-- Validación que la cuenta esté activa
		IF NOT EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email AND EmailConfirmed = 1)
		BEGIN
			THROW 50000, 'La cuenta no se encuentra activa', 1;
		END

		-- Validación que exista el curso
		IF NOT EXISTS (SELECT 1 FROM practica1.Course WHERE CodCourse = @CodCourse)
		BEGIN
			THROW 50000, 'El curso no existe', 1;
		END

		-- Obtener UserId asociado al correo
		DECLARE @UserId UNIQUEIDENTIFIER;
		SELECT @UserId = Id FROM practica1.Usuarios WHERE Email = @Email;

		-- Validación que no tenga ya asignado el curso como tutor
		IF EXISTS (SELECT 1 FROM practica1.CourseTutor WHERE TutorId = @UserId AND CourseCodCourse = @CodCourse)
		BEGIN
			THROW 50000, 'El usuario ya tiene asignado este curso como tutor', 1;
		END

		-- Configuración de fecha y hora de Guatemala
		DECLARE @GuatemalaTime DATETIMEOFFSET;
		SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');

		-- Insertar en la tabla CourseTutor
		INSERT INTO practica1.CourseTutor (TutorId, CourseCodCourse)
		VALUES (@UserId, @CodCourse);

		-- Obtener el Id insertado
		DECLARE @TutorIdInserted INT;
		SET @TutorIdInserted = SCOPE_IDENTITY();

		-- Insertar en la tabla TutorProfile
		INSERT INTO practica1.TutorProfile (UserId, TutorCode)
		VALUES (@UserId, @TutorIdInserted);

		-- Actualizar roles a última versión
		UPDATE practica1.UsuarioRole SET IsLatestVersion = 0 WHERE UserId = @UserId;

		-- Insertar en la tabla UsuarioRole
		INSERT INTO practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
		VALUES ('2CF8E1CF-3CD6-44F3-8F86-1386B7C17657', @UserId, 1);

		-- Insertar en la tabla Notificacion
		INSERT INTO practica1.Notification (UserId, Message, Date)
		VALUES (@UserId, 'Felicitaciones, ahora también tienes el rol de tutor', @GuatemalaTime);

		SELECT 'Se ha agregado un nuevo rol al usuario' AS Success;

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
	END CATCH
END;

CREATE PROCEDURE practica1.PR3
    @Email NVARCHAR(100),
    @CodCurse INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
    -- Iniciar la transacción
        BEGIN TRANSACTION;

            -- Validación del email
            IF @Email IS NULL OR @Email NOT LIKE '%_@__%.__%'
            BEGIN
                throw 50000, N'El email no es válido.', 1;
            END

            -- Obtener el Student Id
            DECLARE @StudentId uniqueidentifier;

            SELECT @StudentId = Id
            FROM practica1.Usuarios
            WHERE Email = @Email;

            IF @StudentId IS NULL
            BEGIN
                THROW 50000, 'No se encuentra el estudiante', 1;
            END

            -- Validar que el curso exista

            IF NOT EXISTS (
                SELECT 1
                FROM practica1.Course
                WHERE CodCourse = @CodCurse
            )
                BEGIN
                    throw 50000, 'El curso no existe', 1;
                end

            -- Validar que el estudiante no esté inscrito en el curso
            IF EXISTS (
                SELECT 1
                FROM practica1.CourseAssignment
                WHERE StudentId = @StudentId AND CourseCodCourse = @CodCurse
            )
                BEGIN
                    throw 50000, N'El estudiante ya está inscrito en el curso', 1;
                end

            -- Insertar el registro en la entidad CorseAssignment
            INSERT INTO practica1.CourseAssignment
            VALUES (@StudentId, @CodCurse);

            SELECT 'Estudiante asignado correctamente' AS Success;

            -- Notificarle al estudiante que se ha inscrito en el curso

            INSERT INTO practica1.Notification
            VALUES (
                @StudentId,
                'El estudiante ' + @Email + ' se ha inscrito en el curso ' + CAST(@CodCurse AS NVARCHAR(10)),
                GETDATE()
            );

            -- Notificarle al profesor que un estudiante se ha inscrito en su curso, si el curso tiene profesor

            DECLARE @TutorId uniqueidentifier;

            SELECT @TutorId = TutorId
                FROM practica1.CourseTutor ct
                WHERE ct.CourseCodCourse = @CodCurse;

            IF @TutorId IS NOT NULL
            BEGIN
                INSERT INTO practica1.Notification
                VALUES (
                    @TutorId,
                    'El estudiante ' + @Email + ' se ha inscrito en el curso ' + CAST(@CodCurse AS NVARCHAR(10)),
                    GETDATE()
                );
            END

            -- Confirmar la transacción
            COMMIT TRANSACTION;
    END TRY

    begin catch
        -- Revertir la transacción
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Lanzar el error
        THROW;
    end catch
END;

CREATE PROCEDURE practica1.PR4
    @RoleName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        begin transaction;
        -- Validación de que el nombre del rol no sea nulo
        IF @RoleName IS NULL
        BEGIN
            throw 50000, N'El nombre del rol no puede ser nulo.', 1;
        END

        -- Validación que el rol no exista
        IF EXISTS (SELECT * FROM practica1.Roles WHERE RoleName = @RoleName)
        BEGIN
            throw 50000, N'El rol ya existe.', 1;
        END

        DECLARE @Id uniqueidentifier
        -- Insertar el registro en la entidad Roles
        INSERT INTO practica1.Roles
        VALUES (@Id, @RoleName)
        select 'El rol se ha creado correctamente.' as Success;

        commit transaction;


    END TRY
    begin catch
        -- Revertir la transacción
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Lanzar el error
        THROW;
    end catch

end;

CREATE PROCEDURE practica1.PR5
	@CodCurso INT,
    @Nombre NVARCHAR(MAX),
    @CreditosRequeridos INT
AS
BEGIN
	SET NOCOUNT ON;
	-- Iniciar la transacción
	BEGIN TRANSACTION;
	BEGIN TRY
		DECLARE @idCurso INT;
		DECLARE @DatosValidos BIT;
		DECLARE @ErrorMessage NVARCHAR(4000);

		EXEC practica1.PR6 'Course', NULL, NULL, @Nombre, @CreditosRequeridos, @DatosValidos OUTPUT;
		IF(@DatosValidos = 0)
		BEGIN
			 SET @ErrorMessage = 'ERROR// Los atributos ingresados no son validos.';
            THROW 50000, @ErrorMessage, 1;
		END

		-- VALIDAR QUE EL NOMBRE NO ESTE VACÍO
		IF(@Nombre IS NULL OR @Nombre='')
		BEGIN
			SET @ErrorMessage = 'ERROR// El nombre no puede ser una cadena vacía.';
            THROW 50000, @ErrorMessage, 1;
		END

		-- VALIDAR QUE EL CODIGO Y LOS CREDITOS SEAN POSITIVOS
		IF(@CreditosRequeridos < 0 OR @CodCurso < 0)
		BEGIN
			SET @ErrorMessage = 'ERROR// La cantidad de créditos y el código no pueden ser negativos.';
            THROW 50000, @ErrorMessage, 1;
		END

		-- VALIDAR QUE EL CODIGO DEL CURSO NO EXISTA
		SELECT @idCurso = CodCourse FROM practica1.Course WHERE CodCourse = @CodCurso;
		IF(@idCurso IS NOT NULL)
		BEGIN
			SET @ErrorMessage = 'ERROR// El codigo del curso ya existe.';
            THROW 50000, @ErrorMessage, 1;
		END

		-- REALIZAMOS LA INSERCION
		INSERT INTO practica1.Course (CodCourse, Name, CreditsRequired)
		VALUES (@CodCurso, @Nombre, @CreditosRequeridos);

		SELECT 'Curso insertado correctamente.' AS Success;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END;

CREATE PROCEDURE practica1.PR6
	@NombreTabla NVARCHAR(50),
	@FirstName NVARCHAR(255) = NULL,
	@LastName NVARCHAR(255) = NULL,
	@Name NVARCHAR(255) = NULL,
	@CreditsRequired INT = NULL,
	@EsValido BIT OUTPUT
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		IF @NombreTabla = 'Usuarios'
		BEGIN
			-- Se verifica que FirstName y LastName solo tengan letras y espacio
			IF ISNULL(@FirstName, '') NOT LIKE '%[^a-zA-Z ]%' AND ISNULL(@LastName, '') NOT LIKE '%[^a-zA-Z ]%'
				SET @EsValido = 1;
			ELSE
				SET @EsValido = 0;
		END

		ELSE IF @NombreTabla = 'Course'
		BEGIN
			-- Se verifica que Name solo tenga letras y CreditsRequired solo tenga numeros.
			IF ISNULL(@Name, '') NOT LIKE '%[^a-zA-Z ]%' AND ISNUMERIC(@CreditsRequired) = 1
				SET @EsValido = 1;
			ELSE
				SET @EsValido = 0;
		END

		ELSE
		BEGIN
			SET @EsValido = 0;
		END;
	END TRY

	BEGIN CATCH
		SET @EsValido = 0;
	END CATCH
END;

CREATE FUNCTION practica1.F1
    (@CodCurse INT)
RETURNS TABLE
AS
RETURN
    SELECT u.Id AS 'Id estudiante', u.FirstName AS 'Nombre', u.LastName AS 'Apellido', u.Email AS 'Correo'
    FROM practica1.Usuarios u
    INNER JOIN practica1.CourseAssignment ca ON u.Id = ca.StudentId
    WHERE ca.CourseCodCourse = @CodCurse

CREATE FUNCTION practica1.F2
    (@IdTutorProfile INT)
RETURNS TABLE
AS
RETURN
    SELECT c.CodCourse AS 'Codigo Curso', c.Name AS 'Nombre del curso', c.CreditsRequired AS 'Creditos requeridos'
    FROM practica1.Course c
    INNER JOIN practica1.CourseTutor ct ON c.CodCourse = ct.CourseCodCourse
    WHERE ct.TutorId = @IdTutorProfile


CREATE FUNCTION practica1.F3(@id UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN
(
	SELECT
		N.Id,
		N.Message,
		N.Date
	FROM
		practica1.Notification N
	WHERE N.UserId = @id
);

CREATE FUNCTION practica1.F4()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM practica1.HistoryLog
);

CREATE FUNCTION practica1.F5(@UserId NVARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT
        U.Firstname,
        U.Lastname,
        U.Email,
        U.DateOfBirth,
        PS.Credits,
        R.RoleName
    FROM
        Usuarios U
    INNER JOIN
        ProfileStudent PS ON U.Id = PS.UserId
    INNER JOIN
        UsuarioRole UR ON U.Id = UR.UserId
    INNER JOIN
        Roles R ON UR.RoleId = R.Id
    WHERE
        U.Id = @UserId
);

CREATE TRIGGER Trigger_Usuarios
ON practica1.Usuarios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla Usuarios';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_UsuarioRole
ON practica1.UsuarioRole
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla UsuarioRole';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_TutorProfile
ON practica1.TutorProfile
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla TutorProfile';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_TFA
ON practica1.TFA
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla TFA';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_ProfileStudent
ON practica1.ProfileStudent
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla ProfileStudent';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_Notification
ON practica1.Notification
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla Notification';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_CourseTutor
ON practica1.CourseTutor
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla CourseTutor';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_CourseAssignment
ON practica1.CourseAssignment
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla CourseAssignment';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;

CREATE TRIGGER Trigger_Course
ON practica1.Course
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @Operation = 'UPDATE';
        ELSE
            SET @Operation = 'INSERT';
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
	
	-- Configuración de fecha y hora de Guatemala
	DECLARE @GuatemalaTime DATETIMEOFFSET;
	SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla Course';
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(@GuatemalaTime, @Message);
END;