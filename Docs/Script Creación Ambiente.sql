-- Creaci�n de tablespaces
CREATE TABLESPACE TS_TDM_DATA LOGGING 
     DATAFILE 'C:\APPS\ORACLEXE\APP\ORACLE\ORADATA\XE\TS_TDM_DATA.DBF' 
     SIZE 50M REUSE AUTOEXTEND ON NEXT 1280K MAXSIZE UNLIMITED 
     EXTENT MANAGEMENT LOCAL;
     
CREATE TABLESPACE TS_TDM_INDEX LOGGING 
     DATAFILE 'C:\APPS\ORACLEXE\APP\ORACLE\ORADATA\XE\TS_TDM_INDEX.DBF' 
     SIZE 20M REUSE AUTOEXTEND ON NEXT 1280K MAXSIZE UNLIMITED 
     EXTENT MANAGEMENT LOCAL;


-- Creaci�n de Esquemas
CREATE USER ADMTDM
  IDENTIFIED BY pwdadmtdlm
  DEFAULT TABLESPACE TS_TDM_DATA
  QUOTA 20M on TS_TDM_DATA;

ALTER USER ADMTDM QUOTA 50M ON TS_TDM_INDEX;

ALTER USER ADMTDM QUOTA 100M ON TS_TDM_DATA;

CREATE USER USRTDM
  IDENTIFIED BY pwdusrtdlm
  DEFAULT TABLESPACE TS_TDM_DATA
  QUOTA 20M on TS_TDM_DATA; 

-- Otorgar privilegios  
GRANT create session TO ADMTDM;
GRANT create table TO ADMTDM;
GRANT create view TO ADMTDM;
GRANT create any trigger TO ADMTDM;
GRANT create any procedure TO ADMTDM;
GRANT create sequence TO ADMTDM;
GRANT create synonym TO ADMTDM;

GRANT create session TO USRTDM;