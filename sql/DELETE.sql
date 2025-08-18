DELETE FROM reservations_details;
DELETE FROM reservations;
DELETE FROM flight_promotions;
DELETE FROM flight_reservation;
DELETE FROM unbooked_promotional_seats;

/*------------------------------------------------------*/

DELETE FROM unbooked_promotional_seats;
DELETE FROM reservations_details;
DELETE FROM flight_promotions;
DELETE FROM flight_prices;
DELETE FROM flight_reservation;
DELETE FROM seat_configurations;
DELETE FROM percentage_discount;

DELETE FROM reservations;
DELETE FROM flights;

DELETE FROM clients;
DELETE FROM planes;
DELETE FROM cities;
DELETE FROM categorie_age;
DELETE FROM admins;

/*------------------------------------------------------*/
/*------------------------------------------------------*/
/*------------------------------------------------------*/
/*------------------------------------------------------*/


INSERT INTO admins
(id, email, password_hash)
VALUES(1, 'admin@gmail.com', 'admin');

INSERT INTO clients
(id, "name", email, password_hash, passport_image)
VALUES(1, 'Client 1', 'client1@gmail.com', 'client1', NULL);


-- avion

INSERT INTO planes
(id, model_name, fabrication_date)
VALUES(1, 'Air Madagascar', '2010-01-01');


INSERT INTO planes
(id, model_name, fabrication_date)
VALUES(2, 'Air France', '2010-01-01');



-- city
INSERT INTO cities
(id, city_name, country)
VALUES(1, 'Tana', 'TNR');

INSERT INTO cities
(id, city_name, country)
VALUES(2, 'Paris CDG', 'PRS');

INSERT INTO cities
(id, city_name, country)
VALUES(3, 'Mauritius', 'MAUR');

INSERT INTO cities
(id, city_name, country)
VALUES(4, 'Addis Abeba', 'ADD');

-- categorie age
INSERT INTO categorie_age
(id, "label")
VALUES(1, 'Child');
INSERT INTO categorie_age
(id, "label")
VALUES(2, 'Ado');
INSERT INTO categorie_age
(id, "label")
VALUES(3, 'Adulte');

-- seat config
INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(1, 1, 'Economy', 100);
INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(2, 1, 'Business', 100);
INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(3, 1, 'First Class', 100);

INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(4, 2, 'Economy', 100);
INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(5, 2, 'Business', 100);
INSERT INTO seat_configurations
(id, id_plane, category, number_of_seats)
VALUES(6, 2, 'First Class', 100);


-- vol
INSERT INTO flights
(id, flight_number, id_plane, id_origin_city, id_destination_city, departure_time, arrival_time, reservation_deadline_hours, cancellation_deadline_hours)
VALUES(1, 'FL1001', 1, 1, 4, '2025-08-31 08:00:00.000', '2025-09-01 08:00:00.000', 2, 24);


INSERT INTO flights
(id, flight_number, id_plane, id_origin_city, id_destination_city, departure_time, arrival_time, reservation_deadline_hours, cancellation_deadline_hours)
VALUES(2, 'FL1002', 2, 2, 3, '2025-09-03 08:00:00.000', '2025-09-04 09:00:00.000', 2, 24);






INSERT INTO reservations
(id, id_client, id_flight, reservation_time, nbr_billet_total, nbr_billet_enfant, nbr_billet_adulte, payment_status, payment_time)
VALUES(59, 1, 1, '2025-08-22 01:00:00.000', 1, 0, 1, 'paid', '2025-08-18 13:59:00.924');


INSERT INTO reservations_details
(id, id_reservation, seat_category, name_voyageur, dtn_voyageur, passport_image, price, is_promotional, is_cancel, cancellation_time, cancellation_reason)
VALUES(50, 59, 'Economy', 'Tommy', '2000-08-18', 'uploads/84ca7819-84b0-45a1-85fa-6deddcbbd325_bici_log.jpeg', 300.00, false, false, NULL, NULL);