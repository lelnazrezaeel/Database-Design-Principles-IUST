-- Elnaz Rezaii 

CREATE DATABASE Company;
USE Company;

CREATE TABLE roles(
   role_id int PRIMARY KEY,
   role_name VARCHAR (255) UNIQUE NOT NULL
);

CREATE TABLE Person (
    Id int PRIMARY KEY,
    LastName varchar(255),
    FirstName varchar(255),
    Nationalcode varchar(255),
    parent_id int,
    role_id int NOT NULL,
    FOREIGN KEY (role_id)
      REFERENCES roles (role_id),
    FOREIGN KEY (parent_id)
        REFERENCES Person (Id)
);


-- 3
GO
CREATE FUNCTION get_children (@Id INTEGER)
RETURNS TABLE
AS
RETURN 
	WITH cte AS (
	SELECT p.* FROM PERSON as p
	WHERE p.Id = @Id
	UNION ALL
	SELECT p.* from PERSON as p
	INNER JOIN cte AS c ON p.parent_id = c.Id)
	SELECT * FROM cte WHERE cte.id != @Id;
GO


-- 1
-- we can define a view to limit access of the data to only parent nodes
--CREATE VIEW company_view as
--WITH u AS (
--    SELECT p.Id, r.role_name FROM Person AS p JOIN roles AS r ON p.role_id = r.role_id
--    WHERE p.FirstName = CURRENT_USER
--)
--CASE WHEN u.role_name = 'HRM' THEN
--    SELECT *
--    FROM Person 
--ELSE
--    get_children(u.Id)
--END;

--CREATE VIEW company_view as
--WITH u AS (
--    SELECT p.Id, r.role_name FROM Person AS p JOIN roles AS r ON p.role_id = r.role_id
--    WHERE p.FirstName = CURRENT_USER
--)
--CASE WHEN u.role_name = 'HRM' THEN
--    SELECT *
--    FROM Person 
--ELSE
--    get_children(u.Id)
--END;



-- 4
GO
CREATE PROCEDURE transfer_positions (
    @Id1 int,
    @Id2 int
)
AS
BEGIN
    -- change parents
    UPDATE Person
    SET parent_id = @Id2
    WHERE Id = @Id1;

    UPDATE Person
    SET parent_id = @Id1
    WHERE Id = @Id2;
    
	-- change roles
    UPDATE Person
    SET role_id = (SELECT role_id FROM Person WHERE Id = @Id2)
    WHERE Id = @Id1;
    
	UPDATE Person
    SET role_id = (SELECT role_id FROM Person WHERE Id = @Id1)
    WHERE Id = @Id2;
END;
GO

-- 5
CREATE PROCEDURE conditional_delete (
    @Id1 int,
    @Id2 int
)
AS
-- check if the id1 person has children change child parent to Id2
BEGIN
    IF EXISTS (SELECT * FROM Person WHERE parent_id = @Id1)
    BEGIN
        UPDATE Person
        SET parent_id = @Id2
        WHERE parent_id = @Id1;
    END;
    -- delete the id1 person
    DELETE FROM Person
    WHERE Id = @Id1;
END;


-- 6
GO
CREATE PROCEDURE add_person (
    @Id int,
    @LastName varchar(255),
    @FirstName varchar(255),
    @Nationalcode varchar(255),
    @parent_id int,
    @role_name varchar(255)
)
AS
BEGIN
    INSERT INTO Person (Id, LastName, FirstName, Nationalcode, parent_id, role_id)
    VALUES (@Id, @LastName, @FirstName, @Nationalcode, @parent_id, (SELECT role_id FROM roles WHERE role_name = @role_name));
END;


-- 7
INSERT INTO roles (role_id, role_name) VALUES (1, 'CEO'); 
INSERT INTO roles (role_id, role_name) VALUES (2, 'HRM');
INSERT INTO roles (role_id, role_name) VALUES (3, 'FM');
INSERT INTO roles (role_id, role_name) VALUES (4, 'TM');
INSERT INTO roles (role_id, role_name) VALUES (5, 'E');

INSERT INTO Person (Id, LastName, FirstName, Nationalcode, parent_id, role_id) VALUES
(1, 'Jafari', 'Ali', '1234567890', NULL, 1),
(2, 'Kazemi', 'Zahra', '1236547524', 1, 2),
(3, 'Akbari', 'Saleh', '1236523654', 1, 3),
(4, 'Bageri', 'Reza', '1246578125', 1, 4),
(5, 'Ahmadi', 'Sina', '4512547856', 3, 5),
(6, 'Zare', 'Melika', '2365478941', 4, 5),
(7, 'Askari', 'Maryam', '1230212015', 4, 5),
(8, 'Moradi', 'Mehrdad', '1203201458', 4, 5);

