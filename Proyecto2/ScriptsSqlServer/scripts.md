## Backup y Restore

- **Script Backup:**

```sql
use dbo;

BACKUP DATABASE dbo
TO DISK = 'C:\tmp\dbo3.bak'
   WITH FORMAT,
      MEDIANAME = 'BackupCompletoProyecto',
      NAME = 'Full Backup of dbo';
```

- **Para ingresar al contenedor**

```bash
docker exec -it <nombre_contenedor_o_ID> /bin/sh
```

- **Para ver los nombres lógicos**

```sql
RESTORE FILELISTONLY
FROM DISK = 'C:\tmp\dbo3.bak';
```

- **Restore**

```sql
RESTORE DATABASE recovery
FROM DISK = 'C:\tmp\dbo3.bak'
WITH REPLACE,
MOVE 'dbo' TO 'C:\tmp\recovery.mdf',
MOVE 'dbo_log' TO 'C:\tmp\recovery.ldf';
```

## Obtener el Collation

- **Obtener el Collation de cualquier tabla, especificando su nombre**

```sql
SELECT t.name AS TableName, c.name AS ColumnName, c.collation_name AS CollationName
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.name = 'Videojuego';
```

- **Muestra el collation predeterminado, de acá se hereda para todas las demás tablas.**

```sql
SELECT DATABASEPROPERTYEX('recovery', 'Collation') AS Collation;
```

## Truncar la bitácora

- **Obtener el nombre del archivo de la bitácora:**

```sql
USE recovery;

SELECT name, physical_name
FROM sys.master_files
WHERE database_id = DB_ID('dbo') AND type_desc = 'LOG';
```

- **Truncar la bitácora**

```sql
DBCC SHRINKFILE (N'dbo_log' , 0, TRUNCATEONLY)
```

Fuente: _[SQL Server Transaction Log Backup, Truncate and Shrink Operations (sqlshack.com)](https://www.sqlshack.com/sql-server-transaction-log-backup-truncate-and-shrink-operations/)_

## Obtener la fragmentación de los índices

```sql
USE recovery;

SELECT OBJECT_NAME(IX.[object_id]) AS [NombreTabla],
IX.[name] AS [NombreIndice],
PS.[avg_fragmentation_in_percent] AS [PorcentajeFragmentacion],
PS.[page_count] AS [NumeroPaginas]
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') AS PS
INNER JOIN sys.indexes AS IX ON PS.[object_id] = IX.[object_id] AND PS.[index_id] = IX.[index_id]
WHERE PS.[index_type_desc] <> 'HEAP'
ORDER BY [PorcentajeFragmentacion] DESC;
```
