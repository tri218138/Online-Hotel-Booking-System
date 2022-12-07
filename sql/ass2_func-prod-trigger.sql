USE HotelBooking;

-- Create a trigger that check if a user is older than 18 years old
DROP PROCEDURE IF EXISTS prod_check_age;
DROP TRIGGER IF EXISTS tr_check_age_ins;
DROP TRIGGER IF EXISTS tr_check_age_upd;
CREATE PROCEDURE prod_check_age(birthyear INT)
BEGIN
    IF birthyear > YEAR(CURDATE()) - 18 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User must be older than 18 years old'
    END IF
END
delimiter ;
CREATE TRIGGER tr_check_age_ins
    AFTER INSERT
    ON users
    FOR EACH ROW
BEGIN
    CALL prod_check_age(NEW.birth_year)
END
delimiter ;
CREATE TRIGGER tr_check_age_upd
    AFTER UPDATE
    ON users
    FOR EACH ROW
BEGIN
    CALL prod_check_age(NEW.birth_year)
END
delimiter ;

-- Test the trigger
-- Insert
INSERT INTO users (email, birth_year, phone_number, first_name, last_name, citizen_id)
VALUES ('abc@example.com', 2010, '0123456789', 'John', 'Doe', '123456789012');
-- Update
INSERT INTO users (id, sex, email, birth_year, phone_number, first_name, last_name, citizen_id)
VALUES ('9b2f22b1-9bd2-48b3-90b7-6e52cb9df9d6', 'M', 'abc@example.com', 2000, '0123456789', 'John', 'Doe',
        '123456780123');
UPDATE users
SET birth_year = 2010
WHERE email = 'abc@example.com';

-- Create a trigger that check if check-in date is before check-out date and if the check-in date is not in the past.
DROP TRIGGER IF EXISTS tr_check_dates_ins;
DROP TRIGGER IF EXISTS tr_check_dates_upd;
CREATE TRIGGER tr_check_dates_ins
    BEFORE INSERT
    ON bookings
    FOR EACH ROW
BEGIN
    IF NEW.check_in < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Check-in date must not be in the past'
    END IF
END
delimiter ;
CREATE TRIGGER tr_check_dates_upd
    BEFORE UPDATE
    ON bookings
    FOR EACH ROW
BEGIN
    IF NEW.check_in < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Check-in date must not be in the past'
    END IF
END
delimiter ;
-- Test the trigger
-- Insert
INSERT INTO users (id, sex, email, birth_year, phone_number, first_name, last_name, citizen_id)
VALUES ('276b252d-5ae5-48e8-ace8-92eaf84bfc89', 'M', 'def@example.com', 1990, '0123456780', 'John', 'X',
        '123456790124');
INSERT INTO bookings (user_id, check_in, check_out)
VALUES ('276b252d-5ae5-48e8-ace8-92eaf84bfc89', '2020-01-01', '2020-01-02');
INSERT INTO bookings (user_id, check_in, check_out)
VALUES ('276b252d-5ae5-48e8-ace8-92eaf84bfc89', '2020-01-02', '2020-01-01');
-- Update
INSERT INTO bookings (id, user_id, check_in, check_out)
VALUES ('6870de7b-c89f-40fe-864f-bed54b856066', '276b252d-5ae5-48e8-ace8-92eaf84bfc89', '2023-12-31', '2024-01-02');
UPDATE bookings
SET check_in = '2020-01-02'
WHERE id = '6870de7b-c89f-40fe-864f-bed54b856066';

-- Create a trigger that update timestamp when a booking is updated
DROP TRIGGER IF EXISTS tr_update_timestamp_bookings_upd;
CREATE TRIGGER tr_update_timestamp_bookings_upd
    BEFORE UPDATE
    ON bookings
    FOR EACH ROW
BEGIN
    SET NEW.`timestamp` = CURRENT_TIMESTAMP
END
delimiter ;
-- Test the trigger
INSERT INTO users (id, sex, email, birth_year, phone_number, first_name, last_name, citizen_id)
VALUES ('276b252d-5ae5-48e8-ace8-92eaf84bfc89', 'M', 'def@example.com', 1990, '0123456780', 'John', 'X',
        '123456790124');
INSERT INTO bookings (id, user_id, check_in, check_out)
VALUES ('40e0e66e-150d-442d-85b3-0c4200d5c7d7', '276b252d-5ae5-48e8-ace8-92eaf84bfc89', '2023-01-01', '2023-01-02');
UPDATE bookings
SET check_out = '2023-04-02'
WHERE id = '40e0e66e-150d-442d-85b3-0c4200d5c7d7';
SELECT *
FROM bookings
WHERE id = '40e0e66e-150d-442d-85b3-0c4200d5c7d7';


-- Write a function that returns the number of admins working in the specific cluster
DROP FUNCTION IF EXISTS func_count_admins;
CREATE FUNCTION func_count_admins(cluster_no INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE count INT
    SELECT COUNT(*)
    INTO count
    FROM admins a
    WHERE a.cluster_no = cluster_no
    RETURN count
END
delimiter ;

-- Test the function
SELECT func_count_admins(1);

-- Write a function that returns the number of available rooms in the specific hotel
DROP FUNCTION IF EXISTS func_count_available_rooms;
CREATE FUNCTION func_count_available_rooms(hotel_no VARCHAR(36))
    RETURNS INT
    READS SQL DATA
BEGIN
    DECLARE count INT
    SELECT COUNT(*)
    INTO count
    FROM rooms r
    WHERE r.hotel_id = hotel_no
      AND r.`status` = 'AVAILABLE'
    RETURN count
END
delimiter ;
-- Test the function
SELECT func_count_available_rooms('b9f2c2f0-5c1f-4b9c-9c1f-2c2f0b9c9c1f');

-- Write a procedure that returns the number of bookings grouped by user
DROP PROCEDURE IF EXISTS prod_count_bookings;
CREATE PROCEDURE prod_count_bookings()
BEGIN
    SELECT u.id, COUNT(IFNULL(b.id, 0)) AS num_bookings
    FROM users u
             LEFT JOIN bookings b ON u.id = b.user_id
    GROUP BY u.id
END
delimiter ;
-- Test the procedure
CALL prod_count_bookings();

-- Write a procedure that check the username and return the hashed password & salt
DROP PROCEDURE IF EXISTS prod_check_login;
CREATE PROCEDURE prod_check_login(username VARCHAR(50))
BEGIN
    DECLARE id VARCHAR(36)
    DECLARE hashed_password VARCHAR(512)
    DECLARE salt VARCHAR(512)
    SELECT id, hashed_password, salt
    INTO id, hashed_password, salt
    FROM login
    WHERE login.username = username
    IF id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Username does not exist'
    END IF
    # Return the hashed password and salt
    SELECT hashed_password, salt
END
delimiter ;

-- Test the procedure
CALL prod_check_login('admin');