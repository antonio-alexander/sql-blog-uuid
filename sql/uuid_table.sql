-- DROP DATABASE IF EXISTS employee_table;
CREATE DATABASE IF NOT EXISTS employee_table;

USE employee_table;

-- DROP TABLE IF EXISTS employee
CREATE TABLE IF NOT EXISTS employee (
    id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    employee_first_name TEXT,
    employee_last_name TEXT,
    employee_email_address TEXT NOT NULL,
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
    employee_uuid TEXT(36) NOT NULL DEFAULT (uuid()),
    employee_id BIGINT NOT NULL,
    PRIMARY KEY (employee_id, employee_uuid(36)),
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE,
    INDEX(employee_id, employee_uuid(36))
) ENGINE = InnoDB;

-- KIM: This trigger avoids having to generate the uuid manually and
--  prevents data inconsistency where an employee could exist without
--  a uuid
-- DROP TRIGGER IF EXISTS employee_insert_uuid
-- DELIMITER $$
-- CREATE TRIGGER employee_insert_uuid
-- AFTER INSERT
--     ON employee FOR EACH ROW BEGIN
-- INSERT INTO employee_uuid(employee_id, employee_uuid)
--     VALUES(new.id, UUID());
-- END $$
-- DELIMITER ;