-- SYNTAX TEST "source.mariadb" "ON UPDATE CASCADE must highlight on FK constraints"

-- The existing grammar covers ON DELETE CASCADE but not ON UPDATE CASCADE.
CREATE TABLE child (
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES parent(id) ON UPDATE CASCADE ON DELETE CASCADE
--                                              ^^^^^^^^^^^^^^^^^ storage.modifier.mariadb
--                                                                ^^^^^^^^^^^^^^^^^ storage.modifier.mariadb
);
