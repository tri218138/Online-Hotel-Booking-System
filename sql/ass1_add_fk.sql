USE HotelBooking;

ALTER TABLE login
    ADD FOREIGN KEY (id) REFERENCES users (id);
ALTER TABLE admins
    ADD FOREIGN KEY (admin_id) REFERENCES users (id);
ALTER TABLE hotel_phone
    ADD FOREIGN KEY (hotel_id) REFERENCES hotels (id);
ALTER TABLE payment_acc_hotel
    ADD FOREIGN KEY (hotel_id) REFERENCES hotels (id);
ALTER TABLE hotel_timing
    ADD FOREIGN KEY (hotel_id) REFERENCES hotels (id);
ALTER TABLE booking_revision
    ADD FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE booking_revision
    ADD FOREIGN KEY (admin_id) REFERENCES users (id);
ALTER TABLE bookings
    ADD FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE bills
    ADD FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE bills
    ADD FOREIGN KEY (admin_id) REFERENCES users (id);
ALTER TABLE payment
    ADD FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE payment
    ADD FOREIGN KEY (cid) REFERENCES customers (cid);
ALTER TABLE booking_rooms
    ADD FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE booking_rooms
    ADD FOREIGN KEY (room_no) REFERENCES rooms (room_no);
ALTER TABLE booking_rooms
    ADD FOREIGN KEY (hotel_id) REFERENCES hotels (id);
ALTER TABLE rooms
    ADD FOREIGN KEY (hotel_id) REFERENCES hotels (id);
ALTER TABLE payment_acc_customer
    ADD FOREIGN KEY (cid) REFERENCES customers (cid);
ALTER TABLE customers
    ADD FOREIGN KEY (cid) REFERENCES users (id);