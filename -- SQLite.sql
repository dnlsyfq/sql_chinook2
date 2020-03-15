-- SQLite

-- messy query
-- select ta.artist_name artist, count(*) tracks_sold from invoice_line il
-- inner join (select t.track_id, ar.name artist_name from track t
-- inner join album al on al.album_id = t.album_id
-- inner join artist ar on ar.artist_id = al.artist_id) ta
-- on ta.track_id = il.track_id group by 1 order by 2 desc limit 10;

-- organized query
-- SELECT
--     ta.artist_name artist,
--     COUNT(*) tracks_sold
-- FROM invoice_line il
-- INNER JOIN (
--             SELECT
--                 t.track_id,
--                 ar.name artist_name
--             FROM track t
--             INNER JOIN album al ON al.album_id = t.album_id
--             INNER JOIN artist ar ON ar.artist_id = al.artist_id
--            ) ta
--            ON ta.track_id = il.track_id
-- GROUP BY 1
-- ORDER BY 2 DESC LIMIT 10;

-- PG 3
-- WITH playtrack AS (SELECT 
--     playlist.playlist_id,
--     playlist.name playlist_name,
--     track.name track_name,
--     (track.milliseconds/1000) seconds 
-- FROM playlist
-- LEFT JOIN playlist_track ON playlist.playlist_id =  playlist_track.playlist_id
-- LEFT JOIN track ON track.track_id = playlist_track.track_id)

-- SELECT 
--     playlist_id,
--     playlist_name,
--     COUNT(track_name) number_of_tracks,
--     SUM(seconds) length_seconds
-- FROM playtrack
-- GROUP BY 1,2
-- ORDER BY 1;

--4


-- DROP VIEW customer_gt_90_dollars;

-- CREATE VIEW customer_gt_90_dollars AS 
-- SELECT  
--     customer.* ,
--     SUM(invoice.total) AS total
-- FROM customer 
-- INNER JOIN invoice ON customer.customer_id = invoice.customer_id
-- GROUP BY 1
-- HAVING SUM(invoice.total) > 90;

-- SELECT * FROM customer_gt_90_dollars;

--5



-- WITH customers_usa_gt_90 AS (
-- SELECT 
-- customer.* ,
-- SUM(invoice.total) total
-- FROM customer 
-- INNER JOIN invoice ON customer.customer_id = invoice.customer_id
-- WHERE customer.country = 'USA'
-- GROUP BY customer.customer_id
-- HAVING SUM(invoice.total) > 90)

-- SELECT 
--     employee.first_name || " " || employee.last_name AS employee_name,
--     COUNT(customers_usa_gt_90.support_rep_id),
--     employee.title
-- FROM employee 
-- LEFT JOIN customers_usa_gt_90 ON employee.employee_id = customers_usa_gt_90.support_rep_id
-- WHERE employee.title = 'Sales Support Agent'
-- GROUP BY employee_name
-- ORDER BY employee_name;

-- 6

-- WITH cust_india AS (
--         SELECT * FROM customer WHERE country = 'India'
--     ),
--     cust_sum AS (
--         SELECT cust_india.* ,
--             SUM(invoice.total) as total_purchase
--         FROM cust_india INNER JOIN invoice
--         ON cust_india.customer_id = invoice.customer_id 
--         GROUP BY 1
--     )

-- SELECT 
--     first_name || " " || last_name as customer_name,
--     total_purchase
-- FROM cust_sum
-- ORDER BY customer_name ASC;

--8
--  customer from each country that has spent the most money at our store. 

-- WITH invoice_sum AS (SELECT 
--     customer_id,
--     billing_country,
--     SUM(total) total
-- FROM invoice
-- GROUP BY 2),
--     max_sum AS (SELECT 
--     billing_country, 
--     MAX(total) max_total
--     FROM invoice_sum
--     GROUP BY billing_country
--     ),
--     cust_max AS (SELECT 
--        invoice_sum.customer_id, 
--        invoice_sum.billing_country,
--        max_sum.max_total
--     FROM invoice_sum 
--     INNER JOIN max_sum ON invoice_sum.billing_country = max_sum.billing_country
--     )

-- SELECT
--     customer.country,
--     customer.first_name || " " || customer.last_name customer_name,
--     cust_max.max_total total_purchased
-- FROM customer
-- INNER JOIN cust_max ON customer.customer_id = cust_max.customer_id;

