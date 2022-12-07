USE HotelBooking;
--
-- DROP INDEX idx_admin ON admins;

SELECT cluster_no, COUNT(admin_id) AS count_admin_id
FROM admins
GROUP BY cluster_no;

EXPLAIN
SELECT cluster_no, COUNT(admin_id) AS count_admin_id
FROM admins
GROUP BY cluster_no;
--
CREATE INDEX idx_admin ON admins (admin_id, cluster_no);

SELECT cluster_no, COUNT(admin_id) AS count_admin_id
FROM admins
GROUP BY cluster_no;

EXPLAIN
SELECT cluster_no, COUNT(admin_id) AS count_admin_id
FROM admins
GROUP BY cluster_no;