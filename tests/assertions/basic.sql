-- SYNTAX TEST "source.mariadb" "common SELECT patterns"

SELECT COUNT(*) AS cpt FROM my_table;
-- <- keyword.other.DML.mariadb
--     ^^^^^ support.function.aggregate.mariadb
--           ^ keyword.operator.star.mariadb
--              ^^ keyword.other.alias.mariadb
--                     ^^^^ keyword.other.DML.mariadb

DELETE FROM users;
-- <- keyword.other.DML.mariadb
--     ^^^^ keyword.other.DML.mariadb

UPDATE users SET active = 0;
-- <- keyword.other.DML.mariadb
--           ^^^ keyword.other.DML.mariadb
--                      ^ keyword.operator.comparison.mariadb
--                        ^ constant.numeric.mariadb
