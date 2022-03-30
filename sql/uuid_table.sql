-- DROP DATABASE IF EXISTS sql_blog_uuid;
CREATE DATABASE IF NOT EXISTS sql_blog_uuid;

USE sql_blog_uuid;

-- DROP TABLE IF EXISTS employee
CREATE TABLE IF NOT EXISTS employee (
    id BIGINT NOT NULL AUTO_INCREMENT,
    employee_first_name TEXT,
    employee_last_name TEXT,
    employee_email_address TEXT NOT NULL,
    PRIMARY KEY id,
    UNIQUE(employee_email_address)
) ENGINE = InnoDB;

-- KIM: if you're not running at least MYSQL 8.0 you may not be able to have a default
-- REFERENCE: https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html
-- KIM: this table doesn't require any manual inserts/updates on the assumption that
--  you never change the primary key for employees AND you never attempt to update
--  this table manually, the ON DELETE CASCADE will automatically clean up any entries
--  that don't belong to existing employees
-- DROP TABLE IF EXISTS employee_uuid
CREATE TABLE IF NOT EXISTS employee_uuid (
    uuid TEXT(36) PRIMARY KEY NOT NULL DEFAULT (uuid()),
    -- KIM: if you're not running at least MYSQL 8.0 you may not be able to have a default
    -- REFERENCE: https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html
    -- uuid TEXT(36) PRIMARY KEY NOT NULL,
    employee_id BIGINT NOT NULL,
    PRIMARY KEY (uuid(36)),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
    UNIQUE(uuid, employee_id)
) ENGINE = InnoDB;

-- KIM: This trigger avoids having to generate the uuid manually and
--  prevents data inconsistency where an employee could exist without
--  a uuid
-- DROP TRIGGER IF EXISTS employee_insert_uuid
DELIMITER $$
CREATE TRIGGER employee_insert_uuid
AFTER INSERT
    ON employee FOR EACH ROW BEGIN
INSERT INTO employee_uuid(employee_id, uuid)
    VALUES(new.id, UUID());
END $$
DELIMITER ;

-- DROP VIEW IF EXISTS employee_v1
CREATE VIEW employee_v1 AS
    SELECT
        uuid, employee_first_name, employee_last_name, employee_email_address
    FROM employee
    JOIN employee_uuid ON id;