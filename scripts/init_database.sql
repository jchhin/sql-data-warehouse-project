/*
=============================================================
Database and Schema Setup
=============================================================
Purpose:
    This script initializes the DataWarehouse database environment.
    It first checks whether a database named 'DataWarehouse' already exists.
    If it does, the script drops and rebuilds it from scratch.

    After the database is created, the script sets up the three schemas
    used throughout the project:
        - bronze
        - silver
        - gold

Note:
    Running this script will permanently remove the existing
    'DataWarehouse' database and everything stored inside it.
    Only run it when you are okay with resetting the project database.
*/

USE master;
GO

-- Reset the DataWarehouse database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create a fresh DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create project schemas for each warehouse layer
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
