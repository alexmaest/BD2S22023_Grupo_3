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
	BEGIN TRY
		BEGIN TRANSACTION
	
		-- Validación del primer nombre
		IF LEN(@Firstname) = 0 OR @Firstname LIKE '%[0-9]%'
		BEGIN
			SELECT 'El Nombre no es válido.' AS Error;
			RETURN;
		END

		-- Validación del apellido
		IF LEN(@Lastname) = 0 OR @Lastname LIKE '%[0-9]%'
		BEGIN
			SELECT 'El Apellido no es válido.' AS Error;
			RETURN;
		END
		
		-- Validación del email
		IF @Email IS NULL OR @Email NOT LIKE '%_@__%.__%'
		BEGIN
			SELECT 'El email no es válido.' AS Error;
			RETURN;
		END
		
		-- Validación de los créditos
		IF @Credits IS NULL
		BEGIN
			SELECT 'Los créditos no son válidos.' AS Error;
			RETURN;
		END
		
		-- Validación del correo repetido
		IF EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email)
		BEGIN
			SELECT 'El correo ya está registrado.' AS Error;
			RETURN;
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

		SELECT 'Successful!' AS Success;

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		SELECT 'Ha ocurrido un error al registrar un usuario.' AS Error;
		ROLLBACK TRANSACTION
	END CATCH
END;

CREATE PROCEDURE practica1.PR2
	@Email			NVARCHAR(60),
	@CodCourse		INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
	
		-- Validación del email
		IF @Email IS NULL OR @Email NOT LIKE '%_@__%.__%'
		BEGIN
			SELECT 'El email no es válido.' AS Error;
			RETURN;
		END
		
		-- Validación de los créditos
		IF @CodCourse IS NULL
		BEGIN
			SELECT 'El código de curso no es válido.' AS Error;
			RETURN;
		END
		
		-- Validación que exista el correo
		IF NOT EXISTS (SELECT 1 FROM practica1.Usuarios WHERE Email = @Email)
		BEGIN
			SELECT 'El correo no existe.' AS Error;
			RETURN;
		END

		-- Validación que exista el curso
		IF NOT EXISTS (SELECT 1 FROM practica1.Course WHERE CodCourse = @CodCourse)
		BEGIN
			SELECT 'El curso no existe.' AS Error;
			RETURN;
		END

		-- Obtener UserId asociado al correo
		DECLARE @UserId UNIQUEIDENTIFIER;
		SELECT @UserId = Id FROM practica1.Usuarios WHERE Email = @Email;

		-- Validación que no tenga ya asignado el curso como tutor
		IF EXISTS (SELECT 1 FROM practica1.UsuarioRole WHERE RoleId = '2CF8E1CF-3CD6-44F3-8F86-1386B7C17657' AND UserId = @UserId)
		BEGIN
			SELECT 'El usuario ya tiene asignado este curso como tutor.' AS Error;
			RETURN;
		END

		-- Configuración de fecha y hora de Guatemala
		DECLARE @GuatemalaTime DATETIMEOFFSET;
		SET @GuatemalaTime = SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00');

		-- Insertar en las tablas TutorProfile y CourseTutor
		DECLARE @TutorCode NVARCHAR(50);
		SET @TutorCode = CONCAT('TUTOR_', NEWID());

		INSERT INTO practica1.TutorProfile (UserId, TutorCode)
		VALUES (@UserId, @TutorCode);

		-- Insertar en la tabla CourseTutor
		INSERT INTO practica1.CourseTutor (TutorId, CourseCodCourse)
		VALUES (@UserId, @CodCourse);

		-- Insertar en la tabla UsuarioRole
		INSERT INTO practica1.UsuarioRole (RoleId, UserId, IsLatestVersion)
		VALUES ('2CF8E1CF-3CD6-44F3-8F86-1386B7C17657', @UserId, 1);

		-- Insertar en la tabla Notificacion
		INSERT INTO practica1.Notification (UserId, Message, Date)
		VALUES (@UserId, 'Felicitaciones, ahora también tienes el rol de tutor', @GuatemalaTime);

		SELECT 'Successful!' AS Success;

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		SELECT 'Ha ocurrido un error al cambiar de rol al estudiante.' AS Error;
		ROLLBACK TRANSACTION
	END CATCH
END;

CREATE FUNCTION practica1.F5(@Email NVARCHAR(100))
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
        U.Email = @Email
);

-- Not ready, pending questions
CREATE TRIGGER Trigger1
ON  practica1.Usuarios, 
	practica1.UsuarioRole, 
	practica1.TutorProfile, 
	practica1.TFA, 
	practica1.ProfileStudent, 
	practica1.Notification, 
	practica1.CourseTutor, 
	practica1.CourseAssignment, 
	practica1.Course
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Message AS VARCHAR(MAX);
    DECLARE @Operation AS VARCHAR(10);
    DECLARE @TableName AS VARCHAR(MAX);
    
    SET @TableName = OBJECT_NAME(@@PROCID);

    IF EXISTS (SELECT * FROM inserted)
        SET @Operation = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operation = 'DELETE';
    ELSE
        SET @Operation = 'UPDATE';
    
    SET @Message = 'Se realizó un ' + @Operation + ' en la tabla ' + @TableName;
    INSERT INTO practica1.HistoryLog([Date], Description) VALUES(GETDATE(), @Message);
END;