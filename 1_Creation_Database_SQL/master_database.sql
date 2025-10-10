/*----------------------------------------------------------------------------------------------------------------------------
/									Wetlands flooding extent and trends using SATellite data and Machine Learning			 /
/													WETSAT-ML Databases using PostgreSQL and PgAdmin4						 /											 				 
/												  Code Developed by Carlos Mendez and Sebastian Palomino                     /
----------------------------------------------------------------------------------------------------------------------------*/																				  
--- General Steps
--- Create a new Server Group, for example 'SeiLatamWater'
--- Register a new SERVER, for example 'WETSAT_Server'
--- Create a new DATABASE, for example 'wetsat_master' 
CREATE DATABASE wetsat_master
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--- Create an user with permissions, for example 'admin_wetsat'
CREATE ROLE admin_wetsat WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'xxxxxx';
COMMENT ON ROLE admin_wetsat IS 'support data';

--- Change the administrator and set 'admin_wetsat'
ALTER DATABASE wetsat_master OWNER TO admin_wetsat;

--- create extensions related with PostGIS
CREATE EXTENSION address_standardizer;
CREATE EXTENSION address_standardizer_data_us;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;
CREATE EXTENSION h3;
CREATE EXTENSION h3_postgis;
CREATE EXTENSION mobilitydb;
CREATE EXTENSION ogr_fdw;
CREATE EXTENSION pgrouting;
CREATE EXTENSION plpgsql;
CREATE EXTENSION pointcloud;
CREATE EXTENSION pointcloud_postgis;
CREATE EXTENSION postgis_sfcgal;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;

-----------------------------------------------------------Create Schema from everglades -----------------------------------------------------------------
CREATE SCHEMA wetsat_everglades
    AUTHORIZATION admin_wetsat;

------------------------------------------------------ Evapotranspiration variable -----------------------------------------------------------------

--- Create empty table from evapotranspiration
CREATE TABLE wetsat_everglades.evapotranspiration(fecha date, stationname varchar, et decimal);

--- Import the data from everglades evapotranspiration
COPY wetsat_everglades.evapotranspiration FROM 'C:\WETSAT\everglades\evergladesEtData.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);

--- Alter table owner
ALTER TABLE IF EXISTS wetsat_everglades.evapotranspiration OWNER to admin_wetsat;

--- Create a simple query to visualize evapotranspiration
SELECT * FROM wetsat_everglades.evapotranspiration

---------------------------------------------------------- Rainfall variable -----------------------------------------------------------------

--- Create empty table from rainfall
CREATE TABLE wetsat_everglades.rainfall(fecha date, stationname varchar, et decimal);

--- Import the data from everglades rainfall
COPY wetsat_everglades.rainfall FROM 'C:\WETSAT\everglades\evergladesRainfallData.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);

--- Alter table owner
ALTER TABLE IF EXISTS wetsat_everglades.rainfall OWNER to admin_wetsat;

--- Create a simple query to visualize rainfall
SELECT * FROM wetsat_everglades.rainfall

---------------------------------------------------------- Water Levels -----------------------------------------------------------------

--- Create empty table from water level
CREATE TABLE wetsat_everglades.water_level(fecha date, stationname varchar, et decimal, tipodato varchar);

--- Import the data from everglades rainfall
COPY wetsat_everglades.water_level FROM 'C:\WETSAT\everglades\evergladesWaterLevelData.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);

--- Alter table owner
ALTER TABLE IF EXISTS wetsat_everglades.water_level OWNER to admin_wetsat;

--- Create a simple query to visualize water levels
SELECT * FROM wetsat_everglades.water_level

-----------------------------------------------------------Create Schema from point stations -----------------------------------------------------------------
CREATE SCHEMA point_stations
    AUTHORIZATION admin_wetsat;

-----------------------------------------------------------Create Schema from shape_everglades -----------------------------------------------------------------
CREATE SCHEMA shape_everglades
    AUTHORIZATION admin_wetsat;
	
/* 
Connect GIS data using PostGIS and import shapefiles (.shp) using the function shp2pgsql
Try to run the following scripts in the Terminal of Windows/macOS/Linux:

First, Open the shp2pgsql.exe in the local directory 
C:\Program Files\PostgreSQL\18\bin\shp2pgsql.exe

Second, run the script and replace the path folder and .shp files, folowing the structure 
(shp2pgsql -s <SRID> -I <path_to_shapefile.shp> <schema_name>.<table_name> > <output_file.sql>

open Commander or Powershell in your local machine

Point Stations
.\shp2pgsql -s 4326 -I C:\WETSAT\points_stations\Points_stations_example.shp point_stations.points_stations > C:\Users\CarlosMéndez\Documents\GitHub\WETSAT_v2\1_Creation_Database_SQL\point_stations.sql

Shape everglades
.\shp2pgsql -s 4326 -I C:\WETSAT\shape_everglades\EDEN_v3_subzones_OK.shp shape_everglades.everglades_shape > C:\Users\CarlosMéndez\Documents\GitHub\WETSAT_v2\1_Creation_Database_SQL\everglades_shape.sql
*/

--- Create a simple query to visualize point_stations
SELECT * FROM point_stations.points_stations
ORDER BY gid ASC 

--- Create a simple query to visualize everglades_shape
SELECT * FROM shape_everglades.everglades_shape
ORDER BY gid ASC 

-- new query





	