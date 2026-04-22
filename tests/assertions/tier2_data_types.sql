-- SYNTAX TEST "source.mariadb" "bare data types must highlight without a (N) suffix"

-- On jlb/2.0 TINYINT and FLOAT only match with a (\d+) suffix, and MEDIUMINT/DECIMAL/ENUM are absent.
CREATE TABLE t (
  a TINYINT,
--  ^^^^^^^ storage.type.mariadb
  b MEDIUMINT,
--  ^^^^^^^^^ storage.type.mariadb
  c DECIMAL,
--  ^^^^^^^ storage.type.mariadb
  d FLOAT,
--  ^^^^^ storage.type.mariadb
  e ENUM('x','y')
--  ^^^^ storage.type.mariadb
);
