CREATE TABLE HABITACION (
    idHabitacion INT auto_increment primary KEY,
    Habitacion varchar(50)
);

CREATE TABLE PACIENTE (
    idPaciente INT auto_increment primary key,
    edad int,
    genero varchar(20)
);

CREATE TABLE LOG_ACTIVIDAD (
    id_log_actividad INT auto_increment PRIMARY KEY,
    timestampx VARCHAR(100),
    actividad VARCHAR(500),
    PACIENTE_idPaciente INT,
    HABITACION_idHabitacion INT,
    CONSTRAINT fk_log_actividad_paciente FOREIGN KEY (PACIENTE_idPaciente) REFERENCES PACIENTE(idPaciente) ON DELETE CASCADE,
    CONSTRAINT fk_habitacion_log_actividad FOREIGN KEY (HABITACION_idHabitacion) REFERENCES HABITACION(idHabitacion) ON DELETE CASCADE
);

CREATE TABLE LOG_HABITACION (
    timestampx varchar(100) PRIMARY KEY,
    statusx VARCHAR(45),
    idHabitacion INT,
    CONSTRAINT fk_habitacion_log_habitacion FOREIGN KEY (idHabitacion) REFERENCES HABITACION(idHabitacion) ON DELETE CASCADE
);

SELECT * FROM HABITACION;
SELECT * FROM LOG_ACTIVIDAD;
SELECT * FROM LOG_HABITACION;
SELECT * FROM PACIENTE;

SELECT COUNT(*) FROM HABITACION;
SELECT COUNT(*) FROM LOG_ACTIVIDAD;
SELECT COUNT(*) FROM LOG_HABITACION;
SELECT COUNT(*) FROM PACIENTE;

-- Ejemplos
-- mysqldump -u root -p practica2 > full_backup_dia1.sql
-- mysqldump -u root -p practica2 PACIENTE > incremental_backup_dia1.sql

-- Sintaxis para un full backup
-- mysqldump -u [usuario] -p [nombre_de_la_base_de_datos] > C:\ruta\al\directorio\full_backup_dia#.sql

-- Sintaxis para un backup incremental
-- mysqldump -u [usuario] -p [nombre_de_la_base_de_datos] [nombre_de_la_tabla] > C:\ruta\al\directorio\incremental_backup_dia#.sql
-- mysqldump -u [usuario] -p [nombre_de_la_base_de_datos] [nombre_de_la_tabla] -where="fecha_modificacion > '2023-01-01 00:00:00'"  > C:\ruta\al\directorio\incremental_backup_dia#.sql
