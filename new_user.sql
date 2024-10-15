alter session set "_ORACLE_SCRIPT"=true; 
DROP USER cprg250;
CREATE USER cprg250
      IDENTIFIED BY password
      DEFAULT TABLESPACE users;
ALTER USER cprg250 quota unlimited on users;
GRANT CREATE SESSION, RESOURCE, CONNECT, CREATE VIEW TO cprg250;
