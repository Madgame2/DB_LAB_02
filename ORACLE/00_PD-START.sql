

CREATE PLUGGABLE DATABASE ForeignWorld_PDB
ADMIN USER foreign_admin IDENTIFIED BY StrongPassword123
FILE_NAME_CONVERT = (
    '/opt/oracle/oradata/XE/pdbseed/',
    '/opt/oracle/oradata/XE/ForeignWorld_PDB/'
);

ALTER PLUGGABLE DATABASE ForeignWorld_PDB OPEN;
ALTER PLUGGABLE DATABASE ForeignWorld_PDB SAVE STATE;

ALTER SESSION SET CONTAINER = ForeignWorld_PDB;

CREATE TABLESPACE foreignworld_ts
DATAFILE 'foreignworld01.dbf'
SIZE 200M
AUTOEXTEND ON
NEXT 50M
MAXSIZE 2G;


CREATE USER foreignworld_user
IDENTIFIED BY StrongPassword123
DEFAULT TABLESPACE foreignworld_ts
QUOTA UNLIMITED ON foreignworld_ts;


GRANT CONNECT TO foreignworld_user;
GRANT RESOURCE TO foreignworld_user;
GRANT CREATE SESSION TO foreignworld_user;
GRANT CREATE TABLE TO foreignworld_user;
GRANT CREATE VIEW TO foreignworld_user;
GRANT CREATE SEQUENCE TO foreignworld_user;
GRANT CREATE PROCEDURE TO foreignworld_user;