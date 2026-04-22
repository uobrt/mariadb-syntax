-- SYNTAX TEST "source.mariadb" "standalone JOIN must highlight (upstream #23/#36/partial #28)"

-- Bare JOIN (no LEFT/RIGHT/INNER/CROSS/NATURAL modifier) must be highlighted as DML.
SELECT * FROM a JOIN b ON a.id = b.a_id;
-- <- keyword.other.DML.mariadb
--              ^^^^ keyword.other.DML.mariadb

-- Sanity: modifier-prefixed joins still work.
SELECT * FROM a LEFT JOIN b ON a.id = b.a_id;
--              ^^^^^^^^^ keyword.other.DML.mariadb

SELECT * FROM a INNER JOIN b ON a.id = b.a_id;
--              ^^^^^^^^^^ keyword.other.DML.mariadb
