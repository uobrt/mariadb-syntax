-- SYNTAX TEST "source.mariadb" "strings, numbers, operators"

SELECT 'hello', 42, `my_col` FROM t WHERE x >= 1;
-- <- keyword.other.DML.mariadb
--     ^^^^^^^ string.quoted.single.mariadb
--              ^^ constant.numeric.mariadb
--                  ^^^^^^^^ string.quoted.other.backtick.mariadb
--                                          ^^ keyword.operator.comparison.mariadb
