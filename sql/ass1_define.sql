USE mysql;
CREATE DATABASE IF NOT EXISTS HotelBooking;
USE HotelBooking;

CREATE TABLE IF NOT EXISTS users
(
    id           varchar(36)                  DEFAULT (uuid()),
    sex          char(1)             NOT NULL DEFAULT 'M',
    email        varchar(254) UNIQUE NOT NULL,
    birth_year   int unsigned        NOT NULL,
    phone_number varchar(10) UNIQUE  NOT NULL,
    first_name   varchar(50)         NOT NULL,
    last_name    varchar(50)         NOT NULL,
    citizen_id   varchar(12) UNIQUE  NOT NULL,
    PRIMARY KEY (id),
    CHECK ( id REGEXP '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' ),
    CHECK ( sex IN ('M', 'F') ),
    CHECK ( birth_year BETWEEN 1900 AND 2100 ),
    CHECK ( phone_number REGEXP '^0[0-9]{9}$' ),
    CHECK ( citizen_id REGEXP '^[0-9]{12}$' ),
    CHECK ( email REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$' )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS hotels
(
    id      varchar(36) DEFAULT (uuid()),
    `name`  varchar(50)         NOT NULL,
    address varchar(100)        NOT NULL,
    `desc`  varchar(200)        NOT NULL,
    email   varchar(254) UNIQUE NOT NULL,
    rating  int unsigned        NOT NULL,
    PRIMARY KEY (id),
    CHECK ( id REGEXP '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' ),
    CHECK ( rating BETWEEN 1 AND 5 ),
    CHECK (email REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*(\\.[a-zA-Z]{2,4})+$')
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS rooms
(
    room_no  varchar(10),
    hotel_id varchar(36),
    `desc`   varchar(200) NOT NULL,
    capacity int unsigned NOT NULL,
    `status` varchar(10)  NOT NULL DEFAULT 'AVAILABLE',
    price    int unsigned NOT NULL,
    PRIMARY KEY (room_no, hotel_id),
    CHECK ( status IN ('AVAILABLE', 'BOOKED', 'MAINTENANCE') )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS bookings
(
    id            varchar(36)           DEFAULT (uuid()),
    user_id       varchar(36)  NOT NULL,
    check_in      date         NOT NULL,
    check_out     date         NOT NULL,
    `timestamp`   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reward_points int unsigned NOT NULL DEFAULT 0,
    people        int unsigned NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CHECK ( id REGEXP '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' ),
    CHECK ( check_in < check_out )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS booking_rooms
(
    booking_id varchar(36) NOT NULL,
    room_no    varchar(10) NOT NULL,
    hotel_id   varchar(36) NOT NULL,
    PRIMARY KEY (booking_id, room_no, hotel_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS customers
(
    cid    varchar(36),
    points int unsigned NOT NULL DEFAULT 0,
    PRIMARY KEY (cid)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS admins
(
    admin_id   varchar(36),
    cluster_no int unsigned NOT NULL,
    PRIMARY KEY (admin_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS login
(
    id              varchar(36),
    username        varchar(50) UNIQUE NOT NULL,
    hashed_password varchar(512)       NOT NULL,
    salt            varchar(512)       NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS payment_acc_customer
(
    cid              varchar(36),
    payment_provider varchar(100) NOT NULL,
    payment_acc      varchar(35)  NOT NULL,
    PRIMARY KEY (payment_provider, payment_acc)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS payment_acc_hotel
(
    hotel_id         varchar(36),
    payment_provider varchar(100) NOT NULL,
    payment_acc      varchar(35)  NOT NULL,
    PRIMARY KEY (payment_provider, payment_acc)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS bills
(
    id                    varchar(36)           DEFAULT (uuid()),
    booking_id            varchar(36),
    admin_id              varchar(36),
    expected_payment_type varchar(10)  NOT NULL,
    `timestamp`           timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount                int unsigned NOT NULL,
    `status`              varchar(10)  NOT NULL DEFAULT 'PENDING',
    PRIMARY KEY (id),
    CHECK ( id REGEXP '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' ),
    CHECK ( expected_payment_type IN ('CASH', 'CREDIT') ),
    CHECK ( `status` IN ('PENDING', 'PAID', 'EXPIRED') )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS hotel_phone
(
    hotel_id     varchar(36),
    phone_number varchar(10) NOT NULL,
    PRIMARY KEY (hotel_id, phone_number),
    CHECK ( phone_number REGEXP '^0[0-9]{9}$' )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS hotel_timing
(
    hotel_id varchar(36),
    `open`   time NOT NULL,
    `close`  time NOT NULL,
    PRIMARY KEY (hotel_id, `open`, `close`),
    CHECK ( `open` < `close` )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS booking_revision
(
    booking_id  varchar(36),
    admin_id    varchar(36),
    `timestamp` timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status`    varchar(10) NOT NULL DEFAULT 'PENDING',
    PRIMARY KEY (booking_id, admin_id),
    CHECK ( `status` IN ('PENDING', 'APPROVED', 'REJECTED') )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS payment
(
    booking_id          varchar(36),
    cid                 varchar(36),
    actual_payment_type varchar(10) NOT NULL,
    payment_date        timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id),
    CHECK ( actual_payment_type IN ('CASH', 'CREDIT') )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
