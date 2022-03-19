-- DROP DATABASE IF EXISTS employee_optimized;
CREATE DATABASE IF NOT EXISTS employee_optimized;

USE employee_optimized;

-- DROP TABLE IF EXISTS employee
CREATE TABLE IF NOT EXISTS employee (
    id BINARY(16) PRIMARY KEY NOT NULL DEFAULT (unhex(replace(uuid(),'-',''))),
    -- KIM: if you're not running at least MYSQL 8.0 you may not be able to have a default
    -- REFERENCE: https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html
    -- id BINARY(16) PRIMARY KEY NOT NULL,
    employee_first_name TEXT,
    employee_last_name TEXT,
    employee_email_address TEXT NOT NULL,
    id_text varchar(36) generated always as
     (insert(
        insert(
          insert(
            insert(hex(id),9,0,'-'),
            14,0,'-'),
          19,0,'-'),
        24,0,'-')
     ) virtual,
    UNIQUE(employee_email_address)
) ENGINE = InnoDB;

-- KIM: if your version of mysql doesn't support using unhex(replace(uuid(),'-',''))
--   as a default, you can use a trigger to automatically fill it in if it isn't set,
--   SO for the win
-- REFERENCE: https://stackoverflow.com/questions/46134550/mysql-set-default-id-uuid
-- DROP TRIGGER IF EXISTS employee_insert_uuid
-- DELIMITER $$
-- CREATE TRIGGER `employee_insert_uuid`
-- BEFORE INSERT ON `employee` FOR EACH ROW 
-- BEGIN
--   IF new.id IS NULL THEN
--     SET new.id = unhex(replace(uuid(),'-',''));
--   END IF;
-- END $$
-- DELIMITER ;