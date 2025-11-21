--SAIRE TELLO FERNANDO JOSE

create tablespace bdtareita1
datafile 'D:\Dosdescargas\bdtareita1_01.dbf' size 30m
autoextend on next 5m maxsize 45m
extent management local
segment space management manual
logging;

--COMENTARIO 1
create temporary tablespace temp_bdtareita1
tempfile 'D:\Dosdescargas\temp_bdtareita101.dbf' size 20m
extent management local
uniform size 2m;

CREATE TABLE S (
  "S#"    VARCHAR2(5)    CONSTRAINT PK_S PRIMARY KEY,
  SNAME   VARCHAR2(20)   CONSTRAINT NN_S_SNAME  NOT NULL,
  STATUS  NUMBER(3)      CONSTRAINT CHK_S_STATUS CHECK (STATUS BETWEEN 0 AND 100),
  CITY    VARCHAR2(20)   CONSTRAINT NN_S_CITY   NOT NULL
)
TABLESPACE bdtareita1;

INSERT INTO S("S#",SNAME,STATUS,CITY) VALUES ('S1','Smith',20,'London');
INSERT INTO S("S#",SNAME,STATUS,CITY) VALUES ('S2','Jones',10,'Paris');
INSERT INTO S("S#",SNAME,STATUS,CITY) VALUES ('S3','Blake',30,'Paris');
INSERT INTO S("S#",SNAME,STATUS,CITY) VALUES ('S4','Clark',20,'London');
INSERT INTO S("S#",SNAME,STATUS,CITY) VALUES ('S5','Adams',30,'Athens');

COMMIT;

CREATE TABLE P (
    "P#" VARCHAR2(5) CONSTRAINT PK_P PRIMARY KEY,
    PNAME   VARCHAR2(20)   CONSTRAINT NN_P_PNAME  NOT NULL,
    COLOR   VARCHAR2(20)   CONSTRAINT NN_P_COLOR  NOT NULL,
    WEIGHT NUMBER(3) CONSTRAINT NN_P_WEIGHT NOT NULL,
    CITY    VARCHAR2(20)   CONSTRAINT NN_P_CITY   NOT NULL
)TABLESPACE bdtareita1;

INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P1','Nut','Red',12,'London');
INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P2','Bolt','Green',17,'Paris');
INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P3','Screw','Blue',17,'Rome');
INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P4','Screw','Red',14,'London');
INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P5','Cam','Blue',12,'Paris');
INSERT INTO P("P#", PNAME, COLOR, WEIGHT, CITY) VALUES ('P6','Cog','Red',19,'London');

COMMIT;

CREATE TABLE J (
  "J#"   VARCHAR2(5)  CONSTRAINT PK_J PRIMARY KEY,
  JNAME  VARCHAR2(20) CONSTRAINT NN_J_JNAME NOT NULL,
  CITY   VARCHAR2(20) CONSTRAINT NN_J_CITY  NOT NULL
) TABLESPACE bdtareita1;

INSERT INTO J("J#", JNAME, CITY) VALUES ('J1','Sorter', 'Paris');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J2','Display','Rome');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J3','OCR',    'Athens');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J4','Console','Athens');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J5','RAID',   'London');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J6','EDS',    'Oslo');
INSERT INTO J("J#", JNAME, CITY) VALUES ('J7','Tape',   'London');

COMMIT;

CREATE TABLE SPJ (
  "S#"  VARCHAR2(5)  CONSTRAINT NN_SPJ_S NOT NULL,
  "P#"  VARCHAR2(5)  CONSTRAINT NN_SPJ_P NOT NULL,
  "J#"  VARCHAR2(5)  CONSTRAINT NN_SPJ_J NOT NULL,
  QTY   NUMBER(10)   CONSTRAINT CHK_SPJ_QTY CHECK (QTY > 0) NOT NULL,
  CONSTRAINT PK_SPJ PRIMARY KEY ("S#", "P#", "J#"),
  CONSTRAINT FK_SPJ_S FOREIGN KEY ("S#") REFERENCES S("S#"),
  CONSTRAINT FK_SPJ_P FOREIGN KEY ("P#") REFERENCES P("P#"),
  CONSTRAINT FK_SPJ_J FOREIGN KEY ("J#") REFERENCES J("J#")
) TABLESPACE bdtareita1;

INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S1','P1','J1',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S1','P1','J4',700);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J1',400);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J2',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J3',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J4',500);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J5',600);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J6',400);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P3','J7',800);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S2','P5','J2',100);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S3','P3','J1',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S3','P4','J2',500);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S4','P6','J3',300);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S4','P6','J7',300);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P2','J2',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P2','J4',100);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P5','J5',500);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P5','J2',100);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P6','J2',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P1','J4',100);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P3','J4',200);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P4','J4',800);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P5','J4',300);
INSERT INTO SPJ("S#","P#","J#",QTY) VALUES ('S5','P6','J4',500);

COMMIT;

--Obtenga el color y ciudad para las partes que no son de París, con un peso mayor de diez.
CREATE OR REPLACE FUNCTION get_parts_color_city_not_paris(
  p_excluded_city IN VARCHAR2 DEFAULT 'Paris',
  p_min_weight    IN NUMBER   DEFAULT 10
) RETURN SYS_REFCURSOR
IS
  l_cursor SYS_REFCURSOR;   
BEGIN
  OPEN l_cursor FOR
    SELECT DISTINCT COLOR, CITY
    FROM   P
    WHERE  WEIGHT > p_min_weight
       AND CITY <> p_excluded_city;
  RETURN l_cursor;
END;
/

---Esto es para hacer que corra el FUNCTION,lo puse como comentario
/*VAR c REFCURSOR                   
EXEC :c := get_parts_color_city_not_paris;
PRINT c;*/

--Para todas las partes, obtenga el número de parte y el peso de dichas partes en gramos.
CREATE OR REPLACE FUNCTION get_parts_number_weight(
    p_factor IN NUMBER DEFAULT 453.592,
    P_decimal IN INTEGER DEFAULT 2
) RETURN SYS_REFCURSOR
IS
    num_cursor SYS_REFCURSOR;
BEGIN
    OPEN num_cursor FOR
    SELECT "P#",ROUND(WEIGHT*p_factor,p_decimal) AS "Peso en gramos"
    FROM P;
    RETURN num_cursor;
END;
/
/*VAR c REFCURSOR
EXEC :c := get_parts_number_weight;  
PRINT c;*/

--Obtenga el detalle completo de todos los proveedores.
CREATE OR REPLACE FUNCTION get_suppliers_detail
RETURN SYS_REFCURSOR
IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT "S#" AS supplier_no, SNAME, STATUS, CITY
    FROM   S
    ORDER  BY "S#";
  RETURN l_cur;
END;
/

--VAR c REFCURSOR
--EXEC :c :get_suppliers_detail;
--PRINT c;

--Obtenga todas las combinaciones de proveedores y partes para aquellos proveedores y partes co-localizados.

CREATE OR REPLACE FUNCTION get_supplier_part_colocated
RETURN SYS_REFCURSOR
IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT s."S#"  AS supplier_no,
           s.SNAME,
           p."P#"  AS part_no,
           p.PNAME,
           s.CITY  AS city
    FROM   S s
    JOIN   P p
      ON   UPPER(s.CITY) = UPPER(p.CITY)
    ORDER  BY s."S#", p."P#";
  RETURN l_cur;
END;
/
--VAR c REFCURSOR
--EXEC :c :get_supplier_part_colocated;
--PRINT c;
/*Obtenga todos los pares de nombres de ciudades de tal forma que el proveedor localizado 
en la primera ciudad del par abastece una parte almacenada en la segunda ciudad del par.*/

CREATE OR REPLACE FUNCTION get_supplier_part_city_par
RETURN SYS_REFCURSOR
IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT DISTINCT
           s.CITY AS supplier_city,
           p.CITY AS part_city
    FROM   SPJ j
    JOIN   S   s ON s."S#" = j."S#"
    JOIN   P   p ON p."P#" = j."P#"
    ORDER  BY supplier_city, part_city;
  RETURN l_cur;
END;
/   

--Obtenga todos los pares de número de proveedor tales que los dos proveedores del par estén co-localizados.
CREATE OR REPLACE FUNCTION get_colocated_supplier_pairs
RETURN SYS_REFCURSOR
IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT s1."S#" AS supplier1,
           s2."S#" AS supplier2,
           s1.CITY AS city
    FROM   S s1
    JOIN   S s2
      ON   UPPER(s1.CITY) = UPPER(s2.CITY)
     AND  s1."S#" < s2."S#";
  RETURN l_cur;
END;
/

--VAR c REFCURSOR
--EXEC :c :get_colocated_supplier_pairs;
--PRINT c;

--Obtenga el número total de proveedores.
CREATE OR REPLACE PROCEDURE obtener_proveedores(
    p_num_proveedores OUT number
) AS
 BEGIN
 SELECT COUNT(*) 
 INTO p_num_proveedores
 FROM S;
 END obtener_proveedores;
/

/*VAR n NUMBER
EXEC obtener_proveedores(:n);
PRINT n;*/

--Obtenga la cantidad mínima y la cantidad máxima para la parte P2.
CREATE OR REPLACE PROCEDURE get_min_max_qty_for_part(
  p_part IN  VARCHAR2,
  p_min  OUT NUMBER,
  p_max  OUT NUMBER
) AS
BEGIN
  SELECT MIN(QTY), MAX(QTY)
  INTO   p_min, p_max
  FROM   SPJ
  WHERE  "P#" = p_part;
END get_min_max_qty_for_part;
/

/*VAR vmin NUMBER
VAR vmax NUMBER
EXEC get_min_max_qty_for_part('P2', :vmin, :vmax);
PRINT vmin
PRINT vmax*/

--Para cada parte abastecida, obtenga el número de parte y el total despachado.
CREATE OR REPLACE FUNCTION get_total_despachado_por_parte
RETURN SYS_REFCURSOR
IS
  l_cur SYS_REFCURSOR;
BEGIN
  OPEN l_cur FOR
    SELECT spj."P#" AS part_no,
           SUM(spj.QTY) AS total_despachado
    FROM   SPJ spj
    GROUP  BY spj."P#"
    ORDER  BY spj."P#";
  RETURN l_cur;
END;
/
--Obtenga el número de parte para todas las partes abastecidas por más de
--un proveedor.
CREATE OR REPLACE FUNCTION get_parts_with_multiple_suppliers
RETURN SYS_REFCURSOR
IS
  c SYS_REFCURSOR;
BEGIN
  OPEN c FOR
    SELECT spj."P#" AS part_no
    FROM   SPJ spj
    GROUP  BY spj."P#"
    HAVING COUNT(DISTINCT spj."S#") > 1
    ORDER  BY part_no;
  RETURN c;
END;
/

--Obtenga el nombre de proveedor para todos los proveedores que abastecen
--la parte P2.
CREATE OR REPLACE FUNCTION get_suppliers_for_part(
  p_part IN VARCHAR2 DEFAULT 'P2'
) RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT s.SNAME
    FROM   S   s
    JOIN   SPJ j ON j."S#" = s."S#"
    WHERE  j."P#" = p_part
    ORDER  BY s.SNAME;
  RETURN rc;
END;
/

--Obtenga el nombre de proveedor de quienes abastecen por lo menos una parte.
CREATE OR REPLACE FUNCTION abastecer_almenos
RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT DISTINCT s.SNAME
    FROM   S   s
    JOIN   SPJ j ON j."S#" = s."S#";
  RETURN rc;
END abastecer_almenos;
/

--Obtenga el número de proveedor para los proveedores con estado menor
--que el máximo valor de estado en la tabla S.
CREATE OR REPLACE FUNCTION get_suppliers_status_below_max
RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s."S#" AS supplier_no
    FROM   S s
    WHERE  s.STATUS < (SELECT MAX(STATUS) FROM S)
    ORDER  BY s."S#";
  RETURN rc;
END;
/

--Obtenga el nombre de proveedor para los proveedores que abastecen la
--parte P2 (aplicar EXISTS en su solución).
CREATE OR REPLACE FUNCTION get_suppliers_for_P2_exists
RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s.SNAME
    FROM   S s
    WHERE  EXISTS (
      SELECT 1
      FROM   SPJ j
      WHERE  j."S#" = s."S#"
      AND    j."P#" = 'P2'
    )
    ORDER BY s.SNAME;
  RETURN rc;
END;
/


--Obtenga el nombre de proveedor para los proveedores que no abastecen la
--parte P2.

CREATE OR REPLACE FUNCTION get_suppliers_not_P2(
  p_require_any_shipment IN CHAR DEFAULT 'N'  -- 'Y' para exigir que abastezca algo
) RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  IF UPPER(p_require_any_shipment) = 'Y' THEN
    OPEN rc FOR
      SELECT s.SNAME
      FROM   S s
      WHERE  EXISTS (SELECT 1 FROM SPJ j WHERE j."S#" = s."S#")
      AND    NOT EXISTS (SELECT 1 FROM SPJ j WHERE j."S#" = s."S#" AND j."P#" = 'P2')
      ORDER  BY s.SNAME;
  ELSE
    OPEN rc FOR
      SELECT s.SNAME
      FROM   S s
      WHERE  NOT EXISTS (SELECT 1 FROM SPJ j WHERE j."S#" = s."S#" AND j."P#" = 'P2')
      ORDER  BY s.SNAME;
  END IF;
  RETURN rc;
END;
/

--Obtenga el nombre de proveedor para los proveedores que abastecen todas las partes.
CREATE OR REPLACE FUNCTION get_suppliers_all_parts
RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT s.SNAME
    FROM   S s
    WHERE  NOT EXISTS (
             SELECT 1
             FROM   P p
             WHERE  NOT EXISTS (
                      SELECT 1
                      FROM   SPJ j
                      WHERE  j."S#" = s."S#"
                      AND    j."P#" = p."P#"
                    )
           )
    ORDER  BY s.SNAME;
  RETURN rc;
END;
/
--Obtenga el número de parte para todas las partes que pesan más de 16 libras
--ó son abastecidas por el proveedor S2, ó cumplen con ambos criterios.
CREATE OR REPLACE FUNCTION get_parts_weight_gt16_or_S2
RETURN SYS_REFCURSOR
IS
  rc SYS_REFCURSOR;
BEGIN
  OPEN rc FOR
    SELECT p."P#" AS part_no
    FROM   P p
    WHERE  p.WEIGHT > 16
       OR  EXISTS (
             SELECT 1
             FROM   SPJ j
             WHERE  j."P#" = p."P#"
             AND    j."S#" = 'S2'
           )
    ORDER  BY part_no;
  RETURN rc;
END;
/

