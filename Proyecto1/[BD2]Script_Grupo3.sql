-- Crear tabla Tipo
CREATE TABLE Tipo (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Serie
CREATE TABLE Serie (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Franquicia
CREATE TABLE Franquicia (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Videojuego
CREATE TABLE Videojuego (
    Id BIGINT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Fecha_lanzamiento_general DATE,
    Descripcion NVARCHAR(4000),
    Historia NVARCHAR(4000),
    Calificacion_general DECIMAL(10,2),
    Calificacion_profesional DECIMAL(10,2),
    Member_ratings INT,
    Critic_ratings INT,
    Tipo_Id INT,
    Serie_Id INT,
    Franquicia_Id INT,
    FOREIGN KEY (Tipo_Id) REFERENCES Tipo(Id),
    FOREIGN KEY (Serie_Id) REFERENCES Serie(Id),
    FOREIGN KEY (Franquicia_Id) REFERENCES Franquicia(Id)
);

-- Crear tabla Motor
CREATE TABLE Motor (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Videojuego_Motor
CREATE TABLE Videojuego_Motor (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Motor_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Motor_Id) REFERENCES Motor(Id)
);

-- Crear tabla Tema
CREATE TABLE Tema (
    Id INT PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_Tema
CREATE TABLE Videojuego_Tema (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Tema_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Tema_Id) REFERENCES Tema(Id)
);

-- Crear tabla Perspectiva
CREATE TABLE Perspectiva (
    Id INT PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_Perspectiva
CREATE TABLE Videojuego_Perspectiva (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Perspectiva_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Perspectiva_Id) REFERENCES Perspectiva(Id)
);

-- Crear tabla Titulo
CREATE TABLE Titulo (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100),
    Comentario NVARCHAR(100),
    Videojuego_Id BIGINT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id)
);

-- Crear tabla Genero
CREATE TABLE Genero (
    Id INT PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_Genero
CREATE TABLE Videojuego_Genero (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Genero_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Genero_Id) REFERENCES Genero(Id)
);

-- Crear tabla Plataforma
CREATE TABLE Plataforma (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Videojuego_Plataforma
CREATE TABLE Videojuego_Plataforma (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE,
    Region NVARCHAR(50),
    Videojuego_Id BIGINT,
    Plataforma_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Plataforma_Id) REFERENCES Plataforma(Id)
);

-- Crear tabla ModoJuego
CREATE TABLE ModoJuego (
    Id INT PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_ModoJuego
CREATE TABLE Videojuego_ModoJuego (
	Id bigint IDENTITY(1,1) NOT NULL,
	Plataforma_Id INT,
	Videojuego_Id BIGINT,
	ModoJuego_Id INT,
	Lan_Cooperativo BIT,
	Offline_Cooperativo BIT,
	Online_Cooperativo BIT,
	Campaña_Cooperativo BIT,
	Pantalla_Dividida_Offline BIT,
	Pantalla_Dividida_Online BIT,
	Dropin BIT,
	Offline_Cooperativo_Max INT,
	Online_Cooperativo_Max INT,
	Offline_Single_Max INT,
	Online_Single_Max INT,
	CONSTRAINT (ModoJuego_Id) FOREIGN KEY (ModoJuego_Id) REFERENCES ModoJuego(Id),
	CONSTRAINT (Plataforma_Id) FOREIGN KEY (Plataforma_Id) REFERENCES Plataforma(Id),
	CONSTRAINT (Videojuego_Id) FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id)
);

-- Crear tabla Categoria_Edad
CREATE TABLE Categoria_Edad (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_CatEdad
CREATE TABLE Videojuego_CatEdad (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Categoria_Edad_Id INT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Categoria_Edad_Id) REFERENCES Categoria_Edad(Id)
);

-- Crear tabla Idioma
CREATE TABLE Idioma (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);

-- Crear tabla Tipo_Soporte
CREATE TABLE Tipo_Soporte (
    Id INT PRIMARY KEY,
    Tipo NVARCHAR(100)
);

-- Crear tabla Videojuego_Idioma
CREATE TABLE Videojuego_Idioma (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_Soporte_Id INT,
    Videojuego_Id BIGINT,
    Idioma_Id INT,
    FOREIGN KEY (Tipo_Soporte_Id) REFERENCES Tipo_Soporte(Id),
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Idioma_Id) REFERENCES Idioma(Id)
);

-- Crear tabla Empresa
CREATE TABLE Empresa (
    Id BIGINT PRIMARY KEY,
    Nombre NVARCHAR(100),
    Descripcion NVARCHAR(500),
    Fundacion NVARCHAR(100),
    Padre_Id BIGINT
);

-- Crear tabla Videojuego_Empresa
CREATE TABLE Videojuego_Empresa (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Videojuego_Id BIGINT,
    Empresa_Id BIGINT,
    FOREIGN KEY (Videojuego_Id) REFERENCES Videojuego(Id),
    FOREIGN KEY (Empresa_Id) REFERENCES Empresa(Id)
);
