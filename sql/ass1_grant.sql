USE HotelBooking;

CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'customer';
CREATE ROLE IF NOT EXISTS 'db_admin';

-- Entire database
GRANT ALL ON HotelBooking.* TO 'db_admin';

-- `users` table
GRANT INSERT, SELECT, UPDATE, DELETE ON users TO 'admin';
GRANT INSERT, SELECT, UPDATE, DELETE ON users TO 'customer';

-- `hotels` table
GRANT INSERT, SELECT, UPDATE, DELETE ON hotels TO 'admin';
GRANT SELECT ON hotels TO 'customer';

-- `rooms` table
GRANT INSERT, SELECT, UPDATE, DELETE ON rooms TO 'admin';
GRANT SELECT ON rooms TO 'customer';

-- `bookings` table
GRANT INSERT, SELECT, UPDATE, DELETE ON bookings TO 'admin';
GRANT INSERT, SELECT, DELETE ON bookings TO 'customer';

-- `booking_rooms` table
GRANT INSERT, SELECT, UPDATE, DELETE ON booking_rooms TO 'admin';
GRANT SELECT ON booking_rooms TO 'customer';

-- `customers` table
GRANT INSERT, SELECT, UPDATE, DELETE ON customers TO 'admin';
GRANT SELECT ON customers TO 'customer';

-- `admins` table
GRANT SELECT ON admins TO 'admin';

-- `login` table
GRANT INSERT, SELECT, UPDATE, DELETE ON login TO 'admin';
GRANT INSERT, SELECT, UPDATE, DELETE ON login TO 'customer';

-- `payment_acc_customer` table
GRANT INSERT, SELECT, UPDATE, DELETE ON payment_acc_customer TO 'admin';
GRANT INSERT, SELECT, UPDATE, DELETE ON payment_acc_customer TO 'customer';

-- `payment_acc_hotel` table
GRANT INSERT, SELECT, UPDATE, DELETE ON payment_acc_hotel TO 'admin';
GRANT SELECT ON payment_acc_hotel TO 'customer';

-- `bills` table
GRANT INSERT, SELECT, UPDATE, DELETE ON bills TO 'admin';
GRANT SELECT, UPDATE ON bills TO 'customer';

-- `hotel_phone` table
GRANT INSERT, SELECT, UPDATE, DELETE ON hotel_phone TO 'admin';
GRANT SELECT ON hotel_phone TO 'customer';

-- `hotel_timing` table
GRANT INSERT, SELECT, UPDATE, DELETE ON hotel_timing TO 'admin';
GRANT SELECT ON hotel_timing TO 'customer';

-- `booking_revision` table
GRANT INSERT, SELECT, UPDATE, DELETE ON booking_revision TO 'admin';
GRANT SELECT ON booking_revision TO 'customer';

-- `payment` table
GRANT INSERT, SELECT, UPDATE, DELETE ON payment TO 'admin';
GRANT SELECT ON payment TO 'customer';
