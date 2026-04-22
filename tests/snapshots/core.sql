-- Core MariaDB syntax regression snapshot.
-- Any change here should be reviewed token-by-token via `./test.sh`.

SELECT id, name, created_at
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.active = 1
  AND name LIKE 'a%'
  AND created_at IS NOT NULL
GROUP BY u.id
ORDER BY created_at DESC
LIMIT 10;

INSERT INTO users (id, name) VALUES (1, 'alice');

UPDATE users SET active = 0 WHERE id = 42;

DELETE FROM users WHERE id = 7;

CREATE TABLE foo (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  note TEXT
);

/* block comment */
# hash comment
-- dash comment
