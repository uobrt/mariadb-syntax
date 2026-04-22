-- SYNTAX TEST "source.mariadb" "AS clause must not leak into following tokens (upstream #14/#20/#24/#28/#35/#39)"

-- Canonical bug: a string literal after `AS 'alias'` was getting mis-scoped.
SELECT foo AS 'bar', 'baz' FROM t WHERE x = 'qux';
-- <- keyword.other.DML.mariadb
--         ^^ keyword.other.alias.mariadb
--            ^^^^^ string.quoted.single.mariadb
--                   ^^^^^ string.quoted.single.mariadb
--                                          ^^^^^ string.quoted.single.mariadb

-- Same shape with a double-quoted alias.
SELECT foo AS "bar", 'baz' FROM t;
--         ^^ keyword.other.alias.mariadb
--            ^^^^^ string.quoted.double.mariadb
--                   ^^^^^ string.quoted.single.mariadb

-- Same shape with a backtick-quoted alias.
SELECT foo AS `bar`, 'baz' FROM t;
--         ^^ keyword.other.alias.mariadb
--            ^^^^^ string.quoted.other.backtick.mariadb
--                   ^^^^^ string.quoted.single.mariadb
